disableSerialization;
params [["_terminal",objNull],["_device",""],["_startApp","ATLAS"]];
if (!hasInterface || {!isNull findDisplay 87000}) exitWith {};
if (!([player,_terminal] call SICS_fnc_access)) exitWith {hint "ATLAS requires a carried SynapseOS device, enabled vehicle seat or authorised TOC terminal."};
if (missionNamespace getVariable ["SICS_markerSide",sideUnknown]!=sideUnknown && {SICS_markerSide!=side group player}) then {[] call SICS_fnc_resetClient;SICS_markerSide=side group player};
if (missionNamespace getVariable ["SICS_quickActive",false]) then {[] call SICS_fnc_quickView};
SICS_osApp="ATLAS";SICS_deviceState="FULL";
ATLAS_interfaceRole="SECONDARY";
SICS_terminal = _terminal;
SICS_tab = "OVERVIEW";
SICS_localRecords = [];
SICS_openSide = side group player;
SICS_selectedPosition = getPosATL player;
SICS_selectedUnit = player;
SICS_detailTab = "OVERVIEW";
SICS_compose = false;
SICS_chatTarget="";
SICS_mapTool="GRID";
SICS_lineStart=[];
SICS_pendingMarker=[];
SICS_tracks=createHashMap;SICS_trackTick=-10;
if !(createDialog "SICS_Display") exitWith {diag_log "SICS_UI ERROR: createDialog failed"};
private _d = uiNamespace getVariable ["SICS_display",displayNull];
if (isNull _d) exitWith {diag_log "SICS_UI ERROR: onLoad did not return a display"};
uiNamespace setVariable ["SICS_display",_d];
private _vw=safeZoneW*0.95;
private _vh=(_vw/pixelW)/1.6*pixelH;
if (_vh>safeZoneH*0.95) then {_vh=safeZoneH*0.95;_vw=(_vh/pixelH)*1.6*pixelW};
SICS_viewport=[safeZoneX+(safeZoneW-_vw)/2,safeZoneY+(safeZoneH-_vh)/2,_vw,_vh];
(_d displayCtrl 90) ctrlSetPosition SICS_viewport; (_d displayCtrl 90) ctrlCommit 0;
(_d displayCtrl 91) ctrlSetPosition SICS_viewport; (_d displayCtrl 91) ctrlCommit 0;
SICS_fnc_rect={params ["_x","_y","_w","_h"]; SICS_viewport params ["_vx","_vy","_vw","_vh"]; [_vx+_x*_vw,_vy+_y*_vh,_w*_vw,_h*_vh]};
SICS_formViewport=+SICS_viewport;
SICS_fnc_formRect={params ["_x","_y","_w","_h"]; SICS_formViewport params ["_vx","_vy","_vw","_vh"]; [_vx+_x*_vw,_vy+_y*_vh,_w*_vw,_h*_vh]};
// Normalised safe-zone coordinates; the map remains the largest control.
SICS_fnc_control = {
    disableSerialization;
    params ["_class","_id","_rect",["_text",""]];
    private _display=_this param [4,uiNamespace getVariable ["SICS_display",displayNull]];
    private _c = _display displayCtrl _id;
    if (isNull _c) then {_c = _display ctrlCreate [_class,_id]};
    if (isNull _c) exitWith {diag_log format ["SICS_UI ERROR: cannot create %1 / %2",_class,_id]; controlNull};
    private _view=if (_display==findDisplay 87000 && {!(_id>=300 && {_id<=319})}) then {SICS_viewport} else {SICS_formViewport};
    _rect params ["_rx","_ry","_rw","_rh"];
    _view params ["_vx","_vy","_vw","_vh"];
    _c ctrlSetPosition [_vx+_rx*_vw,_vy+_ry*_vh,_rw*_vw,_rh*_vh];
    _c ctrlCommit 0;
    if !(_class in ["SICS_Map","RscPicture","SICS_ChatScroll"]) then {
        private _small=_display==findDisplay 87000 && {(missionNamespace getVariable ["SICS_deviceMode",""]) in ["PHONE","PORTABLE"]};
        private _height=(((_view select 3)*0.025) max (pixelH*([20,15] select _small))) min (pixelH*28);
        if (_class=="SICS_Header") then {_height=(((_view select 3)*0.022) max (pixelH*18)) min (pixelH*24)};
        if (_class=="SICS_Button") then {_height=(((_view select 3)*0.024) max (pixelH*([20,15] select _small))) min (pixelH*26)};
        if (_id>=230 && {_id<=233}) then {_height=(pixelH*18) min _height};
        if (_id==60) then {_height=pixelH*14};
        if ((_rect select 3)<0.065 && {_text find "\n"<0}) then {
            private _available=((_rect select 2)*(_view select 2))-pixelW*12;
            private _estimated=(count _text)*_height*0.44*pixelW/pixelH;
            if (_estimated>_available && {_estimated>0}) then {_height=_height*(_available/_estimated)};
        };
        _c ctrlSetFontHeight (_height*(missionNamespace getVariable ["ATLAS_textScale",1]));
    };
    if (_class!="SICS_ChatScroll") then {_c ctrlSetText _text}; _c ctrlSetFade 0; _c ctrlShow true; _c ctrlCommit 0; _c
};
["SICS_Text",2,[0.055,0.07,0.43,0.045],"ATLAS  /  Common operational picture"] call SICS_fnc_control;
["RscPicture",6,[0.052,0.064,0.036,0.058],"\x\sics\addons\core\ui\sics_logo_ca.paa"] call SICS_fnc_control;
private _deviceButton=["SICS_Button",5,[0.73,0.075,0.12,0.03],"TABLET"] call SICS_fnc_control;
_deviceButton ctrlAddEventHandler ["ButtonClick",{
    private _devices=[player,SICS_terminal] call SICS_fnc_devices;
    private _index=_devices find SICS_deviceMode;
    if (_devices isNotEqualTo []) then {[_devices select ((_index+1) mod count _devices)] call SICS_fnc_selectDevice};
}];
["SICS_Text",3,[0.60,0.07,0.29,0.045],"LINK INITIALISING"] call SICS_fnc_control;
private _exit = ["SICS_Button",4,[0.90,0.07,0.05,0.04],"CLOSE"] call SICS_fnc_control;
_exit ctrlSetText "Ã—";
_exit ctrlAddEventHandler ["ButtonClick",{["POWER"] call SICS_fnc_toggleDevice}];
private _home=["SICS_Button",7,[0.64,0.075,0.085,0.032],"Home"] call SICS_fnc_control;
_home ctrlAddEventHandler ["ButtonClick",{[] call SICS_fnc_osHome}];
private _minimize=["SICS_Button",8,[0.835,0.075,0.06,0.032],"âˆ’"] call SICS_fnc_control;
_minimize ctrlAddEventHandler ["ButtonClick",{["MINIMIZE"] call SICS_fnc_toggleDevice}];
_exit ctrlSetBackgroundColor [0.28,0.07,0.08,1];
{
    private _label=["Tactical","Messages","ISR / Assets","C2","Reports","TOC"] select _forEachIndex;
    private _b = ["SICS_Button",10+_forEachIndex,[0.05+_forEachIndex*0.151,0.14,0.14,0.052],_label] call SICS_fnc_control;
    _b setVariable ["SICS_tab",_x];
    _b ctrlAddEventHandler ["ButtonClick",{SICS_tab = (_this select 0) getVariable "SICS_tab"; SICS_compose=false; [] call SICS_fnc_page}];
} forEach ["OVERVIEW","MESSAGES","ISR","C2","REPORTS","TOC"];
["SICS_Text",30,[0.035,0.165,0.17,0.035],"FRIENDLY FORCES"] call SICS_fnc_control;
private _roster = ["SICS_List",31,[0.035,0.21,0.17,0.48]] call SICS_fnc_control;
_roster ctrlAddEventHandler ["LBSelChanged",{
    params ["_ctrl","_idx"];
    if (missionNamespace getVariable ["SICS_refreshing",false]) exitWith {};
    if (_idx<0) exitWith {};
    if (SICS_tab=="MESSAGES" && {(_ctrl lbData _idx) find "CH:"==0}) exitWith {
        SICS_chatTarget=_ctrl lbData _idx;[] call SICS_fnc_channelUI;
        if (SICS_deviceMode in ["PHONE","PORTABLE"]) then {SICS_mobilePane="APP";[] call SICS_fnc_mobileLayout};
    };
    if (SICS_tab=="MESSAGES" && {_ctrl lbData _idx=="__ALL__"}) exitWith {
        SICS_chatTarget=""; [] call SICS_fnc_channelUI;
        if (SICS_deviceMode in ["PHONE","PORTABLE"]) then {SICS_mobilePane="APP";[] call SICS_fnc_mobileLayout};
    };
    private _obj = objectFromNetId (_ctrl lbData _idx);
    if (SICS_tab=="MESSAGES" && {!isNull _obj}) then {
        SICS_chatTarget=netId group _obj;
        private _to=findDisplay 87000 displayCtrl 104;
        for "_i" from 0 to (lbSize _to-1) do {if (_to lbData _i==SICS_chatTarget) exitWith {_to lbSetCurSel _i}};
        [] call SICS_fnc_chat;
    };
    SICS_selectedUnit=_obj;
    [] call SICS_fnc_details;
    if (!isNull _obj) then {(findDisplay 87000 displayCtrl 40) ctrlMapAnimAdd [0.4,0.08,getPosATL _obj]; ctrlMapAnimCommit (findDisplay 87000 displayCtrl 40)};
    if (SICS_deviceMode in ["PHONE","PORTABLE"]) then {
        SICS_mobilePane="APP";
        if (SICS_tab!="MESSAGES") then {["INSPECT",false] call SICS_fnc_mapTool};
        [] call SICS_fnc_mobileLayout;
    };
}];
["SICS_Text",32,[0.035,0.71,0.17,0.03],"GROUP CALLSIGN"] call SICS_fnc_control;
["SICS_Edit",33,[0.035,0.75,0.17,0.04],groupId group player] call SICS_fnc_control;
private _rename = ["SICS_Button",34,[0.035,0.80,0.17,0.04],"APPLY CALLSIGN"] call SICS_fnc_control;
_rename ctrlAddEventHandler ["ButtonClick",{["CALLSIGN"] call SICS_fnc_submit}];
private _map = ["SICS_Map",40,[0.22,0.165,0.52,0.72]] call SICS_fnc_control;
_map ctrlAddEventHandler ["Draw",{_this call SICS_fnc_draw}];
_map ctrlAddEventHandler ["MouseButtonDown",{_this call SICS_fnc_mapClick}];
_map ctrlAddEventHandler ["MouseMoving",{params ["_ctrl","_x","_y"]; SICS_mapCursor=_ctrl ctrlMapScreenToWorld [_x,_y]}];
_map ctrlMapAnimAdd [0,0.12,getPosATL player]; ctrlMapAnimCommit _map;
["SICS_Text",50,[0.755,0.165,0.21,0.035],"OPERATIONS FEED"] call SICS_fnc_control;
private _feed = ["SICS_List",51,[0.755,0.21,0.21,0.37]] call SICS_fnc_control;
_feed ctrlAddEventHandler ["LBSelChanged",{
    params ["_c","_i"];
    (findDisplay 87000 displayCtrl 390) ctrlShow false;
    private _id = parseNumber (_c lbData _i);
    private _r = (missionNamespace getVariable ["SICS_localRecords",[]]) select {(_x select 0)==_id};
    if (_r isNotEqualTo []) then {
        _r = _r select 0; SICS_selectedRecord = _id;
        private _meta=_r param [11,[]];
        private _title=if (_meta isEqualTo []) then {_r select 2} else {format ["CONTACT / %1 / %2",_meta select 0,_meta select 2]};
        (findDisplay 87000 displayCtrl 52) ctrlSetText format ["%1 | %2%6%3%6GRID %4 | %5",_title,_r select 3,_r select 4,mapGridPosition (_r select 5),_r select 8,toString [10]];
        private _photos=_r param [12,[]];
        if (_photos isNotEqualTo [] && {SICS_tab=="OVERVIEW"}) then {
            private _view=["SICS_Button",390,[0.74,0.83,0.215,0.045],"View report photo"] call SICS_fnc_control;
            _view setVariable ["ATLAS_photo",[_id,_photos select 0]];_view ctrlRemoveAllEventHandlers "ButtonClick";
            _view ctrlAddEventHandler ["ButtonClick",{((_this select 0) getVariable "ATLAS_photo") call SICS_fnc_photoView}];
            if (SICS_deviceMode in ["PHONE","PORTABLE"]) then {[] call SICS_fnc_mobileLayout};
        };
    };
}];
["SICS_ReadOnly",52,[0.755,0.59,0.21,0.15],"Select a record to read details."] call SICS_fnc_control;
["SICS_Text",60,[0.045,0.915,0.90,0.025],"ATLAS // FIELD TABLET    |    CHOOSGm9¶‰žËkºwµçR“°¢&—fFRöCÖf–æDF—7Æ’ƒs°¢&—fFRöÓÕöBF—7Æ”7G&ÂC°¢¶–b†7G&Ä”D2÷ƒãÓSbb¶7G&Ä”D2÷ƒÃÓS'ÒÇÂ¶7G&Ä”D2÷ƒãÓÒ’F†Vâµ÷‚7G&Å6†÷r4”55öW‡æFVG×Òf÷$V6‚ÆÄ6öçG&öÇ2öC°¢–b‚4”55öW‡æFVB’W†—Ev—F‚µµÒ6ÆÂ4”55öfæ5÷vWÓ°¢²…öBF—7Æ”7G&Â÷‚’7G&Å6†÷rfÇ6WÒf÷$V6‚³3Ã3Ã3"Ã32Ã3EÓ°¢öÒ7G&Å6WE÷6—F–öâ…³ãCRÃã##RÃã“ÃãcÒ6ÆÂ4”55öfæ5÷&V7B“µöÒ7G&Ä6öÖÖ—B°§ÕÓ°¥µöFWf–6UÒ6ÆÂ4”55öfæ5öFWf–6TÆ–÷WC°¥·Æ–W"Â%5”ä2"ÅµÒÅ÷FW&Ö–æÅÒ&VÖ÷FTW†V46ÆÂ²%4”55öfæ5÷6W'fW""Ã%Ó°¥4”55÷&Vg&W6„†æFÆRÒ·µµÒ6ÆÂ4”55öfæ5÷&Vg&W6‡ÒÃ%Ò6ÆÂ4$öfæ5öFEW$g&ÖT†æFÆW#°¥µÒ6ÆÂ4”55öfæ5÷&Vg&W6ƒ°¦–b…÷7F'DÓÒ$„ôÔR"’F†VâµµÒ6ÆÂ4”55öfæ5ö÷4†öÖWÒVÇ6R¶–b…÷7F'DÓÒ$DÄ2"’F†VâµµÒ6ÆÂ4”55öfæ5÷&W7VÖU6W76–öçÒVÇ6Rµµ÷7F'DÒ6ÆÂ4”55öfæ5öÆVæ6„×Ó°¦F–uöÆörf÷&ÖB²%4”55õT’$TE“¢6öçG&öÇ3ÒSF—FÆSÒS"ÖÒS2"Æ6÷VçBÆÄ6öçG&öÇ2öBÆ7G&ÅFW‡B…öBF—7Æ”7G&Â"’Æ7G&Å6†÷vâ…öBF—7Æ”7G&ÂC•Ó° Ð