// Picks a fixed location but allows objective to be selected by a player - ZM_Mode == 2
if !isServer exitWith {};
		
_centre = getPos nearestBuilding (locationPosition (selectRandom ((nearestLocations [[worldSize / 2, worldSize / 2, 0], ["NameCity","NameVillage"],15000]) - (nearestLocations [getMarkerPos format["respawn_%1",ZMM_playerSide], ["NameCity","NameVillage"],1000])))); // Find a Home

_nearLoc = (nearestLocations [_centre, ["Airport", "NameCityCapital", "NameCity", "NameVillage", "NameLocal"], 10000, _centre])#0;
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
	
_centre = position _nearLoc;
	
_mkr = createMarker ["loc_mkr", _centre];
_mkr setMarkerShape "ICON";
_mkr setMarkerColor "ColorBlack";
_mkr setMarkerType "mil_circle";

waitUntil { (!isNil "ZMM_MissionChoice" || time > 1) };

_forceMission = "";

if (!isNil "ZMM_MissionChoice") then { _forceMission = ZMM_MissionChoice };

[_centre, _locType, _locRadius, _locName, _locType, _forceMission] spawn zmm_fnc_setupZone;

