// Attempts to allow an urban objective (spawned by fill_towns) to be completed.
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
// [[0,0,0], 200, 2, [true, true, true, false]] call tg_fnc_spawnVehicle;
if !isServer exitWith {};

params ["_searchPos", "_inDist", "_count", ["_spawnType", [], [[]]], ["_buildingList", [], [[]]]];

_spawnType params [["_spawnAir", true, [true]],["_spawnLand", true, [true]],["_spawnSea", true, [true]],["_milSide", civilian, [civilian,""]]];

// Object Arrays
//private _ammoBoxes = ["Box_T_East_WpsSpecial_F", "Box_T_East_Wps_F", "Box_T_East_Ammo_F"];
private _vA = tg_vehicles_air_civ;
private _vL_lrg = tg_vehicles_land_civ_lrg;
private _vL_sml = tg_vehicles_land_civ_sml;
private _vS = tg_vehicles_sea_civ;
private _vU = tg_vehicles_util_civ;

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

private _counter = 0;

if (count _buildingList == 0) then {
	// Find all the nearby buildings.
	_buildingList = _searchPos nearObjects ["Building", _inDist];
};

if (count _buildingList == 0) exitWith {};

// Damage vehicle function.
private _fnc_damageVehicle = {
	params ["_veh"];
	_veh setFuel random 0.25;
	_veh setDamage random 0.75;
	_veh setVehicleAmmo random 0.2;
	_veh disableTIEquipment true;
	_veh lock true;
	
	/*{
		// Random chance of high damage.
		diag_log text format["spawnVehicle: Part %1",_x];
		if (random 1 > 0.9) then {
			_veh setHit [_x, random 1]; 
		} else {
			_veh setHit [_x, .2 + random 0.5]; 
		};
	} forEach (getAllHitPointsDamage _veh select 1);*/
	
	[_veh] spawn f_fnc_ace_medicGearConverter;
};

// Create vehicle function.
private _fnc_createVehicle = {
	params ["_id","_type","_loc","_dir"];
	
	// Try and find a safe position.
	// private _emptyPos = _loc findEmptyPosition [0, 25, _type];
	// if (count _emptyPos > 0) then { _loc = _emptyPos };
	
	// Create the vehicle.
	private _veh = _type createVehicle _loc;
	_veh setDir _dir;
	_veh enableDynamicSimulation true;
	
	[_veh] spawn _fnc_damageVehicle;
	_counter = _counter + 1;
	//[format ["[TG] DEBUG spawnVehicle: **CREATED** %1 at %2 D%3", typeOf _veh, _loc, round _dir]] call tg_fnc_debugMsg;
	
	if tg_debug then {
		private _vehMarker = createMarkerLocal [format["%1_%2", _type, round (_loc select 0) + _id], _loc];
		_vehMarker setMarkerType "Mil_dot";
		_vehMarker setMarkerSize [0.6,0.6];
		_vehMarker setMarkerColor "ColorBlue";
	};
};

//[format ["[TG] DEBUG spawnVehicle: Starting - 0/%1 with %2 objects found in R%7 [%3,%4,%5,%6]", _count, count _buildingList, _spawnAir, _spawnLand, _spawnSea, _milSide, _inDist]] call tg_fnc_debugMsg;

// Loop the objects and generate a relevant vehicle for each type.
{
	private _building = _x;
	
	//[format ["[TG] DEBUG spawnVehicle: Processing %1 (%2)", _building, typeOf _building]] call tg_fnc_debugMsg;	
	if _spawnSea then {
		switch (typeOf _building) do {
			// DOCK (Centre)
			case "Land_PierWooden_01_dock_F": {
					if (surfaceIsWater (_building modelToWorld [-8,0,1])) then {
						[
							_forEachIndex,
							selectRandom _vS,
							_building modelToWorld [-8,0,1],
							(getDir _building) + selectRandom [180,0]
						] call _fnc_createVehicle;
					};
					if (random 1 > 0.6) then {
						if (surfaceIsWater (getPosATL _building vectorAdd [0, 0, 1])) then {
							[
								_forEachIndex,
								selectRandom _vS,
								getPosATL _building vectorAdd [0, 0, 1],
								(getDir _building)
							] call _fnc_createVehicle;
						};
					};
			};
			// PIER / DOCK (L+R Sides)
			case "Land_PierWooden_03_F"; case "Land_PierConcrete_01_4m_ladders_F"; case "Land_PierWooden_02_hut_F": {
				private _rPos = selectRandom [_building modelToWorld [-7,0,1],_building modelToWorld [7,0,1]];
				
				if (surfaceIsWater _rPos) then {
					[
						_forEachIndex,
						selectRandom _vS,
						_rPos,
						(getDir _building) + selectRandom [180,0]
					] call _fnc_createVehicle;
				};
			};
		};
	};
	
	if _spawnLand then {
		switch (typeOf _building) do {
			// Mansion (Apex)
			case "Land_House_Big_03_F": {
				[ _forEachIndex, selectRandom _vL_sml, _building modelToWorld [17,-3,0.2], (getDir _building) + selectRandom [90,270] ] call _fnc_createVehicle;	
			};
			// Garage House (Apex)
			case "Land_GarageShelter_01_F": {
				[ _forEachIndex, selectRandom _vL_sml, _building modelToWorld [2.5,-3,0.2], (getDir _building) + selectRandom [0,180] ] call _fnc_createVehicle;	
			};
			// Warehouse (Apex)
			case "Land_Addon_05_F": {
				[ _forEachIndex, selectRandom _vL_sml, _building modelToWorld [-1,-14,0.3], (getDir _building) + selectRandom [0,180] ] call _fnc_createVehicle;	
			};
			// House Roof (Apex)
			case "Land_Shed_06_F": {
				[ _forEachIndex, selectRandom _vL_sml, _building modelToWorld [0,-2,0.3], (getDir _building) + selectRandom [90,270] ] call _fnc_createVehicle;	
			};
			// Garage
			case "Land_i_Garage_V2_F"; case "Land_i_Garage_V1_F": {
				[ _forEachIndex, selectRandom _vL_sml, _building modelToWorld [0,0,0.2], (getDir _building) + selectRandom [0,180] ] call _fnc_createVehicle;	
			};
			// Yard Roof
			case "Land_SM_01_shelter_wide_F"; case "Land_SM_01_shelter_narrow_F"; case "Land_SCF_01_shed_F"; case "Land_Shed_Small_F"; case "Land_Shed_Big_F": {
				[ _forEachIndex, selectRandom (_vL_lrg + _vL_sml), _building modelToWorld [0,0,0.2], (getDir _building) + selectRandom [0,180] ] call _fnc_createVehicle;	
			};
			// WAREHOUSES (Front)
			case "Land_Warehouse_03_F": {
				private _rPos = selectRandom [_building modelToWorld [1,-11,0.2],_building modelToWorld [-7,-11,0.2]];
				[
					_forEachIndex,
					if (_milSide == west) then { selectRandom _vL_sml } else { selectRandom (_vL_lrg + _vL_sml) }, // West large vehicles are too long!
					_rPos,
					if (isOnRoad _rPos) then { random 360 } else  { (getDir _building) + selectRandom [180,0] }	
				] call _fnc_createVehicle;
			};
			// WORKSHOP (Front)
			case "Land_FuelStation_01_workshop_F": {
				private _rPos = selectRandom [_building modelToWorld [3,-1,0.2],_building modelToWorld [-3,-9,0.2]];
				[ _forEachIndex, selectRandom (_vU + _vL_sml), _rPos, if (isOnRoad _rPos) then { random 360 } else { (getDir _building) + selectRandom [180,0] } ] call _fnc_createVehicle;
			};
			// WAREHOUSES (White)
			case "Land_SM_01_shed_unfinished_F"; case "Land_SM_01_shed_F"; case "Land_u_Shed_Ind_F"; case "Land_i_Shed_Ind_F": {
				[ _forEachIndex, selectRandom (_vL_lrg + _vL_sml), _building modelToWorld [9,-5,0.2], (getDir _building) + selectRandom [270,90] ] call _fnc_createVehicle;		
			};
			// FUEL STATIONS (Beside Pumps)
			case "Land_fs_roof_F"; case "Land_FuelStation_Shed_F"; case "Land_FuelStation_01_roof_F"; case "Land_FuelStation_02_roof_F": {
				private _rPos = selectRandom [_building modelToWorld [0,4.5,0.2],_building modelToWorld [0,-4.5,0.2]];
				[ _forEachIndex, selectRandom (_vU + _vL_lrg + _vL_sml), _rPos, (getDir _building) + selectRandom [270,90] ] call _fnc_createVehicle;
			};
		};
	};
	
	if _spawnAir then {
		switch (typeOf _building) do {
			// Helipads
			case "Land_HelipadCircle_F"; case "Land_HelipadSquare_F": {
					[ _forEachIndex, selectRandom _vA, _building modelToWorld [0,0,0.2], random 360 ] call _fnc_createVehicle;		
			};
			// Hangar
			case "Land_Airport_01_hangar_F"; case "Land_TentHangar_V1_F": {
					[ _forEachIndex, selectRandom _vA, _building modelToWorld [0,-25,0.2], (getDir _building) + selectRandom [0,180] ] call _fnc_createVehicle;		
			};
			// Hangar (Apex)
			case "Land_Hangar_F": {
					[ _forEachIndex, selectRandom _vA, _building modelToWorld [0,-35,0.2], (getDir _building) + selectRandom [0,180] ] call _fnc_createVehicle;		
			};
		};
	};
	
	// Break the loop if we've reached the requested spawn limit.
	if (_counter >= round _count) exitWith {};
} forEach _buildingList;

//[format ["[TG] DEBUG spawnVehicle: Finished - %1/%2 Created", _counter, _count]] call tg_fnc_debugMsg;