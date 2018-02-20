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
		"A <font color='#00FFFF'>%1</font> has been seen in this area, locate and destroy it.",
		"Enemy forces have recently reinforced this area and brought in a <font color='#00FFFF'>%1</font>. It must be destroyed.",
		"Locate a <font color='#00FFFF'>%1</font> within the area and destroy it.",
		"Hunt down a <font color='#00FFFF'>%1</font> that has been spotted around this area.",
		"A <font color='#00FFFF'>%1</font> was spotted entering this area recently, find and eliminate it.",
		"Destroy the <font color='#00FFFF'>%1</font> stationed somewhere around this location."
	];	
private _missionSize = if _isMainMission then {700} else {400};
private _missionCounter = tg_counter;

// ----------- POSITION ---------------
// Loop to check if no players are nearby the area.
private _locAttempt = 0; 
private _maxAttempt = 10; 
private _missionPos = [];

while {_locAttempt < _maxAttempt} do {
	// Pick a random location from a marker.
	private  _tempPos = [_missionType] call tg_fnc_findRandomMarker;
	
	// Find a random position 
	private _minValue = _locAttempt * 100;
	_tempPos = [_tempPos, _minValue, _minValue + 300] call tg_fnc_findRandomEmpty;
	
	// Validate position
	private  _closePlayer = [_tempPos] call tg_fnc_isNearPlayer;
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

// ----------- SIDE ---------------
// Check if another mission is active nearby to force a side.
([_missionPos] call tg_fnc_findSide) params ["_enemySide", "_enemyDAC", "_enemySoldier", "_enemyFlag"];

// ----------- OBJECTIVE ---------------
// Display mission marker.
private _missionMarker = createMarker[format["%1_marker", _missionName], _missionPos];
_missionMarker setMarkerShape "ICON";
_missionMarker setMarkerColor ([_enemySide, true] call BIS_fnc_sideColor);
_missionMarker setMarkerSize [1,1];
_missionMarker setMarkerType "mil_circle";

private _zoneMarker = createMarker [format["%1_marker_zone", _missionName], _missionPos];
_zoneMarker setMarkerShape "ELLIPSE";
_zoneMarker setMarkerSize  [_missionSize * 1.5, _missionSize * 1.5];
_zoneMarker setMarkerColor ([_enemySide, true] call BIS_fnc_sideColor);
_zoneMarker setMarkerBrush  "Border";

// Create Objective
private _vehClass = if _isMainMission then {
		selectRandom (missionNamespace getVariable[format["tg_vehicles_land_%1_arm",_enemySide],[""]]);
	} else {
		selectRandom (missionNamespace getVariable[format["tg_vehicles_util_%1",_enemySide],[""]]);
	};

if (_vehClass isEqualTo "") exitWith { false };
	
private _vehObj = _vehClass createVehicle _missionPos;
private _vehName = [getText (configFile >> "CfgVehicles" >> _vehClass >> "displayname"),"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- "] call BIS_fnc_filterString;
missionNamespace setVariable [format["%1_VEH",_missionName], _vehObj];

// Crew vehicle if main mission.
if _isMainMission then {
	createVehicleCrew _vehObj;
	[group driver _vehObj, getPos _vehObj, 100] spawn bis_fnc_taskPatrol;
} else {
	_vehObj lock true;
};

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_objTrigger setTriggerTimeout [5, 5, 5, false];
//_objTrigger setTriggerActivation ["VEHICLE", "NOT PRESENT", false];
//_objTrigger triggerAttachVehicle [_vehObj];
_objTrigger setTriggerStatements [ 	format["!alive %1_VEH",_missionName], 
									format["['%1', '%2', true] spawn tg_fnc_missionEnd; {_x setMarkerColor 'ColorGrey'} forEach ['%1_marker','%1_marker_zone']; [] spawn { sleep 60; {deleteMarker _x} forEach ['%1_marker','%1_marker_zone']; };", _missionName, _missionType],
									"" ];

// ----------- OTHER ---------------
//_group1 = [_missionPos, _enemySide, 4] call BIS_fnc_spawnGroup;
//[_group1, getPos leader _group1, 50] spawn bis_fnc_taskPatrol;

// DAC = [UnitCount, UnitSize, WaypointPool, WaypointsGiven]
private _DACinfantry = [([6, "light", _missionType] call tg_fnc_balanceUnits), if _isMainMission then {3} else {2}, 30, 15];
private _DACvehicles = [([3, "medium", _missionType] call tg_fnc_balanceUnits), if _isMainMission then {2} else {1}, 25, 10];
private _DACarmour = [([1, "heavy", _missionType] call tg_fnc_balanceUnits), 1, 25, 10];
private _DACheli = if (random 1 > 0.65 && _isMainMission) then {[1,2,5]} else {[]};

// If unit count is 0 clear the array.
if (_DACvehicles select 0 == 0) then { _DACvehicles = []; }; 
if (_DACarmour select 0 == 0) then { _DACarmour = []; }; 

_DACZoneList = [
	// Spawn an inner infantry-only Sentry Zone
	[
		_enemySide,
		_missionName,
		"sentryZone",
		_missionPos,
		100,
		[[_missionCounter, 1, 0], [random 3, 1, 15, 5], [], [], [], _enemyDAC]
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

private _addText = "";

// Spawn a Heli Zone (maybe)
if (count _DACheli > 0) then {
	_addText = "<br/><br/>Enemy air support is understood to be active in this area. Approach the area with extreme caution.";
	_DACZoneList pushBack [
			_enemySide,
			_missionName,
			"heliZone",
			_missionPos,
			_missionSize,
			[[_missionCounter, 1, 0], [], [], [], _DACheli, _enemyDAC]
		];
};

// Create a trigger that sets up a DAC Zone (we don't want 100's of active zones at the start takes ~20mins to initialise!)
private _initTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_initTrigger setTriggerTimeout [1, 1, 1, false];
_initTrigger setTriggerArea [tg_triggerRange + _missionSize, tg_triggerRange + _missionSize, 0, true];
_initTrigger setTriggerActivation [format["%1", tg_playerSide], "PRESENT", false];
_initTrigger setTriggerStatements [ "this", format["['%1',%2] spawn tg_fnc_DACzone_creator; deleteVehicle thisTrigger;", _missionName, _DACZoneList], "" ];

// Get a text summary of the difficulty and enemy strength for the task.
private _textDifficulty = [if _isMainMission then {1} else {0},_DACinfantry, _DACvehicles, _DACarmour, _DACheli] call tg_fnc_stringDifficulty;

// Create Task
private _missionTask = [format["%1_task", _missionName], true, ["<font color='#00FF80'>Summary</font><br/>" + format[selectRandom _missionDesc,_vehName] + _addText + _textDifficulty, _missionTitle, ""], _missionPos, "CREATED", 1, if (time < 300) then { false } else { true }, true, "car"] call BIS_fnc_setTask;
missionNamespace setVariable [format["%1_task", _missionName], _missionTask];

true