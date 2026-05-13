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
private _triggerRadius = if ((_radius * 6) < 1000) then { 1000 } else { (_radius * 6) min 2000 };

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

// Set default sizes of area based on type.
private _iconSize = 1;
private _locSize = 1;
private _locMax = 8;
private _multiplier = missionNamespace getVariable ["ZZM_Diff", 1];
private _qrfTime = [900, 600, 300] select (missionNamespace getVariable ["ZZM_Diff", 1]);

missionNamespace setVariable [format[ "ZMM_%1_Patrols", _zoneID ], true];
missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], round (30 * _multiplier)];
missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], _qrfTime];
missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], round (3 * _multiplier)];

switch (_locType) do {
	case "Airport": { 
		_iconSize = 1.2;
		_locSize = 1.25;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], (50 * _multiplier) + random 10];
		missionNamespace setVariable [format[ "ZMM_%1_Roadblocks", _zoneID ], floor (random 5)];
		missionNamespace setVariable [format[ "ZMM_%1_Supports", _zoneID ], floor (random 3)];
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], round (8 * _multiplier)];
		missionNamespace setVariable [format[ "ZMM_%1_IEDs", _zoneID ], floor (random 3)];
	};
	case "NameCityCapital": { 
		_iconSize = 1.1;
		_locSize = 1.25;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], (50 * _multiplier) + random 10];
		missionNamespace setVariable [format[ "ZMM_%1_Roadblocks", _zoneID ], floor (random 5)];
		missionNamespace setVariable [format[ "ZMM_%1_Supports", _zoneID ], floor (random 3)];
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], round (6 * _multiplier)];
		missionNamespace setVariable [format[ "ZMM_%1_IEDs", _zoneID ], floor (random 3)];
	};
	case "NameCity": { 
		_iconSize = 1;
		_locSize = 1;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], (40 * _multiplier) + random 10];
		missionNamespace setVariable [format[ "ZMM_%1_Roadblocks", _zoneID ], floor (random 4)];
		missionNamespace setVariable [format[ "ZMM_%1_Supports", _zoneID ], floor (random 2)];
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], (6 * _multiplier)];
		missionNamespace setVariable [format[ "ZMM_%1_IEDs", _zoneID ], floor (random 2)];
	};
	case "NameVillage": { 
		_iconSize = 0.8;
		_locSize = 0.75;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], (30 * _multiplier) + random 10];
		missionNamespace setVariable [format[ "ZMM_%1_Roadblocks", _zoneID ], floor (random 2)];
		missionNamespace setVariable [format[ "ZMM_%1_Supports", _zoneID ], floor (random 2)];
		missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], _qrfTime + 100]; // Delayed QRF
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], (4 * _multiplier)];
		missionNamespace setVariable [format[ "ZMM_%1_IEDs", _zoneID ], floor (random 1)];
	};
	case "NameLocal": { 
		_iconSize = 0.6;
		_locSize = 0.75;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], (20 * _multiplier) + random 6];
		missionNamespace setVariable [format[ "ZMM_%1_Roadblocks", _zoneID ], floor (random 2)];
		missionNamespace setVariable [format[ "ZMM_%1_Supports", _zoneID ], floor (random 1.5)];
		missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], _qrfTime + 200]; // Delayed QRF
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], (4 * _multiplier)];
		missionNamespace setVariable [format[ "ZMM_%1_IEDs", _zoneID ], 0];
	};
	case "Ambient": {
		_iconSize = 0.4;
		_locSize = 0.75;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], (20 * _multiplier) + random 6];
		missionNamespace setVariable [format[ "ZMM_%1_Roadblocks", _zoneID ], floor (random 1.5)];
		missionNamespace setVariable [format[ "ZMM_%1_Supports", _zoneID ], floor (random 1.5)];
		missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 0]; // No QRF
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], 0]; // No QRF
		missionNamespace setVariable [format[ "ZMM_%1_IEDs", _zoneID ], 0];
	};
	case "Task": {
		_iconSize = 0.4;
		_locSize = 0.75;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], (20 * _multiplier) + random 8];
		missionNamespace setVariable [format[ "ZMM_%1_Roadblocks", _zoneID ], 2 + floor (random 2)];
		missionNamespace setVariable [format[ "ZMM_%1_Supports", _zoneID ], floor (random 2)];
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], (6 * _multiplier)];
		if (random 1 > 0.5) then { missionNamespace setVariable [format[ "ZMM_%1_IEDs", _zoneID ], floor (random 1)]; };
	};
};

if (_side != INDEPENDENT) then { missionNamespace setVariable [format[ "ZMM_%1_IEDs", _zoneID ], 0] }; // IEDs for GUER only.

["DEBUG", format["Zone%1 - Setup Zone - Settings - (%2 - %3) GAR: %4 RBL: %5 SUP: %6 QRF: %7 IED: %8", _zoneID, _locType, _side,
	missionNamespace getVariable [format[ "ZMM_%1_Garrison", _zoneID ], 0],
	missionNamespace getVariable [format[ "ZMM_%1_Roadblocks", _zoneID ], 0],
	missionNamespace getVariable [format[ "ZMM_%1_Supports", _zoneID ], 0],
	missionNamespace getVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], 0],
	missionNamespace getVariable [format[ "ZMM_%1_IEDs", _zoneID ], 0]]
] call zmm_fnc_misc_logMsg;

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

// SERVER ONLY MARKER
_mrk = createMarkerLocal [ format["MKR_Z%1_MAX", _zoneID], _pos ];
_mrk setMarkerShapeLocal "ELLIPSE";
_mrk setMarkerBrushLocal "BORDER";
_mrk setMarkerAlphaLocal 0.2;
_mrk setMarkerColorLocal format["color%1", _side];
_mrk setMarkerSizeLocal [ _radius * 2, _radius * 2];

// SERVER ONLY MARKER
_mrk = createMarkerLocal [ format["MKR_Z%1_TRG", _zoneID], _pos ];
_mrk setMarkerShapeLocal "ELLIPSE";
_mrk setMarkerBrushLocal "BORDER";
_mrk setMarkerAlphaLocal 0.2;
_mrk setMarkerColorLocal format[ "color%1", "Black" ];
_mrk setMarkerSizeLocal [ _triggerRadius, _triggerRadius];

// Create Building Locations
private _allBlds = nearestObjects [_pos, ["building","static"], ((_radius * _locSize) max 150 min 300), true]; // +static for SOG!
private _finalBlds = [];

{
	if (isNil {_x getVariable "ZAU_BuildingPositions"} || isNil {_x getVariable "ZAU_BuildingSide"}) then {
		private _positions = _x buildingPos -1;
		if (count _positions >= 4) then { 
			_finalBlds pushBack _x;
			_x setVariable ["ZAU_BuildingPositions", _positions];
			_x setVariable ["ZAU_BuildingSide", _side];
		};
	};
} forEach _allBlds;

// Remove unwanted building types
_finalBlds = _finalBlds select { !(typeOf _x in ["Land_SPE_bocage_short_mound","Land_SPE_bocage_long_mound"]) };

missionNamespace setVariable [ format["ZMM_%1_Buildings", _zoneID], _finalBlds]; // Set Large Buildings

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

// Genuine location, so add it to possible locations list (to pick a random task location in CTI).
if (isNil "ZMM_LocationMarkerList") then { ZMM_LocationMarkerList = [] };
ZMM_LocationMarkerList pushBack format["MKR_Z%1_LOC", _zoneID];

// ***  Find Flat Points *** 
private _groundLocs = [];
for [{_i = 0}, {_i < 360}, {_i = _i + 5}] do {
	for [{_j = 50}, {_j <= (_radius / 1.5)}, {_j = _j + 10}] do {
		private _tempPos = _pos getPos [_j, _i];
		
		if (count (_tempPos nearRoads 50) == 0 && 
			count (nearestObjects [_tempPos, ["House", "Building"], 25]) == 0 && 
			{{_x distance2D _tempPos < 250} count _groundLocs == 0}) 
		then {
			_tempPos = _tempPos isFlatEmpty [5, -1, 0.2, 3];
			if !(_tempPos isEqualTo []) then { _groundLocs pushBack _tempPos };
		};
	};
	
	if (count _groundLocs > _locMax) exitWith {};
};
missionNamespace setVariable [ format["ZMM_Z%1_FlatLocations", _zoneID], _groundLocs]; // Set Flat Locations

// DEBUG: Show Flat Markers in local
{
	private _flatMkr = createMarkerLocal [format ["FLAT_Z%1_L%2", _zoneID, _forEachIndex], _x];
	_flatMkr setMarkerTypeLocal "mil_dot";
	_flatMkr setMarkerColorLocal "ColorGreen";
	_flatMkr setMarkerAlphaLocal 0.6;
	_flatMkr setMarkerTextLocal format ["F_Z%1_L%2", _zoneID, _forEachIndex];
} forEach _groundLocs;

// *** Find Support Points ***
private _supportLocs = [];
for [{_i = 0}, {_i < 360}, {_i = _i + 5}] do {
	for [{_j = _radius * 0.75}, {_j <= (_radius * 2)}, {_j = _j + 25}] do {
		private _tempPos = _pos getPos [_j, _i];
					
		if ({_x distance2D _tempPos < 400} count _supportLocs == 0 && !(_tempPos isFlatEmpty [10, -1, 0.25, 5] isEqualTo [])) then {			
			if (count (_tempPos nearRoads 50) == 0 &&
				count (nearestObjects [_tempPos, ["House", "Building"], 50]) == 0)
			then {
				_supportLocs pushBack _tempPos;
			};
		};
	};
	
	if (count _supportLocs > _locMax) exitWith {};
};

missionNamespace setVariable [ format["ZMM_%1_SupportLocations", _zoneID], _supportLocs]; // Set Flat Locations

// DEBUG: Show Support Markers in local
{
	private _suppMkr = createMarkerLocal [format ["SUPP_Z%1_L%2", _zoneID, _forEachIndex], _x];
	_suppMkr setMarkerTypeLocal "mil_dot";
	_suppMkr setMarkerColorLocal "ColorGreen";
	_suppMkr setMarkerAlphaLocal 0.6;
	_suppMkr setMarkerTextLocal format ["S_Z%1_L%2", _zoneID, _forEachIndex];
} forEach _supportLocs;

// *** Find Roadblock Points ***
private _blockLocs = [];
for [{_i = 0}, {_i < 360}, {_i = _i + 10}] do {
	private _roads = ((_pos getPos [(_radius * (1 + random 0.5)) max 300, _i]) nearRoads 100) select {count roadsConnectedTo _x > 0 && (nearestBuilding _x) distance _x > 75 && !((getPos _x) isFlatEmpty [-1, -1, 0.25, 2] isEqualTo [])};
		
	if (count _roads > 0) then {
		private _road = _roads#0;
		if ({_x distance2D _road < 600} count _blockLocs == 0) then {
			_blockLocs pushBack _road;
		};
	};
	
	if (count _blockLocs > (_locMax / 2)) exitWith {};
};
missionNamespace setVariable [ format["ZMM_%1_BlockLocations", _zoneID], _blockLocs]; // Set Flat Locations

// DEBUG: Show Roadblock Markers in local
{
	private _blckMkr = createMarkerLocal [format ["ROAD_Z%1_L%2", _zoneID, _forEachIndex], _x];
	_blckMkr setMarkerTypeLocal "mil_dot";
	_blckMkr setMarkerColorLocal "ColorBlue";
	_blckMkr setMarkerAlphaLocal 0.6;
	_blckMkr setMarkerTextLocal format ["R_Z%1_L%2", _zoneID, _forEachIndex];
} forEach _blockLocs;

["DEBUG", format["Zone%1 - Setup Zone - Completed [%2] - Locations: BLD:%3 FLT:%4", _zoneID, _side, count _allBlds, count _groundLocs]] call zmm_fnc_misc_logMsg;

if (ZZM_Mode > 0 && isNil format["TR_Z%1_POPULATE", _zoneID]) then {
	// CTI Mode - Create trigger when player nears Zone.
	private _setupTrg = createTrigger [ "EmptyDetector", _pos, false ];
	_setupTrg setTriggerArea [ _triggerRadius, _triggerRadius, 0, false, 150 ];
	_setupTrg setTriggerActivation [ "ANYPLAYER", "PRESENT", false ];
	_setupTrg setTriggerStatements [ "count thisList > 1 || (this && count allPlayers <= 1)", 
		format [ "[%1, '%2'] spawn zmm_fnc_setupPopulate; deleteVehicle this;", _zoneID, _locType], 
		""];

	missionNamespace setVariable [format['TR_Z%1_POPULATE', _zoneID], _setupTrg, true];
	[_setupTrg, format['TR_Z%1_POPULATE', _zoneID]] remoteExec ["setVehicleVarName", 0, _setupTrg];
} else {
	// Non-CTI Mode - Fill Zone immediately.
	[ _zoneID, _locType, _forceTask ] spawn zmm_fnc_setupPopulate;
};

_zoneID