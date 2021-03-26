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
		
private _centre = ZMM_targetLocation;
_centre set [2,0];

private _nearLocs = nearestLocations [_centre, ["Airport", "NameCityCapital", "NameCity", "NameVillage", "NameLocal"], 10000, _centre];
private _locName = "This Location";
private _locType = "Custom";
private _locRadius = 300 * 0.75;

if (count _nearLocs > 0) then {
	private _location = _nearLocs#0;
	 if (getPos _location distance2D _centre < 200) then {
		_locName = text _location;
		_locType = type _location;
		_locRadius = 300 * (switch (_locType) do { case "Airport": { 1.5 }; case "NameCityCapital": { 1.25 }; case "NameCity": { 1 }; case "NameVillage": { 0.75 }; case "NameLocal": { 0.75 }; default { 0.75 }; });
	};
};
	
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