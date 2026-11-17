if (!hasInterface || {isMultiplayer && {remoteExecutedOwner != 2}}) exitWith {};
params ["_kind","_data"];
if (_kind=="TRACK_SNAPSHOT") exitWith {
    private _allowed=((missionNamespace getVariable ["cTabBFTgroups",[]])+(missionNamespace getVariable ["cTabBFTvehicles",[]])+(missionNamespace getVariable ["cTabBFTmembers",[]])) apply {netId (_x select 0)};
    {if ((_x select 0) in _allowed) then {ATLAS_networkTracks set [_x select 0,_x]}} forEach _data;
    {if !(_x in _allowed) then {ATLAS_networkTracks deleteAt _x}} forEach keys ATLAS_networkTracks;
};
if (_kind=="OPERATIONS") exitWith {
    _data params ["_entities","_journal","_version"];
    private _changed=_entities select {private _old=ATLAS_clientOperations getOrDefault [_x select 0,[]];((_old isEqualTo []) || {_old select 13!=_x select 13}) && {(_x select 4)!=getPlayerUID player}};
    private _hydrated=missionNamespace getVariable ["ATLAS_operationsHydrated",false];
    ATLAS_clientOperations=createHashMapFromArray (_entities apply {[_x select 0,_x]});ATLAS_clientJournal=_journal;
    ATLAS_operationsHydrated=true;
    SICS_notificationHistory=SICS_notificationHistory select {(_x select 0)!="OPERATION" || {(_x param [4,""]) in ATLAS_clientOperations}};
    if (_hydrated && {_changed isNotEqualTo []}) then {private _e=_changed select 0;["OPERATION",format ["%1 / %2 / %3 update(s)",_e select 2,_e select 3,count _changed],_e select 6,_e select 0] call SICS_fnc_notify};
    if (missionNamespace getVariable ["ATLAS_opsSelected",""]!="" && {!(ATLAS_opsSelected in ATLAS_clientOperations)} && {ATLAS_opsSelected find "ORDER:"!=0} && {ATLAS_opsSelected find "JOURNAL:"!=0}) then {ATLAS_opsSelected=""};
    if (missionNamespace getVariable ["ATLAS_followRoute",""]!="" && {!(ATLAS_followRoute in ATLAS_clientOperations)}) then {ATLAS_followRoute=""};
    {if ((_x param [11,[]]) isNotEqualTo []) then {[_x] call SICS_fnc_contactApply}} forEach (missionNamespace getVariable ["SICS_localRecords",[]]);
    if (!isNull findDisplay 87000 && {missionNamespace getVariable ["SICS_osApp",""]=="OPERATIONS"} && {isNull findDisplay 87003}) then {[] call SICS_fnc_operations};
};
if (_kind=="OPERATION_SAVED") exitWith {private _d=findDisplay 87003;if (!isNull _d && {_d getVariable ["ATLAS_savingToken",-1]==(_data select 1)}) then {ATLAS_opsSelected=_data select 0;ATLAS_opsDraftPoints=[];ATLAS_opsCapture=false;_d closeDisplay 1};["INFO","Operation saved."] call SICS_fnc_notify};
if (_kind find "PHOTO_"==0) exitWith {[_kind,_data] call SICS_fnc_photoReceive};
if (_kind=="PROFILE") exitWith {
    private _profile=[_data] call SICS_fnc_profileValidate;
    if (_profile isEqualTo []) exitWith {};
    profileNamespace setVariable ["ATLAS_profile_"+getPlayerUID player,_profile];saveProfileNamespace;
    (findDisplay 87000 displayCtrl 2012) ctrlSetText "Profile saved. Display rank does not change command permissions.";
    ["INFO","Operator profile saved."] call SICS_fnc_notify;
};
if (_kind=="CHANNEL_EVENT") exitWith {["CHANNEL",_data] call SICS_fnc_notify};
if (_kind=="CHANNEL_DELETED") exitWith {
    if (!isNull findDisplay 87002) then {findDisplay 87002 closeDisplay 1};
    ["INFO",format ["Channel deleted: %1",_data]] call SICS_fnc_notify;
    [] call SICS_fnc_channelUI;
};
if (_kind=="CHANNEL_SAVED") exitWith {
    SICS_chatTarget=if (SICS_clientChannels findIf {(_x select 0)==_data}>=0) then {_data} else {""};if (!isNull findDisplay 87002) then {findDisplay 87002 closeDisplay 1};
    [] call SICS_fnc_channelUI;[] call SICS_fnc_chat;
    ["INFO","Channel settings saved."] call SICS_fnc_notify;
};
if (_kind=="CHANNELS") exitWith {
    _data params ["_channels","_roster","_create"];
    SICS_clientChannels=_channels;SICS_channelRoster=_roster;SICS_canCreateChannel=_create;
    private _ids=_channels apply {_x select 0};
    private _removedUnread=0;
    {if !(_x in _ids) then {_removedUnread=_removedUnread+(SICS_channelUnread get _x);SICS_channelUnread deleteAt _x}} forEach keys SICS_channelUnread;
    SICS_unread set ["MESSAGES",((SICS_unread getOrDefault ["MESSAGES",0])-_removedUnread) max 0];
    SICS_notificationHistory=SICS_notificationHistory select {private _target=_x param [3,""];_target find "CH:"!=0 || {_target in _ids}};
    // Received private photographs must disappear as soon as their channel is revoked.
    {
        private _photoId=_x;private _recordId=ATLAS_photoRecords get _photoId;
        private _record=(missionNamespace getVariable ["SICS_localRecords",[]]) select {(_x select 0)==_recordId};
        if (_record isNotEqualTo [] && {private _target=(_record select 0) select 7;_target find "CH:"==0 && {!(_target in _ids)}}) then {
            "atlas_media" callExtension ["drop",[_photoId]];ATLAS_photoMeta deleteAt _photoId;ATLAS_photoRecords deleteAt _photoId;ATLAS_photoSkip deleteAt _photoId;
            if (ATLAS_cameraSelected==_photoId) then {ATLAS_cameraSelected="";if (missionNamespace getVariable ["SICS_osApp",""]=="CAMERA") then {[] call SICS_fnc_camera}};
        };
    } forEach keys ATLAS_photoRecords;
    if ((missionNamespace getVariable ["SICS_chatTarget",""]) find "CH:"==0 && {!(SICS_chatTarget in _ids)}) then {SICS_chatTarget=""};
    private _editor=findDisplay 87002;
    if (!isNull _editor) then {
        private _editing=_editor getVariable ["SICS_channel",[]];
        if (_editing isNotEqualTo []) then {
            private _current=_channels select {(_x select 0)==(_editing select 0)};
            if (_current isEqualTo [] || {!([player,_current select 0,true] call SICS_fnc_channelAccess)}) then {_editor closeDisplay 2};
        };
    };
    [] call SICS_fnc_channelUI;
    if (missionNamespace getVariable ["SICS_osApp",""]=="NOTIFICATIONS" && {!isNull findDisplay 87000}) then {[] call SICS_fnc_notifications};
};
if (_kind=="NOTICE") exitWith {
    if (_data=="Transmission accepted by server." && {missionNamespace getVariable ["SICS_tab",""]=="MESSAGES"}) then {
        private _edit=findDisplay 87000 displayCtrl 106;
        if (!isNull _edit && {ctrlText _edit==missionNamespace getVariable ["SICS_pendingChatDraft",""]}) then {_edit ctrlSetText ""};
        SICS_pendingChatDraft="";
    } else {hint _data;if (_data!="Transmission accepted by server.") then {["INFO",_data] call SICS_fnc_notify}};
};
if (_kind=="MARKER") exitWith {[_data] call SICS_fnc_markerApply};
if (_kind=="MARKER_DELETE") exitWith {[_data,true] call SICS_fnc_markerApply};
if (_kind=="MARKERS") exitWith {
    {deleteMarkerLocal format ["SICS_SIDE_%1",_x select 0]} forEach values (missionNamespace getVariable ["SICS_clientMarkers",createHashMap]);
    SICS_clientMarkers=createHashMap; {[_x] call SICS_fnc_markerApply} forEach _data;
};
if (_kind=="SYNC") exitWith {
    {deleteMarkerLocal _x} forEach (missionNamespace getVariable ["SICS_contactNames",[]]);SICS_contactNames=[];
    SICS_localRecords=_data select {(_x select 1)==side group player};
    if (isNil "SICS_seenRecords") then {SICS_seenRecords=createHashMap};
    {SICS_seenRecords set [str (_x select 0),true];[_x] call SICS_fnc_contactApply} forEach SICS_localRecords;
    [] call SICS_fnc_feed
};
if (_kind!="RECORD") exitWith {};
if ((_data select 1) != side group player) exitWith {};
if ((_data select 7) find "CH:"==0 && {(missionNamespace getVariable ["SICS_clientChannels",[]]) findIf {(_x select 0)==(_data select 7)}<0}) exitWith {};
if (isNil "SICS_localRecords") then {SICS_localRecords=[]};
private _idx=SICS_localRecords findIf {(_x select 0)==(_data select 0)};
private _old=if (_idx<0) then {[]} else {SICS_localRecords select _idx};
if (isNil "SICS_seenRecords") then {SICS_seenRecords=createHashMap};
private _isNew=!(str (_data select 0) in SICS_seenRecords);
SICS_seenRecords set [str (_data select 0),true];
if (count SICS_seenRecords>600) then {private _ids=(keys SICS_seenRecords) apply {parseNumber _x};_ids sort true;SICS_seenRecords deleteAt str (_ids select 0)};
if (_idx<0) then {SICS_localRecords pushBack _data} else {SICS_localRecords set [_idx,_data]};
if (count SICS_localRecords > 300) then {private _removed=SICS_localRecords deleteAt 0;private _name=format ["SICS_CONTACT_%1",_removed select 0];deleteMarkerLocal _name;SICS_contactNames=(missionNamespace getVariable ["SICS_contactNames",[]])-[_name]};
[_data] call SICS_fnc_contactApply;
if (_isNew && {(_data select 9)!=getPlayerUID player}) then {
    private _kind=switch (_data select 2) do {case "MESSAGES":{"MESSAGE"};case "C2":{"ORDER"};default {["REPORT","CONTACT"] select ((_data param [11,[]]) isNotEqualTo [])}};
    [_kind,format ["%1 / %2",_data select 3,(_data select 4) select [0,100]],_data select 7,_data select 0] call SICS_fnc_notify;
    if ((_data select 2)=="C2" && {(_data select 7)=="" || {(_data select 7)==netId group player}}) then {[player,"OPS_ORDER_STATE",[_data select 0,"RECEIVED"],missionNamespace getVariable ["SICS_terminal",objNull]] remoteExecCall ["SICS_fnc_server",2]};
};
if (_old isNotEqualTo [] && {(_data select 2)=="C2"} && {count (_data select 10)>count (_old select 10)} && {(_data select 9)==getPlayerUID player} && {((_data select 10) select -1)!=groupId group player}) then {["ACK",format ["Order %1 / %2",_data select 0,_data select 8],_data select 7,_data select 0] call SICS_fnc_notify};
[] call SICS_fnc_feed;
if (_old isNotEqualTo [] && {_data select 2=="C2"} && {_data select 9==getPlayerUID player} && {count (_data select 10)==count (_old select 10)} && {!((_old param [13,[]]) isEqualTo (_data param [13,[]]))}) then {["ORDER_UPDATE",format ["Order %1 / %2",_data select 0,_data select 8],_data select 7,_data select 0] call SICS_fnc_notify};

