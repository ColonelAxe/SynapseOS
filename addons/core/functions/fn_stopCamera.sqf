ATLAS_streamGeneration=(missionNamespace getVariable ["ATLAS_streamGeneration",0])+1;
private _camera=missionNamespace getVariable ["ATLAS_isrCamera",objNull];
if (!isNull _camera) then {
    _camera cameraEffect ["Terminate","Back","SICS_ISR"];
    camDestroy _camera;
};
missionNamespace setVariable ["ATLAS_isrCamera",objNull];
SICS_cameraActive=false;
ATLAS_streamSource=objNull;
if (!isNil "ATLAS_streamHandle" && {!scriptDone ATLAS_streamHandle}) then {terminate ATLAS_streamHandle};
true
