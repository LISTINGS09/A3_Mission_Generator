// Choose West Faction
switch (missionNamespace getVariable ["f_param_factionWest",-1]) do {
	case 2: {
		// WEST - CSF
		ZMM_WESTFactionName = "US CSF";
		ZMM_WESTFlag = ["vn_flag_usa", "\vn\objects_f_vietnam\flags\data\vn_flag_01_usa_co.paa"];
		ZMM_WESTMan = ["vn_b_men_cidg_06","vn_b_men_cidg_14","vn_b_men_cidg_01","vn_b_men_cidg_05","vn_b_men_cidg_07","vn_b_men_cidg_04","vn_b_men_cidg_12"];
		ZMM_WESTVeh_Truck = ["vn_b_wheeled_m54_01"];
		ZMM_WESTVeh_Util = ["vn_b_wheeled_m54_ammo","vn_b_wheeled_m54_fuel","vn_b_wheeled_m54_repair"];
		ZMM_WESTVeh_Light = ["vn_b_wheeled_m151_mg_04","vn_b_wheeled_m151_mg_02","vn_b_wheeled_m151_mg_03","vn_b_wheeled_m151_mg_05"];
		ZMM_WESTVeh_Medium = ["vn_b_wheeled_m54_mg_01","vn_b_wheeled_m54_mg_03","vn_b_wheeled_m54_mg_02"];
		ZMM_WESTVeh_Heavy = ["vn_b_armor_m41_01_01"];
		ZMM_WESTVeh_Air = ["vn_b_air_uh1d_01_04","vn_b_air_uh1d_02_04"];
		ZMM_WESTVeh_CasH = ["vn_b_air_ah1g_07_usmc"];
		ZMM_WESTVeh_CasP = ["vn_b_air_f4b_usmc_ucas","vn_b_air_f4b_usmc_mbmb"];
		ZMM_WESTVeh_Convoy = ["vn_b_wheeled_m54_mg_03","vn_b_wheeled_m54_02","vn_b_wheeled_m54_mg_01"];
		ZMM_WESTVeh_Static = ["vn_b_army_static_m1919a4_high","vn_b_army_static_m2_high","vn_b_army_static_m60_high"];
	};
	case 3: {
		// WEST - MACV
		ZMM_WESTFactionName = "US MCAV";
		ZMM_WESTFlag = ["vn_flag_usa", "\vn\objects_f_vietnam\flags\data\vn_flag_01_usa_co.paa"];
		ZMM_WESTMan = ["vn_b_men_seal_43","vn_b_men_seal_51","vn_b_men_seal_24","vn_b_men_seal_45","vn_b_men_seal_23","vn_b_men_sog_07","vn_b_men_sog_19","vn_b_men_sog_17"];
		ZMM_WESTVeh_Truck = ["vn_b_wheeled_m54_01"];
		ZMM_WESTVeh_Util = ["vn_b_wheeled_m54_ammo","vn_b_wheeled_m54_fuel","vn_b_wheeled_m54_repair"];
		ZMM_WESTVeh_Light = ["vn_b_wheeled_m151_mg_04","vn_b_wheeled_m151_mg_02","vn_b_wheeled_m151_mg_03","vn_b_wheeled_m151_mg_05"];
		ZMM_WESTVeh_Medium = ["vn_b_wheeled_m54_mg_01","vn_b_wheeled_m54_mg_03","vn_b_wheeled_m54_mg_02"];
		ZMM_WESTVeh_Heavy = ["vn_b_armor_m41_01_01"];
		ZMM_WESTVeh_Air = ["vn_b_air_uh1d_01_04","vn_b_air_uh1d_02_04"];
		ZMM_WESTVeh_CasH = ["vn_b_air_ah1g_07_usmc"];
		ZMM_WESTVeh_CasP = ["vn_b_air_f4b_usmc_ucas","vn_b_air_f4b_usmc_mbmb"];
		ZMM_WESTVeh_Convoy = ["vn_b_wheeled_m54_mg_03","vn_b_wheeled_m54_02","vn_b_wheeled_m54_mg_01"];
		ZMM_WESTVeh_Static = ["vn_b_army_static_m1919a4_high","vn_b_army_static_m2_high","vn_b_army_static_m60_high"];
	};
	case 4: {
		// WEST - SEAL
		ZMM_WESTFactionName = "US Seal";
		ZMM_WESTFlag = ["vn_flag_usa", "\vn\objects_f_vietnam\flags\data\vn_flag_01_usa_co.paa"];
		ZMM_WESTMan = ["vn_b_men_seal_01","vn_b_men_seal_16","vn_b_men_seal_12","vn_b_men_seal_03","vn_b_men_seal_15","vn_b_men_seal_02"];
		ZMM_WESTVeh_Truck = ["vn_b_wheeled_m54_01"];
		ZMM_WESTVeh_Util = ["vn_b_wheeled_m54_ammo","vn_b_wheeled_m54_fuel","vn_b_wheeled_m54_repair"];
		ZMM_WESTVeh_Light = ["vn_b_wheeled_m151_mg_04","vn_b_wheeled_m151_mg_02","vn_b_wheeled_m151_mg_03","vn_b_wheeled_m151_mg_05"];
		ZMM_WESTVeh_Medium = ["vn_b_wheeled_m54_mg_01","vn_b_wheeled_m54_mg_03","vn_b_wheeled_m54_mg_02"];
		ZMM_WESTVeh_Heavy = ["vn_b_armor_m41_01_01"];
		ZMM_WESTVeh_Air = ["vn_b_air_uh1d_01_04","vn_b_air_uh1d_02_04"];
		ZMM_WESTVeh_CasH = ["vn_b_air_ah1g_07_usmc"];
		ZMM_WESTVeh_CasP = ["vn_b_air_f4b_usmc_ucas","vn_b_air_f4b_usmc_mbmb"];
		ZMM_WESTVeh_Convoy = ["vn_b_wheeled_m54_mg_03","vn_b_wheeled_m54_02","vn_b_wheeled_m54_mg_01"];
		ZMM_WESTVeh_Static = ["vn_b_army_static_m1919a4_high","vn_b_army_static_m2_high","vn_b_army_static_m60_high"];
	};
	default {
		// WEST - US ARMY
		ZMM_WESTFactionName = "US Army";
		ZMM_WESTFlag = ["vn_flag_usa", "\vn\objects_f_vietnam\flags\data\vn_flag_01_usa_co.paa"];
		ZMM_WESTMan = ["vn_b_men_army_12","vn_b_men_army_05","vn_b_men_army_04","vn_b_men_army_07","vn_b_men_army_06","vn_b_men_army_10","vn_b_men_army_03","vn_b_men_army_15","vn_b_men_army_16","vn_b_men_army_18","vn_b_men_army_19","vn_b_men_army_20","vn_b_men_army_21"];
		ZMM_WESTVeh_Truck = ["vn_b_wheeled_m54_02"];
		ZMM_WESTVeh_Util = ["vn_b_wheeled_m54_repair","vn_b_wheeled_m54_fuel","vn_b_wheeled_m54_ammo"];
		ZMM_WESTVeh_Light = ["vn_b_wheeled_m151_mg_04","vn_b_wheeled_m151_mg_02","vn_b_wheeled_m151_mg_03"];
		ZMM_WESTVeh_Medium = ["vn_b_wheeled_m54_mg_01","vn_b_wheeled_m54_mg_03","vn_b_wheeled_m54_mg_02"];
		ZMM_WESTVeh_Heavy = ["vn_b_armor_m41_01_01"];
		ZMM_WESTVeh_Air = ["vn_b_air_uh1d_01_04","vn_b_air_uh1d_02_04"];
		ZMM_WESTVeh_CasH = ["vn_b_air_ah1g_07_usmc"];
		ZMM_WESTVeh_CasP = ["vn_b_air_f4b_usmc_ucas","vn_b_air_f4b_usmc_mbmb"];
		ZMM_WESTVeh_Convoy = ["vn_b_wheeled_m54_mg_03","vn_b_wheeled_m54_02","vn_b_wheeled_m54_mg_01"];
		ZMM_WESTVeh_Static = ["vn_b_army_static_m1919a4_high","vn_b_army_static_m2_high","vn_b_army_static_m60_high"];
	};
};

// Choose East Faction
switch (missionNamespace getVariable ["f_param_factionEast",-1]) do {
	case 1: {
		// EAST - PAVN 68
		ZMM_EASTFactionName = "PAVN 68";
		ZMM_EASTFlag = ["vn_flag_pavn", "\vn\objects_f_vietnam\flags\data\vn_flag_01_pavn_co.paa"];
		ZMM_EASTMan = ["vn_o_men_nva_06","vn_o_men_nva_03","vn_o_men_nva_11","vn_o_men_nva_07","vn_o_men_nva_14","vn_o_men_nva_04"];
		ZMM_EASTVeh_Truck = ["vn_o_wheeled_z157_01"];
		ZMM_EASTVeh_Util = ["vn_o_wheeled_z157_ammo","vn_o_wheeled_z157_repair","vn_o_wheeled_z157_fuel"];
		ZMM_EASTVeh_Light = ["vn_o_wheeled_z157_mg_01","vn_o_wheeled_btr40_mg_02","vn_o_wheeled_z157_mg_01"];
		ZMM_EASTVeh_Medium = ["vn_o_wheeled_z157_mg_02","vn_o_wheeled_btr40_mg_06","vn_o_wheeled_btr40_mg_03","vn_o_wheeled_btr40_mg_04","vn_o_armor_btr50pk_02"];
		ZMM_EASTVeh_Heavy = ["vn_o_armor_type63_01","vn_o_armor_t54b_01","vn_o_armor_pt76b_01"];
		ZMM_EASTVeh_Air = ["vn_o_air_mi2_01_01","vn_o_air_mi2_01_03"];
		ZMM_EASTVeh_CasH = ["vn_o_air_mi2_03_04","vn_o_air_mi2_04_03"];
		ZMM_EASTVeh_CasP = ["vn_o_air_mig19_cas","vn_o_air_mig19_mr"];
		ZMM_EASTVeh_Convoy = ["vn_o_wheeled_btr40_mg_02","vn_o_wheeled_btr40_01","vn_o_wheeled_btr40_mg_03"];
		ZMM_EASTVeh_Static = ["vn_o_nva_65_static_dshkm_high_01","vn_o_nva_65_static_pk_high","vn_o_nva_65_static_rpd_high"];
	};
	case 2: {
		// EAST - DAC CONG
		ZMM_EASTFactionName = "DAC Cong";
		ZMM_EASTFlag = ["vn_flag_pavn", "\vn\objects_f_vietnam\flags\data\vn_flag_01_pavn_co.paa"];
		ZMM_EASTMan = ["vn_o_men_nva_dc_14","vn_o_men_nva_dc_07","vn_o_men_nva_dc_11","vn_o_men_nva_dc_10","vn_o_men_nva_dc_08","vn_o_men_nva_dc_06","vn_o_men_nva_dc_05","vn_o_men_nva_dc_12"];
		ZMM_EASTVeh_Truck = ["vn_o_wheeled_z157_01"];
		ZMM_EASTVeh_Util = ["vn_o_wheeled_z157_ammo","vn_o_wheeled_z157_repair","vn_o_wheeled_z157_fuel"];
		ZMM_EASTVeh_Light = ["vn_o_wheeled_z157_mg_01","vn_o_wheeled_btr40_mg_02","vn_o_wheeled_z157_mg_01"];
		ZMM_EASTVeh_Medium = ["vn_o_wheeled_z157_mg_02","vn_o_wheeled_btr40_mg_06","vn_o_wheeled_btr40_mg_03","vn_o_wheeled_btr40_mg_04","vn_o_armor_btr50pk_02"];
		ZMM_EASTVeh_Heavy = ["vn_o_armor_type63_01","vn_o_armor_t54b_01","vn_o_armor_pt76b_01"];
		ZMM_EASTVeh_Air = ["vn_o_air_mi2_01_01","vn_o_air_mi2_01_03"];
		ZMM_EASTVeh_CasH = ["vn_o_air_mi2_03_04","vn_o_air_mi2_04_03"];
		ZMM_EASTVeh_CasP = ["vn_o_air_mig19_cas","vn_o_air_mig19_mr"];
		ZMM_EASTVeh_Convoy = ["vn_o_wheeled_btr40_mg_02","vn_o_wheeled_btr40_01","vn_o_wheeled_btr40_mg_03"];
		ZMM_EASTVeh_Static = ["vn_o_nva_65_static_dshkm_high_01","vn_o_nva_65_static_pk_high","vn_o_nva_65_static_rpd_high"];
	};
	case 3: {
		// EAST - VIET CONG
		ZMM_EASTFactionName = "Viet Cong";
		ZMM_EASTFlag = ["vn_flag_pavn", "\vn\objects_f_vietnam\flags\data\vn_flag_01_pavn_co.paa"];
		ZMM_EASTMan = ["vn_o_men_vc_local_08","vn_o_men_vc_local_07","vn_o_men_vc_local_28","vn_o_men_vc_local_05","vn_o_men_vc_local_23","vn_o_men_vc_local_18","vn_o_men_vc_local_06","vn_o_men_vc_local_02"];
		ZMM_EASTVeh_Truck = ["vn_o_wheeled_z157_01"];
		ZMM_EASTVeh_Util = ["vn_o_wheeled_z157_ammo","vn_o_wheeled_z157_repair","vn_o_wheeled_z157_fuel"];
		ZMM_EASTVeh_Light = ["vn_o_wheeled_z157_mg_01","vn_o_wheeled_btr40_mg_02","vn_o_wheeled_z157_mg_01"];
		ZMM_EASTVeh_Medium = ["vn_o_wheeled_z157_mg_02","vn_o_wheeled_btr40_mg_06","vn_o_wheeled_btr40_mg_03","vn_o_wheeled_btr40_mg_04","vn_o_armor_btr50pk_02"];
		ZMM_EASTVeh_Heavy = ["vn_o_armor_type63_01","vn_o_armor_t54b_01","vn_o_armor_pt76b_01"];
		ZMM_EASTVeh_Air = ["vn_o_air_mi2_01_01","vn_o_air_mi2_01_03"];
		ZMM_EASTVeh_CasH = ["vn_o_air_mi2_03_04","vn_o_air_mi2_04_03"];
		ZMM_EASTVeh_CasP = ["vn_o_air_mig19_cas","vn_o_air_mig19_mr"];
		ZMM_EASTVeh_Convoy = ["vn_o_wheeled_btr40_mg_02","vn_o_wheeled_btr40_01","vn_o_wheeled_btr40_mg_03"];
		ZMM_EASTVeh_Static = ["vn_o_nva_65_static_dshkm_high_01","vn_o_nva_65_static_pk_high","vn_o_nva_65_static_rpd_high"];
	};
	case 4: {
		// EAST - KHMER ROUGE
		ZMM_EASTFactionName = "Khmer Rouge";
		ZMM_EASTFlag = ["vn_flag_pavn", "\vn\objects_f_vietnam\flags\data\vn_flag_01_pavn_co.paa"];
		ZMM_EASTMan = ["vn_o_men_kr_75_22","vn_o_men_kr_75_04","vn_o_men_kr_75_02","vn_o_men_kr_75_06","vn_o_men_kr_75_05","vn_o_men_kr_75_11","vn_o_men_kr_75_10","vn_o_men_kr_75_14","vn_o_men_kr_75_21","vn_o_men_kr_75_08","vn_o_men_kr_75_07","vn_o_men_kr_75_09"];
		ZMM_EASTVeh_Truck = ["vn_o_wheeled_z157_01"];
		ZMM_EASTVeh_Util = ["vn_o_wheeled_z157_ammo","vn_o_wheeled_z157_repair","vn_o_wheeled_z157_fuel"];
		ZMM_EASTVeh_Light = ["vn_o_wheeled_z157_mg_01","vn_o_wheeled_btr40_mg_02","vn_o_wheeled_z157_mg_01"];
		ZMM_EASTVeh_Medium = ["vn_o_wheeled_z157_mg_02","vn_o_wheeled_btr40_mg_06","vn_o_wheeled_btr40_mg_03","vn_o_wheeled_btr40_mg_04","vn_o_armor_btr50pk_02"];
		ZMM_EASTVeh_Heavy = ["vn_o_armor_type63_01","vn_o_armor_t54b_01","vn_o_armor_pt76b_01"];
		ZMM_EASTVeh_Air = ["vn_o_air_mi2_01_01","vn_o_air_mi2_01_03"];
		ZMM_EASTVeh_CasH = ["vn_o_air_mi2_03_04","vn_o_air_mi2_04_03"];
		ZMM_EASTVeh_CasP = ["vn_o_air_mig19_cas","vn_o_air_mig19_mr"];
		ZMM_EASTVeh_Convoy = ["vn_o_wheeled_btr40_mg_02","vn_o_wheeled_btr40_01","vn_o_wheeled_btr40_mg_03"];
		ZMM_EASTVeh_Static = ["vn_o_nva_65_static_dshkm_high_01","vn_o_nva_65_static_pk_high","vn_o_nva_65_static_rpd_high"];
	};
	case 5: {
		// WEST - MACV
		ZMM_EASTFactionName = "US MCAV";
		ZMM_EASTFlag = ["vn_flag_usa", "\vn\objects_f_vietnam\flags\data\vn_flag_01_usa_co.paa"];
		ZMM_EASTMan = ["vn_b_men_seal_43","vn_b_men_seal_51","vn_b_men_seal_24","vn_b_men_seal_45","vn_b_men_seal_23","vn_b_men_sog_07","vn_b_men_sog_19","vn_b_men_sog_17"];
		ZMM_EASTVeh_Truck = ["vn_b_wheeled_m54_01"];
		ZMM_EASTVeh_Util = ["vn_b_wheeled_m54_ammo","vn_b_wheeled_m54_fuel","vn_b_wheeled_m54_repair"];
		ZMM_EASTVeh_Light = ["vn_b_wheeled_m151_mg_04","vn_b_wheeled_m151_mg_02","vn_b_wheeled_m151_mg_03","vn_b_wheeled_m151_mg_05"];
		ZMM_EASTVeh_Medium = ["vn_b_wheeled_m54_mg_01","vn_b_wheeled_m54_mg_03","vn_b_wheeled_m54_mg_02"];
		ZMM_EASTVeh_Heavy = ["vn_b_armor_m41_01_01"];
		ZMM_EASTVeh_Air = ["vn_b_air_uh1d_01_04","vn_b_air_uh1d_02_04"];
		ZMM_EASTVeh_CasH = ["vn_b_air_ah1g_07_usmc"];
		ZMM_EASTVeh_CasP = ["vn_b_air_f4b_usmc_ucas","vn_b_air_f4b_usmc_mbmb"];
		ZMM_EASTVeh_Convoy = ["vn_b_wheeled_m54_mg_03","vn_b_wheeled_m54_02","vn_b_wheeled_m54_mg_01"];
		ZMM_EASTVeh_Static = ["vn_b_army_static_m1919a4_high","vn_b_army_static_m2_high","vn_b_army_static_m60_high"];
	};
	default {
		// EAST - PAVN 65
		ZMM_EASTFactionName = "PAVN 65";
		ZMM_EASTFlag = ["vn_flag_pavn", "\vn\objects_f_vietnam\flags\data\vn_flag_01_pavn_co.paa"];
		ZMM_EASTMan = ["vn_o_men_nva_65_15","vn_o_men_nva_65_16","vn_o_men_nva_65_21","vn_o_men_nva_65_23","vn_o_men_nva_65_24","vn_o_men_nva_65_25","vn_o_men_nva_65_26","vn_o_men_nva_65_28","vn_o_men_nva_65_17","vn_o_men_nva_65_18","vn_o_men_nva_65_19","vn_o_men_nva_65_20","vn_o_men_nva_65_22"];
		ZMM_EASTVeh_Truck = ["vn_o_wheeled_z157_01"];
		ZMM_EASTVeh_Util = ["vn_o_wheeled_z157_ammo","vn_o_wheeled_z157_repair","vn_o_wheeled_z157_fuel"];
		ZMM_EASTVeh_Light = ["vn_o_wheeled_z157_mg_01","vn_o_wheeled_btr40_mg_02","vn_o_wheeled_z157_mg_01"];
		ZMM_EASTVeh_Medium = ["vn_o_wheeled_z157_mg_02","vn_o_wheeled_btr40_mg_06","vn_o_wheeled_btr40_mg_03","vn_o_wheeled_btr40_mg_04","vn_o_armor_btr50pk_02"];
		ZMM_EASTVeh_Heavy = ["vn_o_armor_type63_01","vn_o_armor_t54b_01","vn_o_armor_pt76b_01"];
		ZMM_EASTVeh_Air = ["vn_o_air_mi2_01_01","vn_o_air_mi2_01_03"];
		ZMM_EASTVeh_CasH = ["vn_o_air_mi2_03_04","vn_o_air_mi2_04_03"];
		ZMM_EASTVeh_CasP = ["vn_o_air_mig19_cas","vn_o_air_mig19_mr"];
		ZMM_EASTVeh_Convoy = ["vn_o_wheeled_btr40_mg_02","vn_o_wheeled_btr40_01","vn_o_wheeled_btr40_mg_03"];
		ZMM_EASTVeh_Static = ["vn_o_nva_65_static_dshkm_high_01","vn_o_nva_65_static_pk_high","vn_o_nva_65_static_rpd_high"];
	};
};

// Choose Guer Faction
switch (missionNamespace getVariable ["f_param_factionGuer",-1]) do {
	case 1: {
		// GUER - PAVN 68
		ZMM_GUERFactionName = "PAVN 68";
		ZMM_GUERFlag = ["vn_flag_pavn", "\vn\objects_f_vietnam\flags\data\vn_flag_01_pavn_co.paa"];
		ZMM_GUERMan = ["vn_o_men_nva_06","vn_o_men_nva_03","vn_o_men_nva_11","vn_o_men_nva_07","vn_o_men_nva_14","vn_o_men_nva_04"];
		ZMM_GUERVeh_Truck = ["vn_o_wheeled_z157_01"];
		ZMM_GUERVeh_Util = ["vn_o_wheeled_z157_ammo","vn_o_wheeled_z157_repair","vn_o_wheeled_z157_fuel"];
		ZMM_GUERVeh_Light = ["vn_o_wheeled_z157_mg_01","vn_o_wheeled_btr40_mg_02","vn_o_wheeled_z157_mg_01"];
		ZMM_GUERVeh_Medium = ["vn_o_wheeled_z157_mg_02","vn_o_wheeled_btr40_mg_06","vn_o_wheeled_btr40_mg_03","vn_o_wheeled_btr40_mg_04","vn_o_armor_btr50pk_02"];
		ZMM_GUERVeh_Heavy = ["vn_o_armor_type63_01","vn_o_armor_t54b_01","vn_o_armor_pt76b_01"];
		ZMM_GUERVeh_Air = ["vn_o_air_mi2_01_01","vn_o_air_mi2_01_03"];
		ZMM_GUERVeh_CasH = ["vn_o_air_mi2_03_04","vn_o_air_mi2_04_03"];
		ZMM_GUERVeh_CasP = ["vn_o_air_mig19_cas","vn_o_air_mig19_mr"];
		ZMM_GUERVeh_Convoy = ["vn_o_wheeled_btr40_mg_02","vn_o_wheeled_btr40_01","vn_o_wheeled_btr40_mg_03"];
		ZMM_GUERVeh_Static = ["vn_o_nva_65_static_dshkm_high_01","vn_o_nva_65_static_pk_high","vn_o_nva_65_static_rpd_high"];
	};
	case 2: {
		// GUER - DAC CONG
		ZMM_GUERFactionName = "DAC Cong";
		ZMM_GUERFlag = ["vn_flag_pavn", "\vn\objects_f_vietnam\flags\data\vn_flag_01_pavn_co.paa"];
		ZMM_GUERMan = ["vn_o_men_nva_dc_14","vn_o_men_nva_dc_07","vn_o_men_nva_dc_11","vn_o_men_nva_dc_10","vn_o_men_nva_dc_08","vn_o_men_nva_dc_06","vn_o_men_nva_dc_05","vn_o_men_nva_dc_12"];
		ZMM_GUERVeh_Truck = ["vn_o_wheeled_z157_01"];
		ZMM_GUERVeh_Util = ["vn_o_wheeled_z157_ammo","vn_o_wheeled_z157_repair","vn_o_wheeled_z157_fuel"];
		ZMM_GUERVeh_Light = ["vn_o_wheeled_z157_mg_01","vn_o_wheeled_btr40_mg_02","vn_o_wheeled_z157_mg_01"];
		ZMM_GUERVeh_Medium = ["vn_o_wheeled_z157_mg_02","vn_o_wheeled_btr40_mg_06","vn_o_wheeled_btr40_mg_03","vn_o_wheeled_btr40_mg_04","vn_o_armor_btr50pk_02"];
		ZMM_GUERVeh_Heavy = ["vn_o_armor_type63_01","vn_o_armor_t54b_01","vn_o_armor_pt76b_01"];
		ZMM_GUERVeh_Air = ["vn_o_air_mi2_01_01","vn_o_air_mi2_01_03"];
		ZMM_GUERVeh_CasH = ["vn_o_air_mi2_03_04","vn_o_air_mi2_04_03"];
		ZMM_GUERVeh_CasP = ["vn_o_air_mig19_cas","vn_o_air_mig19_mr"];
		ZMM_GUERVeh_Convoy = ["vn_o_wheeled_btr40_mg_02","vn_o_wheeled_btr40_01","vn_o_wheeled_btr40_mg_03"];
		ZMM_GUERVeh_Static = ["vn_o_nva_65_static_dshkm_high_01","vn_o_nva_65_static_pk_high","vn_o_nva_65_static_rpd_high"];
	};
	case 3: {
		// GUER - VIET CONG
		ZMM_GUERFactionName = "Viet Cong";
		ZMM_GUERFlag = ["vn_flag_pavn", "\vn\objects_f_vietnam\flags\data\vn_flag_01_pavn_co.paa"];
		ZMM_GUERMan = ["vn_o_men_vc_local_08","vn_o_men_vc_local_07","vn_o_men_vc_local_28","vn_o_men_vc_local_05","vn_o_men_vc_local_23","vn_o_men_vc_local_18","vn_o_men_vc_local_06","vn_o_men_vc_local_02"];
		ZMM_GUERVeh_Truck = ["vn_o_wheeled_z157_01"];
		ZMM_GUERVeh_Util = ["vn_o_wheeled_z157_ammo","vn_o_wheeled_z157_repair","vn_o_wheeled_z157_fuel"];
		ZMM_GUERVeh_Light = ["vn_o_wheeled_z157_mg_01","vn_o_wheeled_btr40_mg_02","vn_o_wheeled_z157_mg_01"];
		ZMM_GUERVeh_Medium = ["vn_o_wheeled_z157_mg_02","vn_o_wheeled_btr40_mg_06","vn_o_wheeled_btr40_mg_03","vn_o_wheeled_btr40_mg_04","vn_o_armor_btr50pk_02"];
		ZMM_GUERVeh_Heavy = ["vn_o_armor_type63_01","vn_o_armor_t54b_01","vn_o_armor_pt76b_01"];
		ZMM_GUERVeh_Air = ["vn_o_air_mi2_01_01","vn_o_air_mi2_01_03"];
		ZMM_GUERVeh_CasH = ["vn_o_air_mi2_03_04","vn_o_air_mi2_04_03"];
		ZMM_GUERVeh_CasP = ["vn_o_air_mig19_cas","vn_o_air_mig19_mr"];
		ZMM_GUERVeh_Convoy = ["vn_o_wheeled_btr40_mg_02","vn_o_wheeled_btr40_01","vn_o_wheeled_btr40_mg_03"];
		ZMM_GUERVeh_Static = ["vn_o_nva_65_static_dshkm_high_01","vn_o_nva_65_static_pk_high","vn_o_nva_65_static_rpd_high"];
	};
	case 4: {
		// GUER - ARVN
		ZMM_GUERFactionName = "ARVN";
		ZMM_GUERFlag = ["vn_flag_thai", "\vn\objects_f_vietnam\flags\data\vn_flag_01_thai_co.paa"];
		ZMM_GUERMan = ["vn_i_men_army_12","vn_i_men_army_05","vn_i_men_army_04","vn_i_men_army_07","vn_i_men_army_06","vn_i_men_army_10","vn_i_men_army_15","vn_i_men_army_16","vn_i_men_army_18","vn_i_men_army_19","vn_i_men_army_20","vn_i_men_army_21","vn_i_men_army_02"];
		ZMM_GUERVeh_Truck = ["vn_i_wheeled_m54_02"];
		ZMM_GUERVeh_Util = ["vn_i_wheeled_m54_ammo","vn_i_wheeled_m54_repair","vn_i_wheeled_m54_fuel"];
		ZMM_GUERVeh_Light = ["vn_i_wheeled_m151_mg_01","vn_i_wheeled_m151_mg_06"];
		ZMM_GUERVeh_Medium = ["vn_i_armor_m113_acav_04","vn_i_armor_m113_acav_02","vn_i_armor_m113_acav_06"];
		ZMM_GUERVeh_Heavy = ["vn_i_armor_m41_01","vn_i_armor_type63_01"];
		ZMM_GUERVeh_Air = ["vn_b_air_ch47_04_01","vn_i_air_uh1d_01_01","vn_i_air_uh1d_02_01"];
		ZMM_GUERVeh_CasH = ["vn_i_air_uh1c_02_01","vn_i_air_uh1c_01_01"];
		ZMM_GUERVeh_CasP = ["vn_b_air_f4b_navy_ucas","vn_b_air_f100d_cas","vnx_b_air_ov10a_usmc_cas"];
		ZMM_GUERVeh_Convoy = ["vn_i_armor_type63_01","vn_i_wheeled_m54_02","vn_b_wheeled_m54_mg_01"];
		ZMM_GUERVeh_Static = ["vn_i_static_m1919a4_high","vn_i_static_m2_high","vn_i_static_m60_high"];
	};
	default {
		// GUER - PAVN 65
		ZMM_GUERFactionName = "PAVN 65";
		ZMM_GUERFlag = ["vn_flag_pavn", "\vn\objects_f_vietnam\flags\data\vn_flag_01_pavn_co.paa"];
		ZMM_GUERMan = ["vn_o_men_nva_65_15","vn_o_men_nva_65_16","vn_o_men_nva_65_21","vn_o_men_nva_65_23","vn_o_men_nva_65_24","vn_o_men_nva_65_25","vn_o_men_nva_65_26","vn_o_men_nva_65_28","vn_o_men_nva_65_17","vn_o_men_nva_65_18","vn_o_men_nva_65_19","vn_o_men_nva_65_20","vn_o_men_nva_65_22"];
		ZMM_GUERVeh_Truck = ["vn_o_wheeled_z157_01"];
		ZMM_GUERVeh_Util = ["vn_o_wheeled_z157_ammo","vn_o_wheeled_z157_repair","vn_o_wheeled_z157_fuel"];
		ZMM_GUERVeh_Light = ["vn_o_wheeled_z157_mg_01","vn_o_wheeled_btr40_mg_02","vn_o_wheeled_z157_mg_01"];
		ZMM_GUERVeh_Medium = ["vn_o_wheeled_z157_mg_02","vn_o_wheeled_btr40_mg_06","vn_o_wheeled_btr40_mg_03","vn_o_wheeled_btr40_mg_04","vn_o_armor_btr50pk_02"];
		ZMM_GUERVeh_Heavy = ["vn_o_armor_type63_01","vn_o_armor_t54b_01","vn_o_armor_pt76b_01"];
		ZMM_GUERVeh_Air = ["vn_o_air_mi2_01_01","vn_o_air_mi2_01_03"];
		ZMM_GUERVeh_CasH = ["vn_o_air_mi2_03_04","vn_o_air_mi2_04_03"];
		ZMM_GUERVeh_CasP = ["vn_o_air_mig19_cas","vn_o_air_mig19_mr"];
		ZMM_GUERVeh_Convoy = ["vn_o_wheeled_btr40_mg_02","vn_o_wheeled_btr40_01","vn_o_wheeled_btr40_mg_03"];
		ZMM_GUERVeh_Static = ["vn_o_nva_65_static_dshkm_high_01","vn_o_nva_65_static_pk_high","vn_o_nva_65_static_rpd_high"];
	};
};