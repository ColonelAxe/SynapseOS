// Authoritative timestamps for the ATLAS feed, not simulated RF reception.
if (isRemoteExecuted) exitWith {};
if (!isServer || {!( ["tracking",true] call SICS_fnc_policy )}) exitWith {};
{
    private _side=_x;
    private _receivers=(allPlayers select {side group _x==_side && {[_x] call SICS_fnc_access}}) apply {owner _x};
    _receivers=_receivers arrayIntersect _receivers;
    if (_receivers isNotEqualTo []) then {
        private _objects=(vehicles select {!(_x isKindOf "Man") && {alive _x} && {crew _x isNotEqualTo []} && {side group effectiveCommander _x==_side}});
        _objects append (allUnits select {alive _x && {side group _x==_side} && {[_x,["ItemcTab","ItemAndroid"]] call cTab_fnc_checkGear}});
        private _samples=(_objects select [0,512]) apply {[netId _x,getPosASL _x,getDir _x,speed _x,serverTime]};
        ["TRACK_SNAPSHOT",_samples] remoteExecCall ["SICS_fnc_receive",_receivers];
    };
} forEach [west,east,resistance,civilian];
