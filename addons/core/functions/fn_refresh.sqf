disableSerialization;
private _d = findDisplay 87000;
if (isNull _d) exitWith {};
if (side group player != SICS_openSide) exitWith {[] call SICS_fnc_resetClient;SICS_markerSide=side group player};
if !([player,SICS_terminal] call SICS_fnc_access) exitWith {closeDialog 0; hint "ATLAS access lost."};
if (!isNull (missionNamespace getVariable ["SICS_deviceVehicle",objNull]) && {vehicle player!=SICS_deviceVehicle}) exitWith {closeDialog 0};
if !((missionNamespace getVariable ["SICS_deviceMode","TABLET"]) in ([player,SICS_terminal] call SICS_fnc_devices)) exitWith {closeDialog 0};
(_d displayCtrl 3) ctrlSetText format ["%1  |  %2",[player] call SICS_fnc_radio,[dayTime,"HH:MM"] call BIS_fnc_timeToString];
if (missionNamespace getVariable ["SICS_osApp","ATLAS"]=="HOME") exitWith {
    (_d displayCtrl 1002) ctrlSetText ([dayTime,"HH:MM"] call BIS_fnc_timeToString);
    (_d displayCtrl 1004) ctrlSetText format ["%1/%2/%3",date select 2,date select 1,date select 0];
    {private _app=SYNAPSE_apps getOrDefault [_x select 0,[]];if (_app isNotEqualTo []) then {private _badge=[] call (_app select 5);(_d displayCtrl (_x select 1)) ctrlSetText (if (_badge>0) then {str _badge} else {""})}} forEach (missionNamespace getVariable ["SICS_osAppWidgets",[]]);
};
if (SICS_osApp=="OPERATIONS") exitWith {[false] call SICS_fnc_operationsSelect};
if (SICS_osApp=="CAMERA" && {!( ["camera",true] call SICS_fnc_policy )}) exitWith {[] call SICS_fnc_osHome};
if (SICS_osApp!="ATLAS") exitWith {};
if (missionNamespace getVariable ["SICS_cameraActive",false]) then {
    private _source=missionNamespace getVariable ["ATLAS_streamSource",objNull];
    private _allowed=missionNamespace getVariable [["cTabUAVlist","cTabHcamlist"] select (missionNamespace getVariable ["ATLAS_streamKind",""]=="HELMET"),[]];
    if (!([ ["drone","helmet"] select (missionNamespace getVariable ["ATLAS_streamKind",""]=="HELMET"),true] call SICS_fnc_policy)) then {_allowed=[]};
    if (isNull _source || {!alive _source} || {!(_source in _allowed)}) then {[] call SICS_fnc_stopCamera;(_d displayCtrl 112) ctrlSetText "STREAM LOST / source unavailable"};
};
private _c = _d displayCtrl 31;
private _selected = _c lbData lbCurSel _c;
SICS_refreshing=true;
lbClear _c;
if (SICS_tab=="MESSAGES") then {private _i=_c lbAdd "All stations";_c lbSetData [_i,"__ALL__"];if (SICS_chatTarget=="") then {_c lbSetCurSel _i}};
if (SICS_tab=="MESSAGES") then {
    {
        private _id=_x select 0;private _n=SICS_channelUnread getOrDefault [_id,0];
        private _i=_c lbAdd format ["# %1%2",_x select 2,if (_n>0) then {format [" (%1)",_n]} else {""}];
        _c lbSetData [_i,_id];_c lbSetTooltip [_i,_x select 3];
        if (_id==SICS_chatTarget) then {_c lbSetCurSel _i};
    } forEach SICS_clientChannels;
};
{
    private _obj = _x select 0;
    private _i = _c lbAdd (_x select 3);
    _c lbSetTooltip [_i,_x select 3];
    _c lbSetData [_i,netId _obj]; _c lbSetPicture [_i,_x select 1];
    if (SICS_tab!="MESSAGES" && {netId _obj==_selected}) then {_c lbSetCurSel _i};
    if (SICS_tab=="MESSAGES" && {SICS_chatTarget!=""} && {SICS_chatTarget find "CH:"!=0} && {netId group _obj==SICS_chatTarget}) then {_c lbSetCurSel _i};
} forEach ((missionNamespace getVariable ["cTabBFTgroups",[]]) + (missionNamespace getVariable ["cTabBFTvehicles",[]]) + (missionNamespace getVariable ["cTabBFTmembers",[]]));
SICS_refreshing=false;
[] call SICS_fnc_details;
if (SICS_mapTool=="INSPECT" && {SICS_tab!="MESSAGES"}) then {[] call SICS_fnc_inspect};

