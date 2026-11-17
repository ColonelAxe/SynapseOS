ATLAS_streamGeneration=(missionNamespace getVariable ["ATLAS_streamGeneration",0])+1;
[] call cTab_fnc_deleteUAVcam;
[] call cTab_fnc_deleteHelmetCam;
SICS_cameraActive=false;ATLAS_streamSource=objNull;
if (!isNil "ATLAS_streamHandle" && {!scriptDone ATLAS_streamHandle}) then {terminate ATLAS_streamHandle};
