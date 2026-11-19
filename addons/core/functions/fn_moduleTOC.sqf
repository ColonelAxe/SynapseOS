params [["_logic",objNull],["_objects",[]],["_activated",true]];
if (!isServer || {!_activated} || {isNull _logic} || {isRemoteExecuted}) exitWith {};
private _side=[east,west,resistance,civilian] select (floor ((_logic getVariable ["tocSide",1]) max 0 min 3));
private _selection=floor ((_logic getVariable ["tocSelection",0]) max 0);
private _sources=_objects select {getNumber (configOf _x >> "isUav")==1 || {_x isKindOf "Man" && {"ATLAS_HelmetCam" in (items _x+assignedItems _x)}}};
private _source=_sources param [0,objNull];
private _kind=if (_source isKindOf "Man") then {"HELMET"} else {"UAV"};
if (isNull _source || {side group _source!=_side && {side _source!=_side}}) then {_source=objNull;_kind="OFF"};
private _screens=_objects select {!(_x isKindOf "Logic") && {!(_x isKindOf "Man")} && {getNumber (configOf _x >> "isUav")!=1} && {!(_x getVariable ["ATLAS_managedBriefing",false])} && {!(_x in (missionNamespace getVariable ["ATLAS_tocMasters",[]]))}};
{
    private _textures=getObjectTextures _x;
    if (_selection<count _textures) then {
        _x setVariable ["ATLAS_tocOriginal",_textures select _selection,true];
        _x setVariable ["ATLAS_tocGroup",_logic,true];
        _x setVariable ["ATLAS_tocFeed",[_source,_selection,_side,_kind],true];
        ATLAS_tocDisplays=missionNamespace getVariable ["ATLAS_tocDisplays",[]];ATLAS_tocDisplays pushBackUnique _x;
        if !(_logic getVariable ["tocISR",true]) then {[_x,_side,_selection,"TOC"] call SICS_fnc_briefingScreen;_x setVariable ["ATLAS_tocOriginal",getObjectTextures _x select _selection,true]};
    } else {diag_log format ["ATLAS TOC: %1 has no texture selection %2",typeOf _x,_selection]};
} forEach _screens;
publicVariable "ATLAS_tocDisplays";
