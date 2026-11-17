// Journal entries intentionally omit message bodies and retain original audience.
params ["_unit","_kind","_action","_id","_title",["_target",""],["_owner",""],["_position",[0,0,0]]];
if (!isServer) exitWith {};
if (isRemoteExecuted && {isNil "_ATLAS_serverDispatch"}) exitWith {};
ATLAS_journalSequence=ATLAS_journalSequence+1;
ATLAS_journal pushBack [str ATLAS_journalSequence,side group _unit,_kind,_title,[_owner,getPlayerUID _unit] select (_owner==""),([_unit] call SICS_fnc_profile) select 0,_target,_action,+_position,_id,serverTime];
private _limit=["journalLimit",500] call SICS_fnc_policy;
while {count ATLAS_journal>_limit} do {ATLAS_journal deleteAt 0};
ATLAS_operationsVersion=ATLAS_operationsVersion+1;
