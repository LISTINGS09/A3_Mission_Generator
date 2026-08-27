// [getPos player] call zmm_fnc_misc_findEnemySide;
params [
	["_nearPos", [0,0,0]],
	["_inDist", 3000],
	["_markerList",missionNamespace getVariable ["ZMM_LocationMarkerList",[]]]
];

private _foundSide = missionNamespace getVariable ["ZAU_Side", CIVILIAN];
private _distance = 0;

if (_foundSide != CIVILIAN) exitWith { 
	["DEBUG", format["Found Side by Variable - %1", _foundSide]] call zmm_fnc_misc_logMsg;
	_foundSide 
};

//["DEBUG", format["Find Side - Checking %1 within %2", _nearPos, _inDist]] call zmm_fnc_misc_logMsg;
private _sidePlayers = ((allGroups select {isPlayer leader _x} apply {side _x}) arrayIntersect (allGroups select {isPlayer leader _x} apply {side _x})) select {_x in [WEST, EAST, INDEPENDENT]};
private _sideOnMap = ((allGroups apply {side _x}) arrayIntersect (allGroups apply {side _x})) select {_x in [WEST, EAST, INDEPENDENT] && !(_x in _sidePlayers)};
private _sideVars = [EAST, WEST, INDEPENDENT] select { missionNamespace getVariable [format["ZMM_%1_Man", _x], []] isNotEqualTo [] && !(_x in _sidePlayers) };

// Only have one varaible defined, one enemy side on map so use that side.
if (count _sideVars == 1 && count _sideOnMap == 1 && (_sideVars#0) == (_sideOnMap#0)) exitWith {
	_foundSide = _sideVars#0;
	["DEBUG", format["Found Side by Logic - %1", _foundSide]] call zmm_fnc_misc_logMsg;
	_foundSide
};

// This will most often be called in ZMM so 
if (count _markerList == 0) then { _markerList = allMapMarkers };

private _enemySides = [WEST, EAST, INDEPENDENT] - _sidePlayers;
private _enemyColors = _enemySides apply { toUpper format ["Color%1", _x] };

if (_enemySides isEqualTo []) exitWith {
	["ERROR", "No enemy sides available - Set 'ZAU_Side' variable to override"] call zmm_fnc_misc_logMsg;
	CIVILIAN
};

// Check marker colours to match on.
private _sortedMarkers = [
	_markerList select {
		toUpper (getMarkerColor _x) in _enemyColors &&
		getMarkerPos _x distance2D _nearPos < _inDist
	},
	[],
	{ _nearPos distance2D getMarkerPos _x },
	"ASCEND"
] call BIS_fnc_sortBy;

private _nearMarker = _sortedMarkers param [0, ""];

// Found markers so find the nearest
if (_nearMarker != "") exitWith {
	_distance = getMarkerPos _nearMarker distance2D _nearPos;
	_foundSide = switch (toUpper (getMarkerColor _nearMarker)) do { case "COLORWEST": { WEST }; case "COLOREAST": { EAST }; default { INDEPENDENT }; };
	["DEBUG", format["Found Side by Marker - %1 distance %2m", _foundSide, _distance]] call zmm_fnc_misc_logMsg;
	_foundSide
};

// Find near entities to get side.
private _sortedGroups = [
	allGroups select {
		leader _x distance2D _nearPos < _inDist &&
		side _x in _enemySides
	},
	[],
	{ leader _x distance2D _nearPos },
	"ASCEND"
] call BIS_fnc_sortBy;

private _group = _sortedGroups param [0, grpNull];

if ((side _group) in _enemySides) exitWith { 
	_foundSide = side _group;
	_distance = (getPos (leader _group)) distance2D _nearPos;
	["DEBUG", format["Found Side by Group - %1 distance %2m", _foundSide, _distance]] call zmm_fnc_misc_logMsg;
	_foundSide
};

_foundSide = selectRandom _enemySides;
["DEBUG", format["Found Side by Random - %1", _foundSide]] call zmm_fnc_misc_logMsg;
_foundSide