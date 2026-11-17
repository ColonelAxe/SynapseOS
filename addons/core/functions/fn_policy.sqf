params ["_key",["_fallback",true]];
private _policy=missionNamespace getVariable [["ATLAS_missionPolicy","ATLAS_serverPolicy"] select isServer,createHashMap];
_policy getOrDefault [_key,_fallback]
