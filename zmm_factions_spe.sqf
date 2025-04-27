// Choose West Faction
switch (missionNamespace getVariable ["f_param_factionWest",-1]) do {
	case 1: {
		// WEST - Germany (Sturmtroopers)
		ZMM_WESTFactionName = "Germany (Sturmtroopers)";
		ZMM_WESTFlag = ["SPE_FlagCarrier_GER", "\WW2\SPE_Core_t\Data_t\Flags\flag_GER_co.paa"];
		ZMM_WESTMan = ["SPE_sturmtrooper_SquadLead","SPE_sturmtrooper_mgunner","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_medic","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_stggunner","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_amgunner","SPE_sturmtrooper_LAT_rifleman","SPE_sturmtrooper_ober_grenadier","SPE_sturmtrooper_rifleman"];
		ZMM_WESTVeh_Truck = ["SPE_ST_OpelBlitz"];
		ZMM_WESTVeh_Util = ["SPE_ST_OpelBlitz_Ammo","SPE_ST_OpelBlitz_Fuel","SPE_ST_OpelBlitz_Repair"];
		ZMM_WESTVeh_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Medium = [["SPE_OpelBlitz_Flak38","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_StuH_42","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_ST_PzKpfwIII_J","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwIV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Heavy = [["SPE_Jagdpanther_G1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwVI_H1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_CasP = ["SPE_FW190F8"];
		ZMM_WESTVeh_Convoy = ["SPE_ST_SdKfz250_1","SPE_ST_OpelBlitz","SPE_ST_PzKpfwIII_J"];
		ZMM_WESTVeh_Static = ["SPE_ST_MG42_Lafette_Deployed"];
	};
	default {
		/// WEST - Germany (Wehrmacht)
		ZMM_WESTFactionName = "Germany (Wehrmacht)";
		ZMM_WESTFlag = ["SPE_FlagCarrier_GER", "\WW2\SPE_Core_t\Data_t\Flags\flag_GER_co.paa"];
		ZMM_WESTMan = ["SPE_GER_SquadLead","SPE_GER_rifleman","SPE_GER_mgunner","SPE_GER_medic","SPE_GER_rifleman","SPE_GER_amgunner","SPE_GER_rifleman","SPE_GER_LAT_Rifleman","SPE_GER_ober_grenadier","SPE_GER_rifleman"];
		ZMM_WESTVeh_Truck = ["SPE_OpelBlitz"];
		ZMM_WESTVeh_Util = ["SPE_OpelBlitz_Fuel","SPE_OpelBlitz_Repair","SPE_OpelBlitz_Ammo","SPE_OpelBlitz_Ambulance"];
		ZMM_WESTVeh_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Medium = [["SPE_OpelBlitz_Flak38","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_StuH_42","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_ST_PzKpfwIII_J","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwIV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_Heavy = [["SPE_Jagdpanther_G1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwVI_H1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_WESTVeh_CasP = ["SPE_FW190F8"];
		ZMM_WESTVeh_Convoy = ["SPE_SdKfz250_1","SPE_OpelBlitz","SPE_PzKpfwIII_J"];
		ZMM_WESTVeh_Static = ["SPE_ST_MG42_Lafette_Deployed"];
	}; 
};

// Choose East Faction
switch (missionNamespace getVariable ["f_param_factionEast",-1]) do {
	case 1: {
		// EAST - US
		ZMM_EASTFactionName = "USA";
		ZMM_EASTFlag = ["SPE_FlagCarrier_USA", "\WW2\SPE_Core_t\Data_t\Flags\flag_USA_co.paa"];
		ZMM_EASTMan = ["SPE_US_Rangers_SquadLead","SPE_US_Rangers_HMGunner","SPE_US_Rangers_rifleman","SPE_US_Rangers_medic","SPE_US_Rangers_rifleman","SPE_US_Rangers_AHMGunner","SPE_US_Rangers_rifleman","SPE_US_Rangers_grenadier","SPE_US_Rangers_Rifleman_AmmoBearer","SPE_US_Rangers_rifleman"];
		ZMM_EASTVeh_Truck = ["SPE_US_M3_Halftrack_Unarmed"];
		ZMM_EASTVeh_Util = ["SPE_US_M3_Halftrack_Fuel","SPE_US_M3_Halftrack_Ammo","SPE_US_M3_Halftrack_Repair","SPE_US_M3_Halftrack_Ambulance"];
		ZMM_EASTVeh_Light = ["SPE_US_G503_MB_M1919_Armoured","SPE_US_G503_MB_M2","SPE_US_M3_Halftrack"];
		ZMM_EASTVeh_Medium = ["SPE_US_M3_Halftrack","SPE_US_M16_Halftrack","SPE_US_M3_Halftrack","SPE_M8_LAC_ringMount","SPE_US_M3_Halftrack"];
		ZMM_EASTVeh_Heavy = ["SPE_M10","SPE_M18_Hellcat","SPE_M4A0_75"];
		ZMM_EASTVeh_Air = ["SPEX_C47_Skytrain"];
		ZMM_EASTVeh_CasP = ["SPE_P47"];
		ZMM_EASTVeh_Convoy = ["SPE_M4A1_75","SPE_US_M3_Halftrack_Unarmed","SPE_M4A1_75"];
		ZMM_EASTVeh_Static = ["SPE_ST_MG42_Lafette_Deployed","SPE_M45_Quadmount"];		
	};
	case 2: {
		/// EAST - Germany (Wehrmacht)
		ZMM_EASTFactionName = "Germany (Wehrmacht)";
		ZMM_EASTFlag = ["SPE_FlagCarrier_GER", "\WW2\SPE_Core_t\Data_t\Flags\flag_GER_co.paa"];
		ZMM_EASTMan = ["SPE_GER_SquadLead","SPE_GER_rifleman","SPE_GER_mgunner","SPE_GER_medic","SPE_GER_rifleman","SPE_GER_amgunner","SPE_GER_rifleman","SPE_GER_LAT_Rifleman","SPE_GER_ober_grenadier","SPE_GER_rifleman"];
		ZMM_EASTVeh_Truck = ["SPE_OpelBlitz"];
		ZMM_EASTVeh_Util = ["SPE_OpelBlitz_Fuel","SPE_OpelBlitz_Repair","SPE_OpelBlitz_Ammo","SPE_OpelBlitz_Ambulance"];
		ZMM_EASTVeh_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Medium = [["SPE_OpelBlitz_Flak38","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_StuH_42","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_ST_PzKpfwIII_J","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwIV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["SPE_Jagdpanther_G1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwVI_H1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_CasP = ["SPE_FW190F8"];
		ZMM_EASTVeh_Convoy = ["SPE_SdKfz250_1","SPE_OpelBlitz","SPE_PzKpfwIII_J"];
		ZMM_EASTVeh_Static = ["SPE_ST_MG42_Lafette_Deployed"];
	}; 
	case 3: {
		// EAST - French
		ZMM_EASTFactionName = "French";
		ZMM_EASTFlag = ["SPE_FlagCarrier_FFF", "\WW2\SPE_Core_t\Data_t\Flags\flag_FFF_co.paa"];
		ZMM_EASTMan = ["SPE_FR_SquadLead","SPE_FR_Rifleman_Carbine","SPE_FR_Autorifleman","SPE_FR_Rifleman","SPE_FR_Assist_SquadLead","SPE_FR_Rifleman_Carbine","SPE_FR_AT_Soldier","SPE_FR_Rifleman","SPE_FR_Grenadier","SPE_FR_Rifleman"];
		ZMM_EASTVeh_Truck = ["SPE_FFI_OpelBlitz"];
		ZMM_EASTVeh_Util = ["SPE_FFI_OpelBlitz_Fuel","SPE_FFI_OpelBlitz_Ammo","SPE_FFI_OpelBlitz_Repair","SPE_FFI_OpelBlitz_Ambulance"];
		ZMM_EASTVeh_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]],
		ZMM_EASTVeh_Medium = [["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_OpelBlitz_Flak38","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["SPE_PzKpfwIII_J","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Air = [["SPEX_C47_Skytrain","[_grpVeh,['bare',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_CasP = ["SPE_P47"];
		ZMM_EASTVeh_Convoy = [["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],"SPE_FFI_OpelBlitz",["SPE_PzKpfwIII_J","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Static = ["SPE_ST_MG42_Lafette_Deployed"];
	};
	default {	
		// EAST - Germany (Sturmtroopers)
		ZMM_EASTFactionName = "Germany (Sturmtroopers)";
		ZMM_EASTFlag = ["SPE_FlagCarrier_GER", "\WW2\SPE_Core_t\Data_t\Flags\flag_GER_co.paa"];
		ZMM_EASTMan = ["SPE_sturmtrooper_SquadLead","SPE_sturmtrooper_mgunner","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_medic","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_stggunner","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_amgunner","SPE_sturmtrooper_LAT_rifleman","SPE_sturmtrooper_ober_grenadier","SPE_sturmtrooper_rifleman"];
		ZMM_EASTVeh_Truck = ["SPE_ST_OpelBlitz"];
		ZMM_EASTVeh_Util = ["SPE_ST_OpelBlitz_Ammo","SPE_ST_OpelBlitz_Fuel","SPE_ST_OpelBlitz_Repair"];
		ZMM_EASTVeh_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Medium = [["SPE_OpelBlitz_Flak38","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_StuH_42","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_ST_PzKpfwIII_J","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwIV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_Heavy = [["SPE_Jagdpanther_G1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwVI_H1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
		ZMM_EASTVeh_CasP = ["SPE_FW190F8"];
		ZMM_EASTVeh_Convoy = ["SPE_ST_SdKfz250_1","SPE_ST_OpelBlitz","SPE_ST_PzKpfwIII_J"];
		ZMM_EASTVeh_Static = ["SPE_ST_MG42_Lafette_Deployed"];
	};
};

// Choose Guer Faction
switch (missionNamespace getVariable ["f_param_factionGuer",-1]) do {
	case 1: {
		// GUER - French
		ZMM_GUERFactionName = "French";
		ZMM_GUERFlag = ["SPE_FlagCarrier_FFF", "\WW2\SPE_Core_t\Data_t\Flags\flag_FFF_co.paa"];
		ZMM_GUERMan = ["SPE_FR_SquadLead","SPE_FR_Rifleman_Carbine","SPE_FR_Autorifleman","SPE_FR_Rifleman","SPE_FR_Assist_SquadLead","SPE_FR_Rifleman_Carbine","SPE_FR_AT_Soldier","SPE_FR_Rifleman","SPE_FR_Grenadier","SPE_FR_Rifleman"];
		ZMM_GUERVeh_Truck = ["SPE_FFI_OpelBlitz"];
		ZMM_GUERVeh_Util = ["SPE_FFI_OpelBlitz_Fuel","SPE_FFI_OpelBlitz_Ammo","SPE_FFI_OpelBlitz_Repair","SPE_FFI_OpelBlitz_Ambulance"];
		ZMM_GUERVeh_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]],
		ZMM_GUERVeh_Medium = [["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_OpelBlitz_Flak38","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Heavy = [["SPE_PzKpfwIII_J","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Air = [["SPEX_C47_Skytrain","[_grpVeh,['bare',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_CasP = ["SPE_P47"];
		ZMM_GUERVeh_Convoy = [["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],"SPE_FFI_OpelBlitz",["SPE_PzKpfwIII_J","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
		ZMM_GUERVeh_Static = ["SPE_ST_MG42_Lafette_Deployed"];
	};
	default {
		// GUER - US
		ZMM_GUERFactionName = "USA";
		ZMM_GUERFlag = ["SPE_FlagCarrier_USA", "\WW2\SPE_Core_t\Data_t\Flags\flag_USA_co.paa"];
		ZMM_GUERMan = ["SPE_US_Rangers_SquadLead","SPE_US_Rangers_HMGunner","SPE_US_Rangers_rifleman","SPE_US_Rangers_medic","SPE_US_Rangers_rifleman","SPE_US_Rangers_AHMGunner","SPE_US_Rangers_rifleman","SPE_US_Rangers_grenadier","SPE_US_Rangers_Rifleman_AmmoBearer","SPE_US_Rangers_rifleman"];
		ZMM_GUERVeh_Truck = ["SPE_US_M3_Halftrack_Unarmed"];
		ZMM_GUERVeh_Util = ["SPE_US_M3_Halftrack_Fuel","SPE_US_M3_Halftrack_Ammo","SPE_US_M3_Halftrack_Repair","SPE_US_M3_Halftrack_Ambulance"];
		ZMM_GUERVeh_Light = ["SPE_US_G503_MB_M1919_Armoured","SPE_US_G503_MB_M2","SPE_US_M3_Halftrack"];
		ZMM_GUERVeh_Medium = ["SPE_US_M3_Halftrack","SPE_US_M16_Halftrack","SPE_US_M3_Halftrack","SPE_M8_LAC_ringMount","SPE_US_M3_Halftrack"];
		ZMM_GUERVeh_Heavy = ["SPE_M10","SPE_M18_Hellcat","SPE_M4A0_75"];
		ZMM_GUERVeh_Air = ["SPEX_C47_Skytrain"];
		ZMM_GUERVeh_CasP = ["SPE_P47"];
		ZMM_GUERVeh_Convoy = ["SPE_M4A1_75","SPE_US_M3_Halftrack_Unarmed","SPE_M4A1_75"];
		ZMM_GUERVeh_Static = ["SPE_ST_MG42_Lafette_Deployed","SPE_M45_Quadmount"];
	};
};