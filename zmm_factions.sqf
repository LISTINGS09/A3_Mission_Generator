// Choose West Faction
switch (missionNamespace getVariable ["f_param_factionWest",-1]) do {
	/*
	case 0: {
		// WEST - US ARMY D
		ZMM_WESTFlag = ["FlagCarrierUSA", "\ca\data\flag_usa_co.paa"];
		ZMM_WESTMan = ["rhsusf_army_ocp_rifleman","rhsusf_army_ocp_machinegunner","rhsusf_army_ocp_grenadier","rhsusf_army_ocp_riflemanat","rhsusf_army_ocp_squadleader"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_infantry" >> "rhs_group_nato_usarmy_d_infantry_team"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_infantry" >> "rhs_group_nato_usarmy_d_infantry_team"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_infantry" >> "rhs_group_nato_usarmy_d_infantry_squad"];
		ZMM_WESTVeh_Truck = [configFile >> "CfgGroups" >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_RG33" >> "rhs_group_nato_usarmy_d_RG33_m2_squad", configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_RG33" >> "rhs_group_nato_usarmy_d_RG33_squad"];
		ZMM_WESTVeh_Util = ["rhsusf_M978A4_usarmy_d","rhsusf_M977A4_AMMO_usarmy_d","rhsusf_M977A4_REPAIR_usarmy_d"];
		ZMM_WESTVeh_Light = ["rhsusf_m1025_d_m2","rhsusf_m1025_d_Mk19"];
		ZMM_WESTVeh_Medium = ["rhsusf_m113d_usarmy","rhsusf_m113d_usarmy_MK19"];
		ZMM_WESTVeh_Heavy = ["RHS_M2A3","RHS_M6","rhsusf_m1a1aimd_usarmy"];
		ZMM_WESTVeh_Air = ["RHS_UH60M2_d","RHS_UH60M_d","RHS_MELB_MH6M"];
		ZMM_WESTVeh_CAS = ["RHS_MELB_AH6M","RHS_AH64DGrey","RHS_AH1Z"];
		//ZMM_WESTVeh_CasH = [];
		//ZMM_WESTVeh_CasP = [];
		//ZMM_WESTVeh_Convoy = [];
	};
	case 1: {
		// WEST - US ARMY W
		ZMM_WESTFlag = ["FlagCarrierUSA", "\ca\data\flag_usa_co.paa"];
		ZMM_WESTMan = ["rhsusf_army_ucp_rifleman","rhsusf_army_ucp_machinegunner","rhsusf_army_ucp_grenadier","rhsusf_army_ucp_riflemanat","rhsusf_army_ucp_squadleader"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_infantry" >> "rhs_group_nato_usarmy_wd_infantry_team"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_infantry" >> "rhs_group_nato_usarmy_wd_infantry_team"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_infantry" >> "rhs_group_nato_usarmy_wd_infantry_squad"];
		ZMM_WESTVeh_Truck = [configFile >> "CfgGroups" >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_RG33" >> "rhs_group_nato_usarmy_wd_RG33_m2_squad", configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_RG33" >> "rhs_group_nato_usarmy_wd_RG33_squad"];
		ZMM_WESTVeh_Util = ["rhsusf_M977A4_AMMO_usarmy_wd","rhsusf_M977A4_REPAIR_usarmy_wd","rhsusf_M978A4_usarmy_wd"];
		ZMM_WESTVeh_Light = ["rhsusf_m1025_w_m2","rhsusf_m1025_w_Mk19"];
		ZMM_WESTVeh_Medium = ["rhsusf_m113_usarmy","rhsusf_m113_usarmy_MK19"];
		ZMM_WESTVeh_Heavy = ["RHS_M2A3_wd","RHS_M6_wd","rhsusf_m1a1aimwd_usarmy"];
		ZMM_WESTVeh_Air = ["RHS_UH60M2","RHS_UH60M","RHS_MELB_MH6M"];
		ZMM_WESTVeh_CAS = ["RHS_MELB_AH6M","RHS_AH64D_wd"];
		//ZMM_WESTVeh_CasH = [];
		//ZMM_WESTVeh_CasP = [];
		//ZMM_WESTVeh_Convoy = [];
	};
	case 2: {
		// WEST - CDF
		ZMM_WESTFlag = ["FlagCarrierCDF_EP1", "\ca\data\flag_Chernarus_co.paa"];
		ZMM_WESTMan = ["rhsgref_cdf_b_reg_machinegunner","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier","rhsgref_cdf_b_reg_grenadier_rpg"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhsgref_group_cdf_b_reg_infantry" >> "rhsgref_group_cdf_b_reg_infantry_squad"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhsgref_group_cdf_b_reg_infantry" >> "rhsgref_group_cdf_b_reg_infantry_squad"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhsgref_group_cdf_b_reg_infantry" >> "rhsgref_group_cdf_b_reg_infantry_squad"];
		ZMM_WESTVeh_Truck = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_gaz66" >> "rhs_group_cdf_b_gaz66_squad", configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_ural" >> "rhs_group_cdf_b_ural_squad"];
		ZMM_WESTVeh_Util = ["rhsgref_cdf_b_ural_fuel","rhsgref_cdf_b_ural_repair","rhsgref_cdf_b_gaz66_ammo"];
		ZMM_WESTVeh_Light = ["rhsgref_cdf_b_reg_uaz_ags","rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz_spg9"];
		ZMM_WESTVeh_Medium = ["rhsgref_cdf_b_btr70","rhsgref_cdf_b_bmp2k","rhsgref_cdf_b_bmd1k","rhsgref_cdf_b_bmd2k"];
		ZMM_WESTVeh_Heavy = ["rhsgref_cdf_b_zsu234","rhsgref_cdf_b_t72bb_tv"];
		ZMM_WESTVeh_Air = ["rhsgref_cdf_b_reg_Mi8amt","rhsgref_cdf_b_reg_Mi17Sh"];
		ZMM_WESTVeh_CAS = ["rhsgref_cdf_b_Mi35","rhsgref_cdf_b_su25"];
		//ZMM_WESTVeh_CasH = [];
		//ZMM_WESTVeh_CasP = [];
		//ZMM_WESTVeh_Convoy = [];
	};
	case 3: {
		// WEST - HORIZON
		ZMM_WESTFlag = ["FlagCarrierUSA", "\ca\data\flag_usa_co.paa"];
		ZMM_WESTMan = ["rhsgref_hidf_grenadier","rhsgref_hidf_squadleader","rhsgref_hidf_autorifleman"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_hidf" >> "rhsgref_group_hidf_infantry" >> "rhs_group_hidf_infantry_team"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_hidf" >> "rhsgref_group_hidf_infantry" >> "rhs_group_hidf_infantry_team"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_hidf" >> "rhsgref_group_hidf_infantry" >> "rhsgref_group_hidf_infantry_squad"];
		ZMM_WESTVeh_Truck = ["rhsgref_hidf_m998_4dr"];
		ZMM_WESTVeh_Util = ["rhsusf_M977A4_AMMO_usarmy_wd","rhsusf_M977A4_REPAIR_usarmy_wd","rhsusf_M978A4_usarmy_wd"];
		ZMM_WESTVeh_Light = ["rhsgref_hidf_m1025_m2","rhsgref_hidf_m1025_mk19"];
		ZMM_WESTVeh_Medium = ["rhsgref_hidf_m113a3_m2","rhsgref_hidf_m113a3_mk19"];
		ZMM_WESTVeh_Heavy = ["RHS_M2A3_wd","RHS_M6_wd","rhsusf_m1a1aimwd_usarmy"];
		ZMM_WESTVeh_Air = ["RHS_UH60M2","RHS_UH60M","RHS_MELB_MH6M"];
		ZMM_WESTVeh_CAS = ["RHS_MELB_AH6M","RHS_AH64D_wd"];
		//ZMM_WESTVeh_CasH = [];
		//ZMM_WESTVeh_CasP = [];
		//ZMM_WESTVeh_Convoy = [];
	};
	case 4: {
		// WEST - NATO
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
		//ZMM_WESTVeh_CasH = [];
		//ZMM_WESTVeh_CasP = [];
		//ZMM_WESTVeh_Convoy = [];
	};
	case 5: {
		// WEST - NATO TANOA
		ZMM_WESTFlag = ["Flag_NATO_F", "\A3\Data_F\Flags\Flag_NATO_CO.paa"];
		ZMM_WESTMan = ["B_T_Soldier_F","B_T_soldier_LAT_F","B_T_soldier_AR_F","B_T_Soldier_TL_F"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfSentry"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfTeam"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfSquad"];
		ZMM_WESTVeh_Truck = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Motorized" >> "B_T_MotInf_Reinforcements"];
		ZMM_WESTVeh_Util = ["B_Truck_01_ammo_F","B_Truck_01_fuel_F","B_Truck_01_Repair_F"];
		ZMM_WESTVeh_Light = ["B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F","B_T_LSV_01_AT_F","B_T_LSV_01_armed_F"];
		ZMM_WESTVeh_Medium = ["B_T_APC_Wheeled_01_cannon_F","B_T_APC_Tracked_01_rcws_F"];
		ZMM_WESTVeh_Heavy = ["B_T_APC_Tracked_01_AA_F","B_T_MBT_01_TUSK_F"];
		ZMM_WESTVeh_Air = ["B_Heli_Light_01_F","B_Heli_Transport_01_F","B_Heli_Transport_03_F"];
		ZMM_WESTVeh_CAS = ["B_Heli_Light_01_dynamicLoadout_F","B_Heli_Attack_01_dynamicLoadout_F","B_Plane_CAS_01_dynamicLoadout_F","B_Plane_Fighter_01_F"];
		//ZMM_WESTVeh_CasH = [];
		//ZMM_WESTVeh_CasP = [];
		//ZMM_WESTVeh_Convoy = [];
	};
	*/
	default {
		// WEST - FIA
		ZMM_WESTFlag = ["Flag_FIA_F", "\A3\Data_F\Flags\Flag_FIA_CO.paa"];
		ZMM_WESTMan = ["B_G_Soldier_LAT_F","B_G_Soldier_F","B_G_Soldier_SL_F","B_G_Soldier_AR_F"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "B_G_InfTeam_Light"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "B_G_InfTeam_Light"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "B_G_InfSquad_Assault"];
		ZMM_WESTVeh_Truck = ["B_G_Van_01_transport_F"];
		ZMM_WESTVeh_Util = ["B_G_Offroad_01_repair_F","B_G_Van_01_fuel_F"];
		ZMM_WESTVeh_Light = ["B_G_Offroad_01_AT_F","B_G_Offroad_01_armed_F"];
		ZMM_WESTVeh_Medium = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Air = ["B_Heli_Light_01_F"];
		ZMM_WESTVeh_CasH = ["B_Heli_Light_01_dynamicLoadout_F"];
		ZMM_WESTVeh_CasP = [["I_Plane_Fighter_04_F","[_grpVeh,['CamoGrey',1]] call BIS_fnc_initVehicle;"]];
		//ZMM_WESTVeh_Convoy = [];
	};
};

// Choose East Faction
switch (missionNamespace getVariable ["f_param_factionEast",-1]) do {
	/*
	case 0: {
		// EAST - RU DESERT
		ZMM_EASTFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EASTMan = ["rhs_vdv_mflora_rifleman","rhs_vdv_mflora_at","rhs_vdv_mflora_grenadier","rhs_vdv_mflora_sergeant","rhs_vdv_mflora_machinegunner"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora" >> "rhs_group_rus_vdv_infantry_mflora_MANEUVER"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora" >> "rhs_group_rus_vdv_infantry_mflora_fireteam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora" >> "rhs_group_rus_vdv_infantry_mflora_squad"];
		ZMM_EASTVeh_Truck = [["RHS_Ural_MSV_01","[_grpVeh,['rhs_sand',1],TRUE] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = ["Taki_Ural_Zu23_F","Taki_UAZ_ags30_F","Taki_UAZ_dshkm_F","Taki_UAZ_spg9_F"];
		ZMM_EASTVeh_Medium = ["Taki_bmd1_F","Taki_bmp1_F"];
		ZMM_EASTVeh_Heavy = ["Taki_t72_F", "Taki_zsu_F"];
		ZMM_EASTVeh_Air = ["RHS_Mi8mt_vvsc","RHS_Mi8AMT_vvsc"];
		ZMM_EASTVeh_CAS = ["RHS_Mi24P_vvsc","RHS_Ka52_vvs"];
		//ZMM_EASTVeh_CasH = [];
		//ZMM_EASTVeh_CasP = [];
		//ZMM_EASTVeh_Convoy = [];
	};
	case 1: {
		// EAST - RU MSV
		ZMM_EASTFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EASTMan = ["rhs_msv_rifleman","rhs_msv_grenadier","rhs_msv_rifleman","rhs_msv_LAT","rhs_msv_rifleman","rhs_msv_grenadier_rpg","rhs_msv_rifleman","rhs_msv_machinegunner"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_MANEUVER"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_fireteam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_squad"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_Ural" >> "rhs_group_rus_msv_Ural_squad", configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_gaz66" >> "rhs_group_rus_msv_gaz66_squad"];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = ["rhs_tigr_sts_msv","rhsgref_nat_uaz_dshkm","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9"];
		ZMM_EASTVeh_Medium = ["rhs_btr80a_msv","rhs_btr70_msv","rhs_btr80_msv"];
		ZMM_EASTVeh_Heavy = ["rhs_bmp1_msv","rhs_bmp2e_msv","rhs_bmp3_msv"];
		ZMM_EASTVeh_Air = ["RHS_Mi8mt_vvsc","RHS_Mi8AMT_vvsc"];
		ZMM_EASTVeh_CasH = ["RHS_Mi24P_vvsc","RHS_Ka52_vvsc"];
		ZMM_EASTVeh_CasP = ["RHS_Su25SM_vvsc"];
		ZMM_EASTVeh_Convoy = [["rhs_tigr_sts_msv",""],["rhs_btr70_msv",""],["rhs_btr70_msv",""]];
	};
	case 2: {
		// EAST - TAKI
		ZMM_EASTFlag = ["FlagCarrierTKMilitia_EP1", "ca\Ca_E\data\flag_tkm_co.paa"];
		ZMM_EASTMan = ["O_Taki_soldier_TL_F","O_Taki_soldier_R26_F","O_Taki_soldier_R_AK103_F","O_Taki_soldier_R_AK105_F"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Infantry" >> "Taki_Sentry"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Infantry" >> "Taki_AssaultTeam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Infantry" >> "Taki_RifleSquad"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Motorized" >> "Taki_MountedWarband"];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = ["Taki_Ural_Zu23_F","Taki_UAZ_ags30_F","Taki_UAZ_dshkm_F","Taki_UAZ_spg9_F"];
		ZMM_EASTVeh_Medium = ["Taki_bmd1_F","Taki_bmp1_F"];
		ZMM_EASTVeh_Heavy = ["Taki_t72_F", "Taki_zsu_F"];
		ZMM_EASTVeh_Air = ["Taki_mi8_armed_F"];
		ZMM_EASTVeh_CAS = ["Taki_mi8_armed_F"];
		//ZMM_EASTVeh_CasH = [];
		//ZMM_EASTVeh_CasP = [];
		//ZMM_EASTVeh_Convoy = [];
	};
	case 3: {
		// EAST - CSAT
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
		//ZMM_EASTVeh_CasH = [];
		//ZMM_EASTVeh_CasP = [];
		//ZMM_EASTVeh_Convoy = [];
	};
	case 4: {
		// EAST - CSAT TANOA
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
		//ZMM_EASTVeh_CasH = [];
		//ZMM_EASTVeh_CasP = [];
		//ZMM_EASTVeh_Convoy = [];
	};
	case 5: {
		// EAST - SYNDIKAT
		ZMM_EASTFlag = ["Flag_Syndikat_F", "\A3\Data_F_Exp\Flags\flag_SYND_CO.paa"];
		ZMM_EASTMan = ["I_C_Soldier_Para_7_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_2_F"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaFireTeam"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaFireTeam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaCombatGroup"];
		ZMM_EASTVeh_Truck = ["I_C_Van_01_transport_F"];
		ZMM_EASTVeh_Util = ["I_G_Offroad_01_repair_F","I_G_Van_01_fuel_F"];
		ZMM_EASTVeh_Light = ["I_C_Offroad_02_LMG_F","I_C_Offroad_02_AT_F"];
		ZMM_EASTVeh_Medium = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_01',1],TRUE] call BIS_fnc_initVehicle;"],["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_03',1],TRUE] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["O_MBT_04_cannon_F","[_grpVeh,['Jungle',1],TRUE] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = ["I_Heli_light_03_unarmed_F"];
		ZMM_EASTVeh_CAS = [["I_Heli_light_03_dynamicLoadout_F","[_grpVeh,['Green',1],TRUE] call BIS_fnc_initVehicle;"]];
		//ZMM_EASTVeh_CasH = [];
		//ZMM_EASTVeh_CasP = [];
		//ZMM_EASTVeh_Convoy = [];
	};
	*/
	default {
		// EAST - CSAT
		ZMM_EASTFlag = ["Flag_CSAT_F", "\A3\Data_F\Flags\Flag_CSAT_CO.paa"];
		ZMM_EASTMan = ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_GL_F","O_Soldier_AR_F"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized" >> "OIA_MotInf_Reinforce"];
		ZMM_EASTVeh_Util = ["O_Truck_02_Ammo_F","O_Truck_02_fuel_F","O_Truck_02_box_F"];
		ZMM_EASTVeh_Light = ["O_MRAP_02_hmg_F","O_LSV_02_armed_F"];
		ZMM_EASTVeh_Medium = [["O_APC_Wheeled_02_rcws_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_APC_Tracked_02_cannon_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["O_APC_Tracked_02_AA_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_02_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_04_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = ["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F"];
		ZMM_EASTVeh_CasH = [["O_Heli_Light_02_dynamicLoadout_F","_grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"],["O_Heli_Attack_02_dynamicLoadout_F", "_grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],"O_Plane_CAS_02_dynamicLoadout_F"];
		ZMM_EASTVeh_CasP = ["O_Plane_CAS_02_dynamicLoadout_F","O_Plane_Fighter_02_F"];
		ZMM_EASTVeh_Convoy = [["O_MRAP_02_hmg_F",""],["O_MRAP_02_F",""],["O_APC_Wheeled_02_rcws_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
	};
};

// Choose Guer Faction
switch (missionNamespace getVariable ["f_param_factionGuer",-1]) do {
	/*
	case 0: {
		// EAST - RU DESERT
		ZMM_GUERFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_GUERMan = ["rhs_vdv_mflora_rifleman","rhs_vdv_mflora_at","rhs_vdv_mflora_grenadier","rhs_vdv_mflora_sergeant","rhs_vdv_mflora_machinegunner"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora" >> "rhs_group_rus_vdv_infantry_mflora_MANEUVER"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora" >> "rhs_group_rus_vdv_infantry_mflora_fireteam"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora" >> "rhs_group_rus_vdv_infantry_mflora_squad"];
		ZMM_GUERVeh_Truck = [["RHS_Ural_MSV_01","[_grpVeh,['rhs_sand',1],TRUE] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_GUERVeh_Light = ["Taki_Ural_Zu23_F","Taki_UAZ_ags30_F","Taki_UAZ_dshkm_F","Taki_UAZ_spg9_F"];
		ZMM_GUERVeh_Medium = ["Taki_bmd1_F","Taki_bmp1_F"];
		ZMM_GUERVeh_Heavy = ["Taki_t72_F", "Taki_zsu_F"];
		ZMM_GUERVeh_Air = ["RHS_Mi8mt_vvsc","RHS_Mi8AMT_vvsc"];
		ZMM_GUERVeh_CAS = ["RHS_Mi24P_vvsc","RHS_Ka52_vvs"];
		//ZMM_GUERVeh_CasH = [];
		//ZMM_GUERVeh_CasP = [];
		//ZMM_GUERVeh_Convoy = [];
	};
	case 1: {
		// EAST - RU MSV
		ZMM_GUERFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_GUERMan = ["rhs_msv_rifleman","rhs_msv_grenadier","rhs_msv_rifleman","rhs_msv_LAT","rhs_msv_rifleman","rhs_msv_grenadier_rpg","rhs_msv_rifleman","rhs_msv_machinegunner"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_MANEUVER"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_fireteam"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_squad"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_Ural" >> "rhs_group_rus_msv_Ural_squad", configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_gaz66" >> "rhs_group_rus_msv_gaz66_squad"];
		ZMM_GUERVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_GUERVeh_Light = ["rhs_tigr_sts_msv","rhsgref_nat_uaz_dshkm","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9"];
		ZMM_GUERVeh_Medium = ["rhs_btr80a_msv","rhs_btr70_msv","rhs_btr80_msv"];
		ZMM_GUERVeh_Heavy = ["rhs_bmp1_msv","rhs_bmp2e_msv","rhs_bmp3_msv"];
		ZMM_GUERVeh_Air = ["RHS_Mi8mt_vvsc","RHS_Mi8AMT_vvsc"];
		ZMM_GUERVeh_CAS = ["RHS_Mi24P_vvsc","RHS_Ka52_vvsc"];
		//ZMM_GUERVeh_CasH = [];
		//ZMM_GUERVeh_CasP = [];
		//ZMM_GUERVeh_Convoy = [];
	};
	case 2: {
		// EAST - TAKI
		ZMM_GUERFlag = ["FlagCarrierTKMilitia_EP1", "ca\Ca_E\data\flag_tkm_co.paa"];
		ZMM_GUERMan = ["O_Taki_soldier_TL_F","O_Taki_soldier_R26_F","O_Taki_soldier_R_AK103_F","O_Taki_soldier_R_AK105_F"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Infantry" >> "Taki_Sentry"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Infantry" >> "Taki_AssaultTeam"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Infantry" >> "Taki_RifleSquad"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Motorized" >> "Taki_MountedWarband"];
		ZMM_GUERVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_GUERVeh_Light = ["Taki_Ural_Zu23_F","Taki_UAZ_ags30_F","Taki_UAZ_dshkm_F","Taki_UAZ_spg9_F"];
		ZMM_GUERVeh_Medium = ["Taki_bmd1_F","Taki_bmp1_F"];
		ZMM_GUERVeh_Heavy = ["Taki_t72_F", "Taki_zsu_F"];
		ZMM_GUERVeh_Air = ["Taki_mi8_armed_F"];
		ZMM_GUERVeh_CAS = ["Taki_mi8_armed_F"];
		//ZMM_GUERVeh_CasH = [];
		//ZMM_GUERVeh_CasP = [];
		//ZMM_GUERVeh_Convoy = [];
	};
	case 3: {
		// EAST - CSAT
		ZMM_GUERFlag = ["Flag_CSAT_F", "\A3\Data_F\Flags\Flag_CSAT_CO.paa"];
		ZMM_GUERMan = ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_GL_F","O_Soldier_AR_F"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized" >> "OIA_MotInf_Reinforce"];
		ZMM_GUERVeh_Util = ["O_Truck_02_Ammo_F","O_Truck_02_fuel_F","O_Truck_02_box_F"];
		ZMM_GUERVeh_Light = ["O_MRAP_02_hmg_F","O_LSV_02_armed_F"];
		ZMM_GUERVeh_Medium = ["O_APC_Tracked_02_cannon_F","O_APC_Wheeled_02_rcws_F"];
		ZMM_GUERVeh_Heavy = ["O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F"];
		ZMM_GUERVeh_Air = ["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F"];
		ZMM_GUERVeh_CAS = ["O_T_VTOL_02_infantry_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F","O_Heli_Attack_02_dynamicLoadout_F","O_Plane_CAS_02_dynamicLoadout_F"];
		//ZMM_GUERVeh_CasH = [];
		//ZMM_GUERVeh_CasP = [];
		//ZMM_GUERVeh_Convoy = [];
	};
	case 4: {
		// EAST - CSAT TANOA
		ZMM_GUERFlag = ["Flag_CSAT_F", "\A3\Data_F\Flags\Flag_CSAT_CO.paa"];
		ZMM_GUERMan = ["O_T_Soldier_F","O_T_Soldier_LAT_F","O_T_Soldier_GL_F","O_T_Soldier_AR_F"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSentry"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSquad"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Motorized_MTP" >> "O_T_MotInf_Reinforcements"];
		ZMM_GUERVeh_Util = ["O_T_Truck_02_Ammo_F","O_T_Truck_02_fuel_F","O_T_Truck_02_box_F"];
		ZMM_GUERVeh_Light = ["O_T_MRAP_02_hmg_ghex_F","O_T_LSV_02_armed_F"];
		ZMM_GUERVeh_Medium = ["O_T_APC_Tracked_02_cannon_ghex_F","O_T_APC_Wheeled_02_rcws_ghex_F"];
		ZMM_GUERVeh_Heavy = ["O_T_APC_Tracked_02_AA_ghex_F","O_T_MBT_02_cannon_ghex_F"];
		ZMM_GUERVeh_Air = ["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F"];
		ZMM_GUERVeh_CAS = ["O_T_VTOL_02_infantry_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F","O_Heli_Attack_02_dynamicLoadout_F","O_Plane_CAS_02_dynamicLoadout_F"];
		//ZMM_GUERVeh_CasH = [];
		//ZMM_GUERVeh_CasP = [];
		//ZMM_GUERVeh_Convoy = [];
	};
	case 5: {
		// GUER - NAPA
		ZMM_GUERFlag = ["Flag_Enoch_F", "\a3\Data_F_Enoch\Flags\flag_Enoch_CO.paa"];
		ZMM_GUERMan = ["rhsgref_nat_pmil_machinegunner","rhsgref_nat_pmil_grenadier","rhsgref_nat_pmil_grenadier_rpg","rhsgref_nat_pmil_rifleman_aksu"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_nationalist" >> "rhsgref_group_national_infantry" >> "rhsgref_group_national_infantry_at"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_nationalist" >> "rhsgref_group_national_infantry" >> "rhsgref_group_national_infantry_patrol"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_nationalist" >> "rhsgref_group_national_infantry" >> "rhsgref_group_national_infantry_squad_2"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_nationalist" >> "rhs_group_indp_nat_ural" >> "rhs_group_nat_ural_squad"];
		ZMM_GUERVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_GUERVeh_Light = ["rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9","rhsgref_nat_uaz_dshkm","rhsgref_nat_btr70"];
		ZMM_GUERVeh_Medium = ["rhsgref_ins_g_bmp2k","rhsgref_ins_g_bmp1k"];
		ZMM_GUERVeh_Heavy = ["rhsgref_ins_g_zsu234","rhsgref_ins_g_t72bc"];
		ZMM_GUERVeh_Air = ["rhsgref_cdf_reg_Mi8amt"];
		ZMM_GUERVeh_CAS = ["rhsgref_cdf_reg_Mi17Sh"];
		//ZMM_GUERVeh_CasH = [];
		//ZMM_GUERVeh_CasP = [];
		//ZMM_GUERVeh_Convoy = [];
	};
	case 5: {
		// GUER - SYNDIKAT
		ZMM_GUERFlag = ["Flag_Syndikat_F", "\A3\Data_F_Exp\Flags\flag_SYND_CO.paa"];
		ZMM_GUERMan = ["I_C_Soldier_Para_7_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_2_F"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaFireTeam"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaFireTeam"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaCombatGroup"];
		ZMM_GUERVeh_Truck = ["I_C_Van_01_transport_F"];
		ZMM_GUERVeh_Util = ["I_G_Offroad_01_repair_F","I_G_Van_01_fuel_F"];
		ZMM_GUERVeh_Light = ["I_C_Offroad_02_LMG_F","I_C_Offroad_02_AT_F"];
		ZMM_GUERVeh_Medium = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_03',1],['showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_03',1],['showCamonetHull',0.5,'showSLATHull',1]] call BIS_fnc_initVehicle;"],["O_MBT_04_cannon_F","[_grpVeh,['Jungle',1],TRUE] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Air = [["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
		ZMM_GUERVeh_CasH = [["B_Heli_Light_01_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
		ZMM_GUERVeh_CasP = [["I_Plane_Fighter_04_F","[_grpVeh,['CamoGrey',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Convoy = [["O_G_Offroad_01_armed_F",""],["O_G_Van_01_transport_F",""],["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_01',1,'Guerilla_03',0.5],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
	};
	*/
	default {
		// GUER - FIA
		ZMM_GUERFlag = ["Flag_FIA_F", "\A3\Data_F\Flags\Flag_FIA_CO.paa"];
		ZMM_GUERMan = ["O_G_Soldier_SL_F","O_G_Soldier_AR_F","O_G_Soldier_LAT_F","O_G_Soldier_F"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfTeam_Light"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfTeam_Light"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfSquad_Assault"];
		ZMM_GUERVeh_Truck = ["O_G_Van_01_transport_F"];
		ZMM_GUERVeh_Util = ["O_G_Offroad_01_repair_F","O_G_Van_01_fuel_F"];
		ZMM_GUERVeh_Light = ["O_G_Offroad_01_armed_F","O_G_Offroad_01_AT_F"];
		ZMM_GUERVeh_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Air = [["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
		ZMM_GUERVeh_CasH = [["B_Heli_Light_01_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
		ZMM_GUERVeh_CasP = [["I_Plane_Fighter_04_F","[_grpVeh,['CamoGrey',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Convoy = [["O_G_Offroad_01_armed_F",""],["O_G_Van_01_transport_F",""],["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_01',1,'Guerilla_03',0.5],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
	};
};