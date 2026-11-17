// Shared pure policy; server state is authoritative. AI cannot receive player grants.
params ["_unit","_channel",["_manage",false]];
if (isNull _unit || {count _channel<8} || {side group _unit!=(_channel select 1)}) exitWith {false};
private _uid=[_unit] call SICS_fnc_channelIdentity;
private _manager=_uid!="" && {_uid==(_channel select 4) || {_uid in (_channel select 7)}};
if (_manage) exitWith {_manager};
_manager || {_uid!="" && {_uid in (_channel select 5)}} || {netId group _unit in (_channel select 6)}

