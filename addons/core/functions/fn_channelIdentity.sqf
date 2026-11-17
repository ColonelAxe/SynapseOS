params ["_unit"];
if (isNull _unit || {!isPlayer _unit}) exitWith {""};
private _uid=getPlayerUID _unit;
if (_uid=="" && {!isMultiplayer}) then {_uid="SICS_LOCAL_PLAYER"};
_uid

