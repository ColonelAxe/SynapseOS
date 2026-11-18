params ["_action"];
if (!hasInterface || {missionNamespace getVariable ["SICS_transitionActive",false]}) exitWith {false};
private _full=!isNull findDisplay 87000;
if (_action=="MAIN") exitWith {
    if (_full) then {["MINIMIZE"] call SICS_fnc_toggleDevice} else {
        if (missionNamespace getVariable ["SICS_quickActive",false]) then {["CLOSE"] call SICS_fnc_toggleDevice} else {["MINI"] call SICS_fnc_toggleDevice};
    };true
};
if (_full && {missionNamespace getVariable ["ATLAS_interfaceRole","SECONDARY"]==_action}) exitWith {["CLOSE"] call SICS_fnc_toggleDevice;true};
private _terminal=missionNamespace getVariable ["SICS_terminal",objNull];
private _available=[player,_terminal] call SICS_fnc_devices;
if (_available isEqualTo []) exitWith {false};
private _mode=_available select 0;
if (_action=="TERTIARY") then {
    private _personal=["TABLET","PHONE","PORTABLE"] select {_x in _available};
    if (_personal isNotEqualTo []) then {_mode=_personal select 0};
} else {
    if ("WORKSTATION" in _available) then {_mode="WORKSTATION"} else {
        if !([player] call SICS_fnc_vehicleAccess) then {private _preferred=missionNamespace getVariable ["SICS_preferredDevice",""];if (_preferred in _available) then {_mode=_preferred}};
    };
};
if (_full) then {
    ["CLOSE"] call SICS_fnc_toggleDevice;
    [_mode,_action,_terminal] spawn {
        params ["_mode","_role","_terminal"];
        waitUntil {sleep 0.01;!(missionNamespace getVariable ["SICS_transitionActive",false])};
        [_terminal,_mode,missionNamespace getVariable ["SICS_osLastApp","HOME"]] call SICS_fnc_open;
        ATLAS_interfaceRole=_role;
    };
} else {
    [_terminal,_mode,missionNamespace getVariable ["SICS_osLastApp","HOME"]] call SICS_fnc_open;
    ATLAS_interfaceRole=_action;
};
true
