// Use the dependency's real TAD renderer, controls and avionics symbology.
params ["_action"];
if !([player] call SICS_fnc_vehicleAccess && {vehicle player isKindOf "Air"}) exitWith {false};
if (!isNull findDisplay 87000) then {["CLOSE"] call SICS_fnc_toggleDevice};
[_action] spawn {
    params ["_action"];
    waitUntil {sleep 0.01;!(missionNamespace getVariable ["SICS_transitionActive",false])};
    if (missionNamespace getVariable ["SICS_quickActive",false]) then {[] call SICS_fnc_quickView};
    if !([player] call SICS_fnc_vehicleAccess && {vehicle player isKindOf "Air"}) exitWith {};
    if (_action=="MAIN") then {[] call cTab_fnc_onIfMainPressed} else {[] call cTab_fnc_onIfSecondaryPressed};
    private _deadline=diag_tickTime+2;
    waitUntil {sleep 0.01;(!isNil "cTabIfOpen" && {!isNull(uiNamespace getVariable [cTabIfOpen select 1,displayNull])}) || {diag_tickTime>_deadline}};
    if (isNil "cTabIfOpen") exitWith {};
    private _display=uiNamespace getVariable [cTabIfOpen select 1,displayNull];
    if (!isNull _display && {[_display] call {params ["_d"];!(_d getVariable ["ATLAS_keysInstalled",false])}}) then {
        _display setVariable ["ATLAS_keysInstalled",true];
        _display displayAddEventHandler ["KeyDown",{[_this,false] call SICS_fnc_deviceKey}];
        _display displayAddEventHandler ["KeyUp",{[_this,true] call SICS_fnc_deviceKey}];
        {if (ctrlType _x==101) then {_x ctrlAddEventHandler ["Draw",{[_this select 0] call SICS_fnc_operationsDraw}]}} forEach allControls _display;
    };
};
true
