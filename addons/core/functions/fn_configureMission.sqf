// Trusted server/Eden API. Never registered for remote execution.
params [["_changes",createHashMap]];
if (!isServer || {isRemoteExecuted} || {!(_changes isEqualType createHashMap)}) exitWith {false};
private _defaults=createHashMapFromArray [["tablet",true],["phone",true],["portable",true],["vehicles",true],["camera",true],["drone",true],["helmet",true],["tracking",true],["overlays",true],["support",true],["assignedCommandOnly",false],["journalLimit",500],["contactTTL",1800],["vehicleClasses",[]]];
private _p=missionNamespace getVariable ["ATLAS_serverPolicy",_defaults];
{
    private _value=_changes get _x;private _default=_defaults getOrDefault [_x,nil];
    if (!isNil "_default" && {_value isEqualType _default}) then {
        private _valid=true;
        if (_x=="journalLimit") then {_valid=finite _value && {_value>=100} && {_value<=2000} && {_value==floor _value}};
        if (_x=="contactTTL") then {_valid=finite _value && {_value>=60} && {_value<=86400}};
        if (_x=="vehicleClasses") then {_valid=count _value<=64 && {_value findIf {!(_x isEqualType "") || {count _x>80}}<0}};
        if (_valid) then {_p set [_x,_value]};
    };
} forEach keys _changes;
ATLAS_serverPolicy=_p;missionNamespace setVariable ["ATLAS_missionPolicy",_p,true];
ATLAS_operationsVersion=(missionNamespace getVariable ["ATLAS_operationsVersion",0])+1;
true
