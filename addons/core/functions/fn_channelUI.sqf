disableSerialization;
private _d=findDisplay 87000;
if (isNull _d || {missionNamespace getVariable ["SICS_tab",""]!="MESSAGES"}) exitWith {};
private _to=_d displayCtrl 104;if (isNull _to) exitWith {};
private _keep=missionNamespace getVariable ["SICS_chatTarget",""];
SICS_channelUpdating=true;lbClear _to;
private _i=_to lbAdd "ALL STATIONS";_to lbSetData [_i,""];
{if (side _x==side group player) then {private _row=_to lbAdd groupId _x;_to lbSetData [_row,netId _x]}} forEach allGroups;
{private _row=_to lbAdd format ["# %1",_x select 2];_to lbSetData [_row,_x select 0]} forEach SICS_clientChannels;
for "_row" from 0 to (lbSize _to-1) do {if (_to lbData _row==_keep) exitWith {_to lbSetCurSel _row}};
SICS_channelUpdating=false;
(_d displayCtrl 640) ctrlEnable SICS_canCreateChannel;
private _channel=SICS_clientChannels select {(_x select 0)==_keep};
(_d displayCtrl 641) ctrlEnable (_channel isNotEqualTo [] && {[player,_channel select 0,true] call SICS_fnc_channelAccess});
[] call SICS_fnc_refresh;[] call SICS_fnc_chat;

