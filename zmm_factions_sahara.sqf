// Choose West Faction
switch (missionNamespace getVariable ["f_param_factionWest",-1]) do {
	case 1: {
		// WEST - NATO (DESERT)
		ZMM_WEST_FactionName = "NATO (Desert)";
		ZMM_WEST_Flag = ["Flag_ION_F", "\A3\Data_F\Flags\flag_ion_CO.paa"];
		ZMM_WEST_Man = ["B_D_Soldier_lxWS","B_D_soldier_LAT2_lxWS","B_D_Soldier_TL_lxWS","B_D_soldier_AR_lxWS","B_D_Soldier_GL_lxWS"];
		ZMM_WEST_Truck = ["B_D_Truck_01_covered_lxWS"];
		ZMM_WEST_Util = ["B_D_Truck_01_Repair_lxWS","B_D_Truck_01_fuel_lxWS","B_D_Truck_01_ammo_lxWS"];
		ZMM_WEST_Light = ["B_D_MRAP_01_hmg_lxWS","B_D_MRAP_01_gmg_lxWS"];
		ZMM_WEST_Medium = [["B_D_APC_Wheeled_01_cannon_lxWS","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["B_D_APC_Wheeled_01_atgm_lxWS","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Heavy = ["B_D_MBT_01_TUSK_lxWS",["B_D_APC_Tracked_01_aa_lxWS","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Air = ["B_D_Heli_Light_01_lxWS","B_D_Heli_Transport_01_lxWS"];
		ZMM_WEST_CasH = ["B_D_Heli_Light_01_dynamicLoadout_lxWS","B_D_Heli_Attack_01_dynamicLoadout_lxWS"];
		ZMM_WEST_CasP = ["B_D_Plane_CAS_01_dynamicLoadout_lxWS"];
		ZMM_WEST_Convoy = ["B_D_MRAP_01_hmg_lxWS","B_D_MRAP_01_lxWS",["B_D_APC_Wheeled_01_cannon_lxWS","[_grpVeh,false,['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Static = ["B_Tura_HMG_02_high_lxWS"];
	};
	case 2: {
		// WEST - UNA
		ZMM_WEST_FactionName = "UNA";
		ZMM_WEST_Flag = ["Flag_UNO_F", "\lxws\data_f_lxws\img\flags\flag_una_CO.paa"];
		ZMM_WEST_Man = ["B_UN_soldier_AR_lxWS","B_UN_engineer_lxWS","B_UN_soldier_repair_lxWS","B_UN_Soldier_lxWS","B_UN_Soldier_TL_lxWS"];
		ZMM_WEST_Truck = ["B_ION_Truck_02_covered_lxWS"];
		ZMM_WEST_Util = ["B_UN_Truck_01_fuel_lxWS","B_UN_Truck_01_medical_lxWS","B_UN_Truck_01_Repair_lxWS"];
		ZMM_WEST_Light = ["B_ION_Offroad_armed_lxWS"];
		ZMM_WEST_Medium = [["B_ION_APC_Wheeled_01_command_lxWS","[_grpVeh,['BLACK',0.5],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Heavy = ["B_MBT_03_cannon_lxWS"];
		ZMM_WEST_Air = ["B_UN_Heli_Transport_02_lxWS"];
		ZMM_WEST_CasH = ["B_ION_Heli_Light_02_dynamicLoadout_lxWS"];
		ZMM_WEST_CasP = ["B_D_Plane_CAS_01_dynamicLoadout_lxWS"];
		ZMM_WEST_Convoy = ["B_ION_Offroad_armed_lxWS","B_ION_Offroad_lxWS",["B_ION_APC_Wheeled_01_command_lxWS","[_grpVeh,['BLACK',0.5],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Static = ["B_Tura_HMG_02_high_lxWS"];
	};
	default {
		// WEST - ION
		ZMM_WEST_FactionName = "ION";
		ZMM_WEST_Flag = ["Flag_ION_F", "\A3\Data_F\Flags\flag_ion_CO.paa"];
		ZMM_WEST_Man = ["B_ION_soldier_AR_lxWS","B_ION_Soldier_GL_lxWS","B_ION_shot_lxWS","B_ION_TL_lxWS","B_ION_Soldier_lxWS","B_ION_medic_lxWS"];
		ZMM_WEST_Truck = ["B_ION_Truck_02_covered_lxWS"];
		ZMM_WEST_Util = ["B_UN_Truck_01_fuel_lxWS","B_UN_Truck_01_medical_lxWS","B_UN_Truck_01_Repair_lxWS"];
		ZMM_WEST_Light = ["B_ION_Offroad_armed_lxWS"];
		ZMM_WEST_Medium = [["B_ION_APC_Wheeled_01_command_lxWS","[_grpVeh,['BLACK',0.5],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Heavy = [["B_ION_APC_Wheeled_01_command_lxWS","[_grpVeh,['BLACK',0.5],['showSLATHull',0.5,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Air = ["B_ION_Heli_Light_02_unarmed_lxWS"];
		ZMM_WEST_CasH = ["B_ION_Heli_Light_02_dynamicLoadout_lxWS"];
		ZMM_WEST_CasP = [["I_Plane_Fighter_04_F","[_grpVeh,['CamoGrey',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Convoy = ["B_ION_Offroad_armed_lxWS","B_ION_Offroad_lxWS",["B_ION_APC_Wheeled_01_command_lxWS","[_grpVeh,['BLACK',0.5],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Static = ["B_Tura_HMG_02_high_lxWS"];
	};
};

// Choose East Faction
switch (missionNamespace getVariable ["f_param_factionEast",-1]) do {
	default {
		// EAST - SFIA
		ZMM_EAST_FactionName = "SFIA";
		ZMM_EAST_Flag = ["Flag_SFIA_lxWS", "\lxws\data_f_lxws\img\flags\flag_SFIA_CO.paa"];
		ZMM_EAST_Man = ["O_SFIA_soldier_lxWS","O_SFIA_Soldier_AR_lxWS","O_SFIA_soldier_at_lxWS","O_SFIA_Soldier_TL_lxWS","O_SFIA_HeavyGunner_lxWS","O_SFIA_Soldier_GL_lxWS"];
		ZMM_EAST_Truck = ["O_SFIA_Truck_02_covered_lxWS"];
		ZMM_EAST_Util = ["O_SFIA_Truck_02_box_lxWS","O_SFIA_Truck_02_fuel_lxWS","O_SFIA_Truck_02_Ammo_lxWS"];
		ZMM_EAST_Light = ["O_Tura_Offroad_armor_AT_lxWS","O_Tura_Offroad_armor_armed_lxWS"];
		ZMM_EAST_Medium = ["O_SFIA_APC_Wheeled_02_hmg_lxWS","O_SFIA_Truck_02_aa_lxWS","O_SFIA_APC_Wheeled_02_hmg_lxWS",["O_SFIA_APC_Tracked_02_cannon_lxWS","[_grpVeh,false,['showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],"O_SFIA_APC_Wheeled_02_hmg_lxWS"];
		ZMM_EAST_Heavy = [["O_SFIA_APC_Tracked_02_AA_lxWS","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_SFIA_APC_Tracked_02_cannon_lxWS","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',1]] call BIS_fnc_initVehicle;"],["O_SFIA_APC_Tracked_02_30mm_lxWS","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',1]] call BIS_fnc_initVehicle;"],["O_SFIA_MBT_02_cannon_lxWS","[_grpVeh,false,['showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Air = [["O_Heli_Transport_04_covered_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_CasH = ["O_SFIA_Heli_Attack_02_dynamicLoadout_lxWS"];
		ZMM_EAST_Convoy = ["O_Tura_Offroad_armor_armed_lxWS","O_SFIA_Truck_02_covered_lxWS",["O_SFIA_APC_Tracked_02_cannon_lxWS","[_grpVeh,false,['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Static = ["O_SFIA_HMG_02_high_lxWS"];
	};
};

// Choose Guer Faction
switch (missionNamespace getVariable ["f_param_factionGuer",-1]) do {
	default {
		// GUER - TURA
		ZMM_GUER_FactionName = "TURA";
		ZMM_GUER_Flag = ["Flag_Argana_F_lxWS", "\lxws\data_f_lxws\img\flags\flag_Argana_CO.paa"];
		ZMM_GUER_Man = ["I_SFIA_enforcer_lxWS","I_SFIA_hireling_lxWS","I_SFIA_scout_lxWS","I_SFIA_medic2_lxWS","I_SFIA_thug_lxWS","I_SFIA_watcher_lxWS"];
		ZMM_GUER_Truck = ["O_SFIA_Truck_02_covered_lxWS"];
		ZMM_GUER_Util = ["O_SFIA_Truck_02_box_lxWS","O_SFIA_Truck_02_fuel_lxWS","O_SFIA_Truck_02_Ammo_lxWS"];
		ZMM_GUER_Light = ["I_Tura_Offroad_armor_AT_lxWS","I_Tura_Offroad_armor_armed_lxWS"];
		ZMM_GUER_Medium = ["I_Tura_Truck_02_aa_lxWS",["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showCamonetHull',0.5,'showSLATHull',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_Air = ["O_Heli_Light_02_unarmed_F"];
		ZMM_GUER_CasH = ["B_Heli_Light_01_dynamicLoadout_F"];
		ZMM_GUER_Convoy = ["I_C_Offroad_02_LMG_F","I_C_Van_02_transport_F",["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showCamonetHull',0.5,'showSLATHull',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_Static = ["I_Tura_HMG_02_high_lxWS"];
	};
};