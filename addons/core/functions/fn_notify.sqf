params ["_kind","_description",["_target",""],["_recordId",-1]];
if (!hasInterface || {isNull player} || {!([player,missionNamespace getVariable ["SICS_terminal",objNull]] call SICS_fnc_access)}) exitWith {};
private _bucket=switch (_kind) do {case "MESSAGE":{"MESSAGES"};case "CHANNEL":{"MESSAGES"};case "INFO":{""};case "OPERATION":{""};case "ORDER":{"C2"};case "ORDER_UPDATE":{"C2"};case "ACK":{"C2"};default {"REPORTS"}};
if (isNil "SICS_unread") then {SICS_unread=createHashMap};
private _reading=!isNull findDisplay 87000 && {missionNamespace getVariable ["SICS_osApp","HOME"]=="ATLAS"} && {missionNamespace getVariable ["SICS_tab",""]==_bucket} && {_kind!="MESSAGE" || {_target==missionNamespace getVariable ["SICS_chatTarget",""]}};
if (!_reading && {_bucket!=""}) then {
    SICS_unread set [_bucket,(SICS_unread getOrDefault [_bucket,0])+1];
    if (_target find "CH:"==0) then {SICS_channelUnread set [_target,(SICS_channelUnread getOrDefault [_target,0])+1]};
};
if (isNil "SICS_notificationHistory") then {SICS_notificationHistory=[]};
ATLAS_noticeSequence=(missionNamespace getVariable ["ATLAS_noticeSequence",0])+1;
SICS_notificationHistory pushBack [_kind,_description,diag_tickTime,_target,_recordId,_reading,ATLAS_noticeSequence];
if (count SICS_notificationHistory>50) then {SICS_notificationHistory deleteAt 0};
private _safe=(_description splitString "&") joinString "&amp;";_safe=(_safe splitString "<") joinString "&lt;";
private _title=switch (_kind) do {case "MESSAGE":{"ATLAS / New message"};case "ORDER":{"ATLAS / New order"};case "ORDER_UPDATE":{"ATLAS / Order update"};case "ACK":{"ATLAS / Order acknowledged"};case "CONTACT":{"ATLAS / Contact report"};case "CHANNEL":{"ATLAS / Channel update"};case "INFO":{"ATLAS / Information"};case "OPERATION":{"ATLAS / Operation update"};default {"ATLAS / New report"}};
if (missionNamespace getVariable ["ATLAS_bannersEnabled",true]) then {SICS_lastNotificationShown=["SICS_Received",[_title,_safe]] call BIS_fnc_showNotification};
private _sound=switch (_kind) do {case "MESSAGE":{"SICS_Message"};case "ORDER":{"SICS_Order"};case "ACK":{"SICS_Ack"};case "CONTACT":{"SICS_Contact"};case "CHANNEL":{"SICS_Channel"};case "INFO":{"SICS_Info"};case "ORDER_UPDATE":{"SICS_Info"};case "OPERATION":{"SICS_Info"};default {"SICS_Report"}};
if (isNil "SICS_notificationAudioQueue") then {SICS_notificationAudioQueue=[]};
if (missionNamespace getVariable ["ATLAS_voiceEnabled",true]) then {SICS_notificationAudioQueue pushBack _sound};
if (count SICS_notificationAudioQueue>50) then {SICS_notificationAudioQueue deleteAt 0};
SICS_lastNotificationSoundQueued=_sound;
if !(missionNamespace getVariable ["SICS_notificationAudioActive",false]) then {
    SICS_notificationAudioActive=true;
    [] spawn {
        while {SICS_notificationAudioQueue isNotEqualTo []} do {
            private _sound=SICS_notificationAudioQueue deleteAt 0;
            if (missionNamespace getVariable ["ATLAS_voiceEnabled",true]) then {playSound _sound;SICS_lastNotificationSoundPlayed=_sound};
            sleep 2.7;
        };
        SICS_notificationAudioActive=false;
    };
};
disableSerialization;
private _d=findDisplay 87000;
if (!isNull _d) then {
    {private _n=SICS_unread getOrDefault [_x select 0,0];(_d displayCtrl (_x select 1)) ctrlSetText format ["%1%2",_x select 2,["",format [" (%1)",_n]] select (_n>0)]} forEach [["MESSAGES",11,"Messages"],["C2",13,"C2"],["REPORTS",14,"Reports"]];
};
if (!isNull _d && {missionNamespace getVariable ["SICS_osApp",""]=="NOTIFICATIONS"}) then {[] call SICS_fnc_notifications};

