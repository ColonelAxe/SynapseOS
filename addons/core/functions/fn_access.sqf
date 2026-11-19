params ["_unit", ["_terminal", objNull]];
if (isNull _unit || {!alive _unit}) exitWith {false};
([_unit,_terminal] call SICS_fnc_devices) isNotEqualTo []

