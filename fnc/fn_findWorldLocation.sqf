// Finds a free area on the map, not in a blacklisted area.
//
// *** PARAMETERS ***
// _searchPos	ARRAY			Position to search around.
// _findType	STRING/ARRAY	Arma Location types to search for (NameCityCapital, NameCity, NameVillage, NameMarine, NameLocal, Airport etc)
//	_maxDist	INT			
// _skipSafe	BOOLEAN			Skip any Blacklist/Safe Zone checking.
//
// *** RETURNS ***
// Position Array
//
// *** USAGE ***
// [[0,0,0], "NameVillage", 5000] call tg_fnc_findWorldLocation;

params [["_searchPos",[],[[]]], ["_findType",["NameCityCapital","NameCity","NameVillage","NameLocal"],["",[]]], ["_maxDist", 10000, [10000]], ["_skipSafe", false, [false]]];

//[format ["[TG] DEBUG - findWorldLocation: Called (Pos: %1, Types: %2, Max: %3, Skip: %4)", _searchPos, _findType,  _maxDist, _skipSafe]] call tg_fnc_debugMsg;

if (_findType isEqualType "") then { _findType = [_findType]; };

// If no position was passed, use world centre
if (_searchPos isEqualTo []) then {
	_searchPos = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
	//[format ["[TG] DEBUG - findWorldLocation: Using %1 centrePosition: %2", worldName, _searchPos]] call tg_fnc_debugMsg;
};

_nearLocs = nearestLocations [_searchPos, _findType, _maxDist];

//[format ["[TG-findWorldLocation] DEBUG: Found %1 locations", count _nearLocs]] call tg_fnc_debugMsg;

_foundPos = [];

if (count _nearLocs > 0) then {
	// Pull off each location randomly and check if it's usable.
	{
		_foundPos = getPos (selectRandom _nearLocs);
		
		/*if tg_debug then {
			_tmpMkr = createMarkerLocal[format["NearLoc_%1%2", _forEachIndex, ceil random 500], _foundPos];
			_tmpMkr setMarkerShapeLocal "ICON";
			_tmpMkr setMarkerColorLocal "colorGrey";
			_tmpMkr setMarkerSizeLocal [0.5,0.5];
			_tmpMkr setMarkerTypeLocal "mil_dot";
		};*/
		
		_nearLocs = _nearLocs - [_foundPos];
		
		// Exit if position was not in safeZone.
		if (!([_foundPos] call tg_fnc_inSafeZone) || _skipSafe) exitWith {
			//[format["[TG-findWorldLocation] DEBUG: %1 is not in a Safe Zone (Skip: %2)", _foundPos, _skipSafe]] call tg_fnc_debugMsg;
		};
			
		// Exit if we've run out of locations.
		if (count _nearLocs == 0) exitWith { 
			_foundPos = []; 
			//["[TG] DEBUG - findWorldLocation: Emptied array, aborting"] call tg_fnc_debugMsg;
		};
		
		//[format["[TG-findWorldLocation] DEBUG: Scanning location, retrying %1 remain", count _nearLocs]] call tg_fnc_debugMsg;
	} forEach _nearLocs;
};

if (_foundPos isEqualTo []) exitWith {
	// No suitable locations found at all, give up and try to find an empty position nearby.
	_foundPos = [_searchPos] call tg_fnc_findRandomEmpty;
	
	_foundPos
};

//[format ["[TG] DEBUG - findWorldLocation: Returning %1", _foundPos]] call tg_fnc_debugMsg;

/*if tg_debug then {
	_tmpMkr = createMarkerLocal[format["markerEmptyByType_%1", ceil random 100000], _emptyPos];
	_tmpMkr setMarkerTextLocal "WorldLocation";
	_tmpMkr setMarkerShapeLocal "ICON";
	_tmpMkr setMarkerColorLocal "colorRed";
	_tmpMkr setMarkerSizeLocal [0.5,0.5];
	_tmpMkr setMarkerTypeLocal "mil_circle";
};*/

_foundPos