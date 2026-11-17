ATLAS_captureGeneration=(missionNamespace getVariable ["ATLAS_captureGeneration",0])+1;
ATLAS_captureBusy=false;
private _pending=missionNamespace getVariable ["ATLAS_pendingCapture",""];
if (_pending!="") then {"atlas_media" callExtension ["drop",[_pending]]};ATLAS_pendingCapture="";
if (!isNil "ATLAS_photoCameraPFH") then {[ATLAS_photoCameraPFH] call CBA_fnc_removePerFrameHandler;ATLAS_photoCameraPFH=nil};
if (!isNil "ATLAS_captureEH") then {removeMissionEventHandler ["Draw3D",ATLAS_captureEH];ATLAS_captureEH=nil};
private _cam=missionNamespace getVariable ["ATLAS_photoCamera",objNull];
if (!isNull _cam) then {_cam cameraEffect ["TERMINATE","BACK"];camDestroy _cam};
ATLAS_photoCamera=objNull;
