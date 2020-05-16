// Iterates the Zone and selects a suitable objective.
if !isServer exitWith {};

params [ "_zoneID", ["_filterTask", ""] ];

// Are we in CTI Mode?
_isCTI = ZZM_Mode == 1;

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

// Set global mission variable to false.
missionNamespace setVariable ["ZMM_DONE", false, true];

// Find a Main Objective
_objectives = [];

_centre = missionNamespace getVariable [ format[ "ZMM_%1_Location", _zoneID ], [0,0,0] ];
_side = missionNamespace getVariable [ format[ "ZMM_%1_EnemySide", _zoneID ], EAST ];
_radius = (getMarkerSize format["MKR_%1_MIN", _zoneID]) select 0;
_locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
_locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

// Fill Objectives - Building
_allBlds = nearestObjects [_centre, ["building"], _radius - 50, true];
_lrgBlds = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], (_allBlds select {count (_x buildingPos -1) >= 4}) ]; // Get Large Buildings

if (count _allBlds > 0) then {
	if (count _lrgBlds > 0) then {
		_objectives pushBack ["Denial", [_zoneID, selectRandom _lrgBlds],"kill_hvt.sqf"];
		_objectives pushBack ["Rescue", [_zoneID, selectRandom _lrgBlds],"rescue_prisoner.sqf"];
	};
	
	// Special Building Objective Types
	{
		_x params ["_type", "_bldTypes","_execScript"];
		
		_objBlds = _allBlds select {typeOf _x in _bldTypes};
		
		if (count _objBlds > 0) then { _objectives pushBack [_type, [_zoneID, selectRandom _objBlds], _execScript] };
	} forEach [
		// Destroy Objectives
		[
			"Denial",
			[
				"Land_Research_house_V1_F", "Land_Research_HQ_F", "Land_dp_bigTank_F", "Land_dp_smallTank_F", "Land_ReservoirTank_V1_F", "Land_ReservoirTank_Airport_F", 
				"Land_ReservoirTank_Rust_F", "Land_ReservoirTank_01_military_F", "Land_Radar_F", "Land_Radar_Small_F", "Land_TTowerBig_1_F", "Land_TTowerBig_2_F", "Land_Communication_F"
			],
			"destroy_target.sqf"
		],
		// Clearing Objectives
		[
			"Secure",
			[
				"Land_DPP_01_mainFactory_F", "Land_Bunker_01_HQ_F", "Land_WIP_F", "Land_Factory_Main_F", "Land_dp_mainFactory_F", "Land_House_Big_04_F", "Land_House_Big_03_F", 
				"Land_School_01_F", "Land_MilOffices_V1_F", "Land_Offices_01_V1_F", "Land_i_Barracks_V1_F", "Land_i_Barracks_V2_F", "Land_u_Barracks_V2_F", "Land_Barracks_01_dilapidated_F", 
				"Land_Barracks_01_grey_F", "Land_Barracks_01_camo_F"
			], 
			"clear_building.sqf"
		]
	];		
};

// Fill Objectives - Flat Areas
_locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], []];
if (count _locations > 0) then {
	_objectives pushBack ["Recovery", [_zoneID, selectRandom _locations], "collect_crashsite.sqf"];
	_objectives pushBack ["Denial", [_zoneID, selectRandom _locations], "destroy_tower.sqf"];
	_objectives pushBack ["Denial", [_zoneID, selectRandom _locations], "destroy_camp.sqf"];
	_objectives pushBack ["Rescue", [_zoneID, selectRandom _locations], "rescue_minefield.sqf"];
};

// Fill Objectives - Roads
for [{_i = 25}, {_i <= (_radius / 1.5)}, {_i = _i + 25}] do {
	_roads = (_centre nearRoads _i) select { count (roadsConnectedTo _x) > 0};
	
	if (count _roads > 0) exitWith {
		_objectives pushBack ["Denial", [_zoneID, position (selectRandom _roads)], "destroy_vehicle.sqf"];
		_objectives pushBack ["Denial", [_zoneID, position (selectRandom _roads)], "destroy_convoy.sqf"];
		_objectives pushBack ["Secure", [_zoneID, position (selectRandom _roads)], "disarm_ied.sqf"];
		_objectives pushBack ["Recovery", [_zoneID, position (selectRandom _roads)], "capture_vehicle.sqf"];
		_objectives pushBack ["Rescue", [_zoneID, position (selectRandom _roads)], "rescue_ambush.sqf"];
		_objectives pushBack ["Rescue", [_zoneID, position (selectRandom _roads)], "rescue_transport.sqf"];
	}; 
};

// Fill Objectives - Anywhere
if (count (missionNamespace getVariable [ format["ZMM_%1_QRFLocations", _zoneID], [] ]) > 0 && !_isCTI) then { _objectives pushBack ["Defence", [_zoneID], "defend_location.sqf", [300, false, false, false]]; }; // Never defend in a CTI.
_objectives pushBack ["Secure", [_zoneID], "clear_location.sqf", [900]];
_objectives pushBack ["Denial", [_zoneID], "kill_group.sqf"];
_objectives pushBack ["Secure", [_zoneID], "clear_uprising.sqf"];
_objectives pushBack ["Secure", [_zoneID], "disarm_uxo.sqf"];
_objectives pushBack ["Secure", [_zoneID], "kill_animal.sqf"];
_objectives pushBack ["Recovery", [_zoneID], "collect_items.sqf"];
_objectives pushBack ["Recovery", [_zoneID], "collect_container.sqf"];
_objectives pushBack ["Recovery", [_zoneID], "collect_weapon.sqf"];
_objectives pushBack ["Recovery", [_zoneID], "collect_backpack.sqf"];
_objectives pushBack ["Secure", [_zoneID], "disarm_bomb.sqf"];
//_objectives pushBack ["Secure", [_zoneID], "disarm_crater.sqf"]; // Crater Sitet
_objectives pushBack ["Denial", [_zoneID], "destroy_cache.sqf"];
_objectives pushBack ["Intel", [_zoneID], "intel_download.sqf"];
_objectives pushBack ["Intel", [_zoneID], "intel_upload.sqf"];
_objectives pushBack ["Intel", [_zoneID], "intel_talk.sqf"];
_objectives pushBack ["Intel", [_zoneID], "intel_garbage.sqf"];
//_objectives pushBack ["Intel", [_zoneID], "intel_group.sqf"];
_objectives pushBack ["Recovery", [_zoneID], "collect_paradrop.sqf"];

// Fill Objectives - Special Locations
switch _locType do {
	case "Airport": {
		// Large Base Objective?
	};
};

switch _locName do {
	case "AAC airfield";
	case "Airfield";
	case "Stratis Air Base";
	case "Molos Airfield";
	case "Stratis Air Base": {
		// Large Base Objective?
	};
};

// If we've no objectives, exit
if (count _objectives == 0) exitWith { 
	["ERROR", format["Zone%1 - No objectives (%2, %3)", _zoneID, _locName, _centre]] call zmm_fnc_logMsg;
};

// If tasks are to be filtered, only get the ones that match the type
if (_filterTask != "") then {
	_filterObjectives = _objectives select { toUpper (_x#0) == toUpper _filterTask };	
	if (count _filterObjectives > 0) then { _objectives = _filterObjectives };
};

// Get any custom parameters from the task.
(selectRandom _objectives) params ["_type", "_args", "_script", ["_overWrite", []]];

// Set custom parameters (e.g. defence missions have no AI patrols etc).
if (count _overWrite > 0) then {
	_overWrite params [["_qrfTime", 600], ["_patrols", true], ["_garrison", true], ["_roadblock", true] ];
	
	if !(_qrfTime isEqualTo 600) then { missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], _qrfTime] };
	if !_patrols then { missionNamespace setVariable [format[ "ZMM_%1_Patrols", _zoneID ], false] };
	if !_garrison then { missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], 0] };	
	if !_roadblock then { missionNamespace setVariable [format[ "ZMM_%1_Roadblocks", _zoneID ], 0] };	
};

_result = _args call compile preprocessFileLineNumbers format["%1\tasks\%2", ZMM_FolderLocation, _script];

if !_result then {
	["ERROR", format["Zone%1 - Failed to create: %1", _zoneID, _script]] call zmm_fnc_logMsg;
	[_zoneID, _filterTask] call zmm_fnc_setupTask;
} else {
	["DEBUG", format["Zone%1 - Created Objective %2 [%3] - (Wanted: %5 Got: %2 ) at %4", _zoneID, _type, _script, _locName, _filterTask]] call zmm_fnc_logMsg;
	if (_type != _filterTask && _filterTask != "") then {
		["INFO", format["Zone%1 - No suitable location for the Mission, %2 was selected instead!", _zoneID, _type]] call zmm_fnc_logMsg;
	};
};

true