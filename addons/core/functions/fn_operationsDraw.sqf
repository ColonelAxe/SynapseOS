params ["_map",["_planFilter",""],["_room",false]];
private _layers=if (_room) then {[true,true,true]} else {missionNamespace getVariable ["ATLAS_opsLayers",[true,true,true]]};
{
    _x params ["_id","_side","_kind","_title","_owner","_author","_target","_status","_pos","_points","_pairs"];
    private _d=createHashMapFromArray _pairs;
    private _draw=!_room || {_target==""};
    private _colour=[0.25,0.72,1,1];private _icon="\A3\ui_f\data\map\markers\military\objective_CA.paa";
    if (_kind=="GRAPHIC") then {
        private _plan=_d getOrDefault ["plan",""];
        _draw=_draw && {_layers select 0} && {_room || {!( _plan in (missionNamespace getVariable ["ATLAS_hiddenPlans",[]]) )}} && {_planFilter=="" || {_plan==_planFilter}};
        _colour=getArray(configFile >> "CfgMarkerColors" >> (_d getOrDefault ["colour","ColorBlue"]) >> "color");
        if (_colour findIf {!(_x isEqualType 0)}>=0 || {count _colour<4}) then {_colour=[0.25,0.72,1,1]};
        if (_draw) then {
            for "_i" from 1 to (count _points-1) do {_map drawLine [_points select (_i-1),_points select _i,_colour]};
            if (_d get "shape"=="BOUNDARY" && {count _points>2}) then {_map drawLine [_points select -1,_points select 0,_colour]};
            {if (_d get "shape"=="ROUTE") then {_map drawIcon [_icon,_colour,_x,13,13,0,format ["%1 / CP%2",_title,_forEachIndex+1],1,0.021,"RobotoCondensed"]}} forEach _points;
            _map drawIcon [_icon,_colour,_pos,22,22,0,_title,1,0.026,"RobotoCondensed"];
        };
    };
    if (_kind=="CONTACT" && {_layers select 1} && {_status!="RESOLVED"} && {!_room}) then {
        private _stale=serverTime>(_d getOrDefault ["expires",1e12]);
        private _c=([_d get "affiliation"] call SICS_fnc_affiliation) select 3;if (_stale) then {_c=[0.65,0.65,0.65,0.6]};
        if (markerType ("SICS_CONTACT_"+str (_d getOrDefault ["record",-1]))=="") then {_map drawIcon [getText(configFile >> "CfgMarkers" >> (_d get "symbol") >> "icon"),_c,_pos,25,25,_d getOrDefault ["heading",0],format ["%1 / %2%3",_title,_d get "confidence",[""," / STALE"] select _stale],1,0.026,"RobotoCondensed"]};
    };
    if (_kind in ["SUPPORT","LZ","AIR_TASK"] && {_layers select 2} && {_status!="CANCELLED"} && {_status!="COMPLETED"} && {!_room || {_planFilter==""}}) then {
        _map drawIcon [_icon,[0.3,1,0.7,1],_pos,24,24,0,format ["%1 / %2",_title,_status],1,0.025,"RobotoCondensed"];
    };
} forEach values (missionNamespace getVariable ["ATLAS_clientOperations",createHashMap]);
if (!_room) then {
    private _points=missionNamespace getVariable ["ATLAS_opsDraftPoints",[]];
    for "_i" from 1 to (count _points-1) do {_map drawLine [_points select (_i-1),_points select _i,[1,0.8,0.2,1]]};
    { _map drawIcon ["\A3\ui_f\data\map\markers\military\dot_CA.paa",[1,0.8,0.2,1],_x,16,16,0,str (_forEachIndex+1),1,0.024,"RobotoCondensed"] } forEach _points;
    private _nav=[] call SICS_fnc_navigation;
    if (_nav isNotEqualTo []) then {_map drawIcon [getText(configFile >> "CfgMarkers" >> "mil_dot" >> "icon"),[0.2,1,0.7,1],_nav select 6,30,30,0,format ["FOLLOW CP %1",(_nav select 0)+1],1,0.03,"RobotoCondensed"]};
};
