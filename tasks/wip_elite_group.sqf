// Test Mission
params [["_missionType", (tg_missionTypes select 0), [""]], ["_missionName", "", [""]]];

// ----------- PREP ---------------
// Make sure missionType is valid.
if (!(_missionType in tg_missionTypes) || _missionName == "") exitWith {
	["[TG] ERROR: Invalid mission: %1 %2", _missionName, _missionType] call tg_fnc_debugMsg;
	false
};

// Set-up mission variables.
private _isMainMission = if (_missionType == tg_missionTypes select 0) then {true} else {false};
private _missionTitle = format["%1: %2", (["Side","Main"] select (_missionType == "mainMission")), [] call tg_fnc_nameGenerator];
private _missionDesc = [
		"",
		"",
		"",
		"",
		"",
		""
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
	[format["[TG] DEBUG (%1): Near %3%4 - Retrying %5/%6", _missionName, _tempPos, ["","Player "] select _closePlayer, ["","Mission "] select _closeMission, _locAttempt, _maxAttempt]] call tg_fnc_debugMsg;
};

// No valid location found, abort the mission!
if (count _missionPos != 3 || _missionPos isEqualTo [0,0,0]) exitWith { false };

// Place the marker on a nearby road.
private _roadList = _missionPos nearRoads 300;

// If a road is found, put the new location there.
if (count _roadList > 0) then {
	_missionPos = getPos (selectRandom _roadList);
};

// ----------- SIDE ---------------
// Check if another mission is active nearby to force a side.
([_missionPos] call tg_fnc_findSide) params ["_enemySide", "_enemyDAC", "_enemySoldier", "_enemyFlag"];

// ----------- OBJECTIVE ---------------
// Display mission marker.
private _missionMarker = createMarker[format["%1_marker", _missionName], _missionPos];
_missionMarker setMarkerShape "ICON";
_missionMarker setMarkerColor ([_enemySide, true] call BIS_fnc_sideColor);
_missionMarker setMarkerSize [1,1];
_missionMarker setMarkerType "mil_unknown";

// Create Objective
private _milGroup = [_missionPos, _enemySide, [_enemySoldier, _enemySoldier, _enemySoldier, _enemySoldier, _enemySoldier, _enemySoldier, _enemySoldier, _enemySoldier]] call BIS_fnc_spawnGroup;
[_milGroup, _missionPos, 200] call bis_fnc_taskPatrol;

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_objTrigger setTriggerTimeout [12, 12, 12, false];
_objTrigger setTriggerArea [(_missionSize / 100 * 75), (_missionSize / 100 * 75), 0, true];
_objTrigger setTriggerActivation [format["%1",_enemySide], "NOT PRESENT", false];
_objTrigger setTriggerStatements [ 	format["!alive ",_missionName], 
									format["['%1', '%2', true] spawn tg_fnc_missionEnd; '%1_marker' setMarkerColor 'ColorGrey'; [] spawn { sleep 60; deleteMarker '%1_marker'; };", _missionName, _missionType], 
									"" ];

// ----------- OTHER ---------------
// DAC = [UnitCount, UnitSize, WaypointPool, WaypointsGiven]
private _DACinfantry = [([4, "light", _missionType] call tg_fnc_balanceUnits), if _isMainMission then {3} else {2}, 20, 5];
private _DACvehicles = [([1, "medium", _missionType] call tg_fnc_balanceUnits), 2, 10, 6];
private _DACarmour = [];
private _DACheli = [];

// If unit count is 0 clear the array.
if (_DACvehicles select 0 == 0) then { _DACvehicles = []; }; 

// Set DAC Behaviour to garrison Buildings for a long time.
_enemyDAC set [2,6];

_DACZoneList = [
	// Spawn an infantry-only Zone
	[
		_enemySide,
		_missionName,
		"sentryZone",
		_missionPos,
		_missionSize,
		[[_missionCounter, 1, 0], _DACinfantry, [], [], [], _enemyDAC],
		true
	]
];

// Create a trigger that sets up a DAC Zone (we don't want 100's of active zones at the start takes ~20mins to initialise!)
private _initTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_initTrigger setTriggerTimeout [1, 1, 1, false];
_initTrigger setTriggerArea [tg_triggerRange + _missionSize, tg_triggerRange + _missionSize, 0, true];
_initTrigger setTriggerActivation [format["%1", tg_playerSide], "PRESENT", false];
_initTrigger setTriggerStatements [ "this", format["['%1',%2] spawn tg_fnc_DACzone_creator; deleteVehicle thisTrigger;", _missionName, _DACZoneList], "" ];

// Get a text summary of the difficulty and enemy strength for the task.
private _textDifficulty = [if _isMainMission then {1} else {0},_DACinfantry, _DACvehicles, _DACarmour, _DACheli] call tg_fnc_stringDifficulty;

// Create Task
private _missionTask = [format["%1_task", _missionName], true, ["<font color='#00FF80'>Summary</font><br/>" + (selectRandom _missionDesc) + _textDifficulty, _missionTitle, ""], _missionPos, "CREATED", 1, true, true, "attack"] call BIS_fnc_setTask;
missionNamespace setVariable [format["%1_task", _missionName], _missionTask];

true