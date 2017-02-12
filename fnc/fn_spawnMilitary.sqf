// Populates soliders and static weapons around a given radius.
//
// *** PARAMETERS ***
// _searchPos	ARRAY		Position to search around.
//	_inDist		INT			Distance to search around.
// _count		INT			How many vehicles to create (won't ever be more than _buildingList)
// _spawnType	ARRAY		Array of 4 boolean indicators to spawn vehicles of type [air, land, sea, military]
//
// *** RETURNS ***
// Nothing
//
// *** USAGE ***
// [[0,0,0], 200, 2, [true, true, true, false]] call tg_fnc_spawnMilitary;
if !isServer exitWith {};

params ["_searchPos", "_inDist", "_count", ["_milSide", civilian, [civilian,""]], ["_milSoldier","",[""]], ["_buildingList", [], [[]]]];

// Object Arrays
private _vA = tg_vehicles_air_civ;
private _vL_lrg = tg_vehicles_land_civ_lrg;
private _vL_sml = tg_vehicles_land_civ_sml;
private _vS = tg_vehicles_sea_civ;
private _vU = tg_vehicles_util_civ;
private _vStatic = tg_vehicles_static;

switch (toLower format["%1",_milSide]) do {
	case "west": {
		_milSide = west;
		_vA = tg_vehicles_air_west;
		_vL_lrg = tg_vehicles_land_west_lrg;
		_vL_sml = tg_vehicles_land_west_sml;
		_vS = tg_vehicles_sea_west;
		_vU = tg_vehicles_util_west;
	};
	case "east": {
		_milSide = east;
		_vA = tg_vehicles_air_east;
		_vL_lrg = tg_vehicles_land_east_lrg;
		_vL_sml = tg_vehicles_land_east_sml;
		_vS = tg_vehicles_sea_east;
		_vU = tg_vehicles_util_east;
	};
	case "guer": {
		_milSide = independent;
		_vA = tg_vehicles_air_guer;
		_vL_lrg = tg_vehicles_land_guer_lrg;
		_vL_sml = tg_vehicles_land_guer_sml;
		_vS = tg_vehicles_sea_guer;
		_vU = tg_vehicles_util_guer;
	};
	default { 
		_milSide = civilian;
	};
};

if (_milSoldier != "" && _milSide != civilian) then {
	private _milGroup = [_searchPos, _milSide, [_milSoldier, _milSoldier, _milSoldier, _milSoldier]] call BIS_fnc_spawnGroup;
	[_milGroup, _searchPos, 50] call bis_fnc_taskPatrol;
};
private _counter = 0;

if (count _buildingList == 0) then {
	// Find all the nearby buildings.
	_buildingList = _searchPos nearObjects ["Building", _inDist];
};

if (count _buildingList == 0) exitWith {};

// Damage vehicle function.
private _fnc_damageVehicle = {
	params ["_veh"];
	_veh setVehicleAmmo random 0.4;
	_veh disableTIEquipment true;	
	[_veh] spawn f_fnc_ace_medicGearConverter;
};

// Create vehicle function.
private _fnc_createVehicle = {
	params ["_id","_type","_loc","_dir"];
	
	// Try and find a safe position.
	// private _emptyPos = _loc findEmptyPosition [0, 25, _type];
	// if (count _emptyPos > 0) then { _loc = _emptyPos };
	
	//[format ["[TG] DEBUG spawnMilitary: **CREATED** %1 at %2 D%3", _type, _loc, round _dir]] call tg_fnc_debugMsg;
	
	// Create the vehicle.
	private _veh = _type createVehicle _loc;
	_veh setDir _dir;
	_veh enableDynamicSimulation true;
	
	[_veh] spawn _fnc_damageVehicle;
	
	private _gunner = (createGroup _milSide) createUnit [_milSoldier,[0,0,0], [], 0, "NONE"];
	_gunner moveInGunner _veh;
	_gunner enableDynamicSimulation true;
	
	if tg_debug then {
		private _vehMarker = createMarkerLocal [format["%1_%2", _type, round (_loc select 0) + _id], _loc];
		_vehMarker setMarkerType "Mil_dot";
		_vehMarker setMarkerSize [0.8,0.8];
		_vehMarker setMarkerColor "ColorGreen";
	};
	
	_counter = _counter + 1;
	
	_veh
};

// Create unit function.
private _fnc_createUnit = {
	params ["_id","_type","_loc","_dir","_side",["_isBuilding",false,[false]]];
	
	private _unit = (createGroup _side) createUnit [_type, _loc, [], 0, "NONE"];
	_unit setDir _dir;
	_unit setFormDir _dir;
		
	// buildingPos returns ATL over ground and ASL over water
	if ((getTerrainHeightASL _loc) < 0 && {_isBuilding}) then {
		_unit setPosASL _loc;
	} else {
		_unit setPosATL _loc;
	};

	_unit enableDynamicSimulation true;
	
	if tg_debug then {
		private _vehMarker = createMarkerLocal [format["%1_%2", _type, round (_loc select 0) + _id], _loc];
		_vehMarker setMarkerType "Mil_dot";
		_vehMarker setMarkerSize [0.8,0.8];
		_vehMarker setMarkerColor "ColorOrange";
	};
	
	_counter = _counter + 1;
	
	//[format ["[TG] DEBUG spawnMilitary: **CREATED** %1 at %2 D%3", _type, _loc, round _dir]] call tg_fnc_debugMsg;
	
	sleep 1;
	
	_unit
};

[format ["[TG] DEBUG spawnMilitary: Starting - 0/%1 with %2 objects found in R%7 [%3,%4]", round _count, count _buildingList, _inDist, _milSide, _milSoldier]] call tg_fnc_debugMsg;

// Loop the objects and generate a relevant vehicle for each type.
{
	private _building = _x;
	
	//[format ["[TG] DEBUG spawnMilitary: Processing %1 (%2)", _building, typeOf _building]] call tg_fnc_debugMsg;
	
	if (_milSide in [east, west, resistance]) then {
		//diag_log text format["spawnMilitary checking: %1", typeOf _building];
		switch (typeOf _building) do {
			// Small Bunker
			case "Land_BagBunker_Small_F"; case "Land_BagBunker_01_small_green_F"; case "Land_fortified_nest_small_EP1"; case "Fort_Nest"; case "Land_fortified_nest_small": {
				if (random 1 > 0.75) then { 
					[ _forEachIndex, selectRandom _vStatic, _building modelToWorld [0,0,0], getDir _building + 180 ] call _fnc_createVehicle;
				} else {
					[ _forEachIndex, _milSoldier, selectRandom (_building buildingPos -1), getDir _building + 180, _milSide, true ] call _fnc_createUnit;
				};
			};
			// Bunker Tower
			case "Land_BagBunker_Tower_F"; case "Land_HBarrier_01_tower_green_F"; case "Land_Fort_Watchtower"; case "Land_Fort_Watchtower_EP1": {
				private _man = [ _forEachIndex, _milSoldier, _building modelToWorld [0,1,2.78], getDir _building, _milSide ] call _fnc_createUnit;
				_man setUnitPos "DOWN";
				
				if (random 1 > 0.75) then { 
					[ _forEachIndex, selectRandom _vStatic, _building modelToWorld [0,-2,2.79], getDir _building + 180 ] call _fnc_createVehicle;
				} else {
					[ _forEachIndex, _milSoldier, _building modelToWorld [0,-2,2.79], getDir _building + 180, _milSide ] call _fnc_createUnit;
				};
			};
			// Large Bunker
			case "Land_BagBunker_Large_F"; case "Land_BagBunker_01_large_green_F"; case "Land_fortified_nest_big"; case "Land_fortified_nest_big_EP1": {
				{
					[ _forEachIndex, _milSoldier, selectRandom (_building buildingPos -1), random 360, _milSide, true ] call _fnc_createUnit;
				} forEach [1,2,3];
			};			
			// Cargo HQ
			case "Land_Cargo_HQ_V1_F"; case "Land_Medevac_HQ_V1_F"; case "Land_Cargo_HQ_V2_F"; case "Land_Cargo_HQ_V3_F"; case "Land_Cargo_HQ_V4_F"; case "Land_Research_HQ_F": {
				{
					[ _forEachIndex, _milSoldier, selectRandom (_building buildingPos -1), random 360, _milSide, true ] call _fnc_createUnit;
				} forEach [1,2,3];
			};
			// Cargo Tower
			case "Land_Cargo_Tower_V1_No1_F"; case "Land_Cargo_Tower_V1_No2_F"; case "Land_Cargo_Tower_V1_No3_F"; case "Land_Cargo_Tower_V1_No4_F"; case "Land_Cargo_Tower_V1_No5_F";
			case "Land_Cargo_Tower_V1_No6_F"; case "Land_Cargo_Tower_V1_No7_F"; case "Land_Cargo_Tower_V3_F"; case "Land_Cargo_Tower_V1_F"; case "Land_Cargo_Tower_V2_F"; case "Land_Cargo_Tower_V4_F": {
				{
					[ _forEachIndex, _milSoldier, selectRandom (_building buildingPos -1), random 360, _milSide, true ] call _fnc_createUnit;
				} forEach [1,2,3];
			};
			// Cargo Post
			case "Land_Cargo_Patrol_V3_F"; case "Land_Cargo_Patrol_V1_F"; case "Land_Cargo_Patrol_V2_F"; case "Land_Cargo_Patrol_V4_F": {
				if (random 1 > 0.75) then { 
					[ _forEachIndex, _milSoldier, selectRandom (_building buildingPos -1), getDir _building + 180, _milSide, true ] call _fnc_createUnit;
				};
			};
			// Cargo House
			case "Land_Cargo_House_V3_F"; case "Land_Cargo_House_V1_F"; case "Land_Medevac_house_V1_F";
			case "Land_Cargo_House_V2_F"; case "Land_Cargo_House_V4_F"; case "Land_Research_house_V1_F": {
				if (random 1 > 0.75) then { 
					[ _forEachIndex, _milSoldier, selectRandom (_building buildingPos -1), getDir _building + 180, _milSide, true ] call _fnc_createUnit;
				};
			};
			// Watchtower
			case "Land_HBarrier_01_big_tower_green_F"; case "Land_HBarrierTower_F": {
				if (random 1 > 0.65) then { 
					[ _forEachIndex, _milSoldier, selectRandom (_building buildingPos -1), getDir _building + 180, _milSide, true ] call _fnc_createUnit;
				};
			};
			// Barracks
			case "Land_Barracks_01_dilapidated_F"; case "Land_Barracks_01_grey_F"; case "Land_Barracks_01_camo_F"; case "Land_i_Barracks_V1_F"; case "Land_i_Barracks_V2_F"; 
			case "Land_u_Barracks_V2_F"; case "Land_Mil_Barracks_i"; case "Land_Mil_Barracks_i_EP1"; case "Land_Budova4"; case "Land_Budova4_in": {
				{
					[ _forEachIndex, _milSoldier, selectRandom (_building buildingPos -1), random 360, _milSide, true ] call _fnc_createUnit;
				} forEach [1,2];
			};
			// Any building with more than 5 positions and less than 5 men total will spawn a unit.
			default {
				private _bP = _building buildingPos -1;
				if (count _bP > 4) then {
					if (random 1 > 0.85 || _counter < 5) then { 
						[ _forEachIndex, _milSoldier, selectRandom _bP, random 360, _milSide, true ] call _fnc_createUnit;
					};
				};
			};
		};
	};
	
	// Break the loop if we've reached the requested spawn limit.
	if (_counter >= round (_count)) exitWith {};
} forEach _buildingList;

[format ["[TG] DEBUG spawnMilitary: Finished - %1/%2 Created", _counter, round _count]] call tg_fnc_debugMsg;