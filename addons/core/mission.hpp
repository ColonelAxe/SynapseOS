class CfgFactionClasses {class ATLAS_Modules {displayName="SynapseOS / Command Element Setup";priority=2;side=7;};};
class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class AttributesBase {class Default;class Edit;class Checkbox;class Combo;};
        class ModuleDescription {};
    };
    class ATLAS_ModuleTOC: Module_F {
        scope=2;scopeCurator=0;displayName="TOC / Synced Displays";category="ATLAS_Modules";
        function="SICS_fnc_moduleTOC";functionPriority=5;isGlobal=0;isTriggerActivated=0;
        class Attributes: AttributesBase {
            class tocISR: Checkbox {property="ATLAS_tocISR";displayName="Display ISR (off = tactical briefing)";defaultValue="true";expression="_this setVariable ['tocISR',_value,true]";};
            class tocSide: Edit {property="ATLAS_tocSide";displayName="Side: 0 east / 1 west / 2 independent / 3 civilian";typeName="NUMBER";defaultValue="1";expression="_this setVariable ['tocSide',_value,true]";};
            class tocSelection: Edit {property="ATLAS_tocSelection";displayName="Screen texture selection";typeName="NUMBER";defaultValue="0";expression="_this setVariable ['tocSelection',_value,true]";};
        };
        class ModuleDescription {description="Sync one or more retexturable screens/laptops. In-game ACE-interact: ATLAS TOC Video Feed, then choose a friendly UAV or equipped helmet camera. Syncing a source is optional. Screens on the same module switch together. Separate modules allow independent feeds. PiP must be enabled.";};
    };
    class ATLAS_ModuleTOCSetup: Module_F {
        scope=2;scopeCurator=0;displayName="TOC Setup";category="ATLAS_Modules";
        function="SICS_fnc_moduleTOCSetup";functionPriority=5;isGlobal=0;isTriggerActivated=0;
        class Attributes: AttributesBase {
            class masterDevice: Edit {property="ATLAS_tocSetupMaster";displayName="Master device object variable";typeName="STRING";defaultValue="''";expression="_this setVariable ['masterDevice',_value]";};
            class roomSide: Combo {
                property="ATLAS_tocSetupSide";displayName="Side";typeName="NUMBER";defaultValue="1";expression="_this setVariable ['roomSide',_value]";
                class Values {class East {name="OPFOR";value=0;}; class West {name="BLUFOR";value=1;}; class Independent {name="Independent";value=2;}; class Civilian {name="Civilian";value=3;};};
            };
            class screen1: Edit {property="ATLAS_tocSetupScreen1";displayName="Screen 1 object variable";typeName="STRING";defaultValue="''";expression="_this setVariable ['screen1',_value]";};
            class view1: Combo {property="ATLAS_tocSetupView1";displayName="Screen 1 startup view";defaultValue="1";expression="_this setVariable ['view1',_value]";typeName="NUMBER"; class Values {class Standby {name="Standby";value=0;}; class Map {name="ATLAS briefing map";value=1;}; class ISR {name="ISR video";value=2;};};};
            class screen2: Edit {property="ATLAS_tocSetupScreen2";displayName="Screen 2 object variable";typeName="STRING";defaultValue="''";expression="_this setVariable ['screen2',_value]";};
            class view2: view1 {property="ATLAS_tocSetupView2";displayName="Screen 2 startup view";defaultValue="2";expression="_this setVariable ['view2',_value]";};
            class screen3: Edit {property="ATLAS_tocSetupScreen3";displayName="Screen 3 object variable";typeName="STRING";defaultValue="''";expression="_this setVariable ['screen3',_value]";};
            class view3: view1 {property="ATLAS_tocSetupView3";displayName="Screen 3 startup view";defaultValue="0";expression="_this setVariable ['view3',_value]";};
            class screen4: Edit {property="ATLAS_tocSetupScreen4";displayName="Screen 4 object variable";typeName="STRING";defaultValue="''";expression="_this setVariable ['screen4',_value]";};
            class view4: view1 {property="ATLAS_tocSetupView4";displayName="Screen 4 startup view";defaultValue="0";expression="_this setVariable ['view4',_value]";};
            class textureSelection: Edit {property="ATLAS_tocSetupSelection";displayName="Screen texture selection";typeName="NUMBER";defaultValue="0";expression="_this setVariable ['textureSelection',_value]";};
        };
        class ModuleDescription {description="Enter the Eden object variable of a master laptop or PC and up to four retexturable displays. Leave unused screens blank. Use one module per room. No synchronization is required.";};
    };
    class ATLAS_ModuleSettings: Module_F {
        scope=2;scopeCurator=0;displayName="Command Element Setup / Mission Policy";category="ATLAS_Modules";
        icon="\x\sics\addons\core\ui\settings_glyph_ca.paa";
        function="SICS_fnc_moduleSettings";functionPriority=2;isGlobal=0;isTriggerActivated=0;
        class Attributes: AttributesBase {
            class showAI: Checkbox {property="ATLAS_showAI";displayName="[ROSTER] Include friendly AI in unit / message lists";defaultValue="false";expression="_this setVariable ['showAI',_value,true]";};
            class tablet: Checkbox {property="ATLAS_tablet";displayName="[DEVICES] Allow tablet";defaultValue="true";expression="_this setVariable ['tablet',_value,true]";};
            class phone: tablet {property="ATLAS_phone";displayName="[DEVICES] Allow phone";expression="_this setVariable ['phone',_value,true]";};
            class portable: tablet {property="ATLAS_portable";displayName="[DEVICES] Allow portable GPS";expression="_this setVariable ['portable',_value,true]";};
            class vehicles: tablet {property="ATLAS_vehicles";displayName="[DEVICES] Allow mounted consoles";expression="_this setVariable ['vehicles',_value,true]";};
            class camera: tablet {property="ATLAS_camera";displayName="[SENSORS] Allow Camera app";expression="_this setVariable ['camera',_value,true]";};
            class drone: tablet {property="ATLAS_drone";displayName="[SENSORS] Allow UAV links / control";expression="_this setVariable ['drone',_value,true]";};
            class helmet: tablet {property="ATLAS_helmet";displayName="[SENSORS] Allow helmet cameras";expression="_this setVariable ['helmet',_value,true]";};
            class tracking: tablet {property="ATLAS_tracking";displayName="[SENSORS] Allow ATLAS Blue Force Tracking";expression="_this setVariable ['tracking',_value,true]";};
            class overlays: tablet {property="ATLAS_overlays";displayName="[COMMAND] Allow operational overlays";expression="_this setVariable ['overlays',_value,true]";};
            class support: tablet {property="ATLAS_support";displayName="[COMMAND] Allow support / air coordination";expression="_this setVariable ['support',_value,true]";};
            class assignedCommandOnly: tablet {property="ATLAS_assignedCommandOnly";displayName="[COMMAND] Only assigned commanders may issue plans / orders";defaultValue="false";expression="_this setVariable ['assignedCommandOnly',_value,true]";};
            class journalLimit: Edit {property="ATLAS_journalLimit";displayName="[RECORDS] Journal retention (100–2000)";typeName="NUMBER";defaultValue="500";expression="_this setVariable ['journalLimit',_value,true]";};
            class contactTTL: Edit {property="ATLAS_contactTTL";displayName="[RECORDS] Default contact expiry (seconds)";typeName="NUMBER";defaultValue="1800";expression="_this setVariable ['contactTTL',_value,true]";};
            class vehicleClasses: Edit {property="ATLAS_vehicleClasses";displayName="[VEHICLES] Allowed console classes (blank = SynapseOS defaults)";typeName="STRING";defaultValue="''";expression="_this setVariable ['vehicleClasses',_value,true]";};
        };
        class ModuleDescription {description="COMMAND ELEMENT SETUP / Place once per mission. These server-authoritative options control available devices, sensors, command features and record retention. They do not assign player roles or commander permissions. Assign commanders on unit attributes; configure vehicle consoles and TOC screens on their objects.";};
    };
};
class Cfg3DEN {
    class Object {class AttributeCategories {class ATLAS_Attributes {
        displayName="SynapseOS / Command Element Setup";collapsed=1;
        class Attributes {
            class ATLAS_Commander {displayName="[COMMAND] Assign ATLAS commander";property="ATLAS_commander";control="Checkbox";typeName="BOOL";defaultValue="false";expression="if (_this isKindOf 'Man') then {_this setVariable ['ATLAS_commander',_value,true]}";condition="object";};
            class ATLAS_Console {displayName="[VEHICLE] Enable compatible vehicle console";property="ATLAS_consoleEnabled";control="Checkbox";typeName="BOOL";defaultValue="true";expression="_this setVariable ['ATLAS_consoleEnabled',_value,true]";condition="objectVehicle";};
            class ATLAS_ScreenSide {displayName="[TOC] Briefing screen side (0 east / 1 west / 2 independent / 3 civilian)";property="ATLAS_briefSideIndex";control="Edit";typeName="NUMBER";defaultValue="1";expression="_this setVariable ['ATLAS_briefSideIndex',_value,true]";condition="object";};
            class ATLAS_ScreenSelection {displayName="[TOC] Briefing screen texture selection";property="ATLAS_briefSelection";control="Edit";typeName="NUMBER";defaultValue="0";expression="_this setVariable ['ATLAS_briefSelection',_value,true]";condition="object";};
            class ATLAS_BriefingScreen {displayName="[TOC] Register briefing screen / command room";property="ATLAS_isBriefingScreen";control="Checkbox";typeName="BOOL";defaultValue="false";condition="object";expression="if (_value && {isServer}) then {[_this] spawn {params ['_object'];sleep 0.5;private _index=(_object getVariable ['ATLAS_briefSideIndex',1]) max 0 min 3;[_object,[east,west,resistance,civilian] select floor _index,_object getVariable ['ATLAS_briefSelection',0]] call SICS_fnc_briefingScreen}}";};
        };
    };};};
};
