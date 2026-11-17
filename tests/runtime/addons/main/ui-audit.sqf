// Geometry acceptance across device variants; layered panels are intentionally excluded.
disableSerialization;
params [["_textScale",1]];
private _oldScale=ATLAS_textScale;ATLAS_textScale=_textScale;
private _oldCallsign=groupId group player;group player setGroupIdGlobal ["ALPHA BRAVO CHARLIE 1234"];
private _audit={
    params ["_name",["_display",findDisplay 87000],["_form",false]];
    if (isNull _display) exitWith {diag_log format ["ATLAS_UI_AUDIT %1/text-%2: FAIL missing display",_name,_textScale]};
    private _controls=(allControls _display) select {
        private _id=ctrlIDC _x;
        ctrlShown _x && {isNull ctrlParentControlsGroup _x} && {_id>=0} &&
        {!(_id in [70,71,72,73,74,75,76,77,78,79,90,91,92,93,94,100,300,399,400,600,701,799,800,1510,1511,1512,1513,1514,1520,1521,1522,1600])} &&
        {!(_id>=1200 && {_id<1300})} && {!(_id>=1400 && {_id<1500})} &&
        {!(_id in [2800,2899])} && {!_form || {_id>=300}}
    };
    private _overlaps=[];private _outside=[];
    private _v=if (_form) then {SICS_formViewport} else {SICS_viewport};
    {
        private _a=_x;private _ar=ctrlPosition _a;
        if ((_ar select 0)<(_v select 0)-pixelW || {(_ar select 1)<(_v select 1)-pixelH} || {(_ar select 0)+(_ar select 2)>(_v select 0)+(_v select 2)+pixelW} || {(_ar select 1)+(_ar select 3)>(_v select 1)+(_v select 3)+pixelH}) then {_outside pushBack ctrlIDC _a};
        {
            if (ctrlIDC _a<ctrlIDC _x) then {
                private _br=ctrlPosition _x;
                private _iw=(((_ar select 0)+(_ar select 2)) min ((_br select 0)+(_br select 2)))-((_ar select 0) max (_br select 0));
                private _ih=(((_ar select 1)+(_ar select 3)) min ((_br select 1)+(_br select 3)))-((_ar select 1) max (_br select 1));
                if (_iw>pixelW*2 && {_ih>pixelH*2}) then {_overlaps pushBack [ctrlIDC _a,ctrlIDC _x]};
            };
        } forEach _controls;
    } forEach _controls;
    diag_log format ["ATLAS_UI_AUDIT %1/text-%5: %2 overlaps=%3 outside=%4",_name,["FAIL","PASS"] select (_overlaps isEqualTo [] && {_outside isEqualTo []}),_overlaps,_outside,_textScale];
};
player addItem "ATLAS_Tablet";player addItem "ATLAS_Phone";player addItem "ItemMicroDAGR";
{
    private _mode=_x;
    ["CLOSE"] call SICS_fnc_toggleDevice;
    waitUntil {sleep 0.05;!(missionNamespace getVariable ["SICS_transitionActive",false]) && {isNull findDisplay 87000}};
    if (_mode in ["VEHICLE","AVIATION"]) then {private _v=SICS_testVehicles select ([0,1] select (_mode=="AVIATION"));moveOut driver _v;player moveInDriver _v};
    if (_mode=="WORKSTATION") then {moveOut player;private _p=getPosATL player;_p set [2,0];player setPosATL _p;private _toc="Land_Laptop_unfolded_F" createVehicle _p;_toc setPosATL (player getPos [1,0]);[_toc,west,"VISUAL TEST"] call SICS_fnc_registerTOC;SICS_terminal=_toc};
    [SICS_terminal,_mode,"HOME"] call SICS_fnc_open;
    [_mode] call SICS_fnc_deviceLayout;
    diag_log format ["ATLAS_UI_AUDIT %1/device: %2",_mode,["FAIL","PASS"] select (SICS_deviceMode==_mode)];
    [] call SICS_fnc_osHome;sleep 0.1;
    [_mode+"/HOME"] call _audit;
    {
        [_x] call SICS_fnc_launchApp;sleep 0.1;
        [_mode+"/"+_x] call _audit;
    } forEach ["SETTINGS","CAMERA","NOTIFICATIONS"];
    ["SETTINGS"] call SICS_fnc_launchApp;["PREFERENCES"] call SICS_fnc_settings;[_mode+"/PREFERENCES"] call _audit;
    ["OPERATIONS"] call SICS_fnc_launchApp;
    {ATLAS_opsTab=_x;[] call SICS_fnc_operations;[_mode+"/OPERATIONS/"+_x] call _audit} forEach ["PLANS","CONTACTS","ORDERS","SUPPORT","AIR","JOURNAL","PRESETS"];
    {[_x,[]] call SICS_fnc_operationsEditor;[_mode+"/OPERATIONS/EDITOR/"+_x,findDisplay 87003,true] call _audit;findDisplay 87003 closeDisplay 2;sleep 0.05} forEach ["PLAN","GRAPHIC","CONTACT","SUPPORT","LZ","AIR_TASK"];
    ["ATLAS"] call SICS_fnc_launchApp;
    {
        SICS_tab=_x;SICS_mapTool="GRID";SICS_compose=false;[] call SICS_fnc_page;
        if (_mode in ["PHONE","PORTABLE"]) then {
            {SICS_mobilePane=_x;[] call SICS_fnc_mobileLayout;[_mode+"/"+SICS_tab+"/"+_x] call _audit} forEach ["MAP","APP","UNITS"];
        } else {[_mode+"/"+_x] call _audit};
        if (_x=="C2") then {SICS_compose=true;[] call SICS_fnc_page;if (_mode in ["PHONE","PORTABLE"]) then {SICS_mobilePane="APP";[] call SICS_fnc_mobileLayout};[_mode+"/C2/COMPOSE"] call _audit};
    } forEach ["OVERVIEW","MESSAGES","ISR","C2","REPORTS","TOC"];
    SICS_tab="REPORTS";ATLAS_reportPhoto="LAYOUT_FIXTURE";[] call SICS_fnc_page;
    if (_mode in ["PHONE","PORTABLE"]) then {SICS_mobilePane="APP";[] call SICS_fnc_mobileLayout};
    [_mode+"/REPORTS/PHOTO"] call _audit;ATLAS_reportPhoto="";
    SICS_tab="OVERVIEW";[] call SICS_fnc_page;["INSPECT"] call SICS_fnc_mapTool;
    if (_mode in ["PHONE","PORTABLE"]) then {SICS_mobilePane="APP";[] call SICS_fnc_mobileLayout};
    [_mode+"/INSPECTOR"] call _audit;SICS_mapTool="GRID";
    if (_mode in ["VEHICLE","AVIATION"]) then {moveOut player};
    SICS_terminal=objNull;
} forEach ["TABLET","PHONE","PORTABLE","VEHICLE","AVIATION","WORKSTATION"];
["CLOSE"] call SICS_fnc_toggleDevice;waitUntil {sleep 0.05;!(missionNamespace getVariable ["SICS_transitionActive",false]) && {isNull findDisplay 87000}};
[objNull,"TABLET","HOME"] call SICS_fnc_open;
["TABLET"] call SICS_fnc_deviceLayout;SICS_tab="REPORTS";[] call SICS_fnc_page;
[getPos player] call SICS_fnc_contactEditor;["CONTACT FORM",findDisplay 87001,true] call _audit;[] call SICS_fnc_closeContact;
[false] call SICS_fnc_channelEditor;["CHANNEL FORM",findDisplay 87002,true] call _audit;findDisplay 87002 closeDisplay 2;
[getPos player] call SICS_fnc_markerEditor;["MARKER FORM",findDisplay 87000,true] call _audit;[] call SICS_fnc_closeMarker;
SICS_tab="C2";SICS_compose=false;[] call SICS_fnc_page;
diag_log format ["ATLAS_UI_AUDIT details_newlines: %1",["FAIL","PASS"] select ((ctrlText(findDisplay 87000 displayCtrl 240)) find "\n"<0)];
[] call SICS_fnc_osHome;
["HOME"] call SICS_fnc_frameAction;
diag_log format ["ATLAS_UI_AUDIT frame_start: %1",["FAIL","PASS"] select (findDisplay 87000 getVariable ["ATLAS_startOpen",false])];
["IN"] call SICS_fnc_frameAction;sleep 0.1;
diag_log format ["ATLAS_UI_AUDIT frame_map: %1",["FAIL","PASS"] select (SICS_osApp=="ATLAS" && {ctrlShown(findDisplay 87000 displayCtrl 40)})];
["POWER"] call SICS_fnc_frameAction;sleep 0.1;
diag_log format ["ATLAS_UI_AUDIT frame_power: %1",["FAIL","PASS"] select isNull findDisplay 87000];
[objNull,"TABLET","HOME"] call SICS_fnc_open;
SICS_tab="OVERVIEW";[] call SICS_fnc_page;[] call SICS_fnc_osHome;
diag_log "ATLAS_UI_AUDIT COMPLETE";
ATLAS_textScale=_oldScale;group player setGroupIdGlobal [_oldCallsign];[] call SICS_fnc_osHome;
