// Test Mission
params [["_missionType", (tg_missionTypes select 0), [""]], ["_missionName", "", [""]]];

// ----------- PREP ---------------
// Make sure missionType is valid.
if (!(_missionType in tg_missionTypes) || _missionName == "") exitWith {
	["[TG] ERROR: Invalid mission: %1 %2", _missionName, _missionType] call tg_fnc_debugMsg;
	false
};

// Set-up mission variables.
private _missionTitle = format["%1: %2", (["Side","Main"] select (_missionType == "mainMission")), [] call tg_fnc_nameGenerator];
private _missionDesc = [
		"Enemy forces are trying to occupy a nearby location, eliminate them.",
		"A number of enemy groups have been spotted in this area, locate and eliminate all contacts.",
		"Eliminate all enemy forces in the nearby area.",
		"Enemy forces have recently entered this location, destroy them before they can reinforce it.",
		"The enemy appears to have occupied this area overnight, eliminate all forces there.",
		"The enemy is trying to occupy this area, move in and eliminate all resistance."
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
	[format["[TG] DEBUG (%1): Near %3%4 - Retrying %5/%6", _missionName, _tempPos, ["","Player "] select _closePlayer, ["","Mission "] select _closeMission, _locAttempt, _maxAttempt]] call tg_fnc_debugMsg;
};

// No valid location found, abort the mission!
if (count _missionPos != 3 || _missionPos isEqualTo [0,0,0]) exitWith { false };

// Place the marker on a nearby road.
private _roadList = _missionPos nearRoads 300;

// If a road is found, put the new location there.
if (count _roadList > 0) then {
	_missionPos = getPosASL (selectRandom _roadList);
};

// ----------- SIDE ---------------
// Check if another mission is active nearby to force a side.
private _missionSide = [_missionPos] call tg_fnc_findSide;

// ----------- OBJECTIVE ---------------
// Display mission marker.
private _missionMarker = createMarker[format["%1_marker", _missionName], _missionPos];
_missionMarker setMarkerShape "ICON";
_missionMarker setMarkerText _missionName;
_missionMarker setMarkerColor ([_missionSide select 0, true] call BIS_fnc_sideColor);
_missionMarker setMarkerSize [1,1];
_missionMarker setMarkerType "mil_circle";

// Create Objective
_group1 = [[_missionPos select 0, _missionPos select 1, 0], _missionSide select 0, [_missionSide select 2, _missionSide select 2, _missionSide select 2, _missionSide select 2, _missionSide select 2, _missionSide select 2]] call BIS_fnc_spawnGroup;

// Create Task
private _missionTask = [format["%1_task", _missionName], true, [selectRandom _missionDesc, _missionTitle, ""], _missionPos, "CREATED", 1, true, true, "attack"] call BIS_fnc_setTask;
missionNamespace setVariable [format["%1_task", _missionName], _missionTask];

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_objTrigger setTriggerTimeout [12, 12, 12, false];
_objTrigger setTriggerArea [(_missionSize / 100 * 75), (_missionSize / 100 * 75), 0, true];
_objTrigger setTriggerActivation [format["%1",_missionSide select 0], "NOT PRESENT", false];
_objTrigger setTriggerStatements [ 	format["count thisList < 4 && triggerActivated TR_DAC_%1",_missionName], 
									format["['%1', '%2', true] spawn tg_fnc_missionEnd; '%1_marker' setMarkerColor 'ColorGrey'; [] spawn { sleep 60; deleteMarker '%1_marker'; };", _missionName, _missionType], 
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