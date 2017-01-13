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
		"Destroy a Radio Tower recently constructed by enemy forces.",
		"The enemy has established a Radio Tower at this location, destroy it.",
		"We've picked up a signal indicating a Radio Tower is present in the area, destroy it.",
		"Destroy the Radio Tower at the marked location.",
		"Intel has identified an enemy Radio Tower, destroy it.",
		"A UAV has spotted an enemy Radio Tower recently built by the enemy, destroy it."
	];	
private _missionSize = if (_missionType != tg_missionTypes select 0) then {500} else {1000};
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
	private _minValue = (_locAttempt * 100) + floor random _missionSize;
	_tempPos = [_tempPos, _minValue, _minValue + 200] call tg_fnc_findRandomEmpty;
	
	// Validate position
	private  _closePlayer = [_tempPos, _missionSize + _missionSize] call tg_fnc_isNearPlayer;
	private _closeMission = [_tempPos] call tg_fnc_isNearMission;

	// Ensure the mission does not spawn near a player or near another mission of the same type.
	if (!_closePlayer && !_closeMission) exitWith {
		_missionPos = _tempPos;
	};
	
	_locAttempt = _locAttempt + 1;
	[format["[TG-%1] DEBUG: Near - %3%4retrying %5/%6", _missionName, _tempPos, ["","Player "] select _closePlayer, ["","Task "] select _closeMission, _locAttempt, _maxAttempt]] call tg_fnc_debugMsg;
};

// No valid location found, abort the mission!
if (count _missionPos != 3 || _missionPos isEqualTo [0,0,0]) exitWith { false };

// ----------- SIDE ---------------
private _missionSide = [_missionPos] call tg_fnc_findSide;

// ----------- OBJECTIVE ---------------
// Ending must make a call to 'tg_fnc_missionEnd' to allow the mission to be counted and new one generated.

// Display mission marker.
private _missionMarker = createMarker[format["%1_marker", _missionName], _missionPos];
_missionMarker setMarkerShape "ICON";
_missionMarker setMarkerText _missionName;
_missionMarker setMarkerColor ([_missionSide select 0, true] call BIS_fnc_sideColor);
_missionMarker setMarkerSize [1,1];
_missionMarker setMarkerType "mil_circle";

// Create Objective
private _obj = "Land_TTowerBig_2_F" createVehicle _missionPos;
missionNamespace setVariable [format["%1_Obj",_missionName], _obj];

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
									format["['%1', '%2', true] spawn tg_fnc_missionEnd; '%1_marker' setMarkerColor 'ColorGrey'; [] spawn {sleep 120; deleteMarker '%1_marker';", _missionName, _missionType], 
									"" ];

// ----------- OTHER ---------------
//_group1 = [_missionPos, _missionSide select 0, 4] call BIS_fnc_spawnGroup;
//[_group1, getPos leader _group1, 50] spawn bis_fnc_taskPatrol;

// DAC = [UnitCount, UnitSize, WaypointPool, WaypointsGiven]
private _DACinfantry = [([10, "light", _missionType] call tg_fnc_balanceUnits), 3, 30, 15];
private _DACvehicles = [([4, "medium", _missionType] call tg_fnc_balanceUnits), 2, 25, 10];
private _DACarmour = [([1, "heavy", _missionType] call tg_fnc_balanceUnits), 1, 25, 10];
private _DACheli = if (random 1 > 0.95 && (_missionType == tg_missionTypes select 0)) then {[1,2,5]} else {[]};

// If unit count is 0 clear the array and just leave the way-points.
if (_DACvehicles select 0 == 0) then { _DACvehicles = [_DACvehicles select 2]; }; 
if (_DACarmour select 0 == 0) then { _DACarmour = [_DACarmour select 2]; }; 

// Spawn infantry-only Sentry Zone
[
	_missionSide select 0,
	_missionName,
	"sentryZone",
	_missionPos,
	100,
	[[_missionCounter, 1, 0], [2, 1, 15, 5], [], [], [], _missionSide select 1]
] call tg_fnc_spawnDACzone;

// Spawn a large Mission Zone
[
	_missionSide select 0,
	_missionName,
	"missionZone",
	_missionPos,
	_missionSize,
	[[_missionCounter, 1, 0], _DACinfantry, _DACvehicles, _DACarmour, _DACheli, _missionSide select 1],
	true
] call tg_fnc_spawnDACzone;

// Maybe spawn a Mortar Camp if is mainMission and over certain chance.
if (random 1 > 0.85 && (_missionType == tg_missionTypes select 0)) then {
	[
		_missionSide select 0,
		_missionName,
		"campZone",
		_missionPos,
		_missionSize,
		[[_missionCounter, 1, 0], [], [], [], [1, 2, 50, 0, 100, 10], _missionSide select 1]
	] call tg_fnc_spawnDACzone;
};

true