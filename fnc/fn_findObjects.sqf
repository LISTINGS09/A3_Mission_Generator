// Finds designated objects in an area.
//
// *** PARAMETERS ***
// _searchPos	ARRAY		Position to search around.
//	_inDist		INT			Distance to search around.
// _classNames	STRING		Arma Location types to search for
// _returnOne	BOOLEAN		Skip any Blacklist/Safe Zone checking.
//
// *** RETURNS ***
// Array with matched object(s)
//
// *** USAGE ***
// [[0,0,0], 5000, ["Land_Warehouse_03_F"], false] call tg_fnc_findWorldLocation;

params [["_searchPos", [], [[]]], ["_inDist", 500, [500]], ["_classNames", [], [[], ""]], ["_returnOne", true, [true]]];

private _objects = [];

// Convert to an array if required.
if (_classNames isEqualType "") then {
	_classNames = [_classNames];
};

_objects = nearestObjects [_searchPos, _classNames, _inDist];  

[format ["[TG] DEBUG (findObjects) - Found %1 of %2", count _objects, _classNames]] call tg_fnc_debugMsg;

if (count _objects == 0) exitWith { [] };

if (_returnOne) exitWith { [selectRandom _objects]; };

_objects