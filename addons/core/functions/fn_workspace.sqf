params [["_action","LIST"],["_name","JTAC"]];
private _presets=profileNamespace getVariable ["ATLAS_workspaces",createHashMap];
if !(_presets isEqualType createHashMap) then {_presets=createHashMap};
if (_action=="LIST") exitWith {private _names=["JTAC","Platoon Leader","Pilot"]+keys _presets;_names=_names arrayIntersect _names;_names sort true;_names};
if (count _name<1 || {count _name>32}) exitWith {hint "Preset names must be 1–32 characters.";false};
ATLAS_workspaceName=_name;
if (_action=="DELETE") exitWith {_presets deleteAt _name;profileNamespace setVariable ["ATLAS_workspaces",_presets];saveProfileNamespace;true};
if (_action=="SAVE") exitWith {
    if (count _presets>=20 && {!(_name in _presets)}) exitWith {hint "Maximum 20 saved workspaces.";false};
    private _map=findDisplay 87000 displayCtrl 2601;private _r=ctrlPosition _map;
    private _entry=[worldName,[] call SICS_fnc_preferences,missionNamespace getVariable ["SICS_preferredDevice","TABLET"],ctrlMapScale _map,_map ctrlMapScreenToWorld [(_r select 0)+(_r select 2)/2,(_r select 1)+(_r select 3)/2],+ATLAS_opsLayers];
    _presets set [_name,_entry];profileNamespace setVariable ["ATLAS_workspaces",_presets];saveProfileNamespace;hint "Workspace saved locally.";true
};
private _entry=_presets getOrDefault [_name,[]];
if (_entry isEqualTo []) then {
    private _prefs=[true,true,1,false,true];private _device="PHONE";private _scale=0.08;
    if (_name=="Platoon Leader") then {_prefs=[true,true,1.15,true,true];_device="TABLET";_scale=0.04};
    if (_name=="Pilot") then {_scale=0.2};
    if !(_name in ["JTAC","Platoon Leader","Pilot"]) exitWith {_device=""};
    if (_device!="") then {_entry=[worldName,_prefs,_device,_scale,getPosASL player,[true,true,true]]};
};
if (!(_entry isEqualType []) || {count _entry!=6} || {!((_entry select 1) isEqualType [])} || {count (_entry select 1)!=5} || {!((_entry select 5) isEqualType [])} || {count (_entry select 5)!=3} || {!((_entry select 5) isEqualTypeAll true)}) exitWith {hint "No valid workspace saved under that name.";false};
if (!((_entry select 0) isEqualType "") || {!((_entry select 2) isEqualType "")} || {!((_entry select 3) isEqualType 0)} || {!finite (_entry select 3)} || {_entry select 3<0.001} || {_entry select 3>1} || {!((_entry select 4) isEqualType [])} || {count (_entry select 4)<2} || {(_entry select 4) findIf {!(_x isEqualType 0) || {!finite _x}}>=0}) exitWith {hint "Workspace map data is invalid.";false};
{[_x,(_entry select 1) select _forEachIndex] call SICS_fnc_preferences} forEach ["voice","banners","text","trails","labels"];
private _device=_entry select 2;if (_device in ([player,SICS_terminal] call SICS_fnc_devices)) then {SICS_preferredDevice=_device};
ATLAS_opsLayers=+(_entry select 5);
{[_x] call SICS_fnc_contactApply} forEach SICS_localRecords;
if (_entry select 0==worldName) then {ATLAS_operationsMap=[_entry select 3,_entry select 4]};
if (!(SICS_deviceMode in ["VEHICLE","AVIATION","WORKSTATION"]) && {_device in ([player,SICS_terminal] call SICS_fnc_devices)}) then {[_device] call SICS_fnc_deviceLayout} else {[] call SICS_fnc_operations};
hint "Workspace applied. Mission permissions are unchanged.";
true
