disableSerialization;
params [["_action","BUILD"]];
private _d=findDisplay 87000;if (isNull _d) exitWith {};
private _profile=[player] call SICS_fnc_profile;
private _role=toUpper (_profile param [1,""]);
private _lastRole=missionNamespace getVariable ["ATLAS_opsRole",""];
if (_role!=_lastRole) then {
    ATLAS_opsRole=_role;
    private _roleTab=switch true do {
        case ((_role find "PILOT")>=0 || {(_role find "AVIATION")>=0}): {"AIR"};
        case ((_role find "JTAC")>=0 || {(_role find "TACP")>=0}): {"CONTACTS"};
        case ((_role find "COMMAND")>=0 || {(_role find "TOC")>=0} || {(_role find "HQ")>=0}): {"JOURNAL"};
        case ((_role find "PLATOON")>=0 || {(_role find "LEADER")>=0} || {(_role find "SQUAD")>=0}): {"PLANS"};
        default {""};
    };
    if (_roleTab!="") then {ATLAS_opsTab=_roleTab};
};
private _tab=missionNamespace getVariable ["ATLAS_opsTab","PLANS"];
if (isNil "ATLAS_journalFilter") then {ATLAS_journalFilter="ALL"};
private _id=missionNamespace getVariable ["ATLAS_opsSelected",""];
private _entry=(missionNamespace getVariable ["ATLAS_clientOperations",createHashMap]) getOrDefault [_id,[]];
private _send={params ["_action","_data"];[player,"OPS_"+_action,_data,missionNamespace getVariable ["SICS_terminal",objNull]] remoteExecCall ["SICS_fnc_server",2]};
if (_action=="CREATE") exitWith {
    if (_tab=="ORDERS") exitWith {[_d] call SICS_fnc_saveSession;SICS_osApp="ATLAS";SICS_osLastApp="ATLAS";SICS_tab="C2";SICS_compose=true;[] call SICS_fnc_page};
    if (_tab=="JOURNAL") exitWith {
        private _journal=+ATLAS_clientJournal;
        if (ATLAS_journalFilter!="ALL") then {_journal=_journal select {(_x select 2)==ATLAS_journalFilter}};
        diag_log ("ATLAS TIMELINE / authorised local view / filter "+ATLAS_journalFilter+toString [10]+(_journal apply {format ["T+%1 / %2 / %3 / %4 / %5 / GRID %6",round (_x select 10),_x select 2,_x select 7,_x select 3,_x select 5,mapGridPosition (_x select 8)]} joinString toString [10]));
        hint "Filtered timeline written to RPT.";
    };
    if (_tab=="PRESETS") exitWith {["SAVE",trim ctrlText(_d displayCtrl 2611)] call SICS_fnc_workspace;[] call SICS_fnc_operations};
    private _kind=(_d displayCtrl 2611) lbData lbCurSel (_d displayCtrl 2611);
    if (missionNamespace getVariable ["ATLAS_opsCapture",false]) then {_kind="GRAPHIC"};
    if (_kind=="GRAPHIC" && {!(missionNamespace getVariable ["ATLAS_opsCapture",false])}) exitWith {ATLAS_opsCapture=true;ATLAS_opsDraftPoints=[];ATLAS_opsSelected="";[] call SICS_fnc_operations;hint "Click map points. Right-click undoes a point. Press Details when ready."};
    [_kind,[]] call SICS_fnc_operationsEditor;
};
if (_action=="EDIT") exitWith {
    if (_tab=="PRESETS") exitWith {["APPLY",trim ctrlText(_d displayCtrl 2611)] call SICS_fnc_workspace};
    if (_entry isEqualTo []) exitWith {hint "Select an item first."};
    [_entry select 2,_entry] call SICS_fnc_operationsEditor;
};
if (_action=="DELETE") exitWith {
    if (_tab=="PRESETS") exitWith {["DELETE",trim ctrlText(_d displayCtrl 2611)] call SICS_fnc_workspace;[] call SICS_fnc_operations};
    if (_entry isEqualTo []) exitWith {};
    if (missionNamespace getVariable ["ATLAS_opsDeleteConfirm",""]!=_id) exitWith {ATLAS_opsDeleteConfirm=_id;(_d displayCtrl 2614) ctrlSetText "Confirm";hint "Press Confirm again to delete/cancel this selected item."};
    ATLAS_opsDeleteConfirm="";
    if ((_entry select 2) in ["SUPPORT","AIR_TASK"]) then {["STATE",[_id,_entry select 13,"CANCELLED"]] call _send} else {["DELETE",[_id,_entry select 13]] call _send};
};
if (_action=="FOLLOW") exitWith {
    if (_entry isEqualTo [] || {(_entry select 2)!="GRAPHIC"} || {(createHashMapFromArray (_entry select 10)) getOrDefault ["shape",""]!="ROUTE"}) exitWith {hint "Select a shared route first."};
    ATLAS_followRoute=[_id,""] select (missionNamespace getVariable ["ATLAS_followRoute",""]==_id);ATLAS_routeCheckpoint=0;
    hint (["Route following stopped.","Route selected. Main GPS shows the next checkpoint."] select (ATLAS_followRoute!=""));
};
if (_action=="HIDE") exitWith {
    if (_entry isEqualTo []) exitWith {};
    private _plan=if ((_entry select 2)=="PLAN") then {_id} else {(createHashMapFromArray (_entry select 10)) getOrDefault ["plan",""]};
    if (_plan!="") then {if (_plan in ATLAS_hiddenPlans) then {ATLAS_hiddenPlans=ATLAS_hiddenPlans-[_plan]} else {ATLAS_hiddenPlans pushBack _plan}};
};
if (_action=="BRIEF") exitWith {
    if (_entry isEqualTo []) exitWith {hint "Select a published overlay or one of its objectives."};
    private _screens=(missionNamespace getVariable ["ATLAS_briefScreens",[]]) select {alive _x && {_x distance player<=5} && {_x getVariable ["ATLAS_briefSide",sideUnknown]==side group player}};
    if (_screens isEqualTo []) exitWith {hint "Move within 5 metres of a registered briefing screen."};
    private _plan=if ((_entry select 2)=="PLAN") then {_id} else {(createHashMapFromArray (_entry select 10)) getOrDefault ["plan",""]};
    ["BRIEF",[netId (_screens select 0),_plan,["",_id] select ((_entry select 2)=="GRAPHIC"),ctrlMapScale (_d displayCtrl 2601)]] call _send;
};
if (_action=="STATE") exitWith {
    private _state=(_d displayCtrl 2622) lbText lbCurSel (_d displayCtrl 2622);
    if (_id find "ORDER:"==0) then {["ORDER_STATE",[parseNumber (_id select [6]),_state]] call _send} else {if (_entry isNotEqualTo []) then {["STATE",[_id,_entry select 13,_state]] call _send}};
};
if (_action=="DUE") exitWith {
    private _raw=ctrlText(_d displayCtrl 2625);
    if (_raw=="" || {(toArray _raw) findIf {!(_x in toArray "0123456789")}>=0}) exitWith {hint "Deadline must be 0–1440 whole minutes (0 removes it)."};
    ["ORDER_DUE",[parseNumber (_id select [6]),parseNumber _raw]] call _send;
};
private _oldMap=_d displayCtrl 2601;private _view=missionNamespace getVariable ["ATLAS_operationsMap",[]];
if (!isNull _oldMap) then {private _r=ctrlPosition _oldMap;_view=[ctrlMapScale _oldMap,_oldMap ctrlMapScreenToWorld [(_r select 0)+(_r select 2)/2,(_r select 1)+(_r select 3)/2]];ATLAS_operationsMap=_view};
{if (ctrlIDC _x>=2600 && {ctrlIDC _x<2800}) then {ctrlDelete _x}} forEach allControls _d;
SICS_unread set ["OPERATIONS",0];
["SICS_Header",2600,[0.055,0.14,0.89,0.04],format ["LIVE OPERATIONS / %1 VIEW / %2",if (_role=="") then {"GENERAL"} else {_role select [0,18]},_tab]] call SICS_fnc_control;
{
    private _label=if (_x=="JOURNAL") then {"TIMELINE"} else {_x};
    private _b=["SICS_Button",2650+_forEachIndex,[0.055+_forEachIndex*0.128,0.19,0.122,0.045],_label] call SICS_fnc_control;
    _b setVariable ["ATLAS_tab",_x];_b ctrlSetBackgroundColor (if (_x==_tab) then {[0.02,0.38,0.57,1]} else {[0.06,0.13,0.18,1]});
    _b ctrlAddEventHandler ["ButtonClick",{ATLAS_opsTab=(_this select 0) getVariable "ATLAS_tab";ATLAS_opsSelected="";ATLAS_opsCapture=false;ATLAS_opsDraftPoints=[];[] call SICS_fnc_operations}];
} forEach ["PLANS","CONTACTS","ORDERS","SUPPORT","AIR","JOURNAL","PRESETS"];
private _map=["SICS_Map",2601,[0.055,0.28,0.54,0.46],""] call SICS_fnc_control;
_map ctrlAddEventHandler ["Draw",{[_this select 0] call SICS_fnc_bftDraw;[_this select 0] call SICS_fnc_operationsDraw}];
_map ctrlAddEventHandler ["MouseButtonDown",{_this call SICS_fnc_operationsMapClick}];
["SICS_Header",2604,[0.055,0.245,0.54,0.03],"SHARED MAP / CLICK TO SELECT POSITION"] call SICS_fnc_control;
private _list=["SICS_List",2602,[0.615,0.28,0.33,0.20],""] call SICS_fnc_control;
["SICS_ReadOnly",2603,[0.615,0.50,0.33,0.24],"Select an item to inspect its state and instructions."] call SICS_fnc_control;
_list ctrlAddEventHandler ["LBSelChanged",{[] call SICS_fnc_operationsSelect}];
private _entries=(values ATLAS_clientOperations) select {(_x select 2) in (switch _tab do {case "PLANS":{["PLAN","GRAPHIC"]};case "CONTACTS":{["CONTACT"]};case "SUPPORT":{["SUPPORT"]};case "AIR":{["LZ","AIR_TASK"]};default {[]}})};
_entries sort true;
{private _i=_list lbAdd format ["%1 / %2",_x select 3,_x select 7];_list lbSetData [_i,_x select 0];_list lbSetTooltip [_i,format ["%1 / %2",_x select 2,_x select 3]]} forEach _entries;
if (_tab=="ORDERS") then {{if (_x select 2=="C2") then {private _i=_list lbAdd format ["#%1 / %2",_x select 0,(_x select 4) select [0,70]];_list lbSetData [_i,"ORDER:"+str (_x select 0)]}} forEach SICS_localRecords};
if (_tab=="JOURNAL") then {
    private _journal=+ATLAS_clientJournal;
    if (ATLAS_journalFilter!="ALL") then {_journal=_journal select {(_x select 2)==ATLAS_journalFilter}};
    for "_j" from (count _journal-1) to 0 step -1 do {
        private _e=_journal select _j;
        private _age=floor ((serverTime-(_e select 10)) max 0);
        private _when=if (_age<60) then {format ["%1s",_age]} else {format ["%1m",floor (_age/60)]};
        private _i=_list lbAdd format ["T+%1 / %2 / %3 / %4",round (_e select 10),_e select 7,_e select 3,_when];
        _list lbSetData [_i,"JOURNAL:"+(_e select 0)];
    };
};
if (_tab=="PRESETS") then {private _presets=["LIST"] call SICS_fnc_workspace;{private _i=_list lbAdd _x;_list lbSetData [_i,"PRESET:"+_x]} forEach _presets};
private _kindControl=[ ["SICS_Combo","SICS_Edit"] select (_tab=="PRESETS"),2611,[0.055,0.77,0.17,0.055],""] call SICS_fnc_control;
private _kinds=switch _tab do {case "PLANS":{["PLAN","GRAPHIC"]};case "CONTACTS":{["CONTACT"]};case "SUPPORT":{["SUPPORT"]};case "AIR":{["LZ","AIR_TASK"]};default {[]}};
if (_tab=="PRESETS") then {_kindControl ctrlSetText (missionNamespace getVariable ["ATLAS_workspaceName","JTAC"])} else {
    if (_tab=="JOURNAL") then {
        (_d displayCtrl 2604) ctrlSetText "MISSION TIMELINE / FILTER BY EVENT / SELECT TO LOCATE";
        {private _i=_kindControl lbAdd _x;_kindControl lbSetData [_i,_x];if (_x==ATLAS_journalFilter) then {_kindControl lbSetCurSel _i}} forEach ["ALL","CONTACT","ORDER","SUPPORT","AIR_TASK","PLAN","GRAPHIC","BRIEFING"];
        _kindControl ctrlAddEventHandler ["LBSelChanged",{ATLAS_journalFilter=(_this select 0) lbData lbCurSel (_this select 0);[] call SICS_fnc_operations}];
    } else {{private _i=_kindControl lbAdd _x;_kindControl lbSetData [_i,_x]} forEach _kinds;_kindControl lbSetCurSel 0};
};
if (missionNamespace getVariable ["ATLAS_opsCapture",false]) then {_kindControl lbSetCurSel 1;_kindControl ctrlEnable false};
{
    _x params ["_idc","_label","_actionName","_rect"];
    private _b=["SICS_Button",_idc,_rect,_label] call SICS_fnc_control;_b setVariable ["ATLAS_action",_actionName];
    _b ctrlAddEventHandler ["ButtonClick",{[(_this select 0) getVariable "ATLAS_action"] call SICS_fnc_operations}];
} forEach [[2612,if (_tab=="JOURNAL") then {"Export RPT"} else {if (_tab=="PRESETS") then {"Save"} else {if (missionNamespace getVariable ["ATLAS_opsCapture",false]) then {"Details"} else {"Create"}}},"CREATE",[0.235,0.77,0.10,0.055]],[2613,["Edit","Apply"] select (_tab=="PRESETS"),"EDIT",[0.355,0.77,0.10,0.055]],[2614,["Delete","Cancel"] select (_tab in ["SUPPORT","AIR"]),"DELETE",[0.475,0.77,0.12,0.055]]];
if (_tab=="ORDERS") then {{(_d displayCtrl _x) ctrlShow false} forEach [2611,2613,2614]};
if (_tab=="JOURNAL") then {{(_d displayCtrl _x) ctrlShow false} forEach [2613,2614]};
if (_tab=="PLANS") then {
    {private _b=["SICS_Button",2620+_forEachIndex,[0.615+_forEachIndex*0.17,0.77,0.16,0.055],_x select 0] call SICS_fnc_control;_b setVariable ["ATLAS_action",_x select 1];_b ctrlAddEventHandler ["ButtonClick",{[(_this select 0) getVariable "ATLAS_action"] call SICS_fnc_operations}]} forEach [["Follow route","FOLLOW"],["Hide / show","HIDE"]];
    private _b=["SICS_Button",2624,[0.615,0.845,0.33,0.045],"Brief on nearest screen"] call SICS_fnc_control;_b ctrlAddEventHandler ["ButtonClick",{["BRIEF"] call SICS_fnc_operations}];
};
if (_tab in ["CONTACTS","ORDERS","SUPPORT","AIR"]) then {
    private _state=["SICS_Combo",2622,[0.615,0.77,0.21,0.055],""] call SICS_fnc_control;
    {_state lbAdd _x} forEach (switch _tab do {case "CONTACTS":{["RESOLVED","ACTIVE"]};case "ORDERS":{["RECEIVED","ACKNOWLEDGED","EXECUTING","COMPLETED","CANCELLED"]};default {["ACCEPTED","EXECUTING","COMPLETED","CANCELLED"]}});_state lbSetCurSel 0;
    private _b=["SICS_Button",2623,[0.835,0.77,0.11,0.055],"Set state"] call SICS_fnc_control;_b ctrlAddEventHandler ["ButtonClick",{["STATE"] call SICS_fnc_operations}];
};
if (_tab=="ORDERS") then {
    ["SICS_Edit",2625,[0.615,0.845,0.14,0.045],"30"] call SICS_fnc_control;
    private _b=["SICS_Button",2626,[0.765,0.845,0.18,0.045],"Due in minutes"] call SICS_fnc_control;_b ctrlAddEventHandler ["ButtonClick",{["DUE"] call SICS_fnc_operations}];
};
{
    private _b=["SICS_Button",2630+_forEachIndex,[0.055+_forEachIndex*0.18,0.845,0.17,0.045],_x] call SICS_fnc_control;
    _b setVariable ["ATLAS_layer",_forEachIndex];_b ctrlSetBackgroundColor (if (ATLAS_opsLayers select _forEachIndex) then {[0.02,0.35,0.49,1]} else {[0.08,0.12,0.15,1]});
    _b ctrlAddEventHandler ["ButtonClick",{private _i=(_this select 0) getVariable "ATLAS_layer";ATLAS_opsLayers set [_i,!(ATLAS_opsLayers select _i)];if (_i==1) then {{[_x] call SICS_fnc_contactApply} forEach SICS_localRecords};[] call SICS_fnc_operations}];
} forEach ["Overlays","Contacts","Support"];
["SICS_Text",2640,[0.055,0.90,0.89,0.025],if (missionNamespace getVariable ["ATLAS_opsCapture",false]) then {format ["DRAWING / %1 points / Right-click undo / Create→Details",count ATLAS_opsDraftPoints]} else {"Select a map position before creating a contact, request or landing zone."}] call SICS_fnc_control;
for "_i" from 0 to (lbSize _list-1) do {if (_list lbData _i==_id) exitWith {_list lbSetCurSel _i}};
if (_view isNotEqualTo []) then {ctrlMapAnimClear _map;_map ctrlMapAnimAdd [0,_view select 0,_view select 1];ctrlMapAnimCommit _map} else {_map ctrlMapAnimAdd [0,0.1,getPosASL player];ctrlMapAnimCommit _map};
[] call SICS_fnc_appHeader;[_d] call SICS_fnc_fitText;
if ((missionNamespace getVariable ["ATLAS_operationDraft",[]]) isNotEqualTo [] && {isNull findDisplay 87003}) then {["RESTORE",[]] call SICS_fnc_operationsEditor};
