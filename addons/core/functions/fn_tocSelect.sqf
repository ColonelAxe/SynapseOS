// Shared screen selection; all requests checked on server.
if (!isServer) exitWith {};
params [["_unit",objNull,[objNull]],["_screen",objNull,[objNull]],["_source",objNull,[objNull]],["_kind","OFF",[""]]];
if (isNull _unit || {isNull _screen} || {!alive _unit} || {!alive _screen}) exitWith {};
if (isRemoteExecuted && {remoteExecutedOwner!=owner _unit}) exitWith {};
if (!(_screen in (missionNamespace getVariable ["ATLAS_tocDisplays",[]])) || {_unit distance _screen>5}) exitWith {};
private _settings=_screen getVariable ["ATLAS_tocFeed",[]];
if (count _settings<4 || {side group _unit!=(_settings select 2)}) exitWith {};
if !(_kind in ["OFF","HELMET","UAV"]) exitWith {};
if (_kind!="OFF") then {
    if (isNull _source || {!alive _source}) exitWith {_kind="INVALID"};
    if (_kind=="HELMET" && {!(["helmet",true] call SICS_fnc_policy) || {!(_source isKindOf "Man")} || {side group _source!=side group _unit} || {!("ATLAS_HelmetCam" in (items _source+assignedItems _source))}}) then {_kind="INVALID"};
    if (_kind=="UAV" && {!(["drone",true] call SICS_fnc_policy) || {getNumber (configOf _source >> "isUav")!=1} || {side _source!=side group _unit}}) then {_kind="INVALID"};
};
if (_kind=="INVALID") exitWith {};
if (_kind=="OFF") then {_source=objNull};
private _group=_screen getVariable ["ATLAS_tocGroup",objNull];
{
    if (!isNull _x && {_x getVariable ["ATLAS_tocGroup",objNull]==_group}) then {
        private _feed=+(_x getVariable ["ATLAS_tocFeed",[]]);
        if (count _feed==4) then {_feed set [0,_source];_feed set [3,_kind];_x setVariable ["ATLAS_tocFeed",_feed,true]};
    };
} forEach (missionNamespace getVariable ["ATLAS_tocDisplays",[]]);
