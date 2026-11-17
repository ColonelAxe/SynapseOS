// Native terminal ownership/role rules remain authoritative; never force remoteControl.
disableSerialization;
params ["_role",["_uav",objNull]];
if !( ["drone",true] call SICS_fnc_policy ) exitWith {hint "UAV control through ATLAS is disabled by the mission.";false};
if (isNull _uav) then {private _list=findDisplay 87000 displayCtrl 110;if (lbCurSel _list>=0 && {_list lbValue lbCurSel _list==0}) then {_uav=objectFromNetId (_list lbData lbCurSel _list)}};
if (isNull _uav || {!alive _uav} || {!(_uav in (missionNamespace getVariable ["cTabUAVlist",[]]))}) exitWith {hint "Select an active authorised UAV.";false};
if !(_role in ["DRIVER","GUNNER","TERMINAL"]) exitWith {false};
private _seat=if (_role=="GUNNER") then {gunner _uav} else {driver _uav};
if (_role!="TERMINAL" && {isNull _seat}) exitWith {hint "This drone has no compatible seat for that control mode.";false};
private _controllers=UAVControl _uav;private _occupied=false;
for "_i" from 0 to (count _controllers-2) step 2 do {if ((_controllers select (_i+1))==_role && {!isNull (_controllers select _i)} && {(_controllers select _i)!=player}) then {_occupied=true}};
if (_occupied) exitWith {hint "Another operator controls that drone role.";false};
if !(player connectTerminalToUAV _uav) exitWith {hint "Link refused. Equip a compatible UAV terminal and check access.";false};
["CLOSE"] call SICS_fnc_toggleDevice;
[_uav,_role] spawn {
    params ["_uav","_role"];
    waitUntil {sleep 0.01;!(missionNamespace getVariable ["SICS_transitionActive",false])};
    if (!alive _uav || {getConnectedUAV player!=_uav}) exitWith {hint "Drone link lost."};
    private _action=switch (_role) do {case "DRIVER":{"SwitchToUAVDriver"};case "GUNNER":{"SwitchToUAVGunner"};default {"UAVTerminalOpen"}};
    player action [_action,if (_role=="TERMINAL") then {player} else {_uav}];
    if (_role!="TERMINAL") then {sleep 0.7;private _control=UAVControl _uav;if !((player in _control) && {_role in _control}) then {hint "Control was not granted. Use the UAV terminal to check seat availability and mission restrictions."}};
};
true
