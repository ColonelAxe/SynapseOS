disableSerialization;
private _d=findDisplay 87000;
private _group=_d displayCtrl 600;
if (isNull _group) exitWith {};
{ctrlDelete _x} forEach allControls _group;
private _target=missionNamespace getVariable ["SICS_chatTarget",""];
{if ((_x select 0)=="MESSAGE" && {(_x select 3)==_target}) then {_x set [5,true]}} forEach (missionNamespace getVariable ["SICS_notificationHistory",[]]);
private _channel="All stations";
private _custom=_target find "CH:"==0;
private _info=[];
if (_custom) then {_info=SICS_clientChannels select {(_x select 0)==_target};_info=if (_info isEqualTo []) then {[]} else {_info select 0};_channel=_info param [2,"Unavailable channel"]} else {
    if (_target!="") then {private _g=groupFromNetId _target;if (!isNull _g) then {_channel=groupId _g}};
};
if (_custom) then {
    private _read=SICS_channelUnread getOrDefault [_target,0];SICS_channelUnread set [_target,0];
    SICS_unread set ["MESSAGES",((SICS_unread getOrDefault ["MESSAGES",0])-_read) max 0];
    private _remaining=SICS_unread getOrDefault ["MESSAGES",0];
    (_d displayCtrl 11) ctrlSetText (if (_remaining>0) then {format ["Messages (%1)",_remaining]} else {"Messages"});
};
(_d displayCtrl 50) ctrlSetText format ["%1  /  Chat",_channel];
(_d displayCtrl 260) ctrlSetText format ["%1\n\nSIDE: %2\nSTATION: %3\n\nSide-shared command chat. Select a friendly element to change conversation, or All stations for broadcasts.",_channel,side group player,groupId group player];
if (_custom && {_info isNotEqualTo []}) then {(_d displayCtrl 260) ctrlSetText format ["%1\n\nTYPE: %2\nPLAYERS: %3 grants\nGROUPS: %4 grants\n\nACCESS CONTROLLED\nOnly members receive messages and history. Owner and managers maintain access.",_channel,_info select 3,count (_info select 5),count (_info select 6)]};
private _records=(missionNamespace getVariable ["SICS_localRecords",[]]) select {(_x select 2)=="MESSAGES" && {(_x select 7)==_target || {!_custom && {(_x select 7)=="" && {_target!=""}}}}};
private _escape={params ["_text"];((_text splitString "&") joinString "&amp;") splitString "<" joinString "&lt;"};
private _width=ctrlPosition _group select 2;
private _vh=SICS_viewport select 3;
private _pad=_width*0.035;
private _y=_vh*0.012;
if (_records isEqualTo []) then {
    private _empty=_d ctrlCreate ["SICS_ChatText",-1,_group];
    _empty ctrlSetPosition [_pad,_y,_width-2*_pad,_vh*0.1];
    _empty ctrlSetStructuredText parseText "<t color='#7f9bae'>No messages yet.<br/>Send the first update below.</t>";
    _empty ctrlCommit 0;
};
{
    private _own=(_x select 9)==getPlayerUID player;
    private _sender=[_x select 3] call _escape;
    private _body=([_x select 4] call _escape) splitString toString [10] joinString "<br/>";
    private _seconds=floor (_x select 6);
    private _minutes=floor (_seconds/60);
    private _secondText=str (_seconds mod 60);if (count _secondText<2) then {_secondText="0"+_secondText};
    private _left=[_pad,_pad*2] select _own;
    private _w=_width-_pad*3;
    private _bubble=_d ctrlCreate ["RscPicture",-1,_group];
    _bubble ctrlSetText "\x\sics\addons\core\ui\button_normal_ca.paa";
    _bubble ctrlSetTextColor ([[0.09,0.18,0.25,1],[0.08,0.28,0.43,1]] select _own);
    private _text=_d ctrlCreate ["SICS_ChatText",-1,_group];
    _text ctrlSetPosition [_left+_pad,_y+_vh*0.012,_w-2*_pad,_vh*0.08];
    _text ctrlSetStructuredText parseText format ["<t color='#65bfee' size='0.9'>%1</t> <t color='#7e9aac' size='0.75'>T+%2:%3</t><br/><t color='#dbe9f2'>%4</t>",_sender,_minutes,_secondText,_body];
    _text ctrlCommit 0;
    private _h=(ctrlTextHeight _text) max (_vh*0.065);
    _text ctrlSetPosition [_left+_pad,_y+_vh*0.012,_w-2*_pad,_h];_text ctrlCommit 0;
    _bubble ctrlSetPosition [_left,_y,_w,_h+_vh*0.025];_bubble ctrlCommit 0;
    _y=_y+_h+_vh*0.042;
} forEach _records;
_group ctrlSetScrollValues [1,0];

