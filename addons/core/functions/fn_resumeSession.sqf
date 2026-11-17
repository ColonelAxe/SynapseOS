disableSerialization;
private _s=missionNamespace getVariable ["SICS_savedAtlas",createHashMap];
private _valid=(_s getOrDefault ["identity",[]]) isEqualTo [[player] call SICS_fnc_channelIdentity,side group player];
if (_valid) then {
    {if (_x in _s) then {missionNamespace setVariable [_x,_s get _x]}} forEach ["SICS_tab","SICS_selectedUnit","SICS_selectedPosition","SICS_detailTab","SICS_compose","SICS_chatTarget","SICS_mapTool","SICS_pendingMarker"];
    if (isNull SICS_selectedUnit) then {SICS_selectedUnit=player};
};
[] call SICS_fnc_page;
if (!_valid) exitWith {};
private _d=findDisplay 87000;
private _mapState=_s getOrDefault ["map",[]];
if (_mapState isNotEqualTo []) then {private _map=_d displayCtrl 40;ctrlMapAnimClear _map;_map ctrlMapAnimAdd [0,_mapState select 0,_mapState select 1];ctrlMapAnimCommit _map};
private _composer=_s getOrDefault ["composer",[]];
if (_composer isNotEqualTo [] && {!isNull (_d displayCtrl 106)}) then {
    (_d displayCtrl 106) ctrlSetText (_composer select 0);(_d displayCtrl 102) lbSetCurSel (_composer select 1);
    private _to=_d displayCtrl 104;for "_i" from 0 to (lbSize _to-1) do {if (_to lbData _i==(_composer select 2)) exitWith {_to lbSetCurSel _i}};
    (_d displayCtrl 109) lbSetCurSel (_composer select 3);
};
if (SICS_deviceMode in ["PHONE","PORTABLE"]) then {SICS_mobilePane=_s getOrDefault ["SICS_mobilePane","MAP"];[] call SICS_fnc_mobileLayout};
private _draft=+(_s getOrDefault ["contactDraft",[]]);
if (_draft isNotEqualTo []) then {
    [_draft select 0] call SICS_fnc_contactEditor;private _d=findDisplay 87001;
    (_d displayCtrl 415) ctrlSetText (_draft select 1);(_d displayCtrl 417) ctrlSetText (_draft select 2);
    {private _c=_d displayCtrl (_x select 0);private _value=_draft select (_x select 1);for "_i" from 0 to (lbSize _c-1) do {if ((if (_x select 2) then {_c lbText _i} else {_c lbData _i})==_value) exitWith {_c lbSetCurSel _i}}} forEach [[403,3,false],[405,4,true],[407,5,false]];
    (_d displayCtrl 410) ctrlSetText (_draft select 6);
    private _observation=_draft param [7,[]];if (_observation isNotEqualTo []) then {(_d displayCtrl 419) lbSetCurSel (_observation select 0);{(_d displayCtrl _x) ctrlSetText (_observation select (_forEachIndex+1))} forEach [421,423,425]};
};
private _channelDraft=+(_s getOrDefault ["channelDraft",[]]);
if (_channelDraft isNotEqualTo [] && {_draft isEqualTo []}) then {
    private _old=_channelDraft select 0;
    if (_old isNotEqualTo []) then {SICS_chatTarget=_old select 0};
    [_old isNotEqualTo []] call SICS_fnc_channelEditor;private _d=findDisplay 87002;
    if (!isNull _d) then {
        (_d displayCtrl 803) ctrlSetText (_channelDraft select 1);(_d displayCtrl 805) lbSetCurSel (_channelDraft select 2);
        {private _c=_d displayCtrl _x;private _selected=(_channelDraft select 3) select _forEachIndex;for "_i" from 0 to (lbSize _c-1) do {_c lbSetSelected [_i,(_c lbData _i) in _selected]}} forEach [806,807,808];
    };
};

