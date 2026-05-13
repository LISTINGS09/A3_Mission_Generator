// Choose West Faction
switch (missionNamespace getVariable ["f_param_factionWest",-1]) do {
	case 1: {
		// WEST - Germany (Sturmtroopers)
		ZMM_WEST_FactionName = "Germany (Sturmtroopers)";
		ZMM_WEST_Flag = ["SPE_FlagCarrier_GER", "\WW2\SPE_Core_t\Data_t\Flags\flag_GER_co.paa"];
		ZMM_WEST_Man = ["SPE_sturmtrooper_SquadLead","SPE_sturmtrooper_mgunner","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_medic","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_stggunner","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_amgunner","SPE_sturmtrooper_LAT_rifleman","SPE_sturmtrooper_ober_grenadier","SPE_sturmtrooper_rifleman"];
		ZMM_WEST_Truck = ["SPE_ST_OpelBlitz"];
		ZMM_WEST_Util = ["SPE_ST_OpelBlitz_Ammo","SPE_ST_OpelBlitz_Fuel","SPE_ST_OpelBlitz_Repair"];
		ZMM_WEST_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Medium = [["SPE_OpelBlitz_Flak38","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_StuH_42","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_ST_PzKpfwIII_J","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwIV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Heavy = [["SPE_Jagdpanther_G1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwVI_H1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_CasP = ["SPE_FW190F8"];
		ZMM_WEST_Convoy = ["SPE_ST_SdKfz250_1","SPE_ST_OpelBlitz","SPE_ST_PzKpfwIII_J"];
		ZMM_WEST_Static = ["SPE_ST_MG42_Lafette_Deployed"];
	};
	case 2: {
		/// WEST - Germany (Afrika Korps)
		ZMM_WEST_FactionName = "Germany (Afrika Korps)";
		ZMM_WEST_Flag = ["SPE_FlagCarrier_GER", "\WW2\SPE_Core_t\Data_t\Flags\flag_GER_co.paa"];
		ZMM_WEST_Man = ["SPEX_GER_DAK_SquadLead","SPEX_GER_DAK_rifleman_2","SPEX_GER_DAK_mgunner2","SPEX_GER_DAK_medic","SPEX_GER_DAK_rifleman","SPEX_GER_DAK_amgunner","SPEX_GER_DAK_rifleman_lite","SPEX_GER_DAK_AT_grenadier","SPEX_GER_DAK_Assist_SquadLead","SPEX_GER_DAK_Driver_Lite"];
		ZMM_WEST_Truck = ["SPEX_DAK_OpelBlitz","[_grpVeh,['DAK_camo1',1]] call BIS_fnc_initVehicle;"];
		ZMM_WEST_Util = [["SPEX_DAK_OpelBlitz_Fuel","[_grpVeh,['DAK_camo1',1],['tent_hide_source',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_OpelBlitz_Ammo","[_grpVeh,['DAK_camo1',1],['tent_hide_source',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Light = [["SPEX_DAK_R200_MG34","[_grpVeh,['DAK_camo1',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_SdKfz250_1","[_grpVeh,['DAK',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Medium = [["SPEX_DAK_OpelBlitz_Flak38","[_grpVeh,['DAK_camo1',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_PzKpfwIII_J","[_grpVeh,['DAK',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_PzKpfwIII_L","[_grpVeh,['DAK',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_PzKpfwIV_G","[_grpVeh,['Camo8',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Heavy = ["SPEX_DAK_PzKpfwVI_H1","[_grpVeh,['Muster',1]] call BIS_fnc_initVehicle;"];
		ZMM_WEST_CasP = ["SPE_FW190F8"];
		ZMM_WEST_Convoy = [["SPEX_DAK_SdKfz250_1","[_grpVeh,['DAK',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_OpelBlitz","[_grpVeh,['DAK_camo1',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_PzKpfwIII_J","[_grpVeh,['DAK',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Static = ["SPEX_DAK_MG34_Lafette_Deployed"];
	}; 
	default {
		/// WEST - Germany (Wehrmacht)
		ZMM_WEST_FactionName = "Germany (Wehrmacht)";
		ZMM_WEST_Flag = ["SPE_FlagCarrier_GER", "\WW2\SPE_Core_t\Data_t\Flags\flag_GER_co.paa"];
		ZMM_WEST_Man = ["SPE_GER_SquadLead","SPE_GER_rifleman","SPE_GER_mgunner","SPE_GER_medic","SPE_GER_rifleman","SPE_GER_amgunner","SPE_GER_rifleman","SPE_GER_LAT_Rifleman","SPE_GER_ober_grenadier","SPE_GER_rifleman"];
		ZMM_WEST_Truck = ["SPE_OpelBlitz"];
		ZMM_WEST_Util = ["SPE_OpelBlitz_Fuel","SPE_OpelBlitz_Repair","SPE_OpelBlitz_Ammo","SPE_OpelBlitz_Ambulance"];
		ZMM_WEST_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Medium = [["SPE_OpelBlitz_Flak38","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_StuH_42","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_ST_PzKpfwIII_J","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwIV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_Heavy = [["SPE_Jagdpanther_G1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwVI_H1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WEST_CasP = ["SPE_FW190F8"];
		ZMM_WEST_Convoy = ["SPE_SdKfz250_1","SPE_OpelBlitz","SPE_PzKpfwIII_J"];
		ZMM_WEST_Static = ["SPE_ST_MG42_Lafette_Deployed"];
	}; 
};

// Choose East Faction
switch (missionNamespace getVariable ["f_param_factionEast",-1]) do {
	case 1: {
		// EAST - US
		ZMM_EAST_FactionName = "USA";
		ZMM_EAST_Flag = ["SPE_FlagCarrier_USA", "\WW2\SPE_Core_t\Data_t\Flags\flag_USA_co.paa"];
		ZMM_EAST_Man = ["SPE_US_Rangers_SquadLead","SPE_US_Rangers_HMGunner","SPE_US_Rangers_rifleman","SPE_US_Rangers_medic","SPE_US_Rangers_rifleman","SPE_US_Rangers_AHMGunner","SPE_US_Rangers_rifleman","SPE_US_Rangers_grenadier","SPE_US_Rangers_Rifleman_AmmoBearer","SPE_US_Rangers_rifleman"];
		ZMM_EAST_Truck = ["SPE_US_M3_Halftrack_Unarmed"];
		ZMM_EAST_Util = ["SPE_US_M3_Halftrack_Fuel","SPE_US_M3_Halftrack_Ammo","SPE_US_M3_Halftrack_Repair","SPE_US_M3_Halftrack_Ambulance"];
		ZMM_EAST_Light = ["SPE_US_G503_MB_M1919_Armoured","SPE_US_G503_MB_M2","SPE_US_M3_Halftrack"];
		ZMM_EAST_Medium = ["SPE_US_M3_Halftrack","SPE_US_M16_Halftrack","SPE_US_M3_Halftrack","SPE_M8_LAC_ringMount","SPE_US_M3_Halftrack"];
		ZMM_EAST_Heavy = ["SPE_M10","SPE_M18_Hellcat","SPE_M4A0_75"];
		ZMM_EAST_Air = ["SPEX_C47_Skytrain"];
		ZMM_EAST_CasP = ["SPE_P47"];
		ZMM_EAST_Convoy = ["SPE_M4A1_75","SPE_US_M3_Halftrack_Unarmed","SPE_M4A1_75"];
		ZMM_EAST_Static = ["SPE_ST_MG42_Lafette_Deployed","SPE_M45_Quadmount"];		
	};
	case 2: {
		/// EAST - Germany (Wehrmacht)
		ZMM_EAST_FactionName = "Germany (Wehrmacht)";
		ZMM_EAST_Flag = ["SPE_FlagCarrier_GER", "\WW2\SPE_Core_t\Data_t\Flags\flag_GER_co.paa"];
		ZMM_EAST_Man = ["SPE_GER_SquadLead","SPE_GER_rifleman","SPE_GER_mgunner","SPE_GER_medic","SPE_GER_rifleman","SPE_GER_amgunner","SPE_GER_rifleman","SPE_GER_LAT_Rifleman","SPE_GER_ober_grenadier","SPE_GER_rifleman"];
		ZMM_EAST_Truck = ["SPE_OpelBlitz"];
		ZMM_EAST_Util = ["SPE_OpelBlitz_Fuel","SPE_OpelBlitz_Repair","SPE_OpelBlitz_Ammo","SPE_OpelBlitz_Ambulance"];
		ZMM_EAST_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Medium = [["SPE_OpelBlitz_Flak38","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_StuH_42","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_ST_PzKpfwIII_J","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwIV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Heavy = [["SPE_Jagdpanther_G1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwVI_H1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_CasP = ["SPE_FW190F8"];
		ZMM_EAST_Convoy = ["SPE_SdKfz250_1","SPE_OpelBlitz","SPE_PzKpfwIII_J"];
		ZMM_EAST_Static = ["SPE_ST_MG42_Lafette_Deployed"];
	}; 
	case 3: {
		// EAST - French
		ZMM_EAST_FactionName = "French";
		ZMM_EAST_Flag = ["SPE_FlagCarrier_FFF", "\WW2\SPE_Core_t\Data_t\Flags\flag_FFF_co.paa"];
		ZMM_EAST_Man = ["SPE_FR_SquadLead","SPE_FR_Rifleman_Carbine","SPE_FR_Autorifleman","SPE_FR_Rifleman","SPE_FR_Assist_SquadLead","SPE_FR_Rifleman_Carbine","SPE_FR_AT_Soldier","SPE_FR_Rifleman","SPE_FR_Grenadier","SPE_FR_Rifleman"];
		ZMM_EAST_Truck = ["SPE_FFI_OpelBlitz"];
		ZMM_EAST_Util = ["SPE_FFI_OpelBlitz_Fuel","SPE_FFI_OpelBlitz_Ammo","SPE_FFI_OpelBlitz_Repair","SPE_FFI_OpelBlitz_Ambulance"];
		ZMM_EAST_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]],
		ZMM_EAST_Medium = [["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_OpelBlitz_Flak38","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Heavy = [["SPE_PzKpfwIII_J","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Air = [["SPEX_C47_Skytrain","[_grpVeh,['bare',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_CasP = ["SPE_P47"];
		ZMM_EAST_Convoy = [["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],"SPE_FFI_OpelBlitz",["SPE_PzKpfwIII_J","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Static = ["SPE_ST_MG42_Lafette_Deployed"];
	};
	case 4: {	
		// EAST - Germany (Fallschirmjägers)
		ZMM_EAST_FactionName = "Germany (Fallschirmjägers)";
		ZMM_EAST_Flag = ["SPE_FlagCarrier_GER", "\WW2\SPE_Core_t\Data_t\Flags\flag_GER_co.paa"];
		ZMM_EAST_Man = ["SPEX_FSJ_DAK_SquadLead","SPEX_FSJ_DAK_Mgunner2","SPEX_FSJ_DAK_Solder","SPEX_FSJ_DAK_medic_soldat","SPEX_FSJ_DAK_Solder","SPEX_FSJ_DAK_HMG_AmmoBearer","SPEX_FSJ_DAK_Solder","SPEX_FSJ_DAK_amgunner","SPEX_FSJ_DAK_AT_grenadier","SPEX_FSJ_DAK_Assist_SquadLead","SPEX_FSJ_DAK_Solder"];
		ZMM_EAST_Truck = ["SPEX_DAK_OpelBlitz","[_grpVeh,['DAK_camo1',1]] call BIS_fnc_initVehicle;"];
		ZMM_EAST_Util = [["SPEX_DAK_OpelBlitz_Fuel","[_grpVeh,['DAK_camo1',1],['tent_hide_source',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_OpelBlitz_Ammo","[_grpVeh,['DAK_camo1',1],['tent_hide_source',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Light = [["SPEX_DAK_R200_MG34","[_grpVeh,['DAK_camo1',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_SdKfz250_1","[_grpVeh,['DAK',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Medium = [["SPEX_DAK_OpelBlitz_Flak38","[_grpVeh,['DAK_camo1',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_PzKpfwIII_J","[_grpVeh,['DAK',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_PzKpfwIII_L","[_grpVeh,['DAK',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_PzKpfwIV_G","[_grpVeh,['Camo8',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Heavy = ["SPEX_DAK_PzKpfwVI_H1","[_grpVeh,['Muster',1]] call BIS_fnc_initVehicle;"];
		ZMM_EAST_CasP = ["SPE_FW190F8"];
		ZMM_EAST_Convoy = [["SPEX_DAK_SdKfz250_1","[_grpVeh,['DAK',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_OpelBlitz","[_grpVeh,['DAK_camo1',1]] call BIS_fnc_initVehicle;"],["SPEX_DAK_PzKpfwIII_J","[_grpVeh,['DAK',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Static = ["SPEX_DAK_MG34_Lafette_Deployed"];
	};
	default {	
		// EAST - Germany (Sturmtroopers)
		ZMM_EAST_FactionName = "Germany (Sturmtroopers)";
		ZMM_EAST_Flag = ["SPE_FlagCarrier_GER", "\WW2\SPE_Core_t\Data_t\Flags\flag_GER_co.paa"];
		ZMM_EAST_Man = ["SPE_sturmtrooper_SquadLead","SPE_sturmtrooper_mgunner","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_medic","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_stggunner","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_amgunner","SPE_sturmtrooper_LAT_rifleman","SPE_sturmtrooper_ober_grenadier","SPE_sturmtrooper_rifleman"];
		ZMM_EAST_Truck = ["SPE_ST_OpelBlitz"];
		ZMM_EAST_Util = ["SPE_ST_OpelBlitz_Ammo","SPE_ST_OpelBlitz_Fuel","SPE_ST_OpelBlitz_Repair"];
		ZMM_EAST_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Medium = [["SPE_OpelBlitz_Flak38","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_StuH_42","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_ST_PzKpfwIII_J","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwIV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_Heavy = [["SPE_Jagdpanther_G1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwVI_H1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EAST_CasP = ["SPE_FW190F8"];
		ZMM_EAST_Convoy = ["SPE_ST_SdKfz250_1","SPE_ST_OpelBlitz","SPE_ST_PzKpfwIII_J"];
		ZMM_EAST_Static = ["SPE_ST_MG42_Lafette_Deployed"];
	};
};

// Choose Guer Faction
switch (missionNamespace getVariable ["f_param_factionGuer",-1]) do {
	case 1: {
		// GUER - French
		ZMM_GUER_FactionName = "French";
		ZMM_GUER_Flag = ["SPE_FlagCarrier_FFF", "\WW2\SPE_Core_t\Data_t\Flags\flag_FFF_co.paa"];
		ZMM_GUER_Man = ["SPE_FR_SquadLead","SPE_FR_Rifleman_Carbine","SPE_FR_Autorifleman","SPE_FR_Rifleman","SPE_FR_Assist_SquadLead","SPE_FR_Rifleman_Carbine","SPE_FR_AT_Soldier","SPE_FR_Rifleman","SPE_FR_Grenadier","SPE_FR_Rifleman"];
		ZMM_GUER_Truck = ["SPE_FFI_OpelBlitz"];
		ZMM_GUER_Util = ["SPE_FFI_OpelBlitz_Fuel","SPE_FFI_OpelBlitz_Ammo","SPE_FFI_OpelBlitz_Repair","SPE_FFI_OpelBlitz_Ambulance"];
		ZMM_GUER_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]],
		ZMM_GUER_Medium = [["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_OpelBlitz_Flak38","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_Heavy = [["SPE_PzKpfwIII_J","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_Air = [["SPEX_C47_Skytrain","[_grpVeh,['bare',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_CasP = ["SPE_P47"];
		ZMM_GUER_Convoy = [["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],"SPE_FFI_OpelBlitz",["SPE_PzKpfwIII_J","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUER_Static = ["SPE_ST_MG42_Lafette_Deployed"];
	};
	case 2: {
		// GUER - UK
		ZMM_GUER_FactionName = "UK";
		ZMM_GUER_Flag = ["Flag_UK_F", "\A3\Data_F\Flags\Flag_UK_CO.paa"];
		ZMM_GUER_Man = ["SPEX_CW_KD_42_Sergeant","SPEX_CW_KD_42_Bren_gunner","SPEX_CW_KD_42_rifleman","SPEX_CW_KD_42_Medic","SPEX_CW_KD_42_rifleman","SPEX_CW_KD_42_Bren_asst","SPEX_CW_KD_42_rifleman","SPEX_CW_KD_42_piat_gunner","SPEX_CW_KD_42_Team_Leader","SPEX_CW_KD_42_rifleman"];
		ZMM_GUER_Truck = ["SPEX_CW_trop_Bedford_MWD"];
		ZMM_GUER_Util = ["SPEX_CW_trop_Bedford_MWD_Fuel","SPEX_CW_trop_Bedford_MWD_Ammo","SPEX_CW_trop_Bedford_MWD_Repair"];
		ZMM_GUER_Light = ["SPEX_CW_Trop_G503_MB_M2","SPEX_CW_Trop_Humber_LRC"];
		ZMM_GUER_Medium = ["SPEX_CW_Trop_Humber_LRC","SPEX_CW_Trop_Sherman_II","SPEX_CW_Trop_Sherman_V_Early","SPEX_CW_Trop_Sherman_V"];
		ZMM_GUER_Heavy = ["SPEX_CW_Trop_M10"];
		ZMM_GUER_Air = ["SPEX_C47_Skytrain"];
		ZMM_GUER_CasP = ["SPE_P47"];
		ZMM_GUER_Convoy = ["SPEX_CW_Trop_Sherman_II","SPEX_CW_trop_Bedford_MWD","SPEX_CW_Trop_Sherman_V_Early"];
		ZMM_GUER_Static = ["SPE_M2_M3","SPE_M45_Quadmount"];
	};
	default {
		// GUER - US
		ZMM_GUER_FactionName = "USA";
		ZMM_GUER_Flag = ["SPE_FlagCarrier_USA", "\WW2\SPE_Core_t\Data_t\Flags\flag_USA_co.paa"];
		ZMM_GUER_Man = ["SPE_US_Rangers_SquadLead","SPE_US_Rangers_HMGunner","SPE_US_Rangers_rifleman","SPE_US_Rangers_medic","SPE_US_Rangers_rifleman","SPE_US_Rangers_AHMGunner","SPE_US_Rangers_rifleman","SPE_US_Rangers_grenadier","SPE_US_Rangers_Rifleman_AmmoBearer","SPE_US_Rangers_rifleman"];
		ZMM_GUER_Truck = ["SPE_US_M3_Halftrack_Unarmed"];
		ZMM_GUER_Util = ["SPE_US_M3_Halftrack_Fuel","SPE_US_M3_Halftrack_Ammo","SPE_US_M3_Halftrack_Repair","SPE_US_M3_Halftrack_Ambulance"];
		ZMM_GUER_Light = ["SPE_US_G503_MB_M1919_Armoured","SPE_US_G503_MB_M2","SPE_US_M3_Halftrack"];
		ZMM_GUER_Medium = ["SPE_US_M3_Halftrack","SPE_US_M16_Halftrack","SPE_US_M3_Halftrack","SPE_M8_LAC_ringMount","SPE_US_M3_Halftrack"];
		ZMM_GUER_Heavy = ["SPE_M10","SPE_M18_Hellcat","SPE_M4A0_75"];
		ZMM_GUER_Air = ["SPEX_C47_Skytrain"];
		ZMM_GUER_CasP = ["SPE_P47"];
		ZMM_GUER_Convoy = ["SPE_M4A1_75","SPE_US_M3_Halftrack_Unarmed","SPE_M4A1_75"];
		ZMM_GUER_Static = ["SPE_ST_MG42_Lafette_Deployed","SPE_M45_Quadmount"];
	};
};