// Trusted mission API: [screen,side,textureSelection,name] call ATLAS_fnc_briefingScreen.
params ["_object",["_side",west],["_selection",0],["_title","TOC briefing"]];
if (isRemoteExecuted) exitWith {false};
if (isNull _object || {!(_side in [west,east,resistance,civilian])} || {_selection<0} || {_selection!=floor _selection}) exitWith {false};
if (isServer && {_selection>=count getObjectTextures _object}) exitWith {diag_log "ATLAS briefing: choose a retexturable screen selection.";false};
if (isServer && {count (missionNamespace getVariable ["ATLAS_briefScreens",[]])>=20} && {!(_object in ATLAS_briefScreens)}) exitWith {false};
if (isServer) then {
    if (_selection>=count getObjectTextures _object) exitWith {diag_log "ATLAS briefing: choose an object with a retexturable screen selection.";false};
    if (isNil "ATLAS_briefScreens") then {ATLAS_briefScreens=[]};ATLAS_briefScreens=ATLAS_briefScreens select {!isNull _x && {alive _x}};
    if (count ATLAS_briefScreens>=20 && {!(_object in ATLAS_briefScreens)}) exitWith {false};
    private _name=_object getVariable ["ATLAS_briefName",""];
    if (_name=="") then {ATLAS_briefSequence=(missionNamespace getVariable ["ATLAS_briefSequence",0])+1;_name="atlas_brief_"+str ATLAS_briefSequence};
    _object setVariable ["ATLAS_briefName",_name,true];_object setVariable ["ATLAS_briefSide",_side,true];
    _object setVariable ["ATLAS_briefing",[_side,"","",0.1],true];
    _object setObjectTextureGlobal [_selection,format ['#(rgb,1024,1024,1)ui("ATLAS_BriefDisplay","%1")',_name]];
    ATLAS_briefScreens pushBackUnique _object;publicVariable "ATLAS_briefScreens";
};
[_object,_side,_title] call SICS_fnc_registerTOC;
true
