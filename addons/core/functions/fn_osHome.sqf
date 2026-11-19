disableSerialization;
params [["_start",false]];
private _d=findDisplay 87000;if (isNull _d) exitWith {};
[_d] call SICS_fnc_saveSession;
SICS_osApp="HOME";SICS_osLastApp="HOME";
[] call SICS_fnc_stopCamera;
[] call SICS_fnc_cameraClose;
{if (ctrlIDC _x>=100) then {ctrlDelete _x}} forEach allControls _d;
{if (!(ctrlIDC _x in [2,3,4,5,6,8,90,92,93,94])) then {_x ctrlShow false}} forEach allControls _d;
{(_d displayCtrl _x) ctrlShow true} forEach [2,3,4,5,6,8,90,92,93,94];
private _wallRect=if (SICS_deviceMode in ["PHONE","PORTABLE"]) then {[0.045,0.077,0.91,0.85]} else {[0.045,0.055,0.91,0.875]};
(_d displayCtrl 92) ctrlSetPosition (_wallRect call SICS_fnc_rect);(_d displayCtrl 92) ctrlCommit 0;
(_d displayCtrl 92) ctrlSetText format ["\x\sics\addons\core\ui\wallpaper_%1_ca.paa",["tablet","phone"] select (SICS_deviceMode in ["PHONE","PORTABLE"])];
private _top=_wallRect select 1;
{private _c=_d displayCtrl (_x select 0);_c ctrlSetPosition ((_x select 1) call SICS_fnc_rect);_c ctrlCommit 0} forEach [[93,[0.045,_top,0.91,0.045]],[94,[0.045,0.875,0.91,0.055]],[6,[0.055,_top+0.004,0.022,0.035]],[2,[0.085,_top+0.006,0.21,0.03]],[3,[0.35,_top+0.006,0.30,0.03]],[5,[0.69,_top+0.006,0.12,0.03]],[8,[0.83,_top+0.006,0.055,0.03]],[4,[0.90,_top+0.006,0.04,0.03]]];
(_d displayCtrl 2) ctrlSetText "SynapseOS";(_d displayCtrl 6) ctrlSetText "\x\sics\addons\core\ui\synapse_logo_ca.paa";
(_d displayCtrl 94) ctrlSetPosition ([0.045,0.865,0.91,0.065] call SICS_fnc_rect);(_d displayCtrl 94) ctrlCommit 0;
["SICS_AppLabel",1002,[0.825,0.869,0.09,0.026],[dayTime,"HH:MM"] call BIS_fnc_timeToString] call SICS_fnc_control;
["SICS_AppLabel",1004,[0.817,0.897,0.097,0.026],format ["%1/%2/%3",date select 2,date select 1,date select 0]] call SICS_fnc_control;
["SICS_AppLabel",1003,[0.70,0.879,0.035,0.035],"^"] call SICS_fnc_control;
(_d displayCtrl 1003) ctrlSetTooltip "SynapseOS system tray";
private _apps=(values SYNAPSE_apps) select {[] call (_x select 4)};
_apps sort true;
[
    "SICS_Header",1000,[0.055,_top+0.047,0.42,0.025],"FIELD USER / APPLICATIONS"
] call SICS_fnc_control;
private _appsTop=_top+0.09;
private _page=(missionNamespace getVariable ["SICS_osPage",0]) max 0 min ((ceil(count _apps/8)-1) max 0);SICS_osPage=_page;
SICS_osAppWidgets=[];
{
    private _index=_forEachIndex;private _xpos=0.055+floor(_index/4)*0.15;private _y=_appsTop+(_index mod 4)*0.17;
    private _ih=0.105;private _iw=_ih*(SICS_viewport select 3)/pixelH*pixelW/(SICS_viewport select 2);
    private _ix=_xpos+(0.13-_iw)/2;
    private _button=["SICS_Button",1100+_index,[_ix,_y,_iw,_ih],""] call SICS_fnc_control;
    _button ctrlSetBackgroundColor [0,0,0,0];
    _button setVariable ["SYNAPSE_app",_x select 0];_button ctrlSetTooltip (_x select 1);_button ctrlAddEventHandler ["ButtonClick",{[(_this select 0) getVariable "SYNAPSE_app"] call SICS_fnc_launchApp}];
    ["RscPicture",1250+_index,[_ix,_y,_iw,_ih],"\x\sics\addons\core\ui\app_tile_ca.paa"] call SICS_fnc_control;
    ["RscPicture",1200+_index,[_ix+_iw*0.10,_y+_ih*0.10,_iw*0.80,_ih*0.80],_x select 2] call SICS_fnc_control;
    ["SICS_AppLabel",1300+_index,[_xpos,_y+0.11,0.13,0.035],_x select 1] call SICS_fnc_control;
    private _badge=[] call (_x select 5);
    ["SICS_Text",1400+_index,[_ix+_iw-0.015,_y,0.04,0.04],if (_badge>0) then {str _badge} else {""}] call SICS_fnc_control;
    SICS_osAppWidgets pushBack [_x select 0,1400+_index];
} forEach (_apps select [_page*8,8]);
if (count _apps>8) then {
    private _prev=["SICS_Button",1500,[0.65,0.82,0.12,0.04],"Previous"] call SICS_fnc_control;_prev ctrlEnable (_page>0);_prev ctrlAddEventHandler ["ButtonClick",{SICS_osPage=SICS_osPage-1;[] call SICS_fnc_osHome}];
    private _next=["SICS_Button",1501,[0.79,0.82,0.12,0.04],"Next"] call SICS_fnc_control;_next ctrlEnable ((_page+1)*8<count _apps);_next ctrlAddEventHandler ["ButtonClick",{SICS_osPage=SICS_osPage+1;[] call SICS_fnc_osHome}];
};
_d setVariable ["ATLAS_startOpen",_start];
private _startButton=["SICS_TaskbarButton",1502,[0.045,0.865,0.055,0.065],""] call SICS_fnc_control;
_startButton ctrlSetTooltip "Start / applications";_startButton ctrlAddEventHandler ["ButtonClick",{[!(findDisplay 87000 getVariable ["ATLAS_startOpen",false])] call SICS_fnc_osHome}];
private _search=["SICS_TaskbarButton",1505,[0.102,0.865,0.18,0.065],"Search apps"] call SICS_fnc_control;
_search ctrlSetBackgroundColor [1,1,1,0.08];
_search ctrlSetTooltip "Open the application list";_search ctrlAddEventHandler ["ButtonClick",{[true] call SICS_fnc_osHome}];
private _tasks=["SICS_TaskbarButton",1506,[0.285,0.865,0.05,0.065],""] call SICS_fnc_control;
_tasks ctrlSetTooltip "Applications";_tasks ctrlAddEventHandler ["ButtonClick",{[true] call SICS_fnc_osHome}];
private _notices=["SICS_TaskbarButton",1508,[0.919,0.865,0.035,0.065],""] call SICS_fnc_control;
_notices ctrlSetTooltip "Notification centre";_notices ctrlAddEventHandler ["ButtonClick",{["NOTIFICATIONS"] call SICS_fnc_launchApp}];
private _audio=["SICS_TaskbarButton",1509,[0.78,0.865,0.035,0.065],""] call SICS_fnc_control;
_audio ctrlSetTooltip "Audio and display preferences";_audio ctrlAddEventHandler ["ButtonClick",{["SETTINGS"] call SICS_fnc_launchApp;["PREFERENCES"] call SICS_fnc_settings}];
{
    _x params ["_id","_app","_icon"];
    private _xpos=0.34+_forEachIndex*0.058;
    private _b=["SICS_TaskbarButton",_id,[_xpos,0.865,0.055,0.065],""] call SICS_fnc_control;
    _b ctrlSetTooltip _app;_b setVariable ["SYNAPSE_app",_app];_b ctrlAddEventHandler ["ButtonClick",{[(_this select 0) getVariable "SYNAPSE_app"] call SICS_fnc_launchApp}];
    private _ih=0.044;private _iw=_ih*(SICS_viewport select 3)/pixelH*pixelW/(SICS_viewport select 2);
    ["RscPicture",1520+_forEachIndex,[_xpos+(0.055-_iw)/2,0.875,_iw,_ih],"\x\sics\addons\core\ui\"+_icon+"_app_ca.paa"] call SICS_fnc_control;
} forEach [[1503,"ATLAS","atlas"],[1504,"SETTINGS","settings"],[1507,"CAMERA","camera"]];
{
    _x params ["_id","_xpos","_icon","_tip"];
    private _ih=0.03;private _iw=_ih*(SICS_viewport select 3)/pixelH*pixelW/(SICS_viewport select 2);
    private _p=["RscPicture",_id,[_xpos,0.882,_iw,_ih],"\x\sics\addons\core\ui\taskbar_"+_icon+"_ca.paa"] call SICS_fnc_control;
    _p ctrlSetTooltip _tip;
} forEach [[1510,0.064,"start","Start"],[1511,0.30,"taskview","Applications"],[1512,0.75,"network","ATLAS data link"],[1513,0.785,"volume","Notification audio"],[1514,0.925,"notifications","Notifications"]];
if (_start) then {
    private _panel=["SICS_Text",1600,[0.045,0.48,0.28,0.385],""] call SICS_fnc_control;_panel ctrlSetBackgroundColor [0.025,0.05,0.07,0.98];
    ["SICS_Header",1601,[0.055,0.51,0.26,0.04],"APPLICATIONS"] call SICS_fnc_control;
    {private _b=["SICS_Button",1610+_forEachIndex,[0.055,0.56+_forEachIndex*0.037,0.26,0.033],_x select 1] call SICS_fnc_control;_b setVariable ["SYNAPSE_app",_x select 0];_b ctrlAddEventHandler ["ButtonClick",{[(_this select 0) getVariable "SYNAPSE_app"] call SICS_fnc_launchApp}]} forEach (_apps select [_page*8,8]);
};
[true] call SICS_fnc_appHeader;

