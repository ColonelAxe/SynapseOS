params ["_recordId","_id"];
ATLAS_cameraSelected=_id;
[player,"PHOTO_GET",[_recordId,_id],SICS_terminal] remoteExecCall ["SICS_fnc_server",2];
["CAMERA"] call SICS_fnc_launchApp;
