class CfgFactionClasses {class ATLAS_Modules {displayName="ATLAS / SynapseOS";priority=2;side=7;};};
class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class AttributesBase {class Default;class Edit;class Checkbox;};
        class ModuleDescription {};
    };
    class ATLAS_ModuleSettings: Module_F {
        scope=2;scopeCurator=0;displayName="ATLAS mission settings";category="ATLAS_Modules";
        icon="\x\sics\addons\core\ui\settings_glyph_ca.paa";
        function="SICS_fnc_moduleSettings";functionPriority=2;isGlobal=0;isTriggerActivated=0;
        class Attributes: AttributesBase {
            class tablet: Checkbox {property="ATLAS_tablet";displayName="Allow tablet";defaultValue="true";expression="_this setVariable ['tablet',_value,true]";};
            class phone: tablet {property="ATLAS_phone";displayName="Allow phone";expression="_this setVariable ['phone',_value,true]";};
            class portable: tablet {property="ATLAS_portable";displayName="Allow portable GPS";expression="_this setVariable ['portable',_value,true]";};
            class vehicles: tablet {property="ATLAS_vehicles";displayName="Allow mounted consoles";expression="_this setVariable ['vehicles',_value,true]";};
            class camera: tablet {property="ATLAS_camera";displayName="Allow Camera app";expression="_this setVariable ['camera',_value,true]";};
            class drone: tablet {property="ATLAS_drone";displayName="Allow UAV links / control";expression="_this setVariable ['drone',_value,true]";};
            class helmet: tablet {property="ATLAS_helmet";displayName="Allow helmet cameras";expression="_this setVariable ['helmet',_value,true]";};
            class tracking: tablet {property="ATLAS_tracking";displayName="Allow ATLAS BFT";expression="_this setVariable ['tracking',_value,true]";};
            class overlays: tablet {property="ATLAS_overlays";displayName="Allow operational overlays";expression="_this setVariable ['overlays',_value,true]";};
            class support: tablet {property="ATLAS_support";displayName="Allow support / air coordination";expression="_this setVariable ['support',_value,true]";};
            class assignedCommandOnly: tablet {property="ATLAS_assignedCommandOnly";displayName="Only assigned commanders may issue plans / orders";defaultValue="false";expression="_this setVariable ['assignedCommandOnly',_value,true]";};
            class journalLimit: Edit {property="ATLAS_journalLimit";displayName="Journal retention (100–2000)";typeName="NUMBER";defaultValue="500";expression="_this setVariable ['journalLimit',_value,true]";};
            class contactTTL: Edit {property="ATLAS_contactTTL";displayName="Default contact expiry (seconds)";typeName="NUMBER";defaultValue="1800";expression="_this setVariable ['contactTTL',_value,true]";};
            class vehicleClasses: Edit {property="ATLAS_vehicleClasses";displayName="Allowed console classes (blank = cTab rules)";typeName="STRING";defaultValue="''";expression="_this setVariable ['vehicleClasses',_value,true]";};
        };
        class ModuleDescription {description="Server-authoritative ATLAS device, sensor, command and retention policy. Group-leader permissions remain enabled unless assigned-only is selected.";};
    };
};
class Cfg3DEN {
    class Object {class AttributeCategories {class ATLAS_Attributes {
        displayName="ATLAS / SynapseOS";collapsed=1;
        class Attributes {
            class ATLAS_Commander {displayName="ATLAS commander";property="ATLAS_commander";control="Checkbox";typeName="BOOL";defaultValue="false";expression="if (_this isKindOf 'Man') then {_this setVariable ['ATLAS_commander',_value,true]}";condition="object";};
            class ATLAS_Console {displayName="Enable compatible vehicle console";property="ATLAS_consoleEnabled";control="Checkbox";typeName="BOOL";defaultValue="true";expression="_this setVariable ['ATLAS_consoleEnabled',_value,true]";condition="objectVehicle";};
            class ATLAS_ScreenSide {displayName="Briefing screen side (0 east / 1 west / 2 independent / 3 civilian)";property="ATLAS_briefSideIndex";control="Edit";typeName="NUMBER";defaultValue="1";expression="_this setVariable ['ATLAS_briefSideIndex',_value,true]";condition="object";};
            class ATLAS_ScreenSelection {displayName="Briefing screen texture selection";property="ATLAS_briefSelection";control="Edit";typeName="NUMBER";defaultValue="0";expression="_this setVariable ['ATLAS_briefSelection',_value,true]";condition="object";};
            class ATLAS_BriefingScreen {displayName="Register as ATLAS briefing screen / TOC";property="ATLAS_isBriefingScreen";control="Checkbox";typeName="BOOL";defaultValue="false";condition="object";expression="if (_value && {isServer}) then {[_this] spawn {params ['_object'];sleep 0.5;private _index=(_object getVariable ['ATLAS_briefSideIndex',1]) max 0 min 3;[_object,[east,west,resistance,civilian] select floor _index,_object getVariable ['ATLAS_briefSelection',0]] call SICS_fnc_briefingScreen}}";};
        };
    };};};
};
