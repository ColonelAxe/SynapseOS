private _id=missionNamespace getVariable ["ATLAS_followRoute",""];if (_id=="") exitWith {[]};
private _e=(missionNamespace getVariable ["ATLAS_clientOperations",createHashMap]) getOrDefault [_id,[]];
if (_e isEqualTo [] || {count (_e select 9)<2} || {(_e select 1)!=side group player}) exitWith {ATLAS_followRoute="";[]};
private _points=_e select 9;private _next=(missionNamespace getVariable ["ATLAS_routeCheckpoint",0]) max 0;
if (_next>=count _points) exitWith {ATLAS_followRoute="";hint "Route complete.";[]};
if (player distance2D (_points select _next)<25) then {_next=_next+1;ATLAS_routeCheckpoint=_next};
if (_next>=count _points) exitWith {ATLAS_followRoute="";hint "Route complete.";[]};
private _distance=player distance2D (_points select _next);private _remaining=_distance;
for "_i" from (_next+1) to (count _points-1) do {_remaining=_remaining+((_points select (_i-1)) distance2D (_points select _i))};
private _speed=abs speed vehicle player;
if (_speed<2) then {_speed=(createHashMapFromArray (_e select 10)) getOrDefault ["speed",5]};
[_next,count _points,round _distance,round (player getDir (_points select _next)),ceil (_remaining/(_speed max 1)*0.06),round _remaining,+(_points select _next)]
