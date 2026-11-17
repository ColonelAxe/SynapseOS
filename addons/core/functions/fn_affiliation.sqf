params ["_affiliation"];
switch (_affiliation) do {
    case "BLUFOR": {["b_","ColorBlue","BLUFOR",[0.25,0.65,1,1]]};
    case "OPFOR": {["o_","ColorRed","OPFOR",[1,0.25,0.25,1]]};
    case "INDEPENDENT": {["n_","ColorGreen","INDEPENDENT",[0.25,0.85,0.4,1]]};
    case "CIVILIAN": {["n_","SICS_Civilian","CIVILIAN",[0.69,0.43,0.85,1]]};
    default {["n_","ColorYellow","UNKNOWN",[1,0.85,0.15,1]]};
};

