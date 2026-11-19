// One Eden module owns the master and up to four independently controlled displays.
params [["_logic",objNull],["_objects",[]],["_activated",true]];
if (!isServer || {!_activated} || {isNull _logic} || {isRemoteExecuted}) exitWith {};

private _report = {
    params ["_field","_message"];
    private _text = format ["ATLAS TOC Setup (%1), %2: %3",getPosATL _logic,_field,_message];
    diag_log _text;
    if (!isMultiplayer && {hasInterface}) then {systemChat _text};
};
private _resolve = {
    params ["_name"];
    // Eden variable names are data, never SQF expressions.
    private _object = missionNamespace getVariable [_name,objNull];
    if !(_object isEqualType objNull && {!isNull _object} && {!(_object isKindOf "Logic")} && {!(_object isKindOf "Man")}) exitWith {objNull};
    _object
};
private _masterName = _logic getVariable ["masterDevice",""];
private _master = [_masterName] call _resolve;
if (isNull _master) exitWith {["Master device",format ["'%1' must name an Eden object.",_masterName]] call _report};
private _displays = missionNamespace getVariable ["ATLAS_tocDisplays",[]];
private _masters = missionNamespace getVariable ["ATLAS_tocMasters",[]];
if (_master in _masters || {_master in _displays} || {_master in (missionNamespace getVariable ["ATLAS_briefScreens",[]])}) exitWith {
    ["Master device",format ["'%1' is already assigned to a TOC.",_masterName]] call _report;
};

private _side = [east,west,resistance,civilian] select (floor ((_logic getVariable ["roomSide",1]) max 0 min 3));
private _selection = floor ((_logic getVariable ["textureSelection",0]) max 0);
private _slots = [];
for "_slot" from 1 to 4 do {
    private _name = _logic getVariable ["screen"+str _slot,""];
    if (_name != "") then {
        private _screen = [_name] call _resolve;
        private _field = format ["Screen %1",_slot];
        if (isNull _screen) then {
            [_field,format ["'%1' does not resolve to an Eden object.",_name]] call _report;
        } else {
            if (_screen == _master || {_screen in _displays} || {_screen in _masters} || {_screen in (missionNamespace getVariable ["ATLAS_briefScreens",[]])}) then {
                [_field,format ["'%1' is already assigned to a TOC.",_name]] call _report;
            } else {
                private _textures = getObjectTextures _screen;
                if (_selection >= count _textures) then {
                    [_field,format ["'%1' has no texture selection %2.",_name,_selection]] call _report;
                } else {
                    if !([_screen,_side,_selection,"ATLAS briefing",true] call SICS_fnc_briefingScreen) then {
                        [_field,format ["Could not register '%1' for briefings. Check the briefing-screen limit.",_name]] call _report;
                    } else {
                        private _view = ["STANDBY","MAP","ISR"] select (floor ((_logic getVariable ["view"+str _slot,[1,2,0,0] select (_slot-1)]) max 0 min 2));
                        _screen setVariable ["ATLAS_tocMaster",_master,true];
                        _screen setVariable ["ATLAS_tocFeed",[objNull,_selection,_side,_view],true];
                        _slots pushBack [_slot,_name,_screen];
                        _displays pushBack _screen;
                    };
                };
            };
        };
    };
};
_master setVariable ["ATLAS_tocSlots",_slots,true];
[_master,_side,"TOC ATLAS"] call SICS_fnc_registerTOC;
ATLAS_tocMasters = _masters + [_master];
ATLAS_tocDisplays = _displays;
publicVariable "ATLAS_tocMasters";
publicVariable "ATLAS_tocDisplays";
