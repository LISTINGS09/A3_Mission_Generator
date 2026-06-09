// Spawns a markers/missions over all locations in a world.
// [thisTrigger, "Task", 50, "Hill 241", "Task", "Building"] spawn zmm_fnc_setupZone;
if !isServer exitWith {};
params [ ["_pos", [0,0,0]], ["_locType", "Custom"], ["_radius", 150], ["_locName", "Unnamed"], ["_orgType", "Custom"], ["_forceTask", ""] ];

// Convert position if wrong type.
switch (typeName _pos) do {
	case "STRING": {_pos = getMarkerPos _pos};
	case "OBJECT": {_pos = getPos _pos};
};

_pos set [2,0];

// Set default trigger radius
private _triggerRadius = ((_radius * 5) max 1500) min 3000;

// Set the Zone ID - Used to reference the area in-mission.
private _zoneID = (missionNamespace getVariable ["ZZM_zoneID",0]) + 1;	// Unique per instance.	
missionNamespace setVariable ["ZZM_zoneID", _zoneID]; // Set Current Zone ID	
missionNamespace setVariable [format["ZMM_%1_Location", _zoneID], _pos]; // Set Zone Centre
missionNamespace setVariable [format["ZMM_%1_Name", _zoneID], _locName]; // Set Zone Name
missionNamespace setVariable [format["ZMM_%1_Radius", _zoneID], _radius]; // Set Zone Radius
missionNamespace setVariable [format["ZMM_%1_Type", _zoneID], [_orgType, _locType] select (_orgType isEqualTo "")]; // Set Zone Type (Original)

// Find a suitable enemy side.
private _side = [ _pos, _radius * 5] call zmm_fnc_misc_findEnemySide;
missionNamespace setVariable [format["ZMM_%1_EnemySide", _zoneID], _side]; // Set Side

["DEBUG", format["Zone%1 - Setup Zone - Creating [%2] %6 (%3) %4 TR:%5m [%7]", _zoneID, _side, _locType, _pos, _triggerRadius, _locName, _forceTask]] call zmm_fnc_misc_logMsg;

private _difficulty = missionNamespace getVariable ["ZZM_Diff", 1];

// Location scaling
private _locLevel = switch (_locType) do {
	case "Airport": { 12 };
	case "NameCityCapital": { 12 };
	case "NameCity": { 10 };
	case "NameVillage": { 8 };
	case "NameLocal": { 6 };
	case "Task": { 6 };
	case "Custom": { 6 };
	default { 4 }; // Ambient
};

_locLevel = _locLevel * (0.75 + (_difficulty * 0.25));;

private _iconSize = linearConversion [  4, 12, _locLevel, 0.4, 1.2, true];
private _locSize = linearConversion [ 4, 12, _locLevel, 0.75, 1.25, true ];

private _zonePatrol = true;
private _zoneGarrison = round linearConversion [ 4,	12,	_locLevel,	15 + random 5,	45 + random 10,	true ];
private _zoneRoadblocks = round linearConversion [ 4, 12, _locLevel, random 1, 2 + random 2, true ];
private _zoneSupport = round linearConversion [ 4, 12, _locLevel, random 1, 2 + random 2, true ];
private _zoneQRFTime = round linearConversion [ 4, 12, _locLevel, 1200, 300, true ];
private _zoneQRFWaves = round linearConversion [ 4, 12, _locLevel, 0, 8, true ];
private _zoneIEDs = round linearConversion [ 4, 12, _locLevel, 0, 3, true ];

// Ambient zones have no QRF
if (_locType isEqualTo "Ambient") then { _zoneQRFTime = 0; _zoneQRFWaves = 0 };

// IEDs for GUER only.
if (_side != INDEPENDENT) then { _zoneIEDs = 0 }; 

missionNamespace setVariable [format[ "ZMM_%1_Patrols", _zoneID ], true ];
missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], _zoneGarrison ];
missionNamespace setVariable [format[ "ZMM_%1_Roadblocks", _zoneID ], _zoneRoadblocks ];
missionNamespace setVariable [format[ "ZMM_%1_Supports", _zoneID ], _zoneSupport];
missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], _zoneQRFTime ];
missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], _zoneQRFWaves ];
missionNamespace setVariable [format[ "ZMM_%1_IEDs", _zoneID ], _zoneIEDs];

["DEBUG", format["Zone%1 - Setup Zone - %2 (Level %9) - %3%4%5%6%7%8", _zoneID, _locType, _side,
		if (_zoneGarrison > 0) then { " Garrison:" + str _zoneGarrison } else { "" },
		if (_zoneRoadblocks > 0) then { " Roadblock:" + str _zoneRoadblocks } else { "" },
		if (_zoneSupport > 0) then { " Supports:" + str _zoneSupport } else { "" },
		if (_zoneQRFWaves > 0) then { " Waves:" + str _zoneQRFWaves } else { "" },
		if (_zoneIEDs > 0) then { " IEDs:" + str _zoneIEDs } else { "" },
		_locLevel
	]] call zmm_fnc_misc_logMsg;

// Create Markers
private _mrk = createMarker [ format["MKR_Z%1_LOC", _zoneID], _pos ];
_mrk setMarkerType (if (_side == WEST) then { "b_unknown" } else { if (_side == EAST) then { "o_unknown" } else { "n_unknown" };});
_mrk setMarkerColor format["color%1", _side];
_mrk setMarkerSize [ _iconSize, _iconSize];
if (ZMM_Debug) then { _mrk setMarkerText format["#%1 %2", _zoneID, _locType] };

_mrk = createMarker [ format["MKR_Z%1_MIN", _zoneID], _pos ];
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerBrush "SolidBorder";
_mrk setMarkerAlpha 0.3;
_mrk setMarkerColor format["color%1", _side];
_mrk setMarkerSize [ _radius * _locSize, _radius * _locSize];

_mrk = createMarker [ format["MKR_Z%1_MAX", _zoneID], _pos ];
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerBrush "BORDER";
_mrk setMarkerAlpha 0;
_mrk setMarkerColor format["color%1", _side];
_mrk setMarkerSize [ _radius * 2, _radius * 2];

// SERVER ONLY MARKER
if (isServer) then {
	_mrk setMarkerAlphaLocal 0.3; // Set MKR_Z%1_MAX visible
	
	// SERVER ONLY MARKER
	_mrk = createMarkerLocal [ format["MKR_Z%1_TRG", _zoneID], _pos ];
	_mrk setMarkerShapeLocal "ELLIPSE";
	_mrk setMarkerBrushLocal "BORDER";
	_mrk setMarkerAlphaLocal 0.2;
	_mrk setMarkerColorLocal format[ "color%1", "Black" ];
	_mrk setMarkerSizeLocal [ _triggerRadius, _triggerRadius];
};

// Create Building Locations
private _allBlds = nearestObjects [_pos, ["building","static"], ((_radius * _locSize) max 150 min 300), true]; // +static for SOG!
private _zoneBuildings = [];

{
	if ((_x getVariable ["ZAU_BuildingSide", sideUnknown]) != _side) then {
		private _positions = _x buildingPos -1;
		if (count _positions >= 4) then { 
			_zoneBuildings pushBack _x;
			_x setVariable ["ZAU_BuildingPositions", _positions];
			_x setVariable ["ZAU_BuildingSide", _side];
		};
	};
} forEach _allBlds;

// Remove unwanted building types
_zoneBuildings = _zoneBuildings select { !(typeOf _x in ["Land_SPE_bocage_short_mound","Land_SPE_bocage_long_mound"]) };

missionNamespace setVariable [ format["ZMM_%1_Buildings", _zoneID], _zoneBuildings]; // Set Large Buildings

// No need to have lots of locations
private _locMax = 8;

// ***  Find Flat Points *** 
private _zoneFlatPos = [];
for [{_i = 0}, {_i < 360}, {_i = _i + 5}] do {
	for [{_j = 50}, {_j <= (_radius / 1.5)}, {_j = _j + 10}] do {
		private _tempPos = _pos getPos [_j, _i];
		
		if (count (_tempPos nearRoads 50) == 0 && 
			count (nearestObjects [_tempPos, ["House", "Building"], 25]) == 0 && 
			{{_x distance2D _tempPos < 250} count _zoneFlatPos == 0}) 
		then {
			_tempPos = _tempPos isFlatEmpty [5, -1, 0.2, 3];
			if !(_tempPos isEqualTo []) then { _zoneFlatPos pushBack _tempPos };
		};
	};
	
	if (count _zoneFlatPos > _locMax) exitWith {};
};
missionNamespace setVariable [ format["ZMM_Z%1_FlatLocations", _zoneID], _zoneFlatPos]; // Set Flat Locations

// *** Find Support Points ***
private _zoneSuppPos = [];
for [{_i = 0}, {_i < 360}, {_i = _i + 5}] do {
	for [{_j = _radius * 0.75}, {_j <= (_radius * 2)}, {_j = _j + 25}] do {
		private _tempPos = _pos getPos [_j, _i];
					
		if ({_x distance2D _tempPos < 400} count _zoneSuppPos == 0 && !(_tempPos isFlatEmpty [10, -1, 0.25, 5] isEqualTo [])) then {			
			if (count (_tempPos nearRoads 50) == 0 &&
				count (nearestObjects [_tempPos, ["House", "Building"], 50]) == 0)
			then {
				_zoneSuppPos pushBack _tempPos;
			};
		};
	};
	
	if (count _zoneSuppPos > _locMax) exitWith {};
};

missionNamespace setVariable [ format[ "ZMM_%1_SupportLocations", _zoneID], _zoneSuppPos ]; // Set Flat Locations
missionNamespace setVariable [ format[ "ZMM_%1_Supports", _zoneID ], _zoneSupport min (count _zoneSuppPos) ];

// *** Find Roadblock Points ***
private _zoneRoads = [];
for [{_i = 0}, {_i < 360}, {_i = _i + 10}] do {
	private _roads = ((_pos getPos [(_radius * (1 + random 0.5)) max 300, _i]) nearRoads 100) select {count roadsConnectedTo _x > 0 && (nearestBuilding _x) distance _x > 75 && !((getPos _x) isFlatEmpty [-1, -1, 0.25, 2] isEqualTo [])};
		
	if (count _roads > 0) then {
		private _road = _roads#0;
		if ({_x distance2D _road < 600} count _zoneRoads == 0) then {
			_zoneRoads pushBack _road;
		};
	};
	
	if (count _zoneRoads > (_locMax / 2)) exitWith {};
};

missionNamespace setVariable [ format[ "ZMM_%1_Roads", _zoneID ], _zoneRoads ]; // Set Flat Locations
missionNamespace setVariable [ format[ "ZMM_%1_Roadblocks", _zoneID ], _zoneRoadblocks min (count _zoneRoads) ];

// Genuine location, so add it to possible locations list (to pick a random task location in CTI).
if (isNil "ZMM_LocationMarkerList") then { ZMM_LocationMarkerList = [] };
ZMM_LocationMarkerList pushBack format["MKR_Z%1_LOC", _zoneID];

["DEBUG", format["Zone%1 - Setup Zone - Completed [%2] - BLDS:%3 FLAT:%4 SUPP: %5 ROAD:%6", _zoneID, _side, count _zoneBuildings, count _zoneFlatPos, count _zoneSuppPos, count _zoneRoads]] call zmm_fnc_misc_logMsg;

// *** Ambient Zone - EXIT ***
// This zone doesn't need extra locations as it's just a filler for garrison/patrols.
if (_locType isEqualTo "Ambient") exitWith {
	format["MKR_Z%1_LOC", _zoneID] setMarkerSize [ 0.5, 0.5];
	format["MKR_Z%1_MIN", _zoneID] setMarkerAlpha 0;
	//format["MKR_Z%1_MAX", _zoneID] setMarkerAlphaLocal 0;
	//format["MKR_Z%1_TRG", _zoneID] setMarkerAlphaLocal 0;

	private _setupTrg = createTrigger [ "EmptyDetector", _pos, false ];
	_setupTrg setTriggerArea [ _triggerRadius, _triggerRadius, 0, false, 150 ];
	_setupTrg setTriggerActivation [ "ANYPLAYER", "PRESENT", false ];
	_setupTrg setTriggerStatements [ "count thisList > 1  || (this && count allPlayers <= 1)", 
		format ["[ %1, '%2' ] spawn zmm_fnc_setupPopulate; deleteVehicle this;", _zoneID, _locType], 
		""];
};

// *** Task Zone - EXIT ***
// This zone has been called to create a sub-task, it shouldn't really have QRF or patrols.
if (_locType isEqualTo "Task") exitWith {
	format["MKR_Z%1_LOC", _zoneID] setMarkerSize [ 0.5, 0.5];
	format["MKR_Z%1_MIN", _zoneID] setMarkerAlpha 0;
	[ _zoneID, _locType, _forceTask] spawn zmm_fnc_setupPopulate; // Extra param forces a task type to spawn regardless of game type
};

if (!isDedicated) then {
	// DEBUG: Show Roadblock Markers in local
	{
		private _blckMkr = createMarkerLocal [format ["ROAD_Z%1_L%2", _zoneID, _forEachIndex], _x];
		_blckMkr setMarkerTypeLocal "mil_dot";
		_blckMkr setMarkerColorLocal "ColorBlue";
		_blckMkr setMarkerAlphaLocal 0.6;
		_blckMkr setMarkerTextLocal format ["R_Z%1_L%2", _zoneID, _forEachIndex];
	} forEach _zoneRoads;

	// DEBUG: Show Support Markers in local
	{
		private _suppMkr = createMarkerLocal [format ["SUPP_Z%1_L%2", _zoneID, _forEachIndex], _x];
		_suppMkr setMarkerTypeLocal "mil_dot";
		_suppMkr setMarkerColorLocal "ColorGreen";
		_suppMkr setMarkerAlphaLocal 0.6;
		_suppMkr setMarkerTextLocal format ["S_Z%1_L%2", _zoneID, _forEachIndex];
	} forEach _zoneSuppPos;

	// DEBUG: Show Flat Markers in local
	{
		private _flatMkr = createMarkerLocal [format ["FLAT_Z%1_L%2", _zoneID, _forEachIndex], _x];
		_flatMkr setMarkerTypeLocal "mil_dot";
		_flatMkr setMarkerColorLocal "ColorGreen";
		_flatMkr setMarkerAlphaLocal 0.6;
		_flatMkr setMarkerTextLocal format ["F_Z%1_L%2", _zoneID, _forEachIndex];
	} forEach _zoneFlatPos;
};
private _trgVar = format ["TR_Z%1_POPULATE", _zoneID];

if (ZZM_Mode > 0 && isNil { missionNamespace getVariable _trgVar }) then {
	// CTI Mode - Create trigger when player nears Zone.
	private _setupTrg = createTrigger [ "EmptyDetector", _pos, false ];
	_setupTrg setTriggerArea [ _triggerRadius, _triggerRadius, 0, false, 150 ];
	_setupTrg setTriggerActivation [ "ANYPLAYER", "PRESENT", false ];
	_setupTrg setTriggerStatements [ "count thisList > 1 || (this && count allPlayers <= 1)", 
		format [ "[%1, '%2'] spawn zmm_fnc_setupPopulate; deleteVehicle this;", _zoneID, _locType], 
		""];

	missionNamespace setVariable [_trgVar, _setupTrg, true];
	[_setupTrg, format['TR_Z%1_POPULATE', _zoneID]] remoteExec ["setVehicleVarName", 0, _setupTrg];
} else {
	// Non-CTI Mode - Fill Zone immediately.
	[ _zoneID, _locType, _forceTask ] spawn zmm_fnc_setupPopulate;
};

_zoneID