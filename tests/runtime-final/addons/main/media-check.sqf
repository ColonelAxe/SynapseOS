disableSerialization;
private _log={params ["_name","_ok"];diag_log format ["ATLAS_MEDIA_TEST %1: %2",_name,["FAIL","PASS"] select _ok]};
["extension_version",("atlas_media" callExtension "version") find "ATLAS_MEDIA"==0] call _log;
["CAMERA"] call SICS_fnc_launchApp;sleep 1;
["camera_app",!isNull(findDisplay 87000 displayCtrl 2303)] call _log;
[] call SICS_fnc_cameraSnap;
private _deadline=diag_tickTime+9;waitUntil {sleep 0.1;!(missionNamespace getVariable ["ATLAS_captureBusy",false]) || {diag_tickTime>_deadline}};
private _id=missionNamespace getVariable ["ATLAS_cameraSelected",""];
diag_log format ["ATLAS_MEDIA_TEST capture id=%1 info=%2",_id,if (_id=="") then {"NONE"} else {"atlas_media" callExtension ["info",[_id]]}];
diag_log format ["ATLAS_MEDIA_TEST native diagnostics=%1","atlas_media" callExtension ["debug",[]]];
["camera_real_capture",_id!="" && {(("atlas_media" callExtension ["info",[_id]]) select 0) find "OK|"==0}] call _log;
if (_id!="") then {
    _deadline=diag_tickTime+8;waitUntil {sleep 0.1;ATLAS_photoUploaded getOrDefault [_id,false] || {diag_tickTime>_deadline}};
    ["photo_uploaded",ATLAS_photoUploaded getOrDefault [_id,false]] call _log;
    ATLAS_reportPhoto=_id;["ATLAS"] call SICS_fnc_launchApp;SICS_tab="REPORTS";[] call SICS_fnc_page;
    (findDisplay 87000 displayCtrl 106) ctrlSetText "Camera photo attachment runtime test";SICS_rate set [str owner player,-10];["REPORTS"] call SICS_fnc_submit;sleep 1.2;
    private _records=SICS_records select {_id in (_x param [12,[]])};
    ["report_photo_reference",_records isNotEqualTo []] call _log;
    if (_records isNotEqualTo []) then {
        "atlas_media" callExtension ["drop",[_id]];
        [(_records select 0) select 0,_id] call SICS_fnc_photoView;
        _deadline=diag_tickTime+8;waitUntil {sleep 0.2;(("atlas_media" callExtension ["info",[_id]]) select 0) find "OK|"==0 || {diag_tickTime>_deadline}};
        ["photo_download_roundtrip",(("atlas_media" callExtension ["info",[_id]]) select 0) find "OK|"==0] call _log;
        ["photo_extension_texture",(ctrlText(findDisplay 87000 displayCtrl 2301)) find "extension(">=0] call _log;
    };
};
["invalid_photo_id",(("atlas_media" callExtension ["begin",["../bad","1"]]) select 0) find "ERR"==0] call _log;
diag_log "ATLAS_MEDIA_TEST COMPLETE";
