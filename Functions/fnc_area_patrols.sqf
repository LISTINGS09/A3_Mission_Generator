// Wait for Location Selection.
params [ ["_zoneID", 0], ["_locType", ""], ["_markerOverride", ""] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_side = missionNamespace getVariable [format["ZMM_%1_enemySide", _zoneID], EAST];

_sentry = missionNamespace getVariable format["ZMM_%1Grp_Sentry", _side];
_team = missionNamespace getVariable format["ZMM_%1Grp_Team", _side];
_squad = missionNamespace getVariable format["ZMM_%1Grp_Squad", _side];
_light = missionNamespace getVariable format["ZMM_%1Veh_Light", _side];
_medium = missionNamespace getVariable format["ZMM_%1Veh_Medium", _side];
_heavy = missionNamespace getVariable format["ZMM_%1Veh_Heavy", _side];
_cas = missionNamespace getVariable format["ZMM_%1Veh_CAS", _side];

if (_locType isEqualTo "") then { _locType = type (nearestLocation [_centre,""]) };

_fnc_spawnGroup = {
	params ["_zoneID", "_centre", "_types", ["_marker", ""], "_count"];
	
	if (round _count isEqualTo 0) exitWith {};
	
	if (_markerOverride isEqualTo "") then { 
		if (_marker isEqualTo "") then { 
			_marker = format["MKR_%1_MAX", _zoneID];
		};
	} else {
		_marker = _markerOverride;
	};

	for [{_i = 0}, {_i < _count}, {_i = _i + 1}] do {
		_group = objNull;
		if (count _types isEqualTo 0) exitWith { ["ERROR", format["Zone%1 (%2) - No valid units passed, were global unit variables declared?", _zoneID, _side]] call zmm_fnc_logMsg };
		_type = selectRandom _types;
		_customInit = "";
		["DEBUG", format["Zone%1 (%3) - Spawning '%2' [%4]", _zoneID, if (_type isEqualType "") then { _type } else { configName _type }, _side, _marker]] call zmm_fnc_logMsg;
		
		// If _unitClass is array, extract the custom init.
		if (_type isEqualType []) then {
			_customInit = _type#1;
			_type = _type#0;
		};
		
		if (typeName _type == typeName "") then {
			if (isClass (configFile >> "CfgVehicles" >> _type)) then {
				_isAir = FALSE;
				if ("Air" in ([(configFile >> "CfgVehicles" >> _type), TRUE] call BIS_fnc_returnParents)) then { _isAir = TRUE };
								
				// Spawn vehicle on a road.
				_roads = (getMarkerPos _marker nearRoads (getMarkerSize _marker select 0)) select { count (roadsConnectedTo _x) > 0};

				if (count _roads > 0) then { _centre = position (selectRandom _roads) };
				
				_veh = createVehicle [_type, if _isAir then { [0,0,0] } else { _centre }, [], 0, if _isAir then {"FLY"} else {"NONE"}];
				
				if !(_customInit isEqualTo "") then { _grpVeh = _veh; call compile _customInit; };
				if !_isAir then { _veh enableDynamicSimulation TRUE };
				
				createVehicleCrew _veh;
				
				// Switch units side to Zone side.
				if (side driver _veh != _side) then {
					_sideGrp = createGroup [_side, TRUE];
					(crew _veh) joinSilent _sideGrp;
				};
				
				{ _x addCuratorEditableObjects [ crew _veh, TRUE ] } forEach allCurators;
				
				[driver _veh, _marker, "SHOWMARKER"] spawn zmm_fnc_aiUPS;
			} else {
				["ERROR", format["Invalid vehicle class: %1", _type]] call zmm_fnc_logMsg;
			};
		} else {
			_group = [[0,0,0], _side, _type] call BIS_fnc_spawnGroup;
			_group spawn { sleep 30; _this enableDynamicSimulation TRUE };
				
			if !(_customInit isEqualTo "") then {
				_grpVeh = selectRandom (units _group select { vehicle _x != _x });
				call compile _customInit;
			};
			
			{ _x addCuratorEditableObjects [ units _group, TRUE ] } forEach allCurators;
			
			[leader _group, _marker, "SHOWMARKER", "RANDOM"] spawn zmm_fnc_aiUPS;
			
			[leader _group] call zmm_fnc_inteladd; // Add Intel Drop
		};		
		sleep 1;
	};
};

["DEBUG", format["Creating Patrols - Zone %1 (%2)", _zoneID, _locType]] call zmm_fnc_logMsg;

switch (_locType) do {
	case "Airport": { 
		[_zoneID, _centre, _light, format["MKR_%1_MAX", _zoneID], 1 + random 1] call _fnc_spawnGroup;
		[_zoneID, _centre, _medium + _heavy, format["MKR_%1_MAX", _zoneID], 2 + random 1] call _fnc_spawnGroup;
		[_zoneID, _centre, _heavy + _cas, format["MKR_%1_MIN", _zoneID], 2 + random 1] call _fnc_spawnGroup;
		[_zoneID, _centre, _sentry, format["MKR_%1_MAX", _zoneID], 3 + random 2] call _fnc_spawnGroup;	
		[_zoneID, _centre, _team, format["MKR_%1_MIN", _zoneID], 2 + random 1] call _fnc_spawnGroup;	
		[_zoneID, _centre, _squad, format["MKR_%1_MIN", _zoneID], 1 + random 1] call _fnc_spawnGroup;
	};
	case "NameCityCapital": { 
		[_zoneID, _centre, _light + _medium, format["MKR_%1_MAX", _zoneID], 2 + random 1] call _fnc_spawnGroup;
		[_zoneID, _centre, _medium + _heavy, format["MKR_%1_MIN", _zoneID], 2 + random 1] call _fnc_spawnGroup;
		[_zoneID, _centre, _sentry, format["MKR_%1_MAX", _zoneID], 3 + random 2] call _fnc_spawnGroup;	
		[_zoneID, _centre, _team, format["MKR_%1_MIN", _zoneID], 2 + random 1] call _fnc_spawnGroup;
		[_zoneID, _centre, _squad, format["MKR_%1_MIN", _zoneID], 1 + random 1] call _fnc_spawnGroup;	
	};
	case "NameCity": { 
		[_zoneID, _centre, _light + _medium, format["MKR_%1_MAX", _zoneID], 2 + random 1] call _fnc_spawnGroup;
		[_zoneID, _centre, _medium + _heavy, format["MKR_%1_MIN", _zoneID], 1 + random 1] call _fnc_spawnGroup;
		[_zoneID, _centre, _sentry, format["MKR_%1_MAX", _zoneID], 2 + random 2] call _fnc_spawnGroup;
		[_zoneID, _centre, _team, format["MKR_%1_MIN", _zoneID], 1 + random 1] call _fnc_spawnGroup;
	};
	case "NameVillage": { 
		[_zoneID, _centre, _light + _medium, format["MKR_%1_MAX", _zoneID], 1 + random 1] call _fnc_spawnGroup;
		[_zoneID, _centre, _sentry, format["MKR_%1_MAX", _zoneID], 2 + random 2] call _fnc_spawnGroup;	
		[_zoneID, _centre, _team, format["MKR_%1_MIN", _zoneID], 1 + random 1] call _fnc_spawnGroup;
	};
	case "NameLocal": { 
		[_zoneID, _centre, _light + _medium, format["MKR_%1_MAX", _zoneID], 1 + random 1] call _fnc_spawnGroup;
		[_zoneID, _centre, _sentry, format["MKR_%1_MAX", _zoneID], 2 + random 2] call _fnc_spawnGroup;	
		[_zoneID, _centre, _team, format["MKR_%1_MIN", _zoneID], 1 + random 1] call _fnc_spawnGroup;
	};
	default { 
		if (random 100 > 50) then { 
			[_zoneID, _centre, _light, format["MKR_%1_MAX", _zoneID], random 1] call _fnc_spawnGroup; 
		};
		[_zoneID, _centre, _sentry, format["MKR_%1_MIN", _zoneID], 2 + random 1] call _fnc_spawnGroup;
		[_zoneID, _centre, _team, format["MKR_%1_MIN", _zoneID], 1 + random 1] call _fnc_spawnGroup;
	};
};

missionNamespace setVariable [format[ "ZMM_%1_PatrolsEnabled", _zoneID], FALSE];

TRUE