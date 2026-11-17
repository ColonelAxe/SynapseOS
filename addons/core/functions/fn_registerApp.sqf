// Local trusted-addon API. Launch/availability callbacks are CODE, never network text.
params ["_id","_title","_icon","_launch",["_available",{true}],["_badge",{0}]];
if (!([_id,_title,_icon] isEqualTypeAll "") || {!(_launch isEqualType {})} || {!(_available isEqualType {})} || {!(_badge isEqualType {})}) exitWith {false};
if (count _id<1 || {count _id>32} || {count _title<1} || {count _title>32}) exitWith {false};
if (isNil "SYNAPSE_apps") then {SYNAPSE_apps=createHashMap};
SYNAPSE_apps set [_id,[_id,_title,_icon,_launch,_available,_badge]];
true

