disableSerialization;
private _d=findDisplay 87000;if (isNull _d) exitWith {};
if !( ["camera",true] call SICS_fnc_policy ) exitWith {hint "Camera is disabled by the mission.";[] call SICS_fnc_osHome};
{if (ctrlIDC _x>=2300 && {ctrlIDC _x<2400}) then {ctrlDelete _x}} forEach allControls _d;
(_d displayCtrl 2) ctrlSetText "SynapseOS / Camera";
ATLAS_cameraBuilding=true;
["SICS_Header",2300,[0.065,0.18,0.87,0.055],"CAMERA / PHOTO REPORTS"] call SICS_fnc_control;
private _pic=["RscPicture",2301,[0.065,0.26,0.59,0.48],""] call SICS_fnc_control;
private _list=["SICS_List",2302,[0.68,0.26,0.255,0.32]] call SICS_fnc_control;
{
    private _id=_x;private _meta=ATLAS_photoMeta get _id;private _allowed=(_meta select 4)==getPlayerUID player;
    if (!_allowed) then {
        private _record=ATLAS_photoRecords getOrDefault [_id,-1];
        _allowed=((missionNamespace getVariable ["SICS_localRecords",[]]) findIf {
            private _target=_x select 7;
            (_x select 0)==_record && {_target find "CH:"!=0 || {((missionNamespace getVariable ["SICS_clientChannels",[]]) findIf {(_x select 0)==_target})>=0}}
        })>=0;
    };
    if (_allowed) then {private _i=_list lbAdd (_meta select 0);_list lbSetData [_i,_id];if (_id==ATLAS_cameraSelected) then {_list lbSetCurSel _i}};
} forEach keys ATLAS_photoMeta;
_list ctrlAddEventHandler ["LBSelChanged",{params ["_list","_i"];if (_i<0 || {missionNamespace getVariable ["ATLAS_cameraBuilding",false]}) exitWith {};ATLAS_cameraSelected=_list lbData _i;[] call SICS_fnc_camera}];
private _live=["SICS_Button",2306,[0.68,0.69,0.255,0.065],"Live camera"] call SICS_fnc_control;
private _retry=["SICS_Button",2308,[0.68,0.61,0.255,0.065],"Upload / retry"] call SICS_fnc_control;
_retry ctrlAddEventHandler ["ButtonClick",{private _id=missionNamespace getVariable ["ATLAS_cameraSelected",""];private _meta=ATLAS_photoMeta getOrDefault [_id,[]];if (_meta isNotEqualTo [] && {_meta select 4==getPlayerUID player}) then {[_id] call SICS_fnc_photoUpload}}];
_live ctrlAddEventHandler ["ButtonClick",{ATLAS_cameraSelected="";[] call SICS_fnc_camera}];
["SICS_Edit",2307,[0.065,0.77,0.39,0.06],"Field photograph"] call SICS_fnc_control;
private _snap=["SICS_Button",2303,[0.47,0.77,0.185,0.06],"Snap picture"] call SICS_fnc_control;
_snap ctrlAddEventHandler ["ButtonClick",{[] call SICS_fnc_cameraSnap}];
private _attach=["SICS_Button",2304,[0.68,0.77,0.255,0.06],"Attach to report"] call SICS_fnc_control;
_attach ctrlAddEventHandler ["ButtonClick",{
    private _id=missionNamespace getVariable ["ATLAS_cameraSelected",""];
    if (_id=="") exitWith {hint "Snap or select a photograph first."};
    if !(ATLAS_photoUploaded getOrDefault [_id,false]) exitWith {hint "This photograph is still uploading, or was received from another operator."};
    ATLAS_reportPhoto=_id;["ATLAS"] call SICS_fnc_launchApp;if (SICS_tab!="REPORTS") then {SICS_tab="REPORTS";[] call SICS_fnc_page};
}];
private _status=["SICS_Text",2305,[0.065,0.85,0.87,0.065],"Pictures are shared only when attached to a report."] call SICS_fnc_control;
private _version="atlas_media" callExtension "version";
if (_version find "ATLAS_MEDIA"!=0) then {
    _status ctrlSetText "Camera requires the bundled atlas_media_x64.dll and Arma 3 2.22+.";_snap ctrlEnable false;_attach ctrlEnable false;
} else {
    if (ATLAS_cameraSelected=="") then {
        if (isNull(missionNamespace getVariable ["ATLAS_photoCamera",objNull])) then {
            ATLAS_photoCamera="camera" camCreate getPosATL player;
            ATLAS_photoCamera cameraEffect ["INTERNAL","BACK","ATLAS_CAM_PREVIEW"];ATLAS_photoCamera camSetFov 0.6;
            ATLAS_photoCameraPFH=[{
                private _camera=missionNamespace getVariable ["ATLAS_photoCamera",objNull];if (isNull _camera) exitWith {};
                private _eye=eyePos player;private _target=_eye vectorAdd ((eyeDirection player) vectorMultiply 1000);
                _camera camSetPos ASLToAGL (_eye vectorAdd ((eyeDirection player) vectorMultiply 0.3));_camera camSetTarget ASLToAGL _target;_camera camCommit 0;
            },0] call CBA_fnc_addPerFrameHandler;
        };
        _pic ctrlSetText "#(argb,512,256,1)r2t(ATLAS_CAM_PREVIEW,1)";
        _attach ctrlEnable false;
    } else {
        [] call SICS_fnc_cameraClose;
        private _info=("atlas_media" callExtension ["info",[ATLAS_cameraSelected]]) select 0;
        _snap ctrlEnable false;
        if (_info find "OK|"==0) then {_pic ctrlSetText format ['#(rgb,512,256,1)extension("atlas_media","%1",false,5)',ATLAS_cameraSelected]} else {
            _status ctrlSetText "Photo is outside the local cache. Reopen its report to download it again.";
        };
        private _meta=ATLAS_photoMeta getOrDefault [ATLAS_cameraSelected,[]];
        if (_meta isNotEqualTo []) then {(_d displayCtrl 2307) ctrlSetText (_meta select 0);(_d displayCtrl 2307) ctrlEnable false};
        _attach ctrlEnable (ATLAS_photoUploaded getOrDefault [ATLAS_cameraSelected,false]);
    };
};
ATLAS_cameraBuilding=false;[] call SICS_fnc_appHeader;[_d] call SICS_fnc_fitText;
