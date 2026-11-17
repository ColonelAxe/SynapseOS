if (!isServer) exitWith {};
params ["_unit","_action","_payload"];
private _reject={params ["_text"];["NOTICE",_text] remoteExecCall ["SICS_fnc_receive",owner _unit]};
if (_action=="CHANNEL_DELETE") exitWith {
    private _id=_payload param [0,"",[""]];private _channel=SICS_channels getOrDefault [_id,[]];
    if !([_unit,_channel,true] call SICS_fnc_channelAccess) exitWith {["Only this channel's owner or managers can delete it."] call _reject};
    private _members=allPlayers select {[_x,_channel] call SICS_fnc_channelAccess};
    SICS_channels deleteAt _id;
    SICS_records=SICS_records select {(_x select 7)!=_id};
    {[_x,true] call SICS_fnc_channelSync} forEach allPlayers;
    {if (_x!=_unit) then {["CHANNEL_EVENT",format ["Channel deleted: %1",_channel select 2]] remoteExecCall ["SICS_fnc_receive",owner _x]}} forEach _members;
    ["CHANNEL_DELETED",_channel select 2] remoteExecCall ["SICS_fnc_receive",owner _unit];
};
if (count _payload!=6) exitWith {["Invalid channel settings."] call _reject};
_payload params ["_id","_name","_type","_players","_groups","_managers"];
if (!([_id,_name,_type] isEqualTypeAll "") || {!(_players isEqualType [])} || {!(_groups isEqualType [])} || {!(_managers isEqualType [])}) exitWith {["Invalid channel settings."] call _reject};
if ([_players,_groups,_managers] findIf {count _x>64 || {_x findIf {!(_x isEqualType "") || {count _x>64}}>=0}}>=0) exitWith {["Channel access list is invalid or too large."] call _reject};
_name=trim _name;
if (count _name<1 || {count _name>32} || {!(_type in ["COMMAND","GROUND-AIR","CUSTOM"])}) exitWith {["Enter a name (1-32 characters) and a valid chat type."] call _reject};
private _uid=[_unit] call SICS_fnc_channelIdentity;
private _existing=if (_action=="CHANNEL_UPDATE") then {SICS_channels getOrDefault [_id,[]]} else {[]};
if (_action=="CHANNEL_CREATE" && {!(_unit getVariable ["ATLAS_commander",_unit getVariable ["SICS_commander",false]]) || {_uid==""} || {count SICS_channels>=64}}) exitWith {["Channel creation requires commander access (maximum 64 channels)."] call _reject};
if (_action=="CHANNEL_UPDATE" && {!([_unit,_existing,true] call SICS_fnc_channelAccess)}) exitWith {["Only this channel's owner or managers can edit access."] call _reject};
private _side=side group _unit;
private _validUIDs=(allPlayers select {side group _x==_side}) apply {[_x] call SICS_fnc_channelIdentity};
if (_existing isNotEqualTo []) then {_validUIDs append (_existing select 5);_validUIDs append (_existing select 7);_validUIDs pushBack (_existing select 4)};
if ((_players+_managers) findIf {_x=="" || {!(_x in _validUIDs)}}>=0 || {_groups findIf {private _id=_x;allGroups findIf {netId _x==_id && {side _x==_side}}<0}>=0}) exitWith {["Choose players and groups from your own side."] call _reject};
private _owner=if (_action=="CHANNEL_CREATE") then {_uid} else {_existing select 4};
if (_action=="CHANNEL_CREATE") then {SICS_channelSequence=SICS_channelSequence+1;_id=format ["CH:%1",SICS_channelSequence]};
private _channel=[_id,_side,_name,_type,_owner,_players arrayIntersect _players,_groups arrayIntersect _groups,_managers arrayIntersect _managers];
SICS_channels set [_id,_channel];
{[_x,true] call SICS_fnc_channelSync} forEach allPlayers;
{
    if (_x!=_unit) then {
        private _before=[_x,_existing] call SICS_fnc_channelAccess;
        private _after=[_x,_channel] call SICS_fnc_channelAccess;
        if (_before || {_after}) then {
            private _event=if (!_after) then {"Access removed"} else {if (!_before) then {"Access granted"} else {"Channel updated"}};
            ["CHANNEL_EVENT",format ["%1: %2",_event,_name]] remoteExecCall ["SICS_fnc_receive",owner _x];
        };
    };
} forEach allPlayers;
["CHANNEL_SAVED",_id] remoteExecCall ["SICS_fnc_receive",owner _unit];


