params ["_unit","_record"];
if (side group _unit!=(_record select 1)) exitWith {false};
private _target=_record select 7;
if (_target find "CH:"==0) exitWith {
    private _channel=SICS_channels getOrDefault [_target,[]];
    [_unit,_channel] call SICS_fnc_channelAccess
};
_target=="" || {_target==netId group _unit} || {getPlayerUID _unit==(_record select 9)}

