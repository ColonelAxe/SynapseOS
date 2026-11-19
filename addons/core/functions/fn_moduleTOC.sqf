params [["_logic",objNull],["_objects",[]],["_activated",true]];
if (!isServer || {!_activated} || {isNull _logic}) exitWith {};
private _side=[east,west,resistance,civilian] select (floor ((_logic getVariable ["tocSide",1]) max 0 min 3));
private _selection=floor ((_logic getVariable ["tocSelection",0]) max 0);
private _sources=_objects select {getNumber (configOf _x >> "isUav")==1};
private _source=_sources param [0,objNull];
{
    if (!(_x isKindOf "Logic") && {getNumber (configOf _x >> "isUav")!=1}) then {
        if (_logic getVariable ["tocISR",true]) then {
            _x setVariable ["ATLAS_tocFeed",[_source,_selection,_side],true];
        } else {[_x,_side,_selection,"TOC"] call SICS_fnc_briefingScreen};
    };
} forEach _objects;
ATLAS_tocDisplays=(missionNamespace getVariable ["ATLAS_tocDisplays",[]])+(_objects select {(_x getVariable ["ATLAS_tocFeed",[]]) isNotEqualTo []});publicVariable "ATLAS_tocDisplays";
