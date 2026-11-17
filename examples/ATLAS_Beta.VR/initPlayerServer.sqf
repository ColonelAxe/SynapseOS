params ["_unit",["_didJIP",false]];
// Test mission role assignment only. Never grant every tester commander privileges.
private _name=_unit getVariable ["ATLAS_betaSlot",vehicleVarName _unit];
_unit setVariable ["ATLAS_betaSlot",_name,true];
private _command=_unit getVariable ["ATLAS_betaCommander",_name=="ATLAS_Beta_HQ"];
_unit setVariable ["ATLAS_betaCommander",_command,true];
_unit setVariable ["ATLAS_commander",_command,true];
_unit allowDamage false;
private _callsign=switch _name do {case "ATLAS_Beta_HQ":{"HQ"};case "ATLAS_Beta_Alpha":{"ALPHA"};case "ATLAS_Beta_AlphaMember":{"ALPHA"};case "ATLAS_Beta_Bravo":{"BRAVO"};case "ATLAS_Beta_Air":{"EAGLE"};default {"OBSERVER"}};
group _unit setGroupIdGlobal [_callsign];
diag_log format ["ATLAS_CB1 JOIN: side=%1 role=%2 commander=%3 JIP=%4",side group _unit,_callsign,_command,_didJIP];
