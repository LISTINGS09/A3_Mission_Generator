// West Faction
switch (missionNamespace getVariable ["f_param_factionWest",-1]) do {
	// West Germany - Summer Soldiers
	case 1; case 2; case 3; case 4; case 5; case 6: {
		private _suffix = ["_des","_oli","_ols","_trp","_wdl","_wds","_un","_win","_wiw","_olw"] select (missionNamespace getVariable ["f_param_factionWest",-1]);
		ZMM_WEST_FactionName = "West Germany (Summer)";
		ZMM_WEST_Flag = ["gm_flag_GE", "\gm\gm_core\data\flags\gm_flag_GE_co.paa"];
		ZMM_WEST_Man = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_machinegunner_mg3_80_ols"];
		ZMM_WEST_Truck = ["gm_ge_army_u1300l_cargo"];
		ZMM_WEST_Util = ["gm_ge_army_kat1_451_refuel","gm_ge_army_kat1_451_reammo","gm_ge_army_u1300l_repair","gm_ge_army_u1300l_medic"];
		ZMM_WEST_Light = ["gm_ge_army_iltis_milan","gm_ge_army_iltis_mg3"];
		ZMM_WEST_Medium = ["gm_ge_army_fuchsa0_engineer","gm_ge_army_m113a1g_apc","gm_ge_army_luchsa2"];
		ZMM_WEST_Heavy = ["gm_ge_army_Leopard1a3","gm_ge_army_gepard1a1","gm_ge_army_marder1a1a"];
		ZMM_WEST_Air = ["gm_ge_army_ch53g"];
		ZMM_WEST_CasH = [["I_Heli_light_03_dynamicLoadout_F","[_grpVeh,['Green',1],true] call BIS_fnc_initVehicle;"],"gm_ge_army_bo105p_pah1a1"];
		ZMM_WEST_Convoy = ["gm_ge_army_fuchsa0_engineer","gm_ge_army_luchsa2","gm_ge_army_marder1a1plus"];
		ZMM_WEST_Static = ["gm_ge_army_mg3_aatripod"];
		{ missionNamespace setVariable [_x, (missionNamespace getVariable [_x,[]]) apply { _x + _suffix }] } forEach ["ZMM_WEST_Truck","ZMM_WEST_Util","ZMM_WEST_Light","ZMM_WEST_Medium","ZMM_WEST_Heavy","ZMM_WEST_Convoy"];
	};
	// West Germany - Winter Soldiers
	case 7; case 8; case 9; case 10: {
		private _suffix = ["_des","_oli","_ols","_trp","_wdl","_wds","_un","_win","_wiw","_olw"] select (missionNamespace getVariable ["f_param_factionWest",-1]);
		ZMM_WEST_FactionName = "West Germany (Winter)";
		ZMM_WEST_Flag = ["gm_flag_GE", "\gm\gm_core\data\flags\gm_flag_GE_co.paa"];
		ZMM_WEST_Man = ["gm_ge_army_machinegunner_mg3_parka_80_win","gm_ge_army_rifleman_g3a3_parka_80_win","gm_ge_army_squadleader_g3a3_p2a1_parka_80_win","gm_ge_army_grenadier_g3a3_parka_80_win"];
		ZMM_WEST_Truck = ["gm_ge_army_u1300l_cargo"];
		ZMM_WEST_Util = ["gm_ge_army_kat1_451_refuel","gm_ge_army_kat1_451_reammo","gm_ge_army_u1300l_repair","gm_ge_army_u1300l_medic"];
		ZMM_WEST_Light = ["gm_ge_army_iltis_milan","gm_ge_army_iltis_mg3"];
		ZMM_WEST_Medium = ["gm_ge_army_fuchsa0_engineer","gm_ge_army_m113a1g_apc","gm_ge_army_luchsa2"];
		ZMM_WEST_Heavy = ["gm_ge_army_Leopard1a3","gm_ge_army_gepard1a1","gm_ge_army_marder1a1a"];
		ZMM_WEST_Air = ["gm_ge_army_ch53g"];
		ZMM_WEST_CasH = [["I_Heli_light_03_dynamicLoadout_F","[_grpVeh,['Green',1],true] call BIS_fnc_initVehicle;"],"gm_ge_army_bo105p_pah1a1"];
		ZMM_WEST_Convoy = ["gm_ge_army_fuchsa0_engineer","gm_ge_army_luchsa2","gm_ge_army_marder1a1plus"];
		ZMM_WEST_Static = ["gm_ge_army_mg3_aatripod"];
		{ missionNamespace setVariable [_x, (missionNamespace getVariable [_x,[]]) apply { _x + _suffix }] } forEach ["ZMM_WEST_Truck","ZMM_WEST_Util","ZMM_WEST_Light","ZMM_WEST_Medium","ZMM_WEST_Heavy","ZMM_WEST_Convoy"];
	};
	// CDF 2022 - Woodland
	case 11: {
		private _suffix = ["_wdl","_oli","_win","_olw"] select ((missionNamespace getVariable ["f_param_factionWest",-1]) - 11);
		ZMM_WEST_FactionName = "CDF (Woodland)";
		ZMM_WEST_Flag = ["gm_flag_GE", "\gm\gm_core\data\flags\gm_flag_GE_co.paa"];
		ZMM_WEST_Man = ["gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_machinegunner_pk_digittsko","gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_antitank_trg21_pzf3_digittsko","gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_squadleader_trg21_digittsko"];
		ZMM_WEST_Truck = ["gmx_cdf2022_ural4320_cargo_wdl"];
		ZMM_WEST_Util = ["gmx_cdf2022_ural4320_repair_wdl","gmx_cdf2022_ural4320_reammo_wdl","gmx_cdf2022_ural375d_medic_wdl","gmx_cdf2022_ural375d_refuel_wdl"];
		ZMM_WEST_Light = ["gmx_cdf2022_uaz469_dshkm_wdl","gmx_cdf2022_uaz469_spg9_wdl"];
		ZMM_WEST_Medium = ["gmx_cdf2022_bmp1sp2_wdl","gmx_cdf2022_brdm2_wdl","gmx_cdf2022_btr60pb_wdl"];
		ZMM_WEST_Heavy = ["gmx_cdf2022_marder1a2_wdl","gmx_cdf2022_kpz1a5_wdl","gmx_cdf2022_t55ak","gmx_cdf2022_gepard1a1_wdl"];
		ZMM_WEST_Air = ["gmx_cdf2022_mi2p_wdl"];
		ZMM_WEST_CasH = ["gmx_cdf2022_mi2urn_wdl"];
		ZMM_WEST_Convoy = ["gmx_cdf2022_brdm2_wdl","gmx_cdf2022_btr60pb_wdl","gmx_cdf2022_t55ak_wdl"];
		ZMM_WEST_Static = ["gm_ge_army_mg3_aatripod"];
		{ missionNamespace setVariable [_x, (missionNamespace getVariable [_x,[]]) apply { _x + _suffix }] } forEach ["ZMM_WEST_Truck","ZMM_WEST_Util","ZMM_WEST_Light","ZMM_WEST_Medium","ZMM_WEST_Heavy","ZMM_WEST_Convoy"];
	};
	// CDF 2022 - Olive (_oli)
	case 12: {	
		private _suffix = ["_wdl","_oli","_win","_olw"] select ((missionNamespace getVariable ["f_param_factionWest",-1]) - 11);
		ZMM_WEST_FactionName = "CDF (Olive)";
		ZMM_WEST_Flag = ["gm_flag_GE", "\gm\gm_core\data\flags\gm_flag_GE_co.paa"];
		ZMM_WEST_Man = ["gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_machinegunner_pk_digittsko","gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_antitank_trg21_pzf3_digittsko","gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_squadleader_trg21_digittsko"];
		ZMM_WEST_Truck = [["gmx_cdf2022_ural4320_cargo_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Util = [["gmx_cdf2022_ural4320_repair_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_ural4320_reammo_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_ural375d_medic_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_ural375d_refuel_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Light = [["gmx_cdf2022_uaz469_dshkm_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_uaz469_spg9_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Medium = [["gmx_cdf2022_bmp1sp2_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_brdm2_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_btr60pb_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Heavy = [["gmx_cdf2022_marder1a2_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_kpz1a5_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_t55ak","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_gepard1a1_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Air = ["gmx_cdf2022_mi2p_wdl"];
		ZMM_WEST_CasH = ["gmx_cdf2022_mi2urn_wdl"];
		ZMM_WEST_Convoy = [["gmx_cdf2022_brdm2_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_btr60pb_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_t55ak_wdl","[_grpVeh,['gmx_cdf2022_oli',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Static = ["gm_ge_army_mg3_aatripod"];
	};
		
	// CDF 2022 - Winter (_win)
	case 13: {
		ZMM_WEST_FactionName = "CDF (Winter)";
		ZMM_WEST_Flag = ["gm_flag_GE", "\gm\gm_core\data\flags\gm_flag_GE_co.paa"];
		ZMM_WEST_Man = ["gmx_cdf2022_army_sf_machinegunner_pk_digittsko","gmx_cdf2022_army_sf_rifleman_g3a4ebr_mcam","gmx_cdf2022_army_sf_squadleader_g3a4ebr_mcam","gmx_cdf2022_army_sf_demolition_g3a4ebr_mcam"];
		ZMM_WEST_Truck = [["gmx_cdf2022_ural4320_cargo_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Util = [["gmx_cdf2022_ural4320_repair_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_ural4320_reammo_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_ural375d_medic_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_ural375d_refuel_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Light = [["gmx_cdf2022_uaz469_dshkm_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_uaz469_spg9_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Medium = [["gmx_cdf2022_bmp1sp2_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_brdm2_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_btr60pb_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Heavy = [["gmx_cdf2022_marder1a2_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_kpz1a5_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_t55ak","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_gepard1a1_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Air = ["gmx_cdf2022_mi2p_wdl"];
		ZMM_WEST_CasH = ["gmx_cdf2022_mi2urn_wdl"];
		ZMM_WEST_Convoy = [["gmx_cdf2022_brdm2_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_btr60pb_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_t55ak_wdl","[_grpVeh,['gmx_cdf2022_win',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Static = ["gm_ge_army_mg3_aatripod"];
	};
	// CDF 2022 - Olive Winter (_olw)
	case 14: {
		ZMM_WEST_FactionName = "CDF (Olive Winter)";
		ZMM_WEST_Flag = ["gm_flag_GE", "\gm\gm_core\data\flags\gm_flag_GE_co.paa"];
		ZMM_WEST_Man = ["gmx_cdf2022_army_sf_machinegunner_pk_digittsko","gmx_cdf2022_army_sf_rifleman_g3a4ebr_mcam","gmx_cdf2022_army_sf_squadleader_g3a4ebr_mcam","gmx_cdf2022_army_sf_demolition_g3a4ebr_mcam"];
		ZMM_WEST_Truck = [["gmx_cdf2022_ural4320_cargo_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Util = [["gmx_cdf2022_ural4320_repair_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_ural4320_reammo_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_ural375d_medic_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_ural375d_refuel_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Light = [["gmx_cdf2022_uaz469_dshkm_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_uaz469_spg9_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Medium = [["gmx_cdf2022_bmp1sp2_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_brdm2_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_btr60pb_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Heavy = [["gmx_cdf2022_marder1a2_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_kpz1a5_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_t55ak","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_gepard1a1_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Air = ["gmx_cdf2022_mi2p_wdl"];
		ZMM_WEST_CasH = ["gmx_cdf2022_mi2urn_wdl"];
		ZMM_WEST_Convoy = [["gmx_cdf2022_brdm2_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_btr60pb_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"],["gmx_cdf2022_t55ak_wdl","[_grpVeh,['gmx_cdf2022_olw',1]] spawn BIS_fnc_initVehicle;"]];
		ZMM_WEST_Static = ["gm_ge_army_mg3_aatripod"];
	};
	// CDF 1980 - Summer
	default { 
		ZMM_WEST_FactionName = "CDF Old (Summer)";
		ZMM_WEST_Flag = ["gm_flag_GE", "\gm\gm_core\data\flags\gm_flag_GE_co.paa"];
		ZMM_WEST_Man = ["gmx_cdf_army_antitank_ak74_rpg7_ttsko","gmx_cdf_army_rifleman_ak74_ttsko","gmx_cdf_army_machinegunner_rpk_ttsko","gmx_cdf_army_rifleman_ak74_ttsko","gmx_cdf_army_squadleader_ak74_ttsko","gmx_cdf_army_rifleman_ak74_ttsko","gmx_cdf_army_rifleman_ak74_ttsko"];
		ZMM_WEST_Truck = ["gmx_cdf_ural4320_cargo_wdl"];
		ZMM_WEST_Util = ["gmx_cdf_ural375d_refuel_wdl","gmx_cdf_ural375d_medic_wdl","gmx_cdf_ural4320_reammo_wdl","gmx_cdf_ural4320_repair_wdl"];
		ZMM_WEST_Light = ["gmx_cdf_uaz469_spg9_wdl","gmx_cdf_uaz469_dshkm_wdl"];
		ZMM_WEST_Medium = ["gmx_cdf_btr60pb_wdl","gmx_cdf_bmp1sp2_wdl","gmx_cdf_brdm2_wdl"];
		ZMM_WEST_Heavy = ["gmx_cdf_zsu234v1_wdl","gmx_cdf_pt76b_wdl","gmx_cdf_t55_wdl"];
		ZMM_WEST_Air = ["gmx_cdf_mi2p_wdl"];
		ZMM_WEST_CasH = ["gmx_cdf_mi2urn_wdl"];
		ZMM_WEST_Convoy = ["gmx_cdf_brdm2_wdl","gmx_cdf_btr60pb_wdl","gmx_cdf_zsu234v1_wdl"];
		ZMM_WEST_Static = ["gm_ge_army_mg3_aatripod"];
	};	
};

// East Faction
switch (missionNamespace getVariable ["f_param_factionEast",-1]) do {
	case 1: {
		// EAST - EAST GERMANY - Olive (Mud)
		ZMM_EAST_FactionName = "East Germany (Mud)";
		ZMM_EAST_Flag = ["gm_flag_GC", "\gm\gm_core\data\flags\gm_flag_GC_co.paa"];
		ZMM_EAST_Man = ["gm_gc_army_rifleman_mpiak74n_80_str","gm_gc_army_squadleader_mpiak74n_80_str","gm_gc_army_machinegunner_pk_80_str","gm_gc_army_antitank_mpiak74n_rpg7_80_str","gm_gc_army_squadleader_mpiak74n_80_str"];
		ZMM_EAST_Truck = ["gm_gc_army_ural4320_cargo_ols"];
		ZMM_EAST_Util = ["gm_gc_army_ural4320_repair_ols","gm_gc_army_ural4320_reammo_ols","gm_gc_army_ural375d_medic_ols","gm_gc_army_ural375d_refuel_ols"];
		ZMM_EAST_Light = ["gm_gc_army_uaz469_dshkm_ols","gm_gc_army_uaz469_spg9_ols"];
		ZMM_EAST_Medium = ["gm_gc_army_brdm2_ols","gm_gc_army_btr60pb_ols","gm_gc_army_bmp1sp2_ols"];
		ZMM_EAST_Heavy = ["gm_gc_army_t55_ols","gm_gc_army_zsu234v1_ols","gm_gc_army_pt76b_ols"];
		ZMM_EAST_Air = ["gm_gc_airforce_mi2p"];
		ZMM_EAST_CasH = ["gm_gc_airforce_mi2urn"];
		ZMM_EAST_Convoy = ["gm_gc_army_brdm2_ols","gm_gc_army_btr60pb_ols","gm_gc_army_bmp1sp2_ols"];
		ZMM_EAST_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 2: {
		// EAST - EAST GERMANY - Woodland
		ZMM_EAST_FactionName = "East Germany (Woodland)";
		ZMM_EAST_Flag = ["gm_flag_GC", "\gm\gm_core\data\flags\gm_flag_GC_co.paa"];
		ZMM_EAST_Man = ["gm_gc_army_rifleman_mpiak74n_80_str","gm_gc_army_squadleader_mpiak74n_80_str","gm_gc_army_machinegunner_pk_80_str","gm_gc_army_antitank_mpiak74n_rpg7_80_str","gm_gc_army_squadleader_mpiak74n_80_str"];
		ZMM_EAST_Truck = ["gm_gc_army_ural4320_cargo_wdl"];
		ZMM_EAST_Util = ["gm_gc_army_ural4320_repair_wdl","gm_gc_army_ural4320_reammo_wdl","gm_gc_army_ural375d_medic_wdl","gm_gc_army_ural375d_refuel_wdl"];
		ZMM_EAST_Light = ["gm_gc_army_uaz469_dshkm_wdl","gm_gc_army_uaz469_spg9_wdl"];
		ZMM_EAST_Medium = ["gm_gc_army_brdm2_wdl","gm_gc_army_btr60pb_wdl","gm_gc_army_bmp1sp2_wdl"];
		ZMM_EAST_Heavy = ["gm_gc_army_t55_wdl","gm_gc_army_zsu234v1_wdl","gm_gc_army_pt76b_wdl"];
		ZMM_EAST_Air = ["gm_gc_airforce_mi2p"];
		ZMM_EAST_CasH = ["gm_gc_airforce_mi2urn"];
		ZMM_EAST_Convoy = ["gm_gc_army_brdm2_wdl","gm_gc_army_btr60pb_wdl","gm_gc_army_bmp1sp2_wdl"];
		ZMM_EAST_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 3: {
		// EAST - EAST GERMANY Winter
		ZMM_EAST_FactionName = "East Germany (Winter)";
		ZMM_EAST_Flag = ["gm_flag_GC", "\gm\gm_core\data\flags\gm_flag_GC_co.paa"];
		ZMM_EAST_Man = ["gm_gc_army_rifleman_mpiak74n_80_win","gm_gc_army_squadleader_mpiak74n_80_win","gm_gc_army_machinegunner_pk_80_win","gm_gc_army_antitank_mpiak74n_rpg7_80_win","gm_gc_army_squadleader_mpiak74n_80_win"];
		ZMM_EAST_Truck = ["gm_gc_army_ural4320_cargo_win"];
		ZMM_EAST_Util = ["gm_gc_army_ural4320_repair_win","gm_gc_army_ural4320_reammo_win","gm_gc_army_ural375d_medic_win","gm_gc_army_ural375d_refuel_win"];
		ZMM_EAST_Light = ["gm_gc_army_uaz469_dshkm_win","gm_gc_army_uaz469_spg9_win"];
		ZMM_EAST_Medium = ["gm_gc_army_brdm2_win","gm_gc_army_btr60pb_win","gm_gc_army_bmp1sp2_win"];
		ZMM_EAST_Heavy = ["gm_gc_army_t55_win","gm_gc_army_zsu234v1_win","gm_gc_army_pt76b_win"];
		ZMM_EAST_Air = [["gm_gc_airforce_mi2p","[_grpVeh,['gm_gc_un',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_CasH = [["gm_gc_airforce_mi2urn","[_grpVeh,['gm_gc_un',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Convoy = ["gm_gc_army_brdm2_win","gm_gc_army_btr60pb_win","gm_gc_army_bmp1sp2_win"];
		ZMM_EAST_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 4: {
		// EAST - EAST GERMANY Winter (Olive)
		ZMM_EAST_FactionName = "East Germany (Olive Winter)";
		ZMM_EAST_Flag = ["gm_flag_GC", "\gm\gm_core\data\flags\gm_flag_GC_co.paa"];
		ZMM_EAST_Man = ["gm_gc_army_rifleman_mpiak74n_80_win","gm_gc_army_squadleader_mpiak74n_80_win","gm_gc_army_machinegunner_pk_80_win","gm_gc_army_antitank_mpiak74n_rpg7_80_win","gm_gc_army_squadleader_mpiak74n_80_win"];
		ZMM_EAST_Truck = ["gm_gc_army_ural4320_cargo_olw"];
		ZMM_EAST_Util = ["gm_gc_army_ural4320_repair_olw","gm_gc_army_ural4320_reammo_olw","gm_gc_army_ural375d_medic_olw","gm_gc_army_ural375d_refuel_olw"];
		ZMM_EAST_Light = ["gm_gc_army_uaz469_dshkm_olw","gm_gc_army_uaz469_spg9_olw"];
		ZMM_EAST_Medium = ["gm_gc_army_brdm2_olw","gm_gc_army_btr60pb_olw","gm_gc_army_bmp1sp2_olw"];
		ZMM_EAST_Heavy = ["gm_gc_army_t55_olw","gm_gc_army_zsu234v1_olw","gm_gc_army_pt76b_olw"];
		ZMM_EAST_Air = [["gm_gc_airforce_mi2p","[_grpVeh,['gm_gc_un',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_CasH = [["gm_gc_airforce_mi2urn","[_grpVeh,['gm_gc_un',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Convoy = ["gm_gc_army_brdm2_olw","gm_gc_army_btr60pb_olw","gm_gc_army_bmp1sp2_olw"];
		ZMM_EAST_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 5: {
		// EAST - EAST GERMANY White
		ZMM_EAST_FactionName = "East Germany (White)";
		ZMM_EAST_Flag = ["gm_flag_GC", "\gm\gm_core\data\flags\gm_flag_GC_co.paa"];
		ZMM_EAST_Man = ["gm_gc_army_rifleman_mpiak74n_80_win","gm_gc_army_squadleader_mpiak74n_80_win","gm_gc_army_machinegunner_pk_80_win","gm_gc_army_antitank_mpiak74n_rpg7_80_win","gm_gc_army_squadleader_mpiak74n_80_win"];
		ZMM_EAST_Truck = ["gm_gc_army_ural4320_cargo_un"];
		ZMM_EAST_Util = ["gm_gc_army_ural4320_repair_un","gm_gc_army_ural4320_reammo_un","gm_gc_army_ural375d_medic_un","gm_gc_army_ural375d_refuel_un"];
		ZMM_EAST_Light = ["gm_gc_army_uaz469_dshkm_un","gm_gc_army_uaz469_spg9_un"];
		ZMM_EAST_Medium = ["gm_gc_army_brdm2_un","gm_gc_army_btr60pb_un","gm_gc_army_bmp1sp2_un"];
		ZMM_EAST_Heavy = ["gm_gc_army_t55_un","gm_gc_army_zsu234v1_un","gm_gc_army_pt76b_un"];
		ZMM_EAST_Air = [["gm_gc_airforce_mi2p","[_grpVeh,['gm_gc_un',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_CasH = [["gm_gc_airforce_mi2urn","[_grpVeh,['gm_gc_un',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Convoy = ["gm_gc_army_brdm2_un","gm_gc_army_btr60pb_un","gm_gc_army_bmp1sp2_un"];
		ZMM_EAST_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 6: {
		// EAST - Poland Winter (Olive)
		ZMM_EAST_FactionName = "Poland (Olive Winter)";
		ZMM_EAST_Flag = ["gm_flag_PL", "\gm\gm_core\data\flags\gm_flag_PL_co.paa"];
		ZMM_EAST_Man = ["gm_pl_army_rifleman_akm_80_win","gm_pl_army_squadleader_akm_80_win","gm_pl_army_machinegunner_pk_80_win","gm_pl_army_antitank_akm_rpg7_80_win"];
		ZMM_EAST_Truck = ["gm_pl_army_ural4320_cargo_win"];
		ZMM_EAST_Util = ["gm_pl_army_ural4320_reammo_olw","gm_pl_army_ural375d_medic_olw","gm_pl_army_ural4320_repair_olw","gm_pl_army_ural375d_refuel_olw"];
		ZMM_EAST_Light = ["gm_pl_army_brdm2_olw"];
		ZMM_EAST_Medium = ["gm_pl_army_bmp1sp2_olw","gm_pl_army_ot64a_olw"];
		ZMM_EAST_Heavy = ["gm_pl_army_zsu234v1_olw","gm_pl_army_pt76b_olw","gm_pl_army_t55_olw"];
		ZMM_EAST_Air = ["gm_pl_airforce_mi2p_un"];
		ZMM_EAST_CasH = ["gm_gc_airforce_mi2urn_un","gm_pl_airforce_mi2t_un","gm_pl_airforce_mi2us_un"];
		ZMM_EAST_Convoy = ["gm_pl_army_brdm2_olw","gm_pl_army_brdm2_olw","gm_pl_army_bmp1sp2_olw"];
		ZMM_EAST_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 7: {
		// EAST - Poland Summer (Olive)
		ZMM_EAST_FactionName = "Poland (Olive Summer)";
		ZMM_EAST_Flag = ["gm_flag_PL", "\gm\gm_core\data\flags\gm_flag_PL_co.paa"];
		ZMM_EAST_Man = ["gm_pl_army_grenadier_akm_pallad_80_moro","gm_pl_army_rifleman_akm_80_moro","gm_pl_army_machinegunner_rpk_80_moro","gm_pl_army_rifleman_akm_80_moro","gm_pl_army_antitank_akm_rpg7_80_moro","gm_pl_army_rifleman_akm_80_moro","gm_pl_army_machinegunner_pk_80_moro","gm_pl_army_squadleader_akm_80_moro","gm_pl_army_rifleman_akm_80_moro","gm_pl_army_antiair_akm_9k32m_80_moro"];
		ZMM_EAST_Truck = ["gm_pl_army_ural4320_cargo"];
		ZMM_EAST_Util = ["gm_pl_army_ural4320_reammo","gm_pl_army_ural375d_medic","gm_pl_army_ural4320_repair","gm_pl_army_ural375d_refuel"];
		ZMM_EAST_Light = ["gm_pl_army_brdm2"];
		ZMM_EAST_Medium = ["gm_pl_army_bmp1sp2","gm_pl_army_ot64a"];
		ZMM_EAST_Heavy = ["gm_pl_army_zsu234v1","gm_pl_army_pt76b","gm_pl_army_t55"];
		ZMM_EAST_Air = ["gm_gc_airforce_mi2p"];
		ZMM_EAST_CasH = ["gm_gc_airforce_mi2urn","gm_pl_airforce_mi2t","gm_pl_airforce_mi2us"];
		ZMM_EAST_Convoy = ["gm_pl_army_brdm2","gm_pl_army_brdm2","gm_pl_army_bmp1sp2"];
		ZMM_EAST_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 8: {
		// EAST - EAST GERMANY - Desert
		ZMM_EAST_FactionName = "East Germany (Desert)";
		ZMM_EAST_Flag = ["gm_flag_GC", "\gm\gm_core\data\flags\gm_flag_GC_co.paa"];
		ZMM_EAST_Man = ["gm_gc_army_rifleman_mpiak74n_80_str","gm_gc_army_squadleader_mpiak74n_80_str","gm_gc_army_machinegunner_pk_80_str","gm_gc_army_antitank_mpiak74n_rpg7_80_str","gm_gc_army_squadleader_mpiak74n_80_str"];
		ZMM_EAST_Truck = ["gm_gc_army_ural4320_cargo_des"];
		ZMM_EAST_Util = ["gm_gc_army_ural4320_repair_des","gm_gc_army_ural4320_reammo_des","gm_gc_army_ural375d_medic_des","gm_gc_army_ural375d_refuel_des"];
		ZMM_EAST_Light = ["gm_gc_army_uaz469_dshkm_des","gm_gc_army_uaz469_spg9_des"];
		ZMM_EAST_Medium = ["gm_gc_army_brdm2_des","gm_gc_army_btr60pb_des","gm_gc_army_bmp1sp2_des"];
		ZMM_EAST_Heavy = ["gm_gc_army_t55","gm_gc_army_zsu234v1","gm_gc_army_pt76b"];
		ZMM_EAST_Air = ["gm_gc_airforce_mi2p"];
		ZMM_EAST_CasH = ["gm_gc_airforce_mi2urn"];
		ZMM_EAST_Convoy = ["gm_gc_army_brdm2_des","gm_gc_army_btr60pb_des","gm_gc_army_bmp1sp2_des"];
		ZMM_EAST_Static = ["gm_ge_army_mg3_aatripod"];
	};	
	case 9: {
		// EAST - GMX ChDKz
		ZMM_EAST_FactionName = "ChDKz";
		ZMM_EAST_Flag = ["gm_flag_PL", "\gm\gm_core\data\flags\gm_flag_PL_co.paa"];
		ZMM_EAST_Man = ["gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_squadleader_akm_win","gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_antitank_akm_rpg7_mix","gmx_chdkz_army_machinegunner_rpk_mix","gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_grenadier_akm_pallad_mix"];
		ZMM_EAST_Truck = ["gmx_chdkz_ural4320_cargo_wdr"];
		ZMM_EAST_Util = ["gmx_chdkz_ural4320_repair_wdl","gmx_chdkz_ural4320_reammo_wdl","gmx_chdkz_ural375d_refuel_wdl"];
		ZMM_EAST_Light = ["gmx_chdkz_uaz469_dshkm_wdl","gmx_chdkz_uaz469_spg9_wdl"];
		ZMM_EAST_Medium = ["gmx_chdkz_bmp1sp2_wdl","gmx_chdkz_brdm2_wdl","gmx_chdkz_btr60pb_wdl","gmx_chdkz_ot64a_wdl"];
		ZMM_EAST_Heavy = ["gmx_chdkz_zsu234v1_wdl","gmx_chdkz_t55_wdl","gmx_chdkz_pt76b_wdl","gmx_chdkz_t55_wdl"];
		ZMM_EAST_Air = ["gmx_chdkz_mi2p_wdl"];
		ZMM_EAST_CasH = ["gmx_chdkz_mi2urn_wdl"];
		ZMM_EAST_Convoy = ["gmx_chdkz_brdm2_wdl","gmx_chdkz_btr60pb_wdr","gmx_chdkz_bmp1sp2_wdl"];
		ZMM_EAST_Static = ["gm_ge_army_mg3_aatripod"];
	};
	default {
		// EAST - EAST GERMANY - Olive
		ZMM_EAST_FactionName = "East Germany (Olive)";
		ZMM_EAST_Flag = ["gm_flag_GC", "\gm\gm_core\data\flags\gm_flag_GC_co.paa"];
		ZMM_EAST_Man = ["gm_gc_army_rifleman_mpiak74n_80_str","gm_gc_army_squadleader_mpiak74n_80_str","gm_gc_army_machinegunner_pk_80_str","gm_gc_army_antitank_mpiak74n_rpg7_80_str","gm_gc_army_squadleader_mpiak74n_80_str"];
		ZMM_EAST_Truck = ["gm_gc_army_ural4320_cargo"];
		ZMM_EAST_Util = ["gm_gc_army_ural4320_repair","gm_gc_army_ural4320_reammo","gm_gc_army_ural375d_medic","gm_gc_army_ural375d_refuel"];
		ZMM_EAST_Light = ["gm_gc_army_uaz469_dshkm","gm_gc_army_uaz469_spg9"];
		ZMM_EAST_Medium = ["gm_gc_army_brdm2","gm_gc_army_btr60pb","gm_gc_army_bmp1sp2"];
		ZMM_EAST_Heavy = ["gm_gc_army_t55","gm_gc_army_zsu234v1","gm_gc_army_pt76b"];
		ZMM_EAST_Air = ["gm_gc_airforce_mi2p"];
		ZMM_EAST_CasH = ["gm_gc_airforce_mi2urn"];
		ZMM_EAST_Convoy = ["gm_gc_army_brdm2","gm_gc_army_btr60pb","gm_gc_army_bmp1sp2"];
		ZMM_EAST_Static = ["gm_ge_army_mg3_aatripod"];
	};
};

// Choose Guer Faction
switch (missionNamespace getVariable ["f_param_factionGuer",-1]) do {
	case 1: {
		// GUER - Denmark (Woodland)
		ZMM_GUER_FactionName = "Denmark (Woodland)";
		ZMM_GUER_Flag = ["gm_flag_DK", "\gm\gm_core\data\flags\gm_flag_DK_co.paa"];
		ZMM_GUER_Man = ["gm_dk_army_antiair_gvm95_fim43_90_m84","gm_dk_army_antitank_gvm95_m72a3_90_m84","gm_dk_army_antitank_gvm95_pzf84_90_m84","gm_dk_army_machinegunner_mg3_90_m84","gm_dk_army_marksman_g3a3_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_squadleader_gvm95_p2a1_90_m84"];
		ZMM_GUER_Truck = ["gm_dk_army_u1300l_container"];
		ZMM_GUER_Util = ["gm_dk_army_m113a1dk_medic"];
		ZMM_GUER_Light = ["gm_dk_army_u1300l_container"];
		ZMM_GUER_Medium = ["gm_dk_army_m113a2dk","gm_dk_army_m113a1dk_apc"];
		ZMM_GUER_Heavy = ["gm_dk_army_Leopard1a3"];
		ZMM_GUER_Air = ["gm_ge_army_ch53g","gm_ge_army_bo105m_vbh"];
		ZMM_GUER_CasH = ["gm_ge_army_bo105p_pah1a1"];
		ZMM_GUER_Convoy = ["gm_dk_army_m113a1dk_apc","gm_dk_army_m113a1dk_apc","gm_dk_army_m113a2dk"];
		ZMM_GUER_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 2: {
		// GUER - Denmark (Desert)
		ZMM_GUER_FactionName = "Denmark (Desert)";
		ZMM_GUER_Flag = ["gm_flag_DK", "\gm\gm_core\data\flags\gm_flag_DK_co.paa"];
		ZMM_GUER_Man = ["gm_dk_army_antiair_gvm95_fim43_90_m84","gm_dk_army_antitank_gvm95_m72a3_90_m84","gm_dk_army_antitank_gvm95_pzf84_90_m84","gm_dk_army_machinegunner_mg3_90_m84","gm_dk_army_marksman_g3a3_90_m84","gm_dk_army_rifleman_gvm95_90_m84","gm_dk_army_squadleader_gvm95_p2a1_90_m84"];
		ZMM_GUER_Truck = ["gm_dk_army_u1300l_container_des"];
		ZMM_GUER_Util = ["gm_dk_army_m113a1dk_medic_des"];
		ZMM_GUER_Light = ["gm_dk_army_u1300l_container_des"];
		ZMM_GUER_Medium = ["gm_dk_army_m113a2dk_des","gm_dk_army_m113a1dk_apc_des"];
		ZMM_GUER_Heavy = ["gm_dk_army_Leopard1a3_des"];
		ZMM_GUER_Air = ["gm_ge_army_ch53g","gm_ge_army_bo105m_vbh"];
		ZMM_GUER_CasH = ["gm_ge_army_bo105p_pah1a1"];
		ZMM_GUER_Convoy = ["gm_dk_army_m113a1dk_apc_des","gm_dk_army_m113a1dk_apc_des","gm_dk_army_m113a2dk_des"];
		ZMM_GUER_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 3: {
		// GUER - Denmark (Winter)
		ZMM_GUER_FactionName = "Denmark (Winter)";
		ZMM_GUER_Flag = ["gm_flag_DK", "\gm\gm_core\data\flags\gm_flag_DK_co.paa"];
		ZMM_GUER_Man = ["gm_ge_army_sf_rifleman_g3a4_parka_80_win","gm_ge_army_sf_antitank_mp5a2_pzf84_parka_80_win","gm_ge_army_sf_antiair_mp5a3_fim43_parka_80_win","gm_ge_army_sf_grenadier_hk69a1_parka_80_win","gm_ge_army_sf_machinegunner_g8a2_parka_80_win","gm_ge_army_sf_squadleader_mp5sd3_p2a1_parka_80_win"];
		ZMM_GUER_Truck = ["gm_dk_army_u1300l_container_win"];
		ZMM_GUER_Util = ["gm_dk_army_m113a1dk_medic_win"];
		ZMM_GUER_Light = ["gm_dk_army_u1300l_container_win"];
		ZMM_GUER_Medium = ["gm_dk_army_m113a2dk_win","gm_dk_army_m113a1dk_apc_win"];
		ZMM_GUER_Heavy = ["gm_dk_army_Leopard1a3_win"];
		ZMM_GUER_Air = ["gm_ge_army_ch53g_un","gm_ge_army_bo105m_vbh_un"];
		ZMM_GUER_CasH = ["gm_ge_army_bo105p_pah1a1_un"];
		ZMM_GUER_Convoy = ["gm_dk_army_m113a1dk_apc_win","gm_dk_army_m113a1dk_apc_win","gm_dk_army_m113a2dk_win"];
		ZMM_GUER_Static = ["gm_ge_army_mg3_aatripod"];		
	};
	case 4: {
		// GUER - Poland Winter
		ZMM_GUER_FactionName = "Poland (Winter)";
		ZMM_GUER_Flag = ["gm_flag_PL", "\gm\gm_core\data\flags\gm_flag_PL_co.paa"];
		ZMM_GUER_Man = ["gm_pl_army_rifleman_akm_80_win","gm_pl_army_squadleader_akm_80_win","gm_pl_army_machinegunner_pk_80_win","gm_pl_army_antitank_akm_rpg7_80_win"];
		ZMM_GUER_Truck = ["gm_pl_army_ural4320_cargo_win"];
		ZMM_GUER_Util = ["gm_pl_army_ural4320_reammo_olw","gm_pl_army_ural375d_medic_olw","gm_pl_army_ural4320_repair_olw","gm_pl_army_ural375d_refuel_olw"];
		ZMM_GUER_Light = ["gm_pl_army_brdm2_olw"];
		ZMM_GUER_Medium = ["gm_pl_army_bmp1sp2_olw","gm_pl_army_ot64a_olw"];
		ZMM_GUER_Heavy = ["gm_pl_army_zsu234v1_olw","gm_pl_army_pt76b_olw","gm_pl_army_t55_olw"];
		ZMM_GUER_Air = ["gm_pl_airforce_mi2p_un"];
		ZMM_GUER_CasH = ["gm_gc_airforce_mi2urn_un","gm_pl_airforce_mi2t_un","gm_pl_airforce_mi2us_un"];
		ZMM_GUER_Convoy = ["gm_pl_army_brdm2_olw","gm_pl_army_brdm2_olw","gm_pl_army_bmp1sp2_olw"];
		ZMM_GUER_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 5: {
		// GUER - GMX Revolutionaries
		ZMM_GUER_FactionName = "Revolutionaries";
		ZMM_GUER_Flag = ["gm_flag_PL", "\gm\gm_core\data\flags\gm_flag_PL_co.paa"];
		ZMM_GUER_Man = ["gm_xx_army_squadleader_m16a1_80_grn","gm_xx_army_rifleman_01_akm_alp","gm_xx_army_machinegunner_rpk_80_oli","gm_xx_army_assault_ak74nk_80_wdl","gm_xx_army_antitank_hk53a2_rpg7_80_oli"];
		ZMM_GUER_Truck = ["gmx_chdkz_ural4320_cargo_wdl"];
		ZMM_GUER_Util = ["gmx_chdkz_ural4320_repair_wdl","gmx_chdkz_ural4320_reammo_wdl","gmx_chdkz_ural375d_refuel_wdl"];
		ZMM_GUER_Light = ["gmx_chdkz_uaz469_dshkm_wdl","gmx_chdkz_uaz469_spg9_wdl"];
		ZMM_GUER_Medium = ["gmx_chdkz_bmp1sp2_wdl","gmx_chdkz_brdm2_wdl","gmx_chdkz_btr60pb_wdl","gmx_chdkz_ot64a_wdl"];
		ZMM_GUER_Heavy = ["gmx_chdkz_zsu234v1_wdl","gmx_chdkz_t55_wdl","gmx_chdkz_pt76b_wdl","gmx_chdkz_t55_wdl"];
		ZMM_GUER_Air = ["gmx_chdkz_mi2p_wdl"];
		ZMM_GUER_CasH = ["gmx_chdkz_mi2urn_wdl"];
		ZMM_GUER_Convoy = ["gmx_chdkz_brdm2_wdl","gmx_chdkz_btr60pb_wdr","gmx_chdkz_bmp1sp2_wdl"];
		ZMM_GUER_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 6: {
		// GUER - GMX SYNDIKAT
		ZMM_GUER_FactionName = "Syndikat";
		ZMM_GUER_Flag = ["Flag_Syndikat_F", "\A3\Data_F_Exp\Flags\flag_SYND_CO.paa"];
		ZMM_GUER_Man = ["I_C_Soldier_Para_7_F","I_C_Soldier_Para_5_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_2_F","I_C_Soldier_Para_6_F","I_C_Soldier_Para_1_F"];
		ZMM_GUER_Truck = ["gmx_chdkz_ural4320_cargo_wdl"];
		ZMM_GUER_Util = ["gmx_chdkz_ural4320_repair_wdl","gmx_chdkz_ural4320_reammo_wdl","gmx_chdkz_ural375d_refuel_wdl"];
		ZMM_GUER_Light = ["gmx_chdkz_uaz469_dshkm_wdl","gmx_chdkz_uaz469_spg9_wdl"];
		ZMM_GUER_Medium = ["gmx_chdkz_bmp1sp2_wdl","gmx_chdkz_brdm2_wdl","gmx_chdkz_btr60pb_wdl","gmx_chdkz_ot64a_wdl"];
		ZMM_GUER_Heavy = ["gmx_chdkz_zsu234v1_wdl","gmx_chdkz_t55_wdl","gmx_chdkz_pt76b_wdl","gmx_chdkz_t55_wdl"];
		ZMM_GUER_Air = ["gmx_chdkz_mi2p_wdl"];
		ZMM_GUER_CasH = ["gmx_chdkz_mi2urn_wdl"];
		ZMM_GUER_Convoy = ["gmx_chdkz_brdm2_wdl","gmx_chdkz_btr60pb_wdr","gmx_chdkz_bmp1sp2_wdl"];
		ZMM_GUER_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 7: {
		// GUER - AAF 1990
		ZMM_GUER_FactionName = "AAF 1990";
		ZMM_GUER_Flag = ["Flag_AAF_F", "\A3\Data_F_Exp\Flags\Flag_AAF_CO.paa"];
		ZMM_GUER_Man = ["I_Soldier_F","I_Soldier_LAT_F","I_Soldier_GL_F","I_Soldier_AR_F"];
		ZMM_GUER_Truck = ["gmx_aaf_u1300l_cargo_wdl"];
		ZMM_GUER_Util = ["gmx_aaf_kat1_451_reammo_wdl","gmx_aaf_kat1_451_refuel_wdl","gmx_aaf_u1300l_repair_wdl","gmx_aaf_u1300l_medic_wdl"];
		ZMM_GUER_Light = ["gmx_aaf_fuchsa0_engineer_wdl","gmx_aaf_iltis_milan_wdl"];
		ZMM_GUER_Medium = ["gmx_aaf_luchsa2_wdl","gmx_aaf_marder1a2_wdl"];
		ZMM_GUER_Heavy = ["gmx_aaf_gepard1a1_wdl","gmx_aaf_leopard1a5_wdl","gmx_aaf_leopard1a5_wdl"];
		ZMM_GUER_Air = [["I_Heli_light_03_unarmed_F","[_grpVeh,['Indep',1]] call BIS_fnc_initVehicle;"],"I_Heli_Transport_02_F", ["O_Heli_Light_02_unarmed_F","_grpVeh setObjectTextureGlobal [0,'\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa'];"], ["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0,'A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa'];"]];
		ZMM_GUER_CasH = ["O_Heli_Light_02_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0,'\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa']; _grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"];
		ZMM_GUER_CasP = ["I_Plane_Fighter_03_dynamicLoadout_F"];
		ZMM_GUER_Convoy = ["gmx_aaf_luchsa2_wdl","gmx_aaf_fuchsa0_engineer_wdl","gmx_aaf_marder1a2_wdl"];
		ZMM_GUER_Static = ["gm_ge_army_mg3_aatripod"];
	};
	case 8: {
		// GUER - GMX ChDKz
		ZMM_GUER_FactionName = "ChDKz";
		ZMM_GUER_Flag = ["gm_flag_PL", "\gm\gm_core\data\flags\gm_flag_PL_co.paa"];
		ZMM_GUER_Man = ["gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_squadleader_akm_win","gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_antitank_akm_rpg7_mix","gmx_chdkz_army_machinegunner_rpk_mix","gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_grenadier_akm_pallad_mix"];
		ZMM_GUER_Truck = ["gmx_chdkz_ural4320_cargo_wdl"];
		ZMM_GUER_Util = ["gmx_chdkz_ural4320_repair_wdl","gmx_chdkz_ural4320_reammo_wdl","gmx_chdkz_ural375d_refuel_wdl"];
		ZMM_GUER_Light = ["gmx_chdkz_uaz469_dshkm_wdl","gmx_chdkz_uaz469_spg9_wdl"];
		ZMM_GUER_Medium = ["gmx_chdkz_bmp1sp2_wdl","gmx_chdkz_brdm2_wdl","gmx_chdkz_btr60pb_wdl","gmx_chdkz_ot64a_wdl"];
		ZMM_GUER_Heavy = ["gmx_chdkz_zsu234v1_wdl","gmx_chdkz_t55_wdl","gmx_chdkz_pt76b_wdl","gmx_chdkz_t55_wdl"];
		ZMM_GUER_Air = ["gmx_chdkz_mi2p_wdl"];
		ZMM_GUER_CasH = ["gmx_chdkz_mi2urn_wdl"];
		ZMM_GUER_Convoy = ["gmx_chdkz_brdm2_wdl","gmx_chdkz_btr60pb_wdr","gmx_chdkz_bmp1sp2_wdl"];
		ZMM_GUER_Static = ["gm_ge_army_mg3_aatripod"];
	};
	default {
		// GUER - Poland Summer
		ZMM_GUER_FactionName = "Poland (Summer)";
		ZMM_GUER_Flag = ["gm_flag_PL", "\gm\gm_core\data\flags\gm_flag_PL_co.paa"];
		ZMM_GUER_Man = ["gm_pl_army_grenadier_akm_pallad_80_moro","gm_pl_army_rifleman_akm_80_moro","gm_pl_army_machinegunner_rpk_80_moro","gm_pl_army_rifleman_akm_80_moro","gm_pl_army_antitank_akm_rpg7_80_moro","gm_pl_army_rifleman_akm_80_moro","gm_pl_army_machinegunner_pk_80_moro","gm_pl_army_squadleader_akm_80_moro","gm_pl_army_rifleman_akm_80_moro","gm_pl_army_antiair_akm_9k32m_80_moro"];
		ZMM_GUER_Truck = ["gm_pl_army_ural4320_cargo"];
		ZMM_GUER_Util = ["gm_pl_army_ural4320_reammo","gm_pl_army_ural375d_medic","gm_pl_army_ural4320_repair","gm_pl_army_ural375d_refuel"];
		ZMM_GUER_Light = ["gm_pl_army_brdm2"];
		ZMM_GUER_Medium = ["gm_pl_army_bmp1sp2","gm_pl_army_ot64a"];
		ZMM_GUER_Heavy = ["gm_pl_army_zsu234v1","gm_pl_army_pt76b","gm_pl_army_t55"];
		ZMM_GUER_Air = ["gm_gc_airforce_mi2p"];
		ZMM_GUER_CasH = ["gm_gc_airforce_mi2urn","gm_pl_airforce_mi2t","gm_pl_airforce_mi2us"];
		ZMM_GUER_Convoy = ["gm_pl_army_brdm2","gm_pl_army_brdm2","gm_pl_army_bmp1sp2"];
		ZMM_GUER_Static = ["gm_ge_army_mg3_aatripod"];
	};
};