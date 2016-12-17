// Test Mission
params [["_missionType", (tg_missionTypes select 0), [""]], ["_missionName", "", [""]]];

// ----------- PREP ---------------

// Set-up mission variables.
_missionTitle = format["%1: %2", (["Side","Main"] select (_missionType == "mainMission")), [] call tg_fnc_nameGenerator];
_missionDesc = [
		"Destroy a Radio Tower recently constructed by enemy forces.",
		"The enemy has established a Radio Tower at this location, destroy it.",
		"We've picked up a signal indicating a Radio Tower is present in the area, destroy it.",
		"Destroy the Radio Tower at the marked location.",
		"Intel has identified an enemy Radio Tower, destroy it.",
		"A UAV has spotted an enemy Radio Tower recently built by the enemy, destroy it."
	];
	
// Make sure core variables are valid.
if (!(_missionType in tg_missionTypes) || _missionName == "") exitWith {
	["[TG-%1] ERROR: Invalid mission: %2", _missionName, _missionType] call tg_fnc_debugMsg;
	false
};

// ----------- POSITION ---------------
// 
// [_missionType] call tg_fnc_findRandomMarker;
// [] call tg_fnc_findRandomEmpty;
// 
//

// Pick a random Main Mission location from a marker.
_missionPos = [_missionType] call tg_fnc_findRandomMarker;

_minValue = 100 + floor random 1000;
_missionPos = [_missionPos, _minValue, _minValue + 200] call tg_fnc_findRandomEmpty;

sleep 5;

[format["[TG-%1] DEBUG: %1 (%2) - Location: %3", _missionName, _missionType, _missionPos]] call tg_fnc_debugMsg;

// No valid location found, abort!
if (count _missionPos != 3 || _missionPos isEqualTo [0,0,0]) exitWith {
	[format["[TG-%1] ERROR: %1 (%2) - Invalid location given, aborting", _missionName, _missionType]] call tg_fnc_debugMsg;
	false
};

// ----------- SIDE ---------------

_missionSide = [_missionPos] call tg_fnc_findSide;

[format["[TG-%1] DEBUG: Side - %1", _missionSide select 0]] call tg_fnc_debugMsg;

// ----------- OBJECTIVE ---------------
// Ending must make a call to 'tg_fnc_missionEnd' to allow the mission to be counted and new one generated.

// Display mission marker.
_missionMarker = createMarkerLocal[format["%1_marker", _missionName], _missionPos];
_missionMarker setMarkerShapeLocal "ICON";
_missionMarker setMarkerColorLocal ([_missionSide select 0, true] call BIS_fnc_sideColor);
_missionMarker setMarkerSizeLocal [1,1];
_missionMarker setMarkerTypeLocal "mil_circle";

// Create Objective
_obj = "Land_TTowerBig_2_F" createVehicle _missionPos;
missionNamespace setVariable [format["%1_Obj",_missionName], _obj];

// Create Task
_missionTask = [format["%1_task", _missionName], true, [selectRandom _missionDesc, _missionTitle, ""], _missionPos, "CREATED", 1, true, true, "destroy"] call BIS_fnc_setTask;
missionNamespace setVariable [format["%1_task", _missionName], _missionTask];

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_objTrigger setTriggerTimeout [5, 5, 5, false];
//_objTrigger setTriggerArea [50, 50, 0, true];
//_objTrigger setTriggerActivation ["VEHICLE", "NOT PRESENT", false];
//_objTrigger triggerAttachVehicle [("C_Van_01_box_F" createVehicle _missionPos)];
_objTrigger setTriggerStatements [ 	format["!alive %1_Obj",_missionName], 
									format["['%1', '%2', true] spawn tg_fnc_missionEnd; '%1_marker' setMarkerColor 'ColorGrey';", _missionName, _missionType], 
									"" ];

// ----------- OTHER ---------------

// Set default AI counts
_countInfantry = ceil random [5, 10, 0];
_countVehicles = floor random [2, 4, 0];
_countArmour = floor random [0, 1, 0];
_countAir = floor random [0, 0, 3];

// Auto-Adjust the unit counts depending on params
if (missionNamespace getVariable ["f_param_enemyAutoBalance",0] == 1) then {
	_countInfantry = ceil random [1, (_countInfantry / 2) + ((count (playableUnits + switchableUnits)) * 0.4), 0];
	_countVehicles = floor random [1, (_countVehicles / 2) + ((count (playableUnits + switchableUnits)) * 0.2), 0];
	_countArmour = floor random [0, (_countArmour / 2) + ((count (playableUnits + switchableUnits)) * 0.1), 0];
};

// DAC = [UnitCount, UnitSize, WaypointPool, WaypointsGiven]
_DACinfantry = [_countInfantry, 3, 50, 20];
_DACvehicles = [_countVehicles, 3, 25, 8];
_DACarmour = [_countArmour, 1, 25, 10];
_DACheli = if (_countAir == 0) then {[]} else {[_countAir, 2, 5]};
_DACcamp = [1, 2, 50, 0, 100, 10];
_DACside = [0, 0, 0, 0];


// Spawn a Zone
[
	_missionName,
	"zone1",
	_missionPos,
	1000,
	[[tg_counter, 0, 0], _DACinfantry, _DACvehicles, _DACarmour, _DACheli, _missionSide select 1]
] call tg_fnc_spawnDACzone;

// Spawn a Mortar Camp
if (random 1 > 0.85) then {
	[
		_missionName,
		"camp1",
		_missionPos,
		500,
		[[tg_counter, 0, 0], [], [], [], _DACcamp, _missionSide select 1]
	] call tg_fnc_spawnDACzone;
};


true