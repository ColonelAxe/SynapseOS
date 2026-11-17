disableSerialization;
params ["_display"];
private _name=displayUniqueName _display;
private _screens=(missionNamespace getVariable ["ATLAS_briefScreens",[]]) select {_x getVariable ["ATLAS_briefName",""]==_name};
private _map=_display displayCtrl 40;private _title=_display displayCtrl 2;
if (_screens isEqualTo [] || {isNull player}) exitWith {_map ctrlShow false;_title ctrlSetText "ATLAS / waiting for briefing"};
private _screen=_screens select 0;private _state=_screen getVariable ["ATLAS_briefing",[sideUnknown,"","",0.1]];
if ((_state select 0)!=side group player) exitWith {_map ctrlShow false;_title ctrlSetText "ATLAS / restricted briefing"};
private _plan=ATLAS_clientOperations getOrDefault [_state select 1,[]];
if (_plan isEqualTo [] || {_plan select 7!="PUBLISHED"}) exitWith {_map ctrlShow false;_title ctrlSetText "ATLAS / select a published overlay"};
_map ctrlShow true;_title ctrlSetText ("ATLAS / "+(_plan select 3));
private _focus=ATLAS_clientOperations getOrDefault [_state select 2,_plan];
_map setVariable ["ATLAS_briefPlan",_state select 1];_map setVariable ["ATLAS_briefFocus",_focus select 0];
if !(_map getVariable ["ATLAS_installed",false]) then {
    _map setVariable ["ATLAS_installed",true];
    _map ctrlAddEventHandler ["Draw",{params ["_map"];[_map,_map getVariable ["ATLAS_briefPlan",""],true] call SICS_fnc_operationsDraw;private _e=ATLAS_clientOperations getOrDefault [_map getVariable ["ATLAS_briefFocus",""],[]];if (_e isNotEqualTo []) then {_map drawIcon ["\A3\ui_f\data\map\markers\military\objective_CA.paa",[1,0.8,0.2,1],_e select 8,40,40,0,"BRIEFING FOCUS",1,0.035,"RobotoCondensed"]}}];
};
ctrlMapAnimClear _map;_map ctrlMapAnimAdd [0,_state select 3,_focus select 8];ctrlMapAnimCommit _map;
(_display displayCtrl 3) ctrlSetText format ["%1 / GRID %2 / SHARED BRIEFING",_focus select 3,mapGridPosition (_focus select 8)];
