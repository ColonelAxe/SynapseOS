params ["_source","_kind"];
private _permission=[["drone","helmet"] select (_kind=="HELMET"),true] call SICS_fnc_policy;
if (!_permission) exitWith {hint "This sensor type is disabled by the mission.";false};
private _sources=[] call SICS_fnc_isrSources;
if (isNull _source || {(_sources findIf {(_x select 0)==_source && {(_x select 1)==_kind}})<0}) exitWith {hint "That feed is no longer available to your side.";false};
[] call SICS_fnc_stopCamera;
ATLAS_streamSource=_source;ATLAS_streamKind=_kind;
private _generation=missionNamespace getVariable ["ATLAS_streamGeneration",0];
ATLAS_streamHandle=[_source,_kind,_generation] spawn {
    params ["_source","_kind","_generation"];
    private _camera="camera" camCreate (getPos _source);
    if (isNull _camera) exitWith {(findDisplay 87000 displayCtrl 112) ctrlSetText "Camera unavailable."};
    missionNamespace setVariable ["ATLAS_isrCamera",_camera];
    _camera cameraEffect ["Internal","Back","SICS_ISR"];
    _camera camSetFov 0.72;
    _camera camCommit 0;
    (findDisplay 87000 displayCtrl 112) ctrlSetText (if (_kind=="HELMET") then {"CONNECTING / HEAD CAMERA"} else {"CONNECTING / UAV CAMERA"});
    waitUntil {
        sleep 0.05;
        if (isNull _source || {!alive _source} || {_generation!=ATLAS_streamGeneration} || {isNull findDisplay 87000} || {SICS_osApp!="ATLAS"} || {SICS_tab!="ISR"}) exitWith {true};
        private _position=if (_kind=="HELMET") then {_source modelToWorld [0,0,1.55]} else {_source modelToWorld [0,-6,2.5]};
        private _target=if (_kind=="HELMET") then {_source modelToWorld [0,20,1.55]} else {_source modelToWorld [0,12,0]};
        _camera camSetPos _position;
        _camera camSetTarget _target;
        _camera camCommit 0;
        false
    };
    _camera cameraEffect ["Terminate","Back","SICS_ISR"];
    camDestroy _camera;
    if (_generation==ATLAS_streamGeneration) then {
        missionNamespace setVariable ["ATLAS_isrCamera",objNull];
        SICS_cameraActive=false;
        if (!isNull findDisplay 87000 && {SICS_tab=="ISR"}) then {(findDisplay 87000 displayCtrl 112) ctrlSetText "STREAM ENDED / source unavailable"};
    };
};
SICS_cameraActive=true;
true
