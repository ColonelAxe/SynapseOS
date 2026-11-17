// Extend the original addon through CfgFunctions before final compilation.
// Do not overwrite cTab's final function at runtime.
params ["_unit","_requested"];
if (isNil "ATLAS_originalCheckGear") then {
    ATLAS_originalCheckGear=compileFinal preprocessFileLineNumbers "\cTab\functions\fn_checkGear.sqf";
};
private _expanded=+_requested;
if ("ItemcTab" in _requested) then {_expanded pushBackUnique "ATLAS_Tablet"};
if ("ItemAndroid" in _requested) then {_expanded pushBackUnique "ATLAS_Phone"};
[_unit,_expanded] call ATLAS_originalCheckGear
