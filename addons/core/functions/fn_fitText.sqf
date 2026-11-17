// Fit text after responsive reflow, rather than retaining its old viewport size.
disableSerialization;
params [["_display",displayNull]];
if (isNull _display) exitWith {};
private _small=_display==findDisplay 87000 && {SICS_deviceMode in ["PHONE","PORTABLE"]};
{
    private _text=ctrlText _x;
    if (ctrlType _x in [0,1,16] && {_text!=""} && {_text select [0,1]!="#"} && {_text find ".paa"<0} && {_text find ".png"<0}) then {
        private _r=ctrlPosition _x;
        private _font=pixelH*([22,18] select _small)*(missionNamespace getVariable ["ATLAS_textScale",1]);
        private _single=(_r select 3)<pixelH*40 && {_text find (toString [10])<0} && {_text find "\n"<0};
        if (_single) then {
            _font=_font min ((_r select 3)*0.75);
            private _estimate=count _text*_font*0.44*pixelW/pixelH;
            if (_estimate>0) then {_font=_font min (_font*(((_r select 2)-pixelW*8) max pixelW)/_estimate)};
        };
        _x ctrlSetFontHeight (_font max (pixelH*9));
        if (!_single) then {
            for "_step" from 1 to 6 do {
                if (ctrlTextHeight _x>(_r select 3) && {_font>pixelH*11}) then {_font=_font*0.88;_x ctrlSetFontHeight _font};
            };
        };
        if (ctrlTooltip _x=="" || {_x getVariable ["ATLAS_autoTooltip",false]}) then {_x ctrlSetTooltip _text;_x setVariable ["ATLAS_autoTooltip",true]};
    };
} forEach allControls _display;
