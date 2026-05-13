// Choose West Faction
switch (missionNamespace getVariable ["f_param_factionWest",-1]) do {
	case 1: {
		// WEST - US ARMY D
		ZMM_WEST_FactionName = "US Army (Desert)";
		ZMM_WEST_Flag = ["FlagCarrierUSA", "\ca\data\flag_usa_co.paa"];
		ZMM_WEST_Man = ["rhsusf_army_ocp_rifleman","rhsusf_army_ocp_machinegunner","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_grenadier","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_riflemanat","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_squadleader","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_aa","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_maaws"];
		ZMM_WEST_Truck = [configFile >> "CfgGroups" >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_RG33" >> "rhs_group_nato_usarmy_d_RG33_m2_squad", configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_RG33" >> "rhs_group_nato_usarmy_d_RG33_squad"];
		ZMM_WEST_Util = ["rhsusf_M978A4_usarmy_d","rhsusf_M977A4_AMMO_usarmy_d","rhsusf_M977A4_REPAIR_usarmy_d"];
		ZMM_WEST_Light = ["rhsusf_m1025_d_m2","rhsusf_m1025_d_Mk19"];
		ZMM_WEST_Medium = ["rhsusf_m113d_usarmy","rhsusf_m113d_usarmy_MK19"];
		ZMM_WEST_Heavy = ["RHS_M2A3","RHS_M6","rhsusf_m1a1aimd_usarmy"];
		ZMM_WEST_Air = ["RHS_UH60M2_d","RHS_UH60M_d","RHS_MELB_MH6M"];
		ZMM_WEST_CasH = ["RHS_MELB_AH6M","RHS_AH64DGrey","RHS_AH1Z"];
		ZMM_WEST_CasP = ["RHS_A10","rhsusf_f22"];
		ZMM_WEST_Convoy = ["rhsusf_m1025_d_m2","rhsusf_m1025_d","rhsusf_stryker_m1126_m2_d"];
		ZMM_WEST_Static = ["B_G_HMG_02_high_F"];
	};
	case 2: {
		// WEST - CDF
		ZMM_WEST_FactionName = "CDF";
		ZMM_WEST_Flag = ["FlagCarrierCDF_EP1", "\ca\data\flag_Chernarus_co.paa"];
		ZMM_WEST_Man = ["rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_machinegunner","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier_rpg","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_specialist_aa"];
		ZMM_WEST_Truck = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_gaz66" >> "rhs_group_cdf_b_gaz66_squad", configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_ural" >> "rhs_group_cdf_b_ural_squad"];
		ZMM_WEST_Util = ["rhsgref_cdf_b_ural_fuel","rhsgref_cdf_b_ural_repair","rhsgref_cdf_b_gaz66_ammo"];
		ZMM_WEST_Light = ["rhsgref_cdf_b_reg_uaz_ags","rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz_spg9"];
		ZMM_WEST_Medium = ["rhsgref_cdf_b_btr70","rhsgref_cdf_b_bmp2k","rhsgref_cdf_b_bmd1k","rhsgref_cdf_b_bmd2k"];
		ZMM_WEST_Heavy = ["rhsgref_cdf_b_zsu234","rhsgref_cdf_b_t72bb_tv"];
		ZMM_WEST_Air = ["rhsgref_cdf_b_reg_Mi8amt","rhsgref_cdf_b_reg_Mi17Sh"];
		ZMM_WEST_CasH = ["rhsgref_cdf_b_Mi35"];
		ZMM_WEST_CasP = ["rhsgref_cdf_b_su25"];
		ZMM_WEST_Convoy = ["rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz","rhsgref_cdf_b_btr70"];
		ZMM_WEST_Static = ["rhsgref_cdf_b_DSHKM"];
	};
	case 3: {
		// WEST - HORIZON
		ZMM_WEST_FactionName = "Horizon";
		ZMM_WEST_Flag = ["FlagCarrierUSA", "\ca\data\flag_usa_co.paa"];
		ZMM_WEST_Man = ["rhsgref_hidf_rifleman","rhsgref_hidf_grenadier","rhsgref_hidf_rifleman","rhsgref_hidf_squadleader","rhsgref_hidf_grenadier_m79","rhsgref_hidf_rifleman","rhsgref_hidf_autorifleman"];
		ZMM_WEST_Truck = ["rhsgref_hidf_m998_4dr"];
		ZMM_WEST_Util = ["rhsusf_M977A4_AMMO_usarmy_wd","rhsusf_M977A4_REPAIR_usarmy_wd","rhsusf_M978A4_usarmy_wd"];
		ZMM_WEST_Light = ["rhsgref_hidf_m1025_m2","rhsgref_hidf_m1025_mk19"];
		ZMM_WEST_Medium = ["rhsgref_hidf_m113a3_m2","rhsgref_hidf_m113a3_mk19"];
		ZMM_WEST_Heavy = ["RHS_M2A3_wd","RHS_M6_wd","rhsusf_m1a1aimwd_usarmy"];
		ZMM_WEST_Air = ["rhs_uh1h_hidf"];
		ZMM_WEST_CasH = ["rhs_uh1h_hidf_gunship"];
		ZMM_WEST_CasP = ["RHSGREF_A29B_HIDF"];
		ZMM_WEST_Convoy = ["rhsgref_hidf_m1025_m2","rhsgref_hidf_m1025","rhsgref_hidf_m113a3_m2"];
		ZMM_WEST_Static = ["rhsgref_hidf_m2_static"];
	};
	default {
		// WEST - US ARMY W
		ZMM_WEST_FactionName = "US Army (Woodland)";
		ZMM_WEST_Flag = ["FlagCarrierUSA", "\ca\data\flag_usa_co.paa"];
		ZMM_WEST_Man = ["rhsusf_army_ucp_rifleman","rhsusf_army_ucp_machinegunner","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_grenadier","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_riflemanat","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_squadleader","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_maaws","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_aa"];
		ZMM_WEST_Truck = [configFile >> "CfgGroups" >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_RG33" >> "rhs_group_nato_usarmy_wd_RG33_m2_squad", configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_RG33" >> "rhs_group_nato_usarmy_wd_RG33_squad"];
		ZMM_WEST_Util = ["rhsusf_M977A4_AMMO_usarmy_wd","rhsusf_M977A4_REPAIR_usarmy_wd","rhsusf_M978A4_usarmy_wd"];
		ZMM_WEST_Light = ["rhsusf_m1025_w_m2","rhsusf_m1025_w_Mk19"];
		ZMM_WEST_Medium = ["rhsusf_m113_usarmy","rhsusf_m113_usarmy_MK19"];
		ZMM_WEST_Heavy = ["RHS_M2A3_wd","RHS_M6_wd","rhsusf_m1a1aimwd_usarmy"];
		ZMM_WEST_Air = ["RHS_UH60M2","RHS_UH60M","RHS_MELB_MH6M"];
		ZMM_WEST_CasH = ["RHS_MELB_AH6M","RHS_AH64D_wd"];
		ZMM_WEST_CasP = ["RHS_A10","rhsusf_f22"];
		ZMM_WEST_Convoy = ["rhsusf_m1025_w_m2","rhsusf_m1025_w","rhsusf_stryker_m1126_m2_wd"];
		ZMM_WEST_Static = ["B_G_HMG_02_high_F"];
	};
};

// Choose East Faction
switch (missionNamespace getVariable ["f_param_factionEast",-1]) do {
	case 1: {
		// EAST - RU DESERT MFLORA
		ZMM_EAST_FactionName = "RU (Desert MFLORA)";
		ZMM_EAST_Flag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EAST_Man = ["rhs_vdv_mflora_rifleman","rhs_vdv_mflora_sergeant","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_aa","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_at","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_RShG2","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_grenadier","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_LAT","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_machinegunner"];
		ZMM_EAST_Truck = [["RHS_Ural_MSV_01","[_grpVeh,['rhs_sand',1],true] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EAST_Light = [["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Medium = [["rhs_bmd1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_bmp1_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Heavy = [["rhs_t90_tv","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"],["rhs_zsu234_aa","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"],["rhs_bmd2k","[_grpVeh,['Desert',1]] call BIS_fnc_initVehicle;"],["rhs_bmp2d_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Air = ["rhs_ka60_grey","RHS_Mi8T_vvs","RHS_Mi8mt_vvs"];
		ZMM_EAST_CasH = ["RHS_Ka52_vvs","RHS_Mi24V_vvs"];
		ZMM_EAST_CasP = ["RHS_Su25SM_vvs"];
		ZMM_EAST_Convoy = ["rhs_tigr_sts_3camo_vdv",["RHS_Ural_Zu23_VDV_01","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Static = ["rhs_KORD_high_MSV","rhs_Kornet_9M133_2_msv","rhsgref_ins_DSHKM"];
	};
	case 2: {
		// EAST - RU DESERT EMR
		ZMM_EAST_FactionName = "RU (Desert EMR)";
		ZMM_EAST_Flag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EAST_Man = ["rhs_vdv_des_rifleman","rhs_vdv_des_sergeant","rhs_vdv_des_rifleman","rhs_vdv_des_aa","rhs_vdv_des_rifleman","rhs_vdv_des_at","rhs_vdv_des_rifleman","rhs_vdv_des_RShG2","rhs_vdv_des_rifleman","rhs_vdv_des_grenadier","rhs_vdv_des_rifleman","rhs_vdv_des_LAT","rhs_vdv_des_rifleman","rhs_vdv_des_machinegunner"];
		ZMM_EAST_Truck = [["RHS_Ural_MSV_01","[_grpVeh,['rhs_sand',1],true] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EAST_Light = [["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Medium = [["rhs_bmd1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_bmp1_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Heavy = [["rhs_t90_tv","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"],["rhs_zsu234_aa","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"],["rhs_bmd2k","[_grpVeh,['Desert',1]] call BIS_fnc_initVehicle;"],["rhs_bmp2d_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Air = ["rhs_ka60_grey","RHS_Mi8T_vvs","RHS_Mi8mt_vvs"];
		ZMM_EAST_CasH = ["RHS_Ka52_vvs","RHS_Mi24V_vvs"];
		ZMM_EAST_CasP = ["RHS_Su25SM_vvs"];
		ZMM_EAST_Convoy = ["rhs_tigr_sts_3camo_vdv",["RHS_Ural_Zu23_VDV_01","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Static = ["rhs_KORD_high_MSV","rhs_Kornet_9M133_2_msv","rhsgref_ins_DSHKM"];
	};
	case 3: {
		// EAST - RU MSV FLORA
		ZMM_EAST_FactionName = "RU MSV (Flora)";
		ZMM_EAST_Flag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EAST_Man = ["rhs_msv_rifleman","rhs_msv_aa","rhs_msv_rifleman","rhs_msv_at","rhs_msv_rifleman","rhs_msv_machinegunner","rhs_msv_rifleman","rhs_msv_RShG2","rhs_msv_rifleman","rhs_msv_grenadier","rhs_msv_rifleman","rhs_msv_sergeant","rhs_msv_rifleman","rhs_msv_LAT"];
		ZMM_EAST_Truck = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_Ural" >> "rhs_group_rus_msv_Ural_squad", configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_gaz66" >> "rhs_group_rus_msv_gaz66_squad"];
		ZMM_EAST_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EAST_Light = ["rhs_tigr_sts_msv","rhsgref_nat_uaz_dshkm","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9"];
		ZMM_EAST_Medium = ["rhs_btr80a_msv","rhs_btr70_msv","rhs_btr80_msv"];
		ZMM_EAST_Heavy = ["rhs_bmp1_msv","rhs_bmp2e_msv","rhs_bmp3_msv"];
		ZMM_EAST_Air = ["rhs_ka60_c","RHS_Mi8mt_vvsc","RHS_Mi8T_vvsc"];
		ZMM_EAST_CasH = ["RHS_Ka52_vvsc","RHS_Mi24V_vvsc"];
		ZMM_EAST_CasP = ["RHS_Su25SM_vvsc"];
		ZMM_EAST_Convoy = ["rhs_tigr_sts_msv","rhs_btr80_msv","rhs_btr80_msv"];
		ZMM_EAST_Static = ["rhs_KORD_high_MSV","rhs_Kornet_9M133_2_msv","rhsgref_ins_DSHKM"];
	};
	case 4: {
		// EAST - TAKI
		ZMM_EAST_FactionName = "Takiban";
		ZMM_EAST_Flag = ["FlagCarrierTKMilitia_EP1", "ca\Ca_E\data\flag_tkm_co.paa"];
		ZMM_EAST_Man = ["O_Taki_soldier_R_AK74M_F","O_Taki_soldier_G_AK74M_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_RSG_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_R26_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_SL_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_MG_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_G_RPG_F","O_Taki_soldier_R_AK74M_F"];
		ZMM_EAST_Truck = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Motorized" >> "Taki_MountedWarband"];
		ZMM_EAST_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EAST_Light = ["Taki_Ural_Zu23_F","Taki_UAZ_ags30_F","Taki_UAZ_dshkm_F","Taki_UAZ_spg9_F"];
		ZMM_EAST_Medium = ["Taki_bmd1_F","Taki_gm_bmp1sp2",["rhs_btr70_vdv","[_grpVeh,['Takistan',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Heavy = ["Taki_gm_t55", "Taki_gm_zsu"];
		ZMM_EAST_Air = ["Taki_mi8_transport_F","Taki_mi8_armed_F"];
		ZMM_EAST_CasH = ["Taki_mi8_armed_F"];
		ZMM_EAST_CasP = ["Taki_mi8_armed_F"];
		ZMM_EAST_Convoy = ["Taki_gm_brdm2","Taki_Ural_03_F","Taki_gm_ot64a"];
		ZMM_EAST_Static = ["rhs_KORD_high_MSV","rhsgref_ins_DSHKM"];
	};
	case 5: {
		// EAST - RU EMR DESERT
		ZMM_EAST_FactionName = "RU VDV (Desert)";
		ZMM_EAST_Flag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EAST_Man = ["rhs_vdv_des_rifleman","rhs_vdv_des_sergeant","rhs_vdv_des_rifleman","rhs_vdv_des_aa","rhs_vdv_des_rifleman","rhs_vdv_des_at","rhs_vdv_des_rifleman","rhs_vdv_des_RShG2","rhs_vdv_des_rifleman","rhs_vdv_des_grenadier","rhs_vdv_des_rifleman","rhs_vdv_des_LAT","rhs_vdv_des_rifleman","rhs_vdv_des_machinegunner"];
		ZMM_EAST_Truck = ["rhs_gaz66_msv"];
		ZMM_EAST_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EAST_Light = ["Taki_UAZ_ags30_F","Taki_UAZ_dshkm_F","Taki_UAZ_spg9_F",["rhs_btr70_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Medium = [["rhs_btr80a_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_bmd2k","[_grpVeh,['Desert',1]] call BIS_fnc_initVehicle;"],["rhs_bmp1_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Heavy = [["rhs_bmp3m_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_bmp2d_tv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_t90_tv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhsgref_ins_zsu234","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhssaf_army_t72s","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Air = ["rhs_ka60_c","RHS_Mi8mt_vvsc","RHS_Mi8T_vvsc"];
		ZMM_EAST_CasH = ["RHS_Ka52_vvsc","RHS_Mi24V_vvsc"];
		ZMM_EAST_CasP = ["RHS_Su25SM_vvsc"];
		ZMM_EAST_Convoy = [["rhs_t90_tv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_btr80a_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_t90_tv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Static = ["rhs_KORD_high_MSV","rhsgref_ins_DSHKM"];
	};
	case 6: {
		// EAST - ChDKZ
		ZMM_EAST_FactionName = "ChDKz";
		ZMM_EAST_Flag = ["FlagCarrierINS", "\a3\Data_F_Enoch\Flags\flag_EAF_CO.paa"];
		ZMM_EAST_Man = ["rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_grenadier_rpg","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_rifleman_RPG26","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_grenadier","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_machinegunner","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_saboteur","rhsgref_ins_g_rifleman_aks74"];
		ZMM_EAST_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhs_group_indp_ins_g_ural" >> "rhs_group_chdkz_ural_squad"];
		ZMM_EAST_Util = ["rhsgref_ins_ural_repair","rhsgref_ins_gaz66_ammo"];
		ZMM_EAST_Light = ["rhsgref_ins_uaz_spg9","rhsgref_ins_uaz_ags","rhsgref_ins_uaz_dshkm_chdkz","rhsgref_BRDM2_ins"];
		ZMM_EAST_Medium = ["rhsgref_ins_ural_Zu23","rhsgref_ins_btr70","rhsgref_ins_bmp2k","rhsgref_ins_bmp1k","rhsgref_ins_bmd1"];
		ZMM_EAST_Heavy = ["rhsgref_ins_bmd2","rhsgref_ins_zsu234","rhsgref_ins_t72ba","rhsgref_ins_t72bb"];
		ZMM_EAST_Air = ["rhsgref_ins_Mi8amt"];
		ZMM_EAST_CasH = [["rhsgref_cdf_reg_Mi17Sh","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_CasP = [["RHSGREF_A29B_HIDF","[_grpVeh,['Ecuador',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Convoy = ["rhsgref_BRDM2_ins","rhsgref_ins_ural","rhsgref_ins_bmd2"];
		ZMM_EAST_Static = ["rhsgref_ins_DSHKM"];
	};	
	default {
		// EAST - RU MSV EMR
		ZMM_EAST_FactionName = "RU MSV (EMR)";
		ZMM_EAST_Flag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EAST_Man = ["rhs_msv_emr_rifleman","rhs_msv_emr_aa","rhs_msv_emr_rifleman","rhs_msv_emr_at","rhs_msv_emr_rifleman","rhs_msv_emr_machinegunner","rhs_msv_emr_rifleman","rhs_msv_emr_RShG2","rhs_msv_emr_rifleman","rhs_msv_emr_grenadier","rhs_msv_emr_rifleman","rhs_msv_emr_sergeant","rhs_msv_emr_rifleman","rhs_msv_emr_LAT"];
		ZMM_EAST_Truck = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_Ural" >> "rhs_group_rus_msv_Ural_squad", configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_gaz66" >> "rhs_group_rus_msv_gaz66_squad"];
		ZMM_EAST_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EAST_Light = ["rhs_tigr_sts_msv","rhsgref_nat_uaz_dshkm","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9"];
		ZMM_EAST_Medium = ["rhs_btr80a_msv","rhs_btr70_msv","rhs_btr80_msv"];
		ZMM_EAST_Heavy = ["rhs_bmp1_msv","rhs_bmp2e_msv","rhs_bmp3_msv"];
		ZMM_EAST_Air = ["rhs_ka60_c","RHS_Mi8mt_vvsc","RHS_Mi8T_vvsc"];
		ZMM_EAST_CasH = ["RHS_Ka52_vvsc","RHS_Mi24V_vvsc"];
		ZMM_EAST_CasP = ["RHS_Su25SM_vvsc"];
		ZMM_EAST_Convoy = ["rhs_tigr_sts_msv","rhs_btr80_msv","rhs_btr80_msv"];
		ZMM_EAST_Static = ["rhs_KORD_high_MSV","rhs_Kornet_9M133_2_msv","rhsgref_ins_DSHKM"];
	};
};

// Choose Guer Faction
switch (missionNamespace getVariable ["f_param_factionGuer",-1]) do {
	case 1: {
		// GUER - NAPA
		ZMM_GUER_FactionName = "NAPA";
		ZMM_GUER_Flag = ["Flag_Enoch_F", "\a3\Data_F_Enoch\Flags\flag_Enoch_CO.paa"];
		ZMM_GUER_Man = ["rhsgref_nat_rifleman","rhsgref_nat_rifleman","rhsgref_nat_grenadier_rpg","rhsgref_nat_rifleman","rhsgref_nat_machinegunner","rhsgref_nat_rifleman","rhsgref_nat_grenadier","rhsgref_nat_rifleman_mp44rhsgref_nat_scout","rhsgref_nat_rifleman","rhsgref_nat_commander"];
		ZMM_GUER_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_nationalist" >> "rhs_group_indp_nat_ural" >> "rhs_group_nat_ural_squad"];
		ZMM_GUER_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_GUER_Light = ["rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9","rhsgref_nat_uaz_dshkm","rhsgref_nat_btr70"];
		ZMM_GUER_Medium = ["rhsgref_ins_g_bmp2k","rhsgref_ins_g_bmp1k"];
		ZMM_GUER_Heavy = ["rhsgref_ins_g_zsu234","rhsgref_ins_g_t72bc"];
		ZMM_GUER_Air = ["rhsgref_cdf_reg_Mi8amt"];
		ZMM_GUER_CasH = ["rhsgref_cdf_Mi35"];
		ZMM_GUER_CasP = ["rhsgref_cdf_su25"];
		ZMM_GUER_Convoy = ["rhsgref_nat_uaz_dshkm","rhsgref_nat_ural","rhsgref_nat_btr70"];
		ZMM_GUER_Static = ["rhsgref_cdf_DSHKM"];
	};
	case 2: {
		// GUER - UN
		ZMM_GUER_FactionName = "UN";
		ZMM_GUER_Flag = ["Flag_Enoch_F", "\a3\Data_F_Enoch\Flags\flag_Enoch_CO.paa"];
		ZMM_GUER_Man = ["rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_rifleman_at","rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_sq_lead","rhssaf_un_m10_digital_desert_rifleman_m70vrhssaf_un_m10_digital_desert_spec_at","rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_mgun_m84","rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_sniper_m76"];
		ZMM_GUER_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhssaf_faction_un" >> "rhssaf_group_un_ural" >> "rhssaf_group_un_ural_squad"];
		ZMM_GUER_Util = ["C_IDAP_Truck_02_water_F","C_IDAP_Van_02_medevac_F"];
		ZMM_GUER_Light = ["rhsgref_un_m1117"];
		ZMM_GUER_Medium = ["rhsgref_un_btr70"];
		ZMM_GUER_Heavy = [["rhsgref_cdf_bmd1","[_grpVeh,['MC',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_Air = ["rhsgref_un_Mi8amt"];
		ZMM_GUER_CasH = ["rhsgref_un_Mi24V"];
		ZMM_GUER_CasP = ["rhsgref_cdf_su25"];
		ZMM_GUER_Convoy = ["rhsgref_un_uaz","rhsgref_un_ural","rhsgref_un_btr70"];
		ZMM_GUER_Static = ["rhsgref_cdf_DSHKM"];
	};
	
	case 3: {
		// GUER - SAF (DIGITAL)
		ZMM_GUER_FactionName = "SAF (Digital)";
		ZMM_GUER_Flag = ["FlagCarrierINS", "\a3\Data_F_Enoch\Flags\flag_EAF_CO.paa"];
		ZMM_GUER_Man = ["rhssaf_army_m10_digital_rifleman_m21","rhssaf_army_m10_digital_rifleman_m70","rhssaf_army_m10_digital_sq_lead","rhssaf_army_m10_digital_rifleman_at","rhssaf_army_m10_digital_mgun_m84","rhssaf_army_m10_digital_spec_at","rhssaf_army_m10_digital_spec_aa","rhssaf_army_m10_digital_gl"];
		ZMM_GUER_Truck = ["rhsgref_cdf_zil131"];
		ZMM_GUER_Util = ["rhsgref_cdf_ural_fuel","rhsgref_cdf_ural_repair"];
		ZMM_GUER_Light = ["rhsgref_BRDM2","rhssaf_m1025_olive_m2","rhssaf_m1151_olive_pkm"];
		ZMM_GUER_Medium = ["rhsgref_ins_g_ural_Zu23",["rhsgref_ins_g_btr70","[_grpVeh, ['African',1]] call BIS_fnc_initVehicle;"],["rhsgref_ins_bmd1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_Heavy = ["rhsgref_ins_g_bmd2","rhsgref_ins_g_zsu234","rhsgref_cdf_t80uk_tv","rhsgref_cdf_t80b_tv"];
		ZMM_GUER_Air = ["rhssaf_airforce_ht40","rhssaf_airforce_ht48"];
		ZMM_GUER_CasH = ["rhsgref_cdf_Mi24D"];
		ZMM_GUER_CasP = ["rhsgref_cdf_su25"];
		ZMM_GUER_Convoy = ["rhsgref_BRDM2","rhsgref_cdf_zil131","rhsgref_ins_g_bmd2"];
		ZMM_GUER_Static = ["rhsgref_ins_g_DSHKM"];
	};	
	case 4: {
		// GUER - SAF (OAKLEAF)
		ZMM_GUER_FactionName = "SAF (Oakleaf)";
		ZMM_GUER_Flag = ["FlagCarrierINS", "\a3\Data_F_Enoch\Flags\flag_EAF_CO.paa"];
		ZMM_GUER_Man = ["rhssaf_army_m93_oakleaf_summer_sq_lead","rhssaf_army_m93_oakleaf_summer_rifleman_m21","rhssaf_army_m93_oakleaf_summer_rifleman_m70","rhssaf_army_m93_oakleaf_summer_spec_at","rhssaf_army_m93_oakleaf_summer_spec_aa","rhssaf_army_m93_oakleaf_summer_mgun_m84","rhssaf_army_m93_oakleaf_summer_gl"];
		ZMM_GUER_Truck = ["rhsgref_cdf_zil131"];
		ZMM_GUER_Util = ["rhsgref_cdf_ural_fuel","rhsgref_cdf_ural_repair"];
		ZMM_GUER_Light = ["rhsgref_BRDM2","rhssaf_m1025_olive_m2","rhssaf_m1151_olive_pkm"];
		ZMM_GUER_Medium = ["rhsgref_ins_g_ural_Zu23",["rhsgref_ins_g_btr70","[_grpVeh, ['Belarusian',1]] call BIS_fnc_initVehicle;"],["rhsgref_ins_bmd1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_Heavy = ["rhsgref_ins_g_bmd2","rhsgref_ins_g_zsu234","rhsgref_cdf_t80uk_tv","rhsgref_cdf_t80b_tv"];
		ZMM_GUER_Air = ["rhssaf_airforce_ht40","rhssaf_airforce_ht48"];
		ZMM_GUER_CasH = ["rhsgref_cdf_Mi24D"];
		ZMM_GUER_CasP = ["rhsgref_cdf_su25"];
		ZMM_GUER_Convoy = ["rhsgref_BRDM2","rhsgref_cdf_zil131","rhsgref_ins_g_bmd2"];
		ZMM_GUER_Static = ["rhsgref_ins_g_DSHKM"];
	};	
	case 5: {
		// GUER - TLA
		ZMM_GUER_FactionName = "TLA";
		ZMM_GUER_Flag = ["FlagCarrierINS", "\a3\Data_F_Enoch\Flags\flag_EAF_CO.paa"];
		ZMM_GUER_Man = ["rhsgref_tla_rifleman_M16","rhsgref_tla_specialist_at","rhsgref_tla_rifleman_M16","rhsgref_tla_grenadier","rhsgref_tla_rifleman_M16","rhsgref_tla_squadleader","rhsgref_tla_rifleman_M16","rhsgref_tla_rifleman_rpg75","rhsgref_tla_rifleman_M16","rhsgref_tla_machinegunner","rhsgref_tla_rifleman_M16","rhsgref_tla_machinegunner_mg42"];
		ZMM_GUER_Truck = ["rhsgref_tla_g_kraz255b1_cargo_open"];
		ZMM_GUER_Util = ["rhsgref_ins_g_kraz255b1_fuel","rhsgref_ins_g_gaz66_repair","rhsgref_ins_g_gaz66_ammo"];
		ZMM_GUER_Light = ["rhsgref_ins_g_uaz_spg9","rhsgref_ins_g_uaz_ags","rhsgref_ins_g_uaz_dshkm_chdkz","rhsgref_BRDM2_ins_g"];
		ZMM_GUER_Medium = ["rhsgref_ins_g_ural_Zu23","rhsgref_tla_g_btr60",["rhsgref_ins_bmd1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_Heavy = ["rhsgref_ins_g_bmd2","rhsgref_ins_g_zsu234","rhsgref_ins_g_t72ba","rhsgref_ins_g_t72bb"];
		ZMM_GUER_Air = ["rhsgref_ins_g_Mi8amt"];
		ZMM_GUER_CasH = [["rhsgref_cdf_reg_Mi17Sh","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_CasP = [["RHSGREF_A29B_HIDF","[_grpVeh,['Ecuador',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_Convoy = ["rhsgref_BRDM2_ins_g","rhsgref_tla_g_kraz255b1_cargo_open","rhsgref_ins_g_bmd2"];
		ZMM_GUER_Static = ["rhsgref_ins_g_DSHKM"];
	};
	case 6: {
		// GUER - CDF
		ZMM_GUER_FactionName = "CDF";
		ZMM_GUER_Flag = ["FlagCarrierCDF_EP1", "\ca\data\flag_Chernarus_co.paa"];
		ZMM_GUER_Man = ["rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_machinegunner","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier_rpg","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_specialist_aa"];
		ZMM_GUER_Truck = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_gaz66" >> "rhs_group_cdf_b_gaz66_squad", configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_ural" >> "rhs_group_cdf_b_ural_squad"];
		ZMM_GUER_Util = ["rhsgref_cdf_b_ural_fuel","rhsgref_cdf_b_ural_repair","rhsgref_cdf_b_gaz66_ammo"];
		ZMM_GUER_Light = ["rhsgref_cdf_b_reg_uaz_ags","rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz_spg9"];
		ZMM_GUER_Medium = ["rhsgref_cdf_b_btr70","rhsgref_cdf_b_bmp2k","rhsgref_cdf_b_bmd1k","rhsgref_cdf_b_bmd2k"];
		ZMM_GUER_Heavy = ["rhsgref_cdf_b_zsu234","rhsgref_cdf_b_t72bb_tv"];
		ZMM_GUER_Air = ["rhsgref_cdf_b_reg_Mi8amt","rhsgref_cdf_b_reg_Mi17Sh"];
		ZMM_GUER_CasH = ["rhsgref_cdf_b_Mi35"];
		ZMM_GUER_CasP = ["rhsgref_cdf_b_su25"];
		ZMM_GUER_Convoy = ["rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz","rhsgref_cdf_b_btr70"];
		ZMM_GUER_Static = ["rhsgref_cdf_b_DSHKM"];
	};
	default {
		// GUER - ChDKZ
		ZMM_GUER_FactionName = "ChDKz";
		ZMM_GUER_Flag = ["FlagCarrierINS", "\a3\Data_F_Enoch\Flags\flag_EAF_CO.paa"];
		ZMM_GUER_Man = ["rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_grenadier_rpg","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_rifleman_RPG26","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_grenadier","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_machinegunner","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_saboteur","rhsgref_ins_g_rifleman_aks74"];
		ZMM_GUER_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhs_group_indp_ins_g_ural" >> "rhs_group_chdkz_ural_squad"];
		ZMM_GUER_Util = ["rhsgref_ins_g_ural_repair","rhsgref_ins_g_gaz66_ammo"];
		ZMM_GUER_Light = ["rhsgref_ins_g_uaz_spg9","rhsgref_ins_g_uaz_ags","rhsgref_ins_g_uaz_dshkm_chdkz","rhsgref_BRDM2_ins_g"];
		ZMM_GUER_Medium = ["rhsgref_ins_g_ural_Zu23","rhsgref_ins_g_btr70","rhsgref_ins_g_bmp2k","rhsgref_ins_g_bmp1k","rhsgref_ins_g_bmd1"];
		ZMM_GUER_Heavy = ["rhsgref_ins_g_bmd2","rhsgref_ins_g_zsu234","rhsgref_ins_g_t72ba","rhsgref_ins_g_t72bb"];
		ZMM_GUER_Air = ["rhsgref_ins_g_Mi8amt"];
		ZMM_GUER_CasH = [["rhsgref_cdf_reg_Mi17Sh","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_CasP = [["RHSGREF_A29B_HIDF","[_grpVeh,['Ecuador',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_Convoy = ["rhsgref_BRDM2_ins_g","rhsgref_ins_g_ural","rhsgref_ins_g_bmd2"];
		ZMM_GUER_Static = ["rhsgref_ins_g_DSHKM"];
	};
};