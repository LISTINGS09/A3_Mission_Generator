// Destroy Tower Mission

params [["_missionType",(tg_missionTypes select 0),[""]]];

_missionName = format["%1%2", "destroyTower", tg_counter]; // THIS MUST BE UNIQUE!
_missionTitle = ["Operation ", "Codename ", "Objective "];
_missionDesc = [
		"Destroy a Radio Tower recently constructed by enemy forces.",
		"The enemy has established a Radio Tower at this location, destroy it.",
		"We've picked up a signal indicating a Radio Tower is present in the area, destroy it.",
		"Destroy the Radio Tower at the marked location.",
		"Intel has identified an enemy Radio Tower, destroy it.",
		"A UAV has spotted an enemy Radio Tower recently built by the enemy, destroy it."
	];

// Make sure type is valid (is needed?)
if !(_missionType in tg_missionTypes) exitWith {
	["[TG] ERROR: %1 - Invalid mission type passed: %2", _missionName, _missionType] call tg_fnc_debugMsg;
};

// ----------- PREP ---------------

// Pick a random Main Mission location.
_missionPos = [] call tg_fnc_findRandomEmpty;

//_missionLoc = selectRandom (missionNamespace getVariable[format["tg_markers_%1",_missionType],[]]);

if (_missionPos isEqualTo [0,0,0]) exitWith {
	["[TG] ERROR: %1 - Invalid position returned", _missionName, format["tg_markers_%1",_missionType]] call tg_fnc_debugMsg;
};

// Identify mission as not completed.
missionNamespace setVariable [format["%1", _missionName], false];

// Add to active missions queue.
tg_missions_active append [[_missionName,_missionType]];

// Create Objective
_obj = "Land_TTowerBig_2_F" createVehicle _missionPos;

// Objective Trigger

_objTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_objTrigger setTriggerTimeout [5, 5, 5, false];
_objTrigger setTriggerArea [100, 100, 0, true];
_objTrigger setTriggerActivation ["VEHICLE", "NOT PRESENT", false];
_objTrigger triggerAttachVehicle [_obj];
_objTrigger setTriggerStatements [ 	"this", 
									format["[%1, %2, true] call tg_fnc_missionEnd; ['[TG] DEBUG: %1 - Completed'] call tg_fnc_debugMsg;", _missionName, _missionType], 
									"" ];

// Create Task
_missionTask = [str tg_counter, true, [selectRandom _missionDesc, selectRandom _missionTitle, ""],_missionPos,"CREATED",0,true,"destroy",false] call BIS_fnc_setTask;
missionNamespace setVariable [format["tg_task_%1", _missionName], _missionTask];

// ----------- MAIN OBJECTIVE ---------------



// Remove it from the list so its not picked again.
//missionNamespace setVariable[format["tg_markers_%1",_missionType],(missionNamespace getVariable[format["tg_markers_%1",_missionType],[]]) - [_missionLoc]];

// TODO: SPAWN MISSION UNITS & WIN CONDITION

if tg_debug then {
	// Display mission marker.
	_missionMarker = createMarkerLocal[format["%1_marker", _missionName], _missionPos];
	_missionMarker setMarkerShapeLocal "ICON";
	_missionMarker setMarkerColorLocal "colorRed";
	_missionMarker setMarkerSizeLocal [1,1];
	_missionMarker setMarkerTypeLocal "mil_dot";
	
	[format["[TG] DEBUG: Marker '%1_marker' created at %2", _missionName, getMarkerPos format["%1_marker",_missionName]]] call tg_fnc_debugMsg;
};

// 

[_missionPos, WEST, 5] call BIS_fnc_spawnGroup;

// ----------- SURROUNDING UNITS ---------------

sleep 1; 

//[format["[TG] Counts for 'mainMission_%1_zone' (%6 players): [%2, %3, %4, %5]", tg_counter, _countInfantry, _countVehicles, _countArmour, _countAir, count (playableUnits + switchableUnits)]] call tg_fnc_debugMsg;

// Spawn a Zone
[
	_missionName,
	"zone1",
	_missionPos,
	1500,
	[[tg_counter, 0, 0], _DACinfantry, _DACvehicles, _DACarmour, _DACheli, _DACside]
] call tg_fnc_spawnDACzone;

// Spawn a Mortar Camp
[
	_missionName,
	"camp1",
	_missionPos,
	500,
	[[tg_counter, 0, 0], [], [], [], _DACcamp, _DACside]
] call tg_fnc_spawnDACzone;