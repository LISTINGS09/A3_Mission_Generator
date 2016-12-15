// Test Mission
params [["_missionType", (tg_missionTypes select 0), [""]], ["_missionName", "", [""]]];

// ----------- PREP ---------------

// Set-up mission variables.
_missionTitle = format["%1", call tg_fnc_nameGenerator];
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

// Pick a random Main Mission location from a marker.
_missionPos = [] call tg_fnc_findRandomMarker;
_missionPos = [_missionPos, 200, 500] call tg_fnc_findRandomEmpty;

sleep 5;

[format["[TG-%1] DEBUG: %1 (%2) - Location: %3", _missionName, _missionType, _missionPos]] call tg_fnc_debugMsg;

// No valid location found, abort!
if (count _missionPos != 3 || _missionPos isEqualTo [0,0,0]) exitWith {
	[format["[TG-%1] ERROR: %1 (%2) - Invalid location given, aborting", _missionName, _missionType]] call tg_fnc_debugMsg;
	false
};

// ----------- OBJECTIVE ---------------

if tg_debug then {
	// Display mission marker.
	_missionMarker = createMarkerLocal[format["%1_marker", _missionName], _missionPos];
	_missionMarker setMarkerShapeLocal "ICON";
	_missionMarker setMarkerColorLocal "colorRed";
	_missionMarker setMarkerSizeLocal [1,1];
	_missionMarker setMarkerTypeLocal "mil_dot";
	
	[format["[TG-%1] DEBUG: Marker '%1_marker' created at %2", _missionName, getMarkerPos format["%1_marker",_missionName]]] call tg_fnc_debugMsg;
};

// Create Objective
_obj = "Land_TTowerBig_2_F" createVehicle _missionPos;

// Objective Trigger
_objTrigger = createTrigger ["EmptyDetector", _missionPos, false];
_objTrigger triggerAttachVehicle [_obj];
_objTrigger setTriggerTimeout [5, 5, 5, false];
_objTrigger setTriggerArea [100, 100, 0, true];
_objTrigger setTriggerActivation ["VEHICLE", "NOT PRESENT", false];
_objTrigger setTriggerStatements [ 	"this", 
									format["[%1, %2, true] call tg_fnc_missionEnd; ['[TG] DEBUG: %1 - Completed'] call tg_fnc_debugMsg;", _missionName, _missionType], 
									"" ];

// Create Task
_missionTask = [str tg_counter, true, [selectRandom _missionDesc, _missionTitle, ""], _missionPos, "CREATED", 1, true, true, "destroy"] call BIS_fnc_setTask;
missionNamespace setVariable [format["tg_task_%1", _missionName], _missionTask];

// ----------- OTHER ---------------

true