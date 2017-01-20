// Test Mission
params [["_missionType", (tg_missionTypes select 0), [""]], ["_missionName", "", [""]]];

// ----------- PREP ---------------
// Make sure missionType is valid.
if (!(_missionType in tg_missionTypes) || _missionName == "") exitWith {
	["[TG-%1] ERROR: Invalid mission: %2", _missionName, _missionType] call tg_fnc_debugMsg;
	false
};

// Set-up mission variables.
private _isMainMission = if (_missionType == tg_missionTypes select 0) then {true} else {false};
private _missionTitle = format["%1: %2", (["Side","Main"] select (_missionType == "mainMission")), [] call tg_fnc_nameGenerator];
private _missionDesc = [
		"Destroy a Communications Station recently occupied by enemy forces.",
		"The enemy has established a Communications Station, it must be destroyed.",
		"We've picked up a signal indicating a small Communications Station is present, destroy it.",
		"Destroy the Communications Station at the marked location.",
		"Intel has identified a small enemy Communications Station, destroy it.",
		"A UAV has spotted an enemy Communications Station, it must be destroyed quickly."
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

// Create the objective + fluff.
_dir = random 360;

[[
	["Land_Communication_F", [-0.387802,5.38965,0], 0, format["%1_Obj",_missionName]],
	["Land_HBarrier_5_F", [-3.75385,6.12378,0], 90], 
	["Land_BagFence_Long_F", [0.496094,-2.73438,0], 360], 
	["Land_BagFence_Long_F", [-2.48445,-1.37109,0], 90], 
	["Land_HBarrier_1_F", [-2.49806,1.75732,0], 195], 
	["Land_BagFence_Short_F", [-2.50145,0.989502,0], 270], 
	["Land_BagFence_Short_F", [-1.73949,-2.75146,0], 180], 
	["Land_PowerGenerator_F", [-2.24978,5.23438,0], 180], 
	["Land_HBarrier_5_F", [-3.99875,7.37109,0], 0], 
	["Land_Cargo_House_V2_F", [2.62503,2.72852,0], 0], 
	["Land_HBarrier_5_F", [7.12885,3.12622,0], 270], 
	["Land_HBarrier_5_F", [1.50125,7.37109,0], 0]
], _missionPos, _dir] call tg_fnc_objectSpawner;

// Align the objective tower.
(missionNamespace getVariable format["%1_Obj",_missionName]) setVectorUp [0,0,1];

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_objTrigger setTriggerTimeout [5, 5, 5, false];
//_objTrigger setTriggerArea [50, 50, 0, true];
_objTrigger setTriggerActivation ["VEHICLE", "NOT PRESENT", false];
//_objTrigger triggerAttachVehicle [("C_Van_01_box_F" createVehicle _missionPos)];
_objTrigger setTriggerStatements [ 	format["!alive %1_Obj",_missionName], 
									format["['%1', '%2', true] spawn tg_fnc_missionEnd; '%1_marker' setMarkerColor 'ColorGrey'; [] spawn { sleep 60; deleteMarker '%1_marker'; };", _missionName, _missionType], 
									"" ];

// ----------- OTHER ---------------
//_group1 = [_missionPos, _enemySide, 4] call BIS_fnc_spawnGroup;
//[_group1, getPos leader _group1, 50] spawn bis_fnc_taskPatrol;

// DAC = [UnitCount, UnitSize, WaypointPool, WaypointsGiven]
private _DACinfantry = [([6, "light", _missionType] call tg_fnc_balanceUnits), 2, 30, 15];
private _DACvehicles = [([4, "medium", _missionType] call tg_fnc_balanceUnits), 2, 25, 10];
private _DACarmour = [([1, "heavy", _missionType] call tg_fnc_balanceUnits), 1, 25, 10];
private _DACheli = if (random 1 > 0.95 && _isMainMission) then {[1,2,5]} else {[]};

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
		[[_missionCounter, 1, 0], [random 4, 1, 15, 5], [], [], [], _enemyDAC]
	],
	// Spawn a outer Mission Zone
	[
		_enemySide,
		_missionName,
		"missionZone",
		_missionPos,
		_missionSize,
		[[_missionCounter, 1, 0], _DACinfantry, _DACvehicles, _DACarmour, _DACheli, _enemyDAC],
		true
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

// Maybe spawn a Mortar Camp if is mainMission and over certain chance.
if (random 1 > 0.75 && (_missionType == tg_missionTypes select 0)) then {
	_addText = "<br/><br/>A mortar site is present somewhere near the objective. Expect the enemy will call in mortar support if you are spotted.";
	_DACZoneList append [[
		_enemySide,
		_missionName,
		"campZone",
		_missionPos,
		_missionSize,
		[[_missionCounter, 0, 0], [], [], [], [1, 2, 50, 0, 100, 5], _enemyDAC]
	]];
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
private _missionTask = [format["%1_task", _missionName], true, ["<font color='#00FF80'>Summary</font><br/>" + (selectRandom _missionDesc) + _addText + _textDifficulty, _missionTitle, ""], _missionPos, "CREATED", 1, true, true, "destroy"] call BIS_fnc_setTask;
missionNamespace setVariable [format["%1_task", _missionName], _missionTask];

true