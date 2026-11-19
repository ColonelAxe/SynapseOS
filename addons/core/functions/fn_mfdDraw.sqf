// Range rings are map geometry in metres, centred on visual ownship.
params ["_map"];
private _own=vehicle player;
if !(_own isKindOf "Air") exitWith {};
private _pos=getPosASLVisual _own;
private _rect=ctrlPosition _map;
private _edge=_map ctrlMapScreenToWorld [(_rect select 0)+(_rect select 2)*0.9,(_rect select 1)+(_rect select 3)/2];
private _limit=(_pos distance2D _edge)/3;
private _step=100;
{if (_x<=_limit) then {_step=_x}} forEach [100,250,500,1000,2000,5000,10000,20000];
private _colour=[0.15,0.85,0.65,0.65];
for "_i" from 1 to 3 do {
    private _range=_step*_i;
    _map drawEllipse [_pos,_range,_range,0,_colour,""];
    private _label=if (_range>=1000) then {format ["%1 km",_range/1000]} else {format ["%1 m",_range]};
    _map drawIcon ["\A3\ui_f\data\map\Markers\System\dummy_ca.paa",_colour,_pos getPos [_range,60],0,0,0,_label,1,0.023,"RobotoCondensed"];
};
private _outer=_step*3;
for "_bearing" from 0 to 330 step 30 do {_map drawLine [_pos getPos [_outer,_bearing],_pos getPos [_outer*1.04,_bearing],_colour]};
_map drawArrow [_pos,_pos getPos [_step*0.8,getDirVisual _own],[0.3,1,0.7,0.9]];
