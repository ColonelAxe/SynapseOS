disableSerialization;
params [["_d",displayNull]];
if (isNull _d) exitWith {};
SICS_osLastApp=missionNamespace getVariable ["SICS_osApp","ATLAS"];
if (SICS_osLastApp=="OPERATIONS") exitWith {private _map=_d displayCtrl 2601;if (!isNull _map) then {private _r=ctrlPosition _map;ATLAS_operationsMap=[ctrlMapScale _map,_map ctrlMapScreenToWorld [(_r select 0)+(_r select 2)/2,(_r select 1)+(_r select 3)/2]]}};
if (SICS_osLastApp!="ATLAS") exitWith {};
if (isNil "SICS_savedAtlas") then {SICS_savedAtlas=createHashMap};
private _s=SICS_savedAtlas;
_s set ["identity",[[player] call SICS_fnc_channelIdentity,side group player]];
{_s set [_x,missionNamespace getVariable _x]} forEach ["SICS_tab","SICS_selectedUnit","SICS_selectedPosition","SICS_detailTab","SICS_compose","SICS_chatTarget","SICS_mapTool","SICS_mobilePane","SICS_pendingMarker"];
private _map=_d displayCtrl 40;private _r=ctrlPosition _map;
_s set ["map",[ctrlMapScale _map,_map ctrlMapScreenToWorld [(_r select 0)+(_r select 2)/2,(_r select 1)+(_r select 3)/2]]];
if (!isNull (_d displayCtrl 106)) then {_s set ["composer",[ctrlText (_d displayCtrl 106),lbCurSel (_d displayCtrl 102),(_d displayCtrl 104) lbData lbCurSel (_d displayCtrl 104),lbCurSel (_d displayCtrl 109)]]};
private _report=findDisplay 87001;
if (!isNull _report && {!(_report getVariable ["ATLAS_discarded",false])}) then {
    _s set ["contactDraft",[SICS_selectedPosition,ctrlText (_report displayCtrl 415),ctrlText (_report displayCtrl 417),(_report displayCtrl 403) lbData lbCurSel (_report displayCtrl 403),(_report displayCtrl 405) lbText lbCurSel (_report displayCtrl 405),(_report displayCtrl 407) lbData lbCurSel (_report displayCtrl 407),ctrlText (_report displayCtrl 410),[lbCurSel (_report displayCtrl 419),ctrlText(_report displayCtrl 421),ctrlText(_report displayCtrl 423),ctrlText(_report displayCtrl 425)]]];
};
private _channels=findDisplay 87002;
if (!isNull _channels) then {
    private _lists=[806,807,808] apply {private _list=_channels displayCtrl _x;(lbSelection _list) apply {_list lbData _x}};
    _s set ["channelDraft",[_channels getVariable ["SICS_channel",[]],ctrlText (_channels displayCtrl 803),lbCurSel (_channels displayCtrl 805),_lists]];
};

