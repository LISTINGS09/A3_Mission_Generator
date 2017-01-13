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
tg_missionTypes = ["mainMission", "sideMission"]; // Used globally and variables are built from these strings.. // 

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
tg_sideMission_max = 4;	// sideMission - Max no missions to be active at any time
tg_sideMission_dist = 1500; // Used in fn_isNearMission - New Missions will not be within this distance from others.
//tg_sideMission_last = "";	// sideMission - Last selected mission

//tg_sideWest = [west, [1, 1, 1, (selectRandom [1, 5, 9])]]; // West Side & DAC settings (NATO).
//tg_sideWest = [west, [1, 6, 1, (selectRandom [1, 5, 9])]]; // West Side & DAC settings (NATO PACIFIC).
//tg_sideWest = [west, [1, 7, 1, (selectRandom [1, 5, 9])]]; // West Side & DAC settings (NATO CTRG PACIFIC).
//tg_sideWest = [west, [1, 11, 1, (selectRandom [3, 7, 11])]];	// West Side & DAC settings (FIA).
//tg_sideEast = [east, [0, 0, 0, (selectRandom [0, 4, 8])]]; // East Side & DAC settings (CSAT).
tg_sideEast = [east, [0, 4, 0, (selectRandom [0, 4, 8])]]; // East Side & DAC settings (CSAT PACIFIC).
//tg_sideEast = [east, [0, 5, 0, (selectRandom [0, 4, 8])]]; // East Side & DAC settings (CSAT VIPER).
//tg_sideEast = [east, [0, 10, 0, (selectRandom [0, 4, 8])]]; // East Side & DAC settings (FIA).
//tg_sideGuer = [independent, [2, 2, 2, (selectRandom [2, 6, 10])]]; // Guer Side & DAC settings (AAF).
tg_sideGuer = [independent, [2, 8, 2, (selectRandom [2, 6, 10])]]; // Guer Side & DAC settings (SYND).
//tg_sideGuer = [independent, [2, 9, 2, (selectRandom [2, 6, 10])]]; // Guer Side & DAC settings (PARA).
//tg_sideGuer = [independent, [2, 12, 2, (selectRandom [2, 6, 10])]]; // Guer Side & DAC settings (FIA).


tg_mainMission_end = 10;	// mainMission - Complete game when 'tg_mainMission_cmp' equals 'tg_mainMission_end'
tg_mainMission_dist = 3000; // Used in fn_isNearMission - New Missions will not be within this distance from others.
//tg_mainMission_cmp = 0;	// mainMission - Counter of completions
tg_mainMission_max = 2;	// mainMission - Max no missions to be active at any time
//tg_mainMission_last = "";	// mainMission - Last selected mission

tg_playerSide = west; // The side players are on (used in triggers detection) MUST BE: west/east/resistance
tg_missions_active = []; // Array currently active tasks [uniqueTaskName,taskType]
tg_separateMarkers = false; // Should markers be split by tg_missionTypes? (Allows for specific locations for side and main missions)

tg_debug = true; // Debug Mode
tg_taskDelay = 5; // Seconds to wait after completing tasks (60 default).

tg_counter = 1; // Internal mission number counter - Unique number for each generated mission, don't change this.
tg_threadFree = true; // Internal flag to queue processing of tasks, don't change this.


// ----------- FUNCTIONS START ---------------

// Compile Functions
if (isNil("tg_fnc_balanceUnits")) then {tg_fnc_balanceUnits = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_balanceUnits.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_debugMsg")) then {tg_fnc_debugMsg = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_debugMsg.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findEmptyByType")) then {tg_fnc_findEmptyByType = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findEmptyByType.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findRandomEmpty")) then {tg_fnc_findRandomEmpty = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findRandomEmpty.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findRandomMarker")) then {tg_fnc_findRandomMarker = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findRandomMarker.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findSide")) then {tg_fnc_findSide = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findSide.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findWorldLocation")) then {tg_fnc_findWorldLocation = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findWorldLocation.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_inSafeZone")) then {tg_fnc_inSafeZone = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_inSafeZone.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_isNearMission")) then {tg_fnc_isNearMission = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_isNearMission.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_isNearPlayer")) then {tg_fnc_isNearPlayer = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_isNearPlayer.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_missionEnd")) then {tg_fnc_missionEnd = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_missionEnd.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_missionSelect")) then {tg_fnc_missionSelect = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_missionSelect.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_nameGenerator")) then {tg_fnc_nameGenerator = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_nameGenerator.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_spawnDACzone")) then {tg_fnc_spawnDACzone = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_spawnDACzone.sqf", tg_taskFolder]; };

// ----------- PREP ---------------


// TODO split markers down to side > type, copy markers to all sides if settings not chosen.
// Color indicates side.
// Text indicates type.

// Markers for any pre-determined locations. stored under 'tg_<Type>_markers'
{
	private _type = _x;
	private _typeArray = [];
	
	{
		// Mission Markers
		if ([toLower _type, toLower _x] call BIS_fnc_inString) then {
		   _typeArray pushBack _x;
		};		
	} forEach allMapMarkers;
	
	missionNamespace setVariable [format["tg_%1_markers", _type], _typeArray];
	if (count _typeArray == 0) then {
		[format["[TG-init] ERROR: No markers for '%1'", _type]] call tg_fnc_debugMsg; 
	};
	//[format ["[TG-init] DEBUG: '%1' markers: %2", _type, count _typeArray]] call tg_fnc_debugMsg;
	//[format ["[TG-init] DEBUG: '%1' missions: %2", _type, count (missionNamespace getVariable [format["tg_%1_list",_type],[]])]] call tg_fnc_debugMsg;
} forEach tg_missionTypes;

// Blacklist for any pre-determined locations used in tg_fnc_findRandomEmpty.
private _blackMkr = [];
private _blackList = [];

{	
	// Safe Zone Blacklist
	if (["safezone", toLower _x] call BIS_fnc_inString) then {
	   _blackMkr pushBack _x;
	};
} forEach allMapMarkers;

{
	private _bPos =  getMarkerPos _x;
	private _bSize = getMarkerSize _x;
	
	private _blackUL = [(_bPos select 0) - (_bSize select 0), (_bPos select 1) + (_bSize select 1), 0];
	private _blackDR = [(_bPos select 0) + (_bSize select 0), (_bPos select 1) - (_bSize select 1), 0];
	
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

// Make sure player side settings are correct.
{
	if (side _x != tg_playerSide && side _x in [west, east, independent]) exitWith {
		[format["[TG-init] WARNING: %1's side does not match tg_playerSide (%2 vs %3)", _x, side _x, tg_playerSide]] call tg_fnc_debugMsg; 
	};
} forEach playableUnits	 + switchableUnits;

// ----------- DEBUG ---------------

[] spawn {
	while{true} do {
		hintSilent parseText format["[TG]<br/>Active Missions: %1<br/>Main: %2 Side: %3<br/><br/>Thread: %4<br/>Complete: %5<br/>",
			count tg_missions_active,
			{_x select 0 == tg_missionTypes select 0} count tg_missions_active,
			{_x select 0 == tg_missionTypes select 1} count tg_missions_active,
			['Locked','Free'] select tg_threadFree,
			missionNamespace getVariable [format["tg_%1_cmp", tg_missionTypes select 0],0]
		];
		
		sleep 0.5;
	};
};

// ----------- MAIN START ---------------
// Call the mission selection function.
[] spawn tg_fnc_missionSelect;