// Use cTab's own vehicle-class and seat rules on clients AND server.
params ["_unit"];
if (isNull _unit || {!alive _unit} || {vehicle _unit==_unit}) exitWith {false};
if (!( ["vehicles",true] call SICS_fnc_policy ) || {!(vehicle _unit getVariable ["ATLAS_consoleEnabled",true])}) exitWith {false};
private _classes=["vehicleClasses",[]] call SICS_fnc_policy;
if (_classes isNotEqualTo [] && {_classes findIf {vehicle _unit isKindOf _x}<0}) exitWith {false};
if (isNil "cTab_vehicleClass_has_FBCB2") then {cTab_vehicleClass_has_FBCB2=missionNamespace getVariable ["cTab_vehicleClass_has_FBCB2_server",["MRAP_01_base_F","MRAP_02_base_F","MRAP_03_base_F","Wheeled_APC_F","Tank","Truck_01_base_F","Truck_03_base_F"]]};
if (isNil "cTab_vehicleClass_has_TAD") then {cTab_vehicleClass_has_TAD=missionNamespace getVariable ["cTab_vehicleClass_has_TAD_server",["Helicopter","Plane"]]};
[_unit,vehicle _unit,if (vehicle _unit isKindOf "Air") then {"TAD"} else {"FBCB2"}] call cTab_fnc_unitInEnabledVehicleSeat

