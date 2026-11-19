disableSerialization;
params ["_map","_button","_x","_y"];
if (SICS_tab=="MESSAGES" && {!((missionNamespace getVariable ["SICS_deviceMode","TABLET"]) in ["PHONE","PORTABLE"])}) exitWith {false};
private _pos=_map ctrlMapScreenToWorld [_x,_y];
private _tool=missionNamespace getVariable ["SICS_mapTool","GRID"];
if (_button==1) exitWith {
    if (_tool!="LINE") exitWith {false};
    if (SICS_lineStart isNotEqualTo []) exitWith {SICS_lineStart=[];true};
    private _found=-1;
    {
        if ((_x select 3)=="SICS_LINE") then {
            private _p=_x select 9;
            private _a=_map ctrlMapWorldToScreen (_p select 0);
            private _b=_map ctrlMapWorldToScreen (_p select 1);
            if (_a isNotEqualTo [] && {_b isNotEqualTo []}) then {
                private _vx=(_b select 0)-(_a select 0);private _vy=(_b select 1)-(_a select 1);
                private _len=_vx*_vx+_vy*_vy;
                if (_len>0) then {private _t=((((_this select 2)-(_a select 0))*_vx+((_this select 3)-(_a select 1))*_vy)/_len) max 0 min 1; if ([(_a select 0)+_t*_vx,(_a select 1)+_t*_vy] distance2D [_this select 2,_this select 3]<0.02) exitWith {_found=_x select 0}};
            };
        };
    } forEach values SICS_clientMarkers;
    if (_found>=0) then {[player,"MARKER_DELETE",[_found],SICS_terminal] remoteExecCall ["SICS_fnc_server",2]};true
};
if (_button!=0) exitWith {false};
// Selection is independent of the picked grid and survives panning.
if (_tool in ["GRID","INSPECT"]) then {
    private _nearest=objNull;private _distance=0.025;
    {
        private _obj=_x select 0;
        private _screen=_map ctrlMapWorldToScreen (([vehicle _obj] call SICS_fnc_trackStatus) select 2);
        if (_screen isNotEqualTo []) then {
            private _d=_screen distance2D [_this select 2,_this select 3];
            if (_d<_distance) then {_distance=_d;_nearest=_obj};
        };
    } forEach ([] call SICS_fnc_trackEntries);
    if (!isNull _nearest) then {SICS_selectedUnit=_nearest;[] call SICS_fnc_details};
    if (_tool=="INSPECT") exitWith {
        if (isNull _nearest) then {(findDisplay 87000 displayCtrl 60) ctrlSetText "INSPECT UNIT  /  No friendly symbol here. Previous selection retained."} else {
            if ((missionNamespace getVariable ["SICS_deviceMode","TABLET"]) in ["PHONE","PORTABLE"]) then {SICS_mobilePane="APP"};
            [] call SICS_fnc_inspect;
        };
    };
};
if (_tool=="INSPECT") exitWith {true};
SICS_selectedPosition=_pos;
switch (_tool) do {
    case "CONTACT": {[_pos] call SICS_fnc_contactEditor;true};
    case "MARKER": {
        if ((missionNamespace getVariable ["SICS_pendingMarker",[]]) isNotEqualTo []) exitWith {
            SICS_pendingMarker set [4,_pos];
            [player,"MARKER",SICS_pendingMarker,SICS_terminal] remoteExecCall ["SICS_fnc_server",2];
            SICS_pendingMarker=[];
            (findDisplay 87000 displayCtrl 60) ctrlSetText "MARKER SENT  /  Open the markers menu to choose another symbol";
            true
        };
        if (!isNull (findDisplay 87000 displayCtrl 300)) then {[] call SICS_fnc_closeMarker};
        [_pos,[_x,_y]] call SICS_fnc_markerEditor;true
    };
    case "LINE": {
        if (SICS_lineStart isEqualTo []) then {SICS_lineStart=_pos; (findDisplay 87000 displayCtrl 60) ctrlSetText "LINE DRAWING  /  Start selected. Click the end point; right-click cancels."} else {
            if (SICS_lineStart distance2D _pos>1) then {[player,"LINE",[-1,"ColorBlue","",[SICS_lineStart,_pos]],SICS_terminal] remoteExecCall ["SICS_fnc_server",2]};
            SICS_lineStart=[];
            (findDisplay 87000 displayCtrl 60) ctrlSetText "LINE DRAWING  /  Line sent. Click to begin another line.";
        };true
    };
    default {(findDisplay 87000 displayCtrl 60) ctrlSetText format ["GRID SELECTED  /  %1  /  Attached to your next transmission",mapGridPosition _pos];false};
};

