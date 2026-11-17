disableSerialization;
params [["_centre",true]];
private _d=findDisplay 87000;if (isNull _d) exitWith {};
private _list=_d displayCtrl 2602;private _i=lbCurSel _list;if (_i<0) exitWith {};
ATLAS_opsSelected=_list lbData _i;
private _id=ATLAS_opsSelected;private _entry=ATLAS_clientOperations getOrDefault [_id,[]];private _text="";
private _position=[];
if (_entry isNotEqualTo []) then {
    private _data=createHashMapFromArray (_entry select 10);private _status=_entry select 7;
    if ((_entry select 2)=="CONTACT" && {serverTime>(_data getOrDefault ["expires",1e12])} && {_status!="RESOLVED"}) then {_status="STALE / EXPIRED"};
    private _lines=[_entry select 3,format ["%1 / %2",_entry select 2,_status],format ["GRID %1 / revision %2",mapGridPosition (_entry select 8),_entry select 13],format ["Updated %1s ago / %2",floor ((serverTime-(_entry select 12)) max 0),_entry select 5]];
    {
        if (_x in _data) then {_lines pushBack format ["%1: %2",toUpper _x,_data get _x]};
    } forEach ["confidence","strength","security","urgency","casualties","landing","obstacles","marking","notes","acceptedCallsign"];
    if ((_entry select 2)=="CONTACT") then {_lines pushBack format ["Observed %1s ago / direction %2°",floor ((serverTime-(_data get "observed")) max 0),_data get "heading"]};
    private _points=_entry select 9;
    if (count _points>1) then {private _distance=0;for "_j" from 1 to (count _points-1) do {_distance=_distance+((_points select (_j-1)) distance2D (_points select _j))};_lines pushBack format ["%1 checkpoints / %2m / planned ETA %3 min",count _points,round _distance,ceil (_distance/((_data getOrDefault ["speed",5]) max 1)*0.06)]};
    _text=_lines joinString toString [10];_position=_entry select 8;
};
if (_id find "ORDER:"==0) then {
    private _r=SICS_localRecords select {(_x select 0)==parseNumber (_id select [6])};
    if (_r isNotEqualTo []) then {private _r=_r select 0;private _life=_r param [13,["ISSUED",-1,[]]];
        private _lines=[_r select 3,_r select 4,format ["%1 / GRID %2",_r select 8,mapGridPosition (_r select 5)]];
        if (_life select 1>0) then {private _remaining=ceil (((_life select 1)-serverTime)/60);_lines pushBack format ["Deadline: %1 min %2%3",abs _remaining,["remaining","ago"] select (_remaining<0),[""," / OVERDUE"] select (_remaining<0 && {!((_life select 0) in ["CANCELLED","COMPLETED"])})]};
        {_lines pushBack format ["%1: %2",_x select 3,_x select 1]} forEach (_life select 2);
        _text=_lines joinString toString [10];_position=_r select 5;
    };
};
if (_id find "JOURNAL:"==0) then {private _j=ATLAS_clientJournal select {(_x select 0)==(_id select [8])};if (_j isNotEqualTo []) then {private _e=_j select 0;_text=format ["T+%1 / %2%5%3%5%4",round (_e select 10),_e select 7,_e select 3,_e select 5,toString [10]];_position=_e select 8}};
if (_id find "PRESET:"==0) then {ATLAS_workspaceName=_id select [7];(_d displayCtrl 2611) ctrlSetText ATLAS_workspaceName;_text="WORKSPACE / "+ATLAS_workspaceName+toString [10]+"Apply a saved local layout, or Save to replace it with the current preferences, map and device choice."};
private _stateAllowed=_id find "ORDER:"==0 || {_entry isNotEqualTo [] && {(_entry select 2) in ["CONTACT","SUPPORT","AIR_TASK"]}};
{(_d displayCtrl _x) ctrlEnable _stateAllowed} forEach [2622,2623];
if (_entry isNotEqualTo []) then {
    private _data=createHashMapFromArray (_entry select 10);private _photo=_data getOrDefault ["photo",""];private _record=_data getOrDefault ["record",-1];
    if (_photo!="" && {_record>=0}) then {
        private _b=["SICS_Button",2627,[0.615,0.845,0.33,0.045],"View observation photograph"] call SICS_fnc_control;
        _b setVariable ["ATLAS_observation",[_record,_photo]];_b ctrlAddEventHandler ["ButtonClick",{((_this select 0) getVariable "ATLAS_observation") call SICS_fnc_photoView}];
    } else {(_d displayCtrl 2627) ctrlShow false};
};
(_d displayCtrl 2603) ctrlSetText _text;
if (_centre && {_position isNotEqualTo []} && {!(missionNamespace getVariable ["ATLAS_opsCapture",false])}) then {private _map=_d displayCtrl 2601;ctrlMapAnimClear _map;_map ctrlMapAnimAdd [0.2,ctrlMapScale _map,_position];ctrlMapAnimCommit _map};
