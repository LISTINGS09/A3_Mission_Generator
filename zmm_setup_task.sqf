// Iterates the Zone and selects a suitable objective.
if !isServer exitWith {};

params [ "_zoneID", ["_filterTask", ""] ];

// Are we in CTI Mode?
private _isCTI = ZZM_Mode == 1;

// Zone not defined - Pick a random one.
if (isNil "_zoneID") then {
	private _markersAll = missionNamespace getVariable ["ZMM_ZoneMarkers", []];
	private _markersFar = [];
	
	if (_markersAll isEqualTo []) exitWith {}; // No markers so just exit.
	
	{
		_mkr = _x;
		if ((playableUnits + switchableUnits) findIf { _x distance (getmarkerPos _mkr) < 1500 } isEqualTo -1) then { _markersFar pushBack _mkr };
	} forEach _markersAll;
	
	private _foundZone = selectRandom _markersAll;
	
	if !(_markersFar isEqualTo []) then { _foundZone = selectRandom _markersFar };
	
	ZMM_ZoneMarkers = ZMM_ZoneMarkers - [_foundZone];
	
	_zoneID = parseNumber ((_foundZone splitString "_") select 1);
};

if (isNil "_zoneID") exitWith { ["ERROR", "Invalid Objective Zone"] call zmm_fnc_logMsg };

// Set global mission variable to false.
missionNamespace setVariable ["ZMM_DONE", false, true];

// Find a Main Objective
private _centre = missionNamespace getVariable [ format[ "ZMM_%1_Location", _zoneID ], [0,0,0] ];
private _side = missionNamespace getVariable [ format[ "ZMM_%1_EnemySide", _zoneID ], EAST ];
private _radius = (getMarkerSize format["MKR_%1_MIN", _zoneID]) select 0;
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];
private _buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], []];

// If tasks are to be filtered, only get the ones that match the type first check exact match, then by category.
private _objectives = if (_filterTask != "") then {
		private _filterObjectives = ZMM_tasks select { toUpper (_x#1) == toUpper _filterTask };	
		
		if (count _filterObjectives > 0) exitWith { _filterObjectives };
		
		_filterObjectives = ZMM_tasks select { toUpper (_x#0) == toUpper _filterTask };
			
		if (count _filterObjectives > 0) then { _filterObjectives } else { ZMM_tasks };
	} else { ZMM_tasks };
	
// If we've no objectives, exit
if (count _objectives == 0) exitWith { 
	["ERROR", format["Zone%1 - No objectives (%2, %3)", _zoneID, _locName, _centre]] call zmm_fnc_logMsg;
	false
};

// Get any custom parameters from the task.
(selectRandom _objectives) params ["_type", "_name", "_desc", "_icon", "_args", "_script", ["_overWrite", []]];

_args = switch (_args) do {
	// Get Large Building
	case "Building": {
		private _lrgBlds = _buildings select { count (_x buildingPos -1) >= 6 }; 
		[_zoneID, if (count _lrgBlds > 0) then { selectRandom _lrgBlds } else { nil } ] 
	};
	
	// Get Road
	case "Road": { 
		private _roads = [];
		for [{_i = 25}, {_i <= (_radius / 1.5)}, {_i = _i + 25}] do {
			_roads = (_centre nearRoads _i) select { count (roadsConnectedTo _x) > 0};
	
			if (count _roads > 0) exitWith { [_zoneID, position (selectRandom _roads)] };
		};
		
		[_zoneID]
	};
	
	// Get Flat Location
	case "Location": { 
		private _locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], []];
		[_zoneID, if (count _locations > 0) then { selectRandom _locations } else { nil } ] 
	};
	
	default { [_zoneID] };
};

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
	["ERROR", format["Zone%1 - Failed to create: %2 [%3]", _zoneID, _script, _type]] call zmm_fnc_logMsg;
	[_zoneID, ""] call zmm_fnc_setupTask;
} else {
	["DEBUG", format["Zone%1 - Created Objective %2 [%3] - (Wanted: %5) at %4", _zoneID, _script, _type, _locName, _filterTask]] call zmm_fnc_logMsg;
};

true