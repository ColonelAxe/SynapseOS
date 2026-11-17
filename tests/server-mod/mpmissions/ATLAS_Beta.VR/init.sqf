if (isServer) then {
    ATLAS_betaTOC=createVehicle ["Land_Laptop_unfolded_F",[1510,1500,0],[],0,"NONE"];
    [ATLAS_betaTOC,west,"BETA TOC"] call SICS_fnc_registerTOC;publicVariable "ATLAS_betaTOC";
    private _car=createVehicle ["B_MRAP_01_F",[1530,1500,0],[],0,"NONE"];createVehicleCrew _car;_car allowDamage false;
    private _heli=createVehicle ["B_Heli_Light_01_F",[1560,1500,0],[],0,"NONE"];_heli allowDamage false;
    private _drone=createVehicle ["B_UAV_02_dynamicLoadout_F",[1610,1500,0],[],0,"NONE"];createVehicleCrew _drone;_drone allowDamage false;
    {
        _x params ["_name","_position"];
        private _m=createMarker [_name,_position];_m setMarkerType "respawn_inf";_m setMarkerAlpha 0;
    } forEach [["respawn_west",[1500,1500,0]],["respawn_east",[3500,3500,0]],["respawn_guerrila",[5500,5500,0]],["respawn_civilian",[7500,7500,0]];
    diag_log "ATLAS_BETA_MISSION server ready / five side-isolation slots";
};
if (hasInterface) then {[] spawn {waitUntil {!isNil "ATLAS_betaTOC"};[ATLAS_betaTOC,west,"BETA TOC"] call SICS_fnc_registerTOC}};
