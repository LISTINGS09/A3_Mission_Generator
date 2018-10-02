// Iterates the Zone and selects a suitable objective.
if !isServer exitWith {};

params [ "_zoneID" ];

// Are we in CTI Mode?
_isCTI = (missionNamespace getVariable ["ZZM_Mode", 0]) > 0;

// Zone not defined - Pick a random one.
if (isNil "_zoneID") then {
	_markersAll = missionNamespace getVariable ["ZMM_ZoneMarkers", []];
	_markersFar = [];
	
	if (_markersAll isEqualTo []) exitWith {}; // No markers so just exit.
	
	{
		_mkr = _x;
		if ((playableUnits + switchableUnits) findIf { _x distance (getmarkerPos _mkr) < 1500 } isEqualTo -1) then { _markersFar pushBack _mkr };
	} forEach _markersAll;
	
	_foundZone = selectRandom _markersAll;
	
	if !(_markersFar isEqualTo []) then { _foundZone = selectRandom _markersFar };
	
	ZMM_ZoneMarkers = ZMM_ZoneMarkers - [_foundZone];
	
	_zoneID = parseNumber ((_foundZone splitString "_") select 1);
};

if (isNil "_zoneID") exitWith { ["ERROR", "Invalid Objective Zone"] call zmm_fnc_logMsg };

// Set global mission variable to FALSE.
missionNamespace setVariable ["ZMM_DONE", FALSE, TRUE];

// Create Insert/Exfil Tasks
_lzLocs = missionNamespace getVariable [ format["ZMM_%1_LZLocations", _zoneID], [] ];

/* Disabled INFIL/EXFIL Objectives
if (count _lzLocs > 0 && !_isCTI) then {
	// Mark Insertion.
	_posInsert = [selectRandom _lzLocs, random 50, random 360] call BIS_fnc_relPos;
	_mrkr = createMarker [format["MKR_%1_START", _zoneID], _posInsert];
	_mrkr setMarkerPos _posInsert;
	_mrkr setMarkerType "mil_start";
	_mrkr setMarkerText "Insert";
	_mrkr setMarkerColor format["Color%1",ZMM_playerSide];
	
	// Insertion Task
	_insertTrg = createTrigger ["EmptyDetector", _posInsert, FALSE];
	_insertTrg setTriggerArea [75, 75, 0, FALSE, 100];
	_insertTrg setTriggerActivation ["ANYPLAYER", "PRESENT", FALSE];
	_insertTrg setTriggerStatements ["this", 
									 format["'MKR_%1_START' setMarkerColor 'ColorGrey'; ['ZMM_%1_TaskInsert', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState;", _zoneID],
									 ""];
	
	_insertTask = [format["ZMM_%1_TaskInsert", _zoneID], TRUE, ["Insert at the location to begin the mission.", "Insertion", format["MKR_%1_START", _zoneID]], objNull, "CREATED", 1, FALSE, TRUE, "getin"] call BIS_fnc_setTask;

	// Mark Extraction.	
	_posExfil = [selectRandom _lzLocs, random 50, random 360] call BIS_fnc_relPos;
	_mrkr = createMarker [format["MKR_%1_END", _zoneID], _posExfil];
	_mrkr setMarkerPos _posExfil;
	_mrkr setMarkerType "mil_end";
	_mrkr setMarkerText "Exfil";
	_mrkr setMarkerColor format["Color%1",ZMM_playerSide];
	
	// Exfil Task
	_exfilTsk = createTrigger ["EmptyDetector", _posExfil, FALSE];
	_exfilTsk setTriggerStatements [format["(missionNamespace getVariable ['ZMM_DONE', FALSE] || missionNamespace getVariable ['ZMM_%1_FAIL', FALSE])", _zoneID], 
									format["['ZMM_%1_TaskExfil', TRUE, ['Extract to the marked location and RTB.', 'Extract', 'MKR_%1_END'], objNull, 'ASSIGNED', 1, TRUE, TRUE, 'exit'] call BIS_fnc_setTask;", _zoneID], 
									""];
	
	_exfilTrg = createTrigger ["EmptyDetector", _posExfil, FALSE];
	_exfilTrg setTriggerArea [75, 75, 0, FALSE, 100];
	_exfilTrg setTriggerActivation ["ANYPLAYER", "PRESENT", FALSE];
	_exfilTrg setTriggerStatements [format["(missionNamespace getVariable ['ZMM_DONE', FALSE] || missionNamespace getVariable ['ZMM_%1_FAIL', FALSE]) && this", _zoneID], 
									format["'MKR_%1_END' setMarkerColor 'ColorGrey'; ['ZMM_%1_TaskExfil', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; 
									if (missionNamespace getVariable ['ZMM_%1_Failed', FALSE]) then { 
										playSound selectRandom ['cp_exfil_successful_primary_failed_1', 'cp_exfil_successful_primary_failed_2', 'cp_exfil_successful_primary_failed_3'];
									} else { 
										playSound selectRandom ['cp_exfil_successful_primary_done_1', 'cp_exfil_successful_primary_done_2', 'cp_exfil_successful_primary_done_3'];
									}", _zoneID], 
									""];
};
*/

// Find a Main Objective
_objectives = [];

_centre = missionNamespace getVariable [ format[ "ZMM_%1_Location", _zoneID ], [0,0,0] ];
_side = missionNamespace getVariable [ format[ "ZMM_%1_EnemySide", _zoneID ], EAST ];
_pSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_radius = (getMarkerSize format["MKR_%1_MIN", _zoneID]) select 0;

// Get Location Name
_nearLoc = nearestLocation [_centre, ""];
_locName = if (getPos _nearLoc distance2D _centre < 200) then { text _nearLoc } else { "this Location" };

// Fill Objectives - Building
_allBlds = nearestObjects [_centre, ["building"], _radius - 50, TRUE];
_lrgBlds = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], (_allBlds select {count (_x buildingPos -1) >= 4}) ]; // Get Large Buildings

if (count _allBlds > 0) then {
	if (count _lrgBlds > 0) then {
		_objectives pushBack [[_zoneID, selectRandom _lrgBlds],"hvt_kill.sqf"];
		_objectives pushBack [[_zoneID, selectRandom _lrgBlds],"hvt_rescue.sqf"];
	};
	
	// Special Building Objective Types
	{
		_x params ["_bldTypes","_execScript"];
		
		_objBlds = _allBlds select {typeOf _x in _bldTypes};
		
		if (count _objBlds > 0) then { _objectives pushBack [[_zoneID, selectRandom _objBlds], _execScript] };
	} forEach [
		// Destroy Objectives
		[
			[
				"Land_Research_house_V1_F", "Land_Research_HQ_F", "Land_dp_bigTank_F", "Land_dp_smallTank_F", "Land_ReservoirTank_V1_F", "Land_ReservoirTank_Airport_F", 
				"Land_ReservoirTank_Rust_F", "Land_ReservoirTank_01_military_F", "Land_Radar_F", "Land_Radar_Small_F", "Land_TTowerBig_1_F", "Land_TTowerBig_2_F", "Land_Communication_F"
			],
			"destory_target.sqf"
		],
		// Clearing Objectives
		[
			[
				"Land_DPP_01_mainFactory_F", "Land_Bunker_01_HQ_F", "Land_WIP_F", "Land_Factory_Main_F", "Land_dp_mainFactory_F", "Land_House_Big_04_F", "Land_House_Big_03_F", 
				"Land_School_01_F", "Land_MilOffices_V1_F", "Land_Offices_01_V1_F", "Land_i_Barracks_V1_F", "Land_i_Barracks_V2_F", "Land_u_Barracks_V2_F", "Land_Barracks_01_dilapidated_F", 
				"Land_Barracks_01_grey_F", "Land_Barracks_01_camo_F"
			], 
			"clear_building.sqf"
		]
	];		
};


// Fill Objectives - Flat Area
_hasFlat = FALSE;
for [{_i = 0}, {_i < 360 && !_hasFlat}, {_i = _i + 1}] do {
	for [{_j = 10}, {_j <= (_radius / 1.5)}, {_j = _j + 10}] do {
		private	_tempPos = [_centre, _j, _i] call BIS_fnc_relPos;
		
		_emptyLoc = _tempPos isFlatEmpty [10, -1, 0.3, 5, 0, FALSE];
		
		if (count _emptyLoc > 0) exitWith {			
			_hasFlat = TRUE;
			_objectives pushBack [[_zoneID, _emptyLoc], "crash_site.sqf"];
			_objectives pushBack [[_zoneID, _emptyLoc], "destroy_tower.sqf"];
			_objectives pushBack [[_zoneID, _emptyLoc], "destroy_camp.sqf"];
		};
	};
};

// Fill Objectives - Roads
for [{_i = 25}, {_i <= (_radius / 1.5)}, {_i = _i + 25}] do {
	_roads = (_centre nearRoads _i) select { count (roadsConnectedTo _x) > 0};
	
	if (count _roads > 0) exitWith {
		_objectives pushBack [[_zoneID, position (selectRandom _roads)], "vehicle_destroy.sqf"];
		_objectives pushBack [[_zoneID, position (selectRandom _roads)], "vehicle_capture.sqf"];
	}; 
};

// Fill Objectives - Anywhere
if (count (missionNamespace getVariable [ format["ZMM_%1_QRFLocations", _zoneID], [] ]) > 0 && !_isCTI) then { _objectives pushBack [[_zoneID], "defend_location.sqf", [300, FALSE, FALSE]]; }; // Never defend in a CTI.
_objectives pushBack [[_zoneID], "clear_location.sqf", [900]];
_objectives pushBack [[_zoneID], "group_kill.sqf"];
_objectives pushBack [[_zoneID], "destroy_cache.sqf"];
_objectives pushBack [[_zoneID], "download_data.sqf"];
_objectives pushBack [[_zoneID], "upload_data.sqf"];
_objectives pushBack [[_zoneID], "paradrop.sqf"];

if (count _objectives == 0) exitWith { 
	["ERROR", format["No objectives for Zone %1 (%2, %3)", _zoneID, _locName, _centre]] call zmm_fnc_logMsg;
};

// Get any custom parameters from the task.
(selectRandom _objectives) params ["_args", "_script", ["_overWrite", []]];

// Set custom parameters (e.g. defence missions have no AI patrols etc).
if (count _overWrite > 0) then {
	_overWrite params [["_qrfTime", 600], ["_patrols", TRUE], ["_garrison", TRUE] ];
	
	if !(_qrfTime isEqualTo 600) then { missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], _qrfTime] };
	if !_patrols then { missionNamespace setVariable [format[ "ZMM_%1_Patrols", _zoneID ], FALSE] };
	if !_garrison then { missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], 0] };	
};

["DEBUG", format["Creating Objective %1 at %2", _script, _locName]] call zmm_fnc_logMsg;

_nul = _args execVM format["%1\tasks\%2", ZMM_FolderLocation, _script];

TRUE