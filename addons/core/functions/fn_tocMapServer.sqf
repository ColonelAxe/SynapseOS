// Shared map viewport. Validate ownership, side, proximity and input on server.
if (!isServer) exitWith {};
params [["_unit",objNull,[objNull]],["_screen",objNull,[objNull]],["_position",[],[[]]],["_scale",0.1,[0]]];
if (isNull _unit || {isNull _screen} || {!alive _unit} || {!alive _screen}) exitWith {};
if (isRemoteExecuted && {remoteExecutedOwner!=owner _unit || {!isPlayer _unit}}) exitWith {};
if (!(_screen in (missionNamespace getVariable ["ATLAS_briefScreens",[]])) || {side group _unit!=(_screen getVariable ["ATLAS_briefSide",sideUnknown])}) exitWith {};
private _master=_screen getVariable ["ATLAS_tocMaster",objNull];
if (_unit distance _screen>5 && {isNull _master || {!alive _master} || {_unit distance _master>5}}) exitWith {};
if (count _position!=2 || {!(_position isEqualTypeAll 0)} || {_position findIf {!finite _x || {_x<0} || {_x>worldSize}}>=0} || {!finite _scale} || {_scale<0.001} || {_scale>1}) exitWith {};
private _last=_screen getVariable ["ATLAS_mapRate",-1];
if (diag_tickTime-_last<0.25) exitWith {};
_screen setVariable ["ATLAS_mapRate",diag_tickTime];
_screen setVariable ["ATLAS_tocMapView",[+_position,_scale],true];
if (_screen getVariable ["ATLAS_managedBriefing",false]) then {
    private _feed=+(_screen getVariable ["ATLAS_tocFeed",[]]);
    if (count _feed==4) then {_feed set [0,objNull];_feed set [3,"MAP"];_screen setVariable ["ATLAS_tocFeed",_feed,true]};
};
