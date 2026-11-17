disableSerialization;
params [["_self",false]];
private _u=if (_self) then {player} else {missionNamespace getVariable ["SICS_selectedUnit",player]};
if (isNull _u || {!alive _u}) then {_u=player};
private _map=findDisplay 87000 displayCtrl 40;
ctrlMapAnimClear _map;
_map ctrlMapAnimAdd [0.35,(ctrlMapScale _map) min 0.12,([vehicle _u] call SICS_fnc_trackStatus) select 2];ctrlMapAnimCommit _map;
// Compensate for the map control's projection offset inside the tablet viewport.
[_map,_u] spawn {
    disableSerialization;
    params ["_map","_u"];
    sleep 0.4;
    if (isNull _map || {isNull _u}) exitWith {};
    private _r=ctrlPosition _map;
    private _centre=_map ctrlMapScreenToWorld [(_r select 0)+(_r select 2)/2,(_r select 1)+(_r select 3)/2];
    private _target=([vehicle _u] call SICS_fnc_trackStatus) select 2;
    private _corrected=[2*(_target select 0)-(_centre select 0),2*(_target select 1)-(_centre select 1),0];
    ctrlMapAnimClear _map;
    _map ctrlMapAnimAdd [0,ctrlMapScale _map,_corrected];ctrlMapAnimCommit _map;
};
(findDisplay 87000 displayCtrl 60) ctrlSetText format ["CENTRED / %1 / %2 / GRID %3",groupId group _u,([vehicle _u] call SICS_fnc_trackStatus) select 0,mapGridPosition (([vehicle _u] call SICS_fnc_trackStatus) select 2)];

