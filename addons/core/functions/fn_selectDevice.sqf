// Explicit player choice, also used by optional ACE self-actions.
disableSerialization;
params ["_mode"];
if (!hasInterface || {missionNamespace getVariable ["SICS_transitionActive",false]}) exitWith {false};
private _terminal=missionNamespace getVariable ["SICS_terminal",objNull];
if !(_mode in ([player,_terminal] call SICS_fnc_devices)) exitWith {hint "You are not carrying that ATLAS device.";false};
if (_mode in ["PHONE","TABLET","PORTABLE"]) then {SICS_preferredDevice=_mode};
if (!isNull findDisplay 87001 || {!isNull findDisplay 87002}) exitWith {hint "Finish or cancel the open form before changing devices.";false};
if (!isNull findDisplay 87000) then {
    [findDisplay 87000] call SICS_fnc_saveSession;
    [_mode] call SICS_fnc_deviceLayout;
    if (SICS_osApp=="ATLAS") then {[] call SICS_fnc_resumeSession};
} else {
    [_terminal,_mode,missionNamespace getVariable ["SICS_osLastApp","HOME"]] call SICS_fnc_open;
};
!isNull findDisplay 87000
