if (!hasInterface) exitWith {};
private _sources=[] call SICS_fnc_isrSources;
private _allowed=_sources apply {[_x select 0,_x select 1]};
private _cameras=missionNamespace getVariable ["ATLAS_tocCameras",[]];
ATLAS_tocCameras=_cameras select {
    _x params ["_screen","_camera","_feed","_target"];
    _feed params ["_source","_selection","_side","_kind"];
    private _keep=!isNull _screen && {alive _screen} && {player distance _screen<100} && {side group player==_side} && {[_source,_kind] in _allowed} && {_feed isEqualTo (_screen getVariable ["ATLAS_tocFeed",[]])};
    if (!_keep) then {
        _camera cameraEffect ["Terminate","Back",_target];camDestroy _camera;
        if (!isNull _screen) then {_screen setVariable ["ATLAS_tocCamera",objNull];_screen setObjectTexture [_selection,_screen getVariable ["ATLAS_tocOriginal",""]]};
    };
    _keep
};
{
    private _screen=_x;
    if (!isNull _screen && {alive _screen} && {player distance _screen<100}) then {
        [_screen] call SICS_fnc_tocActions;
        private _feed=_screen getVariable ["ATLAS_tocFeed",[]];
        if (count _feed==4 && {isNull (_screen getVariable ["ATLAS_tocCamera",objNull])} && {count ATLAS_tocCameras<8}) then {
            _feed params ["_source","_selection","_side","_kind"];
            if (side group player==_side && {[_source,_kind] in _allowed} && {_selection<count getObjectTextures _screen}) then {
                ATLAS_tocCameraSequence=(missionNamespace getVariable ["ATLAS_tocCameraSequence",0])+1;
                private _target="ATLAS_TOC_"+str ATLAS_tocCameraSequence;
                private _camera="camera" camCreate (getPosATL _source);
                _camera cameraEffect ["Internal","Back",_target];_camera camSetFov 0.72;_camera camCommit 0;
                _screen setObjectTexture [_selection,format ["#(argb,512,512,1)r2t(%1,1)",_target]];
                _screen setVariable ["ATLAS_tocCamera",_camera];
                ATLAS_tocCameras pushBack [_screen,_camera,+_feed,_target];
            };
        };
    };
} forEach (missionNamespace getVariable ["ATLAS_tocDisplays",[]]);
