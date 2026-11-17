params ["_map","_button","_x","_y"];
if (_button==1) exitWith {if (ATLAS_opsDraftPoints isNotEqualTo []) then {ATLAS_opsDraftPoints deleteAt (count ATLAS_opsDraftPoints-1)};true};
if (_button!=0) exitWith {false};
private _p=_map ctrlMapScreenToWorld [_x,_y];SICS_selectedPosition=_p;
if (missionNamespace getVariable ["ATLAS_opsCapture",false]) then {
    if (count ATLAS_opsDraftPoints<64) then {ATLAS_opsDraftPoints pushBack _p};
    (findDisplay 87000 displayCtrl 2640) ctrlSetText format ["%1 points / right-click undo / Details when ready",count ATLAS_opsDraftPoints];
} else {(findDisplay 87000 displayCtrl 2640) ctrlSetText format ["GRID %1 / position for the next operation",mapGridPosition _p]};
true
