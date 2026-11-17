/* Execute on every machine through an Eden object's init:
   [this,west,"TOC ATLAS"] call SICS_fnc_registerTOC;
   Desks/laptops/screens work; no custom terrain object required. */
params ["_object",["_side",west],["_name","TOC"]];
if (isServer) then {
    _object setVariable ["SICS_toc",true,true];
    _object setVariable ["SICS_side",_side,true];
    _object setVariable ["SICS_name",_name,true];
};
if (!hasInterface || {_object getVariable ["SICS_actionAdded",false]}) exitWith {};
_object setVariable ["SICS_actionAdded",true];
_object addAction [format ["Open SynapseOS / %1",_name],{params ["_target"]; [_target,"","HOME"] call SICS_fnc_open},nil,1.5,true,true,"","alive _this && {alive _target} && {_this distance _target < 5} && {side group _this == _target getVariable ['SICS_side',west]}",5];

