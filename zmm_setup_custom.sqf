// Waits for a custom location to be selected by a player - ZM_Mode == 0
if !isServer exitWith {};

// Remind the players if nothing has been selected.
[] spawn {
	waitUntil {time > 5};
	if (isNil "ZMM_targetPicked") then {
		["INFO", "The Commander must choose an Objective location! (Press M)"] call zmm_fnc_logMsg;
	};
};

// Wait for Location Selection.
waitUntil {!isNil "ZMM_targetPicked"};

// Remove click action for all players.
"" remoteExec ["onMapSingleClick"];
		
_centre = ZMM_targetLocation;
_centre set [2,0];

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
	
// Disable any far-away zones
{	
	if (_x distance2D _centre > 2000) then {
		//_marker = [allMapMarkers, _x] call BIS_fnc_nearestPosition;
		//_marker setMarkerColor "ColorGrey";
		_x enableSimulationGlobal false;
	};
} forEach allMissionObjects "EmptyDetector";

_forceMission = "";

if (!isNil "ZMM_MissionChoice") then {
	_forceMission = ZMM_MissionChoice;
	missionNamespace setVariable ["ZMM_MissionChoice", "", true];
};

[_centre, _locType, _locRadius, _locName, _locType, _forceMission] spawn zmm_fnc_setupZone;