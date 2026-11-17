// Landscape JTAC handset: map-first, with full-width task workspaces.
disableSerialization;
private _d=findDisplay 87000;if (isNull _d) exitWith {};
private _place={params ["_id","_rect"];private _c=findDisplay 87000 displayCtrl _id;_c ctrlSetPosition (_rect call SICS_fnc_rect);_c ctrlCommit 0;if (ctrlType _c in [0,1,2,13,16]) then {_c ctrlSetText ctrlText _c}};
private _show={params ["_ids"];{(findDisplay 87000 displayCtrl _x) ctrlShow true} forEach _ids};
(_d displayCtrl 91) ctrlShow false;
(_d displayCtrl 60) ctrlShow false;
{if (!(ctrlIDC _x in [2,3,4,5,6,7,8,10,11,12,13,14,15,60,90,900,901,902])) then {_x ctrlShow false}} forEach allControls _d;
[[2,3,4,5,6,7,8,10,11,12,13,14,15,90]] call _show;
{[_x select 0,_x select 1] call _place} forEach [[6,[0.045,0.045,0.036,0.085]],[2,[0.10,0.06,0.22,0.05]],[3,[0.34,0.065,0.22,0.04]],[7,[0.58,0.06,0.08,0.05]],[5,[0.68,0.06,0.11,0.05]],[8,[0.81,0.06,0.065,0.05]],[4,[0.90,0.06,0.05,0.05]],[60,[0.67,0.845,0.28,0.055]]];
(_d displayCtrl 2) ctrlSetText "ATLAS / JTAC";
(_d displayCtrl 5) ctrlSetText (["JTAC HANDSET","PORTABLE"] select (SICS_deviceMode=="PORTABLE"));
{[10+_forEachIndex,[0.05+_forEachIndex*0.151,0.14,0.14,0.075]] call _place} forEach [0,1,2,3,4,5];
{
    private _id=900+_forEachIndex;private _button=_d displayCtrl _id;
    if (isNull _button) then {
        _button=["SICS_Button",_id,[0.05+_forEachIndex*0.17,0.235,0.16,0.05],["Map","Workspace","Units / Chats"] select _forEachIndex] call SICS_fnc_control;
        _button setVariable ["SICS_pane",_x];_button ctrlAddEventHandler ["ButtonClick",{SICS_mobilePane=(_this select 0) getVariable "SICS_pane";[] call SICS_fnc_mobileLayout}];
    };
    _button ctrlShow true;_button ctrlSetBackgroundColor (if (SICS_mobilePane==_x) then {[0.03,0.46,0.51,1]} else {[0.08,0.15,0.19,1]});
} forEach ["MAP","APP","UNITS"];
switch SICS_mobilePane do {
    case "MAP": {
        (_d displayCtrl 60) ctrlShow true;
        [[40,200,61,62,63]] call _show;[200,[0.58,0.235,0.37,0.05]] call _place;(_d displayCtrl 200) ctrlSetText "TACTICAL PICTURE";
        [40,[0.05,0.37,0.90,0.45]] call _place;
        {
            private _id=270+_forEachIndex;private _b=_d displayCtrl _id;
            if (isNull _b) then {_b=["SICS_Button",_id,[0.05,0.305,0.17,0.05],["Markers","Line","Grid","Inspect"] select _forEachIndex] call SICS_fnc_control;_b setVariable ["SICS_tool",_x];_b ctrlAddEventHandler ["ButtonClick",{[(_this select 0) getVariable "SICS_tool",true] call SICS_fnc_mapTool}]};
            _b ctrlShow true;[_id,[0.05+_forEachIndex*0.18,0.305,0.17,0.05]] call _place;
        } forEach ["MARKER","LINE","GRID","INSPECT"];
        {[_x,[0.05+_forEachIndex*0.20,0.845,0.18,0.05]] call _place} forEach [61,62,63];
        (_d displayCtrl 61) ctrlSetText "Find unit";(_d displayCtrl 62) ctrlSetText "Full map";(_d displayCtrl 63) ctrlSetText "My position";
    };
    case "UNITS": {
        [[30,31,32,33,34]] call _show;
        {[_x select 0,_x select 1] call _place} forEach [[30,[0.05,0.31,0.55,0.05]],[31,[0.05,0.38,0.55,0.44]],[32,[0.65,0.38,0.30,0.05]],[33,[0.65,0.46,0.30,0.075]],[34,[0.65,0.56,0.30,0.075]]];
        (_d displayCtrl 32) ctrlSetText "GROUP CALLSIGN";
        if (SICS_tab=="MESSAGES") then {{(_d displayCtrl _x) ctrlShow false} forEach [32,33,34];[[640,641]] call _show;[640,[0.65,0.40,0.30,0.075]] call _place;[641,[0.65,0.51,0.30,0.075]] call _place};
    };
    default {
        if (SICS_mapTool=="INSPECT" && {!isNull (_d displayCtrl 704)}) exitWith {
            [[700,701,702,703,704]] call _show;
            {[_x select 0,_x select 1] call _place} forEach [[700,[0.05,0.31,0.40,0.05]],[701,[0.05,0.37,0.40,0.45]],[702,[0.06,0.38,0.38,0.43]],[703,[0.48,0.31,0.47,0.05]],[704,[0.48,0.38,0.47,0.44]]];
        };
        if (SICS_tab=="MESSAGES") exitWith {
            [[30,31,50,600,601,101,102,103,104,106,107,640,641]] call _show;
            {[_x select 0,_x select 1] call _place} forEach [[30,[0.05,0.31,0.22,0.05]],[31,[0.05,0.37,0.22,0.34]],[640,[0.05,0.74,0.22,0.055]],[641,[0.05,0.82,0.22,0.055]],[50,[0.29,0.31,0.66,0.05]],[600,[0.29,0.37,0.66,0.30]],[101,[0.29,0.675,0.15,0.035]],[102,[0.29,0.72,0.15,0.05]],[103,[0.46,0.675,0.49,0.035]],[104,[0.46,0.72,0.49,0.05]],[106,[0.29,0.79,0.48,0.10]],[107,[0.79,0.79,0.16,0.10]],[601,[0.29,0.90,0.66,0.025]]];
            (_d displayCtrl 641) ctrlSetText "Manage access";(_d displayCtrl 30) ctrlSetText "CHANNELS";[] call SICS_fnc_chat;
        };
        if (SICS_tab=="REPORTS" || {SICS_tab=="C2" && {SICS_compose}}) exitWith {
            [[50,101,102,103,104,105,106,107,108,109,250,251,380]] call _show;
            if (SICS_tab=="REPORTS" && {missionNamespace getVariable ["ATLAS_reportPhoto",""]!=""}) then {[[381,382]] call _show};
            [381,[0.05,0.825,0.38,0.065]] call _place;[382,[0.45,0.825,0.15,0.065]] call _place;
            {[_x select 0,_x select 1] call _place} forEach [[50,[0.05,0.31,0.55,0.05]],[101,[0.65,0.31,0.30,0.035]],[102,[0.65,0.36,0.30,0.06]],[103,[0.65,0.45,0.30,0.035]],[104,[0.65,0.50,0.30,0.06]],[105,[0.05,0.375,0.55,0.035]],[106,[0.05,0.43,0.55,0.37]],[107,[0.65,0.60,0.30,0.075]],[109,[0.65,0.72,0.30,0.06]],[380,[0.65,0.82,0.30,0.075]],[108,[0.65,0.72,0.30,0.06]],[250,[0.05,0.825,0.26,0.075]],[251,[0.34,0.825,0.26,0.075]]];
        };
        if (SICS_tab=="C2") exitWith {
            [[220,221,230,231,232,233,240,250,251]] call _show;
            {[_x select 0,_x select 1] call _place} forEach [[220,[0.05,0.31,0.38,0.05]],[221,[0.05,0.39,0.38,0.24]],[240,[0.46,0.40,0.49,0.40]],[250,[0.05,0.72,0.38,0.075]],[251,[0.05,0.825,0.38,0.075]]];
            {[_x,[0.46+_forEachIndex*0.125,0.31,0.115,0.05]] call _place} forEach [230,231,232,233];
        };
        if (SICS_tab=="ISR") exitWith {[[110,111,112,113,114,115,116]] call _show;{[_x select 0,_x select 1] call _place} forEach [[110,[0.05,0.31,0.35,0.34]],[113,[0.43,0.31,0.52,0.40]],[115,[0.05,0.67,0.16,0.06]],[116,[0.23,0.67,0.17,0.06]],[111,[0.05,0.76,0.35,0.075]],[114,[0.43,0.76,0.22,0.075]],[112,[0.68,0.76,0.27,0.10]]]};
        if (SICS_tab=="TOC") exitWith {[[120,121]] call _show;[120,[0.05,0.31,0.40,0.48]] call _place;[121,[0.49,0.31,0.46,0.48]] call _place};
        [[50,51,52,390]] call _show;[50,[0.05,0.31,0.40,0.05]] call _place;[51,[0.05,0.38,0.40,0.44]] call _place;[52,[0.49,0.31,0.46,0.51]] call _place;[390,[0.49,0.84,0.46,0.06]] call _place;
    };
};
[] call SICS_fnc_appHeader;
[_d] call SICS_fnc_fitText;

