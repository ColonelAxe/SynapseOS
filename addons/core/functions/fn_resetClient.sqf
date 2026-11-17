// Clear side-specific/session data before any new-side UI can be opened.
if (!hasInterface) exitWith {};
ATLAS_revokingSession=!isNull findDisplay 87000;
if (!isNull findDisplay 87000) then {["POWER"] call SICS_fnc_toggleDevice};
if (missionNamespace getVariable ["SICS_quickActive",false]) then {[] call SICS_fnc_quickView};
[] call SICS_fnc_stopCamera;[] call SICS_fnc_cameraClose;
{deleteMarkerLocal format ["SICS_SIDE_%1",_x select 0]} forEach values (missionNamespace getVariable ["SICS_clientMarkers",createHashMap]);
{deleteMarkerLocal _x} forEach (missionNamespace getVariable ["SICS_contactNames",[]]);
{"atlas_media" callExtension ["drop",[_x]]} forEach keys (missionNamespace getVariable ["ATLAS_photoMeta",createHashMap]);
SICS_localRecords=[];SICS_clientMarkers=createHashMap;SICS_contactNames=[];SICS_seenRecords=createHashMap;
SICS_clientChannels=[];SICS_channelRoster=[];SICS_canCreateChannel=false;SICS_chatTarget="";
SICS_unread=createHashMap;SICS_channelUnread=createHashMap;SICS_notificationHistory=[];SICS_notificationAudioQueue=[];
SICS_savedAtlas=createHashMap;SICS_tracks=createHashMap;SICS_selectedUnit=objNull;SICS_pendingMarker=[];
ATLAS_photoMeta=createHashMap;ATLAS_photoUploaded=createHashMap;ATLAS_photoRecords=createHashMap;ATLAS_photoSkip=createHashMap;
ATLAS_cameraSelected="";ATLAS_reportPhoto="";ATLAS_noticeSelected=-1;SICS_pendingChatDraft="";
SICS_osLastApp="HOME";
ATLAS_clientOperations=createHashMap;ATLAS_clientJournal=[];ATLAS_opsSelected="";ATLAS_opsDraftPoints=[];
ATLAS_followRoute="";ATLAS_networkTracks=createHashMap;ATLAS_hiddenPlans=[];
ATLAS_operationDraft=[];ATLAS_redrawDraft=[];ATLAS_opsCapture=false;ATLAS_operationsHydrated=false;
