// zmm_fnc_misc_findEnemySide
params [
	["_nearPos", [0,0,0]],
	["_inDist", 2000],
	["_markerList",missionNamespace getVariable ["ZMM_LocationMarkerList",[]]]
];

private _foundSide = missionNamespace getVariable ["ZAU_Side", CIVILIAN];
if (_foundSide != CIVILIAN) exitWith { _foundSide };

["DEBUG", format["Find Side - Checking %1 within %2", _nearPos, _inDist]] call zmm_fnc_misc_logMsg;

// This will most often be called in ZMM so 
if (count _markerList == 0) then { _markerList = allMapMarkers };
if (isNil "ZMM_enemySides") then { ZMM_enemySides = [WEST, EAST, INDEPENDENT] - ((switchableUnits + playableUnits) apply { side group _x }) };

private _sideColors = ZMM_enemySides apply { toUpper format["Color%1", _x] };
	
// Check marker colours to match on.
[([
	_markerList select {
		toUpper (getMarkerColor _x) in _sideColors && 
		getMarkerPos _x distance2D _nearPos < _inDist
	},
	[],
	{ _nearPos distance2D getMarkerPos _x },
	"ASCEND"
] call BIS_fnc_sortBy) select 0] params [["_nearMarker",""]];

// Found markers so find the nearest
if (_nearMarker != "") then {
	_foundSide = switch (toUpper (getMarkerColor _nearMarker)) do { case "COLORWEST": { WEST }; case "COLOREAST": { EAST }; default { INDEPENDENT }; };
};

if (_foundSide in ZMM_enemySides) exitWith { _foundSide };

// Find near entities to get side.
[side (([
	allGroups select {
		leader _x distance2D _nearPos < _inDist &&
		side _x in ZMM_enemySides
	},
	[],
	{ leader _x distance2D _nearPos },
	"ASCEND"
] call BIS_fnc_sortBy) select 0)] params [["_groupSide", CIVILIAN]];

if (_groupSide in ZMM_enemySides) exitWith { _groupSide };

selectRandom ZMM_enemySides