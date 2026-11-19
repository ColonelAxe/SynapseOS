if (!hasInterface) exitWith {false};
if (!isNil "SICS_transitionActive" && {SICS_transitionActive}) exitWith {true};
if (!isNull findDisplay 87000) exitWith {["MINIMIZE"] call SICS_fnc_toggleDevice;true};
if (isNil "SICS_fnc_open") exitWith {hint "SynapseOS core is not available.";false};
[objNull,"AVIATION","ATLAS"] call SICS_fnc_open;
!isNull findDisplay 87000
