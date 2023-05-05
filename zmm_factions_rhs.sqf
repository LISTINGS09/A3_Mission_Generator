// Choose West Faction
switch (missionNamespace getVariable ["f_param_factionWest",-1]) do {
	case 1: {
		// WEST - US ARMY D
		ZMM_WESTFlag = ["FlagCarrierUSA", "\ca\data\flag_usa_co.paa"];
		ZMM_WESTMan = ["rhsusf_army_ocp_rifleman","rhsusf_army_ocp_machinegunner","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_grenadier","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_riflemanat","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_squadleader","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_aa","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_maaws"];
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
	case 2: {
		// WEST - CDF
		ZMM_WESTFlag = ["FlagCarrierCDF_EP1", "\ca\data\flag_Chernarus_co.paa"];
		ZMM_WESTMan = ["rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_machinegunner","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier_rpg","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_specialist_aa"];
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
		ZMM_WESTMan = ["rhsgref_hidf_rifleman","rhsgref_hidf_grenadier","rhsgref_hidf_rifleman","rhsgref_hidf_squadleader","rhsgref_hidf_grenadier_m79","rhsgref_hidf_rifleman","rhsgref_hidf_autorifleman"];
		ZMM_WESTVeh_Truck = ["rhsgref_hidf_m998_4dr"];
		ZMM_WESTVeh_Util = ["rhsusf_M977A4_AMMO_usarmy_wd","rhsusf_M977A4_REPAIR_usarmy_wd","rhsusf_M978A4_usarmy_wd"];
		ZMM_WESTVeh_Light = ["rhsgref_hidf_m1025_m2","rhsgref_hidf_m1025_mk19"];
		ZMM_WESTVeh_Medium = ["rhsgref_hidf_m113a3_m2","rhsgref_hidf_m113a3_mk19"];
		ZMM_WESTVeh_Heavy = ["RHS_M2A3_wd","RHS_M6_wd","rhsusf_m1a1aimwd_usarmy"];
		ZMM_WESTVeh_Air = ["rhs_uh1h_hidf"];
		ZMM_WESTVeh_CasH = ["rhs_uh1h_hidf_gunship"];
		ZMM_WESTVeh_CasP = ["RHSGREF_A29B_HIDF"];
		ZMM_WESTVeh_Convoy = ["rhsgref_hidf_m1025_m2","rhsgref_hidf_m1025","rhsgref_hidf_m113a3_m2"];
		ZMM_WESTVeh_Static = ["rhsgref_hidf_m2_static"];
	};
	default {
		// WEST - US ARMY W
		ZMM_WESTFlag = ["FlagCarrierUSA", "\ca\data\flag_usa_co.paa"];
		ZMM_WESTMan = ["rhsusf_army_ucp_rifleman","rhsusf_army_ucp_machinegunner","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_grenadier","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_riflemanat","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_squadleader","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_maaws","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_aa"];
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
};

// Choose East Faction
switch (missionNamespace getVariable ["f_param_factionEast",-1]) do {
	case 1: {
		// EAST - RU DESERT MFLORA
		ZMM_EASTFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EASTMan = ["rhs_vdv_mflora_rifleman","rhs_vdv_mflora_sergeant","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_aa","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_at","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_RShG2","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_grenadier","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_LAT","rhs_vdv_mflora_rifleman","rhs_vdv_mflora_machinegunner"];
		ZMM_EASTVeh_Truck = [["RHS_Ural_MSV_01","[_grpVeh,['rhs_sand',1],true] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = [["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Medium = [["rhs_bmd1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_bmp1_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["rhs_t90_tv","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"],["rhs_zsu234_aa","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"],["rhs_bmd2k","[_grpVeh,['Desert',1]] call BIS_fnc_initVehicle;"],["rhs_bmp2d_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = ["rhs_ka60_grey","RHS_Mi8T_vvs","RHS_Mi8mt_vvs"];
		ZMM_EASTVeh_CasH = ["RHS_Ka52_vvs","RHS_Mi24V_vvs"];
		ZMM_EASTVeh_CasP = ["RHS_Su25SM_vvs"];
		ZMM_EASTVeh_Convoy = ["rhs_tigr_sts_3camo_vdv",["RHS_Ural_Zu23_VDV_01","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Static = ["rhs_KORD_high_MSV","rhs_Kornet_9M133_2_msv","rhsgref_ins_DSHKM"];
	};
	case 2: {
		// EAST - RU DESERT EMR
		ZMM_EASTFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EASTMan = ["rhs_vdv_des_rifleman","rhs_vdv_des_sergeant","rhs_vdv_des_rifleman","rhs_vdv_des_aa","rhs_vdv_des_rifleman","rhs_vdv_des_at","rhs_vdv_des_rifleman","rhs_vdv_des_RShG2","rhs_vdv_des_rifleman","rhs_vdv_des_grenadier","rhs_vdv_des_rifleman","rhs_vdv_des_LAT","rhs_vdv_des_rifleman","rhs_vdv_des_machinegunner"];
		ZMM_EASTVeh_Truck = [["RHS_Ural_MSV_01","[_grpVeh,['rhs_sand',1],true] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = [["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Medium = [["rhs_bmd1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_bmp1_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["rhs_t90_tv","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"],["rhs_zsu234_aa","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"],["rhs_bmd2k","[_grpVeh,['Desert',1]] call BIS_fnc_initVehicle;"],["rhs_bmp2d_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = ["rhs_ka60_grey","RHS_Mi8T_vvs","RHS_Mi8mt_vvs"];
		ZMM_EASTVeh_CasH = ["RHS_Ka52_vvs","RHS_Mi24V_vvs"];
		ZMM_EASTVeh_CasP = ["RHS_Su25SM_vvs"];
		ZMM_EASTVeh_Convoy = ["rhs_tigr_sts_3camo_vdv",["RHS_Ural_Zu23_VDV_01","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Static = ["rhs_KORD_high_MSV","rhs_Kornet_9M133_2_msv","rhsgref_ins_DSHKM"];
	};
	case 3: {
		// EAST - RU MSV FLORA
		ZMM_EASTFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EASTMan = ["rhs_msv_rifleman","rhs_msv_aa","rhs_msv_rifleman","rhs_msv_at","rhs_msv_rifleman","rhs_msv_machinegunner","rhs_msv_rifleman","rhs_msv_RShG2","rhs_msv_rifleman","rhs_msv_grenadier","rhs_msv_rifleman","rhs_msv_sergeant","rhs_msv_rifleman","rhs_msv_LAT"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_Ural" >> "rhs_group_rus_msv_Ural_squad", configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_gaz66" >> "rhs_group_rus_msv_gaz66_squad"];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = ["rhs_tigr_sts_msv","rhsgref_nat_uaz_dshkm","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9"];
		ZMM_EASTVeh_Medium = ["rhs_btr80a_msv","rhs_btr70_msv","rhs_btr80_msv"];
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
		ZMM_EASTMan = ["O_Taki_soldier_R_AK74M_F","O_Taki_soldier_G_AK74M_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_RSG_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_R26_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_SL_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_MG_F","O_Taki_soldier_R_AK74M_F","O_Taki_soldier_G_RPG_F","O_Taki_soldier_R_AK74M_F"];
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
		// EAST - RU EMR DESERT
		ZMM_EASTFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EASTMan = ["rhs_vdv_des_rifleman","rhs_vdv_des_sergeant","rhs_vdv_des_rifleman","rhs_vdv_des_aa","rhs_vdv_des_rifleman","rhs_vdv_des_at","rhs_vdv_des_rifleman","rhs_vdv_des_RShG2","rhs_vdv_des_rifleman","rhs_vdv_des_grenadier","rhs_vdv_des_rifleman","rhs_vdv_des_LAT","rhs_vdv_des_rifleman","rhs_vdv_des_machinegunner"];
		ZMM_EASTVeh_Truck = ["rhs_gaz66_msv"];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = ["Taki_UAZ_ags30_F","Taki_UAZ_dshkm_F","Taki_UAZ_spg9_F",["rhs_btr70_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Medium = [["rhs_btr80a_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_bmd2k","[_grpVeh,['Desert',1]] call BIS_fnc_initVehicle;"],["rhs_bmp1_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["rhs_bmp3m_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_bmp2d_tv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_t90_tv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhsgref_ins_zsu234","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhssaf_army_t72s","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = ["rhs_ka60_c","RHS_Mi8mt_vvsc","RHS_Mi8T_vvsc"];
		ZMM_EASTVeh_CasH = ["RHS_Ka52_vvsc","RHS_Mi24V_vvsc"];
		ZMM_EASTVeh_CasP = ["RHS_Su25SM_vvsc"];
		ZMM_EASTVeh_Convoy = [["rhs_t90_tv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_btr80a_msv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_t90_tv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Static = ["rhs_KORD_high_MSV","rhsgref_ins_DSHKM"];
	};
	case 6: {
		// EAST - ChDKZ
		ZMM_EASTFlag = ["FlagCarrierINS", "\a3\Data_F_Enoch\Flags\flag_EAF_CO.paa"];
		ZMM_EASTMan = ["rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_grenadier_rpg","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_rifleman_RPG26","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_grenadier","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_machinegunner","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_saboteur","rhsgref_ins_g_rifleman_aks74"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhs_group_indp_ins_g_ural" >> "rhs_group_chdkz_ural_squad"];
		ZMM_EASTVeh_Util = ["rhsgref_ins_ural_repair","rhsgref_ins_gaz66_ammo"];
		ZMM_EASTVeh_Light = ["rhsgref_ins_uaz_spg9","rhsgref_ins_uaz_ags","rhsgref_ins_uaz_dshkm_chdkz","rhsgref_BRDM2_ins"];
		ZMM_EASTVeh_Medium = ["rhsgref_ins_ural_Zu23","rhsgref_ins_btr70","rhsgref_ins_bmp2k","rhsgref_ins_bmp1k","rhsgref_ins_bmd1"];
		ZMM_EASTVeh_Heavy = ["rhsgref_ins_bmd2","rhsgref_ins_zsu234","rhsgref_ins_t72ba","rhsgref_ins_t72bb"];
		ZMM_EASTVeh_Air = ["rhsgref_ins_Mi8amt"];
		ZMM_EASTVeh_CasH = [["rhsgref_cdf_reg_Mi17Sh","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_CasP = [["RHSGREF_A29B_HIDF","[_grpVeh,['Ecuador',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Convoy = ["rhsgref_BRDM2_ins","rhsgref_ins_ural","rhsgref_ins_bmd2"];
		ZMM_EASTVeh_Static = ["rhsgref_ins_DSHKM"];
	};	
	default {
		// EAST - RU MSV EMR
		ZMM_EASTFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EASTMan = ["rhs_msv_emr_rifleman","rhs_msv_emr_aa","rhs_msv_emr_rifleman","rhs_msv_emr_at","rhs_msv_emr_rifleman","rhs_msv_emr_machinegunner","rhs_msv_emr_rifleman","rhs_msv_emr_RShG2","rhs_msv_emr_rifleman","rhs_msv_emr_grenadier","rhs_msv_emr_rifleman","rhs_msv_emr_sergeant","rhs_msv_emr_rifleman","rhs_msv_emr_LAT"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_Ural" >> "rhs_group_rus_msv_Ural_squad", configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_gaz66" >> "rhs_group_rus_msv_gaz66_squad"];
		ZMM_EASTVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_EASTVeh_Light = ["rhs_tigr_sts_msv","rhsgref_nat_uaz_dshkm","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9"];
		ZMM_EASTVeh_Medium = ["rhs_btr80a_msv","rhs_btr70_msv","rhs_btr80_msv"];
		ZMM_EASTVeh_Heavy = ["rhs_bmp1_msv","rhs_bmp2e_msv","rhs_bmp3_msv"];
		ZMM_EASTVeh_Air = ["rhs_ka60_c","RHS_Mi8mt_vvsc","RHS_Mi8T_vvsc"];
		ZMM_EASTVeh_CasH = ["RHS_Ka52_vvsc","RHS_Mi24V_vvsc"];
		ZMM_EASTVeh_CasP = ["RHS_Su25SM_vvsc"];
		ZMM_EASTVeh_Convoy = ["rhs_tigr_sts_msv","rhs_btr80_msv","rhs_btr80_msv"];
		ZMM_EASTVeh_Static = ["rhs_KORD_high_MSV","rhs_Kornet_9M133_2_msv","rhsgref_ins_DSHKM"];
	};
};

// Choose Guer Faction
switch (missionNamespace getVariable ["f_param_factionGuer",-1]) do {
	case 1: {
		// GUER - NAPA
		ZMM_GUERFlag = ["Flag_Enoch_F", "\a3\Data_F_Enoch\Flags\flag_Enoch_CO.paa"];
		ZMM_GUERMan = ["rhsgref_nat_rifleman","rhsgref_nat_rifleman","rhsgref_nat_grenadier_rpg","rhsgref_nat_rifleman","rhsgref_nat_machinegunner","rhsgref_nat_rifleman","rhsgref_nat_grenadier","rhsgref_nat_rifleman_mp44rhsgref_nat_scout","rhsgref_nat_rifleman","rhsgref_nat_commander"];
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
	case 2: {
		// GUER - UN
		ZMM_GUERFlag = ["Flag_Enoch_F", "\a3\Data_F_Enoch\Flags\flag_Enoch_CO.paa"];
		ZMM_GUERMan = ["rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_rifleman_at","rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_sq_lead","rhssaf_un_m10_digital_desert_rifleman_m70vrhssaf_un_m10_digital_desert_spec_at","rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_mgun_m84","rhssaf_un_m10_digital_desert_rifleman_m70","rhssaf_un_m10_digital_desert_sniper_m76"];
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
	
	case 3: {
		// GUER - SAF (DIGITAL)
		ZMM_GUERFlag = ["FlagCarrierINS", "\a3\Data_F_Enoch\Flags\flag_EAF_CO.paa"];
		ZMM_GUERMan = ["rhssaf_army_m10_digital_rifleman_m21","rhssaf_army_m10_digital_rifleman_m70","rhssaf_army_m10_digital_sq_lead","rhssaf_army_m10_digital_rifleman_at","rhssaf_army_m10_digital_mgun_m84","rhssaf_army_m10_digital_spec_at","rhssaf_army_m10_digital_spec_aa","rhssaf_army_m10_digital_gl"];
		ZMM_GUERVeh_Truck = ["rhsgref_cdf_zil131"];
		ZMM_GUERVeh_Util = ["rhsgref_cdf_ural_fuel","rhsgref_cdf_ural_repair"];
		ZMM_GUERVeh_Light = ["rhsgref_BRDM2","rhssaf_m1025_olive_m2","rhssaf_m1151_olive_pkm"];
		ZMM_GUERVeh_Medium = ["rhsgref_ins_g_ural_Zu23",["rhsgref_ins_g_btr70","[_grpVeh, ['African',1]] call BIS_fnc_initVehicle;"],["rhsgref_ins_bmd1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Heavy = ["rhsgref_ins_g_bmd2","rhsgref_ins_g_zsu234","rhsgref_cdf_t80uk_tv","rhsgref_cdf_t80b_tv"];
		ZMM_GUERVeh_Air = ["rhssaf_airforce_ht40","rhssaf_airforce_ht48"];
		ZMM_GUERVeh_CasH = ["rhsgref_cdf_Mi24D"];
		ZMM_GUERVeh_CasP = ["rhsgref_cdf_su25"];
		ZMM_GUERVeh_Convoy = ["rhsgref_BRDM2","rhsgref_cdf_zil131","rhsgref_ins_g_bmd2"];
		ZMM_GUERVeh_Static = ["rhsgref_ins_g_DSHKM"];
	};	
	case 4: {
		// GUER - SAF (OAKLEAF)
		ZMM_GUERFlag = ["FlagCarrierINS", "\a3\Data_F_Enoch\Flags\flag_EAF_CO.paa"];
		ZMM_GUERMan = ["rhssaf_army_m93_oakleaf_summer_sq_lead","rhssaf_army_m93_oakleaf_summer_rifleman_m21","rhssaf_army_m93_oakleaf_summer_rifleman_m70","rhssaf_army_m93_oakleaf_summer_spec_at","rhssaf_army_m93_oakleaf_summer_spec_aa","rhssaf_army_m93_oakleaf_summer_mgun_m84","rhssaf_army_m93_oakleaf_summer_gl"];
		ZMM_GUERVeh_Truck = ["rhsgref_cdf_zil131"];
		ZMM_GUERVeh_Util = ["rhsgref_cdf_ural_fuel","rhsgref_cdf_ural_repair"];
		ZMM_GUERVeh_Light = ["rhsgref_BRDM2","rhssaf_m1025_olive_m2","rhssaf_m1151_olive_pkm"];
		ZMM_GUERVeh_Medium = ["rhsgref_ins_g_ural_Zu23",["rhsgref_ins_g_btr70","[_grpVeh, ['Belarusian',1]] call BIS_fnc_initVehicle;"],["rhsgref_ins_bmd1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Heavy = ["rhsgref_ins_g_bmd2","rhsgref_ins_g_zsu234","rhsgref_cdf_t80uk_tv","rhsgref_cdf_t80b_tv"];
		ZMM_GUERVeh_Air = ["rhssaf_airforce_ht40","rhssaf_airforce_ht48"];
		ZMM_GUERVeh_CasH = ["rhsgref_cdf_Mi24D"];
		ZMM_GUERVeh_CasP = ["rhsgref_cdf_su25"];
		ZMM_GUERVeh_Convoy = ["rhsgref_BRDM2","rhsgref_cdf_zil131","rhsgref_ins_g_bmd2"];
		ZMM_GUERVeh_Static = ["rhsgref_ins_g_DSHKM"];
	};	
	case 5: {
		// GUER - TLA
		ZMM_GUERFlag = ["FlagCarrierINS", "\a3\Data_F_Enoch\Flags\flag_EAF_CO.paa"];
		ZMM_GUERMan = ["rhsgref_tla_rifleman_M16","rhsgref_tla_specialist_at","rhsgref_tla_rifleman_M16","rhsgref_tla_grenadier","rhsgref_tla_rifleman_M16","rhsgref_tla_squadleader","rhsgref_tla_rifleman_M16","rhsgref_tla_rifleman_rpg75","rhsgref_tla_rifleman_M16","rhsgref_tla_machinegunner","rhsgref_tla_rifleman_M16","rhsgref_tla_machinegunner_mg42"];
		ZMM_GUERVeh_Truck = ["rhsgref_tla_g_kraz255b1_cargo_open"];
		ZMM_GUERVeh_Util = ["rhsgref_ins_g_kraz255b1_fuel","rhsgref_ins_g_gaz66_repair","rhsgref_ins_g_gaz66_ammo"];
		ZMM_GUERVeh_Light = ["rhsgref_ins_g_uaz_spg9","rhsgref_ins_g_uaz_ags","rhsgref_ins_g_uaz_dshkm_chdkz","rhsgref_BRDM2_ins_g"];
		ZMM_GUERVeh_Medium = ["rhsgref_ins_g_ural_Zu23","rhsgref_tla_g_btr60",["rhsgref_ins_bmd1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Heavy = ["rhsgref_ins_g_bmd2","rhsgref_ins_g_zsu234","rhsgref_ins_g_t72ba","rhsgref_ins_g_t72bb"];
		ZMM_GUERVeh_Air = ["rhsgref_ins_g_Mi8amt"];
		ZMM_GUERVeh_CasH = [["rhsgref_cdf_reg_Mi17Sh","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_CasP = [["RHSGREF_A29B_HIDF","[_grpVeh,['Ecuador',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Convoy = ["rhsgref_BRDM2_ins_g","rhsgref_tla_g_kraz255b1_cargo_open","rhsgref_ins_g_bmd2"];
		ZMM_GUERVeh_Static = ["rhsgref_ins_g_DSHKM"];
	};
	case 6: {
		// GUER - CDF
		ZMM_GUERFlag = ["FlagCarrierCDF_EP1", "\ca\data\flag_Chernarus_co.paa"];
		ZMM_GUERMan = ["rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_machinegunner","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier_rpg","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_specialist_aa"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_gaz66" >> "rhs_group_cdf_b_gaz66_squad", configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_ural" >> "rhs_group_cdf_b_ural_squad"];
		ZMM_GUERVeh_Util = ["rhsgref_cdf_b_ural_fuel","rhsgref_cdf_b_ural_repair","rhsgref_cdf_b_gaz66_ammo"];
		ZMM_GUERVeh_Light = ["rhsgref_cdf_b_reg_uaz_ags","rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz_spg9"];
		ZMM_GUERVeh_Medium = ["rhsgref_cdf_b_btr70","rhsgref_cdf_b_bmp2k","rhsgref_cdf_b_bmd1k","rhsgref_cdf_b_bmd2k"];
		ZMM_GUERVeh_Heavy = ["rhsgref_cdf_b_zsu234","rhsgref_cdf_b_t72bb_tv"];
		ZMM_GUERVeh_Air = ["rhsgref_cdf_b_reg_Mi8amt","rhsgref_cdf_b_reg_Mi17Sh"];
		ZMM_GUERVeh_CasH = ["rhsgref_cdf_b_Mi35"];
		ZMM_GUERVeh_CasP = ["rhsgref_cdf_b_su25"];
		ZMM_GUERVeh_Convoy = ["rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz","rhsgref_cdf_b_btr70"];
		ZMM_GUERVeh_Static = ["rhsgref_cdf_b_DSHKM"];
	};
	default {
		// GUER - ChDKZ
		ZMM_GUERFlag = ["FlagCarrierINS", "\a3\Data_F_Enoch\Flags\flag_EAF_CO.paa"];
		ZMM_GUERMan = ["rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_grenadier_rpg","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_rifleman_RPG26","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_grenadier","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_machinegunner","rhsgref_ins_g_rifleman_aks74","rhsgref_ins_g_saboteur","rhsgref_ins_g_rifleman_aks74"];
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
};