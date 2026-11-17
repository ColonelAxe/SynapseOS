// All state mutations are server-authoritative. Never trust sender identity in payload.
if (!isServer) exitWith {};
params [["_unit",objNull,[objNull]],["_type","",[""]],["_payload",[],[[]]],["_terminal",objNull,[objNull]]];
if (isNull _unit || {owner _unit != remoteExecutedOwner} || {!isPlayer _unit} || {!([_unit,_terminal] call SICS_fnc_access)}) exitWith {};
private _ATLAS_serverDispatch=true;
private _owner = owner _unit;
if (_type find "OPS_"==0) exitWith {[_unit,_type select [4],_payload,_terminal] call SICS_fnc_operationsServer;{[_x] call SICS_fnc_operationsSync} forEach allPlayers};
if (_type in ["PHOTO_BEGIN","PHOTO_CHUNK","PHOTO_GET"]) exitWith {[_unit,_type,_payload] call SICS_fnc_photoServer};
private _side = side group _unit;
private _audience = allPlayers select {side group _x == _side};
private _deliver = {
    params ["_record"];
    {if ([_x,_record] call SICS_fnc_recordAccess) then {["RECORD",_record] remoteExecCall ["SICS_fnc_receive",owner _x]}} forEach _audience;
};
private _last = SICS_rate getOrDefault [str _owner,-10];
if (serverTime-_last < 1) exitWith {["NOTICE","Please wait one second between transmissions."] remoteExecCall ["SICS_fnc_receive",_owner]};
SICS_rate set [str _owner,serverTime];
if (_type=="SYNC") exitWith {
    [_unit,true] call SICS_fnc_channelSync;
    ["MARKERS",(values SICS_markers) select {(_x select 1)==_side}] remoteExecCall ["SICS_fnc_receive",_owner];
};
if (_type in ["CHANNEL_CREATE","CHANNEL_UPDATE","CHANNEL_DELETE"]) exitWith {[_unit,_type,_payload] call SICS_fnc_channelServer};
if (_type in ["MARKER","MARKER_DELETE","LINE"]) exitWith {[_unit,_type,_payload,_terminal] call SICS_fnc_markerServer};
if (_type=="PROFILE") exitWith {
    private _profile=[_payload] call SICS_fnc_profileValidate;
    if (_profile isEqualTo []) exitWith {["NOTICE","Profile rejected: invalid callsign, role or display rank."] remoteExecCall ["SICS_fnc_receive",_owner]};
    _unit setVariable ["ATLAS_profile",_profile,true];
    ["PROFILE",_profile] remoteExecCall ["SICS_fnc_receive",_owner];
    {[_x,true] call SICS_fnc_channelSync} forEach _audience;
};
if (_type=="CALLSIGN") exitWith {
    if (leader group _unit != _unit) exitWith {["NOTICE","Only the group leader can change its callsign."] remoteExecCall ["SICS_fnc_receive",_owner]};
    private _name=_payload param [0,"",[""]];
    if (count _name < 1 || {count _name > 24}) exitWith {};
    group _unit setGroupIdGlobal [_name];
    ["NOTICE","Callsign updated."] remoteExecCall ["SICS_fnc_receive",_owner];
};
if (_type=="ACK") exitWith {
    private _id=_payload param [0,-1,[0]];
    private _idx=SICS_records findIf {(_x select 0)==_id && {(_x select 1)==_side} && {(_x select 2)=="C2"} && {(_x select 7)=="" || {(_x select 7)==netId group _unit}}};
    if (_idx < 0) exitWith {};
    private _r=+(SICS_records select _idx);
    if ((_r param [13,["ISSUED"]]) select 0 in ["CANCELLED","COMPLETED"]) exitWith {};
    private _acks=+(_r select 10); _acks pushBackUnique groupId group _unit;
    _r set [10,_acks]; _r set [8,format ["ACK: %1",_acks joinString ", "]];
    SICS_records set [_idx,_r]; [_r] call _deliver;
    [_unit,"ORDER_STATE",[_id,"ACKNOWLEDGED"],_terminal] call SICS_fnc_operationsServer;
};
if !(_type in ["MESSAGES","C2","REPORTS"]) exitWith {};
if (_type=="C2" && {leader group _unit != _unit} && {!(_unit getVariable ["ATLAS_commander",_unit getVariable ["SICS_commander",false]])}) exitWith {["NOTICE","Orders require group leader or mission-assigned commander access."] remoteExecCall ["SICS_fnc_receive",_owner]};
if (_type=="C2" && {["assignedCommandOnly",false] call SICS_fnc_policy} && {!(_unit getVariable ["ATLAS_commander",_unit getVariable ["SICS_commander",false]])}) exitWith {};
private _text=_payload param [0,"",[""]];
private _priority=_payload param [1,"ROUTINE",[""]];
private _target=_payload param [2,"",[""]];
private _pos=_payload param [3,[],[[]]];
private _contact=_payload param [4,[],[[]]];
if (count _text < 1 || {count _text > 1000} || {!(_priority in ["ROUTINE","PRIORITY","IMMEDIATE"])} || {count _pos < 2} || {count _pos > 3} || {_pos findIf {!(_x isEqualType 0) || {!finite _x}} >= 0}) exitWith {};
private _custom=_target find "CH:"==0;
if (_custom && {_type!="MESSAGES" || {!([_unit,SICS_channels getOrDefault [_target,[]]] call SICS_fnc_channelAccess)}}) exitWith {["NOTICE","You do not have access to this channel."] remoteExecCall ["SICS_fnc_receive",_owner]};
if (_target!="" && {!_custom} && {allGroups findIf {netId _x==_target && {side _x==_side}} < 0}) exitWith {};
if (_contact isNotEqualTo []) then {
    if (_type!="REPORTS" || {!(count _contact in [3,5])} || {!((_contact select [0,3]) isEqualTypeAll "")}) exitWith {_contact=["INVALID"]};
    if (count _contact==5) then {
        private _designation=_contact select 3;private _strength=_contact select 4;
        if (!(_designation isEqualType "") || {!(_strength isEqualType 0)}) exitWith {_contact=["INVALID"]};
        if (count trim _designation<1 || {count _designation>48} || {!finite _strength} || {_strength<1} || {_strength>9999} || {_strength!=floor _strength}) then {_contact=["INVALID"]};
    };
    if (_contact isEqualTo ["INVALID"]) exitWith {};
    _contact params ["_aff","_symbol","_category"];
    if (!(_aff in ["BLUFOR","OPFOR","UNKNOWN","INDEPENDENT","CIVILIAN"]) || {([_aff] call SICS_fnc_natoCatalog) findIf {configName _x==_symbol}<0} || {!(_category in ["Unknown","Infantry","Motorized","Wheeled vehicle","Armoured vehicle","Helicopter","Fixed-wing aircraft","UAV","Naval","Station / installation","Artillery","Logistics","Medical"])}) then {_contact=["INVALID"]};
};
if (_contact isEqualTo ["INVALID"]) exitWith {["NOTICE","Contact report rejected: invalid affiliation, symbol or type."] remoteExecCall ["SICS_fnc_receive",_owner]};
private _photos=_payload param [5,[],[[]]];
private _observation=_payload param [6,["SUSPECTED",0,(["contactTTL",1800] call SICS_fnc_policy)/60,0],[[]]];
if (_contact isNotEqualTo [] && {count _observation!=4 || {!((_observation select 0) in ["SUSPECTED","OBSERVED","CONFIRMED"])} || {(_observation select [1,3]) findIf {!(_x isEqualType 0) || {!finite _x}}>=0} || {_observation select 1<0} || {_observation select 1>86400} || {_observation select 2<1} || {_observation select 2>1440} || {_observation select 3<0} || {_observation select 3>359}}) exitWith {};
if (count _photos>1 || {_photos isNotEqualTo [] && {!(_photos isEqualTypeAll "") || {_type!="REPORTS"}}}) exitWith {};
if (_photos findIf {private _p=ATLAS_serverPhotos getOrDefault [_x,[]];_p isEqualTo [] || {_p select 0!=_side} || {_p select 1!=getPlayerUID _unit} || {_p select 8!="READY"}}>=0) exitWith {["NOTICE","Report photo is not ready or does not belong to you."] remoteExecCall ["SICS_fnc_receive",_owner]};
SICS_sequence=SICS_sequence+1;
private _record=[SICS_sequence,_side,_type,format ["%1 / %2",groupId group _unit,_priority],_text,_pos,serverTime,_target,"TRANSMITTED",getPlayerUID _unit,[],_contact,_photos];
if (_type=="C2") then {private _recipients=if (_target!="") then {[_target]} else {(allPlayers select {side group _x==_side}) apply {netId group _x}};_record pushBack ["ISSUED",-1,[],_recipients arrayIntersect _recipients]};
if (_contact isNotEqualTo []) then {_record pushBack [_observation select 0,serverTime-(_observation select 1),serverTime+60*(_observation select 2),_observation select 3];[_unit,_record,_observation] call SICS_fnc_operationsContact};
SICS_records pushBack _record;
if (count SICS_records > 300) then {SICS_records deleteAt 0};
[_record] call _deliver;
if (_type in ["C2","REPORTS"] && {_contact isEqualTo []}) then {[_unit,_type,"ISSUED",str (_record select 0),(_text select [0,100]),_target,getPlayerUID _unit,_pos] call SICS_fnc_operationsJournal};
{["PHOTO_ATTACHED",_x] remoteExecCall ["SICS_fnc_receive",_owner]} forEach _photos;
["NOTICE","Transmission accepted by server."] remoteExecCall ["SICS_fnc_receive",_owner];


