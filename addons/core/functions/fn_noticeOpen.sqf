private _match=(missionNamespace getVariable ["SICS_notificationHistory",[]]) select {(_x param [6,-1])==missionNamespace getVariable ["ATLAS_noticeSelected",-2]};
if (_match isEqualTo []) exitWith {false};
private _entry=_match select 0;private _target=_entry select 3;
if ((_entry select 0)=="OPERATION") exitWith {
    private _id=_entry param [4,""];private _e=ATLAS_clientOperations getOrDefault [_id,[]];
    if (_e isEqualTo []) exitWith {hint "This operation is no longer available.";false};
    _entry set [5,true];ATLAS_opsSelected=_id;
    ATLAS_opsTab=switch (_e select 2) do {case "CONTACT":{"CONTACTS"};case "SUPPORT":{"SUPPORT"};case "LZ":{"AIR"};case "AIR_TASK":{"AIR"};default {"PLANS"}};
    ["OPERATIONS"] call SICS_fnc_launchApp;true
};
if (_target find "CH:"==0 && {SICS_clientChannels findIf {(_x select 0)==_target}<0}) exitWith {hint "This channel is no longer available.";false};
private _id=_entry param [4,-1];private _record=[];
if (_id>=0) then {_record=SICS_localRecords select {(_x select 0)==_id && {(_x select 1)==side group player}}};
if (_id>=0 && {_record isEqualTo []}) exitWith {hint "This record is no longer available.";false};
private _wasRead=_entry param [5,false];_entry set [5,true];
["ATLAS"] call SICS_fnc_launchApp;
SICS_tab=["OVERVIEW","MESSAGES"] select ((_entry select 0) in ["MESSAGE","CHANNEL"]);
if (!_wasRead && {SICS_tab=="OVERVIEW"}) then {private _bucket=["REPORTS","C2"] select ((_entry select 0) in ["ORDER","ACK","ORDER_UPDATE"]);SICS_unread set [_bucket,((SICS_unread getOrDefault [_bucket,0])-1) max 0]};
if (SICS_tab=="MESSAGES") then {SICS_chatTarget=_target};
SICS_compose=false;[] call SICS_fnc_page;
if (_record isNotEqualTo []) then {
    SICS_selectedPosition=(_record select 0) select 5;
    private _feed=findDisplay 87000 displayCtrl 51;
    for "_i" from 0 to (lbSize _feed-1) do {if (parseNumber (_feed lbData _i)==_id) exitWith {_feed lbSetCurSel _i}};
    private _map=findDisplay 87000 displayCtrl 40;ctrlMapAnimClear _map;_map ctrlMapAnimAdd [0.2,ctrlMapScale _map,SICS_selectedPosition];ctrlMapAnimCommit _map;
};
if (SICS_deviceMode in ["PHONE","PORTABLE"]) then {SICS_mobilePane="APP";[] call SICS_fnc_mobileLayout};
true
