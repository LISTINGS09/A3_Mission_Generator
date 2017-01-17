// Nearest Positions - SPUn / LostVar / 2600K
// Returns array of building pos's
// USAGE: _bPos = [[0, 0, 0], 250] call tg_fnc_nearestBuilding;
params ["_findPos", ["_radius", 100, [1]]];

if (_findPos in allMapMarkers) then {
	_findPos = getMarkerPos _findPos;
} else {
	if (_findPos isEqualType []) then{
		_findPos = _findPos;
	} else {
		_findPos = getPos _findPos;
	};
};

private _buildingPositions = [];

private _houseObjects = nearestObjects [_findPos, ["building"], _radius];

if (isNil "_houseObjects") exitWith { _buildingPositions };
if ((count _houseObjects) == 0) exitWith { _buildingPositions };

{
	if( str (_x buildingPos 0) != "[0,0,0]") then {
		_buildingPositions append (_x buildingPos -1);
	};
} forEach _houseObjects;

_buildingPositions

