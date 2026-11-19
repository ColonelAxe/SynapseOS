// Shared screen selection; all requests checked on server.
if (!isServer) exitWith {};
params [["_unit",objNull,[objNull]],["_screen",objNull,[objNull]],["_source",objNull,[objNull]],["_kind","OFF",[""]]];
if (isNull _unit || {isNull _screen} || {!alive _unit} || {!alive _screen}) exitWith {};
if (isRemoteExecuted && {remoteExecutedOwner!=owner _unit || {!isPlayer _unit}}) exitWith {};
if !(_screen in (missionNamespace getVariable ["ATLAS_tocDisplays",[]])) exitWith {};
private _managed = _screen getVariable ["ATLAS_managedBriefing",false];
private _master = _screen getVariable ["ATLAS_tocMaster",objNull];
private _control = [_screen,_master] select _managed;
if (isNull _control || {!alive _control} || {_unit distance _control>5}) exitWith {};
private _settings=_screen getVariable ["ATLAS_tocFeed",[]];
if (count _settings<4 || {side group _unit!=(_settings select 2)}) exitWith {};
private _modes = if (_managed) then {["MAP","STANDBY","ISR"]} else {["OFF"]};
if !(_kind in (_modes + ["HELMET","UAV"])) exitWith {};
if !(_kind in _modes) then {
    if (isNull _source || {!alive _source}) exitWith {_kind="INVALID"};
    if (_kind=="HELMET" && {!(["helmet",true] call SICS_fnc_policy) || {!(_source isKindOf "Man")} || {side group _source!=side group _unit} || {!("ATLAS_HelmetCam" in (items _source+assignedItems _source))}}) then {_kind="INVALID"};
    if (_kind=="UAV" && {!(["drone",true] call SICS_fnc_policy) || {getNumber (configOf _source >> "isUav")!=1} || {side _source!=side group _unit}}) then {_kind="INVALID"};
};
if (_kind=="INVALID") exitWith {};
if (_kind in _modes) then {_source=objNull};
if (_managed) exitWith {
    _screen setVariable ["ATLAS_tocFeed",[_source,_settings select 1,_settings select 2,_kind],true];
};
private _group=_screen getVariable ["ATLAS_tocGroup",objNull];
{
    if (!isNull _x && {!(_x getVariable ["ATLAS_managedBriefing",false])} && {_x getVariable ["ATLAS_tocGroup",objNull]==_group}) then {
        private _feed=+(_x getVariable ["ATLAS_tocFeed",[]]);
        if (count _feed==4) then {_feed set [0,_source];_feed set [3,_kind];_x setVariable ["ATLAS_tocFeed",_feed,true]};
    };
} forEach (missionNamespace getVariable ["ATLAS_tocDisplays",[]]);
