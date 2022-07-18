// Choose West Faction
switch (missionNamespace getVariable ["f_param_factionWest",-1]) do {
	case 1: {
		// WEST - NATO
		ZMM_WESTFlag = ["Flag_NATO_F", "\A3\Data_F\Flags\Flag_NATO_CO.paa"];
		ZMM_WESTMan = ["B_Soldier_F","B_Soldier_LAT_F","B_Soldier_F","B_Soldier_GL_F","B_Soldier_F","B_Soldier_AR_F","B_Soldier_F","B_soldier_AA_F","B_Soldier_F","B_soldier_LAT2_F"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSentry"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad"];
		ZMM_WESTVeh_Truck = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Motorized" >> "BUS_MotInf_Reinforce"];
		ZMM_WESTVeh_Util = ["B_Truck_01_ammo_F","B_Truck_01_fuel_F","B_Truck_01_Repair_F"];
		ZMM_WESTVeh_Light = ["B_MRAP_01_gmg_F","B_MRAP_01_hmg_F","B_LSV_01_armed_F"];
		ZMM_WESTVeh_Medium = ["B_APC_Wheeled_01_cannon_F","B_APC_Tracked_01_rcws_F"];
		ZMM_WESTVeh_Heavy = ["B_APC_Tracked_01_AA_F","B_MBT_01_TUSK_F"];
		ZMM_WESTVeh_Air = [["B_Heli_Transport_01_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"],"B_Heli_Light_01_F","B_Heli_Transport_03_F"];
		ZMM_WESTVeh_CAS = ["B_Heli_Light_01_dynamicLoadout_F","B_Heli_Attack_01_dynamicLoadout_F","B_Plane_CAS_01_dynamicLoadout_F","B_Plane_Fighter_01_F"];
		ZMM_WESTVeh_CasH = ["B_Heli_Light_01_dynamicLoadout_F","B_Heli_Attack_01_dynamicLoadout_F"];
		ZMM_WESTVeh_CasP = ["B_Plane_CAS_01_dynamicLoadout_F","B_Plane_Fighter_01_F"];
		ZMM_WESTVeh_Convoy = ["B_MRAP_01_hmg_F","B_MRAP_01_F",["B_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Static = ["B_GMG_01_high_F","B_HMG_01_high_F"];
	};
	case 2: {
		// WEST - NATO TANOA
		ZMM_WESTFlag = ["Flag_NATO_F", "\A3\Data_F\Flags\Flag_NATO_CO.paa"];
		ZMM_WESTMan = ["B_T_Soldier_F","B_T_soldier_LAT_F","B_T_Soldier_F","B_T_soldier_AR_F","B_T_Soldier_F","B_T_Soldier_TL_F","B_T_Soldier_F","B_T_Soldier_AA_F","B_T_Soldier_F","B_T_Soldier_LAT2_F"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfSentry"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfTeam"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfSquad"];
		ZMM_WESTVeh_Truck = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Motorized" >> "B_T_MotInf_Reinforcements"];
		ZMM_WESTVeh_Util = ["B_T_Truck_01_medical_F","B_T_Truck_01_fuel_F","B_T_Truck_01_Repair_F","B_T_Truck_01_ammo_F"];
		ZMM_WESTVeh_Light = ["B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F","B_T_LSV_01_AT_F","B_T_LSV_01_armed_F"];
		ZMM_WESTVeh_Medium = [["B_T_AFV_Wheeled_01_up_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"],["B_T_APC_Tracked_01_rcws_F","[_grpVeh,false,['showCamonetHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Heavy = [["B_T_APC_Tracked_01_AA_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_MBT_01_TUSK_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Air = ["B_Heli_Light_01_F",["B_Heli_Transport_01_F","[_grpVeh,['Green',1]] call BIS_fnc_initVehicle;"],"B_Heli_Transport_03_F"];
		ZMM_WESTVeh_CasH = ["B_Heli_Light_01_dynamicLoadout_F","B_Heli_Attack_01_dynamicLoadout_F"];
		ZMM_WESTVeh_CasP = ["B_Plane_CAS_01_dynamicLoadout_F","B_Plane_Fighter_01_F"];
		ZMM_WESTVeh_Convoy = ["B_T_MRAP_01_hmg_F","B_T_MRAP_01_F",["B_T_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Static = ["B_GMG_01_high_F","B_HMG_01_high_F"];
	};	
	case 3: {
		// WEST - NATO WOODLAND
		ZMM_WESTFlag = ["Flag_NATO_F", "\A3\Data_F\Flags\Flag_NATO_CO.paa"];
		ZMM_WESTMan = ["B_W_Soldier_F","B_W_soldier_LAT_F","B_W_Soldier_F","B_W_soldier_AR_F","B_W_Soldier_F","B_W_Soldier_TL_F","B_W_Soldier_F","B_W_Soldier_AA_F","B_W_Soldier_F","B_W_Soldier_LAT2_F"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "BLU_W_F" >> "Infantry" >> "B_W_InfSentry"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "BLU_W_F" >> "Infantry" >> "B_W_InfTeam"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "BLU_W_F" >> "Infantry" >> "B_W_InfSquad"];
		ZMM_WESTVeh_Truck = ["B_T_Truck_01_covered_F"];
		ZMM_WESTVeh_Util = ["B_T_Truck_01_medical_F","B_T_Truck_01_fuel_F","B_T_Truck_01_Repair_F","B_T_Truck_01_ammo_F"];
		ZMM_WESTVeh_Light = ["B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F","B_T_LSV_01_AT_F","B_T_LSV_01_armed_F"];
		ZMM_WESTVeh_Medium = [["B_T_AFV_Wheeled_01_up_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"],["B_T_APC_Tracked_01_rcws_F","[_grpVeh,false,['showCamonetHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Heavy = [["B_T_APC_Tracked_01_AA_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_MBT_01_TUSK_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Air = ["B_Heli_Light_01_F",["B_Heli_Transport_01_F","[_grpVeh,['Green',1]] call BIS_fnc_initVehicle;"],"B_Heli_Transport_03_F"];
		ZMM_WESTVeh_CasH = ["B_Heli_Light_01_dynamicLoadout_F","B_Heli_Attack_01_dynamicLoadout_F"];
		ZMM_WESTVeh_CasP = ["B_Plane_CAS_01_dynamicLoadout_F","B_Plane_Fighter_01_F"];
		ZMM_WESTVeh_Convoy = ["B_T_MRAP_01_hmg_F","B_T_MRAP_01_F",["B_T_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Static = ["B_GMG_01_high_F","B_HMG_01_high_F"];
	};
	case 4: {
		// WEST - GENDARME (VANILLA)
		ZMM_WESTFlag = ["Flag_Gendarmerie_F", "\A3\Data_F_Exp\Flags\flag_GEN_CO.paa"];
		ZMM_WESTMan = ["B_GEN_Soldier_F","B_GEN_Commander_F"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "Gendarmerie" >> "Infantry" >> "GENDARME_Inf_Patrol"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "Gendarmerie" >> "Infantry" >> "GENDARME_Inf_Patrol"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "Gendarmerie" >> "Infantry" >> "GENDARME_Inf_Patrol"];
		ZMM_WESTVeh_Truck = ["B_GEN_Van_02_transport_F"];
		ZMM_WESTVeh_Util = ["B_Truck_01_ammo_F","B_Truck_01_fuel_F","B_Truck_01_Repair_F"];
		ZMM_WESTVeh_Light = [["B_G_Offroad_01_armed_F","[_grpVeh,false,['HideDoor1',0,'HideDoor2',0,'HideDoor3',0,'HideBackpacks',1,'HideBumper1',0,'HideBumper2',1,'HideConstruction',0]] call BIS_fnc_initVehicle;_grpVeh setObjectTextureGlobal [0,'\A3\Soft_F_Exp\Offroad_01\Data\Offroad_01_ext_gen_CO.paa']"]];
		ZMM_WESTVeh_Medium =[["O_MRAP_02_hmg_F","_grpVeh setObjectTextureGlobal [0,'#(rgb,8,8,3)color(0.7,0.8,1,0.03)'];_grpVeh setObjectTextureGlobal [1,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [2,'#(rgb,8,8,3)color(1,1,1,0.01)'];"]];
		ZMM_WESTVeh_Heavy = [["O_T_APC_Wheeled_02_rcws_ghex_F","_grpVeh setObjectTextureGlobal [0,'#(rgb,8,8,3)color(0.7,0.8,1,0.03)'];_grpVeh setObjectTextureGlobal [1,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [2,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [4,'#(rgb,8,8,3)color(0,0,0,1)'];"]];
		ZMM_WESTVeh_Air = [["I_Heli_Transport_02_F","_grpVeh setObjectTextureGlobal [0,'a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_1_ion_co.paa'];_grpVeh setObjectTextureGlobal [1,'a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_2_ion_co.paa'];_grpVeh setObjectTextureGlobal [2,'a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_3_ion_co.paa'];"]];
		ZMM_WESTVeh_CasH = ["B_Heli_Light_01_dynamicLoadout_F","B_Heli_Attack_01_dynamicLoadout_F"];
		ZMM_WESTVeh_CasP = ["B_Plane_CAS_01_dynamicLoadout_F","B_Plane_Fighter_01_F"];
		ZMM_WESTVeh_Convoy = [["B_G_Offroad_01_armed_F","[_grpVeh,false,['HideDoor1',0,'HideDoor2',0,'HideDoor3',0,'HideBackpacks',1,'HideBumper1',0,'HideBumper2',1,'HideConstruction',0]] call BIS_fnc_initVehicle;_grpVeh setObjectTextureGlobal [0,'\A3\Soft_F_Exp\Offroad_01\Data\Offroad_01_ext_gen_CO.paa']"],"B_GEN_Van_02_transport_F",["O_T_APC_Wheeled_02_rcws_ghex_F","_grpVeh setObjectTextureGlobal [0,'#(rgb,8,8,3)color(0.7,0.8,1,0.03)'];_grpVeh setObjectTextureGlobal [1,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [2,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [4,'#(rgb,8,8,3)color(0,0,0,1)'];"]];
		ZMM_WESTVeh_Static = ["B_GMG_01_high_F","B_HMG_01_high_F"];
	};
	default {
		// WEST - FIA
		ZMM_WESTFlag = ["Flag_FIA_F", "\A3\Data_F\Flags\Flag_FIA_CO.paa"];
		ZMM_WESTMan = ["B_G_Soldier_F","B_G_Soldier_LAT_F","B_G_Soldier_F","B_G_Soldier_SL_F","B_G_Soldier_F","B_G_Soldier_AR_F","B_G_Soldier_F","B_G_Soldier_LAT2_F"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "B_G_InfTeam_Light"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "B_G_InfTeam_Light"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "B_G_InfSquad_Assault"];
		ZMM_WESTVeh_Truck = ["B_G_Van_01_transport_F"];
		ZMM_WESTVeh_Util = ["B_G_Offroad_01_repair_F","B_G_Van_01_fuel_F"];
		ZMM_WESTVeh_Light = ["B_G_Offroad_01_AT_F","B_G_Offroad_01_armed_F"];
		ZMM_WESTVeh_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Air = ["B_Heli_Light_01_F"];
		ZMM_WESTVeh_CasH = ["B_Heli_Light_01_dynamicLoadout_F"];
		ZMM_WESTVeh_CasP = [["I_Plane_Fighter_04_F","[_grpVeh,['CamoGrey',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Convoy = ["B_G_Offroad_01_armed_F","B_G_Van_01_transport_F",["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Static = ["B_G_HMG_02_high_F"];
	};
};

// Choose East Faction
switch (missionNamespace getVariable ["f_param_factionEast",-1]) do {
	case 1: {
		// EAST - CSAT (URBAN)
		ZMM_EASTFlag = ["Flag_CSAT_F", "\A3\Data_F\Flags\Flag_CSAT_CO.paa"];
		ZMM_EASTMan = ["O_soldierU_F","O_soldierU_M_F","O_soldierU_F","O_Urban_HeavyGunner_F","O_soldierU_F","O_SoldierU_SL_F","O_soldierU_F","O_soldierU_LAT_F","O_soldierU_F","O_soldierU_AA_F","O_soldierU_F","O_soldierU_AT_F","O_soldierU_F","O_soldierU_AR_F"]; // Urban
		ZMM_EASTGrp_Sentry = [[["O_SoldierU_SL_F","O_soldierU_F","O_soldierU_F"]]];
		ZMM_EASTGrp_Team = [[["O_SoldierU_SL_F","O_soldierU_F","O_soldierU_LAT_F","O_soldierU_AR_F"]]];
		ZMM_EASTGrp_Squad = [[["O_SoldierU_SL_F","O_soldierU_F","O_Urban_HeavyGunner_F","O_soldierU_F","O_soldierU_LAT_F","O_soldierU_F","O_soldierU_LAT_F","O_soldierU_F"]]];
		ZMM_EASTVeh_Truck = ["O_Truck_02_transport_F"];
		ZMM_EASTVeh_Util = ["O_Truck_02_Ammo_F","O_Truck_02_fuel_F","O_Truck_02_box_F"];
		ZMM_EASTVeh_Light = ["O_MRAP_02_hmg_F","O_LSV_02_armed_F"];
		ZMM_EASTVeh_Medium = [["O_APC_Wheeled_02_rcws_v2_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_APC_Tracked_02_cannon_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["O_APC_Tracked_02_AA_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_02_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_04_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = ["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F"];
		ZMM_EASTVeh_CasH = ["O_Heli_Light_02_dynamicLoadout_F","O_Heli_Attack_02_dynamicLoadout_F"];
		ZMM_EASTVeh_CasP = [["O_T_VTOL_02_infantry_dynamicLoadout_F","[_grpVeh,['CamoGreyHex',1]] call BIS_fnc_initVehicle;"],"O_Plane_CAS_02_dynamicLoadout_F"];
		ZMM_EASTVeh_Convoy = ["O_MRAP_02_hmg_F","O_MRAP_02_F","O_APC_Wheeled_02_rcws_v2_F"];
		ZMM_EASTVeh_Static = ["O_GMG_01_high_F","O_HMG_01_high_F"];
	};
	case 2: {
		// EAST - CSAT TANOA
		ZMM_EASTFlag = ["Flag_CSAT_F", "\A3\Data_F\Flags\Flag_CSAT_CO.paa"];
		ZMM_EASTMan = ["O_T_Soldier_F","O_T_Soldier_AR_F","O_T_Soldier_F","O_T_Soldier_M_F","O_T_Soldier_F","O_T_Soldier_AA_F","O_T_Soldier_F","O_T_Soldier_AT_F","O_T_Soldier_F","O_T_Soldier_LAT_F","O_T_Soldier_F","O_T_Soldier_SL_F","O_T_Soldier_F","O_T_Soldier_GL_F"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSentry"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSquad"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Motorized_MTP" >> "O_T_MotInf_Reinforcements"];
		ZMM_EASTVeh_Util = ["O_T_Truck_02_Ammo_F","O_T_Truck_02_fuel_F","O_T_Truck_02_box_F"];
		ZMM_EASTVeh_Light = ["O_T_MRAP_02_hmg_ghex_F","O_T_LSV_02_armed_F"];
		ZMM_EASTVeh_Medium = [["O_T_APC_Wheeled_02_rcws_v2_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_T_APC_Tracked_02_cannon_ghex_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["O_T_APC_Tracked_02_AA_ghex_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_02_cannon_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_04_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = [["O_Heli_Light_02_unarmed_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"],["O_Heli_Transport_04_bench_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_CasH = [["O_Heli_Light_02_dynamicLoadout_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;_grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"],"O_Heli_Attack_02_dynamicLoadout_F"];
		ZMM_EASTVeh_CasP = [["O_Plane_Fighter_02_F","[_grpVeh,['CamoGreyHex',1]] call BIS_fnc_initVehicle;"],"O_T_VTOL_02_infantry_dynamicLoadout_F"];
		ZMM_EASTVeh_Convoy = ["O_T_MRAP_02_hmg_ghex_F","O_T_MRAP_02_ghex_F","O_T_APC_Wheeled_02_rcws_v2_ghex_F"];
		ZMM_EASTVeh_Static = ["O_GMG_01_high_F","O_HMG_01_high_F"];
	};
	case 3: {
		// EAST - SPETSNAZ VANILLA
		ZMM_EASTFlag = ["Flag_CSAT_F", "\A3\Data_F\Flags\Flag_CSAT_CO.paa"];
		ZMM_EASTMan = ["O_R_Soldier_TL_F","O_R_Soldier_AR_F","O_R_Soldier_LAT_F","O_R_Soldier_GL_F"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_R_F" >> "SpecOps" >> "O_R_InfSentry"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_R_F" >> "SpecOps" >> "O_R_InfTeam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_R_F" >> "SpecOps" >> "O_R_InfSquad"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_R_F" >> "SpecOps" >> "O_T_MotInf_Reinforcements"];
		ZMM_EASTVeh_Util = ["O_T_Truck_02_Ammo_F","O_T_Truck_02_fuel_F","O_T_Truck_02_box_F"];
		ZMM_EASTVeh_Light = ["O_T_MRAP_02_hmg_ghex_F","O_T_LSV_02_armed_F"];
		ZMM_EASTVeh_Medium = [["O_T_APC_Wheeled_02_rcws_v2_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_T_APC_Tracked_02_cannon_ghex_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["O_T_APC_Tracked_02_AA_ghex_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_02_cannon_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_04_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = [["O_Heli_Light_02_unarmed_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"],["O_Heli_Transport_04_bench_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_CasH = [["O_Heli_Light_02_dynamicLoadout_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;_grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"],"O_Heli_Attack_02_dynamicLoadout_F"];
		ZMM_EASTVeh_CasP = [["O_Plane_Fighter_02_F","[_grpVeh,['CamoGreyHex',1]] call BIS_fnc_initVehicle;"],"O_T_VTOL_02_infantry_dynamicLoadout_F"];
		ZMM_EASTVeh_Convoy = ["O_T_MRAP_02_hmg_ghex_F","O_T_MRAP_02_ghex_F","O_T_APC_Wheeled_02_rcws_v2_ghex_F"];
		ZMM_EASTVeh_Static = ["O_GMG_01_high_F","O_HMG_01_high_F"];
	};	
	case 4: {
		// EAST - FIA (VANILLA)
		ZMM_EASTFlag = ["Flag_FIA_F", "\A3\Data_F\Flags\Flag_FIA_CO.paa"];
		ZMM_EASTMan = ["O_G_Soldier_SL_F","O_G_Soldier_AR_F","O_G_Soldier_LAT_F","O_G_Soldier_F"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfTeam_Light"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfTeam_Light"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfSquad_Assault"];
		ZMM_EASTVeh_Truck = ["O_G_Van_01_transport_F"];
		ZMM_EASTVeh_Util = ["O_Truck_02_Ammo_F","O_Truck_02_fuel_F","O_Truck_02_box_F"];
		ZMM_EASTVeh_Light = ["O_G_Offroad_01_armed_F","O_G_Offroad_01_AT_F"];
		ZMM_EASTVeh_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = [["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
		ZMM_EASTVeh_CasH = [["B_Heli_Light_01_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
		ZMM_EASTVeh_CasP = [["I_Plane_Fighter_04_F","[_grpVeh,['CamoGrey',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Convoy = ["O_MRAP_02_hmg_F","O_MRAP_02_F","O_APC_Wheeled_02_rcws_v2_F"];
		ZMM_EASTVeh_Convoy = [["O_G_Offroad_01_armed_F",""],["O_G_Van_01_transport_F",""],["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_01',1,'Guerilla_03',0.5],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Static = ["O_HMG_01_high_F"];
	};
	default {
		// EAST - CSAT
		ZMM_EASTFlag = ["Flag_CSAT_F", "\A3\Data_F\Flags\Flag_CSAT_CO.paa"];
		ZMM_EASTMan = ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_F","O_Soldier_AT_F","O_Soldier_F","O_Soldier_AA_F","O_Soldier_F","O_Soldier_SL_F","O_Soldier_F","O_HeavyGunner_F","O_Soldier_F","O_Soldier_AR_F","O_Soldier_F","O_soldier_M_F","O_Soldier_F","O_Soldier_F"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInf_Reinforce"];
		ZMM_EASTVeh_Util = ["O_Truck_02_Ammo_F","O_Truck_02_fuel_F","O_Truck_02_box_F"];
		ZMM_EASTVeh_Light = ["O_MRAP_02_hmg_F","O_LSV_02_armed_F"];
		ZMM_EASTVeh_Medium = [["O_APC_Wheeled_02_rcws_v2_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_APC_Tracked_02_cannon_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["O_APC_Tracked_02_AA_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_02_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_04_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = ["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F"];
		ZMM_EASTVeh_CasH = ["O_Heli_Light_02_dynamicLoadout_F","O_Heli_Attack_02_dynamicLoadout_F"];
		ZMM_EASTVeh_CasP = [["O_T_VTOL_02_infantry_dynamicLoadout_F","[_grpVeh,['CamoGreyHex',1]] call BIS_fnc_initVehicle;"],"O_Plane_CAS_02_dynamicLoadout_F"];
		ZMM_EASTVeh_Convoy = ["O_MRAP_02_hmg_F","O_MRAP_02_F","O_APC_Wheeled_02_rcws_v2_F"];
		ZMM_EASTVeh_Static = ["O_GMG_01_high_F","O_HMG_01_high_F"];
	};
};

// Choose Guer Faction
switch (missionNamespace getVariable ["f_param_factionGuer",-1]) do {
	case 1: {
		// GUER - AAF
		ZMM_GUERFlag = ["Flag_AAF_F", "\A3\Data_F_Exp\Flags\Flag_AAF_CO.paa"];
		ZMM_GUERMan = ["I_Soldier_F","I_Soldier_LAT_F","I_Soldier_GL_F","I_Soldier_AR_F"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSentry"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfTeam"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Motorized" >> "HAF_MotInf_Reinforce"];
		ZMM_GUERVeh_Util = ["I_Truck_02_fuel_F","I_Truck_02_ammo_F","I_Truck_02_medical_F","I_Truck_02_box_F","I_Truck_02_MRL_F"];
		ZMM_GUERVeh_Light = ["I_MRAP_03_hmg_F","I_MRAP_03_gmg_F","I_LT_01_cannon_F"];
		ZMM_GUERVeh_Medium = ["I_APC_Wheeled_03_cannon_F","I_APC_tracked_03_cannon_F"];
		ZMM_GUERVeh_Heavy = ["I_MBT_03_cannon_F"];
		ZMM_GUERVeh_Air = ["I_Heli_light_03_unarmed_F","I_Heli_Transport_02_F"];
		ZMM_GUERVeh_CasH = ["I_Heli_light_03_dynamicLoadout_F"];
		ZMM_GUERVeh_CasP = ["I_Plane_Fighter_03_dynamicLoadout_F"];
		ZMM_GUERVeh_Convoy = ["I_MRAP_03_hmg_F","I_MRAP_03_F","I_APC_Wheeled_03_cannon_F"];
		ZMM_GUERVeh_Static = ["I_HMG_01_high_F","I_GMG_01_high_F"];
	};	
	case 2: {
		// GUER - SYNDIKAT
		ZMM_GUERFlag = ["Flag_Syndikat_F", "\A3\Data_F_Exp\Flags\flag_SYND_CO.paa"];
		ZMM_GUERMan = ["I_C_Soldier_Para_7_F","I_C_Soldier_Para_5_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_2_F","I_C_Soldier_Para_6_F","I_C_Soldier_Para_1_F"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaFireTeam"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaFireTeam"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaCombatGroup"];
		ZMM_GUERVeh_Truck = ["I_C_Van_01_transport_F"];
		ZMM_GUERVeh_Util = ["I_G_Offroad_01_repair_F","I_G_Van_01_fuel_F"];
		ZMM_GUERVeh_Light = ["I_C_Offroad_02_LMG_F","I_C_Offroad_02_AT_F"];
		ZMM_GUERVeh_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_01',1,'Guerilla_03',0.5],['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Air = ["I_Heli_light_03_unarmed_F",["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
		ZMM_GUERVeh_CasH = [["I_Heli_light_03_dynamicLoadout_F","[_grpVeh,['Green',1],true] call BIS_fnc_initVehicle;"],["B_Heli_Light_01_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
		ZMM_GUERVeh_CasP = [["I_Plane_Fighter_04_F","[_grpVeh,['CamoGrey',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Convoy = ["I_C_Offroad_02_LMG_F","I_C_Van_01_transport_F",["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_01',1,'Guerilla_03',0.5],['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Static = ["I_G_HMG_02_high_F"];
	};
	case 3: {
		// GUER - LDF
		ZMM_GUERFlag = ["Flag_EAF_F", "\a3\Data_F_Enoch\Flags\flag_EAF_CO.paa"];
		ZMM_GUERMan = ["I_E_Soldier_F","I_E_Soldier_AR_F","I_E_Soldier_F","I_E_Soldier_GL_F","I_E_Soldier_F","I_E_soldier_M_F","I_E_Soldier_F","I_E_Soldier_AA_F","I_E_Soldier_F","I_E_Soldier_LAT2_F","I_E_Soldier_F","I_E_Soldier_LAT_F","I_E_Soldier_F","I_E_Soldier_SL_F"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "IND_E_F" >> "Infantry" >> "I_E_InfSentry"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "Indep" >> "IND_E_F" >> "Infantry" >> "I_E_InfTeam"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "Indep" >> "IND_E_F" >> "Infantry" >> "I_E_InfSquad"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "Indep" >> "IND_E_F" >> "Motorized" >> "I_E_MotInf_Reinforcements"];
		ZMM_GUERVeh_Util = ["I_E_Truck_02_Box_F","I_E_Truck_02_fuel_F","I_E_Truck_02_Ammo_F"];
		ZMM_GUERVeh_Light = ["B_T_MRAP_01_hmg_F","B_T_MRAP_01_gmg_F"];
		ZMM_GUERVeh_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.6,'showSLATHull',0.2]] call BIS_fnc_initVehicle;"],["I_E_APC_tracked_03_cannon_F","[_grpVeh,['EAF_01',1],['showCamonetHull',0.6,'showCamonetTurret',0.4]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Heavy = [["O_MBT_04_cannon_F","[_grpVeh,['Jungle',1],['showCamonetHull',0.6,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["I_E_APC_tracked_03_cannon_F","[_grpVeh,['EAF_01',1],['showCamonetHull',0.5,'showSLATHull',0.7,'showSLATTurret',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Air = ["I_Heli_light_03_unarmed_F", ["B_Heli_Light_01_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
		ZMM_GUERVeh_CasH = [["I_Heli_light_03_dynamicLoadout_F","[_grpVeh,['Green',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_CasP = [["I_Plane_Fighter_04_F","[_grpVeh,['CamoGrey',1]] call BIS_fnc_initVehicle; { _grpVeh setPylonLoadout [_forEachIndex + 1, _x] } forEach ['','','','','PylonMissile_Bomb_GBU12_x1','PylonMissile_Bomb_GBU12_x1'];"]];
		ZMM_GUERVeh_Convoy = [["B_T_MRAP_01_hmg_F",""],["I_E_Van_02_transport_F",""],["I_E_APC_tracked_03_cannon_F","[_grpVeh,['EAF_01',1],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Static = ["I_HMG_01_high_F","I_GMG_01_high_F"];
	};
	case 4: {
		// GUER - LOOTERS
		ZMM_GUERFlag = ["Flag_FIA_F", "\A3\Data_F\Flags\Flag_FIA_CO.paa"];
		ZMM_GUERMan = ["I_L_Hunter_F","I_L_Looter_Rifle_F","I_L_Looter_SG_F","I_L_Looter_SMG_F"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "IND_L_F" >> "Infantry" >> "I_L_LooterGang"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "Indep" >> "IND_L_F" >> "Infantry" >> "I_L_LooterGang"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "Indep" >> "IND_L_F" >> "Infantry" >> "I_L_CriminalGang"];
		ZMM_GUERVeh_Truck = ["I_G_Van_01_transport_F"];
		ZMM_GUERVeh_Util = ["I_G_Offroad_01_repair_F","I_G_Van_01_fuel_F"];
		ZMM_GUERVeh_Light = ["I_G_Offroad_01_armed_F","I_G_Offroad_01_AT_F"];
		ZMM_GUERVeh_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Air = [["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
		ZMM_GUERVeh_CasH = [["B_Heli_Light_01_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
		ZMM_GUERVeh_CasP = [["I_Plane_Fighter_04_F","[_grpVeh,['CamoGrey',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Convoy = [["I_G_Offroad_01_armed_F",""],["I_G_Van_01_transport_F",""],["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_01',1,'Guerilla_03',0.5],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Static = ["I_G_HMG_02_high_F"];
	};
	default {
		// GUER - FIA
		ZMM_GUERFlag = ["Flag_FIA_F", "\A3\Data_F\Flags\Flag_FIA_CO.paa"];
		ZMM_GUERMan = ["I_G_Soldier_F","I_G_Soldier_LAT_F","I_G_Soldier_F","I_G_Soldier_SL_F","I_G_Soldier_F","I_G_Soldier_AR_F","I_G_Soldier_F","I_G_Soldier_LAT2_F"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "IND_G_F" >> "Infantry" >> "I_G_InfTeam_Light"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "Indep" >> "IND_G_F" >> "Infantry" >> "I_G_InfTeam_Light"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "Indep" >> "IND_G_F" >> "Infantry" >> "I_G_InfSquad_Assault"];
		ZMM_GUERVeh_Truck = ["I_G_Van_01_transport_F"];
		ZMM_GUERVeh_Util = ["I_G_Offroad_01_repair_F","I_G_Van_01_fuel_F"];
		ZMM_GUERVeh_Light = ["I_G_Offroad_01_armed_F","I_G_Offroad_01_AT_F"];
		ZMM_GUERVeh_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Air = [["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
		ZMM_GUERVeh_CasH = [["B_Heli_Light_01_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
		ZMM_GUERVeh_CasP = [["I_Plane_Fighter_04_F","[_grpVeh,['CamoGrey',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Convoy = [["I_G_Offroad_01_armed_F",""],["I_G_Van_01_transport_F",""],["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_01',1,'Guerilla_03',0.5],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Static = ["I_G_HMG_02_high_F"];
	};
};