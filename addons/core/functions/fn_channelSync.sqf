if (!isServer) exitWith {};
params ["_unit",["_force",false]];
[_unit,_force] call SICS_fnc_operationsSync;
private _channels=(values SICS_channels) select {[_unit,_x] call SICS_fnc_channelAccess};
private _roster=(allPlayers select {side group _x==side group _unit}) apply {[[_x] call SICS_fnc_channelIdentity,([_x] call SICS_fnc_profile) select 0,groupId group _x,netId group _x]};
private _canCreate=_unit getVariable ["ATLAS_commander",_unit getVariable ["SICS_commander",false]];
private _signature=str [_channels,_roster,_canCreate];private _key=str owner _unit;
if (!_force && {SICS_channelSignatures getOrDefault [_key,""]==_signature}) exitWith {};
SICS_channelSignatures set [_key,_signature];
["CHANNELS",[_channels,_roster,_canCreate]] remoteExecCall ["SICS_fnc_receive",owner _unit];
// Silent replay also purges cached records when membership is revoked.
["SYNC",SICS_records select {[_unit,_x] call SICS_fnc_recordAccess}] remoteExecCall ["SICS_fnc_receive",owner _unit];


