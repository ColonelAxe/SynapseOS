// Convert server-authorised SynapseOS snapshots to a shared UI roster shape.
private _entries=[];
private _tracks=missionNamespace getVariable ["ATLAS_networkTracks",createHashMap];
{
    private _object=objectFromNetId _x;
    if (!isNull _object && {alive _object}) then {
        private _commander=if (_object isKindOf "Man") then {_object} else {effectiveCommander _object};
        private _callsign=if (isNull _commander) then {groupId group _object} else {groupId group _commander};
        private _name=if (_object isKindOf "Man") then {name _object} else {getText (configOf _object >> "displayName")};
        private _picture=call {
            if (_object isKindOf "Man") exitWith {"\A3\ui_f\data\map\vehicleicons\iconMan_ca.paa"};
            if (_object isKindOf "Plane") exitWith {"\A3\ui_f\data\map\vehicleicons\iconPlane_ca.paa"};
            if (_object isKindOf "Helicopter") exitWith {"\A3\ui_f\data\map\vehicleicons\iconHelicopter_ca.paa"};
            "\A3\ui_f\data\map\vehicleicons\iconCar_ca.paa"
        };
        _entries pushBack [_object,_picture,"",format ["%1 / %2",_callsign,_name]];
    };
} forEach keys _tracks;
_entries
