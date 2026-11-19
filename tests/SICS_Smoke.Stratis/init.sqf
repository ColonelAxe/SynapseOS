if (!hasInterface) exitWith {};
[] spawn {
    waitUntil {!isNull player};
    player allowDamage false;
    player addItem "ATLAS_Tablet";
    player linkItem "B_UavTerminal";
    player setVariable ["SICS_commander",true,true];
    group player setGroupIdGlobal ["ATLAS 6"];
    {
        private _g=createGroup west;
        private _p=player getPos [100+_forEachIndex*100,45+_forEachIndex*50];
        private _u=_g createUnit ["B_Soldier_TL_F",_p,[],0,"NONE"];
        _u addItem "ATLAS_Tablet"; _u disableAI "PATH";
        _g setGroupIdGlobal [_x];
    } forEach ["ALPHA 1-1","BRAVO 1-2","CHARLIE 1-3"];
    private _uav=createVehicle ["B_UAV_01_F",player getPos [12,90],[],0,"NONE"];
    createVehicleCrew _uav;
    private _desk=createVehicle ["Land_CampingTable_F",player getPos [2,0],[],0,"NONE"];
    private _terminal=createVehicle ["Land_Laptop_unfolded_F",[0,0,0],[],0,"NONE"];
    _terminal setPosATL ((getPosATL _desk) vectorAdd [0,0,0.8]);
    [_terminal,west,"TOC ATLAS / TEST"] call SICS_fnc_registerTOC;
    SICS_testTerminal=_terminal;
    player addAction ["Open SICS test workstation",{[] call SICS_fnc_open}];
    player addAction ["Run SICS local smoke checks",{[] execVM "smoke.sqf"}];
    sleep 5;
    diag_log format ["SICS_TEST READY: side=%1 owner=%2 device=%3",side player,owner player,[player] call SICS_fnc_access];
    [] call SICS_fnc_open;
};
