// Noninteractive picture: movement, steering and cockpit input remain available.
if (!hasInterface) exitWith {};
private _layer="SICS_QUICK" call BIS_fnc_rscLayer;
if (missionNamespace getVariable ["SICS_quickActive",false]) exitWith {
    _layer cutText ["","PLAIN"];SICS_quickActive=false;
    if (!isNil "SICS_quickHandle") then {[SICS_quickHandle] call CBA_fnc_removePerFrameHandler;SICS_quickHandle=nil};
};
if !([player] call SICS_fnc_access) exitWith {hint "ATLAS quick picture requires a device or an enabled vehicle seat."};
SICS_quickActive=true;_layer cutRsc ["SICS_QuickView","PLAIN"];
SICS_quickHandle=[{
    private _d=uiNamespace getVariable ["SICS_quickDisplay",displayNull];
    if (!([player] call SICS_fnc_access) || {isNull _d}) exitWith {[] call SICS_fnc_quickView};
    private _map=_d displayCtrl 40;
    private _mounted=[player] call SICS_fnc_vehicleAccess;
    private _left=missionNamespace getVariable ["ATLAS_quickLeft",false];
    if (_map getVariable ["ATLAS_hudMounted",!_mounted]!=_mounted || {_map getVariable ["ATLAS_hudLeft",!_left]!=_left}) then {
        _map setVariable ["ATLAS_hudMounted",_mounted];
        _map setVariable ["ATLAS_hudLeft",_left];
        private _w=safeZoneW*0.32;private _h=(_w/pixelW)/([2.0,1.78] select _mounted)*pixelH;
        private _x=safeZoneX+safeZoneW-_w-safeZoneW*0.025;private _y=safeZoneY+safeZoneH-_h-safeZoneH*0.05;
        if (_left) then {_x=safeZoneX+safeZoneW*0.025};
        private _frame=_d displayCtrl 90;_frame ctrlSetText format ["\x\sics\addons\core\ui\%1_frame_ca.paa",["phone","vehicle"] select _mounted];
        _frame ctrlSetPosition [_x,_y,_w,_h];_frame ctrlCommit 0;
        (_d displayCtrl 2) ctrlSetPosition [_x+_w*0.12,_y+_h*0.16,_w*0.76,_h*0.085];(_d displayCtrl 2) ctrlCommit 0;(_d displayCtrl 2) ctrlSetFontHeight (pixelH*14);
        _map ctrlSetPosition [_x+_w*0.115,_y+_h*0.28,_w*0.77,_h*0.53];_map ctrlCommit 0;
        (_d displayCtrl 3) ctrlSetPosition [_x+_w*0.115,_y+_h*0.825,_w*0.77,_h*0.055];(_d displayCtrl 3) ctrlSetFontHeight (pixelH*12);(_d displayCtrl 3) ctrlCommit 0;
    };
    if !(_map getVariable ["SICS_drawInstalled",false]) then {
        _map setVariable ["SICS_drawInstalled",true];
        _map ctrlAddEventHandler ["Draw",{[_this select 0] call SICS_fnc_bftDraw;[_this select 0,false] call cTab_fnc_drawUserMarkers;[_this select 0] call SICS_fnc_operationsDraw}];
    };
    ctrlMapAnimClear _map;_map ctrlMapAnimAdd [0,missionNamespace getVariable ["ATLAS_quickScale",0.045],getPosASLVisual vehicle player];ctrlMapAnimCommit _map;
    (_d displayCtrl 2) ctrlSetText format ["GRID %1 | %2° | %3 km/h",mapGridPosition vehicle player,round getDir vehicle player,round abs speed vehicle player];
    private _nav=[] call SICS_fnc_navigation;(_d displayCtrl 3) ctrlSetText (if (_nav isEqualTo []) then {""} else {format ["CP %1/%2 | %3m | %4° | ETA %5m",(_nav select 0)+1,_nav select 1,_nav select 2,_nav select 3,_nav select 4]});
},0.5] call CBA_fnc_addPerFrameHandler;

