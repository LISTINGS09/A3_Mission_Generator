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
		"",
		"",
		"",
		"",
		"",
		""
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

private _obj = createVehicle [selectRandom ["Land_UWreck_Heli_Attack_02_F", "Land_HistoricalPlaneWreck_02_front_F", "Land_UWreck_MV22_F", "Land_Wreck_Plane_Transport_01_F"],_missionPos,[], 0, "can_collide"];
_obj setVectorUp surfaceNormal position _obj;
private _smoke = createVehicle ["SmokeShell",position _obj, [], 0, "CAN_COLLIDE"];
_smoke attachTo [_obj, [0, 0, -5] ];

if (daytime > 17 || daytime < 5) then {
	for "_i" from 0 to 4 do {
		_chem = createVehicle [selectRandom ["Chemlight_green","Chemlight_yellow","Chemlight_red","Chemlight_blue"], _missionPos, [], 7, "NONE"]; 
	};
};

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
private _DACinfantry = [([4, "light", _missionType] call tg_fnc_balanceUnits), 2, 30, 15];
private _DACvehicles = [([1, "medium", _missionType] call tg_fnc_balanceUnits), 2, 25, 10];
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
		[[_missionCounter, 1, 0], _DACinfantry, _DACvehicles, _DACarmour, _DACheli, _enemyDAC],
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
private _missionTask = [format["%1_task", _missionName], true, ["<font color='#00FF80'>Summary</font><br/>" + (selectRandom _missionDesc) + _textDifficulty, _missionTitle, ""], _missionPos, "CREATED", 1, true, true, "destroy"] call BIS_fnc_setTask;
missionNamespace setVariable [format["%1_task", _missionName], _missionTask];

true