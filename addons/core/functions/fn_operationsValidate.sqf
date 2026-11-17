// Never evaluate client-provided strings. Reject unknown keys and malformed geometry.
params ["_unit","_kind","_title","_target","_position","_points","_pairs"];
private _schema=[_kind,_unit] call SICS_fnc_operationsSchema;
if (_schema isEqualTo [] || {!(_title isEqualType "")} || {count trim _title<1} || {count _title>48} || {!(_target isEqualType "")}) exitWith {[false,"Invalid type, title or recipient",[]]};
if (_target!="" && {allGroups findIf {netId _x==_target && {side _x==side group _unit}}<0}) exitWith {[false,"Recipient is not a friendly group",[]]};
private _pointValid={params ["_p"];_p isEqualType [] && {count _p in [2,3]} && {_p findIf {!(_x isEqualType 0) || {!finite _x} || {abs _x>10000000}}<0}};
if !([_position] call _pointValid) exitWith {[false,"Invalid map position",[]]};
if (!(_points isEqualType []) || {count _points>64} || {_points findIf {!([_x] call _pointValid)}>=0}) exitWith {[false,"Invalid route geometry (maximum 64 points)",[]]};
if (!(_pairs isEqualType []) || {count _pairs>16} || {_pairs findIf {!(_x isEqualType []) || {count _x!=2} || {!((_x select 0) isEqualType "")}}>=0}) exitWith {[false,"Invalid fields",[]]};
private _keys=_pairs apply {_x select 0};
if (count (_keys arrayIntersect _keys)!=count _keys || {_keys findIf {!(_x in (_schema apply {_x select 0}))}>=0}) exitWith {[false,"Unknown or duplicate field",[]]};
private _data=createHashMapFromArray _pairs;private _error="";
private _limits=createHashMapFromArray [["speed",[1,250]],["strength",[1,9999]],["age",[0,86400]],["ttl",[1,1440]],["heading",[0,359]],["casualties",[0,99]],["size",[10,1000]],["wind",[0,359]]];
{
    _x params ["_key","_label","_type","_default","_choices"];
    private _value=_data getOrDefault [_key,_default];
    if (_type=="NUMBER") then {
        private _range=_limits getOrDefault [_key,[0,9999]];
        if (!(_value isEqualType 0) || {!finite _value} || {_value<(_range select 0)} || {_value>(_range select 1)} || {_value!=floor _value}) then {_error="Invalid "+_label};
    } else {
        if (!(_value isEqualType "") || {count _value>700}) then {_error="Invalid "+_label} else {
            if (_type=="ENUM" && {!(_value in _choices)}) then {_error="Invalid "+_label};
            if (_type=="REF" && {_choices findIf {(_x select 0)==_value}<0}) then {_error="Unavailable "+_label};
        };
    };
    _data set [_key,_value];
} forEach _schema;
if (_error!="") exitWith {[false,_error,[]]};
if (_kind=="GRAPHIC") then {
    if (_data get "plan"=="") then {_error="Create/select an operational overlay first"};
    private _minimum=switch (_data get "shape") do {case "ROUTE":{2};case "PHASE LINE":{2};case "BOUNDARY":{3};default {1}};
    if (count _points<_minimum) then {_error=format ["This graphic needs at least %1 map points",_minimum]};
};
if (_kind=="CONTACT" && {([_data get "affiliation"] call SICS_fnc_natoCatalog) findIf {configName _x==_data get "symbol"}<0}) then {_error="NATO symbol does not match affiliation"};
if (_kind=="AIR_TASK" && {_data get "aircraft"==""}) then {_error="Select a crewed friendly aircraft"};
[_error=="",_error,(keys _data) apply {[_x,_data get _x]}]
