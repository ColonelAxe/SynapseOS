// Authoritative timestamps for the ATLAS feed, not simulated RF reception.
if (isRemoteExecuted) exitWith {};
if (!isServer || {!( ["tracking",true] call SICS_fnc_policy )}) exitWith {};
{
    private _side=_x;
    private _receivers=(allPlayers select {side group _x==_side && {[_x] call SICS_fnc_access}}) apply {owner _x};
    _receivers=_receivers arrayIntersect _receivers;
    if (_receivers isNotEqualTo []) then {
        private _objects=(vehicles select {!(_x isKindOf "Man") && {alive _x} && {crew _x isNotEqualTo []} && {side group effectiveCommander _x==_side}});
        _objects append (allUnits select {
            private _unit=_x;
            alive _unit && {side group _unit==_side} && {
                ((items _unit + assignedItems _unit) findIf {_x in ["ATLAS_Tablet","ATLAS_Phone","ItemcTab","ItemAndroid"]})>=0
            }
        });
        private _samples=(_objects select [0,512]) apply {[netId _x,getPosASL _x,getDir _x,speed _x,serverTime]};
        ["TRACK_SNAPSHOT",_samples] remoteExecCall ["SICS_fnc_receive",_receivers];
    };
} forEach [west,east,resistance,civilian];
