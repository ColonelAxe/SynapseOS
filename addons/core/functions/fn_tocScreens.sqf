// Client-local render targets keep feeds available for joining players.
if (!hasInterface) exitWith {};
{
    private _settings=_x getVariable ["ATLAS_tocFeed",[]];
    if (_settings isNotEqualTo [] && {_x getVariable ["ATLAS_tocCamera",[]] isEqualTo []}) then {
        _settings params ["_source","_selection","_side"];
        if (!isNull _source && {alive _source} && {side group player==_side} && {_selection<count getObjectTextures _x}) then {
            ATLAS_tocCameraSequence=(missionNamespace getVariable ["ATLAS_tocCameraSequence",0])+1; private _target="ATLAS_TOC_"+str (ATLAS_tocCameraSequence);
            private _camera="camera" camCreate (getPosATL _source);
            _camera attachTo [_source,[0,-6,2.5]];
            _camera cameraEffect ["Internal","Back",_target];
            _camera camSetFov 0.72;_camera camCommit 0;
            _x setObjectTexture [_selection,format ["#(argb,512,512,1)r2t(%1,1)",_target]];
            _x setVariable ["ATLAS_tocCamera",[_camera,_source]];
            private _cameras=missionNamespace getVariable ["ATLAS_tocCameras",[]];_cameras pushBack [_x,_camera,_source,_target];ATLAS_tocCameras=_cameras;
        };
    };
} forEach (missionNamespace getVariable ["ATLAS_tocDisplays",[]]);
ATLAS_tocCameras=(missionNamespace getVariable ["ATLAS_tocCameras",[]]) select {
    _x params ["_screen","_camera","_source","_target"];
    if (isNull _screen || {!alive _screen} || {isNull _source} || {!alive _source} || {side group player!=((_screen getVariable ["ATLAS_tocFeed",[objNull,0,sideUnknown]]) select 2)}) then {
        _camera cameraEffect ["Terminate","Back",_target];camDestroy _camera;
        if (!isNull _screen) then {_screen setVariable ["ATLAS_tocCamera",[]];_screen setObjectTexture [(_screen getVariable ["ATLAS_tocFeed",[objNull,0]]) select 1,""]};false
    } else {true};
};
