// Radio possession is a status adapter, not a propagation or encryption model.
params ["_unit"];
private _status = "LOCAL DATA";
if (!isNil "TFAR_fnc_haveSWRadio") then {
    if (call TFAR_fnc_haveSWRadio || {call TFAR_fnc_haveLRRadio}) then {_status = "TFAR / RADIO PRESENT"} else {_status = "TFAR / NO RADIO"};
};
if (!isNil "acre_api_fnc_getCurrentRadioList") then {
    _status = ["ACRE / NO RADIO","ACRE / RADIO PRESENT"] select (count ([] call acre_api_fnc_getCurrentRadioList) > 0);
};
_status

