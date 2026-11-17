disableSerialization;
params [["_edit",false]];
private _channel=[];
if (_edit) then {_channel=(missionNamespace getVariable ["SICS_clientChannels",[]]) select {(_x select 0)==SICS_chatTarget};_channel=if (_channel isEqualTo []) then {[]} else {_channel select 0}};
if (_edit && {!([player,_channel,true] call SICS_fnc_channelAccess)}) exitWith {hint "Only this channel's owner or managers can edit access."};
if (!_edit && {!SICS_canCreateChannel}) exitWith {hint "Channel creation requires mission-designated commander access."};
if (!isNull findDisplay 87002) then {findDisplay 87002 closeDisplay 2};
private _d=findDisplay 87000 createDisplay "SICS_ChannelDisplay";
if (isNull _d) exitWith {};
_d setVariable ["SICS_channel",_channel];
private _make={params ["_class","_id","_rect",["_text",""]];[_class,_id,_rect,_text,findDisplay 87002] call SICS_fnc_control};
["SICS_Text",800,[0.16,0.20,0.68,0.68],""] call _make;
["SICS_Header",801,[0.16,0.20,0.68,0.05],["CREATE CHANNEL","MANAGE CHANNEL ACCESS"] select _edit] call _make;
["SICS_Text",802,[0.18,0.26,0.39,0.03],"CHANNEL NAME"] call _make;
["SICS_Edit",803,[0.18,0.30,0.39,0.04],_channel param [2,"Command Net"]] call _make;
["SICS_Text",804,[0.59,0.26,0.23,0.03],"CHAT TYPE"] call _make;
private _type=["SICS_Combo",805,[0.59,0.30,0.23,0.04]] call _make;
{private _r=_type lbAdd _x;_type lbSetData [_r,["COMMAND","GROUND-AIR","CUSTOM"] select _forEachIndex]} forEach ["Command","Ground to Air","Custom"];
_type lbSetCurSel (["COMMAND","GROUND-AIR","CUSTOM"] find (_channel param [3,"COMMAND"]));
private _players=_channel param [5,[]];private _groups=_channel param [6,[]];private _managers=_channel param [7,[]];
private _roster=+SICS_channelRoster;
{private _uid=_x;if (_roster findIf {(_x select 0)==_uid}<0) then {_roster pushBack [_uid,format ["Offline / %1",_uid],"",""]}} forEach (_players+_managers);
{
    _x params ["_id","_xpos","_title"];
    ["SICS_Header",_id+10,[_xpos,0.37,0.20,0.035],_title] call _make;
    ["SICS_MultiList",_id,[_xpos,0.415,0.20,0.28],""] call _make;
} forEach [[806,0.18,"PLAYERS"],[807,0.40,"GROUPS"],[808,0.62,"MANAGERS"]];
{
    _x params ["_uid","_name","_group"];
    if (_uid!="") then {
        private _list=_d displayCtrl 806;private _r=_list lbAdd _name;_list lbSetData [_r,_uid];_list lbSetTooltip [_r,format ["%1 / %2",_name,_group]];_list lbSetSelected [_r,_uid in _players];
        _list=_d displayCtrl 808;_r=_list lbAdd _name;_list lbSetData [_r,_uid];_list lbSetSelected [_r,_uid in _managers];
    };
} forEach _roster;
{if (side _x==side group player) then {private _list=_d displayCtrl 807;private _r=_list lbAdd groupId _x;_list lbSetData [_r,netId _x];_list lbSetSelected [_r,netId _x in _groups]}} forEach allGroups;
["SICS_Text",809,[0.18,0.71,0.64,0.06],"Ctrl+click to select multiple entries. Players OR groups grant access. Owner and managers always have access."] call _make;
["SICS_Text",819,[0.18,0.77,0.64,0.025],"Player grants survive respawn / reconnect. Group grants follow the current group."] call _make;
private _save=["SICS_Button",820,[0.18,0.815,0.20,0.04],"Save channel"] call _make;
SICS_fnc_saveChannel={
    private _d=findDisplay 87002;private _channel=_d getVariable ["SICS_channel",[]];
    private _name=trim ctrlText (_d displayCtrl 803);
    if (count _name<1 || {count _name>32}) exitWith {(_d displayCtrl 819) ctrlSetText "Enter a name from 1 to 32 characters."};
    private _lists=[806,807,808] apply {private _list=_d displayCtrl _x;(lbSelection _list) apply {_list lbData _x}};
    private _type=_d displayCtrl 805;
    [player,["CHANNEL_CREATE","CHANNEL_UPDATE"] select (_channel isNotEqualTo []),[_channel param [0,""],_name,_type lbData lbCurSel _type,_lists select 0,_lists select 1,_lists select 2],SICS_terminal] remoteExecCall ["SICS_fnc_server",2];
};
_save ctrlAddEventHandler ["ButtonClick",{[] call SICS_fnc_saveChannel}];
private _cancel=["SICS_Button",821,[0.62,0.815,0.20,0.04],"Cancel"] call _make;
_cancel ctrlAddEventHandler ["ButtonClick",{findDisplay 87002 closeDisplay 2}];
if (_edit) then {
    private _delete=["SICS_Button",822,[0.40,0.815,0.20,0.04],"Delete channel"] call _make;
    _delete ctrlSetBackgroundColor [0.60,0.16,0.18,1];
    _delete ctrlAddEventHandler ["ButtonClick",{
        private _d=findDisplay 87002;private _channel=_d getVariable ["SICS_channel",[]];
        if !(_d getVariable ["SICS_confirmDelete",false]) exitWith {
            _d setVariable ["SICS_confirmDelete",true];(_d displayCtrl 822) ctrlSetText "Confirm delete";
            (_d displayCtrl 819) ctrlSetText format ["Delete '%1' and all its history? Click Confirm delete to continue.",_channel select 2];
        };
        [player,"CHANNEL_DELETE",[_channel select 0],SICS_terminal] remoteExecCall ["SICS_fnc_server",2];
    }];
};
[_d] call SICS_fnc_fitText;

