params ["_screen"];
if (_screen getVariable ["ATLAS_tocActions",false]) exitWith {};
_screen setVariable ["ATLAS_tocActions",true];
if (!isNil "ace_interact_menu_fnc_createAction") then {
    private _action=["ATLAS_TOCVideo","ATLAS TOC Video Feed","\x\sics\addons\core\ui\camera_glyph_ca.paa",{}, {
        params ["_target","_player"];
        alive _target && {_player distance _target<5} && {side group _player==((_target getVariable ["ATLAS_tocFeed",[objNull,0,sideUnknown]]) select 2)} && {[_player,_target,[]] call ace_common_fnc_canInteractWith}
    },{
        params ["_target"];
        private _actions=[];
        private _sources=[[objNull,"OFF","Stop feed / restore display"]]+([] call SICS_fnc_isrSources);
        {
            _x params ["_source","_kind","_label"];
            private _action=["ATLAS_TOC_"+str _forEachIndex,_label,"",{
                params ["_target","_player","_params"];
                _params params ["_source","_kind"];
                [_player,_target,_source,_kind] remoteExecCall ["SICS_fnc_tocSelect",2];
            },{true},{},[_source,_kind]] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action,[],_target];
        } forEach _sources;
        _actions
    },[],{boundingCenter _target},5] call ace_interact_menu_fnc_createAction;
    [_screen,0,[],_action] call ace_interact_menu_fnc_addActionToObject;
} else {
    _screen addAction ["ATLAS TOC / Next drone or helmet camera",{
        params ["_target","_unit"];
        private _sources=[] call SICS_fnc_isrSources;
        if (_sources isEqualTo []) exitWith {hint "No friendly UAVs or equipped helmet cameras available."};
        private _index=((_target getVariable ["ATLAS_tocCycle",-1])+1) mod count _sources;
        _target setVariable ["ATLAS_tocCycle",_index];
        (_sources select _index) params ["_source","_kind","_label"];
        [_unit,_target,_source,_kind] remoteExecCall ["SICS_fnc_tocSelect",2];hint _label;
    },nil,1.5,true,true,"","alive _target && {side group _this==((_target getVariable ['ATLAS_tocFeed',[objNull,0,sideUnknown]]) select 2)}",5];
    _screen addAction ["ATLAS TOC / Stop feed",{params ["_target","_unit"];[_unit,_target,objNull,"OFF"] remoteExecCall ["SICS_fnc_tocSelect",2]},nil,1.5,true,true,"","alive _target && {side group _this==((_target getVariable ['ATLAS_tocFeed',[objNull,0,sideUnknown]]) select 2)}",5];
};
