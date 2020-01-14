// Picks a fixed location but allows objective to be selected by a player - ZM_Mode == 2
if !isServer exitWith {};

_locations = nearestLocations [[worldSize / 2, worldSize / 2, 0], ["NameCity","NameVillage"],15000];
_centre = getPos nearestBuilding (locationPosition (selectRandom (_locations - (_locations select { _tempLoc = _x; (allMapMarkers select { (toUpper _x) find "SAFEZONE" >= 0 }) findIf { position _tempLoc inArea _x } >= 0 }))));

// VR Fix
if (isNil "_centre") then { _centre = [0,0,0] };

_nearLoc = (nearestLocations [_centre, ["Airport", "NameCityCapital", "NameCity", "NameVillage", "NameLocal"], 10000, _centre])#0;

// VR Fix
if (isNil "_nearLoc") then {
	_nearLoc = createLocation [ "NameCity" , _centre, 15, 15];
	_nearLoc setText "Custom City";
};

_locName = if (getPos _nearLoc distance2D _centre < 200) then { text _nearLoc } else { "This Location" };
_locType = if (getPos _nearLoc distance2D _centre < 200) then { type _nearLoc } else { "Custom" };
_locRadius = 300 * (if (getPos _nearLoc distance2D _centre < 200) then { 
		switch (_locType) do {
			case "Airport": { 1.5 };
			case "NameCityCapital": { 1.25 };
			case "NameCity": { 1 };
			case "NameVillage": { 0.75 };
			case "NameLocal": { 0.75 };
			default { 0.75 };
		};
	} else { 0.75 });
	
// Disable any far-away zones
{	
	if (_x distance2D _centre > 2000) then {
		//_marker = [allMapMarkers, _x] call BIS_fnc_nearestPosition;
		//_marker setMarkerColor "ColorGrey";
		_x enableSimulationGlobal false;
	};
} forEach allMissionObjects "EmptyDetector";
	
_centre = position _nearLoc;
	
_mkr = createMarker ["loc_mkr", _centre];
_mkr setMarkerShape "ICON";
_mkr setMarkerColor "ColorBlack";
_mkr setMarkerType "mil_circle";

waitUntil { (!isNil "ZMM_MissionChoice" || time > 1) };

[_centre, _locType, _locRadius, _locName, _locType, missionNamespace getVariable "ZMM_MissionChoice"] spawn zmm_fnc_setupZone;

