disableSerialization;
params ["_action",["_master",objNull]];
private _display = findDisplay 87004;
private _canUse = {
    !isNull _master && {alive _master} && {alive player} && {player distance _master<=5} &&
        {side group player==(_master getVariable ["SICS_side",sideUnknown])}
};

if (_action=="OPEN") exitWith {
    if (!isNull _display || {!([] call _canUse)} || {!createDialog "ATLAS_TOCConsole"}) exitWith {};
    _display = findDisplay 87004;
    _display setVariable ["ATLAS_tocMaster",_master];
    private _create = {
        params ["_class","_id","_position",["_text",""]];
        private _control = _display ctrlCreate [_class,_id];
        _control ctrlSetPosition _position;
        _control ctrlSetText _text;
        _control ctrlCommit 0;
        _control
    };
    ["SICS_Header",-1,[0.05,0.235,0.78,0.06],"ATLAS / TOC DISPLAYS"] call _create;
    private _close = ["SICS_Button",-1,[0.835,0.235,0.115,0.06],"Close"] call _create;
    _close ctrlAddEventHandler ["ButtonClick",{(ctrlParent (_this select 0)) closeDisplay 2}];

    ["SICS_Text",-1,[0.05,0.31,0.31,0.04],"DISPLAY / CURRENT VIEW"] call _create;
    ["SICS_Text",-1,[0.36,0.31,0.20,0.04],"DISPLAY MODE"] call _create;
    ["SICS_Text",-1,[0.57,0.31,0.38,0.04],"ISR SOURCE"] call _create;

    private _slots = _master getVariable ["ATLAS_tocSlots",[]];
    if (_slots isEqualTo []) then {
        ["SICS_Text",-1,[0.05,0.36,0.9,0.08],"No displays are assigned to this master."] call _create;
    };
    {
        _x params ["_slot","_name","_screen"];
        private _y = 0.36 + _forEachIndex * 0.085;
        private _id = 9100 + _slot * 10;
        ["SICS_Text",_id,      [0.05,_y,0.30,0.062]] call _create;
        private _map = ["SICS_Button",_id+1,[0.36,_y,0.09,0.062],"Map"] call _create;
        private _standby = ["SICS_Button",_id+2,[0.455,_y,0.105,0.062],"Standby"] call _create;
        ["SICS_Combo",_id+3,[0.57,_y,0.30,0.062]] call _create;
        private _isr = ["SICS_Button",_id+4,[0.875,_y,0.075,0.062],"Set"] call _create;
        {
            _x params ["_button","_mode"];
            _button setVariable ["ATLAS_screen",_screen];
            _button setVariable ["ATLAS_mode",_mode];
            _button setVariable ["ATLAS_sourceControl",_id+3];
            _button ctrlAddEventHandler ["ButtonClick",{
                params ["_button"];
                private _screen = _button getVariable ["ATLAS_screen",objNull];
                private _mode = _button getVariable ["ATLAS_mode","STANDBY"];
                private _source = objNull;
                if (_mode=="ISR") then {
                    private _combo = (ctrlParent _button) displayCtrl (_button getVariable "ATLAS_sourceControl");
                    private _sources = _combo getVariable ["ATLAS_sources",[]];
                    private _index = lbCurSel _combo;
                    if (_index>=0 && {_index<count _sources}) then {
                        _source = (_sources select _index) select 0;
                        _mode = (_sources select _index) select 1;
                    };
                };
                [player,_screen,_source,_mode] remoteExecCall ["SICS_fnc_tocSelect",2];
            }];
        } forEach [[_map,"MAP"],[_standby,"STANDBY"],[_isr,"ISR"]];
    } forEach _slots;
    ["UPDATE"] call SICS_fnc_tocConsole;
};

if (isNull _display) exitWith {};
_master = _display getVariable ["ATLAS_tocMaster",objNull];
if !([] call _canUse) exitWith {_display closeDisplay 2};
private _sources = [[objNull,"ISR","Awaiting source"]] + ([] call SICS_fnc_isrSources);
{
    _x params ["_slot","_name","_screen"];
    private _id = 9100 + _slot * 10;
    private _feed = _screen getVariable ["ATLAS_tocFeed",[]];
    private _kind = _feed param [3,"STANDBY"];
    private _current = _sources findIf {(_x select 0)==(_feed param [0,objNull]) && {(_x select 1)==_kind}};
    private _available = !isNull _screen && {alive _screen};
    private _status = if (!_available) then {"Unavailable"} else {
        switch (_kind) do {
            case "MAP": {"ATLAS briefing map"};
            case "STANDBY": {"Standby"};
            default {if (_current>0) then {(_sources select _current) select 2} else {"ISR / awaiting source"}};
        }
    };
    private _label = _display displayCtrl _id;
    private _text = format ["%1. %2  |  %3",_slot,_name,_status];
    _label ctrlSetText _text;
    _label ctrlSetTooltip _text;
    for "_offset" from 1 to 4 do {(_display displayCtrl (_id+_offset)) ctrlEnable _available};
    private _combo = _display displayCtrl (_id+3);
    private _previous = _combo getVariable ["ATLAS_sources",[]];
    if (_sources isNotEqualTo _previous) then {
        private _selected = _previous param [(lbCurSel _combo) max 0,[]];
        lbClear _combo;
        {_combo lbAdd (_x select 2)} forEach _sources;
        private _index = _sources find _selected;
        _combo lbSetCurSel (if (_index>=0) then {_index} else {_current max 0});
        _combo setVariable ["ATLAS_sources",_sources];
    };
} forEach (_master getVariable ["ATLAS_tocSlots",[]]);
