params ["_kind","_data"];
switch _kind do {
    case "PHOTO_ACCEPTED": {[_data,true] call SICS_fnc_photoUpload};
    case "PHOTO_READY": {if !(_data in ATLAS_photoMeta) exitWith {};ATLAS_photoUploaded set [_data,true];(findDisplay 87000 displayCtrl 2305) ctrlSetText "Photograph uploaded. Ready to attach to a report.";if (missionNamespace getVariable ["SICS_osApp",""]=="CAMERA" && {ATLAS_cameraSelected==_data}) then {[] call SICS_fnc_camera}};
    case "PHOTO_ATTACHED": {if (ATLAS_reportPhoto==_data) then {ATLAS_reportPhoto="";{(findDisplay 87000 displayCtrl _x) ctrlShow false} forEach [381,382]}};
    case "PHOTO_BEGIN": {
        _data params ["_id","_n","_meta","_record"];
        private _allowed=(missionNamespace getVariable ["SICS_localRecords",[]]) findIf {(_x select 0)==_record && {(_x select 1)==side group player} && {_id in (_x param [12,[]])} && {private _target=_x select 7;_target find "CH:"!=0 || {SICS_clientChannels findIf {(_x select 0)==_target}>=0}}};
        if (_allowed<0) exitWith {};
        ATLAS_photoMeta set [_id,_meta];ATLAS_photoRecords set [_id,_record];
        private _result=("atlas_media" callExtension ["begin",[_id,str _n]]) select 0;
        if (isNil "ATLAS_photoSkip") then {ATLAS_photoSkip=createHashMap};ATLAS_photoSkip set [_id,_result=="READY"];
    };
    case "PHOTO_CHUNK": {_data params ["_id","_index","_chunk"];if (_id in ATLAS_photoMeta && {!(ATLAS_photoSkip getOrDefault [_id,false])}) then {"atlas_media" callExtension ["put",[_id,str _index,_chunk]]}};
    case "PHOTO_END": {
        if !(_data in ATLAS_photoMeta) exitWith {};
        private _ok=if (ATLAS_photoSkip getOrDefault [_data,false]) then {true} else {(("atlas_media" callExtension ["finish",[_data]]) select 0)=="OK"};
        if (_ok && {missionNamespace getVariable ["SICS_osApp",""]=="CAMERA"}) then {[] call SICS_fnc_camera};
        if (!_ok) then {hint "Photograph transfer failed validation. Request it again from the report."};
    };
};
