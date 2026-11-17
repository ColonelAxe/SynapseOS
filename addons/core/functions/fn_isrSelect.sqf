params ["_source","_kind"];
if (!([ ["drone","helmet"] select (_kind=="HELMET"),true] call SICS_fnc_policy)) exitWith {hint "This sensor type is disabled by the mission.";false};
[] call SICS_fnc_stopCamera;
private _allowed=missionNamespace getVariable [["cTabUAVlist","cTabHcamlist"] select (_kind=="HELMET"),[]];
if (isNull _source || {!alive _source} || {!(_source in _allowed)}) exitWith {false};
ATLAS_streamSource=_source;ATLAS_streamKind=_kind;
ATLAS_streamHandle=[_source,_kind,ATLAS_streamGeneration] spawn {
    params ["_source","_kind","_generation"];
    private _ok=if (_kind=="HELMET") then {["SICS_ISR",str _source] call cTab_fnc_createHelmetCam} else {[str _source,[[0,"SICS_ISR"]]] call cTab_fnc_createUavCam};
    if (_generation!=ATLAS_streamGeneration || {isNull findDisplay 87000} || {SICS_osApp!="ATLAS"} || {SICS_tab!="ISR"}) exitWith {[] call SICS_fnc_stopCamera};
    SICS_cameraActive=_ok;
    (findDisplay 87000 displayCtrl 112) ctrlSetText (if (_ok) then {"LIVE / "+_kind} else {"Camera unavailable. Check compatible equipment, PiP and source state."});
};
true
