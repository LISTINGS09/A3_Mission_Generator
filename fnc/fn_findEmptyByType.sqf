// Finds an empty position nearby a location the size of _type.
// Defaults to a random empty area if position not provided.
//
// *** PARAMETERS ***
// _searchPos	ARRAY		Position to search around.
// _minDist		INT		
// _maxDist		INT
// _type		STRING
//
// *** RETURNS ***
// Position Array

params [["_searchPos", [], [[]]], ["_minDist", 100, [100]], ["_maxDist", 500, [500]], ["_type", "B_Heli_Transport_01_F", [""]]];

[format ["[TG-findEmptyType] DEBUG: Called (Pos: %1, Min: %2, Max: %3, Type: %4)", _searchPos, _minDist, _maxDist, _type]] call tg_fnc_debugMsg;

if !(isClass (configFile >> "cfgVehicles" >> _type)) then {
	[format ["[TG-findEmptyType] ERROR: Invalid vehicle type: %1", _type]] call tg_fnc_debugMsg;
	_type = "B_Soldier_F";
};

// If no position was passed, use world centre
if (_searchPos isEqualTo []) then {
	_searchPos = [] call tg_fnc_findWorldLocation;
};

_emptyPos = _searchPos findEmptyPosition [_minDist, _maxDist, _type];

if (_emptyPos isEqualTo []) exitWith {
	["[TG-findEmptyType] DEBUG: No suitable position found, calling tg_fn_findRandomEmpty"] call tg_fnc_debugMsg;
	_emptyPos = [] call tg_fnc_findRandomEmpty;
	
	_emptyPos
};

[format ["[TG-findEmptyType] DEBUG: Returning %1", _emptyPos]] call tg_fnc_debugMsg;

/*if tg_debug then {
	_tmpMkr = createMarkerLocal[format["markerEmptyByType_%1", ceil random 100000], _emptyPos];
	_tmpMkr setMarkerTextLocal "EmptyByType";
	_tmpMkr setMarkerShapeLocal "ICON";
	_tmpMkr setMarkerColorLocal "colorBlue";
	_tmpMkr setMarkerSizeLocal [0.5,0.5];
	_tmpMkr setMarkerTypeLocal "mil_circle";
};*/

_emptyPos