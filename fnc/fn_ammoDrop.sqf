params [["_firstPos",[0,0,0],[[]]], ["_dropSide", west, [west]], ["_crateNo",0,[0]]];

_dropPos = _firstPos findEmptyPosition [1,10];

private _dropBox = createVehicle ["IG_supplyCrate_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_dropBox setPos [_dropPos select 0, _dropPos select 1, 300];

_dropPChute = createVehicle ["I_Parachute_02_F", position _dropBox, [], 0, "CAN_COLLIDE"];
_dropBox attachTo [_dropPChute, [0, 0, -0.5]];

sleep 1; 

// Fill Box
[selectRandom tg_dropType, _dropBox, _dropSide] call f_fnc_assignGear;

if (_crateNo > 0) then {  [_firstPos, _dropSide, _crateNo - 1] spawn tg_fnc_ammoDrop; };

waitUntil{ sleep 1; getPosATL _dropBox select 2 < 4; };

detach _dropBox;
sleep 1;

deleteVehicle _dropPChute;