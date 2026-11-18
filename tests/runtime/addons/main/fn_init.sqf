// Test-only addon. Never included in the production mod.
if (isDedicated) exitWith {[] spawn {waitUntil {sleep 0.2;!isNil "ATLAS_operations" && {time>1}};[] execVM "\x\sics_test\addons\main\server-check.sqf"}};
if (!hasInterface || {is3DEN}) exitWith {};
[] spawn {
    waitUntil {!isNull player};
    sleep 3;
    player allowDamage false;
    player addItemToVest "ATLAS_Tablet";
    player linkItem "ATLAS_Tablet";
    player setVariable ["SICS_commander",true,true];
    group player setGroupIdGlobal ["ATLAS 6"];
    SICS_testGroups=createHashMap;
    {
        private _g=createGroup west;
        private _u=_g createUnit ["B_Soldier_TL_F",player getPos [50+_forEachIndex*50,45+_forEachIndex*40],[],0,"NONE"];
        _u allowDamage false;_u disableAI "TARGET";_u disableAI "AUTOTARGET";_g setCombatMode "BLUE";
        _u linkItem "ATLAS_Tablet";
        _g setGroupIdGlobal [_x];
        SICS_testGroups set [_x,_g];
    } forEach ["ALPHA 1-1","BRAVO 1-2"];
    private _p=getPosATL player;
    private _car=createVehicle ["B_MRAP_01_F",player getPos [70,90],[],0,"NONE"];
    createVehicleCrew _car;_car allowDamage false;_car limitSpeed 35;
    driver _car doMove (player getPos [500,0]);
    private _heli=createVehicle ["B_Heli_Light_01_F",[_p select 0,(_p select 1)+250,180],[],0,"FLY"];
    createVehicleCrew _heli;_heli allowDamage false;_heli flyInHeight 180;
    _heli setVelocity [20,10,0];driver _heli doMove (player getPos [2500,45]);
    private _plane=createVehicle ["B_Plane_CAS_01_F",[(_p select 0)+600,_p select 1,600],[],0,"FLY"];
    createVehicleCrew _plane;_plane allowDamage false;_plane flyInHeight 600;
    _plane setDir 90;_plane setVelocity [120,0,0];driver _plane doMove (player getPos [5000,90]);
    SICS_testVehicles=[_car,_heli,_plane];
    {private _g=group driver _x;_g setCombatMode "BLUE";{_x allowDamage false;_x disableAI "TARGET";_x disableAI "AUTOTARGET"} forEach crew _x} forEach SICS_testVehicles;
    diag_log format ["SICS_TEST READY: playerOwner=%1, alive=%2, access=%3",owner player,alive player,[player] call SICS_fnc_access];
    [objNull,"TABLET"] call SICS_fnc_open;
    sleep 3;
    {
        private _check=[] execVM ("\x\sics_test\addons\main\"+_x);
        waitUntil {sleep 0.2;scriptDone _check};
    } forEach ["operations-check.sqf","beta-check.sqf","smoke.sqf","media-check.sqf","drone-check.sqf","ui-audit.sqf"];
    private _large=[1.15] execVM "\x\sics_test\addons\main\ui-audit.sqf";
    waitUntil {sleep 0.2;scriptDone _large};
    diag_log "ATLAS_COMBINED_TEST COMPLETE";
};
