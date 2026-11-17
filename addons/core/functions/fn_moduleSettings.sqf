params [["_logic",objNull],["_units",[]],["_activated",true]];
if (!isServer || {isRemoteExecuted} || {!_activated} || {isNull _logic}) exitWith {false};
private _p=createHashMap;
{_p set [_x,_logic getVariable [_x,true]]} forEach ["tablet","phone","portable","vehicles","camera","drone","helmet","tracking","overlays","support"];
_p set ["assignedCommandOnly",_logic getVariable ["assignedCommandOnly",false]];
_p set ["journalLimit",_logic getVariable ["journalLimit",500]];
_p set ["contactTTL",_logic getVariable ["contactTTL",1800]];
_p set ["vehicleClasses",(_logic getVariable ["vehicleClasses",""]) splitString ",; "];
[_p] call SICS_fnc_configureMission
