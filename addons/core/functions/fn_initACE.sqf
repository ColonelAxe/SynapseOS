// Optional integration: no ACE dependency when running without ACE.
if (!hasInterface || {isNil "ace_interact_menu_fnc_createAction"} || {missionNamespace getVariable ["ATLAS_aceRegistered",false]}) exitWith {};
ATLAS_aceRegistered=true;
private _icon="\x\sics\addons\core\ui\atlas_logo_ca.paa";
private _root=["ATLAS_Devices","SynapseOS devices",_icon,{}, {
    params ["_target","_player"];
    [_player] call SICS_fnc_access && {[_player,_target,[]] call ace_common_fnc_canInteractWith}
}] call ace_interact_menu_fnc_createAction;
["CAManBase",1,["ACE_SelfActions"],_root,true] call ace_interact_menu_fnc_addActionToClass;
{
    _x params ["_mode","_label"];
    private _action=["ATLAS_"+_mode,_label,_icon,{
        params ["_target","_player","_mode"];
        [_mode] spawn {params ["_mode"];sleep 0.1;if (_mode=="AVIATION") then {["SECONDARY"] call SICS_fnc_aviationTAD} else {[_mode] call SICS_fnc_selectDevice}};
    },{
        params ["_target","_player","_mode"];
        _mode in ([_player] call SICS_fnc_devices) && {[_player,_target,[]] call ace_common_fnc_canInteractWith}
    },{},_mode] call ace_interact_menu_fnc_createAction;
    ["CAManBase",1,["ACE_SelfActions","ATLAS_Devices"],_action,true] call ace_interact_menu_fnc_addActionToClass;
} forEach [["PHONE","Use ATLAS Phone"],["TABLET","Use ATLAS Tablet"],["PORTABLE","Use portable GPS"],["VEHICLE","Use mounted console"],["AVIATION","Use aircraft TAD"]];
