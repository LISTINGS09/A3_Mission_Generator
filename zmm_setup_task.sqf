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

// Find a Main Objective
_objectives = [];

_centre = missionNamespace getVariable [ format[ "ZMM_%1_Location", _zoneID ], [0,0,0] ];
_side = missionNamespace getVariable [ format[ "ZMM_%1_EnemySide", _zoneID ], EAST ];
_radius = (getMarkerSize format["MKR_%1_MIN", _zoneID]) select 0;
_locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
_locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

// Fill Objectives - Building
_allBlds = nearestObjects [_centre, ["building"], _radius - 50, TRUE];
_lrgBlds = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], (_allBlds select {count (_x buildingPos -1) >= 4}) ]; // Get Large Buildings

if (count _allBlds > 0) then {
	if (count _lrgBlds > 0) then {
		_objectives pushBack [[_zoneID, selectRandom _lrgBlds],"kill_hvt.sqf"];
		_objectives pushBack [[_zoneID, selectRandom _lrgBlds],"rescue_hvt.sqf"];
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

// Fill Objectives - Flat Areas
_locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], []];
if (count _locations > 0) then {
	_objectives pushBack [[_zoneID, selectRandom _locations], "collect_crashsite.sqf"];
	_objectives pushBack [[_zoneID, selectRandom _locations], "destroy_tower.sqf"];
	_objectives pushBack [[_zoneID, selectRandom _locations], "destroy_camp.sqf"];
	_objectives pushBack [[_zoneID, selectRandom _locations], "rescue_minefield.sqf"];
};

// Fill Objectives - Roads
for [{_i = 25}, {_i <= (_radius / 1.5)}, {_i = _i + 25}] do {
	_roads = (_centre nearRoads _i) select { count (roadsConnectedTo _x) > 0};
	
	if (count _roads > 0) exitWith {
		_objectives pushBack [[_zoneID, position (selectRandom _roads)], "destroy_vehicle.sqf"];
		_objectives pushBack [[_zoneID, position (selectRandom _roads)], "destroy_convoy.sqf"];
		_objectives pushBack [[_zoneID, position (selectRandom _roads)], "capture_vehicle.sqf"];
		_objectives pushBack [[_zoneID, position (selectRandom _roads)], "rescue_ambush.sqf"];
		_objectives pushBack [[_zoneID, position (selectRandom _roads)], "rescue_transport.sqf"];
	}; 
};

// Fill Objectives - Anywhere
if (count (missionNamespace getVariable [ format["ZMM_%1_QRFLocations", _zoneID], [] ]) > 0 && !_isCTI) then { _objectives pushBack [[_zoneID], "defend_location.sqf", [300, FALSE, FALSE]]; }; // Never defend in a CTI.
_objectives pushBack [[_zoneID], "clear_location.sqf", [900]];
_objectives pushBack [[_zoneID], "kill_group.sqf"];
_objectives pushBack [[_zoneID], "collect_items.sqf"];
_objectives pushBack [[_zoneID], "destroy_cache.sqf"];
_objectives pushBack [[_zoneID], "download_data.sqf"];
_objectives pushBack [[_zoneID], "upload_data.sqf"];
_objectives pushBack [[_zoneID], "collect_paradrop.sqf"];

// Fill Objectives - Special Locations
switch _locType do {
	case "Airport": {
		
	};
};

switch _locName do {
	case "AAC airfield";
	case "Airfield";
	case "Stratis Air Base";
	case "Molos Airfield";
	case "Stratis Air Base": {
		
	};
};


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

["DEBUG", format["Zone%1 - Creating Objective %2 at %3", _zoneID, _script, _locName]] call zmm_fnc_logMsg;

_result = _args execVM format["%1\tasks\%2", ZMM_FolderLocation, _script];

/* execVM doesn't return values?
if !_result then {
	["ERROR", format["Failed to Create: %1", _script]] call zmm_fnc_logMsg;
	[_zoneID] call zmm_fnc_setupTask;
};*/

TRUE