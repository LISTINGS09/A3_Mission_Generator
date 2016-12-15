// Only run on server
if !isServer exitWith {};

// Only start in-game.
sleep 1;

// DAC will error if this parameter is not enabled!
if !(missionNamespace getVariable ["DAC_Direct_Start",false]) then {
	diag_log text "[TG] ERROR: DAC_Direct_Start is NOT enabled.";
	systemChat "[TG] ERROR: DAC_Direct_Start is NOT enabled.";
};

// Wait until DAC has initialised.
waitUntil {sleep 1; DAC_Basic_Value > 0;};

// ----------- VARIABLES START ---------------

tg_taskFolder = "scripts\taskGenerator"; // Location used for loading the tasks.
tg_missionTypes = ["mainMission"]; // Used globally and variables are built from these strings.. // "sideMission"


tg_fnc_taskTestTaskA = compileFinal preprocessFileLineNumbers format["%1\tasks\test_task.sqf", tg_taskFolder];
tg_fnc_taskTestTaskB = compileFinal preprocessFileLineNumbers format["%1\tasks\test_task.sqf", tg_taskFolder];
tg_fnc_taskTestTaskC = compileFinal preprocessFileLineNumbers format["%1\tasks\test_task.sqf", tg_taskFolder];
tg_fnc_taskTestTaskD = compileFinal preprocessFileLineNumbers format["%1\tasks\test_task.sqf", tg_taskFolder];
tg_fnc_taskTestTaskE = compileFinal preprocessFileLineNumbers format["%1\tasks\test_task.sqf", tg_taskFolder];

// List of available main missions.
tg_mainMission_list = [
	"tg_fnc_taskTestTaskA",
	"tg_fnc_taskTestTaskB",
	"tg_fnc_taskTestTaskC"
];

// List of available side missions.
tg_sideMission_list = [
	"tg_fnc_taskTestTaskA",
	"tg_fnc_taskTestTaskB",
	"tg_fnc_taskTestTaskC",
	"tg_fnc_taskTestTaskD",
	"tg_fnc_taskTestTaskE"
];

//tg_sideMission_end = 0;	// sideMission - Complete game when 'tg_mainMission_cmp' equals 'tg_sideMission_end'
//tg_sideMission_cmp = 0;	// sideMission - Counter of completions
tg_sideMission_max = 3;	// sideMission - Max no missions to be active at any time
//tg_sideMission_last = "";	// sideMission - Last selected mission

tg_mainMission_end = 5;	// mainMission - Complete game when 'tg_mainMission_cmp' equals 'tg_mainMission_end'
//tg_mainMission_cmp = 0;	// mainMission - Counter of completions
tg_mainMission_max = 1;	// mainMission - Max no missions to be active at any time
//tg_mainMission_last = "";	// mainMission - Last selected mission

tg_playerSide = "GUER"; // The side players are on (used in triggers detection) (WEST/EAST/GUER)
tg_missions_active = []; // Array currently active tasks [uniqueTaskName,taskType]
tg_counter = 1; // Internal mission number counter - Unique number for each generated mission.
tg_debug = true; // Debug Mode
tg_threadFree = true; // Flag to queue processing of tasks.


// ----------- FUNCTIONS START ---------------

// Compile Functions
if (isNil("tg_fn_debugMsg")) then {tg_fnc_debugMsg = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_debugMsg.sqf", tg_taskFolder]; };
if (isNil("tg_fn_nameGenerator")) then {tg_fnc_nameGenerator = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_nameGenerator.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_missionEnd")) then {tg_fnc_missionEnd = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_missionEnd.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_missionSelect")) then {tg_fnc_missionSelect = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_missionSelect.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findWorldLocation")) then {tg_fnc_findWorldLocation = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findWorldLocation.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findEmptyByType")) then {tg_fnc_findEmptyByType = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findEmptyByType.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findRandomEmpty")) then {tg_fnc_findRandomEmpty = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findRandomEmpty.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findRandomMarker")) then {tg_fnc_findRandomMarker = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findRandomMarker.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_inSafeZone")) then {tg_fnc_inSafeZone = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_inSafeZone.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_spawnDACzone")) then {tg_fnc_spawnDACzone = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_spawnDACzone.sqf", tg_taskFolder]; };

// ----------- PREP ---------------

// Markers for any pre-determined locations. stored under 'tg_<Type>_markers'
{
	_type = _x;
	_typeArray = [];
	
	{
		// Mission Markers
		if ([toLower _type, toLower _x] call BIS_fnc_inString) then {
		   _typeArray pushBack _x;
		};		
	} forEach allMapMarkers;
	
	missionNamespace setVariable [format["tg_%1_markers", _type], _typeArray];
	if (count _typeArray == 0) then { [format["[TG-init] WARNING: '%1' markers: None found, random will be used!", _type]] call BIS_fnc_error; };
	//[format ["[TG-init] DEBUG: '%1' markers: %2", _type, count _typeArray]] call tg_fnc_debugMsg;
	//[format ["[TG-init] DEBUG: '%1' missions: %2", _type, count (missionNamespace getVariable [format["tg_%1_list",_type],[]])]] call tg_fnc_debugMsg;
} forEach tg_missionTypes;

// Blacklist for any pre-determined locations used in tg_fnc_findRandomEmpty.
_blackMkr = [];
_blackList = [];
{	
	// Safe Zone Blacklist
	if (["safezone", toLower _x] call BIS_fnc_inString) then {
	   _blackMkr pushBack _x;
	};
} forEach allMapMarkers;

{
	_bPos =  getMarkerPos _x;
	_bSize = getMarkerSize _x;
	
	_blackUL = [(_bPos select 0) - (_bSize select 0), (_bPos select 1) + (_bSize select 1), 0];
	_blackDR = [(_bPos select 0) + (_bSize select 0), (_bPos select 1) - (_bSize select 1), 0];
	
	/*if tg_debug then {
		_tmpMkr = createMarkerLocal[format["markerUL_%1", _forEachIndex], _blackUL];
		_tmpMkr setMarkerTextLocal format["markerUL_%1", _forEachIndex];
		_tmpMkr setMarkerShapeLocal "ICON";
		_tmpMkr setMarkerColorLocal "colorOrange";
		_tmpMkr setMarkerSizeLocal [1,1];
		_tmpMkr setMarkerTypeLocal "mil_dot";
		
		_tmpMkr = createMarkerLocal[format["markerDR_%1", _forEachIndex], _blackDR];
		_tmpMkr setMarkerTextLocal format["markerDR_%1", _forEachIndex];
		_tmpMkr setMarkerShapeLocal "ICON";
		_tmpMkr setMarkerColorLocal "colorYellow";
		_tmpMkr setMarkerSizeLocal [1,1];
		_tmpMkr setMarkerTypeLocal "mil_dot";
	};*/
	
	_blackList pushBack [_blackUL, _blackDR];
} forEach _blackMkr;

missionNamespace setVariable ["tg_blackList",_blackList];

sleep 3; 

// ----------- DEBUG ---------------

[] spawn {
	while{true} do {
		hintSilent parseText format["[TG]<br/>Active Missions: %1<br/>%2<br/><br/>Lock<br/>%3<br/>", count tg_missions_active, tg_missions_active, tg_threadFree];
		sleep 0.5;
	};
};

// ----------- MAIN START ---------------

[] spawn tg_fnc_missionSelect;



/*
// Make sure we have some valid locations!

*/
// TODO: Default to random if not needed?


// ----------- MISSION CREATION START ---------------
