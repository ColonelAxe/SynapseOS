// Noninteractive moving map; U leaves flight and movement input available.
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
        _map setVariable ["ATLAS_hudMounted",_mounted];_map setVariable ["ATLAS_hudLeft",_left];
        private _w=safeZoneW*([0.32,0.28] select _mounted);
        private _aspect=[2,1.05] select _mounted;
        private _h=(_w/pixelW)/_aspect*pixelH;
        if (_h>safeZoneH*0.48) then {_h=safeZoneH*0.48;_w=(_h/pixelH)*_aspect*pixelW};
        private _x=safeZoneX+safeZoneW-_w-safeZoneW*0.025;
        private _y=safeZoneY+safeZoneH-_h-safeZoneH*0.05;
        if (_left) then {_x=safeZoneX+safeZoneW*0.025};
        private _frame=_d displayCtrl 90;_frame ctrlShow (!_mounted);
        _frame ctrlSetText "\x\sics\addons\core\ui\phone_frame_ca.paa";
        _frame ctrlSetPosition [_x,_y,_w,_h];_frame ctrlCommit 0;
        {private _c=_d displayCtrl _x;_c ctrlShow _mounted} forEach [94,95,96];
        (_d displayCtrl 94) ctrlSetPosition [_x,_y,_w,_h];(_d displayCtrl 94) ctrlCommit 0;
        (_d displayCtrl 95) ctrlSetPosition [_x+_w*0.09,_y+_h*0.09,_w*0.82,_h*0.82];(_d displayCtrl 95) ctrlCommit 0;
        (_d displayCtrl 96) ctrlSetPosition [_x+_w*0.10,_y+_h*0.10,_w*0.80,_h*0.80];(_d displayCtrl 96) ctrlCommit 0;
        for "_i" from 0 to 15 do {
            private _key=_d displayCtrl (140+_i);
            if (isNull _key) then {_key=_d ctrlCreate ["RscText",140+_i];_key ctrlSetBackgroundColor [0.15,0.17,0.18,1]};
            _key ctrlShow _mounted;
            private _side=floor (_i/4);private _step=(_i mod 4)*0.16+0.24;
            private _px=[_step,0.925,_step,0.025] select _side;
            private _py=[0.025,_step,0.925,_step] select _side;
            _key ctrlSetPosition [_x+_w*_px,_y+_h*_py,_w*0.05,_h*0.05];_key ctrlCommit 0;
        };
        private _title=_d displayCtrl 2;
        _title ctrlSetPosition [_x+_w*0.12,_y+_h*([0.16,0.105] select _mounted),_w*0.76,_h*0.075];_title ctrlSetFontHeight (pixelH*13);_title ctrlCommit 0;
        _map ctrlSetPosition [_x+_w*0.115,_y+_h*([0.28,0.19] select _mounted),_w*0.77,_h*([0.53,0.60] select _mounted)];_map ctrlCommit 0;
        private _footer=_d displayCtrl 3;
        _footer ctrlSetPosition [_x+_w*0.115,_y+_h*0.815,_w*0.77,_h*0.055];_footer ctrlSetFontHeight (pixelH*12);_footer ctrlCommit 0;
    };
    if !(_map getVariable ["SICS_drawInstalled",false]) then {
        _map setVariable ["SICS_drawInstalled",true];
        _map ctrlAddEventHandler ["Draw",{[_this select 0] call SICS_fnc_bftDraw;[_this select 0] call SICS_fnc_operationsDraw;if (vehicle player isKindOf "Air") then {[_this select 0] call SICS_fnc_mfdDraw}}];
    };
    // Visual ownship position every rendered frame removes the old half-second jumps.
    ctrlMapAnimClear _map;_map ctrlMapAnimAdd [0,missionNamespace getVariable ["ATLAS_quickScale",0.045],getPosASLVisual vehicle player];ctrlMapAnimCommit _map;
    if (diag_tickTime>(_map getVariable ["ATLAS_nextText",0])) then {
        _map setVariable ["ATLAS_nextText",diag_tickTime+0.2];
        (_d displayCtrl 2) ctrlSetText (if (_mounted) then {format ["ATLAS TAD | %1° | %2 km/h",round getDirVisual vehicle player,round abs speed vehicle player]} else {format ["GRID %1 | %2° | %3 km/h",mapGridPosition vehicle player,round getDirVisual vehicle player,round abs speed vehicle player]});
        private _nav=[] call SICS_fnc_navigation;
        (_d displayCtrl 3) ctrlSetText (if (_nav isEqualTo []) then {if (_mounted) then {format ["N-UP | GRID %1 | %2m AGL",mapGridPosition vehicle player,round ((getPosATLVisual vehicle player) select 2)]} else {""}} else {format ["CP %1/%2 | %3m | %4° | ETA %5m",(_nav select 0)+1,_nav select 1,_nav select 2,_nav select 3,_nav select 4]});
    };
},0] call CBA_fnc_addPerFrameHandler;
