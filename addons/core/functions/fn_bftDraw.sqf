params ["_map"];
if !( ["tracking",true] call SICS_fnc_policy ) exitWith {};
private _entries=(missionNamespace getVariable ["cTabBFTgroups",[]])+(missionNamespace getVariable ["cTabBFTvehicles",[]])+(missionNamespace getVariable ["cTabBFTmembers",[]]);
{
    private _object=_x select 0;
    if (!isNull _object && {alive _object}) then {
        private _sample=[_object] call SICS_fnc_trackStatus;_sample params ["_state","_age","_pos","_dir"];
        private _live=_state in ["LIVE","UNVERIFIED"];
        private _colour=if (_live) then {[0.3,0.72,1,1]} else {[1,0.7,0.25,0.7]};
        private _label=_x select 3;
        if (_state!="LIVE") then {_label=_label+format [" / %1%2",_state,["",format [" %1s",floor _age]] select (_age>=0)]};
        if (_age<120 || {_age<0}) then {_map drawIcon [_x select 1,_colour,_pos,24,24,0,_label,1,0.025,"RobotoCondensed","right"]};
    };
} forEach _entries;
_map drawIcon ["\A3\ui_f\data\map\vehicleicons\iconMan_ca.paa",[0.3,1,0.8,1],getPosASLVisual vehicle player,20,20,getDirVisual vehicle player,"YOU",1,0.024,"RobotoCondensed"];
