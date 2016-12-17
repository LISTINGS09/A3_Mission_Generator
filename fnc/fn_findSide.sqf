params [["_nearPos",[],[[]]]];

_pickedSide = [];
_sideArray = [west, east, independent] - [tg_playerSide];

// If another side is already nearby, use that side to prevent fights.
if !(count _nearPos isEqualTo []) then {
	_nearEnts = _nearPos nearEntities ["Man", 500];
	[format["[TG-findSide] DEBUG: %1 nearby units found", count _nearEnts]] call tg_fnc_debugMsg;
	
	{
		if (side _x in _sideArray) exitWith {
			_sideArray = [side _x];
			[format["[TG-findSide] DEBUG: side %1 forced", _sideArray]] call tg_fnc_debugMsg;
		};
	} forEach _nearEnts;
};

// Select a side to use.
switch (selectRandom _sideArray) do {
	case west: { _pickedSide = [west, [1, 1, 1, (selectRandom [1, 5, 9])]]; };
	case east: { _pickedSide = [east, [0, 0, 0, (selectRandom [0, 4, 8])]]; };
	case independent: { _pickedSide = [independent, [2, 2, 2, (selectRandom [2, 6, 10])]]; };
	case default { _pickedSide = [west, [1, 1, 1, (selectRandom [3, 7, 11])]]; }; // FIA
};

[format["[TG-findSide] DEBUG: Picked %1", _pickedSide]] call tg_fnc_debugMsg;

_pickedSide


