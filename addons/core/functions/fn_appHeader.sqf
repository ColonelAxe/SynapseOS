// Keep every app inside the glass, independent of the previously open app.
disableSerialization;
params [["_desktop",false]];
private _d=findDisplay 87000;if (isNull _d) exitWith {};
private _small=SICS_deviceMode in ["PHONE","PORTABLE"];
private _y=if (_desktop) then {[0.061,0.083] select _small} else {0.08};
private _h=[0.042,0.03] select _desktop;
private _iw=_h*(SICS_viewport select 3)/pixelH*pixelW/(SICS_viewport select 2);
{
    _x params ["_id","_rect"];
    private _c=_d displayCtrl _id;_c ctrlSetPosition (_rect call SICS_fnc_rect);_c ctrlCommit 0;
    _c ctrlShow true;
} forEach [[6,[0.055,_y,_iw,_h]],[2,[0.095,_y,0.225,_h]],[3,[0.33,_y,0.23,_h]],[7,[0.58,_y,0.08,_h]],[5,[0.68,_y,0.11,_h]],[8,[0.81,_y,0.065,_h]],[4,[0.90,_y,0.05,_h]]];
private _app=missionNamespace getVariable ["SICS_osApp","HOME"];
private _atlas=_app=="ATLAS";
(_d displayCtrl 6) ctrlSetText (["\x\sics\addons\core\ui\synapse_logo_ca.paa","\x\sics\addons\core\ui\atlas_app_ca.paa"] select _atlas);
(_d displayCtrl 2) ctrlSetText (switch (_app) do {case "ATLAS":{"ATLAS"};case "HOME":{"SynapseOS"};case "CAMERA":{"SynapseOS / Camera"};case "SETTINGS":{"SynapseOS / Settings"};case "NOTIFICATIONS":{"SynapseOS / Notifications"};case "OPERATIONS":{"ATLAS / Operations"};default {"SynapseOS"}});
(_d displayCtrl 7) ctrlShow !_desktop;
(_d displayCtrl 5) ctrlSetText SICS_deviceMode;
[_d] call SICS_fnc_fitText;
[] call SICS_fnc_frameButtons;
