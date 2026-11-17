disableSerialization;
private _d=findDisplay 87000;
if (isNull _d) exitWith {};
if (SICS_tab=="MESSAGES") exitWith {[] call SICS_fnc_chat};
private _c=_d displayCtrl 51;
private _selected=_c lbData lbCurSel _c;
lbClear _c;
private _records=missionNamespace getVariable ["SICS_localRecords",[]];
for "_i" from (count _records-1) to 0 step -1 do {
    private _r=_records select _i;
    if (!(SICS_tab in ["MESSAGES","C2","REPORTS"]) || {(_r select 2)==SICS_tab}) then {
        private _meta=_r param [11,[]];
        private _label=if (_meta isEqualTo []) then {_r select 2} else {format ["%1 / %2 %3%4",_meta param [3,"CONTACT"],_meta select 0,_meta select 2,if (count _meta>4) then {format [" x%1",_meta select 4]} else {""}]};
        if ((_r param [12,[]]) isNotEqualTo []) then {_label=_label+" / PHOTO"};
        private _row=_c lbAdd format ["#%1 %2 | %3",_r select 0,_label,_r select 3];
        _c lbSetData [_row,str (_r select 0)];
        if (_selected==str (_r select 0)) then {_c lbSetCurSel _row};
    };
};

