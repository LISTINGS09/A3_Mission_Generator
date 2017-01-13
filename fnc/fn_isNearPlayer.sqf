// Checks if a playable unit is within distance '_inDist' of the position '_nearPos'.
// Used to prevent objectives from appearing where players are already present.

params [["_nearPos", [], [[]]], ["_inDist", 2000, [2000]]];

_isNear = false;

// Loop through all player units to see if they're near.
{
	if (alive _x && _nearPos distance2D _x < _inDist) exitWith {
		_isNear = true;
	};
} forEach playableUnits + switchableUnits;

//[format["[TG] fn_isNearPlayer: %1", _isNear]] call tg_fnc_debugMsg;

_isNear