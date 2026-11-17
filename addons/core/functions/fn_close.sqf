params [["_d",uiNamespace getVariable ["SICS_display",displayNull]]];
ATLAS_keysHeld=createHashMap;
if !(missionNamespace getVariable ["ATLAS_revokingSession",false]) then {[_d] call SICS_fnc_saveSession};
ATLAS_revokingSession=false;
if (!isNil "SICS_refreshHandle") then {[SICS_refreshHandle] call CBA_fnc_removePerFrameHandler; SICS_refreshHandle=nil};
uiNamespace setVariable ["SICS_display",displayNull];
[] call SICS_fnc_stopCamera;
[] call SICS_fnc_cameraClose;
if !(missionNamespace getVariable ["SICS_suspending",false]) then {SICS_deviceState="CLOSED"};

