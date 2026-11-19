disableSerialization;
params ["_display"];
private _name=displayUniqueName _display;
private _screens=(missionNamespace getVariable ["ATLAS_briefScreens",[]]) select {_x getVariable ["ATLAS_briefName",""]==_name};
private _map=_display displayCtrl 40;private _title=_display displayCtrl 2;
if (_screens isEqualTo [] || {isNull player}) exitWith {_map ctrlShow false;_title ctrlSetText "SynapseOS / waiting for station"};
private _screen=_screens select 0;private _state=_screen getVariable ["ATLAS_briefing",[sideUnknown,"","",0.1]];
if ((_state select 0)!=side group player) exitWith {_map ctrlShow false;_title ctrlSetText "SynapseOS / restricted station"};
private _ops=missionNamespace getVariable ["ATLAS_clientOperations",createHashMap];
private _plan=_ops getOrDefault [_state select 1,[]];
private _focus=_ops getOrDefault [_state select 2,_plan];
private _default=[getPosATL _screen select [0,2],0.1];
if (_focus isNotEqualTo [] && {_plan param [7,""]=="PUBLISHED"}) then {_default=[_focus select 8 select [0,2],_state select 3]};
private _view=_screen getVariable ["ATLAS_tocMapView",_default];
_map ctrlShow true;_title ctrlSetText "SynapseOS   /   ATLAS   /   LIVE TACTICAL PICTURE";
_map setVariable ["ATLAS_briefPlan",_state select 1];
if !(_map getVariable ["ATLAS_installed",false]) then {
    _map setVariable ["ATLAS_installed",true];
    _map ctrlAddEventHandler ["Draw",{params ["_map"];[_map] call SICS_fnc_bftDraw;[_map,_map getVariable ["ATLAS_briefPlan",""],true] call SICS_fnc_operationsDraw}];
};
if (_view isNotEqualTo (_map getVariable ["ATLAS_lastView",[]])) then {
    ctrlMapAnimClear _map;_map ctrlMapAnimAdd [0,_view select 1,_view select 0];ctrlMapAnimCommit _map;_map setVariable ["ATLAS_lastView",_view];
};
(_display displayCtrl 3) ctrlSetText format ["GRID %1   |   SHARED VIEW   |   %2",mapGridPosition (_view select 0),[dayTime,"HH:MM:SS"] call BIS_fnc_timeToString];
