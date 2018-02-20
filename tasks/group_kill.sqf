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
		"An <font color='#00FFFF'>Elite Group</font> has been spotted at this location, find and kill them.",
		"A <font color='#00FFFF'>Specialist Unit</font> has been spotted moving around this area, hunt them down.",
		"Track and eliminate a <font color='#00FFFF'>Special Forces</font> unit somewhere nearby.",
		"One highly-trained group of <font color='#00FFFF'>Operators</font> is located somewhere nearby, find them.",
		"A <font color='#00FFFF'>Crack Squad</font> of enemy soldiers have para-dropped into this area, locate and eliminate them.",
		"Find and kill a <font color='#00FFFF'>Veteran Unit</font>, patrolling somewhere around this region."
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

private _zoneMarker = createMarker [format["%1_marker_zone", _missionName], _missionPos];
_zoneMarker setMarkerShape "ELLIPSE";
_zoneMarker setMarkerSize  [_missionSize * 1.5, _missionSize * 1.5];
_zoneMarker setMarkerColor ([_enemySide, true] call BIS_fnc_sideColor);
_zoneMarker setMarkerBrush  "Border";

private _groupArr = [_enemySoldier,_enemySoldier];

// Fill random soldiers depending on type
for "_i" from 0 to (if _isMainMission then {random 4} else {random 2}) do {
    _groupArr pushBack _enemySoldier;
};

// Create group, set skill and movement orders
private _milGroup = [_missionPos, _enemySide, _groupArr] call BIS_fnc_spawnGroup;
{_x addHeadGear "H_Beret_blk"; _x setSkill 0.5 + random 0.3; } forEach units _milGroup;
[_milGroup, _missionPos, 100] call bis_fnc_taskPatrol;

missionNamespace setVariable [format["%1_GROUP", _missionName], _milGroup];

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_objTrigger setTriggerTimeout [5, 5, 5, false];
_objTrigger setTriggerStatements [ 	format["(({alive _x} count units %1_GROUP) == 0);",_missionName], 
									format["['%1', '%2', true] spawn tg_fnc_missionEnd; {_x setMarkerColor 'ColorGrey'} forEach ['%1_marker','%1_marker_zone']; [] spawn { sleep 60; {deleteMarker _x} forEach ['%1_marker','%1_marker_zone']; };", _missionName, _missionType],
									"" ];

// ----------- OTHER ---------------
// DAC = [UnitCount, UnitSize, WaypointPool, WaypointsGiven]
private _DACinfantry = [([6, "light", _missionType] call tg_fnc_balanceUnits), if _isMainMission then {3} else {2}, 20, 5];
private _DACvehicles = [([3, "medium", _missionType] call tg_fnc_balanceUnits), if _isMainMission then {2} else {1}, 10, 6];
private _DACarmour = [([1, "heavy", _missionType] call tg_fnc_balanceUnits), 1, 8, 4];
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
private _missionTask = [format["%1_task", _missionName], true, ["<font color='#00FF80'>Summary</font><br/>" + (selectRandom _missionDesc) + _textDifficulty, _missionTitle, ""], _missionPos, "CREATED", 1, if (time < 300) then { false } else { true }, true, "kill"] call BIS_fnc_setTask;
missionNamespace setVariable [format["%1_task", _missionName], _missionTask];

true