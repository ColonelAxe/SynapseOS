disableSerialization;
params [["_mode","SAVE"],["_d",findDisplay 87003]];
if (isNull _d) exitWith {};
private _base=_d getVariable ["ATLAS_editor",[]];if (_base isEqualTo []) exitWith {};
_base params ["_kind","_id","_revision","_position","_points"];
private _raw=[];private _data=[];private _error="";
{
    _x params ["_key","_type","_idc"];private _c=_d displayCtrl _idc;
    private _value=if (_type in ["ENUM","REF"]) then {_c lbData lbCurSel _c} else {ctrlText _c};
    _raw pushBack [_key,_value];
    if (_type=="NUMBER") then {
        if (_value=="" || {(toArray _value) findIf {!(_x in toArray "0123456789")}>=0}) then {_error="Use whole non-negative numbers for numeric fields."};
        _value=parseNumber _value;
    };
    _data pushBack [_key,_value];
} forEach (_d getVariable ["ATLAS_fields",[]]);
private _title=trim ctrlText(_d displayCtrl 2803);private _target=(_d displayCtrl 2805) lbData lbCurSel (_d displayCtrl 2805);
if (_mode=="DRAFT") exitWith {ATLAS_operationDraft=[_kind,_id,_revision,_title,_target,_position,+_points,_raw]};
if (_mode=="REDRAW") exitWith {ATLAS_redrawDraft=[_kind,_id,_revision,_title,_target,_position,+_points,_raw];ATLAS_opsCapture=true;ATLAS_opsDraftPoints=[];ATLAS_operationDraft=[];_d setVariable ["ATLAS_redrawing",true];_d closeDisplay 2;[] call SICS_fnc_operations};
if (_error!="") exitWith {(_d displayCtrl 2854) ctrlSetText _error};
private _valid=[player,_kind,_title,_target,_position,_points,_data] call SICS_fnc_operationsValidate;
if !(_valid select 0) exitWith {(_d displayCtrl 2854) ctrlSetText (_valid select 1)};
ATLAS_operationDraft=[];
private _token=floor random 1000000000;_d setVariable ["ATLAS_savingToken",_token];
[player,"OPS_UPSERT",[_id,_revision,_kind,_title,_target,_position,_points,_data,_token],missionNamespace getVariable ["SICS_terminal",objNull]] remoteExecCall ["SICS_fnc_server",2];
(_d displayCtrl 2854) ctrlSetText "Saving...";
