// Called only by the validated server request dispatcher.
if (!isServer) exitWith {};
params ["_unit","_type","_payload",["_terminal",objNull]];
if (isNull _unit || {owner _unit!=remoteExecutedOwner} || {!isPlayer _unit} || {!([_unit,_terminal] call SICS_fnc_access)}) exitWith {};
private _side=side group _unit;
private _audience=allPlayers select {side group _x==_side};
private _deliver={params ["_kind","_entry"]; {[_kind,_entry] remoteExecCall ["SICS_fnc_receive",owner _x]} forEach _audience};
private _id=_payload param [0,-1,[0]];
private _old=SICS_markers getOrDefault [str _id,[]];
if (_id>=0 && {_old isEqualTo [] || {(_old select 1)!=_side} || {(_old select 2)!=getPlayerUID _unit && {!(_unit getVariable ["ATLAS_commander",_unit getVariable ["SICS_commander",false]])}}}) exitWith {};
if (_type=="MARKER_DELETE") exitWith {if (_old isNotEqualTo []) then {SICS_markers deleteAt str _id;["MARKER_DELETE",_old] call _deliver}};
if (_type=="LINE") exitWith {
    private _colour=_payload param [1,"ColorBlue",[""]];
    private _text=_payload param [2,"",[""]];
    private _points=_payload param [3,[],[[]]];
    if (!(_colour in ["ColorBlue","ColorRed","ColorGreen","ColorYellow","ColorOrange","ColorBlack","ColorWhite"]) || {count _text>100} || {count _points!=2} || {_points findIf {!(_x isEqualType []) || {count _x<2 || {count _x>3}} || {_x findIf {!(_x isEqualType 0) || {!finite _x}}>=0}}>=0}) exitWith {};
    if (count SICS_markers>=200 && {_old isEqualTo []}) exitWith {};
    private _lineId=_id;
    if (_lineId<0) then {SICS_markerSequence=SICS_markerSequence+1;_lineId=SICS_markerSequence};
    private _entry=[_lineId,_side,if (_old isEqualTo []) then {getPlayerUID _unit} else {_old select 2},"SICS_LINE",_colour,_text,_points select 0,0,1,_points];
    SICS_markers set [str _lineId,_entry];["MARKER",_entry] call _deliver;
};
private _symbol=_payload param [1,"",[""]];
private _colour=_payload param [2,"",[""]];
private _text=_payload param [3,"",[""]];
private _pos=_payload param [4,[],[[]]];
private _dir=_payload param [5,0,[0]];
private _size=_payload param [6,1,[0]];
if (!isClass(configFile >> "CfgMarkers" >> _symbol) || {getNumber(configFile >> "CfgMarkers" >> _symbol >> "scope")<1} || {!(_colour in ["ColorBlue","ColorRed","ColorGreen","ColorYellow","ColorOrange","ColorBlack","ColorWhite"])} || {count _text>100} || {count _pos<2 || {count _pos>3}} || {_pos findIf {!(_x isEqualType 0) || {!finite _x}}>=0} || {!finite _dir} || {!finite _size} || {_size<0.25 || {_size>3}}) exitWith {};
if (_id<0) then {SICS_markerSequence=SICS_markerSequence+1;_id=SICS_markerSequence};
if (count SICS_markers>=200 && {_old isEqualTo []}) exitWith {["NOTICE","Marker limit reached (200). Delete an existing marker first."] remoteExecCall ["SICS_fnc_receive",owner _unit]};
private _entry=[_id,_side,if (_old isEqualTo []) then {getPlayerUID _unit} else {_old select 2},_symbol,_colour,_text,_pos,_dir mod 360,_size];
SICS_markers set [str _id,_entry];
["MARKER",_entry] call _deliver;


