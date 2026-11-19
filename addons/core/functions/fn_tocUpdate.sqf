{
    _x params ["_screen","_camera","_feed"];
    _feed params ["_source","_selection","_side","_kind"];
    if (!isNull _camera && {!isNull _source} && {alive _source}) then {
        private _position=if (_kind=="HELMET") then {ASLToAGL eyePos _source} else {_source modelToWorld [0,-6,2.5]};
        private _direction=if (_kind=="HELMET") then {eyeDirection _source} else {vectorDir _source};
        _camera camSetPos _position;
        _camera camSetTarget (_position vectorAdd (_direction vectorMultiply 100));
        _camera camCommit 0;
    };
} forEach (missionNamespace getVariable ["ATLAS_tocCameras",[]]);
