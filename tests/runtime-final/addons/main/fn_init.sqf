// Test-only addon. Never included in the production mod.
if (!hasInterface || {is3DEN}) exitWith {};
[] spawn {
    waitUntil {!isNull player && {!isNil "cTab_player"}};
    sleep 3;
    player allowDamage false;
    player addItemToVest "ItemcTab";
    if !([player,["ItemcTab"]] call cTab_fnc_checkGear) then {player linkItem "ItemcTab"};
    player setVariable ["SICS_commander",true,true];
    group player setGroupIdGlobal ["ATLAS 6"];
    {
        private _g=createGroup west;
        private _u=_g createUnit ["B_Soldier_TL_F",player getPos [50+_forEachIndex*50,45+_forEachIndex*40],[],0,"NONE"];
        _u linkItem "ItemcTab";
        _g setGroupIdGlobal [_x];
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
    call cTab_fnc_updateLists;
    diag_log format ["SICS_TEST READY: playerOwner=%1, alive=%2, access=%3",owner player,alive player,[player] call SICS_fnc_access];
    [objNull,"TABLET"] call SICS_fnc_open;
    sleep 3;
    private _check=[] execVM "\x\sics_test\addons\main\smoke.sqf";
    waitUntil {sleep 0.2;scriptDone _check};
    _check=[] execVM "\x\sics_test\addons\main\media-check.sqf";
    waitUntil {sleep 0.2;scriptDone _check};
    _check=[] execVM "\x\sics_test\addons\main\drone-check.sqf";
    waitUntil {sleep 0.2;scriptDone _check};
    diag_log "ATLAS_COMBINED_TEST COMPLETE";
};
