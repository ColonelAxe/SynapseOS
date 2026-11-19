private _log={params ["_name","_ok"];diag_log format ["ATLAS_HATCHET_TEST %1: %2",_name,["FAIL","PASS"] select _ok]};
private _patch=configFile >> "CfgPatches" >> "sics_hatchet";
if !(isClass _patch) exitWith {diag_log "ATLAS_HATCHET_TEST SKIP: optional adapter is not loaded"};
private _base=configFile >> "CfgVehicles" >> "vtx_H60_base";
private _checks=[
    [_base >> "hct_driver" >> "interaction" >> "MFD_3" >> "mfd_any" >> "tac" >> "SynapseOS_ATLAS_TAD","B_MFD3_24"],
    [_base >> "hct_driver" >> "interaction" >> "MFD_4" >> "mfd_any" >> "tac" >> "SynapseOS_ATLAS_TAD","B_MFD4_24"],
    [_base >> "hct_copilot" >> "interaction" >> "MFD_1" >> "mfd_any" >> "tac" >> "SynapseOS_ATLAS_TAD","B_MFD1_24"],
    [_base >> "hct_copilot" >> "interaction" >> "MFD_2" >> "mfd_any" >> "tac" >> "SynapseOS_ATLAS_TAD","B_MFD2_24"]
];
private _all=true;
{
    _x params ["_action","_selection"];
    private _exists=isClass _action;
    private _position=getText (_action >> "position");
    private _label=getText (_action >> "label");
    private _code=getText (_action >> "buttonUp");
    private _ok=_exists && {_position==_selection} && {_label=="ATLAS TAD"} && {_code find "SICS_fnc_hatchetOpen">=0};
    [format ["mfd_action_%1",_selection],_ok] call _log;
    _all=_all && _ok;
} forEach _checks;
private _vehicle=missionNamespace getVariable ["SICS_testHatchet",objNull];
["test_airframe_spawned",!isNull _vehicle && {typeOf _vehicle=="vtx_MH60M"}] call _log;
if (!isNull _vehicle) then {
    ["pilot_seat",driver _vehicle==player] call _log;
    ["pilot_gets_aviation_access",[player] call SICS_fnc_vehicleAccess] call _log;
    ["pilot_gets_aviation_layout","AVIATION" in ([player] call SICS_fnc_devices)] call _log;
};

// Execute the same callback compiled from the MFD config and verify its UI path.
if (_all && {!isNull _vehicle} && {driver _vehicle==player}) then {
    if (!isNull findDisplay 87000) then {["POWER"] call SICS_fnc_toggleDevice;waitUntil {sleep 0.05;isNull findDisplay 87000}};
    private _callback=compile getText (((_checks select 0) select 0) >> "buttonUp");
    private _deadline=diag_tickTime+8;
    call _callback;
    waitUntil {sleep 0.05;!isNull findDisplay 87000 || {diag_tickTime>_deadline}};
    ["mfd_action_opens_atlas",!isNull findDisplay 87000 && {SICS_deviceMode=="AVIATION"}] call _log;
};
