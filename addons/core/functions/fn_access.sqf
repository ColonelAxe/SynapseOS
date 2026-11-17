params ["_unit", ["_terminal", objNull]];
if (isNull _unit || {!alive _unit}) exitWith {false};
private _device = [_unit,["ItemcTab","ItemAndroid","ItemMicroDAGR"]] call cTab_fnc_checkGear;
private _toc = !isNull _terminal && {alive _terminal} && {_terminal getVariable ["SICS_toc",false]} && {_unit distance _terminal < 5} && {side group _unit == _terminal getVariable ["SICS_side",west]};
([_unit,_terminal] call SICS_fnc_devices) isNotEqualTo []

