// SynapseOS-owned mounted-console policy and seat eligibility.
params ["_unit"];
if (isNull _unit || {!alive _unit} || {vehicle _unit == _unit}) exitWith {false};
private _vehicle = vehicle _unit;
if (_vehicle isKindOf "ParachuteBase") exitWith {false};
if (!( ["vehicles",true] call SICS_fnc_policy ) || {!(_vehicle getVariable ["ATLAS_consoleEnabled",true])}) exitWith {false};

private _air = _vehicle isKindOf "Air";
private _configured = ["vehicleClasses",[]] call SICS_fnc_policy;
private _defaultClasses = if (_air) then { ["Helicopter","Plane"] } else { ["MRAP_01_base_F","MRAP_02_base_F","MRAP_03_base_F","Wheeled_APC_F","Tank","Truck_01_base_F","Truck_03_base_F"] };
private _allowedClasses = if (_configured isEqualTo []) then {_defaultClasses} else {_configured};
if (_allowedClasses findIf {_vehicle isKindOf _x} < 0) exitWith {false};

// Crew outside cargo are commanders/gunners and may use the ground console.
if (driver _vehicle == _unit) exitWith {true};
private _cargoIndex = _vehicle getCargoIndex _unit;
if (_cargoIndex < 0) exitWith {
    if (!_air) then {true} else {
        // Pilot/copilot only. Door gunners and passenger seats are excluded.
        private _copilotTurret = 0;
        if (_vehicle isKindOf "Helicopter") then {
            _copilotTurret = -1;
            private _turrets = configFile >> "CfgVehicles" >> typeOf _vehicle >> "Turrets";
            for "_i" from 0 to (count _turrets - 1) do {
                private _turret = _turrets select _i;
                if (isClass _turret && {getNumber (_turret >> "isCopilot") == 1}) exitWith {_copilotTurret = _i};
            };
        };
        _copilotTurret >= 0 && {_vehicle turretUnit [_copilotTurret] == _unit}
    }
};

// Ground cargo is eligible only when vehicle config identifies a forward
// compartment, or when a small transport has no separate passenger section.
if (_air) exitWith {false};
private _cfg = configFile >> "CfgVehicles" >> typeOf _vehicle;
private _compartments = getArray (_cfg >> "cargoCompartments");
if (count _compartments > 1) exitWith {
    private _coDriverSeats = getArray (_cfg >> "cargoIsCoDriver");
    _cargoIndex < (count _coDriverSeats - 1)
};
getNumber (_cfg >> "transportSoldier") < 5
