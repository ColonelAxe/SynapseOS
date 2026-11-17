// Eden terminal object init, on every client and server:
[this, west, "TOC ATLAS"] call SICS_fnc_registerTOC;

// In a separate playable commander's init field:
// this addItem "ItemcTab";
// this setVariable ["SICS_commander",true,true];
// group this setGroupIdGlobal ["ATLAS 6"];

// A TOC is any room with one or more registered objects. Personal cTab
// devices continue to work away from the terminal. Object access is side
// restricted and range checked again on the server for each transmission.
