params ["_record"];
private _meta=_record param [11,[]];
if (_meta isEqualTo [] || {(_record select 1)!=side group player}) exitWith {};
private _name=format ["SICS_CONTACT_%1",_record select 0];
deleteMarkerLocal _name;
createMarkerLocal [_name,_record select 5];
_name setMarkerTypeLocal (_meta select 1);
_name setMarkerColorLocal (([_meta select 0] call SICS_fnc_affiliation) select 1);
_name setMarkerTextLocal format ["%1 / %2 / %3%4",_meta param [3,format ["C%1",_record select 0]],_meta select 0,_meta select 2,if (count _meta>4) then {format [" x%1",_meta select 4]} else {""}];
private _observation=_record param [13,[]];
if (_observation isNotEqualTo []) then {
    private _stale=serverTime>(_observation select 2);
    _name setMarkerTextLocal format ["%1 / %2%3",markerText _name,_observation select 0,[""," / STALE"] select _stale];
    if (_stale) then {_name setMarkerAlphaLocal 0.4;_name setMarkerColorLocal "ColorGrey"};
};
private _entity=(missionNamespace getVariable ["ATLAS_clientOperations",createHashMap]) getOrDefault ["CONTACT:"+str (_record select 0),[]];
if (_entity isNotEqualTo [] && {(_entity select 7)=="RESOLVED"}) then {_name setMarkerAlphaLocal 0};
if !((missionNamespace getVariable ["ATLAS_opsLayers",[true,true,true]]) select 1) then {_name setMarkerAlphaLocal 0};
if (isNil "SICS_contactNames") then {SICS_contactNames=[]};SICS_contactNames pushBackUnique _name;

