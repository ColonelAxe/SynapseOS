// Aircrew use the SynapseOS aviation device layout and shared map controls.
params ["_action"];
if !([player] call SICS_fnc_vehicleAccess && {vehicle player isKindOf "Air"}) exitWith {false};
[_action] call SICS_fnc_interfaceAction
