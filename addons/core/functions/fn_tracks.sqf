// Positions are sampled from cTab-authorised objects. No enemy discovery.
if (diag_tickTime-(missionNamespace getVariable ["SICS_trackTick",-10])<1) exitWith {};
SICS_trackTick=diag_tickTime;
if (isNil "SICS_tracks") then {SICS_tracks=createHashMap};
private _entries=+(missionNamespace getVariable ["cTabBFTvehicles",[]]);
if (!isNull objectParent player) then {_entries pushBack [vehicle player,"","",groupId group player,""]};
private _keys=[];
{
    private _v=_x select 0;
    if (!isNull _v && {alive _v} && {_v isKindOf "AllVehicles"} && {!(_v isKindOf "Man")} && {crew _v isNotEqualTo []}) then {
        private _key=str _v;_keys pushBackUnique _key;
        private _old=SICS_tracks getOrDefault [_key,[_v,[],"",""]];
        private _trail=(_old select 1) select {diag_tickTime-(_x select 1)<20};
        private _pos=getPosASLVisual _v;
        if (_trail isEqualTo [] || {((_trail select -1) select 0) distance2D _pos>1}) then {_trail pushBack [_pos,diag_tickTime]};
        if (count _trail>8) then {_trail deleteAt 0};
        private _kind=call {if (_v isKindOf "Plane") exitWith {"FIXED WING"};if (_v isKindOf "Helicopter") exitWith {"ROTARY WING"};if (_v isKindOf "Ship") exitWith {"NAVAL"};if (_v isKindOf "Tank") exitWith {"ARMOURED"};"GROUND"};
        SICS_tracks set [_key,[_v,_trail,_kind,_x select 3]];
    };
} forEach _entries;
{if !(_x in _keys) then {SICS_tracks deleteAt _x}} forEach keys SICS_tracks;

