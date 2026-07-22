params [
	["_nearPos", [0,0,0]],
	["_inDist", 2000],
	["_markerList",missionNamespace getVariable ["ZMM_LocationMarkerList",[]]]
];

private _foundSide = missionNamespace getVariable ["ZAU_Side", CIVILIAN];
private _distance = 0;

if (_foundSide != CIVILIAN) exitWith { 
	["DEBUG", format["Found Side by Variable - %1", _foundSide]] call zmm_fnc_misc_logMsg;
	_foundSide 
};

//["DEBUG", format["Find Side - Checking %1 within %2", _nearPos, _inDist]] call zmm_fnc_misc_logMsg;

// This will most often be called in ZMM so 
if (count _markerList == 0) then { _markerList = allMapMarkers };
if (isNil "ZMM_enemySides") then { ZMM_enemySides = [WEST, EAST, INDEPENDENT] - ((switchableUnits + playableUnits) apply { side group _x }) };

private _sideColors = ZMM_enemySides apply { toUpper format["Color%1", _x] };
	
// Check marker colours to match on.
private _sortedMarkers = [
    _markerList select {
        toUpper (getMarkerColor _x) in _sideColors &&
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
        side _x in ZMM_enemySides
    },
    [],
    { leader _x distance2D _nearPos },
    "ASCEND"
] call BIS_fnc_sortBy;

private _group = _sortedGroups param [0, grpNull];

if ((side _group) in ZMM_enemySides) exitWith { 
	_foundSide = side _group;
	_distance = (getPos (leader _group)) distance2D _nearPos;
	["DEBUG", format["Found Side by Group - %1 distance %2m", _foundSide, _distance]] call zmm_fnc_misc_logMsg;
	_foundSide
};

_foundSide = selectRandom ZMM_enemySides;
["DEBUG", format["Found Side by Random - %1", _foundSide]] call zmm_fnc_misc_logMsg;
_foundSide