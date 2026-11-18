// Read-only view of SynapseOS server-authorised friendly selections.
disableSerialization;
private _d=findDisplay 87000;
if (isNull _d) exitWith {};
private _u=missionNamespace getVariable ["SICS_selectedUnit",objNull];
private _rx=[0.74,0.705] select (SICS_tab=="C2");
private _rw=[0.215,0.25] select (SICS_tab=="C2");
if (isNull (_d displayCtrl 700)) then {
    {(_d displayCtrl _x) ctrlShow false} forEach [50,51,52,101,102,103,104,105,106,107,108,109,110,111,112,113,120,121,220,221,230,231,232,233,240,250,251,380];
    ["SICS_Header",700,[_rx,0.215,_rw,0.04],"UNIT INSPECTOR / LIVE"] call SICS_fnc_control;
    private _bg=["SICS_Text",701,[_rx,0.26,_rw,0.565],""] call SICS_fnc_control;
    _bg ctrlSetBackgroundColor [0.015,0.05,0.075,1];
    ["SICS_Text",702,[_rx+0.008,0.265,_rw-0.016,0.255],""] call SICS_fnc_control;
    ["SICS_Header",703,[_rx,0.525,_rw,0.035],"TEAM / RANK / STATUS"] call SICS_fnc_control;
    ["SICS_List",704,[_rx,0.565,_rw,0.26],""] call SICS_fnc_control;
};
if (isNull _u) exitWith {(_d displayCtrl 702) ctrlSetText "No unit selected. Click a friendly map symbol.";lbClear (_d displayCtrl 704)};
private _g=group _u;
private _members=units _g;
private _status={params ["_unit"];if (!alive _unit) exitWith {"KIA"};if (lifeState _unit=="INCAPACITATED" || {_unit getVariable ["ACE_isUnconscious",false]}) exitWith {"INCAPACITATED"};if (damage _unit>0.1) exitWith {"WOUNDED"};if (abs speed vehicle _unit>1) exitWith {"MOVING"};"READY"};
private _combat=(_members findIf {alive _x && {behaviour _x=="COMBAT"}})>=0;
private _feed=[vehicle _u] call SICS_fnc_trackStatus;
private _summary=format ["UNIT  %1\nNAME  %2\nGRID  %3\nSTATUS  %4\nCOMBAT  %5\nTEAM  %6 members\nFEED  %7",groupId _g,if (_u isKindOf "Man") then {([_u] call SICS_fnc_profile) select 0} else {getText(configOf _u >> "displayName")},mapGridPosition (_feed select 2),[_u] call _status,["NOT IN COMBAT","IN COMBAT"] select _combat,count _members,format ["%1 %2",_feed select 0,if (_feed select 1>=0) then {str floor (_feed select 1)+"s"} else {""}]];
(_d displayCtrl 702) ctrlSetText _summary;
(_d displayCtrl 702) ctrlSetTooltip "Combat reflects Arma AI COMBAT behaviour. Player intent and unreported enemy contact cannot be inferred.";
private _list=_d displayCtrl 704;
private _scroll=lbCurSel _list;lbClear _list;
{
    private _profile=[_x] call SICS_fnc_profile;
    private _row=_list lbAdd format ["%1  %2 / %3",_profile select 2,_profile select 0,[_x] call _status];
    _list lbSetTooltip [_row,format ["%1 / %2 / GRID %3 / %4 (display rank)",_profile select 2,_profile select 0,mapGridPosition vehicle _x,_profile select 1]];
    if (!alive _x) then {_list lbSetColor [_row,[1,0.35,0.35,1]]};
} forEach _members;
_list lbSetCurSel _scroll;
SICS_inspectSnapshot=[_u,_summary,_members apply {private _p=[_x] call SICS_fnc_profile;[_p select 0,_p select 2,[_x] call _status]},_combat];
if ((missionNamespace getVariable ["SICS_deviceMode","TABLET"]) in ["PHONE","PORTABLE"] && {SICS_mobilePane=="APP"}) then {[] call SICS_fnc_mobileLayout};

