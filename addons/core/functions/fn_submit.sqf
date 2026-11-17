params ["_type"];
private _d = findDisplay 87000;
private _payload = [];
switch _type do {
    case "CALLSIGN": {_payload=[ctrlText (_d displayCtrl 33)]};
    case "ACK": {_payload=[missionNamespace getVariable ["SICS_selectedRecord",-1]]};
    default {
        private _p = _d displayCtrl 102;
        private _to = _d displayCtrl 104;
        _payload=[ctrlText (_d displayCtrl 106),_p lbText lbCurSel _p,_to lbData lbCurSel _to,SICS_selectedPosition];
    };
};
if (_type=="MESSAGES") then {SICS_pendingChatDraft=_payload select 0};
if (_type=="REPORTS") then {
    private _id=missionNamespace getVariable ["ATLAS_reportPhoto",""];
    if (_id!="") then {_payload pushBack [];_payload pushBack [_id]};
};
[player,_type,_payload,SICS_terminal] remoteExecCall ["SICS_fnc_server",2];

