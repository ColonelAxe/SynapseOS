// Called only after the existing dispatcher has verified sender ownership/access.
params ["_unit","_type","_payload"];
if !( ["camera",true] call SICS_fnc_policy ) exitWith {};
private _owner=owner _unit;private _uid=getPlayerUID _unit;
if (_type=="PHOTO_GET") exitWith {
    private _recordId=_payload param [0,-1,[0]];private _id=_payload param [1,"",[""]];
    private _index=SICS_records findIf {(_x select 0)==_recordId};if (_index<0) exitWith {};
    private _record=SICS_records select _index;
    if (!([_unit,_record] call SICS_fnc_recordAccess) || {!(_id in (_record param [12,[]]))}) exitWith {};
    private _photo=ATLAS_serverPhotos getOrDefault [_id,[]];if (_photo isEqualTo [] || {_photo select 8!="READY"}) exitWith {};
    private _key="GET_"+str _owner;private _last=ATLAS_photoRate getOrDefault [_key,-10];if (serverTime-_last<1) exitWith {};ATLAS_photoRate set [_key,serverTime];
    [_unit,_owner,_record,_id,_photo] spawn {
        params ["_unit","_owner","_record","_id","_photo"];
        ["PHOTO_BEGIN",[_id,_photo select 3,_photo select 5,_record select 0]] remoteExecCall ["SICS_fnc_receive",_owner];
        {if (owner _unit!=_owner || {!([_unit,_record] call SICS_fnc_recordAccess)}) exitWith {};["PHOTO_CHUNK",[_id,_forEachIndex,_x]] remoteExecCall ["SICS_fnc_receive",_owner];sleep 0.04} forEach (_photo select 6);
        if (owner _unit==_owner && {[_unit,_record] call SICS_fnc_recordAccess}) then {["PHOTO_END",_id] remoteExecCall ["SICS_fnc_receive",_owner]};
    };
};
private _id=_payload param [0,"",[""]];
if (count _id>64 || {_id find format ["P_%1_",_owner]!=0} || {(toArray _id) findIf {!(_x in toArray "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_")}>=0}) exitWith {};
if (_type=="PHOTO_BEGIN") exitWith {
    private _n=_payload param [1,0,[0]];private _bytes=_payload param [2,0,[0]];private _meta=_payload param [3,[],[[]]];
    if (!finite _n || {!finite _bytes} || {_n<1} || {_n>48} || {_n!=floor _n} || {_bytes<1} || {_bytes>65536} || {_bytes!=floor _bytes} || {_n!=ceil ((4*ceil (_bytes/3))/2048)} || {count _meta!=5}) exitWith {};
    private _caption=_meta param [0,"",[""]];private _position=_meta param [1,[],[[]]];private _heading=_meta param [2,0,[0]];
    if (count _caption<1 || {count _caption>80} || {count _position!=3} || {_position findIf {!(_x isEqualType 0) || {!finite _x}}>=0} || {!finite _heading}) exitWith {};
    {private _photoId=_x;private _p=ATLAS_serverPhotos get _photoId;private _used=SICS_records findIf {_photoId in (_x param [12,[]])}>=0;if (serverTime-(_p select 7)>600 && {!_used}) then {ATLAS_serverPhotos deleteAt _photoId}} forEach keys ATLAS_serverPhotos;
    private _existing=ATLAS_serverPhotos getOrDefault [_id,[]];
    if (_existing isNotEqualTo [] && {_existing select 8=="UPLOADING"} && {serverTime-(_existing select 7)>30}) then {ATLAS_serverPhotos deleteAt _id;_existing=[]};
    if (_existing isNotEqualTo []) exitWith {
        if (_existing select 1==_uid && {_existing select 2==_owner} && {_existing select 0==side group _unit}) then {
            if (_existing select 8=="READY") then {["PHOTO_READY",_id] remoteExecCall ["SICS_fnc_receive",_owner]} else {
                private _retryKey="RETRY_"+str _owner;private _last=ATLAS_photoRate getOrDefault [_retryKey,-10];
                if (serverTime-_last>=3 && {_existing select 3==_n} && {_existing select 4==_bytes}) then {ATLAS_photoRate set [_retryKey,serverTime];["PHOTO_ACCEPTED",_id] remoteExecCall ["SICS_fnc_receive",_owner]};
            };
        };
    };
    private _key="PUT_"+str _owner;private _last=ATLAS_photoRate getOrDefault [_key,-10];
    if (serverTime-_last<3 || {count ATLAS_serverPhotos>=128}) exitWith {["NOTICE","Photo upload busy. Try again shortly."] remoteExecCall ["SICS_fnc_receive",_owner]};
    ATLAS_photoRate set [_key,serverTime];private _parts=[];_parts resize _n;_parts=_parts apply {""};
    ATLAS_serverPhotos set [_id,[side group _unit,_uid,_owner,_n,_bytes,[_caption,_position,_heading,serverTime,_uid],_parts,serverTime,"UPLOADING"]];
    ["PHOTO_ACCEPTED",_id] remoteExecCall ["SICS_fnc_receive",_owner];
};
if (_type=="PHOTO_CHUNK") exitWith {
    private _p=ATLAS_serverPhotos getOrDefault [_id,[]];if (_p isEqualTo [] || {_p select 1!=_uid} || {_p select 2!=_owner} || {_p select 0!=side group _unit} || {_p select 8!="UPLOADING"} || {serverTime-(_p select 7)>30}) exitWith {};
    private _index=_payload param [1,-1,[0]];private _chunk=_payload param [2,"",[""]];
    if (_index<0 || {_index>=_p select 3} || {_index!=floor _index} || {count _chunk<4} || {count _chunk>2048} || {count _chunk mod 4!=0} || {(toArray _chunk) findIf {!(_x in toArray "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")}>=0}) exitWith {};
    private _encoded=4*ceil ((_p select 4)/3);
    private _expected=2048 min (_encoded-_index*2048);
    if (count _chunk!=_expected || {_index<(_p select 3)-1 && {_chunk find "=">=0}}) exitWith {};
    private _parts=_p select 6;if (_parts select _index!="") exitWith {};_parts set [_index,_chunk];
    if (_parts findIf {_x==""}<0) then {_p set [8,"READY"];["PHOTO_READY",_id] remoteExecCall ["SICS_fnc_receive",_owner]};
};
