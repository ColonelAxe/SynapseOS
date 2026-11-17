params ["_unit"];
private _profile=_unit getVariable ["ATLAS_profile",[]];
if (_profile isEqualTo []) then {_profile=[name _unit,"Rifleman",rank _unit]};
_profile
