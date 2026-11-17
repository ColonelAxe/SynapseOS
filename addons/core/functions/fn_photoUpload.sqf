params ["_id",["_send",false]];
if (!_send) exitWith {
    private _info=(("atlas_media" callExtension ["info",[_id]]) select 0) splitString "|";
    if (count _info!=3 || {_info select 0!="OK"}) exitWith {false};
    [player,"PHOTO_BEGIN",[_id,parseNumber(_info select 1),parseNumber(_info select 2),ATLAS_photoMeta get _id],missionNamespace getVariable ["SICS_terminal",objNull]] remoteExecCall ["SICS_fnc_server",2];true
};
[_id] spawn {
    params ["_id"];
    private _info=(("atlas_media" callExtension ["info",[_id]]) select 0) splitString "|";
    if (count _info!=3) exitWith {};
    for "_i" from 0 to (parseNumber(_info select 1)-1) do {
        private _chunk=("atlas_media" callExtension ["get",[_id,str _i]]) select 0;
        [player,"PHOTO_CHUNK",[_id,_i,_chunk],missionNamespace getVariable ["SICS_terminal",objNull]] remoteExecCall ["SICS_fnc_server",2];sleep 0.04;
    };
};
