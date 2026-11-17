disableSerialization;
params [["_action","CYCLE"]];
if (!hasInterface) exitWith {false};
if (missionNamespace getVariable ["SICS_transitionActive",false]) exitWith {true};
if (_action=="CYCLE" && {diag_tickTime-(missionNamespace getVariable ["SICS_lastDeviceToggle",-10])<0.25}) exitWith {true};
SICS_lastDeviceToggle=diag_tickTime;
if (_action=="CYCLE") then {_action=if (!isNull findDisplay 87000) then {"MINIMIZE"} else {if (missionNamespace getVariable ["SICS_quickActive",false]) then {"OPEN"} else {"MINI"}}};
switch _action do {
    case "MINI": {if !(missionNamespace getVariable ["SICS_quickActive",false]) then {[] call SICS_fnc_quickView};SICS_deviceState=if (SICS_quickActive) then {"MINI"} else {"CLOSED"}};
    case "OPEN": {
        if (missionNamespace getVariable ["SICS_quickActive",false]) then {[] call SICS_fnc_quickView};
        [missionNamespace getVariable ["SICS_terminal",objNull],"",missionNamespace getVariable ["SICS_osLastApp","HOME"]] call SICS_fnc_open;
        SICS_deviceState=if (isNull findDisplay 87000) then {"CLOSED"} else {"FULL"};
    };
    case "MINIMIZE": {
        [findDisplay 87000] call SICS_fnc_saveSession;
        SICS_transitionActive=true;SICS_suspending=true;
        [missionNamespace getVariable ["SICS_osLastApp","HOME"]] spawn {
            params ["_resume"];
            {private _child=findDisplay _x;if (!isNull _child) then {_child closeDisplay 2}} forEach [87001,87002,87003];
            waitUntil {sleep 0.01;isNull findDisplay 87001 && {isNull findDisplay 87002} && {isNull findDisplay 87003}};
            if (!isNull findDisplay 87000) then {findDisplay 87000 closeDisplay 2};
            waitUntil {sleep 0.01;isNull findDisplay 87000};
            SICS_suspending=false;SICS_osLastApp=_resume;
            if !(missionNamespace getVariable ["SICS_quickActive",false]) then {[] call SICS_fnc_quickView};
            SICS_deviceState=if (SICS_quickActive) then {"MINI"} else {"CLOSED"};SICS_transitionActive=false;
        };
    };
    case "CLOSE";
    case "POWER": {
        [findDisplay 87000] call SICS_fnc_saveSession;SICS_transitionActive=true;SICS_suspending=true;
        [_action=="POWER",missionNamespace getVariable ["SICS_osLastApp","HOME"]] spawn {
            params ["_power","_resume"];
            {private _child=findDisplay _x;if (!isNull _child) then {_child closeDisplay 2}} forEach [87001,87002,87003];
            waitUntil {sleep 0.01;isNull findDisplay 87001 && {isNull findDisplay 87002} && {isNull findDisplay 87003}};
            if (!isNull findDisplay 87000) then {findDisplay 87000 closeDisplay 2};
            waitUntil {sleep 0.01;isNull findDisplay 87000};
            SICS_suspending=false;
            if (missionNamespace getVariable ["SICS_quickActive",false]) then {[] call SICS_fnc_quickView};
            SICS_deviceState="CLOSED";SICS_osLastApp=if (_power) then {"HOME"} else {_resume};SICS_transitionActive=false;SICS_deviceKeyHeld=false;
        };
    };
};
true

