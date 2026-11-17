disableSerialization;
params ["_id"];
private _app=SYNAPSE_apps getOrDefault [_id,[]];
if (_app isEqualTo [] || {!([] call (_app select 4))}) exitWith {hint "Application unavailable."};
private _d=findDisplay 87000;if (isNull _d) exitWith {};
if (missionNamespace getVariable ["SICS_osApp",""]=="CAMERA" && {_id!="CAMERA"}) then {[] call SICS_fnc_cameraClose};
if (missionNamespace getVariable ["SICS_osApp",""]=="ATLAS" && {_id!="ATLAS"}) then {[] call SICS_fnc_stopCamera};
[_d] call SICS_fnc_saveSession;
SICS_osApp=_id;SICS_osLastApp=_id;
(_d displayCtrl 92) ctrlShow false;
if (_id=="ATLAS") exitWith {[] call SICS_fnc_resumeSession};
{if (ctrlIDC _x>=100) then {ctrlDelete _x}} forEach allControls _d;
{if (!(ctrlIDC _x in [2,3,4,5,6,7,8,90,92])) then {_x ctrlShow false}} forEach allControls _d;
{(_d displayCtrl _x) ctrlShow true} forEach [7,8];
[_d,SICS_deviceMode] call (_app select 3);
[] call SICS_fnc_appHeader;

