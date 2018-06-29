// Start ZMM by running this script from the folder location its saved to:
// [] execVM "scripts\ZMM\zmm_init.sqf";

ZMM_FolderLocation = "scripts\ZMM"; // No '\' at end!
ZMM_DEBUG = TRUE;
f_param_ZMMMode = 1;

// WEST
ZMM_WESTFlag = ["Flag_NATO_F", "\A3\Data_F\Flags\Flag_NATO_CO.paa"];
ZMM_WESTMan = ["B_Soldier_F","B_Soldier_LAT_F","B_Soldier_GL_F","B_Soldier_AR_F"];
ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSentry"];
ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam"];
ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad"];
ZMM_WESTVeh_Truck = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Motorized" >> "BUS_MotInf_Reinforce"];
ZMM_WESTVeh_Util = ["B_Truck_01_ammo_F","B_Truck_01_fuel_F","B_Truck_01_Repair_F"];
ZMM_WESTVeh_Light = ["B_MRAP_01_gmg_F","B_MRAP_01_hmg_F","B_LSV_01_armed_F"];
ZMM_WESTVeh_Medium = ["B_APC_Wheeled_01_cannon_F","B_APC_Tracked_01_rcws_F"];
ZMM_WESTVeh_Heavy = ["B_APC_Tracked_01_AA_F","B_MBT_01_TUSK_F"];
ZMM_WESTVeh_Air = ["B_Heli_Transport_01_F","B_Heli_Light_01_F","B_Heli_Transport_03_F"];
ZMM_WESTVeh_CAS = ["B_Heli_Light_01_dynamicLoadout_F","B_Heli_Attack_01_dynamicLoadout_F","B_Plane_CAS_01_dynamicLoadout_F","B_Plane_Fighter_01_F"];
// EAST - TANOA
ZMM_EASTFlag = ["Flag_CSAT_F", "\A3\Data_F\Flags\Flag_CSAT_CO.paa"];
ZMM_EASTMan = ["O_T_Soldier_F","O_T_Soldier_LAT_F","O_T_Soldier_GL_F","O_T_Soldier_AR_F"];
ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSentry"];
ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam"];
ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSquad"];
ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Motorized_MTP" >> "O_T_MotInf_Reinforcements"];
ZMM_EASTVeh_Util = ["O_T_Truck_02_Ammo_F","O_T_Truck_02_fuel_F","O_T_Truck_02_box_F"];
ZMM_EASTVeh_Light = ["O_T_MRAP_02_hmg_ghex_F","O_T_LSV_02_armed_F"];
ZMM_EASTVeh_Medium = ["O_T_APC_Tracked_02_cannon_ghex_F","O_T_APC_Wheeled_02_rcws_ghex_F"];
ZMM_EASTVeh_Heavy = ["O_T_APC_Tracked_02_AA_ghex_F","O_T_MBT_02_cannon_ghex_F"];
ZMM_EASTVeh_Air = ["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F"];
ZMM_EASTVeh_CAS = ["O_T_VTOL_02_infantry_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F","O_Heli_Attack_02_dynamicLoadout_F","O_Plane_CAS_02_dynamicLoadout_F"];
// EAST
ZMM_EASTFlag = ["Flag_CSAT_F", "\A3\Data_F\Flags\Flag_CSAT_CO.paa"];
ZMM_EASTMan = ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_GL_F","O_Soldier_AR_F"];
ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry"];
ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam"];
ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"];
ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized" >> "OIA_MotInf_Reinforce"];
ZMM_EASTVeh_Util = ["O_Truck_02_Ammo_F","O_Truck_02_fuel_F","O_Truck_02_box_F"];
ZMM_EASTVeh_Light = ["O_MRAP_02_hmg_F","O_LSV_02_armed_F"];
ZMM_EASTVeh_Medium = ["O_APC_Tracked_02_cannon_F","O_APC_Wheeled_02_rcws_F"];
ZMM_EASTVeh_Heavy = ["O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F"];
ZMM_EASTVeh_Air = ["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F"];
ZMM_EASTVeh_CAS = ["O_T_VTOL_02_infantry_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F","O_Heli_Attack_02_dynamicLoadout_F","O_Plane_CAS_02_dynamicLoadout_F"];
// GUER
ZMM_GUERFlag = ["Flag_AAF_F", "\A3\Data_F\Flags\Flag_AAF_CO.paa"];
ZMM_GUERMan = ["I_Soldier_F","I_Soldier_LAT_F","I_Soldier_GL_F","I_Soldier_AR_F"];
ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSentry"];
ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfTeam"];
ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad"];
ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Motorized" >> "HAF_MotInf_Reinforce"];
ZMM_GUERVeh_Util = ["I_Truck_02_ammo_F","I_Truck_02_fuel_F","I_Truck_02_box_F"];
ZMM_GUERVeh_Light = ["I_MRAP_03_hmg_F","I_MRAP_03_gmg_F"];
ZMM_GUERVeh_Medium = ["I_APC_Wheeled_03_cannon_F","I_APC_tracked_03_cannon_F"];
ZMM_GUERVeh_Heavy = ["I_MBT_03_cannon_F"];
ZMM_GUERVeh_Air = ["I_Heli_light_03_unarmed_F","I_Heli_Transport_02_F"];
ZMM_GUERVeh_CAS = ["I_Heli_light_03_dynamicLoadout_F","I_Plane_Fighter_03_dynamicLoadout_F","I_Plane_Fighter_04_F"];

if (isNil "ZZM_CTIMode") then {
	ZZM_CTIMode = !((missionNamespace getVariable ["f_param_ZMMMode",0]) isEqualTo 0);
};

if (hasInterface && !ZZM_CTIMode) then {
	_nul = [] execVM format["%1\zmm_brief.sqf", ZMM_FolderLocation];
};

if isServer then {
	EAST setFriend [RESISTANCE, 0];
	RESISTANCE setFriend [EAST, 0];
	WEST setFriend [RESISTANCE, 0];
	RESISTANCE setFriend [WEST, 0];
	
	if (isNil "ZMM_playerSide") then { missionNamespace setVariable ["ZMM_playerSide", side ((playableUnits + switchableUnits) select 0), TRUE]; };
	ZMM_enemySides = [ WEST, EAST, INDEPENDENT ] - [ ZMM_playerSide ];
	
	if (isNil("zmm_fnc_nameGen")) then {zmm_fnc_nameGen = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_misc_nameGen.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_logMsg")) then {zmm_fnc_logMsg = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_misc_logMsg.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_spawnUnit")) then {zmm_fnc_spawnUnit = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_ai_spawnUnit.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_areaGarrison")) then {zmm_fnc_areaGarrison = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_area_garrison.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_areaPatrols")) then {zmm_fnc_areaPatrols = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_area_patrols.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_areaQRF")) then {zmm_fnc_areaQRF = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_area_qrf.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_aiUPS")) then {zmm_fnc_aiUPS = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_ai_ups.sqf", ZMM_FolderLocation]; };
	
	if (isNil("zmm_fnc_setupZone")) then {zmm_fnc_setupZone = compileFinal preprocessFileLineNumbers format["%1\zmm_setup_zone.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_setupPopulate")) then {zmm_fnc_setupPopulate = compileFinal preprocessFileLineNumbers format["%1\zmm_setup_populate.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_setupTask")) then {zmm_fnc_setupTask = compileFinal preprocessFileLineNumbers format["%1\zmm_setup_task.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_setupWorld")) then {zmm_fnc_setupWorld = compileFinal preprocessFileLineNumbers format["%1\zmm_setup_world.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_setupCustom")) then {zmm_fnc_setupCustom = compileFinal preprocessFileLineNumbers format["%1\zmm_setup_custom.sqf", ZMM_FolderLocation]; };
	
	// Populate Locations
	[] spawn zmm_fnc_setupWorld;
	
	// Waits for publicVariable then creates zone.
	if !ZZM_CTIMode then { [] call zmm_fnc_setupCustom };
};