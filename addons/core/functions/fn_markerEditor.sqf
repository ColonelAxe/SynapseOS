disableSerialization;
params ["_pos",["_screen",[]]];
SICS_selectedPosition=_pos;
SICS_editMarker=-1;
SICS_markerNeedsPoint=_screen isEqualTo [];
private _entry=[];
private _map=findDisplay 87000 displayCtrl 40;
if (_screen isNotEqualTo []) then {
    {
        private _p=_map ctrlMapWorldToScreen (_x select 6);
        if ((_x select 3)!="SICS_LINE" && {_p isNotEqualTo []} && {_p distance2D _screen < 0.025}) exitWith {SICS_editMarker=_x select 0;_entry=_x;SICS_selectedPosition=_x select 6};
    } forEach values (missionNamespace getVariable ["SICS_clientMarkers",createHashMap]);
};
private _background=["SICS_Text",300,[0.32,0.29,0.36,0.46],""] call SICS_fnc_control;
_background ctrlSetBackgroundColor [0.02,0.065,0.10,1];
["SICS_Header",301,[0.32,0.29,0.36,0.045],["PLACE MAP MARKER","EDIT MAP MARKER"] select (SICS_editMarker>=0)] call SICS_fnc_control;
["SICS_Text",302,[0.34,0.35,0.14,0.03],"SYMBOL"] call SICS_fnc_control;
private _type=["SICS_Combo",303,[0.34,0.39,0.25,0.04]] call SICS_fnc_control;
{
    private _i=_type lbAdd getText(_x >> "name");
    _type lbSetData [_i,configName _x];
    _type lbSetPicture [_i,getText(_x >> "icon")];
    if (configName _x==(["mil_dot",_entry param [3,"mil_dot"]] select (_entry isNotEqualTo []))) then {_type lbSetCurSel _i};
} forEach ("getNumber (_x >> 'scope') > 0 && {getText (_x >> 'icon') != ''}" configClasses (configFile >> "CfgMarkers"));
["SICS_Text",304,[0.34,0.45,0.14,0.03],"COLOUR"] call SICS_fnc_control;
private _colour=["SICS_Combo",305,[0.34,0.49,0.15,0.04]] call SICS_fnc_control;
{
    private _i=_colour lbAdd (_x select 0); _colour lbSetData [_i,_x select 1];
    if ((_x select 1)==(_entry param [4,"ColorBlue"])) then {_colour lbSetCurSel _i};
} forEach [["Blue","ColorBlue"],["Red","ColorRed"],["Green","ColorGreen"],["Yellow","ColorYellow"],["Orange","ColorOrange"],["Black","ColorBlack"],["White","ColorWhite"]];
["SICS_Text",306,[0.51,0.45,0.15,0.03],"DIRECTION / SIZE"] call SICS_fnc_control;
["SICS_Edit",307,[0.51,0.49,0.065,0.04],str (_entry param [7,0])] call SICS_fnc_control;
["SICS_Edit",308,[0.585,0.49,0.065,0.04],str (_entry param [8,1])] call SICS_fnc_control;
["SICS_Text",309,[0.34,0.55,0.30,0.025],format ["LABEL / GRID %1",mapGridPosition SICS_selectedPosition]] call SICS_fnc_control;
["SICS_Edit",310,[0.34,0.585,0.31,0.04],_entry param [5,""]] call SICS_fnc_control;
SICS_fnc_closeMarker={
    {if (ctrlIDC _x>=300 && {ctrlIDC _x<=319}) then {ctrlDelete _x}} forEach allControls findDisplay 87000;
};
private _save=["SICS_Button",311,[0.34,0.66,0.095,0.04],["Save marker","Place on map"] select (SICS_markerNeedsPoint && {SICS_editMarker<0})] call SICS_fnc_control;
_save ctrlSetBackgroundColor [0,0.43,0.68,1];
_save ctrlAddEventHandler ["ButtonClick",{
    private _d=findDisplay 87000;
    private _type=_d displayCtrl 303; private _c=_d displayCtrl 305;
    private _payload=[SICS_editMarker,_type lbData lbCurSel _type,_c lbData lbCurSel _c,ctrlText (_d displayCtrl 310),SICS_selectedPosition,parseNumber ctrlText (_d displayCtrl 307),parseNumber ctrlText (_d displayCtrl 308)];
    if (SICS_markerNeedsPoint && {SICS_editMarker<0}) then {
        SICS_pendingMarker=_payload;
        (findDisplay 87000 displayCtrl 60) ctrlSetText "MARKER READY  /  Click the map to place the selected symbol";
    } else {[player,"MARKER",_payload,SICS_terminal] remoteExecCall ["SICS_fnc_server",2]};
    [] call SICS_fnc_closeMarker;
}];
private _cancel=["SICS_Button",312,[0.445,0.66,0.095,0.04],"Cancel"] call SICS_fnc_control;
_cancel ctrlAddEventHandler ["ButtonClick",{[] call SICS_fnc_closeMarker}];
private _delete=["SICS_Button",313,[0.55,0.66,0.10,0.04],"DELETE"] call SICS_fnc_control;
_delete ctrlEnable (SICS_editMarker>=0);
_delete ctrlAddEventHandler ["ButtonClick",{[player,"MARKER_DELETE",[SICS_editMarker],SICS_terminal] remoteExecCall ["SICS_fnc_server",2]; [] call SICS_fnc_closeMarker}];

