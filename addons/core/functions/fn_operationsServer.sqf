// Dispatcher has already verified remote owner, player identity and device access.
params [["_unit",objNull,[objNull]],["_action","",[""]],["_payload",[],[[]]],["_terminal",objNull,[objNull]]];
if (!isServer) exitWith {};
if (isNull _unit || {isRemoteExecuted && {owner _unit!=remoteExecutedOwner || {!isPlayer _unit} || {!([_unit,_terminal] call SICS_fnc_access)}}}) exitWith {};
private _ATLAS_serverDispatch=true;
if (!(_action in ["UPSERT","DELETE","STATE","ORDER_STATE","ORDER_DUE","BRIEF"]) || {count _payload>9}) exitWith {};
private _owner=owner _unit;private _uid=getPlayerUID _unit;private _side=side group _unit;
private _notice={params ["_text"];["NOTICE",_text] remoteExecCall ["SICS_fnc_receive",_owner]};
private _command=_unit getVariable ["ATLAS_commander",_unit getVariable ["SICS_commander",false]];
private _leader=leader group _unit==_unit;
private _canCommand=_command || {_leader && {!( ["assignedCommandOnly",false] call SICS_fnc_policy )}};
private _rateKey=str _owner+"/"+_action;
if (serverTime-(ATLAS_operationsRate getOrDefault [_rateKey,-10])<0.3) exitWith {["Please wait before the next operation update."] call _notice};
ATLAS_operationsRate set [_rateKey,serverTime];
private _deliverRecord={params ["_record"];{if ([_x,_record] call SICS_fnc_recordAccess) then {["RECORD",_record] remoteExecCall ["SICS_fnc_receive",owner _x]}} forEach allPlayers};
if (_action in ["ORDER_STATE","ORDER_DUE"]) exitWith {
    private _id=_payload param [0,-1,[0]];private _i=SICS_records findIf {(_x select 0)==_id && {(_x select 2)=="C2"} && {[_unit,_x] call SICS_fnc_recordAccess}};
    if (_i<0) exitWith {["Order is no longer available."] call _notice};
    private _r=+(SICS_records select _i);private _life=+(_r param [13,["ISSUED",-1,[]]]);
    private _issuer=(_r select 9)==_uid || {_command};
    if ((_life select 0) in ["CANCELLED","COMPLETED"]) exitWith {["This order is already closed."] call _notice};
    if (_action=="ORDER_DUE") exitWith {
        private _minutes=_payload param [1,-1,[0]];
        if (!_issuer || {!finite _minutes} || {_minutes<0} || {_minutes>1440}) exitWith {["Only the issuer can set a deadline of 0–1440 minutes."] call _notice};
        _life set [1,[-1,serverTime+60*_minutes] select (_minutes>0)];_r set [13,_life];SICS_records set [_i,_r];[_r] call _deliverRecord;
        [_unit,"ORDER","DEADLINE",str _id,_r select 4,_r select 7,_r select 9,_r select 5] call SICS_fnc_operationsJournal;
    };
    private _state=_payload param [1,"",[""]];
    if !(_state in ["RECEIVED","ACKNOWLEDGED","EXECUTING","COMPLETED","CANCELLED"]) exitWith {};
    if (_state=="CANCELLED" && {!_issuer}) exitWith {["Only the issuer or commander can cancel an order."] call _notice};
    if (_state!="CANCELLED" && {(!_leader && {!_command} && {_state!="RECEIVED"}) || {(_r select 7)!="" && {(_r select 7)!=netId group _unit}}}) exitWith {["Only the recipient group may progress this order."] call _notice};
    private _states=+(_life select 2);private _group=netId group _unit;private _j=_states findIf {(_x select 0)==_group};
    private _before=if (_j<0) then {"ISSUED"} else {(_states select _j) select 1};
    private _sequence=["ISSUED","RECEIVED","ACKNOWLEDGED","EXECUTING","COMPLETED"];
    if (_state!="CANCELLED" && {(_sequence find _state)<=(_sequence find _before) || {_state=="COMPLETED" && {_before!="EXECUTING"}}}) exitWith {["Order state cannot move backwards or complete before execution."] call _notice};
    if (_state=="CANCELLED") then {_life set [0,"CANCELLED"]} else {
        private _entry=[_group,_state,serverTime,groupId group _unit];if (_j<0) then {_states pushBack _entry} else {_states set [_j,_entry]};_life set [2,_states];
        if (_state in ["ACKNOWLEDGED","EXECUTING","COMPLETED"]) then {private _acks=+(_r select 10);_acks pushBackUnique groupId group _unit;_r set [10,_acks]};
        private _expected=_life param [3,if ((_r select 7)=="") then {[]} else {[_r select 7]}];
        if (_expected isNotEqualTo [] && {_expected findIf {private _g=_x;_states findIf {(_x select 0)==_g && {_x select 1=="COMPLETED"}}<0}<0}) then {_life set [0,"COMPLETED"]};
    };
    _r set [13,_life];_r set [8,format ["%1 / %2",groupId group _unit,_state]];SICS_records set [_i,_r];[_r] call _deliverRecord;
    [_unit,"ORDER",_state,str _id,_r select 4,_r select 7,_r select 9,_r select 5] call SICS_fnc_operationsJournal;
};
if (_action=="BRIEF") exitWith {
    _payload params [["_screenId","",[""]],["_plan","",[""]],["_focus","",[""]],["_scale",0.1,[0]]];
    private _screen=objectFromNetId _screenId;private _p=ATLAS_operations getOrDefault [_plan,[]];private _f=ATLAS_operations getOrDefault [_focus,[]];
    private _canReach = if (_screen getVariable ["ATLAS_managedBriefing",false]) then {
        !isNull _terminal && {alive _terminal} && {_unit distance _terminal<=5} &&
            {_screen getVariable ["ATLAS_tocMaster",objNull]==_terminal} &&
            {(_screen getVariable ["ATLAS_tocFeed",[]]) param [3,""]=="MAP"}
    } else {_unit distance _screen<=5};
    if (!_canCommand || {isNull _screen} || {!alive _screen} || {!_canReach} || {_screen getVariable ["ATLAS_briefSide",sideUnknown]!=_side} || {_p isEqualTo []} || {(_p select 2)!="PLAN"} || {(_p select 7)!="PUBLISHED"} || {!([_unit,_p] call SICS_fnc_operationsAccess)} || {!finite _scale} || {_scale<0.001} || {_scale>1}) exitWith {["Briefing needs a nearby TOC master or standalone screen and a published same-side overlay."] call _notice};
    if (_focus!="" && {_f isEqualTo [] || {!([_unit,_f] call SICS_fnc_operationsAccess)} || {(_f select 6)!=""} || {(_f select 2)!="GRAPHIC"} || {(createHashMapFromArray (_f select 10)) getOrDefault ["plan",""]!=_plan}}) exitWith {["Only a side-shared graphic from this overlay may be highlighted on a room screen."] call _notice};
    _screen setVariable ["ATLAS_briefing",[_side,_plan,_focus,_scale],true];
    [_unit,"BRIEFING","PUBLISHED",_plan,_p select 3,"","",getPosASL _screen] call SICS_fnc_operationsJournal;
};
if !(_action in ["UPSERT","DELETE","STATE"]) exitWith {};
private _id=_payload param [0,"",[""]];private _revision=_payload param [1,0,[0]];
if (!finite _revision || {_revision<0} || {_revision>1000000000} || {_revision!=floor _revision} || {_id=="" && {_revision!=0}}) exitWith {};
private _old=ATLAS_operations getOrDefault [_id,[]];
if (_action in ["DELETE","STATE"] && {_old isEqualTo []}) exitWith {["Select an existing operation first."] call _notice};
if (_id!="" && {_old isEqualTo [] || {!([_unit,_old] call SICS_fnc_operationsAccess)}}) exitWith {["Operation is no longer available."] call _notice};
if (_old isNotEqualTo [] && {_revision!=(_old select 13)}) exitWith {["This item changed. Refresh/select it again before editing."] call _notice};
private _kind=if (_old isEqualTo []) then {_payload param [2,"",[""]]} else {_old select 2};
private _owns=_old isEqualTo [] || {(_old select 4)==_uid} || {_command};
if (_kind in ["PLAN","GRAPHIC","AIR_TASK"] && {!_canCommand}) exitWith {["This action requires mission command permission or a group leader."] call _notice};
if (_kind in ["PLAN","GRAPHIC"] && {!( ["overlays",true] call SICS_fnc_policy )}) exitWith {["Operational overlays are disabled by the mission."] call _notice};
if (_kind in ["SUPPORT","LZ","AIR_TASK"] && {!( ["support",true] call SICS_fnc_policy )}) exitWith {["Support coordination is disabled by the mission."] call _notice};
if (_action=="DELETE") exitWith {
    if (!_owns) exitWith {["Only the creator or commander can delete this item."] call _notice};
    if (_kind=="CONTACT") exitWith {private _entry=+_old;_entry set [7,"RESOLVED"];_entry set [12,serverTime];_entry set [13,_revision+1];ATLAS_operations set [_id,_entry];[_unit,_kind,"RESOLVED",_id,_old select 3,_old select 6,_old select 4,_old select 8] call SICS_fnc_operationsJournal};
    if (_kind=="PLAN" && {(values ATLAS_operations) findIf {(_x select 2)=="GRAPHIC" && {(createHashMapFromArray (_x select 10)) getOrDefault ["plan",""]==_id}}>=0}) exitWith {["Remove the overlay's graphics before deleting it."] call _notice};
    ATLAS_operations deleteAt _id;
    [_unit,_kind,"DELETED",_id,_old select 3,_old select 6,_old select 4,_old select 8] call SICS_fnc_operationsJournal;
};
if (_action=="STATE") exitWith {
    private _state=_payload param [2,"",[""]];private _entry=+_old;private _data=createHashMapFromArray (_entry select 10);
    private _allowed=false;
    if (_kind=="CONTACT") then {_allowed=_state in ["ACTIVE","RESOLVED"]};
    if (_kind in ["SUPPORT","AIR_TASK"]) then {
        private _current=_entry select 7;private _claimed=_data getOrDefault ["acceptedGroup",""];
        if (_state=="ACCEPTED" && {_current=="REQUESTED"} && {_leader || {_command}}) then {
            private _aircraft=objectFromNetId (_data getOrDefault ["aircraft",""]);
            _allowed=_kind!="AIR_TASK" || {!isNull _aircraft && {(crew _aircraft) findIf {group _x==group _unit}>=0}};
            if (_allowed) then {_data set ["acceptedGroup",netId group _unit];_data set ["acceptedCallsign",groupId group _unit]};
        };
        if (_state=="EXECUTING" && {_current=="ACCEPTED"} || {_state=="COMPLETED" && {_current=="EXECUTING"}}) then {_allowed=(_claimed==netId group _unit && {_leader}) || {_command}};
        if (_state=="CANCELLED") then {_allowed=_owns};
    };
    if (!_allowed) exitWith {["This state transition is not permitted for your group."] call _notice};
    _entry set [7,_state];_entry set [10,(keys _data) apply {[_x,_data get _x]}];_entry set [12,serverTime];_entry set [13,_revision+1];ATLAS_operations set [_id,_entry];
    [_unit,_kind,_state,_id,_entry select 3,_entry select 6,_entry select 4,_entry select 8] call SICS_fnc_operationsJournal;
};
if (!_owns && {_kind!="CONTACT"}) exitWith {["Only the creator or commander may edit these instructions."] call _notice};
private _title=_payload param [3,"",[""]];private _target=_payload param [4,"",[""]];private _position=_payload param [5,[],[[]]];private _points=_payload param [6,[],[[]]];private _pairs=_payload param [7,[],[[]]];
if (_kind=="CONTACT" && {_old isNotEqualTo []} && {_target!=(_old select 6)} && {!_owns}) exitWith {["Only the author or commander may change a contact's audience."] call _notice};
private _result=[_unit,_kind,_title,_target,_position,_points,_pairs] call SICS_fnc_operationsValidate;
if !(_result select 0) exitWith {[_result select 1] call _notice};
private _data=createHashMapFromArray (_result select 2);private _status="ACTIVE";
if (_kind=="PLAN") then {_status=_data get "publication";_target=""};
if (_kind=="AIR_TASK") then {
    private _aircraft=objectFromNetId (_data get "aircraft");private _recipient=effectiveCommander _aircraft;
    _target=netId group _recipient;
    {
        private _ref=_data get _x;
        if (_ref!="" && {!([_recipient,ATLAS_operations getOrDefault [_ref,[]]] call SICS_fnc_operationsAccess)}) then {_status="!REFERENCE"};
    } forEach ["lz","ingress","egress"];
};
if (_status=="!REFERENCE") exitWith {["The aircraft crew cannot access a referenced LZ/route. Publish/share it with that group first."] call _notice};
if (_kind=="LZ") then {_status=_data get "availability"};
if (_kind in ["SUPPORT","AIR_TASK"]) then {_status="REQUESTED";if (_old isNotEqualTo [] && {(_old select 7)!="REQUESTED"}) exitWith {_status="!LOCKED"}};
if (_status=="!LOCKED") exitWith {["Cancel a claimed request instead of changing its assignment."] call _notice};
if (_kind=="GRAPHIC") then {
    private _p=ATLAS_operations getOrDefault [_data get "plan",[]];
    if (_p isEqualTo [] || {(_p select 4)!=_uid && {!_command}}) then {_status="!LOCKED"};
};
if (_status=="!LOCKED") exitWith {["Only the overlay's author or commander may add graphics to it."] call _notice};
if (_old isEqualTo [] && {count ATLAS_operations>=512}) exitWith {["Mission operation capacity reached (512 items). Remove obsolete items first."] call _notice};
private _record=[];
if (_kind=="CONTACT") then {
    private _recordId=if (_old isEqualTo []) then {-1} else {(createHashMapFromArray (_old select 10)) getOrDefault ["record",-1]};
    private _text=format ["%1 / %2 / %3 / STRENGTH %4 / %5",_title,_data get "affiliation",_data get "category",_data get "strength",_data get "notes"];
    private _meta=[_data get "affiliation",_data get "symbol",_data get "category",_title,_data get "strength"];
    private _photo=_data get "photo";private _photos=[[],[_photo]] select (_photo!="");
    if (_recordId<0) then {SICS_sequence=SICS_sequence+1;_recordId=SICS_sequence};
    _record=[_recordId,_side,"REPORTS",groupId group _unit+" / CONTACT",_text,_position,serverTime,_target,"UPDATED",_old param [4,_uid],[],_meta,_photos,[_data get "confidence",serverTime-(_data get "age"),serverTime+60*(_data get "ttl"),_data get "heading"]];
    private _ri=SICS_records findIf {(_x select 0)==_recordId};if (_ri<0) then {SICS_records pushBack _record} else {SICS_records set [_ri,_record]};if (count SICS_records>300) then {SICS_records deleteAt 0};
    if (_old isEqualTo []) then {_id="CONTACT:"+str _recordId};
    _data set ["record",_recordId];_data set ["observed",serverTime-(_data get "age")];_data set ["expires",serverTime+60*(_data get "ttl")];
    [_record] call _deliverRecord;
    if (_photo!="") then {["PHOTO_ATTACHED",_photo] remoteExecCall ["SICS_fnc_receive",_owner]};
};
if (_kind=="LZ" && {_data get "photo"!=""}) then {
    private _photo=_data get "photo";private _recordId=if (_old isEqualTo []) then {-1} else {(createHashMapFromArray (_old select 10)) getOrDefault ["record",-1]};
    if (_recordId<0) then {SICS_sequence=SICS_sequence+1;_recordId=SICS_sequence};
    private _r=[_recordId,_side,"REPORTS",groupId group _unit+" / LZ",format ["%1 / %2 / %3",_title,_status,_data get "notes"],_position,serverTime,_target,"TRANSMITTED",_old param [4,_uid],[],[],[_photo]];
    private _index=SICS_records findIf {(_x select 0)==_recordId};if (_index<0) then {SICS_records pushBack _r} else {SICS_records set [_index,_r]};if (count SICS_records>300) then {SICS_records deleteAt 0};
    _data set ["record",_recordId];[_r] call _deliverRecord;["PHOTO_ATTACHED",_photo] remoteExecCall ["SICS_fnc_receive",_owner];
};
if (_id=="") then {ATLAS_operationsSequence=ATLAS_operationsSequence+1;_id="OP:"+str ATLAS_operationsSequence};
private _entry=[_id,_side,_kind,trim _title,[_uid,_old param [4,_uid]] select (_old isNotEqualTo []),([_unit] call SICS_fnc_profile) select 0,_target,_status,_position,_points,(keys _data) apply {[_x,_data get _x]},_old param [11,serverTime],serverTime,_revision+1];
ATLAS_operations set [_id,_entry];
[_unit,_kind,["CREATED","UPDATED"] select (_old isNotEqualTo []),_id,_entry select 3,_target,_entry select 4,_position] call SICS_fnc_operationsJournal;
private _token=_payload param [8,0,[0]];
["OPERATION_SAVED",[_id,_token]] remoteExecCall ["SICS_fnc_receive",_owner];
