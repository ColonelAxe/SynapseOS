// Available engine/mod NATO icons, not a hard-coded partial list.
params ["_affiliation"];
private _prefix=([_affiliation] call SICS_fnc_affiliation) select 0;
("getNumber (_x >> 'scope') > 0 && {getText (_x >> 'icon') != ''}" configClasses (configFile >> "CfgMarkers")) select {
    private _name=toLower configName _x;
    private _class=toLower getText(_x >> "markerClass");
    (_name select [0,2])==_prefix || {!((_name select [0,2]) in ["b_","o_","n_"]) && {_class find "nato">=0}}
}

