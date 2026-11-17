params ["_event",["_release",false]];
_event params ["_display","_key","_shift","_ctrl","_alt"];
private _handled=false;
{
    private _id=_x;
    private _entry=["SynapseOS",_id] call CBA_fnc_getKeybind;
    if (!isNil "_entry") then {
        private _bindings=_entry param [8,[_entry select 5]];
        if (_release) then {
            if (_bindings findIf {(_x select 0)==_key}>=0) then {[_id,true] call SICS_fnc_keyAction};
        } else {
            if (!_handled && {_bindings findIf {(_x select 0)==_key && {(_x select 1) isEqualTo [_shift,_ctrl,_alt]}}>=0}) then {[_id] call SICS_fnc_keyAction;_handled=true};
        };
    };
} forEach ["ifMain","ifSecondary","ifTertiary","zoomIn","zoomOut","toggleIfPosition"];
_handled

