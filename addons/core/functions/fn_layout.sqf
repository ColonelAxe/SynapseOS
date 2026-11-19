// Reference-led presentation; the SynapseOS transport contract stays stable.
disableSerialization;
private _d=findDisplay 87000;
private _place={params ["_id","_r"]; private _c=findDisplay 87000 displayCtrl _id; _c ctrlSetPosition (_r call SICS_fnc_rect); _c ctrlCommit 0};
private _c2=SICS_tab=="C2";
private _messages=SICS_tab=="MESSAGES";
{(_d displayCtrl _x) ctrlShow true} forEach [2,3,4,5,6,7,8,10,11,12,13,14,15];
{
    _x params ["_id","_rect"];[_id,_rect] call _place;
} forEach [[6,[0.052,0.063,0.036,0.058]],[2,[0.095,0.07,0.27,0.04]],[3,[0.38,0.07,0.23,0.04]],[7,[0.64,0.075,0.085,0.032]],[5,[0.735,0.075,0.085,0.032]],[8,[0.835,0.075,0.06,0.032]],[4,[0.91,0.075,0.04,0.032]]];
(_d displayCtrl 2) ctrlSetText "ATLAS / TACTICAL SYSTEM";
{[10+_forEachIndex,[0.05+_forEachIndex*0.151,0.14,0.14,0.052]] call _place} forEach [0,1,2,3,4,5];
(_d displayCtrl 91) ctrlSetText format ["\x\sics\addons\core\ui\surface_%1_ca.paa",if (_messages) then {"messages"} else {["tactical","c2"] select _c2}];
(_d displayCtrl 91) ctrlShow true;
{(_d displayCtrl _x) ctrlShow true} forEach [30,31,32,33,34,40,50,51,52,61,62,63];
private _lw=[0.15,0.25] select _c2;
private _mx=[0.205,0.305] select _c2;
private _mw=[0.525,0.39] select _c2;
private _rx=[0.74,0.705] select _c2;
private _rw=[0.215,0.25] select _c2;
[30,[0.045,0.215,_lw,0.04]] call _place;
(_d displayCtrl 30) ctrlSetText (["FRIENDLY FORCES","FRIENDLY ORGANIZATION"] select _c2);
(_d displayCtrl 30) ctrlSetBackgroundColor [0.025,0.09,0.13,1];
[31,[0.045,0.26,_lw,0.41]] call _place;
[32,[0.045,0.69,_lw,0.03]] call _place;
[33,[0.045,0.73,_lw,0.04]] call _place;
[34,[0.045,0.78,_lw,0.045]] call _place;
[40,[_mx,0.26,_mw,0.565]] call _place;
["SICS_Header",200,[_mx,0.215,_mw,0.04],"OPERATIONAL AREA"] call SICS_fnc_control;
[50,[_rx,0.215,_rw,0.04]] call _place;
(_d displayCtrl 50) ctrlSetBackgroundColor [0.025,0.09,0.13,1];
[51,[_rx,0.26,_rw,0.29]] call _place;
[52,[_rx,0.57,_rw,0.24]] call _place;
[61,[_mx,0.85,0.11,0.04]] call _place;
[62,[_mx+0.12,0.85,0.12,0.04]] call _place;
[63,[_mx+0.25,0.85,0.12,0.04]] call _place;
(_d displayCtrl 61) ctrlSetText "Centre selected";
(_d displayCtrl 100) ctrlShow false;
{(_d displayCtrl (10+_forEachIndex)) ctrlSetBackgroundColor (if (_x==SICS_tab) then {[0.10,0.55,0.85,1]} else {[0.11,0.20,0.28,1]})} forEach ["OVERVIEW","MESSAGES","ISR","C2","REPORTS","TOC"];
// Shared composer IDs preserve the submit handlers and runtime test contract.
if (SICS_tab in ["C2","REPORTS"]) then {
    (_d displayCtrl 51) ctrlShow false; (_d displayCtrl 52) ctrlShow false;
    (_d displayCtrl 50) ctrlSetText (["FIELD REPORT / COMPOSE","ORDER / COMPOSE"] select _c2);
    [101,[_rx,0.26,_rw*0.46,0.03]] call _place; [102,[_rx,0.30,_rw*0.46,0.04]] call _place;
    [103,[_rx+_rw*0.5,0.26,_rw*0.5,0.03]] call _place; [104,[_rx+_rw*0.5,0.30,_rw*0.5,0.04]] call _place;
    [105,[_rx,0.37,_rw,0.03]] call _place; [106,[_rx,0.41,_rw,0.22]] call _place;
    [107,[_rx,0.66,_rw,0.045]] call _place; [108,[_rx,0.73,_rw,0.04]] call _place; [109,[_rx,0.74,_rw,0.045]] call _place;
    (_d displayCtrl 107) ctrlSetBackgroundColor [0,0.43,0.68,1];
    if (SICS_tab=="REPORTS") then {
        private _contact=["SICS_Button",380,[_rx,0.85,_rw,0.04],"Mark contact on map"] call SICS_fnc_control;
        _contact ctrlSetBackgroundColor [0.10,0.55,0.85,1];
        _contact ctrlAddEventHandler ["ButtonClick",{["CONTACT",false] call SICS_fnc_mapTool}];
    };
};
if (_c2) then {
    private _show=missionNamespace getVariable ["SICS_compose",false];
    {(_d displayCtrl _x) ctrlShow _show} forEach [50,101,102,103,104,105,106,107,108];
    (_d displayCtrl 51) ctrlShow _show;
    [51,[_rx,0.78,_rw,0.055]] call _place;
    ["SICS_Header",220,[_rx,0.215,_rw,0.04],"SELECTED ELEMENT"] call SICS_fnc_control;
    ["SICS_Text",221,[_rx+0.01,0.27,_rw-0.02,0.10],""] call SICS_fnc_control;
    {
        private _b=["SICS_Button",230+_forEachIndex,[_rx+_forEachIndex*(_rw/4),0.38,_rw/4-0.003,0.035],_x] call SICS_fnc_control;
        _b ctrlAddEventHandler ["ButtonClick",{SICS_detailTab=ctrlText (_this select 0); [] call SICS_fnc_details}];
    } forEach ["OVERVIEW","TEAM","ROLE","STATUS"];
    ["SICS_ReadOnly",240,[_rx+0.01,0.435,_rw-0.02,0.37],""] call SICS_fnc_control;
    {(_d displayCtrl _x) ctrlShow !_show} forEach [220,221,230,231,232,233,240];
    private _compose=["SICS_Button",250,[_rx,0.85,0.12,0.04],["ASSIGN ORDER","ELEMENT DETAILS"] select _show] call SICS_fnc_control;
    _compose ctrlAddEventHandler ["ButtonClick",{SICS_compose=!(missionNamespace getVariable ["SICS_compose",false]); [] call SICS_fnc_page}];
    private _chat=["SICS_Button",251,[_rx+0.13,0.85,_rw-0.13,0.04],"CHAT"] call SICS_fnc_control;
    _chat ctrlAddEventHandler ["ButtonClick",{SICS_tab="MESSAGES"; [] call SICS_fnc_page}];
    [] call SICS_fnc_details;
};
if (_messages) then {
    [30,[0.045,0.215,0.22,0.04]] call _place; (_d displayCtrl 30) ctrlSetText "CHANNELS / FRIENDLY ELEMENTS";
    [31,[0.045,0.26,0.22,0.41]] call _place;
    [32,[0.045,0.69,0.22,0.03]] call _place; [33,[0.045,0.73,0.22,0.04]] call _place; [34,[0.045,0.78,0.22,0.045]] call _place;
    [50,[0.275,0.215,0.43,0.04]] call _place; (_d displayCtrl 50) ctrlSetText "MESSAGES / COMMAND NET";
    [51,[0.275,0.26,0.43,0.29]] call _place;
    [52,[0.275,0.57,0.43,0.11]] call _place;
    [101,[0.275,0.69,0.16,0.025]] call _place; [102,[0.275,0.72,0.16,0.035]] call _place;
    [103,[0.445,0.69,0.26,0.025]] call _place; [104,[0.445,0.72,0.26,0.035]] call _place;
    (_d displayCtrl 105) ctrlShow false;
    [106,[0.275,0.78,0.43,0.06]] call _place; [107,[0.565,0.855,0.14,0.04]] call _place;
    (_d displayCtrl 107) ctrlSetBackgroundColor [0,0.43,0.68,1];
    [200,[0.715,0.215,0.24,0.04]] call _place; (_d displayCtrl 200) ctrlSetText "CONVERSATION CONTEXT";
    [40,[0.715,0.62,0.24,0.205]] call _place;
    {(_d displayCtrl _x) ctrlShow false} forEach [61,62,63];
    ["SICS_Text",260,[0.725,0.28,0.22,0.30],format ["COMMAND NET\n\nSIDE: %1\nSTATION: %2\nTRANSPORT: ARMA DATA\n\nSelect a transmission to read its content. Choose the recipient in the composer.",side group player,groupId group player]] call SICS_fnc_control;
    {(_d displayCtrl _x) ctrlShow false} forEach [51,52];
    private _chat=["SICS_ChatScroll",600,[0.275,0.26,0.43,0.415],""] call SICS_fnc_control;
    private _to=_d displayCtrl 104;
    _to ctrlAddEventHandler ["LBSelChanged",{params ["_ctrl","_i"];if (_i<0 || {missionNamespace getVariable ["SICS_channelUpdating",false]}) exitWith {};SICS_chatTarget=_ctrl lbData _i;[] call SICS_fnc_chat;[] call SICS_fnc_channelUI}];
    for "_i" from 0 to (lbSize _to-1) do {if (_to lbData _i==SICS_chatTarget) exitWith {_to lbSetCurSel _i}};
    (_d displayCtrl 107) ctrlSetText "Send message";
    (_d displayCtrl 106) ctrlAddEventHandler ["KeyDown",{params ["_ctrl","_key","_shift"];if (_key in [28,156] && {!_shift}) exitWith {["MESSAGES"] call SICS_fnc_submit;true};false}];
    ["SICS_Text",601,[0.275,0.855,0.275,0.04],"Enter: send  /  Shift+Enter: new line"] call SICS_fnc_control;
    [] call SICS_fnc_chat;
    {(_d displayCtrl _x) ctrlShow false} forEach [32,33,34];
    private _new=["SICS_Button",640,[0.045,0.70,0.22,0.045],"Create chat"] call SICS_fnc_control;
    _new ctrlAddEventHandler ["ButtonClick",{[false] call SICS_fnc_channelEditor}];
    private _manage=["SICS_Button",641,[0.045,0.76,0.22,0.045],"Manage chat access"] call SICS_fnc_control;
    _manage ctrlAddEventHandler ["ButtonClick",{[true] call SICS_fnc_channelEditor}];
    [] call SICS_fnc_channelUI;
};
if (!isNil "SICS_unread") then {{private _n=SICS_unread getOrDefault [_x select 0,0];(_d displayCtrl (_x select 1)) ctrlSetText format ["%1%2",_x select 2,["",format [" (%1)",_n]] select (_n>0)]} forEach [["MESSAGES",11,"Messages"],["C2",13,"C2"],["REPORTS",14,"Reports"]]};
if (SICS_tab=="ISR") then {
    (_d displayCtrl 51) ctrlShow false; (_d displayCtrl 52) ctrlShow false;
    [110,[0.74,0.26,0.215,0.32]] call _place; [113,[0.205,0.325,0.525,0.50]] call _place;
    [111,[0.74,0.70,0.215,0.045]] call _place; [114,[0.74,0.76,0.215,0.045]] call _place;[112,[0.74,0.82,0.215,0.075]] call _place;
};
if (SICS_tab=="TOC") then {
    (_d displayCtrl 51) ctrlShow false; (_d displayCtrl 52) ctrlShow false;
    [120,[0.75,0.28,0.195,0.22]] call _place; [121,[0.75,0.53,0.195,0.25]] call _place;
};
// Tools live inside the top map border, independent of application tabs.
if (!_messages) then {
    [40,[_mx,0.325,_mw,0.50]] call _place;
    {
        private _label=["Markers","Line","Grid","Inspect unit"] select _forEachIndex;
        private _button=["SICS_Button",270+_forEachIndex,[_mx+_forEachIndex*(_mw/4),0.265,_mw/4-0.004,0.043],_label] call SICS_fnc_control;
        _button setVariable ["SICS_tool",_x];
        _button ctrlSetTooltip (["Open map markers menu","Draw a line","Select a grid","Select a friendly unit and inspect its live details"] select _forEachIndex);
        _button ctrlAddEventHandler ["ButtonClick",{[(_this select 0) getVariable "SICS_tool",true] call SICS_fnc_mapTool}];
    } forEach ["MARKER","LINE","GRID","INSPECT"];
    [SICS_mapTool,false,true] call SICS_fnc_mapTool;
};
if ((missionNamespace getVariable ["SICS_deviceMode","TABLET"]) in ["PHONE","PORTABLE"]) then {[] call SICS_fnc_mobileLayout};
if (SICS_tab=="ISR") then {{(_d displayCtrl _x) ctrlShow false} forEach [40,61,62,63,270,271,272,273];(_d displayCtrl 200) ctrlSetText "ISR / LIVE VIDEO"};
if !(SICS_deviceMode in ["PHONE","PORTABLE"]) then {[60,[0.045,0.895,0.91,0.025]] call _place};
[] call SICS_fnc_appHeader;
[_d] call SICS_fnc_fitText;

