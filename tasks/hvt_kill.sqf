// Test Mission
params [["_missionType", (tg_missionTypes select 0), [""]], ["_missionName", "", [""]]];

// ----------- PREP ---------------
// Make sure missionType is valid.
if (!(_missionType in tg_missionTypes) || _missionName == "") then {
	["[TG] Invalid mission ('%1')",_missionType] call bis_fnc_error;
	_missionType = tg_missionTypes select 0;
};

// Set-up mission variables.
private _isMainMission = if (_missionType == tg_missionTypes select 0) then {true} else {false};
private _missionTitle = format["%1: %2", (["Side","Main"] select (_missionType == "mainMission")), [] call tg_fnc_nameGenerator];
private _missionDesc = [
		"Locate and eliminate a <font color='#00FFFF'>HVT</font> nearby %1 within the marked location.",
		"An <font color='#00FFFF'>Officer</font> has been spotted entering the area near %1, they must be eliminated.",
		"There is an enemy <font color='#00FFFF'>HVT</font> is trying to leave %1 and is awaiting extraction from this location, they must be eliminated.",
		"Find and eliminate the <font color='#00FFFF'>Officer</font> hiding somewhere nearby %1.",
		"An <font color='#00FFFF'>HVT</font> has been seen moving around the area outside %1, find them and kill them.",
		"A high-ranking <font color='#00FFFF'>Officer</font> is confirmed to be in the area near %1, ensure they are eliminated."
	];	
private _missionSize = if _isMainMission then {600} else {200};
private _missionCounter = tg_counter;

// ----------- POSITION ---------------
// Loop to check if no players are nearby the area.
private _locAttempt = 0; 
private _maxAttempt = 10; 
private _missionPos = [];
private _locType = if !_isMainMission then {"NameVillage"} else {"NameCity"};

while {_locAttempt < _maxAttempt} do {
	// Pick a random location from a random marker.
	private _tempPos = [([_missionType] call tg_fnc_findRandomMarker), _locType, 5000] call tg_fnc_findWorldLocation;
	
	// Validate position
	private _closePlayer = [_tempPos] call tg_fnc_isNearPlayer;
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
([_missionPos] call tg_fnc_findSide) params ["_enemySide", "_enemyDAC", "_enemySoldier", "_enemyFlag"];

// ----------- OBJECTIVE ---------------
// Create the marker
private _hvtMarker = createMarker[format["%1_marker", _missionName], _missionPos];
_hvtMarker setMarkerShape "ICON";
_hvtMarker setMarkerColor ([_enemySide, true] call BIS_fnc_sideColor);
_hvtMarker setMarkerSize [1,1];
_hvtMarker setMarkerType "mil_unknown";

private _zoneMarker = createMarker [format["%1_marker_zone", _missionName], _missionPos];
_zoneMarker setMarkerShape "ELLIPSE";
_zoneMarker setMarkerSize  [_missionSize * 1.5, _missionSize * 1.5];
_zoneMarker setMarkerColor ([_enemySide, true] call BIS_fnc_sideColor);
_zoneMarker setMarkerBrush  "Border";

// Create Objective
private _hvtGroup = createGroup (_enemySide);
private _hvtPos = selectRandom _bPos;
private _hvt = _hvtGroup createUnit [_enemySoldier, _hvtPos, [], 0, "NONE"];

missionNamespace setVariable [format["%1_HVT", _missionName], _hvt];
	
// Set HVT Post and give him a nice hat.	
_hvt setPosATL _hvtPos;	
_hvt addHeadgear "H_Beret_blk";
	
// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_objTrigger setTriggerTimeout [3, 3, 3, false];
_objTrigger setTriggerStatements [ 	format["!alive %1_HVT",_missionName], 
									format["['%1', '%2', true] spawn tg_fnc_missionEnd; {_x setMarkerColor 'ColorGrey'} forEach ['%1_marker','%1_marker_zone']; [] spawn { sleep 60; {deleteMarker _x} forEach ['%1_marker','%1_marker_zone']; };", _missionName, _missionType],
									"" ];

// ----------- OTHER ---------------
// DAC = [UnitCount, UnitSize, WaypointPool, WaypointsGiven]
private _DACinfantry = [([6, "light", _missionType] call tg_fnc_balanceUnits), if _isMainMission then {3} else {2}, 16, 8];
private _DACvehicles = [([3, "medium", _missionType] call tg_fnc_balanceUnits), if _isMainMission then {2} else {1}, 12, 6];
private _DACarmour = [([1, "heavy", _missionType] call tg_fnc_balanceUnits), 1, 8, 4];

// If unit count is 0 clear the array.
if (_DACvehicles select 0 == 0) then { _DACvehicles = []; }; 
if (_DACarmour select 0 == 0) then { _DACarmour = []; }; 

// Set DAC Behaviour to garrison Buildings for a long time.
_enemyDAC set [2,6];

_DACZoneList = [
	// Spawn an inner infantry-only Sentry Zone
	[
		_enemySide,
		_missionName,
		"sentryZone",
		_missionPos,
		100,
		[[_missionCounter, 1, 0], [random 3, 1, 10, 5], [], [], [], _enemyDAC]
	],
	// Spawn a outer Mission Zone
	[
		_enemySide,
		_missionName,
		"missionZone",
		_missionPos,
		_missionSize,
		[[_missionCounter, 1, 0], _DACinfantry, _DACvehicles, _DACarmour, [], _enemyDAC]
	]
];

// Create a trigger that sets up a DAC Zone (we don't want 100's of active zones at the start takes ~20mins to initialise!)
private _initTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_initTrigger setTriggerTimeout [1, 1, 1, false];
_initTrigger setTriggerArea [tg_triggerRange + _missionSize, tg_triggerRange + _missionSize, 0, true];
_initTrigger setTriggerActivation [format["%1", tg_playerSide], "PRESENT", false];
_initTrigger setTriggerStatements [ "this", format["['%1',%2] spawn tg_fnc_DACzone_creator; deleteVehicle thisTrigger;", _missionName, _DACZoneList], "" ];

// Get a text summary of the difficulty and enemy strength for the task.
private _textDifficulty = [if _isMainMission then {1} else {0},_DACinfantry, _DACvehicles, _DACarmour] call tg_fnc_stringDifficulty;

// Create Task
private _missionNameText = text nearestLocation [_missionPos, ""];
if (_missionNameText isEqualTo "") then { _missionNameText = worldName; };
private _missionTask = [format["%1_task", _missionName], true, ["<font color='#00FF80'>Summary</font><br/>" + format[(selectRandom _missionDesc), _missionNameText] + _textDifficulty, _missionTitle, ""], _missionPos, "CREATED", 1, if (time < 300) then { false } else { true }, true, "target"] call BIS_fnc_setTask;
missionNamespace setVariable [format["%1_task", _missionName], _missionTask];

true