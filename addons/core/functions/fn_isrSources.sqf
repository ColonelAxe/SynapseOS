// Same-side UAVs and operators carrying the SynapseOS helmet camera.
private _sources=[];
if (!hasInterface) exitWith {_sources};
if (["drone",true] call SICS_fnc_policy) then {
    {
        if (alive _x && {getNumber (configOf _x >> "isUav")==1} && {side _x==side group player}) then {
            _sources pushBack [_x,"UAV",format ["UAV / %1",getText (configOf _x >> "displayName")]];
        };
    } forEach vehicles;
};
if (["helmet",true] call SICS_fnc_policy) then {
    {
        if (alive _x && {side group _x==side group player} && {"ATLAS_HelmetCam" in (items _x+assignedItems _x)}) then {
            _sources pushBack [_x,"HELMET",format ["HELMET / %1",([_x] call SICS_fnc_profile) select 0]];
        };
    } forEach allUnits;
};
_sources
