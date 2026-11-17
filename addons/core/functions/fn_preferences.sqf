// Local presentation preferences only; never change mission permissions.
params [["_key",""],["_value",true]];
private _defaults=[true,true,1,true,true];
private _saved=profileNamespace getVariable ["ATLAS_preferences",_defaults];
if !(_saved isEqualType [] && {count _saved==5}) then {_saved=+_defaults};
{if !((_saved select _forEachIndex) isEqualType _x) then {_saved set [_forEachIndex,_x]}} forEach _defaults;
if !((_saved select 2) in [0.9,1,1.15]) then {_saved set [2,1]};
private _index=["voice","banners","text","trails","labels"] find _key;
if (_index>=0) then {
    if (_value isEqualType (_defaults select _index) && {_index!=2 || {_value in [0.9,1,1.15]}}) then {
        _saved set [_index,_value];profileNamespace setVariable ["ATLAS_preferences",_saved];saveProfileNamespace;
    };
};
ATLAS_voiceEnabled=_saved select 0;ATLAS_bannersEnabled=_saved select 1;ATLAS_textScale=_saved select 2;
ATLAS_showTrails=_saved select 3;ATLAS_showTrackLabels=_saved select 4;
+_saved
