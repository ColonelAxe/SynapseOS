disableSerialization;
params [["_action","LIST"]];
private _d=findDisplay 87000;if (isNull _d) exitWith {};
if (_action in ["CLEAR","READ_ALL"]) then {
    { _x set [5,true] } forEach SICS_notificationHistory;
    SICS_unread=createHashMap;SICS_channelUnread=createHashMap;
    if (_action=="CLEAR") then {SICS_notificationHistory=[];ATLAS_noticeSelected=-1};
};
{if (ctrlIDC _x>=2400 && {ctrlIDC _x<2500}) then {ctrlDelete _x}} forEach allControls _d;
["SICS_Header",2400,[0.07,0.18,0.86,0.055],"NOTIFICATION CENTRE"] call SICS_fnc_control;
private _list=["SICS_List",2401,[0.07,0.27,0.40,0.46]] call SICS_fnc_control;
["SICS_ReadOnly",2402,[0.50,0.27,0.43,0.46],"Select an update to read its details."] call SICS_fnc_control;
private _history=missionNamespace getVariable ["SICS_notificationHistory",[]];
for "_i" from (count _history-1) to 0 step -1 do {
    private _entry=_history select _i;
    private _age=floor ((diag_tickTime-(_entry select 2)) max 0);
    private _row=_list lbAdd format ["%1%2 / %3",["NEW / ",""] select (_entry param [5,false]),_entry select 0,(_entry select 1) select [0,80]];
    _list lbSetData [_row,str (_entry param [6,_i])];
    _list lbSetTooltip [_row,format ["%1 seconds ago / %2",_age,_entry select 1]];
    if ((_entry param [6,_i])==missionNamespace getVariable ["ATLAS_noticeSelected",-1]) then {_list lbSetCurSel _row};
};
private _open=["SICS_Button",2403,[0.50,0.77,0.43,0.065],"Open in ATLAS"] call SICS_fnc_control;
_open ctrlEnable false;_open ctrlAddEventHandler ["ButtonClick",{[] call SICS_fnc_noticeOpen}];
private _read=["SICS_Button",2404,[0.07,0.77,0.19,0.065],"Mark all read"] call SICS_fnc_control;
_read ctrlAddEventHandler ["ButtonClick",{["READ_ALL"] call SICS_fnc_notifications}];
private _clear=["SICS_Button",2405,[0.28,0.77,0.19,0.065],"Clear history"] call SICS_fnc_control;
_clear ctrlAddEventHandler ["ButtonClick",{["CLEAR"] call SICS_fnc_notifications}];
["SICS_Text",2406,[0.07,0.85,0.86,0.055],format ["%1 retained updates / Latest 50 / Mission session only",count _history]] call SICS_fnc_control;
_list ctrlAddEventHandler ["LBSelChanged",{
    params ["_list","_row"];if (_row<0) exitWith {};
    ATLAS_noticeSelected=parseNumber (_list lbData _row);
    private _match=SICS_notificationHistory select {(_x param [6,-1])==ATLAS_noticeSelected};
    if (_match isEqualTo []) exitWith {};
    private _e=_match select 0;private _d=findDisplay 87000;
    (_d displayCtrl 2402) ctrlSetText (format ["%1%2%2%3%2%2Received %4 seconds ago",_e select 0,toString [10],_e select 1,floor ((diag_tickTime-(_e select 2)) max 0)]);
    (_d displayCtrl 2403) ctrlEnable ((_e select 0) in ["MESSAGE","CHANNEL","ORDER","ORDER_UPDATE","ACK","REPORT","CONTACT","OPERATION"]);
}];
if (lbSize _list>0) then {private _row=lbCurSel _list;_list lbSetCurSel (_row max 0)};
[] call SICS_fnc_appHeader;[_d] call SICS_fnc_fitText;
