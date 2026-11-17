// Mirror a structured report into the updateable contact registry.
params ["_unit","_record",["_options",["SUSPECTED",0,30,0]]];
if (isRemoteExecuted && {isNil "_ATLAS_serverDispatch"}) exitWith {[]};
if (!isServer || {(_record param [11,[]]) isEqualTo []}) exitWith {[]};
private _id="CONTACT:"+str (_record select 0);private _meta=_record select 11;
private _data=[["affiliation",_meta select 0],["symbol",_meta select 1],["category",_meta select 2],["strength",_meta param [4,1]],["confidence",_options select 0],["observed",serverTime-(_options select 1)],["expires",serverTime+60*(_options select 2)],["heading",_options select 3],["notes",_record select 4],["record",_record select 0],["photo",(_record param [12,[]]) param [0,""]]];
private _entry=[_id,_record select 1,"CONTACT",_meta param [3,"CONTACT"],_record select 9,_record select 3,_record select 7,"ACTIVE",+(_record select 5),[],_data,serverTime,serverTime,1];
if (count ATLAS_operations<512 || {_id in ATLAS_operations}) then {ATLAS_operations set [_id,_entry]};
[_unit,"CONTACT","REPORTED",_id,_entry select 3,_entry select 6,_entry select 4,_entry select 8] call SICS_fnc_operationsJournal;
_entry
