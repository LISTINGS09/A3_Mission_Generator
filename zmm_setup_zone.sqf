// Spawns a markers/missions over all locations in a world.
if !isServer exitWith {};

params [ ["_pos", [0,0,0]], ["_desc_type", "Custom"], ["_radius", 150] ];

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
	} forEach (allMapMarkers select { getMarkerPos _x distance2D _nearPos < _inDist });
	
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

// Set the Zone ID - Used to reference the area in-mission.
_zoneID = (missionNamespace getVariable ["ZZM_zoneID",0]) + 1;	// Unique per instance.	
missionNamespace setVariable ["ZZM_zoneID", _zoneID]; // Set Current Zone ID	
missionNamespace setVariable [format["ZMM_%1_Location", _zoneID], _pos]; // Set Zone Centre

_nearLoc = nearestLocation [_pos, ""];
_locName = if (getPos _nearLoc distance2D _pos < 200) then { text _nearLoc } else { "this Location" };

// Find a suitable enemy side.
_side = [ _pos, _radius * 5] call _zmm_fnc_findSide;
missionNamespace setVariable [format["ZMM_%1_EnemySide", _zoneID], _side]; // Set Side

["DEBUG", format["Creating Zone %1 (%2 - %3 - %4)", _zoneID, _desc_type, _locName, _pos]] call zmm_fnc_logMsg;

// Set sizes of area based on type.
_iconSize = 1;
_locSize = 1;

switch (_desc_type) do {
	case "Airport": { 
		_iconSize = 1.2;
		_locSize = 1.25;
	};
	case "NameCityCapital": { 
		_iconSize = 1.1;
		_locSize = 1.25;
	};
	case "NameCity": { 
		_iconSize = 1;
		_locSize = 1;
	};
	case "NameVillage": { 
		_iconSize = 0.8;
		_locSize = 0.75;
	};
	case "NameLocal": { 
		_iconSize = 0.6;
		_locSize = 0.75;
	};
	case "Ambient": {
		_iconSize = 0.4;
		_locSize = 0.75;
	};
};

// Create Markers
_mrk = createMarker [ format["MKR_%1_LOC", _zoneID], _pos ];
_mrk setMarkerType (if (_side == WEST) then { "b_unknown" } else { if (_side == EAST) then { "o_unknown" } else { "n_unknown" };});
_mrk setMarkerColor format["color%1", _side];
_mrk setMarkerSize [ _iconSize, _iconSize];

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
_mrk setMarkerAlphaLocal 0.5;
_mrk setMarkerColorLocal format["color%1", _side];
_mrk setMarkerSizeLocal [ _radius * 2, _radius * 2];

// SERVER ONLY MARKER
_mrk = createMarkerLocal [ format["MKR_%1_TRG", _zoneID], _pos ];
_mrk setMarkerShapeLocal "ELLIPSE";
_mrk setMarkerBrushLocal "BORDER";
_mrk setMarkerAlphaLocal 0.5;
_mrk setMarkerColorLocal format[ "color%1", "Black" ];
_mrk setMarkerSizeLocal [ _radius * 3, _radius * 3];

// Create QRF Points - Collect all roads ~1.5km around the location that are not in a safe location.
_QRFLocs = [];
_qrfDist = (_radius * 3) max 1500;

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
_allBlds = nearestObjects [_pos, ["building"], _radius * _locSize, TRUE];
_lrgBlds = (_allBlds select {count (_x buildingPos -1) >= 4});
missionNamespace setVariable [ format["ZMM_%1_Buildings", _zoneID], _lrgBlds ]; // Set Large Buildings

// Ambient - EXIT - Only zones need a garrison.
if (_desc_type isEqualTo "Ambient") exitWith {
	format["MKR_%1_LOC", _zoneID] setMarkerSize [ 0.5, 0.5];
	format["MKR_%1_MIN", _zoneID] setMarkerAlpha 0;
	format["MKR_%1_MAX", _zoneID] setMarkerAlphaLocal 0;
	format["MKR_%1_TRG", _zoneID] setMarkerAlphaLocal 0;

	_setupTrg = createTrigger [ "EmptyDetector", _pos, FALSE ];
	_setupTrg setTriggerArea [ _radius * 4, _radius * 4, 0, FALSE, 150 ];
	_setupTrg setTriggerActivation [ "ANYPLAYER", "PRESENT", FALSE ];
	_setupTrg setTriggerStatements [ "this", 
									format ["[ %1, '%2' ] spawn zmm_fnc_setupPopulate;", _zoneID, _desc_type], 
									""];
};

// The following takes a little time.
[_pos, _radius, _locSize, _zoneID] spawn {
	params ["_pos", "_radius", "_locSize", "_zoneID"];

	//  Find Objectives - Positions for Insertion and Extraction Points.
	private _landLocs = [];
	for [{_i = 0}, {_i < 360}, {_i = _i + 1}] do {
		_tempPos = [_pos, _radius * 2.5, _i] call BIS_fnc_relPos;
		
		if (count (_tempPos isFlatEmpty [-1, -1, 0.4, 10, 0, false]) > 0) then { 
			if ({_x distance2D _tempPos < 250} count _landLocs == 0) then {	
				_landLocs pushBack _tempPos;
			};
		};
	};
	missionNamespace setVariable [ format["ZMM_%1_LZLocations", _zoneID], _landLocs ]; // Set LZ Locations

	// Find Objectives - Flat Ground
	private _groundLocs = [];
	for [{_i = 0}, {_i < 360}, {_i = _i + 1}] do {
		for [{_j = 25}, {_j <= ((_radius * _locSize) * 0.9)}, {_j = _j + 25}] do {
			_tempPos = ([_pos, _j, _i] call BIS_fnc_relPos) isFlatEmpty [-1, -1, 0.3, 1, 0, FALSE];
			
			if (count _tempPos > 0) then {
				if ({_x distance2D _tempPos < 250} count _groundLocs == 0) then {		
					_groundLocs pushBack _tempPos;
				};
			};
		};
	};
	missionNamespace setVariable [ format["ZMM_%1_FlatLocations", _zoneID], _groundLocs ]; // Set QRF Locations
};

// SETUP - Location Creation Trigger when player is near.
if (missionNamespace getVariable ["ZZM_CTIMode", FALSE]) then {
	_setupTrg = createTrigger [ "EmptyDetector", _pos, FALSE ];
	_setupTrg setTriggerArea [ _radius * 3, _radius * 3, 0, FALSE, 150 ];
	_setupTrg setTriggerActivation [ "ANYPLAYER", "PRESENT", FALSE ];
	_setupTrg setTriggerStatements [ "this", 
									format [ "[ %1, '%2' ] spawn zmm_fnc_setupPopulate;", _zoneID, _desc_type ], 
									""];
} else {
	[ _zoneID, _desc_type ] spawn zmm_fnc_setupPopulate;
};