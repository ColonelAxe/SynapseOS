disableSerialization;
params ["_map","_button","_x","_y"];
if (SICS_tab=="MESSAGES" && {!((missionNamespace getVariable ["SICS_deviceMode","TABLET"]) in ["PHONE","PORTABLE"])}) exitWith {false};
private _pos=_map ctrlMapScreenToWorld [_x,_y];
private _tool=missionNamespace getVariable ["SICS_mapTool","GRID"];
if (_button==1) exitWith {
    if (_tool!="LINE") exitWith {false};
    if (SICS_lineStart isNotEqualTo []) exitWith {SICS_lineStart=[];true};
    private _found=-1;
    {
        if ((_x select 3)=="SICS_LINE") then {
            private _p=_x select 9;
            private _a=_map ctrlMapWorldToScreen (_p select 0);
            private _b=_map ctrlMapWorldToScreen (_p select 1);
            if (_a isNotEqualTo [] && {_b isNotEqualTo []}) then {
                private _vx=(_b select 0)-(_a select 0);private _vy=(_b select 1)-(_a select 1);
                private _len=_vx*_vx+_vy*_vy;
                if (_len>0) then {private _t=((((_this select 2)-(_a select 0))*_vx+((_this select 3)-(_a select 1))*_vy)/_len) max 0 min 1; if ([(_a select 0)+_t*_vx,(_a select 1)+_t*_vy] distance2D [_this select 2,_this select 3]<0.02) exitWith {_found=_x select 0}};
            };
        };
    } forEach values SICS_clientMarkers;
    if (_found>=0) then {[player,"MARKER_DELETE",[_found],SICS_terminal] remoteExecCall ["SICS_fnc_server",2]};true
};
if (_button!=0) exitWith {false};
// Selection is independent of the picked grid and survives panning.
if (_tool in ["GRID","INSPECT"]) then {
    private _nearest=objNull;private _distance=0.025;
    {
        private _obj=_x select 0;
        private _screen=_map ctrlMapWorldToScreen (([vehicle _obj] call SICS_fnc_trackStatus) select 2);
        if (_screen isNotEqualTo []) then {
            private _d=_screen distance2D [_this select 2,_this select 3];
            if (_d<_distance) then {_distance=_d;_nearest=_obj};
        };
    } forEach ([] call SICS_fnc_trackEntries);
    if (!isNull _nearest) then {SICS_selectedUnit=_nearest;[] call SICS_fnc_details};
    if (_tool=="INSPECT") exitWith {
        if (isNull _nearest) then {(findDisplay 87000 displayCtrl 60) ctrlSetText "INSPECT UNIT  /  No friendly symbol here. Previous selection retained."} else {
            if ((missionNamespace getVariable ["SICS_deviceMode","TABLET"]) in ["PHONE","PORTABLE"]) then {SICS_mobilePane="APP"};
            [] call SICS_fnc_inspect;
        };
    };
};
if (_tool=="INSPECT") exitWith {true};
SICS_selectedPosition=_pos;
switch (_tool) do {
    case "CONTACT": {[_pos] call SICS_fnc_contactEditor;true};
    case "MARKER": {
     .øï¾m¢G§²ÚîÆ­yÕ…¥¹qÍ•ÉÙ•Èµ¡•¬¹ÍÅ˜‰õôì)¥˜€ …¡…Í%¹Ñ•É™…”ñðí¥ÌÍ9ô¤•á¥Ñ]¥Ñ íôì)mtÍÁ…Ý¸ì(€€€Ý…¥ÑU¹Ñ¥°ì…¥Í9Õ±°Á±…å•Éôì(€€€Í±••À€Ìì(€€€Á±…å•È…±±½Ý…µ…”™…±Í”ì(€€€Á±…å•È…‘‘%Ñ•µQ½Y•ÍÐ€‰Q1M}Q…‰±•Ðˆì(€€€Á±…å•È±¥¹­%Ñ•´€‰Q1M}Q…‰±•Ðˆì(€€€Á±…å•ÈÍ•ÑY…É¥…‰±”l‰M%M}½µµ…¹‘•Èˆ±ÑÉÕ”±ÑÉÕ•tì(€€€É½ÕÀÁ±…å•ÈÍ•ÑÉ½ÕÁ%‘±½‰…°l‰Q1L€Ø‰tì(€€€M%M}Ñ•ÍÑÉ½ÕÁÌõÉ•…Ñ•!…Í¡5…Àì(€€€ì(€€€€€€€ÁÉ¥Ù…Ñ”}œõÉ•…Ñ•É½ÕÀÝ•ÍÐì(€€€€€€€ÁÉ¥Ù…Ñ”}Ôõ}œÉ•…Ñ•U¹¥Ðl‰	}M½±‘¥•É}Q1}ˆ±Á±…å•È•ÑA½ÌlÔÀ­}™½É…¡%¹‘•à¨ÔÀ°ÐÔ­}™½É…¡%¹‘•à¨ÐÁt±mt°À°‰9=9‰tì(€€€€€€€}Ô…±±½Ý…µ…”™…±Í”í}Ô‘¥Í…‰±•$€‰QIPˆí}Ô‘¥Í…‰±•$€‰UQ=QIPˆí}œÍ•Ñ½µ‰…Ñ5½‘”€‰	1Uˆì(€€€€€€€}Ô±¥¹­%Ñ•´€‰Q1M}Q…‰±•Ðˆì(€€€€€€€}œÍ•ÑÉ½ÕÁ%‘±½‰…°m}átì(€€€€€€€M%M}Ñ•ÍÑÉ½ÕÁÌÍ•Ðm}à±}tì(€€€ô™½É… l‰1A!€Ä´Äˆ°‰	IY<€Ä´È‰tì(€€€ÁÉ¥Ù…Ñ”}Àõ•ÑA½ÍQ0Á±…å•Èì(€€€ÁÉ¥Ù…Ñ”}…ÈõÉ•…Ñ•Y•¡¥±”l‰	}5IA|ÀÅ}ˆ±Á±…å•È•ÑA½ÌlÜÀ°äÁt±mt°À°‰9=9‰tì(€€€É•…Ñ•Y•¡¥±•É•Ü}…Èí}…È…±±½Ý…µ…”™…±Í”í}…È±¥µ¥ÑMÁ••€ÌÔì(€€€‘É¥Ù•È}…È‘½5½Ù”€¡Á±…å•È•ÑA½ÌlÔÀÀ°Át¤ì(€€€ÁÉ¥Ù…Ñ”}¡•±¤õÉ•…Ñ•Y•¡¥±”l‰	}!•±¥}1¥¡Ñ|ÀÅ}ˆ±m}ÀÍ•±•Ð€À°¡}ÀÍ•±•Ð€Ä¤¬ÈÔÀ°ÄàÁt±mt°À°‰1d‰tì(€€€É•…Ñ•Y•¡¥±•É•Ü}¡•±¤í}¡•±¤…±±½Ý…µ…”™…±Í”í}¡•±¤™±å%¹!•¥¡Ð€ÄàÀì(€€€}¡•±¤Í•ÑY•±½¥ÑälÈÀ°ÄÀ°Átí‘É¥Ù•È}¡•±¤‘½5½Ù”€¡Á±…å•È•ÑA½ÌlÈÔÀÀ°ÐÕt¤ì(€€€ÁÉ¥Ù…Ñ”}Á±…¹”õÉ•…Ñ•Y•¡¥±”l‰	}A±…¹•}M|ÀÅ}ˆ±l¡}ÀÍ•±•Ð€À¤¬ØÀÀ±}ÀÍ•±•Ð€Ä°ØÀÁt±mt°À°‰1d‰tì(€€€É•…Ñ•Y•¡¥±•É•Ü}Á±…¹”í}Á±…¹”…±±½Ý…µ…”™…±Í”í}Á±…¹”™±å%¹!•¥¡Ð€ØÀÀì(€€€}Á±…¹”Í•Ñ¥È€äÀí}Á±…¹”Í•ÑY•±½¥ÑälÄÈÀ°À°Átí‘É¥Ù•È}Á±…¹”‘½5½Ù”€¡Á±…å•È•ÑA½ÌlÔÀÀÀ°äÁt¤ì(€€€¥˜€¡¥Í±…ÍÌ€¡½¹™¥¥±”€øø€‰™A…Ñ¡•Ìˆ€øø€‰Í¥Í}¡…Ñ¡•Ðˆ¤€˜˜í¥Í±…ÍÌ€¡½¹™¥¥±”€øø€‰™Y•¡¥±•Ìˆ€øø€‰ÙÑá}5 ØÁ4ˆ¥ô¤Ñ¡•¸ì(€€€€€€€ÁÉ¥Ù…Ñ”}¡…Ñ¡•ÐõÉ•…Ñ•Y•¡¥±”l‰ÙÑá}5 ØÁ4ˆ±Á±…å•È•ÑA½ÌlÄÈ°Át±mt°À°‰9=9‰tì(€€€€€€€}¡…Ñ¡•ÐÍ•Ñ¥È•Ñ¥ÈÁ±…å•Èí}¡…Ñ¡•Ð…±±½Ý…µ…”™…±Í”íÁ±…å•Èµ½Ù•%¹É¥Ù•È}¡…Ñ¡•ÐíÉ•…Ñ•Y•¡¥±•É•Ü}¡…Ñ¡•Ðì(€€€€€€€µ¥ÍÍ¥½¹9…µ•ÍÁ…”Í•ÑY…É¥…‰±”l‰M%M}Ñ•ÍÑ!…Ñ¡•Ðˆ±}¡…Ñ¡•Ñtì(€€€€€€€‘¥…}±½œ™½Éµ…Ðl‰Q1M}!Q!Q}QMPIdè±…ÍÌô”Ä‘É¥Ù•Èô”Èˆ±ÑåÁ•=˜}¡…Ñ¡•Ð±‘É¥Ù•È}¡…Ñ¡•ÐôõÁ±…å•Étì(€€€ôì(€€€M%M}Ñ•ÍÑY•¡¥±•Ìõm}…È±}¡•±¤±}Á±…¹•tì(€€€íÁÉ¥Ù…Ñ”}œõÉ½ÕÀ‘É¥Ù•È}àí}œÍ•Ñ½µ‰…Ñ5½‘”€‰	1Uˆíí}à…±±½Ý…µ…”™…±Í”í}à‘¥Í…‰±•$€‰QIPˆí}à‘¥Í…‰±•$€‰UQ=QIP‰ô™½É… É•Ü}áô™½É… M%M}Ñ•ÍÑY•¡¥±•Ìì(€€€‘¥…}±½œ™½Éµ…Ðl‰M%M}QMPIdèÁ±…å•É=Ý¹•Èô”Ä°…±¥Ù”ô”È°…•ÍÌô”Ìˆ±½Ý¹•ÈÁ±…å•È±…±¥Ù”Á±…å•È±mÁ±…å•Ét…±°M%M}™¹}…•ÍÍtì(€€€m½‰©9Õ±°°‰Q	1P‰t…±°M%M}™¹}½Á•¸ì(€€€Í±••À€Ìì(€€€ì(€€€€€€€ÁÉ¥Ù…Ñ”}¡•¬õmt•á•Y4€ ‰qáqÍ¥Í}Ñ•ÍÑq…‘‘½¹Íqµ…¥¹pˆ­}à¤ì(€€€€€€€Ý…¥ÑU¹Ñ¥°íÍ±••À€À¸ÈíÍÉ¥ÁÑ½¹”}¡•­ôì(€€€ô™½É… l‰½Á•É…Ñ¥½¹Ìµ¡•¬¹ÍÅ˜ˆ°‰‰•Ñ„µ¡•¬¹ÍÅ˜ˆ°‰Íµ½­”¹ÍÅ˜ˆ°‰µ•‘¥„µ¡•¬¹ÍÅ˜ˆ°‰‘É½¹”µ¡•¬¹ÍÅ˜ˆ°‰¡…Ñ¡•Ðµ¡•¬¹ÍÅ˜ˆ°‰Õ¤µ…Õ‘¥Ð¹ÍÅ˜‰tì(€€€ÁÉ¥Ù…Ñ”}±…É”õlÄ¸ÄÕt•á•Y4€‰qáqÍ¥Í}Ñ•ÍÑq…‘‘½¹Íqµ…¥¹qÕ¤µ…Õ‘¥Ð¹ÍÅ˜ˆì(€€€Ý…¥ÑU¹Ñ¥°íÍ±••À€À¸ÈíÍÉ¥ÁÑ½¹”}±…É•ôì(€€€‘¥…}±½œ€‰Q1M}=5	%9}QMP=5A1Qˆì)ôì(