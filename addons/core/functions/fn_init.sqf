if (isServer) then {
    ATLAS_operations=createHashMap;ATLAS_operationsSequence=0;ATLAS_operationsVersion=0;
    ATLAS_operationsRate=createHashMap;ATLAS_operationsSignatures=createHashMap;
    ATLAS_journal=[];ATLAS_journalSequence=0;ATLAS_briefScreens=[];
    [createHashMap] call SICS_fnc_configureMission;
    [{[] call SICS_fnc_heartbeat},5] call CBA_fnc_addPerFrameHandler;
    SICS_records = [];
    SICS_sequence = 0;
    SICS_rate = createHashMap;
    SICS_markers=createHashMap;
    SICS_markerSequence=0;
    SICS_channels=createHashMap;SICS_channelSequence=0;SICS_channelSignatures=createHashMap;
    ATLAS_serverPhotos=createHashMap;ATLAS_photoRate=createHashMap;
    [{ {[_x] call SICS_fnc_channelSync} forEach allPlayers },2] call CBA_fnc_addPerFrameHandler;
};
{private _name=configName _x;missionNamespace setVariable ["ATLAS_fnc_"+_name,missionNamespace getVariable ("SICS_fnc_"+_name)]} forEach ("true" configClasses (configFile >> "CfgFunctions" >> "SICS" >> "Core"));
if (!hasInterface) exitWith {};
[] call SICS_fnc_preferences;
[] call SICS_fnc_initACE;
if (isNil "SYNAPSE_apps") then {SYNAPSE_apps=createHashMap};
["ATLAS","ATLAS","\x\sics\addons\core\ui\atlas_glyph_ca.paa",{[] call SICS_fnc_resumeSession},{true},{private _n=0;{_n=_n+_x} forEach values (missionNamespace getVariable ["SICS_unread",createHashMap]);_n}] call SICS_fnc_registerApp;
["SETTINGS","Settings","\x\sics\addons\core\ui\settings_glyph_ca.paa",{[] call SICS_fnc_settings}] call SICS_fnc_registerApp;
["CAMERA","Camera","\x\sics\addons\core\ui\camera_glyph_ca.paa",{[] call SICS_fnc_camera}] call SICS_fnc_registerApp;
["NOTIFICATIONS","Notifications","\x\sics\addons\core\ui\notifications_glyph_ca.paa",{[] call SICS_fnc_notifications},{true},{count ((missionNamespace getVariable ["SICS_notificationHistory",[]]) select {!(_x param [5,false])})}] call SICS_fnc_registerApp;
["OPERATIONS","Operations","\x\sics\addons\core\ui\operations_glyph_ca.paa",{[] call SICS_fnc_operations}] call SICS_fnc_registerApp;
ATLAS_clientOperations=createHashMap;ATLAS_clientJournal=[];ATLAS_opsLayers=[true,true,true];
ATLAS_opsTab="PLANS";ATLAS_opsSelected="";ATLAS_opsDraftPoints=[];ATLAS_hiddenPlans=[];
ATLAS_networkTracks=createHashMap;ATLAS_followRoute="";
[{
    if (isNull player) exitWith {};
    [] call SICS_fnc_navigation;
    {
        private _name=_x getVariable ["ATLAS_briefName",""];private _d=findDisplay _name;
        if (!isNull _d && {player distance _x<100}) then {displayUpdate _d};
        if !(_x getVariable ["SICS_actionAdded",false]) then {[_x,_x getVariable ["ATLAS_briefSide",west],"ATLAS briefing"] call SICS_fnc_registerTOC};
    } forEach (missionNamespace getVariable ["ATLAS_briefScreens",[]]);
    if (isNil "ATLAS_contactVisualState") then {ATLAS_contactVisualState=createHashMap};
    {
        private _life=_x param [13,[]];
        if ((_x param [11,[]]) isNotEqualTo [] && {_life isNotEqualTo []}) then {
            private _id=str (_x select 0);private _state=serverTime>(_life select 2);
            if (ATLAS_contactVisualState getOrDefault [_id,!_state]!=_state) then {[_x] call SICS_fnc_contactApply;ATLAS_contactVisualState set [_id,_state]};
        };
    } forEach (missionNamespace getVariable ["SICS_localRecords",[]]);
    if (count ATLAS_contactVisualState>600) then {private _ids=SICS_localRecords apply {str (_x select 0)};{if !(_x in _ids) then {ATLAS_contactVisualState deleteAt _x}} forEach keys ATLAS_contactVisualState};
},1] call CBA_fnc_addPerFrameHandler;
ATLAS_photoMeta=createHashMap;ATLAS_photoUploaded=createHashMap;ATLAS_photoRecords=createHashMap;
ATLAS_photoSkip=createHashMap;
ATLAS_cameraSelected="";ATLAS_reportPhoto="";
Synapse_fnc_registerApp=SICS_fnc_registerApp;Synapse_fnc_launchApp=SICS_fnc_launchApp;Synapse_fnc_home=SICS_fnc_osHome;
Synapse_fnc_open={ ["OPEN"] call SICS_fnc_toggleDevice };
SICS_deviceState="CLOSED";SICS_osLastApp="HOME";SICS_deviceKeyHeld=false;
SICS_clientMarkers=createHashMap;
SICS_markerSide=sideUnknown;
SICS_contactNames=[];
SICS_seenRecords=createHashMap;
SICS_unread=createHashMap;
SICS_notificationHistory=[];
SICS_clientChannels=[];SICS_channelRoster=[];SICS_channelUnread=createHashMap;SICS_canCreateChannel=false;
[{
    if (isNull player) exitWith {};
    if (side group player!=SICS_markerSide) then {
        // Initial unknown-side setup has no old session to revoke.
        if (SICS_markerSide!=sideUnknown) then {[] call SICS_fnc_resetClient};
        SICS_markerSide=side group player;
    };
},2] call CBA_fnc_addPerFrameHandler;
[] spawn {
    waitUntil {!isNull player && {!isNil "cTab_player"}};
    {
        _x params ["_id","_title","_description","_default"];
        ["SynapseOS",_id,[_title,_description],compile format ['["%1"] call SICS_fnc_keyAction',_id],compile format ['["%1",true] call SICS_fnc_keyAction',_id],_default,false] call CBA_fnc_addKeybind;
    } forEach [
        ["ifMain","Toggle Main","Toggle the moving GPS overlay",[22,[false,false,false]]],
        ["ifSecondary","Toggle Secondary","Toggle the full device or mounted console",[22,[false,true,false]]],
        ["ifTertiary","Toggle Tertiary","Toggle carried equipment, preferring the tablet",[22,[false,false,true]]],
        ["zoomIn","Zoom In","Zoom the GPS or visible tactical map in",[201,[true,true,false]]],
        ["zoomOut","Zoom Out","Zoom the GPS or visible tactical map out",[209,[true,true,false]]],
        ["toggleIfPosition","Toggle Interface Position","Swap overlay sides or reset full device position",[199,[true,true,false]]]
    ];
};

