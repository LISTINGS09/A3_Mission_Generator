// Choose West Faction
switch (missionNamespace getVariable ["f_param_factionWest",-1]) do {
	/*
	case 0: {
		// WEST - US ARMY D
		ZMM_WESTFlag = ["FlagCarrierUSA", "\ca\data\flag_usa_co.paa"];
		ZMM_WESTMan = ["rhsusf_army_ocp_rifleman","rhsusf_army_ocp_machinegunner","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_grenadier","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_riflemanat","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_squadleader","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_aa","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_maaws"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_infantry" >> "rhs_group_nato_usarmy_d_infantry_team"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_infantry" >> "rhs_group_nato_usarmy_d_infantry_team"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_infantry" >> "rhs_group_nato_usarmy_d_infantry_squad"];
		ZMM_WESTVeh_Truck = [configFile >> "CfgGroups" >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_RG33" >> "rhs_group_nato_usarmy_d_RG33_m2_squad", configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_RG33" >> "rhs_group_nato_usarmy_d_RG33_squad"];
		ZMM_WESTVeh_Util = ["rhsusf_M978A4_usarmy_d","rhsusf_M977A4_AMMO_usarmy_d","rhsusf_M977A4_REPAIR_usarmy_d"];
		ZMM_WESTVeh_Light = ["rhsusf_m1025_d_m2","rhsusf_m1025_d_Mk19"];
		ZMM_WESTVeh_Medium = ["rhsusf_m113d_usarmy","rhsusf_m113d_usarmy_MK19"];
		ZMM_WESTVeh_Heavy = ["RHS_M2A3","RHS_M6","rhsusf_m1a1aimd_usarmy"];
		ZMM_WESTVeh_Air = ["RHS_UH60M2_d","RHS_UH60M_d","RHS_MELB_MH6M"];
		ZMM_WESTVeh_CasH = ["RHS_MELB_AH6M","RHS_AH64DGrey","RHS_AH1Z"];
		ZMM_WESTVeh_CasP = ["RHS_A10","rhsusf_f22"];
		ZMM_WESTVeh_Convoy = ["rhsusf_m1025_d_m2","rhsusf_m1025_d","rhsusf_stryker_m1126_m2_d"];
		ZMM_WESTVeh_Static = ["B_G_HMG_02_high_F"];
	};

	case 1: {
		// WEST - US ARMY W
		ZMM_WESTFlag = ["FlagCarrierUSA", "\ca\data\flag_usa_co.paa"];
		ZMM_WESTMan = ["rhsusf_army_ucp_rifleman","rhsusf_army_ucp_machinegunner","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_grenadier","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_riflemanat","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_squadleader","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_maaws","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_aa"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_infantry" >> "rhs_group_nato_usarmy_wd_infantry_team"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_infantry" >> "rhs_group_nato_usarmy_wd_infantry_team"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_infantry" >> "rhs_group_nato_usarmy_wd_infantry_squad"];
		ZMM_WESTVeh_Truck = [configFile >> "CfgGroups" >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_RG33" >> "rhs_group_nato_usarmy_wd_RG33_m2_squad", configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_RG33" >> "rhs_group_nato_usarmy_wd_RG33_squad"];
		ZMM_WESTVeh_Util = ["rhsusf_M977A4_AMMO_usarmy_wd","rhsusf_M977A4_REPAIR_usarmy_wd","rhsusf_M978A4_usarmy_wd"];
		ZMM_WESTVeh_Light = ["rhsusf_m1025_w_m2","rhsusf_m1025_w_Mk19"];
		ZMM_WESTVeh_Medium = ["rhsusf_m113_usarmy","rhsusf_m113_usarmy_MK19"];
		ZMM_WESTVeh_Heavy = ["RHS_M2A3_wd","RHS_M6_wd","rhsusf_m1a1aimwd_usarmy"];
		ZMM_WESTVeh_Air = ["RHS_UH60M2","RHS_UH60M","RHS_MELB_MH6M"];
		ZMM_WESTVeh_CasH = ["RHS_MELB_AH6M","RHS_AH64D_wd"];
		ZMM_WESTVeh_CasP = ["RHS_A10","rhsusf_f22"];
		ZMM_WESTVeh_Convoy = ["rhsusf_m1025_w_m2","rhsusf_m1025_w","rhsusf_stryker_m1126_m2_wd"];
		ZMM_WESTVeh_Static = ["B_G_HMG_02_high_F"];
	};
	case 2: {
		// WEST - CDF
		ZMM_WESTFlag = ["FlagCarrierCDF_EP1", "\ca\data\flag_Chernarus_co.paa"];
		ZMM_WESTMan = ["rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_machinegunner","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier_rpg","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_specialist_aa"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhsgref_group_cdf_b_reg_infantry" >> "rhsgref_group_cdf_b_reg_infantry_squad"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhsgref_group_cdf_b_reg_infantry" >> "rhsgref_group_cdf_b_reg_infantry_squad"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhsgref_group_cdf_b_reg_infantry" >> "rhsgref_group_cdf_b_reg_infantry_squad"];
		ZMM_WESTVeh_Truck = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_gaz66" >> "rhs_group_cdf_b_gaz66_squad", configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_ural" >> "rhs_group_cdf_b_ural_squad"];
		ZMM_WESTVeh_Util = ["rhsgref_cdf_b_ural_fuel","rhsgref_cdf_b_ural_repair","rhsgref_cdf_b_gaz66_ammo"];
		ZMM_WESTVeh_Light = ["rhsgref_cdf_b_reg_uaz_ags","rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz_spg9"];
		ZMM_WESTVeh_Medium = ["rhsgref_cdf_b_btr70","rhsgref_cdf_b_bmp2k","rhsgref_cdf_b_bmd1k","rhsgref_cdf_b_bmd2k"];
		ZMM_WESTVeh_Heavy = ["rhsgref_cdf_b_zsu234","rhsgref_cdf_b_t72bb_tv"];
		ZMM_WESTVeh_Air = ["rhsgref_cdf_b_reg_Mi8amt","rhsgref_cdf_b_reg_Mi17Sh"];
		ZMM_WESTVeh_CasH = ["rhsgref_cdf_b_Mi35"];
		ZMM_WESTVeh_CasP = ["rhsgref_cdf_b_su25"];
		ZMM_WESTVeh_Convoy = ["rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz","rhsgref_cdf_b_btr70"];
		ZMM_WESTVeh_Static = ["rhsgref_cdf_b_DSHKM"];
	};
	case 3: {
		// WEST - HORIZON
		ZMM_WESTFlag = ["FlagCarrierUSA", "\ca\data\flag_usa_co.paa"];
		ZMM_WESTMan = ["rhsgref_hidf_rifleman","rhsgref_hidf_grenadier","rhsgref_hidf_rifleman","rhsgref_hidf_squadleader","rhsgref_hidf_rifleman","rhsgref_hidf_autorifleman"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_hidf" >> "rhsgref_group_hidf_infantry" >> "rhs_group_hidf_infantry_team"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_hidf" >> "rhsgref_group_hidf_infantry" >> "rhs_group_hidf_infantry_team"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_hidf" >> "rhsgref_group_hidf_infantry" >> "rhsgref_group_hidf_infantry_squad"];
		ZMM_WESTVeh_Truck = ["rhsgref_hidf_m998_4dr"];
		ZMM_WESTVeh_Util = ["rhsusf_M977A4_AMMO_usarmy_wd","rhsusf_M977A4_REPAIR_usarmy_wd","rhsusf_M978A4_usarmy_wd"];
		ZMM_WESTVeh_Light = ["rhsgref_hidf_m1025_m2","rhsgref_hidf_m1025_mk19"];
		ZMM_WESTVeh_Medium = ["rhsgref_hidf_m113a3_m2","rhsgref_hidf_m113a3_mk19"];
		ZMM_WESTVeh_Heavy = ["RHS_M2A3_wd","RHS_M6_wd","rhsusf_m1a1aimwd_usarmy"];
		ZMM_WESTVeh_Air = ["rhs_uh1h_hidf_unarmed","RHS_MELB_MH6M"];
		ZMM_WESTVeh_CAS = ["RHS_MELB_AH6M","RHS_AH64D_wd"];
		ZMM_WESTVeh_CasH = ["rhs_uh1h_hidf_gunship"];
		ZMM_WESTVeh_CasP = ["RHSGREF_A29B_HIDF"];
		ZMM_WESTVeh_Convoy = ["rhsgref_hidf_m1025_m2","rhsgref_hidf_m1025","rhsgref_hidf_m113a3_m2"];
		ZMM_WESTVeh_Static = ["B_G_HMG_02_high_F"];
	};
	case 4: {
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
	case 5: {
		// WEST - NATO TANOA
		ZMM_WESTFlag = ["Flag_NATO_F", "\A3\Data_F\Flags\Flag_NATO_CO.paa"];
		ZMM_WESTMan = ["B_T_Soldier_F","B_T_soldier_LAT_F","B_T_Soldier_F","B_T_soldier_AR_F","B_T_Soldier_F","B_T_Soldier_TL_F","B_T_Soldier_F","B_T_Soldier_AA_F","B_T_Soldier_F","B_T_Soldier_LAT2_F"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfSentry"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfTeam"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfSquad"];
		ZMM_WESTVeh_Truck = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Motorized" >> "B_T_MotInf_Reinforcements"];
		ZMM_WESTVeh_Util = ["B_T_Truck_01_medical_F","B_T_Truck_01_fuel_F","B_T_Truck_01_Repair_F","B_T_Truck_01_ammo_F"];
		ZMM_WESTVeh_Light = ["B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F","B_T_LSV_01_AT_F","B_T_LSV_01_armed_F"];
		ZMM_WESTVeh_Medium = [["B_T_AFV_Wheeled_01_up_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"],["B_T_APC_Tracked_01_rcws_F","[_grpVeh,false,['showCamonetHull',0.3]] call BIS_fnc_initVehicle;"]];;
		ZMM_WESTVeh_Heavy = [["B_T_APC_Tracked_01_AA_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_MBT_01_TUSK_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];;
		ZMM_WESTVeh_Air = ["B_Heli_Light_01_F",["B_Heli_Transport_01_F","[_grpVeh,['Green',1]] call BIS_fnc_initVehicle;"],"B_Heli_Transport_03_F"];
		ZMM_WESTVeh_CasH = ["B_Heli_Light_01_dynamicLoadout_F","B_Heli_Attack_01_dynamicLoadout_F"];
		ZMM_WESTVeh_CasP = ["B_Plane_CAS_01_dynamicLoadout_F","B_Plane_Fighter_01_F"];
		ZMM_WESTVeh_Convoy = ["B_T_MRAP_01_hmg_F","B_T_MRAP_01_F",["B_T_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Static = ["B_GMG_01_high_F","B_HMG_01_high_F"];
	};	
	case 6: {
		// WEST - NATO WOODLAND
		ZMM_WESTFlag = ["Flag_NATO_F", "\A3\Data_F\Flags\Flag_NATO_CO.paa"];
		ZMM_WESTMan = ["B_W_Soldier_F","B_W_soldier_LAT_F","B_W_Soldier_F","B_W_soldier_AR_F","B_W_Soldier_F","B_W_Soldier_TL_F","B_W_Soldier_F","B_W_Soldier_AA_F","B_W_Soldier_F","B_W_Soldier_LAT2_F"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "BLU_W_F" >> "Infantry" >> "B_W_InfSentry"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "BLU_W_F" >> "Infantry" >> "B_W_InfTeam"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "BLU_W_F" >> "Infantry" >> "B_W_InfSquad"];
		ZMM_WESTVeh_Truck = ["B_T_Truck_01_covered_F"];
		ZMM_WESTVeh_Util = ["B_T_Truck_01_medical_F","B_T_Truck_01_fuel_F","B_T_Truck_01_Repair_F","B_T_Truck_01_ammo_F"];
		ZMM_WESTVeh_Light = ["B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F","B_T_LSV_01_AT_F","B_T_LSV_01_armed_F"];
		ZMM_WESTVeh_Medium = [["B_T_AFV_Wheeled_01_up_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"],["B_T_APC_Tracked_01_rcws_F","[_grpVeh,false,['showCamonetHull',0.3]] call BIS_fnc_initVehicle;"]];;
		ZMM_WESTVeh_Heavy = [["B_T_APC_Tracked_01_AA_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_MBT_01_TUSK_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];;
		ZMM_WESTVeh_Air = ["B_Heli_Light_01_F",["B_Heli_Transport_01_F","[_grpVeh,['Green',1]] call BIS_fnc_initVehicle;"],"B_Heli_Transport_03_F"];
		ZMM_WESTVeh_CasH = ["B_Heli_Light_01_dynamicLoadout_F","B_Heli_Attack_01_dynamicLoadout_F"];
		ZMM_WESTVeh_CasP = ["B_Plane_CAS_01_dynamicLoadout_F","B_Plane_Fighter_01_F"];
		ZMM_WESTVeh_Convoy = ["B_T_MRAP_01_hmg_F","B_T_MRAP_01_F",["B_T_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Static = ["B_GMG_01_high_F","B_HMG_01_high_F"];
	};
	case 7: {
		// WEST - WEST GERMANY DESERT
		ZMM_WESTFlag = ["gm_flag_GE", "\gm\gm_core\data\flags\gm_flag_GE_co.paa"];
		ZMM_WESTMan = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_machinegunner_mg3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_antitank_g3a3_pzf44_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_antiair_g3a3_fim43_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_antitank_g3a3_pzf84_80_ols"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_80_ols"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_80_ols",configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_mggroup_80_ols"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_squad_80_ols"];
		ZMM_WESTVeh_Truck = ["gm_ge_army_u1300l_cargo_des"];
		ZMM_WESTVeh_Util = ["gm_ge_army_kat1_451_refuel","gm_ge_army_kat1_451_reammo","gm_ge_army_u1300l_repair","gm_ge_army_u1300l_medic"];
		ZMM_WESTVeh_Light = ["gm_ge_army_iltis_mg3_des"];
		ZMM_WESTVeh_Medium = ["gm_ge_army_fuchsa0_engineer_des","gm_ge_army_m113a1g_apc_des","gm_ge_army_luchsa2_des"];
		ZMM_WESTVeh_Heavy = ["gm_ge_army_Leopard1a3_des","gm_ge_army_gepard1a1_des"];
		ZMM_WESTVeh_Air = [["gm_ge_army_ch53g","[_grpVeh,['gm_ge_olu',0.5,'gm_ge_olo',0.5],true] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_CasH = [["I_Heli_light_03_dynamicLoadout_F","[_grpVeh,['Green',1],true] call BIS_fnc_initVehicle;"],"gm_ge_army_bo105p_pah1a1"];
		ZMM_WESTVeh_CasP = ["RHSGREF_A29B_HIDF"];
		ZMM_WESTVeh_Convoy = ["gm_ge_army_iltis_mg3_des","gm_ge_army_iltis_cargo_des","gm_ge_army_luchsa2_des"];
		ZMM_WESTVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 8: {
		// WEST - WEST GERMANY WINTER
		ZMM_WESTFlag = ["gm_flag_GE", "\gm\gm_core\data\flags\gm_flag_GE_co.paa"];
		ZMM_WESTMan = ["gm_ge_army_rifleman_g3a3_parka_80_win","gm_ge_army_antitank_g3a3_pzf84_parka_80_win","gm_ge_army_rifleman_g3a3_parka_80_win","gm_ge_army_squadleader_g3a3_p2a1_parka_80_win","gm_ge_army_rifleman_g3a3_parka_80_win","gm_ge_army_grenadier_g3a3_parka_80_win","gm_ge_army_rifleman_g3a3_parka_80_win","gm_ge_army_antitank_g3a3_pzf44_parka_80_win","gm_ge_army_rifleman_g3a3_parka_80_win","gm_ge_army_antiair_g3a3_fim43_parka_80_win"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army_win" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_80_win"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army_win" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_80_win",configFile >> "CfgGroups" >> "West" >> "gm_ge_army_win" >> "gm_infantry_80" >> "gm_ge_army_infantry_mggroup_80_win"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army_win" >> "gm_infantry_80" >> "gm_ge_army_infantry_squad_80_win"];
		ZMM_WESTVeh_Truck = ["gm_ge_army_u1300l_cargo_win"];
		ZMM_WESTVeh_Util = ["gm_ge_army_kat1_451_refuel_win","gm_ge_army_kat1_451_reammo_win","gm_ge_army_u1300l_repair_win","gm_ge_army_u1300l_medic_win"];
		ZMM_WESTVeh_Light = ["gm_ge_army_iltis_mg3_win"];
		ZMM_WESTVeh_Medium = ["gm_ge_army_fuchsa0_engineer_win","gm_ge_army_m113a1g_apc_win","gm_ge_army_luchsa2_win"];
		ZMM_WESTVeh_Heavy = ["gm_ge_army_Leopard1a3_win","gm_ge_army_gepard1a1_win"];
		ZMM_WESTVeh_Air = [["gm_ge_army_ch53g","[_grpVeh,['gm_ge_un',1],true] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_CasH = ["gm_ge_army_bo105p_pah1a1"];
		ZMM_WESTVeh_CasP = ["RHSGREF_A29B_HIDF"];
		ZMM_WESTVeh_Convoy = ["gm_ge_army_iltis_mg3_win","gm_ge_army_iltis_cargo_win","gm_ge_army_luchsa2_win"];
		ZMM_WESTVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
	*/
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
		ZMM_WESTVeh_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];;
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
	/*
	case 0: {
		// EAST - RU DESERT MFLORA
		ZMM_EASTFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EASTMan = ["rhs_vdv_mflora_rifleman","rhs_vdv_mflora_sergeant","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_aa","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_at","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_RShG2","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_grenadier","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_LAT","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_machinegunner"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora" >> "rhs_group_rus_vdv_infantry_mflora_MANEUVER"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora" >> "rhs_group_rus_vdv_infantry_mflora_fireteam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_mflora" >> "rhs_group_rus_vdv_infantry_mflora_squad"];
		ZMM_EASTVeh_Truck = [["RHS_Ural_MSV_01","[_grpVeh,['rhs_sand',1],true] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = [["RHS_Ural_Zu23_VDV_01","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Medium = [["rhs_bmd1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_bmp1_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["rhs_t90_tv","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"],["rhs_zsu234_aa","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"],["rhs_bmd2k","[_grpVeh,['Desert',1]] call BIS_fnc_initVehicle;"],["rhs_bmp2d_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = ["rhs_ka60_grey","RHS_Mi8T_vvs","RHS_Mi8mt_vvs"];
		ZMM_EASTVeh_CasH = ["RHS_Ka52_vvs","RHS_Mi24V_vvs"];
		ZMM_EASTVeh_CasP = ["RHS_Su25SM_vvs"];
		ZMM_EASTVeh_Convoy = ["rhs_tigr_sts_3camo_vdv",["RHS_Ural_Zu23_VDV_01","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Static = ["rhs_KORD_high_MSV","rhs_Kornet_9M133_2_msv","rhsgref_ins_DSHKM"];
	};
	case 1: {
		// EAST - RU DESERT EMR
		ZMM_EASTFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EASTMan = ["rhs_vdv_des_rifleman","rhs_vdv_des_sergeant","rhs_vdv_des_rifleman","rhs_vdv_des_aa","rhs_vdv_des_rifleman","rhs_vdv_des_at","rhs_vdv_des_rifleman","rhs_vdv_des_RShG2","rhs_vdv_des_rifleman","rhs_vdv_des_grenadier","rhs_vdv_des_rifleman","rhs_vdv_des_LAT","rhs_vdv_des_rifleman","rhs_vdv_des_machinegunner"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_des_infantry" >> "rhs_group_rus_vdv_des_infantry_MANEUVER"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_des_infantry" >> "rhs_group_rus_vdv_des_infantry_fireteam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_des_infantry" >> "rhs_group_rus_vdv_des_infantry_squad"];
		ZMM_EASTVeh_Truck = [["RHS_Ural_MSV_01","[_grpVeh,['rhs_sand',1],true] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = [["RHS_Ural_Zu23_VDV_01","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Medium = [["rhs_bmd1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_bmp1_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["rhs_t90_tv","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"],["rhs_zsu234_aa","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"],["rhs_bmd2k","[_grpVeh,['Desert',1]] call BIS_fnc_initVehicle;"],["rhs_bmp2d_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = ["rhs_ka60_grey","RHS_Mi8T_vvs","RHS_Mi8mt_vvs"];
		ZMM_EASTVeh_CasH = ["RHS_Ka52_vvs","RHS_Mi24V_vvs"];
		ZMM_EASTVeh_CasP = ["RHS_Su25SM_vvs"];
		ZMM_EASTVeh_Convoy = ["rhs_tigr_sts_3camo_vdv",["RHS_Ural_Zu23_VDV_01","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Static = ["rhs_KORD_high_MSV","rhs_Kornet_9M133_2_msv","rhsgref_ins_DSHKM"];
	};
	case 2: {
		// EAST - RU MSV FLORA
		ZMM_EASTFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EASTMan = ["rhs_msv_rifleman","rhs_msv_aa","rhs_msv_rifleman","rhs_msv_at","rhs_msv_rifleman","rhs_msv_machinegunner","rhs_msv_rifleman","rhs_msv_RShG2","rhs_msv_rifleman","rhs_msv_grenadier","rhs_msv_rifleman","rhs_msv_sergeant","rhs_msv_rifleman","rhs_msv_LAT"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_MANEUVER"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_fireteam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_squad"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_Ural" >> "rhs_group_rus_msv_Ural_squad", configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_gaz66" >> "rhs_group_rus_msv_gaz66_squad"];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = ["rhs_tigr_sts_msv","rhsgref_nat_uaz_dshkm","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9"];
		ZMM_EASTVeh_Medium = ["RHS_Ural_Zu23_VDV_01","rhs_btr80a_msv","rhs_btr70_msv","rhs_btr80_msv"];
		ZMM_EASTVeh_Heavy = ["rhs_bmp1_msv","rhs_bmp2e_msv","rhs_bmp3_msv"];
		ZMM_EASTVeh_Air = ["rhs_ka60_c","RHS_Mi8mt_vvsc","RHS_Mi8T_vvsc"];
		ZMM_EASTVeh_CasH = ["RHS_Ka52_vvsc","RHS_Mi24V_vvsc"];
		ZMM_EASTVeh_CasP = ["RHS_Su25SM_vvsc"];
		ZMM_EASTVeh_Convoy = ["rhs_tigr_sts_msv","rhs_btr80_msv","rhs_btr80_msv"];
		ZMM_EASTVeh_Static = ["rhs_KORD_high_MSV","rhs_Kornet_9M133_2_msv","rhsgref_ins_DSHKM"];
	};
	case 3: {
		// EAST - RU MSV EMR
		ZMM_EASTFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EASTMan = ["rhs_msv_emr_rifleman","rhs_msv_emr_aa","rhs_msv_emr_rifleman","rhs_msv_emr_at","rhs_msv_emr_rifleman","rhs_msv_emr_machinegunner","rhs_msv_emr_rifleman","rhs_msv_emr_RShG2","rhs_msv_emr_rifleman","rhs_msv_emr_grenadier","rhs_msv_emr_rifleman","rhs_msv_emr_sergeant","rhs_msv_emr_rifleman","rhs_msv_emr_LAT"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_MANEUVER"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_fireteam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_Ural" >> "rhs_group_rus_msv_Ural_squad", configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_gaz66" >> "rhs_group_rus_msv_gaz66_squad"];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = ["rhs_tigr_sts_msv","rhsgref_nat_uaz_dshkm","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9"];
		ZMM_EASTVeh_Medium = ["RHS_Ural_Zu23_VDV_01","rhs_btr80a_msv","rhs_btr70_msv","rhs_btr80_msv"];
		ZMM_EASTVeh_Heavy = ["rhs_bmp1_msv","rhs_bmp2e_msv","rhs_bmp3_msv"];
		ZMM_EASTVeh_Air = ["rhs_ka60_c","RHS_Mi8mt_vvsc","RHS_Mi8T_vvsc"];
		ZMM_EASTVeh_CasH = ["RHS_Ka52_vvsc","RHS_Mi24V_vvsc"];
		ZMM_EASTVeh_CasP = ["RHS_Su25SM_vvsc"];
		ZMM_EASTVeh_Convoy = ["rhs_tigr_sts_msv","rhs_btr80_msv","rhs_btr80_msv"];
		ZMM_EASTVeh_Static = ["rhs_KORD_high_MSV","rhs_Kornet_9M133_2_msv","rhsgref_ins_DSHKM"];
	};
	case 4: {
		// EAST - TAKI
		ZMM_EASTFlag = ["FlagCarrierTKMilitia_EP1", "ca\Ca_E\data\flag_tkm_co.paa"];
		ZMM_EASTMan = ["O_Taki_soldier_R_AK74M_F","O_Taki_soldier_G_AK74M_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_RSG_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_R26_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_SL_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_MG_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_G_RPG_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_AA_F"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Infantry" >> "Taki_Sentry"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Infantry" >> "Taki_AssaultTeam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Infantry" >> "Taki_RifleSquad"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Motorized" >> "Taki_MountedWarband"];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = ["Taki_Ural_Zu23_F","Taki_UAZ_ags30_F","Taki_UAZ_dshkm_F","Taki_UAZ_spg9_F"];
		ZMM_EASTVeh_Medium = ["Taki_bmd1_F","Taki_gm_bmp1sp2",["rhs_btr70_vdv","[_grpVeh,['Takistan',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = ["Taki_gm_t55", "Taki_gm_zsu"];
		ZMM_EASTVeh_Air = ["Taki_mi8_transport_F","Taki_mi8_armed_F"];
		ZMM_EASTVeh_CasH = ["Taki_mi8_armed_F"];
		ZMM_EASTVeh_CasP = ["Taki_mi8_armed_F"];
		ZMM_EASTVeh_Convoy = ["Taki_gm_brdm2","Taki_Ural_03_F","Taki_gm_ot64a"];
		ZMM_EASTVeh_Static = ["rhs_KORD_high_MSV","rhsgref_ins_DSHKM"];
	};
	case 5: {
		// EAST - CSAT
		ZMM_EASTFlag = ["Flag_CSAT_F", "\A3\Data_F\Flags\Flag_CSAT_CO.paa"];
		ZMM_EASTMan = ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_F","O_Soldier_AT_F","O_Soldier_F","O_Soldier_AA_F","O_Soldier_F","O_Soldier_SL_F","O_Soldier_F","O_HeavyGunner_F","O_Soldier_F","O_Soldier_AR_F","O_Soldier_F","O_soldier_M_F","O_Soldier_F","O_Soldier_F"];
		// ZMM_EASTMan = ["O_soldierU_F","O_soldierU_M_F","O_soldierU_F","O_Urban_HeavyGunner_F","O_soldierU_F","O_SoldierU_SL_F","O_soldierU_F","O_soldierU_LAT_F","O_soldierU_F","O_soldierU_AA_F","O_soldierU_F","O_soldierU_AT_F","O_soldierU_F","O_soldierU_AR_F"]; // Urban
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized" >> "OIA_MotInf_Reinforce"];
		ZMM_EASTVeh_Util = ["O_Truck_02_Ammo_F","O_Truck_02_fuel_F","O_Truck_02_box_F"];
		ZMM_EASTVeh_Light = ["O_MRAP_02_hmg_F","O_LSV_02_armed_F"];
		ZMM_EASTVeh_Medium = [["O_APC_Wheeled_02_rcws_v2_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_APC_Tracked_02_cannon_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["O_APC_Tracked_02_AA_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_02_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_04_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = ["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F"];
		ZMM_EASTVeh_CasH = ["O_Heli_Light_02_dynamicLoadout_F","O_Heli_Attack_02_dynamicLoadout_F"];
		ZMM_EASTVeh_CasP = [["O_T_VTOL_02_infantry_dynamicLoadout_F","[_grpVeh,['CamoGreyHex',1]] call BIS_fnc_initVehicle;"],"O_Plane_CAS_02_dynamicLoadout_F"];
		ZMM_EASTVeh_Convoy = ["O_MRAP_02_hmg_F","O_MRAP_02_F","O_APC_Wheeled_02_rcws_v2_F"];
		ZMM_EASTVeh_Static = ["B_GMG_01_high_F","B_HMG_01_high_F"];
	};
	case 6: {
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
		ZMM_EASTVeh_Static = ["B_GMG_01_high_F","B_HMG_01_high_F"];
	};
	case 7: {
		// EAST - RU EMR DESERT
		ZMM_EASTFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EASTMan = ["rhs_vdv_des_rifleman","rhs_vdv_des_sergeant","rhs_vdv_des_rifleman","rhs_vdv_des_aa","rhs_vdv_des_rifleman","rhs_vdv_des_at","rhs_vdv_des_rifleman","rhs_vdv_des_RShG2","rhs_vdv_des_rifleman","rhs_vdv_des_grenadier","rhs_vdv_des_rifleman","rhs_vdv_des_LAT","rhs_vdv_des_rifleman","rhs_vdv_des_machinegunner"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_des_infantry" >> "rhs_group_rus_vdv_des_infantry_MANEUVER"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_des_infantry" >> "rhs_group_rus_vdv_des_infantry_fireteam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_des_infantry" >> "rhs_group_rus_vdv_des_infantry_squad"];
		ZMM_EASTVeh_Truck = ["rhs_gaz66_msv"];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = ["Taki_UAZ_ags30_F","Taki_UAZ_dshkm_F","Taki_UAZ_spg9_F",["rhs_btr70_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Medium = [["rhs_gaz66_zu23_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_btr80a_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_bmd2k","[_grpVeh,['Desert',1]] call BIS_fnc_initVehicle;"],["rhs_bmp1_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["rhs_bmp3m_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_bmp2d_tv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_t90_tv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhsgref_ins_zsu234","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhssaf_army_t72s","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = ["rhs_ka60_c","RHS_Mi8mt_vvsc","RHS_Mi8T_vvsc"];
		ZMM_EASTVeh_CasH = ["RHS_Ka52_vvsc","RHS_Mi24V_vvsc"];
		ZMM_EASTVeh_CasP = ["RHS_Su25SM_vvsc"];
		ZMM_EASTVeh_Convoy = [["rhs_t90_tv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_btr80a_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_t90_tv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Static = ["rhs_KORD_high_MSV","rhsgref_ins_DSHKM"];
	};	
	case 8: {
		// EAST - EAST GERMANY	
		ZMM_EASTFlag = ["gm_flag_GC", "\gm\gm_core\data\flags\gm_flag_GC_co.paa"];
		ZMM_EASTMan = ["gm_gc_army_rifleman_mpiak74n_80_str","gm_gc_army_squadleader_mpiak74n_80_str","gm_gc_army_machinegunner_pk_80_str","gm_gc_army_antitank_mpiak74n_rpg7_80_str","gm_gc_army_squadleader_mpiak74n_80_str"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army" >> "gm_borderguards" >> "gm_gc_bgs_infantry_post_str"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_str",configFile >> "CfgGroups" >> "East" >> "gm_gc_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_mggroup_str"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army" >> "gm_infantry_80" >> "gm_gc_army_infantry_squad_str"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army" >> "gm_motorizedinfantry_80" >> "gm_gc_army_motorizedinfantly_squad_ural4320_cargo"];
		ZMM_EASTVeh_Util = ["gm_gc_army_ural4320_repair","gm_gc_army_ural375d_medic","gm_gc_army_ural375d_refuel"];
		ZMM_EASTVeh_Light = ["gm_gc_army_brdm2"];
		ZMM_EASTVeh_Medium = ["gm_gc_army_bmp1sp2","gm_gc_army_btr60pa"];
		ZMM_EASTVeh_Heavy = ["2gm_gc_army_t55a","gm_gc_army_zsu234v1"];
		ZMM_EASTVeh_Air = ["gm_gc_airforce_mi2p"];
		ZMM_EASTVeh_CasH = ["gm_gc_airforce_mi2urn"];
		ZMM_EASTVeh_CasP = ["RHSGREF_A29B_HIDF"];
		ZMM_EASTVeh_Convoy = ["gm_gc_army_brdm2","gm_gc_army_brdm2um","gm_gc_army_btr60pa"];
		ZMM_EASTVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 9: {
		// EAST - EAST GERMANY	WINTER
		ZMM_EASTFlag = ["gm_flag_GC", "\gm\gm_core\data\flags\gm_flag_GC_co.paa"];
		ZMM_EASTMan = ["gm_gc_army_rifleman_mpiak74n_80_win","gm_gc_army_squadleader_mpiak74n_80_win","gm_gc_army_machinegunner_pk_80_win","gm_gc_army_antitank_mpiak74n_rpg7_80_win","gm_gc_army_squadleader_mpiak74n_80_win"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army_win" >> "gm_borderguards" >> "gm_gc_bgs_infantry_post_win"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army_win" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_win",configFile >> "CfgGroups" >> "East" >> "gm_gc_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_mggroup_win"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army_win" >> "gm_infantry_80" >> "gm_gc_army_infantry_squad_win"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army_win" >> "gm_motorizedinfantry_80" >> "gm_gc_army_motorizedinfantly_squad_ural4320_cargo"];
		ZMM_EASTVeh_Util = ["gm_gc_army_ural4320_repair_win","gm_gc_army_ural375d_medic_win","gm_gc_army_ural375d_refuel_win"];
		ZMM_EASTVeh_Light = ["gm_gc_army_brdm2_win"];
		ZMM_EASTVeh_Medium = ["gm_gc_army_bmp1sp2_win","gm_gc_army_btr60pa_win"];
		ZMM_EASTVeh_Heavy = ["2gm_gc_army_t55a_win","gm_gc_army_zsu234v1_win"];
		ZMM_EASTVeh_Air = [["gm_gc_airforce_mi2p","[_grpVeh,['gm_gc_un',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_CasH = [["gm_gc_airforce_mi2urn","[_grpVeh,['gm_gc_un',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_CasP = ["RHSGREF_A29B_HIDF"];
		ZMM_EASTVeh_Convoy = ["gm_gc_army_brdm2_win","gm_gc_army_brdm2um_win","gm_gc_army_btr60pa_win"];
		ZMM_EASTVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
	*/
	default {
		// EAST - CSAT
		ZMM_EASTFlag = ["Flag_CSAT_F", "\A3\Data_F\Flags\Flag_CSAT_CO.paa"];
		ZMM_EASTMan = ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_F","O_Soldier_AT_F","O_Soldier_F","O_Soldier_AA_F","O_Soldier_F","O_Soldier_SL_F","O_Soldier_F","O_HeavyGunner_F","O_Soldier_F","O_Soldier_AR_F","O_Soldier_F","O_soldier_M_F","O_Soldier_F","O_Soldier_F"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized" >> "OIA_MotInf_Reinforce"];
		ZMM_EASTVeh_Util = ["O_Truck_02_Ammo_F","O_Truck_02_fuel_F","O_Truck_02_box_F"];
		ZMM_EASTVeh_Light = ["O_MRAP_02_hmg_F","O_LSV_02_armed_F"];
		ZMM_EASTVeh_Medium = [["O_APC_Wheeled_02_rcws_v2_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_APC_Tracked_02_cannon_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["O_APC_Tracked_02_AA_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_02_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_04_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = ["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F"];
		ZMM_EASTVeh_CasH = ["O_Heli_Light_02_dynamicLoadout_F","O_Heli_Attack_02_dynamicLoadout_F"];
		ZMM_EASTVeh_CasP = [["O_T_VTOL_02_infantry_dynamicLoadout_F","[_grpVeh,['CamoGreyHex',1]] call BIS_fnc_initVehicle;"],"O_Plane_CAS_02_dynamicLoadout_F"];
		ZMM_EASTVeh_Convoy = ["O_MRAP_02_hmg_F","O_MRAP_02_F","O_APC_Wheeled_02_rcws_v2_F"];
		ZMM_EASTVeh_Static = ["B_GMG_01_high_F","B_HMG_01_high_F"];
	};
};

// Choose Guer Faction
switch (missionNamespace getVariable ["f_param_factionGuer",-1]) do {
	/*
	case 1: {
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
	case 2: {
		// GUER - NAPA
		ZMM_GUERFlag = ["Flag_Enoch_F", "\a3\Data_F_Enoch\Flags\flag_Enoch_CO.paa"];
		ZMM_GUERMan = ["rhsgref_nat_rifleman","rhsgref_nat_specialist_aa","rhsgref_nat_rifleman","rhsgref_nat_grenadier_rpg","rhsgref_nat_rifleman","rhsgref_nat_machinegunner","rhsgref_nat_rifleman","rhsgref_nat_grenadier","rhsgref_nat_rifleman_mp44rhsgref_nat_scout","rhsgref_nat_rifleman","rhsgref_nat_commander"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_nationalist" >> "rhsgref_group_national_infantry" >> "rhsgref_group_national_infantry_at"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_nationalist" >> "rhsgref_group_national_infantry" >> "rhsgref_group_national_infantry_patrol"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_nationalist" >> "rhsgref_group_national_infantry" >> "rhsgref_group_national_infantry_squad_2"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_nationalist" >> "rhs_group_indp_nat_ural" >> "rhs_group_nat_ural_squad"];
		ZMM_GUERVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_GUERVeh_Light = ["rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9","rhsgref_nat_uaz_dshkm","rhsgref_nat_btr70"];
		ZMM_GUERVeh_Medium = ["rhsgref_ins_g_bmp2k","rhsgref_ins_g_bmp1k"];
		ZMM_GUERVeh_Heavy = ["rhsgref_ins_g_zsu234","rhsgref_ins_g_t72bc"];
		ZMM_GUERVeh_Air = ["rhsgref_cdf_reg_Mi8amt"];
		ZMM_GUERVeh_CasH = ["rhsgref_cdf_Mi35"];
		ZMM_GUERVeh_CasP = ["rhsgref_cdf_su25"];
		ZMM_GUERVeh_Convoy = ["rhsgref_nat_uaz_dshkm","rhsgref_nat_ural","rhsgref_nat_btr70"];
		ZMM_GUERVeh_Static = ["rhsgref_cdf_DSHKM"];
	};
	case 3: {
		// GUER - UN
		ZMM_GUERFlag = ["Flag_Enoch_F", "\a3\Data_F_Enoch\Flags\flag_Enoch_CO.paa"];
		ZMM_GUERMan = ["rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_rifleman_at","rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_sq_lead","rhssaf_un_m10_digital_desert_rifleman_m70vrhssaf_un_m10_digital_desert_spec_at","rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_spec_aa","rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_mgun_m84","rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_sniper_m76"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "rhssaf_faction_un" >> "rhssaf_group_un_infantry" >> "rhssaf_group_un_infantry_infantry_team"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "Indep" >> "rhssaf_faction_un" >> "rhssaf_group_un_infantry" >> "rhssaf_group_un_infantry_infantry_team"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "Indep" >> "rhssaf_faction_un" >> "rhssaf_group_un_infantry" >> "rhssaf_group_un_infantry_infantry_squad"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhssaf_faction_un" >> "rhssaf_group_un_ural" >> "rhssaf_group_un_ural_squad"];
		ZMM_GUERVeh_Util = ["C_IDAP_Truck_02_water_F","C_IDAP_Van_02_medevac_F"];
		ZMM_GUERVeh_Light = ["rhsgref_un_m1117"];
		ZMM_GUERVeh_Medium = ["rhsgref_un_btr70"];
		ZMM_GUERVeh_Heavy = [["rhsgref_cdf_bmd1","[_grpVeh,['MC',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Air = ["rhsgref_un_Mi8amt"];
		ZMM_GUERVeh_CasH = ["rhsgref_un_Mi24V"];
		ZMM_GUERVeh_CasP = ["rhsgref_cdf_su25"];
		ZMM_GUERVeh_Convoy = ["rhsgref_un_uaz","rhsgref_un_ural","rhsgref_un_btr70"];
		ZMM_GUERVeh_Static = ["rhsgref_cdf_DSHKM"];
	};
	case 4: {
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
		ZMM_GUERVeh_Static = ["B_GMG_01_high_F","B_HMG_01_high_F"];
	};
	case 5: {
		// GUER - ChDKZ
		ZMM_GUERFlag = ["FlagCarrierINS", "\a3\Data_F_Enoch\Flags\flag_EAF_CO.paa"];
		ZMM_GUERMan = ["rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_grenadier_rpg","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_rifleman_RPG26","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_grenadier","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_machinegunner","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_saboteur","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_specialist_aa"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhsgref_group_chdkz_ins_gurgents_infantry" >> "rhsgref_group_chdkz_infantry_mg"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhsgref_group_chdkz_ins_gurgents_infantry" >> "rhsgref_group_chdkz_infantry_patrol"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhsgref_group_chdkz_ins_gurgents_infantry" >> "rhsgref_group_chdkz_ins_gurgents_squad"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhs_group_indp_ins_g_ural" >> "rhs_group_chdkz_ural_squad"];
		ZMM_GUERVeh_Util = ["rhsgref_ins_g_ural_repair","rhsgref_ins_g_gaz66_ammo"];
		ZMM_GUERVeh_Light = ["rhsgref_ins_g_uaz_spg9","rhsgref_ins_g_uaz_ags","rhsgref_ins_g_uaz_dshkm_chdkz","rhsgref_BRDM2_ins_g"];
		ZMM_GUERVeh_Medium = ["rhsgref_ins_g_ural_Zu23","rhsgref_ins_g_btr70","rhsgref_ins_g_bmp2k","rhsgref_ins_g_bmp1k","rhsgref_ins_g_bmd1"];
		ZMM_GUERVeh_Heavy = ["rhsgref_ins_g_bmd2","rhsgref_ins_g_zsu234","rhsgref_ins_g_t72ba","rhsgref_ins_g_t72bb"];
		ZMM_GUERVeh_Air = ["rhsgref_ins_g_Mi8amt"];
		ZMM_GUERVeh_CasH = [["rhsgref_cdf_reg_Mi17Sh","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_CasP = [["RHSGREF_A29B_HIDF","[_grpVeh,['Ecuador',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Convoy = ["rhsgref_BRDM2_ins_g","rhsgref_ins_g_ural","rhsgref_ins_g_bmd2"];
		ZMM_GUERVeh_Static = ["rhsgref_ins_g_DSHKM"];
	};
	case 6: {
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
		ZMM_GUERVeh_Static = ["B_G_HMG_02_high_F"];
	};
	case 7: {
		// GUER - SAF
	};	
	case 8: {
		// GUER - TLA
		ZMM_GUERFlag = ["FlagCarrierINS", "\a3\Data_F_Enoch\Flags\flag_EAF_CO.paa"];
		ZMM_GUERMan = ["rhsgref_tla_rifleman_M16","rhsgref_tla_specialist_at","rhsgref_tla_rifleman_M16","rhsgref_tla_grenadier","rhsgref_tla_rifleman_M16","rhsgref_tla_squadleader","rhsgref_tla_rifleman_M16","rhsgref_tla_rifleman_rpg75","rhsgref_tla_rifleman_M16","rhsgref_tla_machinegunner","rhsgref_tla_rifleman_M16","rhsgref_tla_machinegunner_mg42"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "rhsgref_faction_tla" >> "rhsgref_group_tla_infantry" >> "rhsgref_group_tla_insurgent_cell"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "East" >> "rhsgref_faction_tla" >> "rhsgref_group_tla_infantry" >> "rhsgref_group_tla_insurgent_cell"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "rhsgref_faction_tla" >> "rhsgref_group_tla_infantry" >> "rhsgref_group_tla_insurgent_cell"];
		ZMM_GUERVeh_Truck = ["rhsgref_ins_g_zil131_open"];
		ZMM_GUERVeh_Util = ["rhsgref_ins_g_kraz255b1_fuel","rhsgref_ins_g_gaz66_repair","rhsgref_ins_g_gaz66_ammo"];
		ZMM_GUERVeh_Light = ["rhsgref_ins_g_uaz_spg9","rhsgref_ins_g_uaz_ags","rhsgref_ins_g_uaz_dshkm_chdkz","rhsgref_BRDM2_ins_g"];
		ZMM_GUERVeh_Medium = ["rhsgref_ins_g_ural_Zu23","rhsgref_ins_g_btr70","rhsgref_ins_g_bmd1"];
		ZMM_GUERVeh_Heavy = ["rhsgref_ins_g_bmd2","rhsgref_ins_g_zsu234","rhsgref_ins_g_t72ba","rhsgref_ins_g_t72bb"];
		ZMM_GUERVeh_Air = ["rhsgref_ins_g_Mi8amt"];
		ZMM_GUERVeh_CasH = [["rhsgref_cdf_reg_Mi17Sh","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_CasP = [["RHSGREF_A29B_HIDF","[_grpVeh,['Ecuador',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Convoy = ["rhsgref_BRDM2_ins_g","rhsgref_ins_g_zil131_open","rhsgref_ins_g_bmd2"];
		ZMM_GUERVeh_Static = ["rhsgref_ins_g_DSHKM"];
	};
	*/
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
		ZMM_GUERVeh_Static = ["B_G_HMG_02_high_F"];
	};
};