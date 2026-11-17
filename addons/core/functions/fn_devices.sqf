params ["_unit",["_terminal",objNull]];
private _devices=[];
if ([_unit] call SICS_fnc_vehicleAccess) then {_devices pushBack (if (vehicle _unit isKindOf "Air") then {"AVIATION"} else {"VEHICLE"})};
private _gear=items _unit+assignedItems _unit;
if (_gear arrayIntersect ["ATLAS_Phone","ItemcTab","ItemAndroid"] isNotEqualTo []) then {_devices pushBackUnique "PHONE"};
if ([_unit,["ItemMicroDAGR"]] call cTab_fnc_checkGear) then {_devices pushBackUnique "PORTABLE"};
if (_gear arrayIntersect ["ATLAS_Tablet","ItemcTab"] isNotEqualTo []) then {_devices pushBackUnique "TABLET"};
if (!isNull _terminal && {alive _terminal} && {_terminal getVariable ["SICS_toc",false]} && {_unit distance _terminal<5} && {side group _unit==_terminal getVariable ["SICS_side",west]}) then {_devices pushBack "WORKSTATION"};
_devices select {switch _x do {case "TABLET":{["tablet",true] call SICS_fnc_policy};case "PHONE":{["phone",true] call SICS_fnc_policy};case "PORTABLE":{["portable",true] call SICS_fnc_policy};default {true}}}

