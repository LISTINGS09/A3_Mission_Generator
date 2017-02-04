params [["_nearPos", [], [[]]], ["_inDist", 1000, [1000]]];

private _pickedSide = [];
private _sideArray = [west, east, independent] - [tg_playerSide]; // Remove the players side from the side selection.
private _reason = "Random";

if (count tg_sideWest == 0) then { _sideArray = _sideArray - [west]; };
if (count tg_sideEast == 0) then { _sideArray = _sideArray - [east]; };
if (count tg_sideGuer == 0) then { _sideArray = _sideArray - [independent]; };

// If another side is already nearby, use that side to prevent fights.
if !(_nearPos isEqualTo []) then {
	{
		if (side _x in _sideArray) exitWith {
			_sideArray = [side _x];
			_reason = "Entity";
		};
	} forEach (_nearPos nearEntities [["Man", "Air", "Car", "Tank"], _inDist]);
};

// If no match, build a list of allowed Marker colours to match on.
if (_reason isEqualTo "Random") then {
	private _colorArray = [];
	private _colorSide = [];
	private _nearDist = _inDist;
	{
		_colorArray pushBack ([_x, true] call BIS_fnc_sideColor);
		_colorSide pushBack _x;
	} forEach _sideArray;

	// Iterate the markers and if one is close and matches a side color, use that side.
	// Only matches if the distance was less than the previous check.
	{	
		if ((getMarkerPos _x) distance2D _nearPos < _nearDist) then {
			private _findIndex = _colorArray find (getMarkerColor _x);
			if (_findIndex >= 0) then {
				_nearDist = (getMarkerPos _x) distance2D _nearPos;
				_sideArray = [_colorSide select _findIndex];
				_reason = "Marker";
			};
		};
	} forEach allMapMarkers;
};

// Select a side to use.
switch (selectRandom _sideArray) do {
	case east: { _pickedSide = selectRandom tg_sideEast; };
	case independent: { _pickedSide = selectRandom tg_sideGuer; };
	case default { _pickedSide = selectRandom tg_sideWest; };
};

//[format["[TG] fn_findSide: AI-%1 (%2)", _pickedSide, _reason]] call tg_fnc_debugMsg;

_pickedSide


