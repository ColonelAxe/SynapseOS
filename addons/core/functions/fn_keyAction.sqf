params ["_id",["_release",false]];
if (isNil "ATLAS_keysHeld") then {ATLAS_keysHeld=createHashMap};
if (_release) exitWith {ATLAS_keysHeld set [_id,false];false};
if (ATLAS_keysHeld getOrDefault [_id,false]) exitWith {true};
ATLAS_keysHeld set [_id,true];
switch _id do {
    case "ifMain": {["MAIN"] call SICS_fnc_interfaceAction};
    case "ifSecondary": {["SECONDARY"] call SICS_fnc_interfaceAction};
    case "ifTertiary": {["TERTIARY"] call SICS_fnc_interfaceAction};
    case "zoomIn": {[-1] call SICS_fnc_mapZoom};
    case "zoomOut": {[1] call SICS_fnc_mapZoom};
    case "toggleIfPosition": {[] call SICS_fnc_interfacePosition};
};
true
