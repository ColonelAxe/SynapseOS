params ["_unit","_entry",["_journal",false]];
if (isNull _unit || {_entry isEqualTo []} || {side group _unit!=(_entry select 1)}) exitWith {false};
if (!_journal && {(_entry select 2) in ["PLAN","GRAPHIC"]} && {!( ["overlays",true] call SICS_fnc_policy )}) exitWith {false};
if (!_journal && {(_entry select 2) in ["SUPPORT","LZ","AIR_TASK"]} && {!( ["support",true] call SICS_fnc_policy )}) exitWith {false};
private _target=_entry select 6;private _owner=_entry select 4;
if (_journal) exitWith {
    if (_target find "CH:"==0) then {[_unit,SICS_channels getOrDefault [_target,[]]] call SICS_fnc_channelAccess} else {_target=="" || {_target==netId group _unit} || {_owner==getPlayerUID _unit}}
};
private _command=_unit getVariable ["ATLAS_commander",_unit getVariable ["SICS_commander",false]];
if ((_entry select 2)=="PLAN" && {(_entry select 7)=="DRAFT"} && {_owner!=getPlayerUID _unit} && {!_command}) exitWith {false};
if ((_entry select 2)=="GRAPHIC") then {
    private _data=createHashMapFromArray (_entry select 10);
    private _parent=(missionNamespace getVariable ["ATLAS_operations",createHashMap]) getOrDefault [_data getOrDefault ["plan",""],[]];
    if (_parent isNotEqualTo [] && {(_parent select 7)=="DRAFT"} && {(_parent select 4)!=getPlayerUID _unit} && {!_command}) exitWith {_target="!DENIED"};
};
_target!="!DENIED" && {_target=="" || {_target==netId group _unit} || {_owner==getPlayerUID _unit}}
