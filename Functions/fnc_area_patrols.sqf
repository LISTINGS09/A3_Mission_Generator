// Wait for Location Selection.
params [ ["_zoneID", 0], ["_locType", ""], ["_markerOverride", ""] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
private _side = missionNamespace getVariable [format["ZMM_%1_enemySide", _zoneID], EAST];

if (_locType isEqualTo "") then { _locType = type (nearestLocation [_centre,""]) };

private _areaLRG = format["MKR_%1_MAX", _zoneID];
private _areaSML = format["MKR_%1_MIN", _zoneID];

// Overwrite the defaults if a marker was forced
if !(_markerOverride isEqualTo "") then { _areaLRG = _markerOverride; _areaSML = _markerOverride; };

_fnc_spawnGroup = {
	params ["_zoneID", "_spawnPos", ["_unitType", []], ["_marker", ""], ["_count", 0]];
	
	if (round _count <= 0) exitWith {};
	
	private _side = missionNamespace getVariable [format["ZMM_%1_enemySide", _zoneID], EAST];
	private _unitClass = [];
	
	if (_unitType isEqualType "") then {
		_unitClass = switch _unitType do {
			case "MEDIUM": { missionNamespace getVariable [format["ZMM_%1Veh_Medium", _side], []] };
			case "HEAVY": { missionNamespace getVariable [format["ZMM_%1Veh_Heavy", _side], []] };
			case "CAS": { missionNamespace getVariable [format["ZMM_%1Veh_CasH",_side], (missionNamespace getVariable [format["ZMM_%1Veh_CasP",_side],[]])] };
			default { missionNamespace getVariable [format["ZMM_%1Veh_Light", _side], []] };
		};
	} else {
		_unitClass = _unitType;
	};
	
	if (_unitClass isEqualType []) then { 
		if (count _unitClass isEqualTo 0) exitWith { ["ERROR", format["Zone%1 - Area Patrols - (%2) No valid units passed, were global unit variables declared?", _zoneID, _side]] call zmm_fnc_logMsg };
	};

	for "_i" from 0 to _count do {	
		// If type is a number populate a random array of men
		if (_unitType isEqualType 1) then {
			private _enemyMen = missionNamespace getVariable [format["ZMM_%1Man", _side], ["O_Solider_F"]];
			private _enemyTeam = []; 
			for "_i" from 0 to (_unitType - 1) do {  _enemyTeam set [_i, selectRandom _enemyMen] };
			_unitClass = [[_enemyTeam]];
		};
		
		// If _unitClass is array, extract the custom init.
		(selectRandom _unitClass) params [["_type", objNull], ["_customInit", ""]];

		if (_type isEqualType "") then {
			if (isClass (configFile >> "CfgVehicles" >> _type)) then {
				_isAir = false;
				if ("Air" in ([(configFile >> "CfgVehicles" >> _type), true] call BIS_fnc_returnParents)) then { _isAir = true };
								
				// Spawn vehicle on a road.
				private _roads = (getMarkerPos _marker nearRoads (getMarkerSize _marker select 0)) select { count (roadsConnectedTo _x) > 0};

				if (count _roads > 0) then { _spawnPos = position (selectRandom _roads) };
				
				["DEBUG", format["Zone%1 - Area Patrols - Spawning Vehicle (%3) '%2' [%4 - CINT: %5]", _zoneID, _type, _side, _spawnPos, _customInit]] call zmm_fnc_logMsg;
				
				private _grpVeh = createVehicle [_type, if _isAir then { [0,0,0] } else { _spawnPos }, [], 0, if _isAir then {"FLY"} else {"NONE"}];
				
				if !(_customInit isEqualTo "") then { call compile _customInit; };
				if !_isAir then { _grpVeh enableDynamicSimulation true };
				
				createVehicleCrew _grpVeh;
				
				// Switch units side to Zone side.
				if (side driver _grpVeh != _side) then {
					private _group = createGroup [_side, true];
					(crew _grpVeh) joinSilent _group;
				};
				
				{ _x addCuratorEditableObjects [ crew _grpVeh, true ] } forEach allCurators;
				
				
				[driver _grpVeh, _marker, "SHOWMARKER"] spawn zmm_fnc_aiUPS;
			} else {
				["ERROR", format["Invalid vehicle class: %1", _type]] call zmm_fnc_logMsg;
			};
		} else {
			["DEBUG", format["Zone%1 - Area Patrols - Spawning Group (%3) '%2' [POS: Random - CINT: %4]", _zoneID, if (_type isEqualType configFile) then { configName _type } else { _type }, _side], _customInit] call zmm_fnc_logMsg;
			
			private _group = [[0,0,0], _side, _type] call BIS_fnc_spawnGroup;
			_group spawn { sleep 30; _this enableDynamicSimulation true };
				
			if !(_customInit isEqualTo "") then {
				private _grpVeh = selectRandom (units _group select { vehicle _x != _x });
				call compile _customInit;
			};
			
			{ _x addCuratorEditableObjects [ units _group, true ] } forEach allCurators;
			
			
			[leader _group, _marker, "SHOWMARKER", "RANDOM"] spawn zmm_fnc_aiUPS;
		};
		
		if (time > 0) then { uiSleep 1 };
	};
};

private _str = selectRandom ["Heavy", "Normal", "Light"];
private _multiplier = missionNamespace getVariable ["ZZM_Diff", 1];
private _customInfSml = missionNamespace getVariable ["ZMM_CustomSentry", -1];
private _customInfMed = missionNamespace getVariable ["ZMM_CustomTeam", -1];
private _customInfLrg = missionNamespace getVariable ["ZMM_CustomSquad", -1];
private _customVehSml = missionNamespace getVariable ["ZMM_CustomLight", -1];
private _customVehMed = missionNamespace getVariable ["ZMM_CustomMedium", -1];
private _customVehLrg = missionNamespace getVariable ["ZMM_CustomHeavy", -1];

["DEBUG", format["Zone%1 - Area Patrols - Creating (%2) - %3 %4", _zoneID, _locType, _str, if (([_customInfSml,_customInfMed,_customInfLrg,_customVehSml,_customVehMed,_customVehLrg] findIf { _x >= 0 }) >= 0) then { "CUSTOM" } else { "DEFAULT" }]] call zmm_fnc_logMsg;

switch (_locType) do {
	case "Airport": { 		
		[_zoneID, _centre, "LIGHT", _areaLRG, if (_customVehSml >= 0) then { _customVehSml } else { (2 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, "MEDIUM", _areaLRG, if (_customVehMed >= 0) then { _customVehMed } else { (2 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, "HEAVY", _areaSML, if (_customVehLrg >= 0) then { _customVehLrg } else { (2 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, 2, _areaLRG, if (_customInfSml >= 0) then { _customInfSml } else { (3 * _multiplier) + random 2 }] spawn _fnc_spawnGroup;	
		[_zoneID, _centre, 4, _areaSML, if (_customInfMed >= 0) then { _customInfMed } else { (2 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;	
		[_zoneID, _centre, 8, _areaSML, if (_customInfLrg >= 0) then { _customInfLrg } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
	};
	case "NameCityCapital": { 
		[_zoneID, _centre, "LIGHT", _areaLRG, if (_customVehSml >= 0) then { _customVehSml } else { (2 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, "MEDIUM", _areaLRG, if (_customVehMed >= 0) then { _customVehMed } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, "HEAVY", _areaSML, if (_customVehLrg >= 0) then { _customVehLrg } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, 2, _areaLRG, if (_customInfSml >= 0) then { _customInfSml } else { (3 * _multiplier) + random 2 }] spawn _fnc_spawnGroup;	
		[_zoneID, _centre, 4, _areaSML, if (_customInfMed >= 0) then { _customInfMed } else { (2 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, 8, _areaSML, if (_customInfLrg >= 0) then { _customInfLrg } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;	
	};
	case "NameCity": { 
		[_zoneID, _centre, "LIGHT", _areaLRG, if (_customVehSml >= 0) then { _customVehSml } else { (2 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, "MEDIUM", _areaLRG, if (_customVehMed >= 0) then { _customVehMed } else { (2 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, "HEAVY", _areaSML, if (_customVehLrg >= 0) then { _customVehLrg } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, 2, _areaLRG, if (_customInfSml >= 0) then { _customInfSml } else { (2 * _multiplier) + random 2 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, 4, _areaSML, if (_customInfMed >= 0) then { _customInfMed } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, 8, _areaLRG, _customInfLrg] spawn _fnc_spawnGroup;  // Only valid for custom override.
	};
	case "NameVillage": { 
		[_zoneID, _centre, "LIGHT", _areaLRG, if (_customVehSml >= 0) then { _customVehSml } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, "MEDIUM", _areaLRG, if (_customVehMed >= 0) then { _customVehMed } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, "HEAVY", _areaSML, _customVehLrg] spawn _fnc_spawnGroup;  // Only valid for custom override.
		[_zoneID, _centre, 2, _areaLRG, if (_customInfSml >= 0) then { _customInfSml } else { (2 * _multiplier) + random 2 }] spawn _fnc_spawnGroup;	
		[_zoneID, _centre, 4, _areaSML, if (_customInfMed >= 0) then { _customInfMed } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, 8, _areaLRG, _customInfLrg] spawn _fnc_spawnGroup;  // Only valid for custom override.
	};
	case "NameLocal": { 
		[_zoneID, _centre, "LIGHT", _areaLRG, if (_customVehSml >= 0) then { _customVehSml } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, "MEDIUM", _areaLRG, if (_customVehMed >= 0) then { _customVehMed } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, "HEAVY", _areaSML, _customVehLrg] spawn _fnc_spawnGroup;  // Only valid for custom override.
		[_zoneID, _centre, 2, _areaLRG, if (_customInfSml >= 0) then { _customInfSml } else { (2 * _multiplier) + random 2 }] spawn _fnc_spawnGroup;	
		[_zoneID, _centre, 4, _areaSML, if (_customInfMed >= 0) then { _customInfMed } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
		[_zoneID, _centre, 8, _areaLRG, _customInfLrg] spawn _fnc_spawnGroup;  // Only valid for custom override.
	};
	default { 		
		switch (_str) do {
			case "Heavy": { 
				[_zoneID, _centre, "LIGHT", _areaLRG, if (_customVehSml >= 0) then { _customVehSml } else { (1 * _multiplier) }] spawn _fnc_spawnGroup; 
				[_zoneID, _centre, "MEDIUM", _areaLRG, if (_customVehMed >= 0) then { _customVehMed } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
				[_zoneID, _centre, "HEAVY", _areaSML, _customVehLrg] spawn _fnc_spawnGroup;  // Only valid for custom override.
				[_zoneID, _centre, 2, _areaSML, if (_customInfSml >= 0) then { _customInfSml } else { (3 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
				[_zoneID, _centre, 4, _areaSML, if (_customInfMed >= 0) then { _customInfMed } else { (2 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
				[_zoneID, _centre, 8, _areaLRG, _customInfLrg] spawn _fnc_spawnGroup;  // Only valid for custom override.
			};
			case "Light": { 
				[_zoneID, _centre, "LIGHT", _areaLRG, if (_customVehSml >= 0) then { _customVehSml } else { (1 * _multiplier) }] spawn _fnc_spawnGroup;
				[_zoneID, _centre, "MEDIUM", _areaLRG, _customVehMed] spawn _fnc_spawnGroup; // Only valid for custom override.
				[_zoneID, _centre, "HEAVY", _areaSML, _customVehLrg] spawn _fnc_spawnGroup;  // Only valid for custom override.
				[_zoneID, _centre, 2, _areaSML, if (_customInfSml >= 0) then { _customInfSml } else { (3 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
				[_zoneID, _centre, 4, _areaLRG, _customInfMed] spawn _fnc_spawnGroup;  // Only valid for custom override.
				[_zoneID, _centre, 8, _areaLRG, _customInfLrg] spawn _fnc_spawnGroup;  // Only valid for custom override.
			};
			default { 
				[_zoneID, _centre, "LIGHT", _areaLRG, if (_customVehSml >= 0) then { _customVehSml } else { (1 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
				[_zoneID, _centre, "MEDIUM", _areaLRG, _customVehMed] spawn _fnc_spawnGroup; // Only valid for custom override.
				[_zoneID, _centre, "HEAVY", _areaSML, _customVehLrg] spawn _fnc_spawnGroup;  // Only valid for custom override.
				[_zoneID, _centre, 2, _areaSML, if (_customInfSml >= 0) then { _customInfSml } else { (2 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
				[_zoneID, _centre, 4, _areaSML, if (_customInfMed >= 0) then { _customInfMed } else { (2 * _multiplier) + random 1 }] spawn _fnc_spawnGroup;
				[_zoneID, _centre, 8, _areaLRG, _customInfLrg] spawn _fnc_spawnGroup;  // Only valid for custom override.
			};
		};
	};
};

missionNamespace setVariable [format[ "ZMM_%1_PatrolsEnabled", _zoneID], false];
missionNamespace setVariable [format[ "ZMM_%1_PatrolsStrength", _zoneID], _str];

true