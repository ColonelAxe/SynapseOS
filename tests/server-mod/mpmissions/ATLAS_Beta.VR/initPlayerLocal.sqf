waitUntil {!isNull player};
private _equip={
    params ["_unit"];
    if (backpack _unit=="") then {_unit addBackpack "B_AssaultPack_mcamo"};
    if !("ATLAS_Tablet" in items _unit) then {_unit addItemToBackpack "ATLAS_Tablet"};
    if !("ATLAS_Phone" in items _unit) then {_unit addItemToBackpack "ATLAS_Phone"};
    _unit linkItem "ItemMap";_unit linkItem "ItemCompass";
    if (side group _unit==west) then {_unit linkItem "B_UavTerminal"};
    _unit setVariable ["ATLAS_commander",true,true];
};
[player] call _equip;
missionNamespace setVariable ["ATLAS_betaEquip",_equip];
player addEventHandler ["Respawn",{params ["_unit"];[_unit] call (missionNamespace getVariable "ATLAS_betaEquip")}];
hint "ATLAS beta: U = moving GPS, Ctrl+U = device, Alt+U = personal tablet. Both ATLAS items are in your backpack. Settings / Preferences can write diagnostics to the RPT.";
