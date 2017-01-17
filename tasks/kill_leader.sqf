// Test Mission
params [["_missionType", (tg_missionTypes select 0), [""]], ["_missionName", "", [""]]];

// ----------- PREP ---------------
// Make sure missionType is valid.
if (!(_missionType in tg_missionTypes) || _missionName == "") exitWith {
	["[TG-%1] ERROR: Invalid mission: %2", _missionName, _missionType] call tg_fnc_debugMsg;
	false
};

// Set-up mission variables.
private _missionTitle = format["%1: %2", (["Side","Main"] select (_missionType == "mainMission")), [] call tg_fnc_nameGenerator];
private _missionDesc = [
		"Locate and eliminate an HVT nearby the marked location.",
		"An Officer has been spotted entering the area, they must be eliminated.",
		"There is an enemy HVT awaiting extraction from this location, they must be eliminated.",
		"Find and eliminate the Officer hiding somewhere around the area.",
		"A HVT has been seen moving around the area, find them and kill them.",
		"A high-ranking Officer is confirmed to be in the area, ensure they are eliminated."
	];	
private _missionSize = if (_missionType != tg_missionTypes select 0) then {200} else {600};
private _isMainMission = if (_missionType == tg_missionTypes select 0) then {true} else {false};
private _missionCounter = tg_counter;

// ----------- POSITION ---------------
// Loop to check if no players are nearby the area.
private _locAttempt = 0; 
private _maxAttempt = 10; 
private _missionPos = [];
private _locType = if !_isMainMission then {"village"} else {"city"};

while {_locAttempt < _maxAttempt} do {
	// Pick a random location from a random marker.
	private _tempPos = [([_missionType] call tg_fnc_findRandomMarker), _locType, 5000] call tg_fnc_findWorldLocation;
	
	// Validate position
	private _closePlayer = [_tempPos, 2000] call tg_fnc_isNearPlayer;
	private _closeMission = [_tempPos] call tg_fnc_isNearMission;

	// Ensure the mission does not spawn near a player or near another mission of the same type.
	if (!_closePlayer && !_closeMission) exitWith {
		_missionPos = _tempPos;
	};
	
	_locAttempt = _locAttempt + 1;
	[format["[TG-%1] DEBUG: Near %3%4 - Retrying %5/%6", _missionName, _tempPos, ["","Player "] select _closePlayer, ["","Mission "] select _closeMission, _locAttempt, _maxAttempt]] call tg_fnc_debugMsg;
};

// No valid location found, abort the mission!
if (count _missionPos != 3 || _missionPos isEqualTo [0,0,0]) exitWith { false };

// Place the marker on a nearby road.
private _roadList = _missionPos nearRoads 200;

// If a road is found, put the new location there.
if (count _roadList > 0) then {
	_missionPos = getPosASL (selectRandom _roadList);
};

// Get nearby buildings.
private _bPos = [_missionPos, 150] call tg_fnc_nearestBuilding;

// If none are enter-able, abandon the mission.
if (count _bPos == 0) exitWith { false };

// ----------- SIDE ---------------
// Check if another mission is active nearby to force a side.
private _missionSide = [_missionPos] call tg_fnc_findSide;

// ----------- OBJECTIVE ---------------
// Create the marker
private _hvtMarker = createMarker[format["%1_marker", _missionName], _missionPos];
_hvtMarker setMarkerShape "ICON";
_hvtMarker setMarkerText _missionName;
_hvtMarker setMarkerColor ([_missionSide select 0, true] call BIS_fnc_sideColor);
_hvtMarker setMarkerSize [1,1];
_hvtMarker setMarkerType "mil_unknown";

// Create Objective
private _hvtGroup = createGroup (_missionSide select 0);
private _hvtPos = selectRandom _bPos;
private _hvt = _hvtGroup createUnit [_missionSide select 2, _hvtPos, [], 0, "NONE"];

missionNamespace setVariable [format["%1_HVT", _missionName], _hvt];
	
// Set HVT Post and give him a nice hat.	
_hvt setPosATL _hvtPos;	
_hvt addHeadgear "H_Beret_blk";
	
// Create Task
private _missionTask = [format["%1_task", _missionName], true, [selectRandom _missionDesc, _missionTitle, ""], _missionPos, "CREATED", 1, true, true, "kill"] call BIS_fnc_setTask;
missionNamespace setVariable [format["%1_task", _missionName], _missionTask];

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_objTrigger setTriggerTimeout [3, 3, 3, false];
_objTrigger setTriggerStatements [ 	format["!alive %1_HVT",_missionName], 
									format["['%1', '%2', true] spawn tg_fnc_missionEnd; '%1_marker' setMarkerColor 'ColorGrey'; [] spawn { sleep 30; deleteMarker '%1_marker'; };", _missionName, _missionType], 
									"" ];

// ----------- OTHER ---------------
// DAC = [UnitCount, UnitSize, WaypointPool, WaypointsGiven]
private _DACinfantry = [([8, "light", _missionType] call tg_fnc_balanceUnits), if _isMainMission then {3} else {2}, 15, 5];
private _DACvehicles = [([3, "medium", _missionType] call tg_fnc_balanceUnits), 2, 10, 6];
private _DACarmour = [([1, "heavy", _missionType] call tg_fnc_balanceUnits), 1, 8, 4];

// If unit count is 0 clear the array.
if (_DACvehicles select 0 == 0) then { _DACvehicles = []; }; 
if (_DACarmour select 0 == 0) then { _DACarmour = []; }; 

// Set DAC Behaviour to garrison Buildings for a long time.
private _DACside = _missionSide select 1;
_DACside set [2,6];

_DACZoneList = [
	// Spawn an inner infantry-only Sentry Zone
	[
		_missionSide select 0,
		_missionName,
		"sentryZone",
		_missionPos,
		100,
		[[_missionCounter, 1, 0], [random 3, 1, 10, 5], [], [], [], _DACside]
	],
	// Spawn a outer Mission Zone
	[
		_missionSide select 0,
		_missionName,
		"missionZone",
		_missionPos,
		_missionSize,
		[[_missionCounter, 1, 0], _DACinfantry, _DACvehicles, _DACarmour, [], _DACside],
		true
	]
];

// Creates the DAC Zones above and sets one trigger to activate/deactivate them.
[_missionName, _DACZoneList] call tg_fnc_DACzone_creator;

true