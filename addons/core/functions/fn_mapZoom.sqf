disableSerialization;
params ["_direction"];
private _factor=if (_direction<0) then {0.5} else {2};
if (!isNil "cTabIfOpen") exitWith {if (_direction<0) then {[] call cTab_fnc_onZoomInPressed} else {[] call cTab_fnc_onZoomOutPressed}};
if (missionNamespace getVariable ["SICS_quickActive",false]) exitWith {
    ATLAS_quickScale=(((missionNamespace getVariable ["ATLAS_quickScale",0.045])*_factor) max 0.001) min 1;
    private _map=(uiNamespace getVariable ["SICS_quickDisplay",displayNull]) displayCtrl 40;
    ctrlMapAnimClear _map;_map ctrlMapAnimAdd [0,ATLAS_quickScale,getPosASLVisual vehicle player];ctrlMapAnimCommit _map;true
};
if (isNull findDisplay 87000 || {!(missionNamespace getVariable ["SICS_osApp","HOME"] in ["ATLAS","OPERATIONS"])} || {!isNull findDisplay 87001} || {!isNull findDisplay 87002} || {!isNull findDisplay 87003}) exitWith {false};
private _map=findDisplay 87000 displayCtrl ([40,2601] select (SICS_osApp=="OPERATIONS"));
if (!ctrlShown _map) exitWith {false};
private _r=ctrlPosition _map;private _centre=_map ctrlMapScreenToWorld [(_r select 0)+(_r select 2)/2,(_r select 1)+(_r select 3)/2];
private _scale=((ctrlMapScale _map*_factor) max 0.001) min 1;
ctrlMapAnimClear _map;_map ctrlMapAnimAdd [0,_scale,_centre];ctrlMapAnimCommit _map;true
