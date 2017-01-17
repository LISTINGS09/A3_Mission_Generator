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
		"Destroy a Communications Station recently occupied by enemy forces.",
		"The enemy has established a Communications Station, it must be destroyed.",
		"We've picked up a signal indicating a small Communications Station is present, destroy it.",
		"Destroy the Communications Station at the marked location.",
		"Intel has identified a small enemy Communications Station, destroy it.",
		"A UAV has spotted an enemy Communications Station, it must be destroyed quickly."
	];	
private _missionSize = if (_missionType != tg_missionTypes select 0) then {400} else {700};
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
	private  _closePlayer = [_tempPos, 2000] call tg_fnc_isNearPlayer;
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
private _missionSide = [_missionPos] call tg_fnc_findSide;

// ----------- OBJECTIVE ---------------

// Display mission marker.
private _missionMarker = createMarker[format["%1_marker", _missionName], _missionPos];
_missionMarker setMarkerShape "ICON";
_missionMarker setMarkerText _missionName;
_missionMarker setMarkerColor ([_missionSide select 0, true] call BIS_fnc_sideColor);
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

// Create Task
private _missionTask = [format["%1_task", _missionName], true, [selectRandom _missionDesc, _missionTitle, ""], _missionPos, "CREATED", 1, true, true, "destroy"] call BIS_fnc_setTask;
missionNamespace setVariable [format["%1_task", _missionName], _missionTask];

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
//_group1 = [_missionPos, _missionSide select 0, 4] call BIS_fnc_spawnGroup;
//[_group1, getPos leader _group1, 50] spawn bis_fnc_taskPatrol;

// DAC = [UnitCount, UnitSize, WaypointPool, WaypointsGiven]
private _DACinfantry = [([12, "light", _missionType] call tg_fnc_balanceUnits), 3, 30, 15];
private _DACvehicles = [([5, "medium", _missionType] call tg_fnc_balanceUnits), 2, 25, 10];
private _DACarmour = [([1, "heavy", _missionType] call tg_fnc_balanceUnits), 1, 25, 10];
private _DACheli = if (random 1 > 0.95 && (_missionType == tg_missionTypes select 0)) then {[1,2,5]} else {[]};

// If unit count is 0 clear the array.
if (_DACvehicles select 0 == 0) then { _DACvehicles = []; }; 
if (_DACarmour select 0 == 0) then { _DACarmour = []; }; 

_DACZoneList = [
	// Spawn an inner infantry-only Sentry Zone
	[
		_missionSide select 0,
		_missionName,
		"sentryZone",
		_missionPos,
		100,
		[[_missionCounter, 1, 0], [random 4, 1, 15, 5], [], [], [], _missionSide select 1]
	],
	// Spawn a outer Mission Zone
	[
		_missionSide select 0,
		_missionName,
		"missionZone",
		_missionPos,
		_missionSize,
		[[_missionCounter, 1, 0], _DACinfantry, _DACvehicles, _DACarmour, _DACheli, _missionSide select 1],
		true
	]
];

// Maybe spawn a Mortar Camp if is mainMission and over certain chance.
if (random 1 > 0.75 && (_missionType == tg_missionTypes select 0)) then {
	_DACZoneList append [[
		_missionSide select 0,
		_missionName,
		"campZone",
		_missionPos,
		_missionSize,
		[[_missionCounter, 0, 0], [], [], [], [1, 2, 50, 0, 100, 5], _missionSide select 1]
	]];
};

// Creates the DAC Zones above and sets one trigger to activate/deactivate them.
[_missionName, _DACZoneList] call tg_fnc_DACzone_creator;

true