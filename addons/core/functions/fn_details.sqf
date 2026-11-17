disableSerialization;
private _d=findDisplay 87000;
if (isNull _d || {isNull (_d displayCtrl 221)}) exitWith {};
private _u=missionNamespace getVariable ["SICS_selectedUnit",player];
if (isNull _u) then {_u=player};
private _g=group _u;
private _alive={alive _x} count units _g;
private _total=count units _g;
private _type=getText(configOf vehicle _u >> "displayName");
(_d displayCtrl 221) ctrlSetText format ["%1\n%2\n%3",groupId _g,_type,side _g];
private _text=switch (missionNamespace getVariable ["SICS_detailTab","OVERVIEW"]) do {
    case "TEAM": {(units _g apply {format ["%1 / %2",name _x,["CASUALTY","READY"] select alive _x]}) joinString "\n"};
    case "ROLE": {format ["ELEMENT TYPE\n%1\n\nCOMMAND\n%2\n\nNET\nSide-wide and group-targeted data",_type,name leader _g]};
    case "STATUS": {format ["STATE   %1\n\nSTRENGTH   %2 / %3\n\nSPEED   %4 km/h\n\nGRID   %5",["INACTIVE","READY"] select alive _u,_alive,_total,round speed vehicle _u,mapGridPosition _u]};
    default {format ["PERSONNEL   %1 / %2\n\nCALLSIGN   %3\n\nGRID   %4\n\nMOVEMENT   %5\n\nCOMMANDER   %6",_alive,_total,groupId _g,mapGridPosition _u,["STATIONARY","MOVING"] select (abs speed vehicle _u > 1),name leader _g]};
};
// Edit controls scroll long details but require real newline characters.
private _displayText="";private _break=_text find "\n";
while {_break>=0} do {_displayText=_displayText+(_text select [0,_break])+toString [10];_text=_text select [_break+2];_break=_text find "\n"};
(_d displayCtrl 240) ctrlSetText (_displayText+_text);

