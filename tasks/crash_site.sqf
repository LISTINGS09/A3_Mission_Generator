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
		"The enemy has engaged a cargo transport flying over the area, search the area for nearby crates.",
		"An enemy air transport has crashed at the location, search the area for crates.",
		"Ammo crates have been spotted near a wreck, move in and secure them.",
		"Search and secure the ammo crates at a downed transport.",
		"An air transport carrying supplies has crashed. Secure the area and find the crates.",
		"A crashed transport has been spotted near this location. Find the crates before the enemy can."
	];	
private _missionSize = if _isMainMission then {400} else {200};
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
	_tempPos = [_tempPos, _minValue + 300, _minValue + 300] call tg_fnc_findRandomEmpty;
	
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

// Create Objective
//private _tower = (selectRandom ["Land_TTowerBig_1_F","Land_TTowerBig_2_F"]) createVehicle _missionPos;
//missionNamespace setVariable [format["%1_Obj",_missionName], _tower];
//_tower setVectorUp [0,0,1];

private _wreck = (selectRandom ["Land_UWreck_Heli_Attack_02_F", "Land_HistoricalPlaneWreck_02_front_F", "Land_UWreck_MV22_F", "Land_Wreck_Plane_Transport_01_F"]) createVehicle _missionPos;
_wreck setVectorUp surfaceNormal position _wreck;

// Spawn smoke.
private _smoke = createVehicle ["test_EmptyObjectForSmoke",_missionPos vectorAdd [0,0,1], [], 0, "CAN_COLLIDE"];

// Get the number of crates to generate.
_crateNo = if _isMainMission then { random 5 } else { random 3 };

// Generate the crates.
for "_i" from 0 to _crateNo do {
	_ammoType = selectRandom tg_vehicles_ammo;
	private _ammoPos = _missionPos findEmptyPosition [5, 15, _ammoType];
	if (count _ammoPos > 0) then { 
		private _ammoObj = _ammoType createVehicle _ammoPos;
		_ammoObj allowDamage false;
		_ammoObj setDir random 90;
		["crash_crate",_ammoObj, _enemySide] call f_fnc_assignGear;
	};
};

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_objTrigger setTriggerTimeout [5, 5, 5, false];
_objTrigger setTriggerArea [50, 50, 0, true];
_objTrigger setTriggerActivation [format["%1", tg_playerSide], "PRESENT", false];
_objTrigger setTriggerStatements [ 	"this", 
									format["['%1', '%2', true] spawn tg_fnc_missionEnd; '%1_marker' setMarkerColor 'ColorGrey'; [] spawn { sleep 60; deleteMarker '%1_marker'; };", _missionName, _missionType], 
									"" ];

// ----------- OTHER ---------------
//_group1 = [_missionPos, _enemySide, 4] call BIS_fnc_spawnGroup;
//[_group1, getPos leader _group1, 50] spawn bis_fnc_taskPatrol;

// DAC = [UnitCount, UnitSize, WaypointPool, WaypointsGiven]
private _DACinfantry = [([4, "light", _missionType] call tg_fnc_balanceUnits), 2, 30, 15];
private _DACvehicles = [([1, "medium", _missionType] call tg_fnc_balanceUnits), 1, 25, 10];
private _DACarmour = [];
private _DACheli =[];

// If unit count is 0 clear the array.
if (_DACvehicles select 0 == 0) then { _DACvehicles = []; }; 

_DACZoneList = [
	// Spawn a Mission Zone
	[
		_enemySide,
		_missionName,
		"missionZone",
		_missionPos,
		_missionSize,
		[[_missionCounter, 1, 0], _DACinfantry, _DACvehicles, _DACarmour, _DACheli, _enemyDAC]
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
private _missionTask = [format["%1_task", _missionName], true, ["<font color='#00FF80'>Summary</font><br/>" + (selectRandom _missionDesc) + _textDifficulty, _missionTitle, ""], _missionPos, "CREATED", 1, if (time < 300) then { false } else { true }, true, "rearm"] call BIS_fnc_setTask;
missionNamespace setVariable [format["%1_task", _missionName], _missionTask];

true