params [["_nearPos", [], [[]]], ["_inDist", 1000, [1000]]];

_pickedSide = [];
_sideArray = [west, east, independent] - [tg_playerSide]; // Remove the players side from the side selection.
_wasForced = false;

// If another side is already nearby, use that side to prevent fights.
if !(_nearPos isEqualTo []) then {
	{
		if (side _x in _sideArray) exitWith {
			_sideArray = [side _x];
			_wasForced = true;
		};
	} forEach (_nearPos nearEntities [["Man", "Air", "Car", "Tank"], _inDist]);
};

// Select a side to use.
switch (selectRandom _sideArray) do {
	case east: { _pickedSide = tg_sideEast; };
	case independent: { _pickedSide = tg_sideGuer; };
	case default { _pickedSide = tg_sideWest; }; // FIA
};

_pickedSide = selectRandom _pickedSide;

//[format["[TG] fn_findSide: AI-%1 (Forced: %2)", _pickedSide, _wasForced]] call tg_fnc_debugMsg;

_pickedSide


