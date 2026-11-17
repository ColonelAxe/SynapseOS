if (!isNil "cTabIfOpen") exitWith {[] call cTab_fnc_toggleIfPosition};
if (missionNamespace getVariable ["SICS_quickActive",false]) exitWith {ATLAS_quickLeft=!(missionNamespace getVariable ["ATLAS_quickLeft",false]);true};
if (isNull findDisplay 87000) exitWith {false};
[missionNamespace getVariable ["SICS_deviceMode","TABLET"]] call SICS_fnc_selectDevice
