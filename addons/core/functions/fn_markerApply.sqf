// Local native markers are delivered only to the authorised Arma side.
params ["_entry",["_deleted",false]];
if (isNil "SICS_clientMarkers") then {SICS_clientMarkers=createHashMap};
private _id=_entry select 0;
private _name=format ["SICS_SIDE_%1",_id];
deleteMarkerLocal _name;
if (_deleted || {(_entry select 1)!=side group player}) exitWith {SICS_clientMarkers deleteAt str _id};
SICS_clientMarkers set [str _id,_entry];
createMarkerLocal [_name,_entry select 6];
if ((_entry select 3)=="SICS_LINE") exitWith {
    _name setMarkerShapeLocal "POLYLINE";
    private _flat=[];{_flat append [_x select 0,_x select 1]} forEach (_entry select 9);
    _name setMarkerPolylineLocal _flat;
    _name setMarkerColorLocal (_entry select 4);
    _name setMarkerTextLocal (_entry select 5);
};
_name setMarkerTypeLocal (_entry select 3);
_name setMarkerColorLocal (_entry select 4);
_name setMarkerTextLocal (_entry select 5);
_name setMarkerDirLocal (_entry select 7);
_name setMarkerSizeLocal [_entry select 8,_entry select 8];

