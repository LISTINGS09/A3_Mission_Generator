// Choose West Faction
switch (missionNamespace getVariable ["f_param_factionWest",-1]) do {	
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
	default {
		// EAST - RU MSV
		ZMM_EASTFlag = ["rhs_Flag_Russia_F", "\ca\data\flag_rus_co.paa"];
		ZMM_EASTMan = ["rhs_msv_rifleman","rhs_msv_grenadier","rhs_msv_rifleman","rhs_msv_LAT","rhs_msv_rifleman","rhs_msv_grenadier_rpg","rhs_msv_rifleman","rhs_msv_machinegunner"];
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
};

// Choose Guer Faction
switch (missionNamespace getVariable ["f_param_factionGuer",-1]) do {	
	default {
		// GUER - NAPA
		ZMM_GUERFlag = ["Flag_Enoch_F", "\a3\Data_F_Enoch\Flags\flag_Enoch_CO.paa"];
		ZMM_GUERMan = ["rhsgref_nat_pmil_machinegunner","rhsgref_nat_pmil_grenadier","rhsgref_nat_pmil_grenadier_rpg","rhsgref_nat_pmil_rifleman_aksu"];
		ZMM_GUERGrp_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_nationalist" >> "rhsgref_group_national_infantry" >> "rhsgref_group_national_infantry_at"];
		ZMM_GUERGrp_Team = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_nationalist" >> "rhsgref_group_national_infantry" >> "rhsgref_group_national_infantry_patrol"];
		ZMM_GUERGrp_Squad = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_nationalist" >> "rhsgref_group_national_infantry" >> "rhsgref_group_national_infantry_squad_2"];
		ZMM_GUERVeh_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_nationalist" >> "rhs_group_indp_nat_ural" >> "rhs_group_nat_ural_squad"];
		ZMM_GUERVeh_Util = ["rhs_gaz66_ammo_msv","RHS_Ural_Fuel_MSV_01","RHS_Ural_Repair_MSV_01"];
		ZMM_GUERVeh_Light = ["rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9","rhsgref_nat_uaz_dshkm","rhsgref_nat_btr70"];
		ZMM_GUERVeh_Medium = ["rhsgref_nat_btr70","rhsgref_ins_g_bmp1k"];
		ZMM_GUERVeh_Heavy = ["rhsgref_ins_g_bmp2k","rhsgref_ins_g_zsu234","rhsgref_ins_g_t72bc"];
		ZMM_GUERVeh_Air = ["rhsgref_cdf_reg_Mi8amt"];
		ZMM_GUERVeh_CasH = ["rhsgref_cdf_Mi35"];
		ZMM_GUERVeh_CasP = ["rhsgref_cdf_su25"];
		ZMM_GUERVeh_Convoy = ["rhsgref_nat_uaz_dshkm","rhsgref_nat_ural","rhsgref_nat_btr70"];
		ZMM_GUERVeh_Static = ["rhsgref_nat_DSHKM"];
	};
};