params ["_object"];
if (_object==player || {_object==vehicle player}) exitWith {["LIVE",0,getPosASLVisual _object,getDirVisual _object,speed _object]};
private _sample=(missionNamespace getVariable ["ATLAS_networkTracks",createHashMap]) getOrDefault [netId _object,[]];
if (_sample isEqualTo []) exitWith {["UNVERIFIED",-1,getPosASLVisual _object,getDirVisual _object,speed _object]};
private _age=(serverTime-(_sample select 4)) max 0;
if (_age<=15) exitWith {["LIVE",_age,getPosASLVisual _object,getDirVisual _object,speed _object]};
[["STALE","LOST FEED"] select (_age>45),_age,+(_sample select 1),_sample select 2,_sample select 3]
