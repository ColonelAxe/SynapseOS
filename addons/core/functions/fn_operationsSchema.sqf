// [key,label,type,default,choices] - shared UI and server validation contract.
params ["_kind",["_unit",objNull]];
if (isNull _unit && {hasInterface}) then {_unit=player};
private _store=missionNamespace getVariable [["ATLAS_clientOperations","ATLAS_operations"] select isServer,createHashMap];
private _refs={
    params ["_wanted",["_route",false]];
    private _choices=[["","None"]];
    {private _d=createHashMapFromArray (_x select 10);if ((_x select 2)==_wanted && {!_route || {_d getOrDefault ["shape",""]=="ROUTE"}} && {[_unit,_x] call SICS_fnc_operationsAccess}) then {_choices pushBack [_x select 0,_x select 3]}} forEach values _store;
    _choices
};
private _photos=[["","None"]];
if (isServer) then {{private _p=ATLAS_serverPhotos get _x;if (_p select 1==getPlayerUID _unit && {_p select 8=="READY"} && {_p select 0==side group _unit}) then {_photos pushBack [_x,(_p select 5) select 0]}} forEach keys ATLAS_serverPhotos} else {
    {if (ATLAS_photoUploaded getOrDefault [_x,false]) then {_photos pushBack [_x,(ATLAS_photoMeta get _x) select 0]}} forEach keys (missionNamespace getVariable ["ATLAS_photoMeta",createHashMap]);
};
private _air=[["","Select aircraft"]];
private _assets=if (isServer) then {vehicles select {_x isKindOf "Air" && {alive _x} && {crew _x isNotEqualTo []} && {side group effectiveCommander _x==side group _unit}}} else {(missionNamespace getVariable ["cTabBFTvehicles",[]]) apply {_x select 0}};
if (vehicle _unit isKindOf "Air") then {_assets pushBackUnique vehicle _unit};
{if (_x isKindOf "Air" && {alive _x}) then {_air pushBack [netId _x,format ["%1 / %2",groupId group effectiveCommander _x,getText(configOf _x >> "displayName")]]}} forEach _assets;
switch _kind do {
    case "PLAN": {[["publication","Visibility","ENUM","DRAFT",["DRAFT","PUBLISHED"]],["notes","Briefing notes","TEXT","",[]]]};
    case "GRAPHIC": {[["plan","Operational overlay","REF","",["PLAN"] call _refs],["shape","Graphic type","ENUM","ROUTE",["ROUTE","PHASE LINE","BOUNDARY","OBJECTIVE","LZ"]],["colour","Colour","ENUM","ColorBlue",["ColorBlue","ColorRed","ColorGreen","ColorYellow","ColorOrange","ColorWhite"]],["speed","Planning speed (km/h)","NUMBER",5,[]],["notes","Instructions","TEXT","",[]]]};
    case "CONTACT": {
        private _symbols=[];{{_symbols pushBack [configName _x,getText(_x >> "name")]} forEach ([_x] call SICS_fnc_natoCatalog)} forEach ["BLUFOR","OPFOR","UNKNOWN","INDEPENDENT","CIVILIAN"];
        [["affiliation","Affiliation","ENUM","OPFOR",["BLUFOR","OPFOR","UNKNOWN","INDEPENDENT","CIVILIAN"]],["symbol","NATO symbol (match affiliation)","REF","o_inf",_symbols],["category","Element type","ENUM","Infantry",["Unknown","Infantry","Motorized","Wheeled vehicle","Armoured vehicle","Helicopter","Fixed-wing aircraft","UAV","Naval","Station / installation","Artillery","Logistics","Medical"]],["strength","Contact count","NUMBER",1,[]],["confidence","Confidence","ENUM","SUSPECTED",["SUSPECTED","OBSERVED","CONFIRMED"]],["age","Observation age (seconds)","NUMBER",0,[]],["ttl","Expiry (minutes)","NUMBER",30,[]],["heading","Observed direction (degrees)","NUMBER",0,[]],["photo","Observation photograph","REF","",_photos],["notes","Activity / observation","TEXT","",[]]]
    };
    case "SUPPORT": {[["type","Request type","ENUM","MEDEVAC",["MEDEVAC","CASEVAC","LOGISTICS"]],["casualties","Casualty / patient count","NUMBER",1,[]],["urgency","Urgency","ENUM","PRIORITY",["URGENT","PRIORITY","ROUTINE"]],["security","Site security","ENUM","UNCERTAIN",["SECURE","UNCERTAIN","HOSTILE"]],["landing","Landing / pickup details","TEXT","",[]],["notes","Equipment / assistance needed","TEXT","",[]]]};
    case "LZ": {[["availability","Landing-zone status","ENUM","OPEN",["OPEN","CAUTION","CLOSED"]],["size","Usable diameter (metres)","NUMBER",50,[]],["obstacles","Obstacles / approach hazards","TEXT","",[]],["wind","Wind direction (degrees)","NUMBER",0,[]],["marking","Marking / identification","TEXT","",[]],["security","Security","ENUM","UNCERTAIN",["SECURE","UNCERTAIN","HOSTILE"]],["photo","Observation photograph","REF","",_photos],["notes","Landing instructions","TEXT","",[]]]};
    case "AIR_TASK": {[["task","Aircraft task","ENUM","TRANSPORT",["TRANSPORT","ISR","CAS","MEDEVAC"]],["aircraft","Assigned aircraft","REF","",_air],["lz","Landing-zone card","REF","",["LZ"] call _refs],["ingress","Ingress route","REF","",["GRAPHIC",true] call _refs],["egress","Egress route","REF","",["GRAPHIC",true] call _refs],["notes","Coordination / restrictions","TEXT","",[]]]};
    default {[]};
}
