// Choose West Faction
switch (missionNamespace getVariable ["f_param_factionWest",-1]) do {
	case 1: {
		// WEST - NATO (DESERT)
		ZMM_WESTFlag = ["Flag_ION_F", "\A3\Data_F\Flags\flag_ion_CO.paa"];
		ZMM_WESTMan = ["B_D_Soldier_lxWS","B_D_soldier_LAT2_lxWS","B_D_Soldier_TL_lxWS","B_D_soldier_AR_lxWS","B_D_Soldier_GL_lxWS"];
		ZMM_WESTGrp_Sentry = [[["B_D_Soldier_GL_lxWS","B_D_Soldier_lxWS","B_D_Soldier_lxWS"]]];
		ZMM_WESTGrp_Team = [[["B_D_Soldier_GL_lxWS","B_D_Soldier_lxWS","B_D_soldier_AR_lxWS","B_D_soldier_LAT2_lxWS","B_D_Soldier_lxWS"]]];
		ZMM_WESTGrp_Squad = [[["B_D_Soldier_GL_lxWS","B_D_Soldier_lxWS","B_D_soldier_AR_lxWS","B_D_soldier_LAT2_lxWS","B_D_Soldier_lxWS","B_D_Soldier_lxWS","B_D_soldier_AR_lxWS","B_D_soldier_LAT2_lxWS","B_D_Soldier_lxWS","B_D_Soldier_lxWS"]]];
		ZMM_WESTVeh_Truck = ["B_D_Truck_01_covered_lxWS"];
		ZMM_WESTVeh_Util = ["B_D_Truck_01_Repair_lxWS","B_D_Truck_01_fuel_lxWS","B_D_Truck_01_ammo_lxWS"];
		ZMM_WESTVeh_Light = ["B_D_MRAP_01_hmg_lxWS","B_D_MRAP_01_gmg_lxWS"];
		ZMM_WESTVeh_Medium = [["B_D_APC_Wheeled_01_cannon_lxWS","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["B_D_APC_Wheeled_01_atgm_lxWS","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Heavy = ["B_D_MBT_01_TUSK_lxWS",["B_D_APC_Tracked_01_aa_lxWS","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Air = ["B_D_Heli_Light_01_lxWS","B_D_Heli_Transport_01_lxWS"];
		ZMM_WESTVeh_CasH = ["B_D_Heli_Light_01_dynamicLoadout_lxWS","B_D_Heli_Attack_01_dynamicLoadout_lxWS"];
		ZMM_WESTVeh_CasP = ["B_D_Plane_CAS_01_dynamicLoadout_lxWS"];
		ZMM_WESTVeh_Convoy = ["B_D_MRAP_01_hmg_lxWS","B_D_MRAP_01_lxWS",["B_D_APC_Wheeled_01_cannon_lxWS","[_grpVeh,false,['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Static = ["B_Tura_HMG_02_high_lxWS"];
	};
	case 2: {
		// WEST - UNA
		ZMM_WESTFlag = ["Flag_UNO_F", "\lxws\data_f_lxws\img\flags\flag_una_CO.paa"];
		ZMM_WESTMan = ["B_UN_soldier_AR_lxWS","B_UN_engineer_lxWS","B_UN_soldier_repair_lxWS","B_UN_Soldier_lxWS","B_UN_Soldier_TL_lxWS"];
		ZMM_WESTGrp_Sentry = [[["B_UN_Soldier_TL_lxWS","B_UN_Soldier_lxWS","B_UN_Soldier_lxWS"]]];
		ZMM_WESTGrp_Team = [[["B_UN_Soldier_TL_lxWS","B_UN_soldier_AR_lxWS","B_UN_Soldier_lxWS","B_UN_Soldier_lxWS","B_UN_Soldier_lxWS"]]];
		ZMM_WESTGrp_Squad = [[["B_UN_Soldier_TL_lxWS","B_UN_soldier_AR_lxWS","B_UN_soldier_repair_lxWS","B_UN_Soldier_lxWS","B_UN_Soldier_lxWS","B_UN_Soldier_lxWS","B_UN_soldier_AR_lxWS","B_UN_Soldier_lxWS","B_UN_Soldier_lxWS","B_UN_Soldier_lxWS"]]];
		ZMM_WESTVeh_Truck = ["B_ION_Truck_02_covered_lxWS"];
		ZMM_WESTVeh_Util = ["B_UN_Truck_01_fuel_lxWS","B_UN_Truck_01_medical_lxWS","B_UN_Truck_01_Repair_lxWS"];
		ZMM_WESTVeh_Light = ["B_ION_Offroad_armed_lxWS"];
		ZMM_WESTVeh_Medium = [["B_ION_APC_Wheeled_01_command_lxWS","[_grpVeh,['BLACK',0.5],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Heavy = ["B_MBT_03_cannon_lxWS"];
		ZMM_WESTVeh_Air = ["B_UN_Heli_Transport_02_lxWS"];
		ZMM_WESTVeh_CasH = ["B_ION_Heli_Light_02_dynamicLoadout_lxWS"];
		ZMM_WESTVeh_CasP = ["B_D_Plane_CAS_01_dynamicLoadout_lxWS"];
		ZMM_WESTVeh_Convoy = ["B_ION_Offroad_armed_lxWS","B_ION_Offroad_lxWS",["B_ION_APC_Wheeled_01_command_lxWS","[_grpVeh,['BLACK',0.5],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Static = ["B_Tura_HMG_02_high_lxWS"];
	};
	default {
		// WEST - ION
		ZMM_WESTFlag = ["Flag_ION_F", "\A3\Data_F\Flags\flag_ion_CO.paa"];
		ZMM_WESTMan = ["B_ION_soldier_AR_lxWS","B_ION_Soldier_GL_lxWS","B_ION_shot_lxWS","B_ION_TL_lxWS","B_ION_Soldier_lxWS","B_ION_medic_lxWS"];
		ZMM_WESTGrp_Sentry = [[["B_ION_Soldier_GL_lxWS","B_ION_Soldier_lxWS","B_ION_Soldier_lxWS"]]];
		ZMM_WESTGrp_Team = [[["B_ION_Soldier_GL_lxWS","B_ION_shot_lxWS","B_ION_Soldier_lxWS","B_ION_soldier_AR_lxWS","B_ION_Soldier_lxWS"]]];
		ZMM_WESTGrp_Squad = [[["B_ION_TL_lxWS","B_ION_Soldier_GL_lxWS","B_ION_medic_lxWS","B_ION_Soldier_lxWS","B_ION_soldier_AR_lxWS","B_ION_Soldier_GL_lxWS","B_ION_shot_lxWS","B_ION_Soldier_lxWS","B_ION_soldier_AR_lxWS","B_ION_Soldier_lxWS"]]];
		ZMM_WESTVeh_Truck = ["B_ION_Truck_02_covered_lxWS"];
		ZMM_WESTVeh_Util = ["B_UN_Truck_01_fuel_lxWS","B_UN_Truck_01_medical_lxWS","B_UN_Truck_01_Repair_lxWS"];
		ZMM_WESTVeh_Light = ["B_ION_Offroad_armed_lxWS"];
		ZMM_WESTVeh_Medium = [["B_ION_APC_Wheeled_01_command_lxWS","[_grpVeh,['BLACK',0.5],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Heavy = [["B_ION_APC_Wheeled_01_command_lxWS","[_grpVeh,['BLACK',0.5],['showSLATHull',0.5,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Air = ["B_ION_Heli_Light_02_unarmed_lxWS"];
		ZMM_WESTVeh_CasH = ["B_ION_Heli_Light_02_dynamicLoadout_lxWS"];
		ZMM_WESTVeh_CasP = [["I_Plane_Fighter_04_F","[_grpVeh,['CamoGrey',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Convoy = ["B_ION_Offroad_armed_lxWS","B_ION_Offroad_lxWS",["B_ION_APC_Wheeled_01_command_lxWS","[_grpVeh,['BLACK',0.5],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Static = ["B_Tura_HMG_02_high_lxWS"];
	};
};

// Choose East Faction
switch (missionNamespace getVariable ["f_param_factionEast",-1]) do {
	default {
		// EAST - SFIA
		ZMM_EASTFlag = ["Flag_SFIA_lxWS", "\lxws\data_f_lxws\img\flags\flag_SFIA_CO.paa"];
		ZMM_EASTMan = ["O_SFIA_soldier_lxWS","O_SFIA_Soldier_AR_lxWS","O_SFIA_soldier_at_lxWS","O_SFIA_Soldier_TL_lxWS","O_SFIA_Soldier_GL_lxWS"];
		ZMM_EASTGrp_Sentry = [[["O_SFIA_Soldier_GL_lxWS","O_SFIA_soldier_lxWS","O_SFIA_soldier_lxWS"]]];
		ZMM_EASTGrp_Team = [[["O_SFIA_Soldier_GL_lxWS","O_SFIA_soldier_at_lxWS","O_SFIA_soldier_lxWS","O_SFIA_Soldier_AR_lxWS","O_SFIA_soldier_lxWS"]]];
		ZMM_EASTGrp_Squad = [[["O_SFIA_Soldier_GL_lxWS","O_SFIA_Soldier_TL_lxWS","O_SFIA_soldier_at_lxWS","O_SFIA_soldier_lxWS","O_SFIA_Soldier_AR_lxWS","O_SFIA_soldier_at_lxWS","O_SFIA_soldier_lxWS","O_SFIA_soldier_lxWS","O_SFIA_Soldier_AR_lxWS","O_SFIA_soldier_lxWS"]]];
		ZMM_EASTVeh_Truck = ["O_SFIA_Truck_02_covered_lxWS"];
		ZMM_EASTVeh_Util = ["O_SFIA_Truck_02_box_lxWS","O_SFIA_Truck_02_fuel_lxWS","O_SFIA_Truck_02_Ammo_lxWS"];
		ZMM_EASTVeh_Light = ["O_Tura_Offroad_armor_AT_lxWS","O_Tura_Offroad_armor_armed_lxWS"];
		ZMM_EASTVeh_Medium = ["O_SFIA_Truck_02_aa_lxWS",["O_SFIA_APC_Tracked_02_cannon_lxWS","[_grpVeh,false,['showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["O_SFIA_APC_Tracked_02_AA_lxWS","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_SFIA_APC_Tracked_02_cannon_lxWS","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',1]] call BIS_fnc_initVehicle;"],["O_SFIA_MBT_02_cannon_lxWS","[_grpVeh,false,['showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = [["O_Heli_Transport_04_covered_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_CasH = ["O_SFIA_Heli_Attack_02_dynamicLoadout_lxWS"];
		ZMM_EASTVeh_Convoy = ["O_Tura_Offroad_armor_armed_lxWS","O_SFIA_Truck_02_covered_lxWS",["O_SFIA_APC_Tracked_02_cannon_lxWS","[_grpVeh,false,['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Static = ["O_SFIA_HMG_02_high_lxWS"];
	};
};

// Choose Guer Faction
switch (missionNamespace getVariable ["f_param_factionGuer",-1]) do {
	default {
		// GUER - TURA
		ZMM_GUERFlag = ["Flag_Argana_F_lxWS", "\lxws\data_f_lxws\img\flags\flag_Argana_CO.paa"];
		ZMM_GUERMan = ["I_SFIA_enforcer_lxWS","I_SFIA_hireling_lxWS","I_SFIA_scout_lxWS","I_SFIA_medic2_lxWS","I_SFIA_thug_lxWS","I_SFIA_watcher_lxWS"];
		ZMM_GUERGrp_Sentry = [[["I_SFIA_enforcer_lxWS","I_SFIA_hireling_lxWS","I_SFIA_watcher_lxWS"]]];
		ZMM_GUERGrp_Team = [[["I_SFIA_thug_lxWS","I_SFIA_enforcer_lxWS","I_SFIA_scout_lxWS","I_SFIA_hireling_lxWS","I_SFIA_scout_lxWS"]]];
		ZMM_GUERGrp_Squad = [[["I_SFIA_thug_lxWS","I_SFIA_enforcer_lxWS","I_SFIA_scout_lxWS","I_SFIA_hireling_lxWS","I_SFIA_thug_lxWS","I_SFIA_scout_lxWS","I_SFIA_hireling_lxWS","I_SFIA_medic2_lxWS"]]];
		ZMM_GUERVeh_Truck = ["I_C_Van_02_transport_F"];
		ZMM_GUERVeh_Util = ["O_SFIA_Truck_02_box_lxWS","O_SFIA_Truck_02_fuel_lxWS","O_SFIA_Truck_02_Ammo_lxWS"];
		ZMM_GUERVeh_Light = ["I_Tura_Offroad_armor_AT_lxWS","I_Tura_Offroad_armor_armed_lxWS"];
		ZMM_GUERVeh_Medium = ["I_Tura_Truck_02_aa_lxWS",["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showCamonetHull',0.5,'showSLATHull',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Air = ["O_Heli_Light_02_unarmed_F"];
		ZMM_GUERVeh_CasH = ["B_Heli_Light_01_dynamicLoadout_F"];
		ZMM_GUERVeh_Convoy = ["I_C_Offroad_02_LMG_F","I_C_Van_02_transport_F",["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showCamonetHull',0.5,'showSLATHull',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Static = ["I_Tura_HMG_02_high_lxWS"];
	};
};