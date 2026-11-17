params ["_unit",["_force",false]];
if (isRemoteExecuted && {isNil "_ATLAS_serverDispatch"}) exitWith {};
if (!isServer || {isNull _unit} || {!isPlayer _unit}) exitWith {};
private _owner=owner _unit;
private _hasDevice=[_unit] call SICS_fnc_access;
private _viewer=(missionNamespace getVariable ["ATLAS_briefScreens",[]]) findIf {alive _x && {_unit distance _x<=15} && {_x getVariable ["ATLAS_briefSide",sideUnknown]==side group _unit}}>=0;
private _sig=str [ATLAS_operationsVersion,side group _unit,netId group _unit,getPlayerUID _unit,_unit getVariable ["ATLAS_commander",_unit getVariable ["SICS_commander",false]],_hasDevice,_viewer];
private _key=str _owner;
if (!_force && {ATLAS_operationsSignatures getOrDefault [_key,""]==_sig}) exitWith {};
ATLAS_operationsSignatures set [_key,_sig];
private _entities=[];private _journal=[];
if (_hasDevice) then {
    _entities=(values ATLAS_operations) select {[_unit,_x] call SICS_fnc_operationsAccess};
    _journal=ATLAS_journal select {[_unit,_x,true] call SICS_fnc_operationsAccess};
};
if (!_hasDevice && {_viewer}) then {
    _entities=(values ATLAS_operations) select {(_x select 6)=="" && {[_unit,_x] call SICS_fnc_operationsAccess} && {(_x select 2)=="PLAN" && {(_x select 7)=="PUBLISHED"} || {(_x select 2)=="GRAPHIC" && {private _p=ATLAS_operations getOrDefault [(createHashMapFromArray (_x select 10)) getOrDefault ["plan",""],[]];_p isNotEqualTo [] && {_p select 7=="PUBLISHED"}}}}};
};
["OPERATIONS",[_entities,_journal,ATLAS_operationsVersion]] remoteExecCall ["SICS_fnc_receive",_owner];
