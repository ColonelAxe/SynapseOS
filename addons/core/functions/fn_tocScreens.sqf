if (!hasInterface || {isNull player}) exitWith {};
private _sources=[] call SICS_fnc_isrSources;
private _allowed=_sources apply {[_x select 0,_x select 1]};
private _cameras=missionNamespace getVariable ["ATLAS_tocCameras",[]];
ATLAS_tocCameras=_cameras select {
    _x params ["_screen","_camera","_feed","_target"];
    _feed params ["_source","_selection","_side","_kind"];
    private _keep=!isNull _screen && {alive _screen} && {player distance _screen<100} && {side group player==_side} && {[_source,_kind] in _allowed} && {_feed isEqualTo (_screen getVariable ["ATLAS_tocFeed",[]])};
    if (!_keep) then {
        _camera cameraEffect ["Terminate","Back",_target];camDestroy _camera;
        if (!isNull _screen) then {
            _screen setVariable ["ATLAS_tocCamera",objNull];
            if (_screen getVariable ["ATLAS_managedBriefing",false]) then {
                _screen setVariable ["ATLAS_tocBaseTexture",nil];
                _screen setObjectTexture [_selection,"#(rgb,8,8,3)color(0.02,0.04,0.06,1)"];
            } else {
                _screen setObjectTexture [_selection,_screen getVariable ["ATLAS_tocOriginal",""]];
            };
        };
    };
    _keep
};
{
    private _screen=_x;
    if (!isNull _screen && {alive _screen} && {player distance _screen<100}) then {
        if !(_screen getVariable ["ATLAS_mapControlAction",false]) then {
    _screen setVariable ["ATLAS_mapControlAction",true];
    _screen addAction ["SynapseOS / Control monitor map",{params ["_target"];["OPEN",_target] call SICS_fnc_tocMap},nil,1.7,true,true,"","alive _target && {side group _this==(_target getVariable ['ATLAS_briefSide',sideUnknown])}",5];
};
        private _managed = _screen getVariable ["ATLAS_managedBriefing",false];
        if (!_managed) then {[_screen] call SICS_fnc_tocActions};
        private _feed=_screen getVariable ["ATLAS_tocFeed",[]];
        if (count _feed==4 && {isNull (_screen getVariable ["ATLAS_tocCamera",objNull])}) then {
            _feed params ["_source","_selection","_side","_kind"];
            if (_managed && {_selection<count getObjectTextures _screen}) then {
                private _texture = "#(rgb,8,8,3)color(0.02,0.04,0.06,1)";
                private _name = _screen getVariable ["ATLAS_briefName",""];
                if (_kind=="MAP" && {_name!=""} && {side group player==_side}) then {
                    _texture = format ['#(rgb,2048,2048,1)ui("ATLAS_BriefDisplay","%1")',_name];
                };
                if (_texture != (_screen getVariable ["ATLAS_tocBaseTexture",""])) then {
                    _screen setObjectTexture [_selection,_texture];
                    _screen setVariable ["ATLAS_tocBaseTexture",_texture];
                };
            };
            if (count ATLAS_tocCameras<8 && {side group player==_side} && {[_source,_kind] in _allowed} && {_selection<count getObjectTextures _screen}) then {
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
{
    if (!isNull _x && {player distance _x<100} && {!isNil {_x getVariable "ATLAS_tocSlots"}}) then {
        if !(_x getVariable ["SICS_actionAdded",false]) then {
            [_x,_x getVariable ["SICS_side",west],"TOC ATLAS"] call SICS_fnc_registerTOC;
        };
        if !(_x getVariable ["ATLAS_tocConsoleAction",false]) then {
            _x setVariable ["ATLAS_tocConsoleAction",true];
            _x addAction ["ATLAS / TOC Displays",{
                params ["_target"];
                ["OPEN",_target] call SICS_fnc_tocConsole;
            },nil,1.6,true,true,"","alive _this && {alive _target} && {side group _this == (_target getVariable ['SICS_side',sideUnknown])}",5];
        };
    };
} forEach (missionNamespace getVariable ["ATLAS_tocMasters",[]]);
["UPDATE"] call SICS_fnc_tocConsole;
