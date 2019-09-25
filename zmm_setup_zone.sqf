// Spawns a markers/missions over all locations in a world.
// [thisTrigger, "Task", 50, "Hill 241", "Task", "Building"] spawn zmm_fnc_setupZone;
if !isServer exitWith {};

params [ ["_pos", [0,0,0]], ["_locType", "Custom"], ["_radius", 150], ["_locName", "Unnamed"], ["_orgType", "Custom"], ["_forceTask", ""] ];

_zmm_fnc_findSide = {
	params [[ "_nearPos", []], ["_inDist", 0]];
		
	_inDist = _inDist max 2500;
	_foundSide = CIVILIAN;
	_sideColors = [];
	{_sideColors pushBack toUpper format["Color%1", _x] } forEach ZMM_enemySides;
		
	// Check marker colours to match on.
	_foundSides = [];
	{	
		_findIndex = _sideColors find toUpper (getMarkerColor _x);
		if (_findIndex >= 0) then { _foundSides pushBack _x };
	} forEach (allMapMarkers select { getMarkerPos _x distance2D _nearPos < _inDist && toUpper (getMarkerColor _x) in ["COLORWEST", "COLOREAST", "COLORGUER"] });
	
	// Found markers so find the nearest
	if (count _foundSides > 0) then {
		_nearMarker = _foundSides select 0;
		
		{
			if ((markerPos _x distance _pos) < (markerPos _nearMarker distance _pos)) then { _nearMarker = _x }; 
		} forEach _foundSides;
		
		_foundSide = switch (toUpper (getMarkerColor _nearMarker)) do { case "COLORWEST": { WEST }; case "COLOREAST": { EAST }; default { INDEPENDENT }; };
	};
	
	if !(_foundSide isEqualTo CIVILIAN) exitWith { _foundSide };
	
	// Find near entities to get side.
	{
		if (side _x in ZMM_enemySides) exitWith { _foundSide = side _x };
	} forEach (_nearPos nearEntities [["Man", "Air", "Car", "Tank"], _inDist]);

	if !(_foundSide isEqualTo CIVILIAN) exitWith { _foundSide };
	
	_foundSide = selectRandom ZMM_enemySides;	
	_foundSide
};

// Convert position if wrong type.
switch (typeName _pos) do {
	case "STRING": {_pos = getMarkerPos _pos};
	case "OBJECT": {_pos = getPos _pos};
};

// Set default trigger radius
_triggerRadius = if ((_radius * 6) < 1000) then { 1000 } else { (_radius * 6) min 2000 };

// Set the Zone ID - Used to reference the area in-mission.
_zoneID = (missionNamespace getVariable ["ZZM_zoneID",0]) + 1;	// Unique per instance.	
missionNamespace setVariable ["ZZM_zoneID", _zoneID]; // Set Current Zone ID	
missionNamespace setVariable [format["ZMM_%1_Location", _zoneID], _pos]; // Set Zone Centre
missionNamespace setVariable [format["ZMM_%1_Name", _zoneID], _locName]; // Set Zone Name
missionNamespace setVariable [format["ZMM_%1_Type", _zoneID], [_orgType, _locType] select (isNil "_orgType")]; // Set Zone Type (Original)

// Find a suitable enemy side.
_side = [ _pos, _radius * 5] call _zmm_fnc_findSide;
missionNamespace setVariable [format["ZMM_%1_EnemySide", _zoneID], _side]; // Set Side

["DEBUG", format["Creating Zone %1 [%2] - %6 (%3) %4 TR:%5m [%7]", _zoneID, _side, _locType, _pos, _triggerRadius, _locName, _forceTask]] call zmm_fnc_logMsg;

// Set default sizes of area based on type.
_iconSize = 1;
_locSize = 1;
missionNamespace setVariable [format[ "ZMM_%1_Patrols", _zoneID ], TRUE];
missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], 12];
missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 600];
missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], 3];

switch (_locType) do {
	case "Airport": { 
		_iconSize = 1.2;
		_locSize = 1.25;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], 20];
		missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 300];
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], 8];
	};
	case "NameCityCapital": { 
		_iconSize = 1.1;
		_locSize = 1.25;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], 20];
		missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 300];
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], 6];
	};
	case "NameCity": { 
		_iconSize = 1;
		_locSize = 1;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], 16];
		missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 300];
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], 6];
	};
	case "NameVillage": { 
		_iconSize = 0.8;
		_locSize = 0.75;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], 10];
		missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 400];
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], 4];
	};
	case "NameLocal": { 
		_iconSize = 0.6;
		_locSize = 0.75;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], 8];
		missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 500];
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], 4];
	};
	case "Ambient": {
		_iconSize = 0.4;
		_locSize = 0.75;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], 8];
		missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 0];
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], 0];
	};
	case "Task": {
		_iconSize = 0.4;
		_locSize = 0.75;
		missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], 8];
		missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 0];
		missionNamespace setVariable [format[ "ZMM_%1_QRFWaves", _zoneID ], 0];
	};
};

// Create Markers
_mrk = createMarker [ format["MKR_%1_LOC", _zoneID], _pos ];
_mrk setMarkerType (if (_side == WEST) then { "b_unknown" } else { if (_side == EAST) then { "o_unknown" } else { "n_unknown" };});
_mrk setMarkerColor format["color%1", _side];
_mrk setMarkerSize [ _iconSize, _iconSize];
if (ZMM_Debug) then { _mrk setMarkerText format["#%1 %2", _zoneID, _locType] };

_mrk = createMarker [ format["MKR_%1_MIN", _zoneID], _pos ];
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerBrush "SolidBorder";
_mrk setMarkerAlpha 0.3;
_mrk setMarkerColor format["color%1", _side];
_mrk setMarkerSize [ _radius * _locSize, _radius * _locSize];

// SERVER ONLY MARKER
_mrk = createMarkerLocal [ format["MKR_%1_MAX", _zoneID], _pos ];
_mrk setMarkerShapeLocal "ELLIPSE";
_mrk setMarkerBrushLocal "BORDER";
_mrk setMarkerAlphaLocal 0.2;
_mrk setMarkerColorLocal format["color%1", _side];
_mrk setMarkerSizeLocal [ _radius * 2, _radius * 2];

// SERVER ONLY MARKER
_mrk = createMarkerLocal [ format["MKR_%1_TRG", _zoneID], _pos ];
_mrk setMarkerShapeLocal "ELLIPSE";
_mrk setMarkerBrushLocal "BORDER";
_mrk setMarkerAlphaLocal 0.2;
_mrk setMarkerColorLocal format[ "color%1", "Black" ];
_mrk setMarkerSizeLocal [ _triggerRadius, _triggerRadius];

// Create QRF Points - Collect all roads ~1.5km around the location that are not in a safe location.
_QRFLocs = [];
_qrfDist = if ((_radius * 3) < 1000) then { 1000 } else { (_radius * 3) min 1500 };

for [{_i = 0}, {_i <= 360}, {_i = _i + 1}] do {
	_roads = (([_pos, _qrfDist, _i] call BIS_fnc_relPos) nearRoads 50) select {((boundingBoxReal _x) select 0) distance2D ((boundingBoxReal _x) select 1) >= 25};
		
	if (count _roads > 0) then {
		_road = _roads select 0;
		if ({_x distance2D _road < 100} count _QRFLocs == 0) then {
			_connected = roadsConnectedTo _road;
			_nearestRoad = objNull;
			{if ((_x distance _pos) < (_nearestRoad distance _pos)) then {_nearestRoad = _x}} forEach _connected;
			_QRFLocs pushBackUnique position _nearestRoad;
		};
	};
};
missionNamespace setVariable [ format["ZMM_%1_QRFLocations", _zoneID], _QRFLocs ]; // Set QRF Locations

// Create Building Locations
_allBlds = nearestObjects [_pos, ["building"], ((_radius * _locSize) max 150), TRUE];
missionNamespace setVariable [ format["ZMM_%1_Buildings", _zoneID], (_allBlds select {count (_x buildingPos -1) >= 2}) ]; // Set Large Buildings

// *** Ambient Zone - EXIT ***
// This zone doesn't need extra locations as it's just a filler for garrison/patrols.
if (_locType isEqualTo "Ambient") exitWith {
	format["MKR_%1_LOC", _zoneID] setMarkerSize [ 0.5, 0.5];
	format["MKR_%1_MIN", _zoneID] setMarkerAlpha 0;
	//format["MKR_%1_MAX", _zoneID] setMarkerAlphaLocal 0;
	//format["MKR_%1_TRG", _zoneID] setMarkerAlphaLocal 0;

	_setupTrg = createTrigger [ "EmptyDetector", _pos, FALSE ];
	_setupTrg setTriggerArea [ _triggerRadius, _triggerRadius, 0, FALSE, 150 ];
	_setupTrg setTriggerActivation [ "ANYPLAYER", "PRESENT", FALSE ];
	_setupTrg setTriggerStatements [ "this", 
									format ["[ %1, '%2' ] spawn zmm_fnc_setupPopulate;", _zoneID, _locType], 
									""];
};

// *** Task Zone - EXIT ***
// This zone has been called to create a sub-task, it shouldn't really have QRF or patrols.
if (_locType isEqualTo "Task") exitWith {
	format["MKR_%1_LOC", _zoneID] setMarkerSize [ 0.5, 0.5];
	format["MKR_%1_MIN", _zoneID] setMarkerAlpha 0;
	[ _zoneID, _locType, _forceTask] spawn zmm_fnc_setupPopulate; // Extra param forces a task type to spawn regardless of game type
};

// Genuine location, so add it to possible locations list (to pick a random task location in CTI).
if (isNil "ZMM_ZoneMarkers") then { ZMM_ZoneMarkers = [] };
ZMM_ZoneMarkers pushBack format["MKR_%1_LOC", _zoneID];

// Find Objectives - Flat Ground
private _groundLocs = [];
for [{_i = 0}, {_i < 360}, {_i = _i + 1}] do {
	for [{_j = 10}, {_j <= (_radius / 1.5)}, {_j = _j + 10}] do {
		_tempPos = ([_pos, _j, _i] call BIS_fnc_relPos) isFlatEmpty [-1, -1, 0.2, 3, 0, FALSE];
		
		if (count _tempPos > 0) then {
			if ({_x distance2D _tempPos < 250 && !surfaceIsWater _tempPos} count _groundLocs == 0) then {		
				_groundLocs pushBack _tempPos;
			};
		};
	};
};
missionNamespace setVariable [ format["ZMM_%1_FlatLocations", _zoneID], _groundLocs ]; // Set Flat Locations

if (ZZM_Mode == 1) then {
	// CTI Mode - Create trigger when player nears Zone.
	_setupTrg = createTrigger [ "EmptyDetector", _pos, FALSE ];
	_setupTrg setTriggerArea [ _triggerRadius, _triggerRadius, 0, FALSE, 150 ];
	_setupTrg setTriggerActivation [ "ANYPLAYER", "PRESENT", FALSE ];
	_setupTrg setTriggerStatements [ "this", 
									format [ "[%1] spawn zmm_fnc_setupPopulate;", _zoneID ], 
									""];
} else {
	// Non-CTI Mode - Fill Zone immediately.
	[ _zoneID, _locType, _forceTask ] spawn zmm_fnc_setupPopulate;
};

_zoneID