// Only run on server
if !isServer exitWith {};

// ----------- VARIABLES START ---------------

tg_taskFolder = "scripts\taskGenerator"; // Location used for loading the tasks.
tg_missionTypes = ["mainMission", "sideMission"]; // Used globally and variables are built from these strings.. // 

tg_fnc_taskTestTaskA = compileFinal preprocessFileLineNumbers format["%1\tasks\crash_site.sqf", tg_taskFolder];
tg_fnc_taskTestTaskB = compileFinal preprocessFileLineNumbers format["%1\tasks\kill_leader.sqf", tg_taskFolder];
tg_fnc_taskTestTaskC = compileFinal preprocessFileLineNumbers format["%1\tasks\destroy_tower.sqf", tg_taskFolder];
tg_fnc_taskTestTaskD = compileFinal preprocessFileLineNumbers format["%1\tasks\radio_camp.sqf", tg_taskFolder];
//tg_fnc_taskTestTaskE = compileFinal preprocessFileLineNumbers format["%1\tasks\clear_location.sqf", tg_taskFolder];

// List of available main missions.
tg_mainMission_list = [
	"tg_fnc_taskTestTaskA",
	"tg_fnc_taskTestTaskB",
	"tg_fnc_taskTestTaskC",
	"tg_fnc_taskTestTaskD"
];

// List of available side missions.
tg_sideMission_list = [
	"tg_fnc_taskTestTaskA",
	"tg_fnc_taskTestTaskB",
	"tg_fnc_taskTestTaskC",
	"tg_fnc_taskTestTaskD"
];

// Pre-filled arrays used in fn_spawnVeicle.
// *** VANILLA ***
/*
// FORMAT: <SIDE> = [[<SIDE>, <DAC UNIT CONFIG>, <DEFAULT SOLIDER>], ...]
private _fNATO = 	[west, [1, 1, 1, (selectRandom [1, 5, 9])], "B_Soldier_F", "Flag_NATO_F"]; // West Side & DAC settings (NATO).
private _fNATOP = 	[west, [1, 6, 1, (selectRandom [1, 5, 9])], "B_T_Soldier_F", "Flag_NATO_F"]; // West Side & DAC settings (NATO PACIFIC).
private _fCTRG = 	[west, [1, 7, 1, (selectRandom [1, 5, 9])], "B_CTRG_Soldier_tna_F", "Flag_CTRG_F"]; // West Side & DAC settings (NATO CTRG PACIFIC).
private _fFIAB = 	[west, [1, 11, 1, (selectRandom [3, 7, 11])], "B_G_Soldier_F", "Flag_FIA_F"];	// West Side & DAC settings (FIA).
private _fCSAT = 	[east, [0, 0, 0, (selectRandom [0, 4, 8])], "O_Soldier_F", "Flag_CSAT_F"]; // East Side & DAC settings (CSAT).
private _fCSATP = 	[east, [0, 4, 0, (selectRandom [0, 4, 8])], "O_T_Soldier_F", "Flag_CSAT_F"]; // East Side & DAC settings (CSAT PACIFIC).
private _fVIPER = 	[east, [0, 5, 0, (selectRandom [0, 4, 8])], "O_V_Soldier_ghex_F", "Flag_Viper_F"]; // East Side & DAC settings (CSAT VIPER).
private _fFIAE = 	[east, [0, 10, 0, (selectRandom [0, 4, 8])], "O_G_Soldier_F", "Flag_FIA_F"]; // East Side & DAC settings (FIA).
private _fAAF = 	[independent, [2, 2, 2, (selectRandom [2, 6, 10])], "I_Soldier_F", "Flag_AAF_F"]; // Guer Side & DAC settings (AAF).
private _fSYND = 	[independent, [2, 8, 2, (selectRandom [2, 6, 10])], "I_C_Soldier_Bandit_7_F", "Flag_Syndikat_F"]; // Guer Side & DAC settings (SYND).
private _fPARA =	[independent, [2, 9, 2, (selectRandom [2, 6, 10])], "I_C_Soldier_Para_1_F", "Flag_Syndikat_F"]; // Guer Side & DAC settings (PARA).
private _fFIAG = 	[independent, [2, 12, 2, (selectRandom [2, 6, 10])], "I_G_Soldier_F", "Flag_FIA_F"]; // Guer Side & DAC settings (FIA).

tg_sideWest = [_fNATOP, _fCTRG, _fFIAB];
tg_sideEast = [_fCSATP, _fVIPER, _fFIAE];
tg_sideGuer = [_fAAF, _fSYND, _fPARA, _fFIAG];

tg_vehicles_air_civ = ["C_Heli_Light_01_civil_F"];
tg_vehicles_air_west = ["B_Heli_Light_01_armed_F", "B_Heli_Transport_01_F", "B_Heli_Transport_01_camo_F", "B_CTRG_Heli_Transport_01_sand_F", "B_CTRG_Heli_Transport_01_tropic_F"];
tg_vehicles_air_east = ["O_Heli_Light_02_F", "O_Heli_Light_02_unarmed_F"];
tg_vehicles_air_guer = ["I_Heli_light_03_F", "I_Heli_light_03_unarmed_F"];
tg_vehicles_land_civ_lrg = ["C_Truck_02_transport_F", "C_Truck_02_covered_F", "C_Van_01_transport_F"];
tg_vehicles_land_civ_sml = ["C_Offroad_01_F", "C_Hatchback_01_F", "C_Offroad_02_unarmed_F"];
tg_vehicles_land_west_sml = ["B_CTRG_LSV_01_light_F", "B_G_Offroad_01_F", "B_T_LSV_01_unarmed_F", "B_T_LSV_01_armed_F"];
tg_vehicles_land_west_lrg = ["B_T_MRAP_01_F", "B_T_Truck_01_transport_F", "B_T_Truck_01_mover_F", "B_G_Van_01_transport_F"];
tg_vehicles_land_east_sml = ["O_LSV_02_unarmed_F", "O_T_LSV_02_unarmed_F", "O_G_Offroad_01_F"];
tg_vehicles_land_east_lrg = ["O_T_MRAP_02_ghex_F", "O_T_Truck_03_transport_ghex_F", "O_T_Truck_03_covered_ghex_F", "O_MRAP_02_F", "O_Truck_02_transport_F", "O_Truck_02_covered_F", "O_Truck_03_covered_F", "O_Truck_03_transport_F", "O_G_Van_01_transport_F"];
tg_vehicles_land_guer_sml = ["I_G_Offroad_01_F", "I_C_Offroad_02_unarmed_F"];
tg_vehicles_land_guer_lrg = ["I_MRAP_03_F", "I_Truck_02_transport_F", "I_Truck_02_covered_F", "I_G_Van_01_transport_F"];
tg_vehicles_sea_civ = ["C_Boat_Civil_01_rescue_F", "C_Boat_Transport_02_F", "C_Rubberboat"];
tg_vehicles_sea_west = ["B_Boat_Armed_01_minigun_F", "B_Boat_Transport_01_F", "B_Lifeboat"];
tg_vehicles_sea_east = ["O_Boat_Armed_01_hmg_F", "O_Boat_Transport_01_F", "O_Lifeboat"];
tg_vehicles_sea_guer = ["I_Boat_Armed_01_minigun_F", "I_Boat_Transport_01_F", "I_Lifeboat"];
tg_vehicles_util_civ = ["C_Van_01_fuel_F", "C_Truck_02_fuel_F", "C_Truck_02_box_F", "C_Van_01_box_F"];
tg_vehicles_util_west = ["B_T_Truck_01_medical_F", "B_T_Truck_01_Repair_F", "B_T_Truck_01_fuel_F", "B_G_Van_01_fuel_F"];
tg_vehicles_util_east = ["O_T_Truck_03_fuel_ghex_F", "O_T_Truck_03_ammo_ghex_F", "O_T_Truck_03_medical_ghex_F", "O_Truck_02_Ammo_F", "O_Truck_02_fuel_F", "O_Truck_02_medical_F", "O_G_Van_01_fuel_F"];
tg_vehicles_util_guer = ["I_Truck_02_fuel_F", "I_Truck_02_medical_F", "I_Truck_02_box_F", "I_G_Van_01_fuel_F"];
tg_vehicles_ammo = ["Box_Syndicate_Ammo_F", "Box_Syndicate_Wps_F", "Box_Syndicate_WpsLaunch_F"];
tg_vehicles_static = ["B_GMG_01_high_F","B_HMG_01_high_F"];
*/
// *** RHS ***
// FORMAT: <SIDE> = [[<SIDE>, <DAC UNIT CONFIG>, <DEFAULT SOLIDER>], ...]
private _fMSV_EMR = [east, [0, 17, 0, (selectRandom [0, 4, 8])], "rhs_msv_emr_rifleman", "rhs_Flag_Russia_F"];
private _fMSV_FLORA = [east, [0, 18, 0, (selectRandom [0, 4, 8])], "rhs_msv_rifleman", "rhs_Flag_Russia_F"];
private _fVDV_EMR = [east, [0, 19, 0, (selectRandom [0, 4, 8])], "rhs_vdv_rifleman", "rhs_Flag_vdv_F"];
private _fVDV_DES = [east, [0, 20, 0, (selectRandom [0, 4, 8])], "rhs_vdv_des_rifleman", "rhs_Flag_vdv_F"];
private _fVDV_FLORA = [east, [0, 21, 0, (selectRandom [0, 4, 8])], "rhs_vdv_flora_rifleman", "rhs_Flag_vdv_F"];
private _fVDV_MFLORA = [east, [0, 22, 0, (selectRandom [0, 4, 8])], "rhs_vdv_mflora_rifleman", "rhs_Flag_vdv_F"];
private _fCHDKE = [east, [0, 23, 0, (selectRandom [0, 4, 8])], "rhsgref_ins_rifleman", "rhs_Flag_DNR_F"];
private _fTAKI = [east, [0, 31, 0, (selectRandom [0, 4, 8])], "O_Taki_soldier_G_AKM_F", "rhs_Flag_DNR_F"];

private _fCDF = 	[west, [1, 24, 1, (selectRandom [1, 5, 9])], "rhsgref_cdf_b_reg_rifleman", "rhs_Flag_Che_F"];
private _fUSDES = 	[west, [1, 25, 1, (selectRandom [1, 5, 9])], "rhsusf_army_ocp_rifleman", "Flag_US_F"];
private _fUS = 	[west, [1, 26, 1, (selectRandom [1, 5, 9])], "rhsusf_army_ucp_rifleman", "Flag_US_F"];
private _fUSMCDES = [west, [1, 27, 1, (selectRandom [1, 5, 9])], "rhsusf_usmc_marpat_d_rifleman", "Flag_US_F"];
private _fUSMC = [west, [1, 28, 1, (selectRandom [1, 5, 9])], "rhsusf_usmc_marpat_wd_rifleman", "Flag_US_F"];

private _fNATI = 	[independent, [2, 29, 2, (selectRandom [2, 6, 10])], "rhsgref_nat_rifleman", "rhs_Flag_DNR_F"];
private _fCHDKG = 	[independent, [2, 30, 2, (selectRandom [2, 6, 10])], "rhsgref_ins_g_rifleman", "rhs_Flag_DNR_F"];

tg_sideWest = [_fCDF, _fUS, _fUSMC];
tg_sideEast = [_fMSV_EMR, _fVDV_FLORA, _fCHDKE];
tg_sideGuer = [_fNATI, _fCHDKG];

tg_vehicles_air_civ = ["RHS_Mi8amt_civilian"];
tg_vehicles_air_west = ["RHS_UH60M","RHS_CH_47F"];
tg_vehicles_air_east = ["RHS_Mi8mt_vv"];
tg_vehicles_air_guer = ["rhsgref_ins_g_Mi8amt"];
tg_vehicles_land_civ_lrg = ["RHS_Ural_Civ_02", "RHS_Ural_Open_Civ_02", "RHS_Ural_Civ_03", "RHS_Ural_Open_Civ_03", "C_Truck_02_transport_F", "C_Truck_02_covered_F", "C_Van_01_transport_F"];
tg_vehicles_land_civ_sml = ["C_Offroad_01_F", "rhsgref_nat_uaz", "rhsgref_nat_uaz_open", "C_Offroad_02_unarmed_F"];
tg_vehicles_land_west_sml = ["rhsgref_cdf_b_reg_uaz","rhsgref_cdf_b_reg_uaz_open"];
tg_vehicles_land_west_lrg = ["rhsgref_cdf_b_ural","rhsusf_m1025_w","rhsusf_m998_w_2dr_halftop","rhsusf_m998_w_4dr_halftop","rhsusf_M1078A1P2_wd_fmtv_usarmy","rhsusf_M1078A1P2_wd_open_fmtv_usarmy"];
tg_vehicles_land_east_sml = ["rhs_uaz_open_MSV_01","RHS_UAZ_MSV_01"];
tg_vehicles_land_east_lrg = ["rhs_tigr_msv","RHS_Ural_MSV_01","RHS_Ural_Open_MSV_01"];
tg_vehicles_land_guer_sml = ["rhsgref_nat_uaz","rhsgref_nat_uaz_open","rhsgref_ins_g_uaz","rhsgref_ins_g_uaz_open"];
tg_vehicles_land_guer_lrg = ["rhsgref_nat_ural","rhsgref_nat_ural_open","rhsgref_ins_g_ural","rhsgref_ins_g_ural_open"];
tg_vehicles_sea_civ = ["C_Boat_Civil_01_rescue_F", "C_Boat_Transport_02_F", "C_Rubberboat"];
tg_vehicles_sea_west = ["B_Boat_Transport_01_F", "B_Lifeboat"];
tg_vehicles_sea_east = ["O_Boat_Transport_01_F", "O_Lifeboat"];
tg_vehicles_sea_guer = ["I_Boat_Transport_01_F", "I_Lifeboat"];
tg_vehicles_util_civ = ["C_Van_01_fuel_F", "C_Truck_02_fuel_F", "C_Truck_02_box_F", "C_Van_01_box_F"];
tg_vehicles_util_west = ["rhsgref_cdf_b_ural_fuel","rhsusf_M977A4_AMMO_usarmy_wd","rhsusf_M977A4_REPAIR_usarmy_wd","rhsusf_M978A4_usarmy_wd"];
tg_vehicles_util_east = ["RHS_Ural_Fuel_MSV_01"];
tg_vehicles_util_guer = ["rhsgref_cdf_ural_fuel"];
tg_vehicles_ammo = ["Box_Syndicate_Ammo_F", "Box_Syndicate_Wps_F", "Box_Syndicate_WpsLaunch_F"];
tg_vehicles_static = ["rhs_KORD_high_VDV","rhsgref_cdf_b_DSHKM","RHS_M2StaticMG_WD"];

// *** CORE VARIABLES ***
tg_sideMission_end = 0;	// sideMission - Complete game when 'tg_mainMission_cmp' equals 'tg_sideMission_end'
tg_sideMission_dist = 1500; // Used in fn_isNearMission - New Missions will not be within this distance from others.
tg_sideMission_max = 3;	// sideMission - Max no missions to be active at any time

tg_mainMission_end = 10;	// mainMission - Complete game when 'tg_mainMission_cmp' equals 'tg_mainMission_end'
tg_mainMission_dist = 3000; // Used in fn_isNearMission - New Missions will not be within this distance from others.
tg_mainMission_max = 2;	// mainMission - Max no missions to be active at any time

tg_playerMaxMissionDist = 3000; // Minimum distance missions should spawn from players.
tg_playerSide = independent; // The side players are on (used in triggers detection) MUST BE: west/east/resistance
tg_missions_active = []; // Array currently active tasks [uniqueTaskName,taskType]
tg_separateMarkers = FALSE; // Should markers be split by tg_missionTypes? (Allows for specific locations for side and main missions)
tg_triggerRange = 1500; // The default range Mission Triggers set set to activate when players are near.

tg_debug = TRUE; // Debug Mode
tg_taskDelay = 30; // Seconds to wait after completing tasks (60 default).

tg_counter = 1; // ** DONT EDIT ** Internal mission number counter - Unique number for each generated mission
tg_threadActive = false; // ** DONT EDIT ** Internal flag to queue processing of tasks, don't change this.
tg_threadLockedBy = "-"; // ** DONT EDIT ** Internal string for identification.

// ----------- FUNCTIONS START ---------------

// Compile Functions
if (isNil("tg_fnc_ammoDrop")) then {tg_fnc_ammoDrop = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_ammoDrop.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_DACzone_creator")) then {tg_fnc_DACzone_creator = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_DACzone_creator.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_DACzone_spawn")) then {tg_fnc_DACzone_spawn = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_DACzone_spawn.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_balanceUnits")) then {tg_fnc_balanceUnits = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_balanceUnits.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_debugMsg")) then {tg_fnc_debugMsg = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_debugMsg.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_fillGrid")) then {tg_fnc_fillGrid = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_fillGrid.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findEmptyByType")) then {tg_fnc_findEmptyByType = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findEmptyByType.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findObjects")) then {tg_fnc_findObjects = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findObjects.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findRandomEmpty")) then {tg_fnc_findRandomEmpty = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findRandomEmpty.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findRandomMarker")) then {tg_fnc_findRandomMarker = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findRandomMarker.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findSide")) then {tg_fnc_findSide = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findSide.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_findWorldLocation")) then {tg_fnc_findWorldLocation = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_findWorldLocation.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_inSafeZone")) then {tg_fnc_inSafeZone = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_inSafeZone.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_isNearMission")) then {tg_fnc_isNearMission = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_isNearMission.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_isNearPlayer")) then {tg_fnc_isNearPlayer = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_isNearPlayer.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_missionEnd")) then {tg_fnc_missionEnd = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_missionEnd.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_missionSelect")) then {tg_fnc_missionSelect = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_missionSelect.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_nameGenerator")) then {tg_fnc_nameGenerator = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_nameGenerator.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_nearestBuilding")) then {tg_fnc_nearestBuilding = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_nearestBuilding.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_objectSpawner")) then {tg_fnc_objectSpawner = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_objectSpawner.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_safeZone_creator")) then {tg_fnc_safeZone_creator = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_safeZone_creator.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_spawnVehicle")) then {tg_fnc_spawnVehicle = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_spawnVehicle.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_spawnMilitary")) then {tg_fnc_spawnMilitary = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_spawnMilitary.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_stringDifficulty")) then {tg_fnc_stringDifficulty = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_stringDifficulty.sqf", tg_taskFolder]; };
if (isNil("tg_fnc_urbanObjective")) then {tg_fnc_urbanObjective = compileFinal preprocessFileLineNumbers format["%1\fnc\fn_urbanObjective.sqf", tg_taskFolder]; };

// ----------- PREP ---------------
// TODO split markers down to side > type, copy markers to all sides if settings not chosen?
// Color indicates side.
// Text indicates type.

// Markers for any pre-determined locations. stored under 'tg_<Type>_markers'
{
	private _type = _x;
	private _typeArray = [];
	
	{
		// Mission Markers
		if ([toLower _type, toLower _x] call BIS_fnc_inString) then {
		   _typeArray pushBack _x;
		};		
	} forEach allMapMarkers;
	
	missionNamespace setVariable [format["tg_%1_markers", _type], _typeArray];
	if (count _typeArray == 0) then {
		[format["[TG] WARNING: No markers found for '%1'", _type]] call tg_fnc_debugMsg; 
	};
	//[format ["[TG-init] DEBUG: '%1' markers: %2", _type, count _typeArray]] call tg_fnc_debugMsg;
	//[format ["[TG-init] DEBUG: '%1' missions: %2", _type, count (missionNamespace getVariable [format["tg_%1_list",_type],[]])]] call tg_fnc_debugMsg;
} forEach tg_missionTypes;

// Make sure player side settings are correct.
{
	if (side _x != tg_playerSide && side _x in [west, east, independent]) exitWith {
		[format["[TG] WARNING: %1's side does not match tg_playerSide (%2 vs %3)", _x, side _x, tg_playerSide]] call tg_fnc_debugMsg; 
		tg_playerSide = (side _x);
	};
} forEach playableUnits	 + switchableUnits;

// Blacklist for any pre-determined locations used in tg_fnc_findRandomEmpty.
private _blackMkr = [];
private _blackList = [];

{	
	// Safe Zone Blacklist
	if (["safezone", toLower _x] call BIS_fnc_inString) then {
	   _blackMkr pushBack _x;
	};
} forEach allMapMarkers;

missionNamespace setVariable ["tg_blackList_markers",_blackMkr];

[] execVM format["%1\setWorldLocations.sqf", tg_taskFolder];

// Only start in-game.
sleep 1;

// Wait until DAC has initialised.
waitUntil {sleep 1; DAC_Basic_Value > 0;};

// DAC will error if this parameter is not enabled!
if !(missionNamespace getVariable ["DAC_Direct_Start",false]) then {
	["[TG] DAC_Direct_Start is is FALSE, it must be TRUE"] call bis_fnc_error;
};

// ----------- DEBUG ---------------
if tg_debug then {
	[] spawn {
		while{true} do {
			hintSilent parseText format["[TG]<br/>Active Missions: %1<br/>Main: %2/%3 Side: %4/%5<br/>
				<br/>Lock: %6 (%7)<br/>Complete: %8<br/>
				<br/>DAC:<br/>Complete: %8<br/>Init_Counter %10 - %9<br/>",
				count tg_missions_active,
				{_x select 0 == tg_missionTypes select 0} count tg_missions_active,
				missionNamespace getVariable [format["tg_%1_max", tg_missionTypes select 0], 0],
				{_x select 0 == tg_missionTypes select 1} count tg_missions_active,
				missionNamespace getVariable [format["tg_%1_max", tg_missionTypes select 1], 0],
				['Free','Active'] select tg_threadActive,
				tg_threadLockedBy,
				missionNamespace getVariable [format["tg_%1_cmp", tg_missionTypes select 0],0],
				DAC_Init_Counter,
				({_x == 0} count DAC_Init_Counter)
			];
			
			
		};
	};
};
//sleep tg_taskDelay;

// ----------- MAIN START ---------------
// Call the mission selection function.
//[] spawn tg_fnc_missionSelect;