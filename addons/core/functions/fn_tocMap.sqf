disableSerialization;
params ["_action",["_screen",objNull]];
private _d=findDisplay 87005;
if (_action=="OPEN") exitWith {
    if (!isNull _d || {isNull _screen} || {!alive _screen}) exitWith {};
    private _master=_screen getVariable ["ATLAS_tocMaster",objNull];
    if (side group player!=(_screen getVariable ["ATLAS_briefSide",sideUnknown]) || {player distance _screen>5 && {isNull _master || {player distance _master>5}}}) exitWith {};
    private _parent=findDisplay 87004;
    if (isNull _parent) then {if !(createDialog "ATLAS_TOCMap") exitWith {}} else {_parent createDisplay "ATLAS_TOCMap"};
    _d=findDisplay 87005;if (isNull _d) exitWith {};
    _d setVariable ["ATLAS_screen",_screen];_d setVariable ["ATLAS_live",true];
    private _map=_d displayCtrl 40;
    private _default=[getPosATL _screen select [0,2],0.1]; private _brief=_screen getVariable ["ATLAS_briefing",[sideUnknown,"","",0.1]]; private _ops=missionNamespace getVariable ["ATLAS_clientOperations",createHashMap]; private _plan=_ops getOrDefault [_brief select 1,[]]; private _focus=_ops getOrDefault [_brief select 2,_plan]; if (_focus isNotEqualTo [] && {_plan param [7,""]=="PUBLISHED"}) then {_default=[_focus select 8 select [0,2],_brief select 3]}; private _view=_screen getVariable ["ATLAS_tocMapView",_default];
    _map ctrlMapAnimAdd [0,_view select 1,_view select 0];ctrlMapAnimCommit _map;
    _map ctrlAddEventHandler ["Draw",{[_this select 0] call SICS_fnc_bftDraw;[_this select 0,"",true] call SICS_fnc_operationsDraw}];
    _d setVariable ["ATLAS_ready",diag_tickTime+0.5];
};
if (isNull _d) exitWith {};
_screen=_d getVariable ["ATLAS_screen",objNull];
private _master=_screen getVariable ["ATLAS_tocMaster",objNull];
if (isNull _screen || {!alive _screen} || {!alive player} || {side group player!=(_screen getVariable ["ATLAS_briefSide",sideUnknown])} || {player distance _screen>5 && {isNull _master || {!alive _master} || {player distance _master>5}}}) exitWith {_d closeDisplay 2};
private _map=_d displayCtrl 40;
private _rect=ctrlPosition _map;
private _centre=_map ctrlMapScreenToWorld [(_rect select 0)+(_rect select 2)/2,(_rect select 1)+(_rect select 3)/2];
private _scale=ctrlMapScale _map;
if (_action in ["IN","OUT","HOME"]) exitWith {
    if (_action=="HOME") then {_centre=getPosATL player select [0,2]} else {_scale=(_scale*([0.75,1.3333] select (_action=="OUT"))) max 0.001 min 1};
    ctrlMapAnimClear _map;_map ctrlMapAnimAdd [0,_scale,_centre];ctrlMapAnimCommit _map;
};
if (_action=="LIVE") exitWith {private _live=!(_d getVariable ["ATLAS_live",true]);_d setVariable ["ATLAS_live",_live];(_d displayCtrl 5) ctrlSetText (["Live sync: OFF","Live sync: ON"] select _live)};
if (diag_tickTime<(_d getVariable ["ATLAS_ready",1e12])) exitWith {};
private _view=[_centre,_scale];
private _last=_d getVariable ["ATLAS_sent",[[1e9,1e9],-1]];
if (_action=="SEND" || {_d getVariable ["ATLAS_live",true] && {(_centre distance2D (_last select 0))>1 || {abs (_scale-(_last select 1))>0.00001}}}) then {
    [player,_screen,_centre,_scale] remoteExecCall ["SICS_fnc_tocMapServer",2];_d setVariable ["ATLAS_sent",_view];
};
(_d displayCtrl 3) ctrlSetText format ["GRID %1  |  drag to pan / wheel to zoom  |  live friendly picture",mapGridPosition _centre];
