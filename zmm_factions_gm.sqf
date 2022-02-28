// Choose West Faction
switch (missionNamespace getVariable ["f_param_factionWest",-1]) do {
	case 1: {
		// WEST - WEST GERMANY Winter
		ZMM_WESTFlag = ["gm_flag_GE", "\gm\gm_core\data\flags\gm_flag_GE_co.paa"];
		ZMM_WESTMan = ["gm_ge_army_machinegunner_mg3_parka_80_win","gm_ge_army_rifleman_g3a3_parka_80_win","gm_ge_army_squadleader_g3a3_p2a1_parka_80_win","gm_ge_army_grenadier_g3a3_parka_80_win"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_80_win"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_80_win",configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_mggroup_80_win"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_squad_80_win"];
		ZMM_WESTVeh_Truck = ["gm_ge_army_u1300l_cargo_win"];
		ZMM_WESTVeh_Util = ["gm_ge_army_kat1_451_refuel_win","gm_ge_army_kat1_451_reammo_win","gm_ge_army_u1300l_repair_win","gm_ge_army_u1300l_medic_win"];
		ZMM_WESTVeh_Light = ["gm_ge_army_iltis_milan_win"];
		ZMM_WESTVeh_Medium = ["gm_ge_army_fuchsa0_engineer_win","gm_ge_army_m113a1g_apc_win","gm_ge_army_luchsa2_win","gm_ge_army_marder1a1a_win"];
		ZMM_WESTVeh_Heavy = ["gm_ge_army_Leopard1a3_win","gm_ge_army_gepard1a1_win"];
		ZMM_WESTVeh_Air = [["gm_ge_army_ch53g","[_grpVeh,['gm_ge_olu',1],true] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_CasH = [["I_Heli_light_03_dynamicLoadout_F","[_grpVeh,['Green',1],true] call BIS_fnc_initVehicle;"],"gm_ge_army_bo105p_pah1a1"];
		ZMM_WESTVeh_Convoy = ["gm_ge_army_iltis_mg3_win","gm_ge_army_iltis_cargo_win","gm_ge_army_luchsa2_win"];
		ZMM_WESTVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 2: {
		// WEST - WEST GERMANY Tropical
		ZMM_WESTFlag = ["gm_flag_GE", "\gm\gm_core\data\flags\gm_flag_GE_co.paa"];
		ZMM_WESTMan = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_machinegunner_mg3_80_ols"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_80_ols"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_80_ols",configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_mggroup_80_ols"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_squad_80_ols"];
		ZMM_WESTVeh_Truck = ["gm_ge_army_u1300l_cargo_trp"];
		ZMM_WESTVeh_Util = ["gm_ge_army_kat1_451_refuel_trp","gm_ge_army_kat1_451_reammo_trp","gm_ge_army_u1300l_repair_trp","gm_ge_army_u1300l_medic_trp"];
		ZMM_WESTVeh_Light = ["gm_ge_army_iltis_milan_trp"];
		ZMM_WESTVeh_Medium = ["gm_ge_army_fuchsa0_engineer_trp","gm_ge_army_m113a1g_apc_trp","gm_ge_army_luchsa2_trp","gm_ge_army_marder1a1a_trp"];
		ZMM_WESTVeh_Heavy = ["gm_ge_army_Leopard1a3_trp","gm_ge_army_gepard1a1_trp"];
		ZMM_WESTVeh_Air = [["gm_ge_army_ch53g","[_grpVeh,['gm_ge_olu',1],true] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_CasH = [["I_Heli_light_03_dynamicLoadout_F","[_grpVeh,['Green',1],true] call BIS_fnc_initVehicle;"],"gm_ge_army_bo105p_pah1a1"];
		ZMM_WESTVeh_Convoy = ["gm_ge_army_iltis_mg3_trp","gm_ge_army_iltis_cargo_win","gm_ge_army_luchsa2_trp"];
		ZMM_WESTVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 3: {
		// WEST - WEST GERMANY Desert
		ZMM_WESTFlag = ["gm_flag_GE", "\gm\gm_core\data\flags\gm_flag_GE_co.paa"];
		ZMM_WESTMan = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_machinegunner_mg3_80_ols"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_80_ols"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_80_ols",configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_mggroup_80_ols"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_squad_80_ols"];
		ZMM_WESTVeh_Truck = ["gm_ge_army_u1300l_cargo_des"];
		ZMM_WESTVeh_Util = ["gm_ge_army_kat1_451_refuel_des","gm_ge_army_kat1_451_reammo_des","gm_ge_army_u1300l_repair_des","gm_ge_army_u1300l_medic_des"];
		ZMM_WESTVeh_Light = ["gm_ge_army_iltis_milan_des"];
		ZMM_WESTVeh_Medium = ["gm_ge_army_fuchsa0_engineer_des","gm_ge_army_m113a1g_apc_des","gm_ge_army_luchsa2_des","gm_ge_army_marder1a1a_des"];
		ZMM_WESTVeh_Heavy = ["gm_ge_army_Leopard1a3_des","gm_ge_army_gepard1a1_des"];
		ZMM_WESTVeh_Air = [["gm_ge_army_ch53g","[_grpVeh,['gm_ge_olu',1],true] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_CasH = [["I_Heli_light_03_dynamicLoadout_F","[_grpVeh,['Green',1],true] call BIS_fnc_initVehicle;"],"gm_ge_army_bo105p_pah1a1"];
		ZMM_WESTVeh_Convoy = ["gm_ge_army_iltis_mg3_des","gm_ge_army_iltis_cargo_des","gm_ge_army_luchsa2_des"];
		ZMM_WESTVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
	default {
		// WEST - WEST GERMANY Summer
		ZMM_WESTFlag = ["gm_flag_GE", "\gm\gm_core\data\flags\gm_flag_GE_co.paa"];
		ZMM_WESTMan = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_machinegunner_mg3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_antitank_g3a3_pzf44_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_antiair_g3a3_fim43_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_antitank_g3a3_pzf84_80_ols"];
		ZMM_WESTGrp_Sentry = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_80_ols"];
		ZMM_WESTGrp_Team = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_80_ols",configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_mggroup_80_ols"];
		ZMM_WESTGrp_Squad = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_squad_80_ols"];
		ZMM_WESTVeh_Truck = ["gm_ge_army_u1300l_cargo"];
		ZMM_WESTVeh_Util = ["gm_ge_army_kat1_451_refuel","gm_ge_army_kat1_451_reammo","gm_ge_army_u1300l_repair","gm_ge_army_u1300l_medic"];
		ZMM_WESTVeh_Light = ["gm_ge_army_iltis_milan"];
		ZMM_WESTVeh_Medium = ["gm_ge_army_fuchsa0_engineer","gm_ge_army_m113a1g_apc","gm_ge_army_luchsa2","gm_ge_army_marder1a1a"];
		ZMM_WESTVeh_Heavy = ["gm_ge_army_Leopard1a3","gm_ge_army_gepard1a1"];
		ZMM_WESTVeh_Air = [["gm_ge_army_ch53g","[_grpVeh,['gm_ge_olu',0.5,'gm_ge_olo',0.5],true] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_CasH = [["I_Heli_light_03_dynamicLoadout_F","[_grpVeh,['Green',1],true] call BIS_fnc_initVehicle;"],"gm_ge_army_bo105p_pah1a1"];
		ZMM_WESTVeh_Convoy = ["gm_ge_army_iltis_mg3","gm_ge_army_iltis_cargo","gm_ge_army_luchsa2"];
		ZMM_WESTVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
};

// Choose East Faction
switch (missionNamespace getVariable ["f_param_factionEast",-1]) do {
	case 1: {
		// EAST - EAST GERMANY Winter
		ZMM_EASTFlag = ["gm_flag_GC", "\gm\gm_core\data\flags\gm_flag_GC_co.paa"];
		ZMM_EASTMan = ["gm_gc_army_rifleman_mpiak74n_80_win","gm_gc_army_squadleader_mpiak74n_80_win","gm_gc_army_machinegunner_pk_80_win","gm_gc_army_antitank_mpiak74n_rpg7_80_win","gm_gc_army_squadleader_mpiak74n_80_win"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army_win" >> "gm_borderguards" >> "gm_gc_bgs_infantry_post_win"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army_win" >> "gm_infantry_80" >> "gm_ge_army_infantry_atgroup_win",configFile >> "CfgGroups" >> "East" >> "gm_gc_army" >> "gm_infantry_80" >> "gm_ge_army_infantry_mggroup_win"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army_win" >> "gm_infantry_80" >> "gm_gc_army_infantry_squad_win"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army_win" >> "gm_motorizedinfantry_80" >> "gm_gc_army_motorizedinfantly_squad_ural4320_cargo"];
		ZMM_EASTVeh_Util = ["gm_gc_army_ural4320_repair_win","gm_gc_army_ural375d_medic_win","gm_gc_army_ural375d_refuel_win"];
		ZMM_EASTVeh_Light = ["gm_gc_army_brdm2_win"];
		ZMM_EASTVeh_Medium = ["gm_gc_army_bmp1sp2_win","gm_gc_army_btr60pa_win"];
		ZMM_EASTVeh_Heavy = ["2gm_gc_army_t55a_win","gm_gc_army_zsu234v1_win","gm_gc_army_t55am2b_win"];
		ZMM_EASTVeh_Air = [["gm_gc_airforce_mi2p","[_grpVeh,['gm_gc_un',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_CasH = [["gm_gc_airforce_mi2urn","[_grpVeh,['gm_gc_un',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Convoy = ["gm_gc_army_brdm2_win","gm_gc_army_brdm2um_win","gm_gc_army_btr60pa_win"];
		ZMM_EASTVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 2: {
		// EAST - Poland Winter
		ZMM_EASTFlag = ["gm_flag_PL", "\gm\gm_core\data\flags\gm_flag_PL_co.paa"];
		ZMM_EASTMan = ["gm_pl_army_rifleman_akm_80_win","gm_pl_army_squadleader_akm_80_win","gm_pl_army_machinegunner_pk_80_win","gm_pl_army_antitank_akm_rpg7_80_win"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army_win" >> "gm_infantry_80" >> "gm_pl_army_infantry_mggroup_80_win"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army_win" >> "gm_infantry_80" >> "gm_pl_army_infantry_atgroup_80_win"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army_win" >> "gm_infantry_80" >> "gm_pl_army_infantry_squad_80_win"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army_win" >> "gm_motorizedinfantry_80" >> "gm_pl_army_motorizedinfantly_squad_ural4320_cargo_80"];
		ZMM_EASTVeh_Util = ["gm_gc_army_ural4320_repair_win","gm_gc_army_ural375d_medic_win","gm_gc_army_ural375d_refuel_win"];
		ZMM_EASTVeh_Light = ["gm_pl_army_brdm2_olw"];
		ZMM_EASTVeh_Medium = ["gm_pl_army_bmp1sp2_olw","gm_pl_army_ot64a_olw"];
		ZMM_EASTVeh_Heavy = ["gm_pl_army_zsu234v1_olw","gm_pl_army_pt76b_olw","gm_pl_army_t55_olw"];
		ZMM_EASTVeh_Air = ["gm_pl_airforce_mi2p_un"];
		ZMM_EASTVeh_CasH = ["gm_gc_airforce_mi2urn_un","gm_pl_airforce_mi2t_un","gm_pl_airforce_mi2us_un"];
		ZMM_EASTVeh_Convoy = ["gm_pl_army_brdm2_olw","gm_pl_army_brdm2_olw","gm_pl_army_bmp1sp2_olw"];
		ZMM_EASTVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 3: {
		// EAST - Poland Summer
		ZMM_EASTFlag = ["gm_flag_PL", "\gm\gm_core\data\flags\gm_flag_PL_co.paa"];
		ZMM_EASTMan = ["gm_pl_army_rifleman_akm_80_autumn_moro","gm_pl_army_squadleader_akm_80_autumn_moro","gm_pl_army_machinegunner_pk_80_autumn_moro","gm_pl_army_antitank_akm_rpg7_80_autumn_moro"];
		ZMM_EASTGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army" >> "gm_infantry_80" >> "gm_pl_army_infantry_mggroup_80_moro"];
		ZMM_EASTGrp_Team = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army" >> "gm_infantry_80" >> "gm_pl_army_infantry_atgroup_80_moro"];
		ZMM_EASTGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army" >> "gm_infantry_80" >> "gm_pl_army_infantry_squad_80_moro"];
		ZMM_EASTVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army" >> "gm_motorizedinfantry_80" >> "gm_pl_army_motorizedinfantly_squad_ural4320_cargo_80"];
		ZMM_EASTVeh_Util = ["gm_gc_army_ural4320_repair","gm_gc_army_ural375d_medic","gm_gc_army_ural375d_refuel"];
		ZMM_EASTVeh_Light = ["gm_pl_army_brdm2"];
		ZMM_EASTVeh_Medium = ["gm_pl_army_bmp1sp2","gm_pl_army_ot64a"];
		ZMM_EASTVeh_Heavy = ["gm_pl_army_zsu234v1","gm_pl_army_pt76b","gm_pl_army_t55"];
		ZMM_EASTVeh_Air = ["gm_gc_airforce_mi2p"];
		ZMM_EASTVeh_CasH = ["gm_gc_airforce_mi2urn","gm_pl_airforce_mi2t","gm_pl_airforce_mi2us"];
		ZMM_EASTVeh_Convoy = ["gm_pl_army_brdm2","gm_pl_army_brdm2","gm_pl_army_bmp1sp2"];
		ZMM_EASTVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
	default {
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
		ZMM_EASTVeh_Heavy = ["gm_gc_army_t55a","gm_gc_army_zsu234v1","gm_gc_army_t55am2b"];
		ZMM_EASTVeh_Air = ["gm_gc_airforce_mi2p"];
		ZMM_EASTVeh_CasH = ["gm_gc_airforce_mi2urn"];
		ZMM_EASTVeh_Convoy = ["gm_gc_army_brdm2","gm_gc_army_brdm2um","gm_gc_army_btr60pa"];
		ZMM_EASTVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
};

// Choose Guer Faction
switch (missionNamespace getVariable ["f_param_factionGuer",-1]) do {
	case 1: {
		// GUER - Denmark (Woodland)
		ZMM_GUERFlag = ["gm_flag_DK", "\gm\gm_core\data\flags\gm_flag_DK_co.paa"];
		ZMM_GUERMan = ["gm_dk_army_antiair_gvm95_fim43_90_m84","gm_dk_army_antitank_gvm95_m72a3_90_m84","gm_dk_army_antitank_gvm95_pzf84_90_m84","gm_dk_army_machinegunner_mg3_90_m84","gm_dk_army_marksman_g3a3_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_squadleader_gvm95_p2a1_90_m84"];
		ZMM_GUERGrp_Sentry = [[["gm_dk_army_squadleader_gvm95_p2a1_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_rifleman_gvm95_90_m84"]]];
		ZMM_GUERGrp_Team = [[["gm_dk_army_squadleader_gvm95_p2a1_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_machinegunner_mg3_84_m84","gm_dk_army_antitank_g3a3_m72a3_84_m84"]]];
		ZMM_GUERGrp_Squad = [[["gm_dk_army_squadleader_gvm95_p2a1_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_machinegunner_mg3_84_m84","gm_dk_army_antitank_g3a3_m72a3_84_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_antitank_gvm95_m72a3_90_m84","gm_dk_army_marksman_g3a3_90_m84","gm_dk_army_antitank_gvm95_pzf84_90_m84"]]];
		ZMM_GUERVeh_Truck = ["gm_dk_army_u1300l_container"];
		ZMM_GUERVeh_Util = ["gm_dk_army_m113a1dk_medic"];
		ZMM_GUERVeh_Light = ["gm_dk_army_u1300l_container"];
		ZMM_GUERVeh_Medium = ["gm_dk_army_m113a2dk","gm_dk_army_m113a1dk_apc"];
		ZMM_GUERVeh_Heavy = ["gm_dk_army_Leopard1a3"];
		ZMM_GUERVeh_Air = ["gm_ge_army_ch53g","gm_ge_army_bo105m_vbh"];
		ZMM_GUERVeh_CasH = ["gm_ge_army_bo105p_pah1a1"];
		ZMM_GUERVeh_Convoy = ["gm_dk_army_m113a1dk_apc","gm_dk_army_m113a1dk_apc","gm_dk_army_m113a2dk"];
		ZMM_GUERVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 2: {
		// GUER - Denmark (Desert)
		ZMM_GUERFlag = ["gm_flag_DK", "\gm\gm_core\data\flags\gm_flag_DK_co.paa"];
		ZMM_GUERMan = ["gm_dk_army_antiair_gvm95_fim43_90_m84","gm_dk_army_antitank_gvm95_m72a3_90_m84","gm_dk_army_antitank_gvm95_pzf84_90_m84","gm_dk_army_machinegunner_mg3_90_m84","gm_dk_army_marksman_g3a3_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_squadleader_gvm95_p2a1_90_m84"];
		ZMM_GUERGrp_Sentry = [[["gm_dk_army_squadleader_gvm95_p2a1_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_rifleman_gvm95_90_m84"]]];
		ZMM_GUERGrp_Team = [[["gm_dk_army_squadleader_gvm95_p2a1_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_machinegunner_mg3_84_m84","gm_dk_army_antitank_g3a3_m72a3_84_m84"]]];
		ZMM_GUERGrp_Squad = [[["gm_dk_army_squadleader_gvm95_p2a1_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_machinegunner_mg3_84_m84","gm_dk_army_antitank_g3a3_m72a3_84_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_antitank_gvm95_m72a3_90_m84","gm_dk_army_marksman_g3a3_90_m84","gm_dk_army_antitank_gvm95_pzf84_90_m84"]]];
		ZMM_GUERVeh_Truck = ["gm_dk_army_u1300l_container_des"];
		ZMM_GUERVeh_Util = ["gm_dk_army_m113a1dk_medic_des"];
		ZMM_GUERVeh_Light = ["gm_dk_army_u1300l_container_des"];
		ZMM_GUERVeh_Medium = ["gm_dk_army_m113a2dk_des","gm_dk_army_m113a1dk_apc_des"];
		ZMM_GUERVeh_Heavy = ["gm_dk_army_Leopard1a3_des"];
		ZMM_GUERVeh_Air = ["gm_ge_army_ch53g","gm_ge_army_bo105m_vbh"];
		ZMM_GUERVeh_CasH = ["gm_ge_army_bo105p_pah1a1"];
		ZMM_GUERVeh_Convoy = ["gm_dk_army_m113a1dk_apc_des","gm_dk_army_m113a1dk_apc_des","gm_dk_army_m113a2dk_des"];
		ZMM_GUERVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 3: {
		// GUER - Denmark (Winter)
		ZMM_GUERFlag = ["gm_flag_DK", "\gm\gm_core\data\flags\gm_flag_DK_co.paa"];
		ZMM_GUERMan = ["gm_dk_army_antiair_gvm95_fim43_90_m84","gm_dk_army_antitank_gvm95_m72a3_90_m84","gm_dk_army_antitank_gvm95_pzf84_90_m84","gm_dk_army_machinegunner_mg3_90_m84","gm_dk_army_marksman_g3a3_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_squadleader_gvm95_p2a1_90_m84"];
		ZMM_GUERGrp_Sentry = [[["gm_dk_army_squadleader_gvm95_p2a1_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_rifleman_gvm95_90_m84"]]];
		ZMM_GUERGrp_Team = [[["gm_dk_army_squadleader_gvm95_p2a1_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_machinegunner_mg3_84_m84","gm_dk_army_antitank_g3a3_m72a3_84_m84"]]];
		ZMM_GUERGrp_Squad = [[["gm_dk_army_squadleader_gvm95_p2a1_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_machinegunner_mg3_84_m84","gm_dk_army_antitank_g3a3_m72a3_84_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_antitank_gvm95_m72a3_90_m84","gm_dk_army_marksman_g3a3_90_m84","gm_dk_army_antitank_gvm95_pzf84_90_m84"]]];
		ZMM_GUERVeh_Truck = ["gm_dk_army_u1300l_container_win"];
		ZMM_GUERVeh_Util = ["gm_dk_army_m113a1dk_medic_win"];
		ZMM_GUERVeh_Light = ["gm_dk_army_u1300l_container_win"];
		ZMM_GUERVeh_Medium = ["gm_dk_army_m113a2dk_win","gm_dk_army_m113a1dk_apc_win"];
		ZMM_GUERVeh_Heavy = ["gm_dk_army_Leopard1a3_win"];
		ZMM_GUERVeh_Air = ["gm_ge_army_ch53g_un","gm_ge_army_bo105m_vbh_un"];
		ZMM_GUERVeh_CasH = ["gm_ge_army_bo105p_pah1a1_un"];
		ZMM_GUERVeh_Convoy = ["gm_dk_army_m113a1dk_apc_win","gm_dk_army_m113a1dk_apc_win","gm_dk_army_m113a2dk_win"];
		ZMM_GUERVeh_Static = ["gm_ge_army_mg3_aatripod"];		
	};
	case 4: {
		// GUER - Poland Winter
		ZMM_GUERFlag = ["gm_flag_PL", "\gm\gm_core\data\flags\gm_flag_PL_co.paa"];
		ZMM_GUERMan = ["gm_pl_army_rifleman_akm_80_win","gm_pl_army_squadleader_akm_80_win","gm_pl_army_machinegunner_pk_80_win","gm_pl_army_antitank_akm_rpg7_80_win"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army_win" >> "gm_infantry_80" >> "gm_pl_army_infantry_mggroup_80_win"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army_win" >> "gm_infantry_80" >> "gm_pl_army_infantry_atgroup_80_win"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army_win" >> "gm_infantry_80" >> "gm_pl_army_infantry_squad_80_win"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army_win" >> "gm_motorizedinfantry_80" >> "gm_pl_army_motorizedinfantly_squad_ural4320_cargo_80"];
		ZMM_GUERVeh_Util = ["gm_gc_army_ural4320_repair_win","gm_gc_army_ural375d_medic_win","gm_gc_army_ural375d_refuel_win"];
		ZMM_GUERVeh_Light = ["gm_pl_army_brdm2_olw"];
		ZMM_GUERVeh_Medium = ["gm_pl_army_bmp1sp2_olw","gm_pl_army_ot64a_olw"];
		ZMM_GUERVeh_Heavy = ["gm_pl_army_zsu234v1_olw","gm_pl_army_pt76b_olw","gm_pl_army_t55_olw"];
		ZMM_GUERVeh_Air = ["gm_pl_airforce_mi2p_un"];
		ZMM_GUERVeh_CasH = ["gm_gc_airforce_mi2urn_un","gm_pl_airforce_mi2t_un","gm_pl_airforce_mi2us_un"];
		ZMM_GUERVeh_Convoy = ["gm_pl_army_brdm2_olw","gm_pl_army_brdm2_olw","gm_pl_army_bmp1sp2_olw"];
		ZMM_GUERVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
	default {
		// GUER - Poland Summer
		ZMM_GUERFlag = ["gm_flag_PL", "\gm\gm_core\data\flags\gm_flag_PL_co.paa"];
		ZMM_GUERMan = ["gm_pl_army_rifleman_akm_80_autumn_moro","gm_pl_army_squadleader_akm_80_autumn_moro","gm_pl_army_machinegunner_pk_80_autumn_moro","gm_pl_army_antitank_akm_rpg7_80_autumn_moro"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army" >> "gm_infantry_80" >> "gm_pl_army_infantry_mggroup_80_moro"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army" >> "gm_infantry_80" >> "gm_pl_army_infantry_atgroup_80_moro"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army" >> "gm_infantry_80" >> "gm_pl_army_infantry_squad_80_moro"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army" >> "gm_motorizedinfantry_80" >> "gm_pl_army_motorizedinfantly_squad_ural4320_cargo_80"];
		ZMM_GUERVeh_Util = ["gm_gc_army_ural4320_repair","gm_gc_army_ural375d_medic","gm_gc_army_ural375d_refuel"];
		ZMM_GUERVeh_Light = ["gm_pl_army_brdm2"];
		ZMM_GUERVeh_Medium = ["gm_pl_army_bmp1sp2","gm_pl_army_ot64a"];
		ZMM_GUERVeh_Heavy = ["gm_pl_army_zsu234v1","gm_pl_army_pt76b","gm_pl_army_t55"];
		ZMM_GUERVeh_Air = ["gm_gc_airforce_mi2p"];
		ZMM_GUERVeh_CasH = ["gm_gc_airforce_mi2urn","gm_pl_airforce_mi2t","gm_pl_airforce_mi2us"];
		ZMM_GUERVeh_Convoy = ["gm_pl_army_brdm2","gm_pl_army_brdm2","gm_pl_army_bmp1sp2"];
		ZMM_GUERVeh_Static = ["gm_ge_army_mg3_aatripod"];
	};
};