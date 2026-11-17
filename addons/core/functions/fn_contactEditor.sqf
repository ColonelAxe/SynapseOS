disableSerialization;
params ["_pos"];
SICS_selectedPosition=_pos;
SICS_fnc_closeContact={
    private _d=findDisplay 87001;
    if (!isNull _d) then {_d setVariable ["ATLAS_discarded",true];_d closeDisplay 2};
    if (!(missionNamespace getVariable ["SICS_suspending",false]) && {!isNil "SICS_savedAtlas"}) then {SICS_savedAtlas deleteAt "contactDraft"};
};
[] call SICS_fnc_closeContact;
private _modal=findDisplay 87000 createDisplay "SICS_ContactDisplay";
if (isNull _modal) exitWith {diag_log "SICS_UI ERROR: contact modal creation failed"};
SICS_fnc_contactControl={params ["_class","_id","_rect",["_text",""]];[_class,_id,_rect,_text,findDisplay 87001] call SICS_fnc_control};
private _bg=["SICS_Text",400,[0.25,0.20,0.50,0.68],""] call SICS_fnc_contactControl;
_bg ctrlSetBackgroundColor [0.025,0.07,0.105,1];
["SICS_Header",401,[0.25,0.20,0.50,0.05],"POSITION REPORT"] call SICS_fnc_contactControl;
["SICS_Text",414,[0.27,0.26,0.29,0.03],"DESIGNATION"] call SICS_fnc_contactControl;
["SICS_Edit",415,[0.27,0.30,0.29,0.04],"CONTACT"] call SICS_fnc_contactControl;
["SICS_Text",416,[0.58,0.26,0.15,0.03],"STRENGTH / COUNT"] call SICS_fnc_contactControl;
private _strength=["SICS_Edit",417,[0.58,0.30,0.15,0.04],"1"] call SICS_fnc_contactControl;
_strength ctrlSetTooltip "Number of observed contacts: whole number from 1 to 9999";
["SICS_Text",402,[0.30,0.30,0.18,0.03],"AFFILIATION"] call SICS_fnc_contactControl;
private _aff=["SICS_Combo",403,[0.30,0.34,0.18,0.04]] call SICS_fnc_contactControl;
{private _i=_aff lbAdd _x;_aff lbSetData [_i,_x]} forEach ["OPFOR","UNKNOWN","BLUFOR","INDEPENDENT","CIVILIAN"];
["SICS_Text",404,[0.50,0.30,0.19,0.03],"ELEMENT TYPE"] call SICS_fnc_contactControl;
private _category=["SICS_Combo",405,[0.50,0.34,0.19,0.04]] call SICS_fnc_contactControl;
{_category lbAdd _x} forEach ["Unknown","Infantry","Motorized","Wheeled vehicle","Armoured vehicle","Helicopter","Fixed-wing aircraft","UAV","Naval","Station / installation","Artillery","Logistics","Medical"];
_category lbSetCurSel 0;
["SICS_Text",406,[0.30,0.40,0.29,0.03],"NATO SYMBOL"] call SICS_fnc_contactControl;
private _symbols=["SICS_Combo",407,[0.30,0.44,0.29,0.04]] call SICS_fnc_contactControl;
["RscPicture",408,[0.62,0.405,0.06,0.08],""] call SICS_fnc_contactControl;
["SICS_Text",409,[0.30,0.50,0.39,0.03],"ACTIVITY / NOTES"] call SICS_fnc_contactControl;
["SICS_Multiline",410,[0.30,0.54,0.39,0.15],""] call SICS_fnc_contactControl;
["SICS_Text",411,[0.30,0.70,0.39,0.03],format ["GRID %1  /  Observed contact position",mapGridPosition _pos]] call SICS_fnc_contactControl;
SICS_fnc_contactPreview={
    private _d=findDisplay 87001;private _s=_d displayCtrl 407;private _a=_d displayCtrl 403;
    private _type=_s lbData lbCurSel _s;
    (_d displayCtrl 408) ctrlSetText getText(configFile >> "CfgMarkers" >> _type >> "icon");
    (_d displayCtrl 408) ctrlSetTextColor (([_a lbData lbCurSel _a] call SICS_fnc_affiliation) select 3);
};
SICS_fnc_contactSymbols={
    private _d=findDisplay 87001;private _a=_d displayCtrl 403;private _s=_d displayCtrl 407;
    private _aff=_a lbData lbCurSel _a;lbClear _s;private _selected=0;
    {
        private _i=_s lbAdd getText(_x >> "name");_s lbSetData [_i,configName _x];_s lbSetPicture [_i,getText(_x >> "icon")];
        if (toLower configName _x==(([_aff] call SICS_fnc_affiliation) select 0)+"unknown") then {_selected=_i};
    } forEach ([_aff] call SICS_fnc_natoCatalog);
    _s lbSetCurSel _selected;[] call SICS_fnc_contactPreview;
};
_aff ctrlAddEventHandler ["LBSelChanged",{[] call SICS_fnc_contactSymbols}];
_symbols ctrlAddEventHandler ["LBSelChanged",{[] call SICS_fnc_contactPreview}];
SICS_fnc_contactType={
    private _d=findDisplay 87001;private _c=_d displayCtrl 405;private _s=_d displayCtrl 407;
    private _suffix=["unknown","inf","motor_inf","motor_inf","armor","air","plane","uav","naval","installation","art","support","medical"] select lbCurSel _c;
    private _a=_d displayCtrl 403;
    private _desired=(([_a lbData lbCurSel _a] call SICS_fnc_affiliation) select 0)+_suffix;
    for "_i" from 0 to (lbSize _s-1) do {if (_s lbData _i==_desired) exitWith {_s lbSetCurSel _i}};
};
_category ctrlAddEventHandler ["LBSelChanged",{[] call SICS_fnc_contactType}];
_aff ctrlAddEventHandler ["LBSelChanged",{[] call SICS_fnc_contactType}];
_aff lbSetCurSel 0;
["SICS_Text",418,[0.18,0.51,0.20,0.025],"CONFIDENCE"] call SICS_fnc_contactControl;
private _confidence=["SICS_Combo",419,[0.18,0.545,0.20,0.04]] call SICS_fnc_contactControl;
{_confidence lbAdd _x} forEach ["SUSPECTED","OBSERVED","CONFIRMED"];_confidence lbSetCurSel 0;
["SICS_Text",420,[0.40,0.51,0.13,0.025],"AGE / SECONDS"] call SICS_fnc_contactControl;
["SICS_Edit",421,[0.40,0.545,0.13,0.04],"0"] call SICS_fnc_contactControl;
["SICS_Text",422,[0.55,0.51,0.13,0.025],"EXPIRY / MIN"] call SICS_fnc_contactControl;
["SICS_Edit",423,[0.55,0.545,0.13,0.04],str (ceil ((["contactTTL",1800] call SICS_fnc_policy)/60))] call SICS_fnc_contactControl;
["SICS_Text",424,[0.70,0.51,0.12,0.025],"DIRECTION"] call SICS_fnc_contactControl;
["SICS_Edit",425,[0.70,0.545,0.12,0.04],"0"] call SICS_fnc_contactControl;
private _send=["SICS_Button",412,[0.30,0.75,0.18,0.04],"Send contact report"] call SICS_fnc_contactControl;
_send ctrlSetBackgroundColor [0.10,0.55,0.85,1];
SICS_fnc_sendContact={
    private _d=findDisplay 87001;private _a=_d displayCtrl 403;private _s=_d displayCtrl 407;private _c=_d displayCtrl 405;
    private _aff=_a lbData lbCurSel _a;private _symbol=_s lbData lbCurSel _s;private _category=_c lbText lbCurSel _c;
    private _designation=trim ctrlText (_d displayCtrl 415);
    private _raw=trim ctrlText (_d displayCtrl 417);private _count=parseNumber _raw;
    if (count _designation<1 || {count _designation>48}) exitWith {(_d displayCtrl 411) ctrlSetText "Enter a designation of 1 to 48 characters."};
    if (_raw=="" || {(toArray _raw) findIf {!(_x in toArray "0123456789")}>=0} || {_count<1} || {_count>9999}) exitWith {(_d displayCtrl 411) ctrlSetText "Strength must be a whole number from 1 to 9999."};
    private _text=format ["%1 / %2 / %3 / STRENGTH %4 / GRID %5",_designation,_aff,_category,_count,mapGridPosition SICS_selectedPosition];
    private _notes=ctrlText (_d displayCtrl 410);
    if (count _notes>700) exitWith {(_d displayCtrl 411) ctrlSetText "Notes must be 700 characters or fewer."};
    if (_notes!="") then {_text=_text+toString [10]+_notes};
    private _photo=missionNamespace getVariable ["ATLAS_reportPhoto",""];
    private _rawNumbers=[421,423,425] apply {ctrlText(_d displayCtrl _x)};
    if (_rawNumbers findIf {_x=="" || {(toArray _x) findIf {!(_x in toArray "0123456789")}>=0}}>=0) exitWith {(_d displayCtrl 411) ctrlSetText "Age, expiry and direction must be whole non-negative numbers."};
    private _numbers=_rawNumbers apply {parseNumber _x};
    if (_numbers select 0>86400 || {_numbers select 1<1} || {_numbers select 1>1440} || {_numbers select 2>359}) exitWith {(_d displayCtrl 411) ctrlSetText "Age ≤86400s, expiry 1–1440 min, direction 0–359°."};
    private _observation=[(_d displayCtrl 419) lbText lbCurSel (_d displayCtrl 419)]+_numbers;
    [player,"REPORTS",[_text,"PRIORITY","",SICS_selectedPosition,[_aff,_symbol,_category,_designation,_count],if (_photo=="") then {[]} else {[_photo]},_observation],SICS_terminal] remoteExecCall ["SICS_fnc_server",2];
    [] call SICS_fnc_closeContact;
};
_send ctrlAddEventHandler ["ButtonClick",{[] call SICS_fnc_sendContact}];
private _cancel=["SICS_Button",413,[0.50,0.75,0.19,0.04],"Cancel"] call SICS_fnc_contactControl;
_cancel ctrlAddEventHandler ["ButtonClick",{[] call SICS_fnc_closeContact}];
// Two-column form, with symbol picker and optional observed-activity notes.
{
    _x params ["_id","_rect"];private _c=findDisplay 87001 displayCtrl _id;
    _c ctrlSetPosition (_rect call SICS_fnc_formRect);_c ctrlCommit 0;_c ctrlSetText ctrlText _c;
} forEach [[400,[0.16,0.12,0.68,0.80]],[401,[0.16,0.12,0.68,0.05]],[414,[0.18,0.19,0.42,0.025]],[415,[0.18,0.225,0.42,0.04]],[416,[0.64,0.19,0.18,0.025]],[417,[0.64,0.225,0.18,0.04]],[402,[0.18,0.29,0.30,0.025]],[403,[0.18,0.325,0.30,0.04]],[404,[0.52,0.29,0.30,0.025]],[405,[0.52,0.325,0.30,0.04]],[406,[0.18,0.39,0.52,0.025]],[407,[0.18,0.425,0.52,0.04]],[408,[0.74,0.39,0.06,0.08]],[409,[0.18,0.61,0.64,0.025]],[410,[0.18,0.645,0.64,0.10]],[411,[0.18,0.77,0.64,0.035]],[412,[0.18,0.835,0.30,0.05]],[413,[0.52,0.835,0.30,0.05]]];
[findDisplay 87001] call SICS_fnc_fitText;


