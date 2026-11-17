params ["_map"];
if ((missionNamespace getVariable ["SICS_mapTool",""])=="INSPECT" && {!isNull SICS_selectedUnit}) then {
    _map drawIcon ["\A3\ui_f\data\map\markers\military\circle_CA.paa",[0.3,0.95,0.85,1],getPosASLVisual vehicle SICS_selectedUnit,38,38,0,"INSPECTING",1,0.025,"RobotoCondensed"];
};
[_map] call SICS_fnc_bftDraw;
[_map,false] call cTab_fnc_drawUserMarkers;
[] call SICS_fnc_tracks;
{
    _x params ["_v","_trail","_kind","_callsign"];
    if (!isNull _v && {alive _v} && {([_v] call SICS_fnc_trackStatus) select 0 in ["LIVE","UNVERIFIED"]} && {["tracking",true] call SICS_fnc_policy}) then {
        private _pos=getPosASLVisual _v;
        if (missionNamespace getVariable ["ATLAS_showTrails",true]) then {
            for "_i" from 1 to (count _trail-1) do {_map drawLine [(_trail select (_i-1)) select 0,(_trail select _i) select 0,[0.2,0.65,1,0.35]]};
            if (_trail isNotEqualTo []) then {_map drawLine [(_trail select -1) select 0,_pos,[0.2,0.65,1,0.65]]};
        };
        private _speed=round abs speed _v;
        if (_speed>1) then {
            _map drawArrow [_pos,_v getPos [(worldSize*ctrlMapScale _map*0.012) max 25,getDirVisual _v],[0.25,0.7,1,0.9]];
        };
        private _label=format ["%1 / %2 km/h",_kind,_speed];
        if (_v isKindOf "Air") then {_label=_label+format [" / %1m AGL",round ((getPosATLVisual _v) select 2)]};
        if (missionNamespace getVariable ["ATLAS_showTrackLabels",true]) then {_map drawIcon ["\A3\ui_f\data\map\Markers\System\dummy_ca.paa",[0.45,0.8,1,1],_pos,0,0,0,_label,1,0.024,"RobotoCondensed","left"]};
    };
} forEach values (missionNamespace getVariable ["SICS_tracks",createHashMap]);
if ((missionNamespace getVariable ["SICS_lineStart",[]]) isNotEqualTo [] && {(missionNamespace getVariable ["SICS_mapCursor",[]]) isNotEqualTo []}) then {_map drawLine [SICS_lineStart,SICS_mapCursor,[0.2,0.7,1,1]]};
_map drawIcon ["\A3\ui_f\data\map\markers\military\objective_CA.paa",[0.3,0.9,0.8,1],SICS_selectedPosition,24,24,0,"SELECTED GRID",1,0.035,"RobotoCondensed"];
{
    if (_x select 2 == "C2" && {(missionNamespace getVariable ["ATLAS_opsLayers",[true,true,true]]) select 2}) then {_map drawIcon ["\A3\ui_f\data\map\markers\military\objective_CA.paa",[1,0.7,0.3,1],_x select 5,24,24,0,format ["ORDER %1",_x select 0],1,0.03,"RobotoCondensed"]};
    if (_x select 2 == "REPORTS" && {(_x param [11,[]]) isEqualTo []} && {(missionNamespace getVariable ["ATLAS_opsLayers",[true,true,true]]) select 1}) then {_map drawIcon ["\A3\ui_f\data\map\markers\military\warning_CA.paa",[1,0.7,0.3,1],_x select 5,20,20,0,format ["REPORT %1",_x select 0],1,0.03,"RobotoCondensed"]};
} forEach (missionNamespace getVariable ["SICS_localRecords",[]]);
[_map] call SICS_fnc_operationsDraw;

