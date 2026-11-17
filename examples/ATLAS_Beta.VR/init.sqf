if (isServer) then {
    [] spawn {
    waitUntil {sleep 0.1;!isNil "ATLAS_fnc_briefingScreen" && {!isNil "ATLAS_briefScreens"}};
    addMissionEventHandler ["EntityRespawned",{params ["_new","_old"];if (isPlayer _new) then {private _command=_old getVariable ["ATLAS_betaCommander",false];_new setVariable ["ATLAS_betaSlot",_old getVariable ["ATLAS_betaSlot",vehicleVarName _old],true];_new setVariable ["ATLAS_betaCommander",_command,true];_new setVariable ["ATLAS_commander",_command,true];_new allowDamage false}}];
    ATLAS_betaTOC=createVehicle ["Land_Laptop_unfolded_F",[1510,1500,0],[],0,"NONE"];
    [ATLAS_betaTOC,west,"BETA TOC"] call SICS_fnc_registerTOC;publicVariable "ATLAS_betaTOC";
    private _screen=createVehicle ["Land_TripodScreen_01_large_F",[1510,1503,0],[],0,"NONE"];
    _screen setDir 180;[_screen,west,0,"BETA BRIEFING"] call ATLAS_fnc_briefingScreen;
    private _car=createVehicle ["B_MRAP_01_F",[1530,1500,0],[],0,"NONE"];createVehicleCrew _car;_car allowDamage false;
    _car limitSpeed 25;driver _car doMove [1530,2200,0];
    private _empty=createVehicle ["B_MRAP_01_F",[1535,1510,0],[],0,"NONE"];_empty allowDamage false;
    private _heli=createVehicle ["B_Heli_Light_01_F",[1560,1500,0],[],0,"NONE"];_heli allowDamage false;
    private _drone=createVehicle ["B_UAV_02_dynamicLoadout_F",[1610,1500,0],[],0,"NONE"];createVehicleCrew _drone;_drone allowDamage false;
    {group driver _x setCombatMode "BLUE";{_x allowDamage false;_x disableAI "TARGET";_x disableAI "AUTOTARGET"} forEach crew _x} forEach [_car,_drone];
    {
        _x params ["_name","_position"];
        private _m=createMarker [_name,_position];_m setMarkerType "respawn_inf";_m setMarkerAlpha 0;
    } forEach [["respawn_west",[1500,1500,0]],["respawn_east",[3500,3500,0]],["respawn_guerrila",[5500,5500,0]],["respawn_civilian",[7500,7500,0]]];
    diag_log "ATLAS_BETA_MISSION CB1 ready / eight slots / HQ-only channel creation / noncombat fixtures";
    };
};
if (hasInterface) then {[] spawn {waitUntil {!isNil "ATLAS_betaTOC"};[ATLAS_betaTOC,west,"BETA TOC"] call SICS_fnc_registerTOC}};
