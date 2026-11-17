// Hit areas follow the physical artwork in shell coordinates, outside the glass.
disableSerialization;
private _d=findDisplay 87000;if (isNull _d) exitWith {};
private _phone=SICS_deviceMode in ["PHONE","PORTABLE"];
private _buttons=if (_phone) then {
    [["ATLAS",[0.205,0.008,0.125,0.048],"ATLAS shortcut"],["OUT",[0.354,0.016,0.073,0.036],"Map zoom out"],["IN",[0.448,0.016,0.073,0.036],"Map zoom in"],["HOME",[0.44,0.932,0.115,0.055],"Home / Start"],["POWER",[0.968,0.325,0.028,0.37],"Power off"],["MESSAGES",[0.004,0.325,0.025,0.37],"Messages shortcut"]]
} else {
    [["HOME",[0.133,0.882,0.049,0.05],"Home / Start"],["OUT",[0.187,0.882,0.049,0.05],"Map zoom out"],["IN",[0.24,0.882,0.049,0.05],"Map zoom in"],["POWER",[0.795,0.882,0.053,0.05],"Power off"]]
};
for "_i" from 70 to 79 do {(_d displayCtrl _i) ctrlShow false};
{
    _x params ["_action","_r","_tip"];
    private _b=_d displayCtrl (70+_forEachIndex);
    if (isNull _b) then {_b=_d ctrlCreate ["SICS_HardwareButton",70+_forEachIndex];_b ctrlAddEventHandler ["ButtonClick",{[(_this select 0) getVariable "ATLAS_frameAction"] call SICS_fnc_frameAction}]};
    _b setVariable ["ATLAS_frameAction",_action];_b ctrlSetTooltip _tip;
    SICS_shellViewport params ["_sx","_sy","_sw","_sh"];
    _b ctrlSetPosition [_sx+(_r select 0)*_sw,_sy+(_r select 1)*_sh,(_r select 2)*_sw,(_r select 3)*_sh];_b ctrlShow true;_b ctrlCommit 0;
} forEach _buttons;
