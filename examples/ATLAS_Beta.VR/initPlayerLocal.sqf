waitUntil {!isNull player};
private _equip={
    params ["_unit"];
    _unit allowDamage false;
    if (backpack _unit=="") then {_unit addBackpack "B_AssaultPack_mcamo"};
    if !("ATLAS_Tablet" in items _unit) then {_unit addItemToBackpack "ATLAS_Tablet"};
    if !("ATLAS_Phone" in items _unit) then {_unit addItemToBackpack "ATLAS_Phone"};
    _unit linkItem "ItemMap";_unit linkItem "ItemCompass";
    if !("ItemMicroDAGR" in items _unit) then {_unit addItemToBackpack "ItemMicroDAGR"};
    if (side group _unit==west) then {_unit linkItem "B_UavTerminal";if !("ItemcTabHCam" in items _unit) then {_unit addItemToBackpack "ItemcTabHCam"}};
};
[player] call _equip;
missionNamespace setVariable ["ATLAS_betaEquip",_equip];
player addEventHandler ["Respawn",{params ["_unit"];[_unit] call (missionNamespace getVariable "ATLAS_betaEquip")}];
hint "ATLAS CB1: U = GPS, Ctrl+U = device, Alt+U = personal tablet. Tablet, phone and portable GPS are in your backpack. HQ creates private channels; other roles must be granted access. Settings / Preferences writes beta diagnostics to RPT.";
