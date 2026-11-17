params ["_action"];
if (isNull findDisplay 87000) exitWith {};
switch (_action) do {
    case "POWER": {["POWER"] call SICS_fnc_toggleDevice};
    case "HOME": {if (SICS_osApp=="HOME") then {[!(findDisplay 87000 getVariable ["ATLAS_startOpen",false])] call SICS_fnc_osHome} else {[] call SICS_fnc_osHome}};
    case "CAMERA": {["CAMERA"] call SICS_fnc_launchApp};
    default {
        if (SICS_osApp!="ATLAS") then {["ATLAS"] call SICS_fnc_launchApp};
        if (_action=="MESSAGES") then {SICS_tab="MESSAGES";[] call SICS_fnc_page} else {
            if (_action in ["IN","OUT"]) then {
                if (SICS_tab!="OVERVIEW") then {SICS_tab="OVERVIEW";[] call SICS_fnc_page};
                if (SICS_deviceMode in ["PHONE","PORTABLE"]) then {SICS_mobilePane="MAP";[] call SICS_fnc_mobileLayout};
                [[1,-1] select (_action=="IN")] call SICS_fnc_mapZoom;
            };
        };
    };
};
