disableSerialization;
params ["_tool",["_openMenu",false],["_restore",false]];
private _wasInspect=(missionNamespace getVariable ["SICS_mapTool",""])=="INSPECT";
SICS_mapTool=_tool;
if (_wasInspect && {_tool!="INSPECT"}) exitWith {[] call SICS_fnc_page;if (_tool=="MARKER" && {_openMenu}) then {[SICS_selectedPosition] call SICS_fnc_markerEditor}};
SICS_lineStart=[];
if (_tool!="MARKER") then {SICS_pendingMarker=[];if (!isNull (findDisplay 87000 displayCtrl 300)) then {[] call SICS_fnc_closeMarker}};
private _d=findDisplay 87000;
{
    (_d displayCtrl (270+_forEachIndex)) ctrlSetBackgroundColor (if (_x==_tool) then {[0.10,0.55,0.85,1]} else {[0.11,0.20,0.28,1]});
} forEach ["MARKER","LINE","GRID","INSPECT"];
if (_tool=="INSPECT") then {[] call SICS_fnc_inspect};
if (_tool=="MARKER" && {_openMenu}) then {[SICS_selectedPosition] call SICS_fnc_markerEditor};
(_d displayCtrl 60) ctrlSetText (switch (_tool) do {
    case "MARKER": {"MARKERS / Click to place"};
    case "LINE": {"LINE / Select start and end"};
    case "CONTACT": {"REPORT / Select contact position"};
    case "INSPECT": {"INSPECT / Select friendly unit"};
    default {"GRID / Select position"};
});
if ((missionNamespace getVariable ["SICS_deviceMode","TABLET"]) in ["PHONE","PORTABLE"]) then {
    if (_tool=="CONTACT" && {!_restore}) then {SICS_mobilePane="MAP"};
    [] call SICS_fnc_mobileLayout;
};

