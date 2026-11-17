if (missionNamespace getVariable ["ATLAS_captureBusy",false] || {isNull(missionNamespace getVariable ["ATLAS_photoCamera",objNull])}) exitWith {false};
private _caption=trim ctrlText(findDisplay 87000 displayCtrl 2307);
if (count _caption<1 || {count _caption>80}) exitWith {hint "Use a photo caption of 1–80 characters.";false};
ATLAS_captureBusy=true;
ATLAS_captureGeneration=(missionNamespace getVariable ["ATLAS_captureGeneration",0])+1;
[_caption,ATLAS_captureGeneration,player,side group player,getPosASL player,getDir player] spawn {
    params ["_caption","_generation","_operator","_side","_position","_heading"];disableSerialization;
    private _id=format ["P_%1_%2_%3",owner player,(diag_tickTime*1000) toFixed 0,(random 1000000000) toFixed 0];
    private _cam=ATLAS_photoCamera;
    private _valid={ATLAS_captureGeneration==_generation && {!isNull _cam} && {player==_operator} && {side group player==_side} && {missionNamespace getVariable ["SICS_osApp",""]=="CAMERA"}};
    private _abort={"atlas_media" callExtension ["drop",[_id]];if (ATLAS_captureGeneration==_generation) then {ATLAS_captureBusy=false;ATLAS_pendingCapture=""}};
    _cam cameraEffect ["INTERNAL","BACK",_id];
    (findDisplay 87000 displayCtrl 2301) ctrlSetText format ["#(argb,512,256,1)r2t(%1,1)",_id];
    (findDisplay 87000 displayCtrl 2305) ctrlSetText "Capturing photograph...";
    sleep 0.35;
    if !(call _valid) exitWith {call _abort};
    ATLAS_pendingCapture=_id;ATLAS_captureResult="WAIT";
    ATLAS_captureEH=addMissionEventHandler ["Draw3D",{
        private _id=missionNamespace getVariable ["ATLAS_pendingCapture",""];
        if (_id!="") then {ATLAS_captureResult=("atlas_media" callExtension ["capture",[_id]]) select 0};
        removeMissionEventHandler ["Draw3D",_thisEventHandler];ATLAS_captureEH=nil;
    }];
    private _result="WAIT";private _deadline=diag_tickTime+1;
    waitUntil {sleep 0.1;_result=("atlas_media" callExtension ["info",[_id]]) select 0;_result find "OK|"==0 || {ATLAS_captureResult find "ERR"==0} || {diag_tickTime>_deadline} || {!(call _valid)}};
    if !(call _valid) exitWith {call _abort};
    if (_result find "OK|"!=0 && {!isNull _cam}) then {
        // The engine screenshot captures only the 3D scene, never Windows/UI pixels.
        _cam cameraEffect ["INTERNAL","BACK"];sleep 0.2;
        private _saved=false;if (call _valid) then {_saved=screenshot format ["ATLAS\%1.png",_id]};
        diag_log format ["ATLAS_CAMERA screenshot fallback=%1 id=%2",_saved,_id];
        sleep 0.2;if (call _valid) then {_cam cameraEffect ["TERMINATE","BACK"];_cam cameraEffect ["INTERNAL","BACK",_id]};
        if (_saved && {call _valid}) then {
            _deadline=diag_tickTime+4;
            waitUntil {sleep 0.1;private _import=("atlas_media" callExtension ["import",[_id]]) select 0;_import=="OK" || {diag_tickTime>_deadline} || {!(call _valid)}};
            _result=("atlas_media" callExtension ["info",[_id]]) select 0;
        };
    };
    if !(call _valid) exitWith {call _abort};
    if (_result find "OK|"!=0) exitWith {"atlas_media" callExtension ["drop",[_id]];ATLAS_captureBusy=false;hint "Capture failed. Confirm Arma 3 2.22, PiP and the bundled media extension are available.";if (SICS_osApp=="CAMERA") then {ATLAS_cameraSelected="";[] call SICS_fnc_camera}};
    ATLAS_photoMeta set [_id,[_caption,_position,_heading,serverTime,getPlayerUID player]];
    ATLAS_cameraSelected=_id;ATLAS_captureBusy=false;ATLAS_pendingCapture="";
    [] call SICS_fnc_cameraClose;
    if (missionNamespace getVariable ["SICS_osApp",""]=="CAMERA" && {!isNull findDisplay 87000}) then {[] call SICS_fnc_camera};
    [_id] call SICS_fnc_photoUpload;
};
true
