params ["_profile"];
if (!(_profile isEqualType []) || {count _profile!=3} || {!(_profile isEqualTypeAll "")}) exitWith {[]};
_profile params ["_callsign","_role","_rank"];
_callsign=trim _callsign;_role=trim _role;
if (count _callsign<1 || {count _callsign>32} || {count _role<1} || {count _role>32} || {(toArray (_callsign+_role)) findIf {_x<32 || {_x in [60,62,127]}}>=0} || {!(_rank in ["PRIVATE","CORPORAL","SERGEANT","LIEUTENANT","CAPTAIN","MAJOR","COLONEL"])}) exitWith {[]};
[_callsign,_role,_rank]
