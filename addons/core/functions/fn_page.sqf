disableSerialization;
private _d = findDisplay 87000;
{(_d displayCtrl _x) ctrlShow false} forEach [93,94];
SICS_osApp="ATLAS";SICS_osLastApp="ATLAS";(_d displayCtrl 92) ctrlShow false;(_d displayCtrl 6) ctrlSetText "\x\sics\addons\core\ui\atlas_logo_ca.paa";
if (!(SICS_tab in ["OVERVIEW","C2"]) && {SICS_mapTool=="INSPECT"}) then {SICS_mapTool="GRID"};
if (missionNamespace getVariable ["SICS_mobileTab",""]!=SICS_tab) then {
    SICS_mobilePane=if (SICS_tab in ["MESSAGES","REPORTS","ISR","TOC"]) then {"APP"} else {"MAP"};SICS_mobileTab=SICS_tab;
};
if (!isNil "SICS_unread") then {SICS_unread set [SICS_tab,0]};
{private _bucket=switch (_x select 0) do {case "ORDER":{"C2"};case "ACK":{"C2"};case "ORDER_UPDATE":{"C2"};case "REPORT":{"REPORTS"};case "CONTACT":{"REPORTS"};default {""}};if (_bucket==SICS_tab) then {_x set [5,true]}} forEach (missionNamespace getVariable ["SICS_notificationHistory",[]]);
SICS_expanded=false;
{(_d displayCtrl _x) ctrlShow true} forEach [50,51,52];
[] call SICS_fnc_stopCamera;
{if (ctrlIDC _x >= 100) then {ctrlDelete _x}} forEach allControls _d;
private _map = _d displayCtrl 40;
private _overview = SICS_tab == "OVERVIEW";
_map ctrlSetPosition ([0.22,0.165,[0.36,0.52] select _overview,0.72] call SICS_fnc_rect); _map ctrlCommit 0;
(_d displayCtrl 50) ctrlSetText ([SICS_tab,"OPERATIONS FEED"] select _overview);
[] call SICS_fnc_feed;
{(_d displayCtrl (10+_forEachIndex)) ctrlSetBackgroundColor (if (_x==SICS_tab) then {[0.08,0.30,0.31,1]} else {[0.08,0.14,0.19,1]})} forEach ["OVERVIEW","MESSAGES","ISR","C2","REPORTS","TOC"];
if (_overview) exitWith {[] call SICS_fnc_layout};
// Detail workspace next to the persistent tactical map.
["SICS_Text",100,[0.595,0.165,0.14,0.04],SICS_tab] call SICS_fnc_control;
if (SICS_tab in ["MESSAGES","C2","REPORTS"]) then {
    ["SICS_Text",101,[0.595,0.23,0.14,0.04],"PRIORITY"] call SICS_fnc_control;
    private _p = ["SICS_Combo",102,[0.595,0.28,0.14,0.04]] call SICS_fnc_control;
    {_p lbAdd _x} forEach ["ROUTINE","PRIORITY","IMMEDIATE"]; _p lbSetCurSel 0;
    ["SICS_Text",103,[0.595,0.34,0.14,0.04],"RECIPIENT GROUP"] call SICS_fnc_control;
    private _to = ["SICS_Combo",104,[0.595,0.39,0.14,0.04]] call SICS_fnc_control;
    _to lbAdd "ALL STATIONS"; _to lbSetData [0,""];
    {if (side _x == side group player) then {private _i = _to lbAdd groupId _x; _to lbSetData [_i,netId _x]}} forEach allGroups; _to lbSetCurSel 0;
    ["SICS_Text",105,[0.595,0.45,0.14,0.04],"TEXT / REPORT"] call SICS_fnc_control;
    ["SICS_Multiline",106,[0.595,0.50,0.14,0.17],""] call SICS_fnc_control;
    if (SICS_tab=="REPORTS") then {(_d displayCtrl 106) ctrlSetText "SALUTE: Size / Activity / Location / Unit / Time / Equipment"};
    if (SICS_tab=="REPORTS") then {
        private _format=["SICS_Combo",109,[0.595,0.76,0.14,0.045]] call SICS_fnc_control;
        {_format lbAdd _x} forEach ["SALUTE","SITREP","LOGSTAT","MEDICAL"]; _format lbSetCurSel 0;
        _format ctrlAddEventHandler ["LBSelChanged",{
            params ["_ctrl","_i"];
            private _templates=["SALUTE: Size / Activity / Location / Unit / Time / Equipment","SITREP: Situation / Own activity / Next activity / Support needed","LOGSTAT: Personnel / Ammunition / Fuel / Supplies / Requests","MEDICAL: Grid / Patients / Severity / Security / Assistance needed"];
            (findDisplay 87000 displayCtrl 106) ctrlSetText (_templates select _i);
        }];
    };
    private _send = ["SICS_Button",107,[0.595,0.69,0.14,0.045],"TRANSMIT"] call SICS_fnc_control;
    _send ctrlAddEventHandler ["ButtonClick",{[SICS_tab] call SICS_fnc_submit}];
};
if (SICS_tab=="C2") then {
    private _ack = ["SICS_Button",108,[0.595,0.76,0.14,0.045],"ACK SELECTED"] call SICS_fnc_control;
    _ack ctrlAddEventHandler ["ButtonClick",{["ACK"] call SICS_fnc_submit}];
};
if (SICS_tab=="ISR") then {
    private _list = ["SICS_List",110,[0.595,0.23,0.14,0.35]] call SICS_fnc_control;
    _list ctrlAddEventHandler ["LBSelChanged",{
        params ["_list","_i"];
        if (_i<0) exitWith {};
        [objectFromNetId (_list lbData _i),["UAV","HELMET"] select (_list lbValue _i)] call SICS_fnc_isrSelect;
    }];
    {private _i=_list lbAdd (_x select 2);_list lbSetData [_i,netId (_x select 0)];_list lbSetValue [_i,if ((_x select 1)=="HELMET") then {1} else {0}] } forEach ([] call SICS_fnc_isrSources);
    private _link = ["SICS_Button",111,[0.595,0.61,0.14,0.05],"LINK UAV TERMINAL"] call SICS_fnc_control;
    _link ctrlAddEventHandler ["ButtonClick",{
        ["TERMINAL"] call SICS_fnc_droneControl;
    }];
    ["SICS_Text",112,[0.595,0.69,0.14,0.17],"Select an authorised UAV or helmet camera. UAV control requires a compatible terminal."] call SICS_fnc_control;
    private _stop=["SICS_Button",114,[0.595,0.87,0.14,0.04],"Stop stream"] call SICS_fnc_control;_stop ctrlAddEventHandler ["ButtonClick",{[] call SICS_fnc_stopCamera}];
    private _pilot=["SICS_Button",115,[0.74,0.62,0.10,0.06],"Pilot"] call SICS_fnc_control;_pilot ctrlAddEventHandler ["ButtonClick",{["DRIVER"] call SICS_fnc_droneControl}];
    private _gunner=["SICS_Button",116,[0.85,0.62,0.10,0.06],"Turret / weapons"] call SICS_fnc_control;_gunner ctrlAddEventHandler ["ButtonClick",{["GUNNER"] call SICS_fnc_droneControl}];
    private _pic=["RscPicture",113,[0.755,0.75,0.21,0.135],"#(argb,512,512,1)r2t(SICS_ISR,1)"] call SICS_fnc_control;
};
if (SICS_tab=="TOC") then {
    ["SICS_Text",120,[0.595,0.23,0.14,0.20],"TACTICAL OPERATIONS CENTRE\n\nMission-defined terminals provide shared C2 access within 5 metres."] call SICS_fnc_control;
    ["SICS_Text",121,[0.595,0.47,0.14,0.21],if (isNull SICS_terminal) then {"MOBILE STATION\nUse an authorised terminal to enter TOC mode."} else {format ["CONNECTED\n%1",SICS_terminal getVariable ["SICS_name","TOC"]]}] call SICS_fnc_control;
};
if (SICS_tab=="REPORTS" && {missionNamespace getVariable ["ATLAS_reportPhoto",""]!=""}) then {
    private _photo=["SICS_Button",381,[0.74,0.795,0.15,0.04],"Photo attached"] call SICS_fnc_control;
    _photo ctrlAddEventHandler ["ButtonClick",{ATLAS_cameraSelected=ATLAS_reportPhoto;["CAMERA"] call SICS_fnc_launchApp}];
    private _remove=["SICS_Button",382,[0.90,0.795,0.055,0.04],"Remove"] call SICS_fnc_control;
    _remove ctrlAddEventHandler ["ButtonClick",{private _draft=ctrlText(findDisplay 87000 displayCtrl 106);ATLAS_reportPhoto="";[] call SICS_fnc_page;(findDisplay 87000 displayCtrl 106) ctrlSetText _draft}];
};
[] call SICS_fnc_layout;

