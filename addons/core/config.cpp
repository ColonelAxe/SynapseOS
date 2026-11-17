class CfgPatches {
    class sics_core {
        name = "SynapseOS Modular Tactical Platform";
        versionStr = "0.12.0-beta.2";
        units[] = {"ATLAS_ModuleSettings"};
        weapons[] = {"ATLAS_Tablet","ATLAS_Phone"};
        requiredVersion = 2.18;
        requiredAddons[] = {"cTab", "cba_keybinding", "A3_UI_F", "A3_Modules_F"};
    };
};
class CfgFunctions {
    class cTab {
        class Functions {
            class checkGear {file="\x\sics\addons\core\functions\fn_ctabCheckGear.sqf";};
        };
    };
    class SICS {
        class Core {
            file = "\x\sics\addons\core\functions";
            class init {postInit = 1;};
            class open {};
            class page {};
            class refresh {};
            class draw {};
            class submit {};
            class server {};
            class receive {};
            class registerTOC {};
            class access {};
            class radio {};
            class close {};
            class feed {};
            class layout {};
            class details {};
            class markerEditor {};
            class markerApply {};
            class markerServer {};
            class chat {};
            class mapTool {};
            class mapClick {};
            class affiliation {};
            class natoCatalog {};
            class contactEditor {};
            class contactApply {};
            class notify {};
            class tracks {};
            class centre {};
            class inspect {};
            class channelIdentity {};
            class channelAccess {};
            class recordAccess {};
            class channelSync {};
            class channelServer {};
            class channelEditor {};
            class channelUI {};
            class vehicleAccess {};
            class devices {};
            class deviceLayout {};
            class mobileLayout {};
            class quickView {};
            class toggleDevice {};
            class deviceKey {};
            class saveSession {};
            class resumeSession {};
            class registerApp {};
            class launchApp {};
            class osHome {};
            class selectDevice {};
            class initACE {};
            class keyAction {};
            class interfaceAction {};
            class mapZoom {};
            class interfacePosition {};
            class settings {};
            class profile {};
            class profileValidate {};
            class fitText {};
            class appHeader {};
            class frameButtons {};
            class frameAction {};
            class notifications {};
            class noticeOpen {};
            class preferences {};
            class diagnostics {};
            class resetClient {};
            class policy {};
            class configureMission {};
            class moduleSettings {};
            class operationsAccess {};
            class operationsSync {};
            class operationsServer {};
            class operationsJournal {};
            class operationsContact {};
            class operationsSchema {};
            class operationsValidate {};
            class operations {};
            class operationsSelect {};
            class operationsEditor {};
            class operationsSave {};
            class operationsMapClick {};
            class operationsDraw {};
            class navigation {};
            class workspace {};
            class briefingScreen {};
            class briefingDraw {};
            class heartbeat {};
            class trackStatus {};
            class bftDraw {};
            class aviationTAD {};
            class stopCamera {};
            class isrSelect {};
            class droneControl {};
            class camera {};
            class cameraClose {};
            class cameraSnap {};
            class photoUpload {};
            class photoServer {};
            class photoReceive {};
            class photoView {};
        };
    };
};
class CfgWeapons {
    class ItemcTab;
    class ItemAndroid;
    class ATLAS_Tablet: ItemcTab {
        scope=2;scopeArsenal=2;
        displayName="ATLAS Tablet";
        descriptionShort="Rugged SynapseOS tablet with the ATLAS tactical application.";
        descriptionUse="Open SynapseOS using the device key or ACE self-interaction.";
        author="ATLAS Team";
    };
    class ATLAS_Phone: ItemAndroid {
        scope=2;scopeArsenal=2;
        displayName="ATLAS Phone";
        descriptionShort="Landscape SynapseOS field handset with the ATLAS tactical application.";
        descriptionUse="Open SynapseOS using the device key or ACE self-interaction.";
        author="ATLAS Team";
    };
};
class CfgMarkerColors {class SICS_Civilian {name="Civilian (purple)";color[]={0.69,0.43,0.85,1};scope=2;};};
class CfgNotifications {
    class Default;
    class SICS_Received: Default {
        title="%1";description="%2";
        iconPicture="\A3\ui_f\data\map\markers\military\warning_CA.paa";
        iconText="ATLAS";duration=5;priority=4;color[]={0.22,0.70,1,1};
    };
};
class CfgSounds {
    class SICS_Message {name="ATLAS message";sound[]={"\x\sics\addons\core\audio\message.wav",1,1};titles[]={};};
    class SICS_Report {name="ATLAS report";sound[]={"\x\sics\addons\core\audio\report.wav",1,1};titles[]={};};
    class SICS_Contact {name="ATLAS contact";sound[]={"\x\sics\addons\core\audio\contact.wav",1,1};titles[]={};};
    class SICS_Order {name="ATLAS order";sound[]={"\x\sics\addons\core\audio\order.wav",1,1};titles[]={};};
    class SICS_Ack {name="ATLAS acknowledgement";sound[]={"\x\sics\addons\core\audio\ack.wav",1,1};titles[]={};};
    class SICS_Channel {name="ATLAS channel";sound[]={"\x\sics\addons\core\audio\channel.wav",1,1};titles[]={};};
    class SICS_Info {name="ATLAS information";sound[]={"\x\sics\addons\core\audio\info.wav",1,1};titles[]={};};
};
class CfgRemoteExec {
    class Functions {
        class SICS_fnc_server {allowedTargets = 2;};
        class SICS_fnc_receive {allowedTargets = 0;};
    };
};
class RscText;
class RscButtonMenu;
class RscEdit;
class RscListBox;
class RscCombo;
class RscMapControl;
class RscPicture;
class RscControlsGroup;
class RscStructuredText;
class SICS_ChatScroll: RscControlsGroup {class HScrollbar {height=0;};};
class SICS_ChatText: RscStructuredText {size="((0.022*safeZoneH) max (pixelH*22)) min (pixelH*28)"; colorBackground[]={0,0,0,0}; class Attributes {font="RobotoCondensed";color="#dbe9f2";align="left";shadow=0;};};
class SICS_Text: RscText {style=528; lineSpacing=1; font="RobotoCondensed"; sizeEx=0.024; colorText[]={0.81,0.90,0.96,1}; colorBackground[]={0,0,0,0};};
class SICS_AppLabel: SICS_Text {style=2;};
class SICS_Header: SICS_Text {sizeEx=0.023; colorText[]={0.40,0.78,1,1}; colorBackground[]={0.025,0.09,0.13,1};};
class SICS_Button: RscButtonMenu {
    font="RobotoCondensed"; sizeEx=0.023;
    style=2; shadow=0; autoAdjustTexture=1;
    color[]={0.83,0.93,1,1}; color2[]={1,1,1,1}; colorFocused[]={0.9,0.97,1,1};
    colorText[]={0.83,0.93,1,1}; colorBackground[]={0.11,0.20,0.28,1};
    colorBackground2[]={0.10,0.34,0.49,1}; colorBackgroundFocused[]={0.09,0.29,0.42,1};
    colorBackgroundActive[]={0.10,0.34,0.49,1};
    colorShadow[]={0,0,0,0}; borderSize=0;
    animTextureNormal="\x\sics\addons\core\ui\button_normal_ca.paa";
    animTextureDefault="\x\sics\addons\core\ui\button_normal_ca.paa";
    animTextureOver="\x\sics\addons\core\ui\button_over_ca.paa";
    animTextureFocused="\x\sics\addons\core\ui\button_over_ca.paa";
    animTexturePressed="\x\sics\addons\core\ui\button_pressed_ca.paa";
    animTextureDisabled="\x\sics\addons\core\ui\button_disabled_ca.paa";
    period=0;periodFocus=0;periodOver=0;
    class TextPos {left=0.006;top=0;right=0.006;bottom=0;forceMiddle=1;};
    class Attributes {font="RobotoCondensed";align="center";shadow=0;};
    class ShortcutPos {left=0;top=0;w=0;h=0;};
};
class SICS_Edit: RscEdit {font="RobotoCondensed"; sizeEx=0.023; colorBackground[]={0.025,0.055,0.08,1}; colorText[]={0.9,0.94,0.96,1}; colorSelection[]={0.08,0.38,0.58,1}; colorBorder[]={0.15,0.26,0.34,1};};
class SICS_HardwareButton: SICS_Button {
    colorBackground[]={0,0,0,0};colorBackground2[]={0.3,0.8,1,0.16};colorBackgroundFocused[]={0.3,0.8,1,0.12};
    animTextureNormal="";animTextureDefault="";animTextureOver="";animTextureFocused="";animTexturePressed="";animTextureDisabled="";
};
class SICS_TaskbarButton: SICS_HardwareButton {colorBackground2[]={1,1,1,0.10};colorBackgroundFocused[]={1,1,1,0.07};};
class SICS_Multiline: SICS_Edit {style=16; lineSpacing=1;};
class SICS_ReadOnly: SICS_Multiline {canModify=0;colorBackground[]={0.015,0.05,0.075,1};};
class SICS_List: RscListBox {font="RobotoCondensed"; sizeEx=0.023; rowHeight=0.048; colorText[]={0.74,0.88,0.96,1}; colorSelect[]={0.93,0.98,1,1}; colorSelect2[]={0.93,0.98,1,1}; colorBackground[]={0.015,0.05,0.075,1}; colorSelectBackground[]={0.02,0.32,0.52,1}; colorSelectBackground2[]={0.02,0.32,0.52,1};};
class SICS_Combo: RscCombo {font="RobotoCondensed"; sizeEx=0.021; colorBackground[]={0.05,0.10,0.14,1};};
class SICS_MultiList: SICS_List {style=32;};
class SICS_ChannelDisplay {
    idd=87002;movingEnable=0;enableSimulation=1;
    onKeyDown="[_this,false] call SICS_fnc_deviceKey";onKeyUp="[_this,true] call SICS_fnc_deviceKey";
    onUnload="if !(missionNamespace getVariable ['SICS_suspending',false]) then {if (!isNil 'SICS_savedAtlas') then {SICS_savedAtlas deleteAt 'channelDraft'}}";
    class controlsBackground {
        class Shade: RscText {idc=799;x="safeZoneX";y="safeZoneY";w="safeZoneW";h="safeZoneH";text="";colorBackground[]={0,0,0,0.65};};
        class Panel: RscText {idc=800;x=0;y=0;w=0;h=0;text="";colorBackground[]={0.025,0.07,0.105,1};};
    };
    class controls {};
};
class SICS_Map: RscMapControl {colorBackground[]={0.16,0.19,0.16,1}; colorOutside[]={0.04,0.08,0.11,1};};
class ATLAS_OperationDisplay {
    idd=87003;movingEnable=0;enableSimulation=1;
    onKeyDown="[_this,false] call SICS_fnc_deviceKey";onKeyUp="[_this,true] call SICS_fnc_deviceKey";
    onUnload="if (missionNamespace getVariable ['SICS_suspending',false] && {!(missionNamespace getVariable ['ATLAS_revokingSession',false])}) then {['DRAFT',_this select 0] call SICS_fnc_operationsSave} else {if !((_this select 0) getVariable ['ATLAS_redrawing',false]) then {ATLAS_opsCapture=false;ATLAS_opsDraftPoints=[]}}";
    class controlsBackground {class Shade: RscText {idc=2899;x="safeZoneX";y="safeZoneY";w="safeZoneW";h="safeZoneH";colorBackground[]={0,0,0,0.65};};};
    class controls {};
};
class ATLAS_BriefDisplay {
    idd=-1;movingEnable=0;
    onDraw="_this call SICS_fnc_briefingDraw";
    class controlsBackground {class Background: RscText {idc=-1;x=0;y=0;w=1;h=1;colorBackground[]={0.01,0.03,0.05,1};};};
    class controls {
        class Title: SICS_Header {idc=2;x=0;y=0;w=1;h=0.08;text="ATLAS / BRIEFING";sizeEx=0.035;};
        class Map: SICS_Map {idc=40;x=0;y=0.08;w=1;h=0.84;};
        class Caption: SICS_Text {idc=3;x=0;y=0.93;w=1;h=0.06;text="SHARED BRIEFING";sizeEx=0.03;};
    };
};
class RscTitles {
    class SICS_QuickView {
        idd=87010;duration=1e10;fadein=0.15;fadeout=0.15;movingEnable=0;
        onLoad="uiNamespace setVariable ['SICS_quickDisplay',_this select 0]";
        class controlsBackground {
            class Frame: RscPicture {idc=90;x="safeZoneX+safeZoneW*0.68";y="safeZoneY+safeZoneH*0.57";w="safeZoneW*0.30";h="safeZoneH*0.38";text="\x\sics\addons\core\ui\vehicle_frame_ca.paa";};
        };
        class controls {
            class Title: SICS_Header {idc=2;x="safeZoneX+safeZoneW*0.715";y="safeZoneY+safeZoneH*0.63";w="safeZoneW*0.23";h="safeZoneH*0.035";text="ATLAS / QUICK PICTURE";};
            class Navigation: SICS_Text {idc=3;x=0;y=0;w=0;h=0;text="";};
            class Map: SICS_Map {idc=40;x="safeZoneX+safeZoneW*0.715";y="safeZoneY+safeZoneH*0.676";w="safeZoneW*0.23";h="safeZoneH*0.20";};
        };
    };
};
class SICS_ContactDisplay {
    idd=87001;movingEnable=0;enableSimulation=1;
    onKeyDown="[_this,false] call SICS_fnc_deviceKey";onKeyUp="[_this,true] call SICS_fnc_deviceKey";
    onUnload="if !(missionNamespace getVariable ['SICS_suspending',false]) then {if (!isNil 'SICS_savedAtlas') then {SICS_savedAtlas deleteAt 'contactDraft'}}";
    class controlsBackground {
        class Shade: RscText {idc=399;x="safeZoneX";y="safeZoneY";w="safeZoneW";h="safeZoneH";text="";colorBackground[]={0,0,0,0.65};};
        class Panel: RscText {idc=400;x=0;y=0;w=0;h=0;text="";colorBackground[]={0.025,0.07,0.105,1};};
    };
    class controls {};
};
class SICS_Display {
    idd=87000; movingEnable=0; enableSimulation=1;
    onLoad="uiNamespace setVariable ['SICS_display',_this select 0]";
    onUnload="[_this select 0] call SICS_fnc_close";
    onKeyDown="[_this,false] call SICS_fnc_deviceKey";onKeyUp="[_this,true] call SICS_fnc_deviceKey";
    class controlsBackground {
        class TabletFrame: RscPicture {idc=90; x="safeZoneX"; y="safeZoneY"; w="safeZoneW"; h="safeZoneH"; text="\x\sics\addons\core\ui\tablet_frame_ca.paa";};
        class Surfaces: TabletFrame {idc=91;text="\x\sics\addons\core\ui\surface_tactical_ca.paa";};
        class OSWallpaper: RscPicture {idc=92;x=0;y=0;w=0;h=0;text="";};
        class OSStatusBar: RscText {idc=93;x=0;y=0;w=0;h=0;colorBackground[]={0.015,0.025,0.035,0.98};};
        class OSTaskBar: RscText {idc=94;x=0;y=0;w=0;h=0;colorBackground[]={0.015,0.025,0.035,0.98};};
    };
    class controls {
        class Title: SICS_Text {idc=2; x="safeZoneX+0.035*safeZoneW"; y="safeZoneY+0.043*safeZoneH"; w="0.38*safeZoneW"; h="0.045*safeZoneH"; text="A T L A S /   TACTICAL OPERATIONS";};
        class Network: SICS_Text {idc=3; x="safeZoneX+0.65*safeZoneW"; y="safeZoneY+0.043*safeZoneH"; w="0.25*safeZoneW"; h="0.045*safeZoneH"; text="LINK INITIALISING";};
        class Exit: SICS_Button {idc=4; x="safeZoneX+0.925*safeZoneW"; y="safeZoneY+0.045*safeZoneH"; w="0.04*safeZoneW"; h="0.035*safeZoneH"; text="X"; action="";};
        class Map: SICS_Map {idc=40; x="safeZoneX+0.22*safeZoneW"; y="safeZoneY+0.165*safeZoneH"; w="0.52*safeZoneW"; h="0.72*safeZoneH";};
    };
};

#include "mission.hpp"
