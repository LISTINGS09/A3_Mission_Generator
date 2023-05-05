if !isServer exitWith {};

params [["_zoneID", 0], ["_enemyCount", 30]];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
private _side = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyMen = missionNamespace getVariable [format["ZMM_%1Man", _side], []];

if (count _enemyMen isEqualTo 0) exitWith { ["ERROR", format["Zone%1 - Area Militarise - (%2) No valid units passed, were global unit variables declared?", _zoneID, _side]] call zmm_fnc_logMsg };

// Always populate military buildings.

private _milPrimary = [
	"Land_Cargo_HQ_V1_F","Land_Cargo_HQ_V2_F","Land_Cargo_HQ_V3_F","Land_Cargo_HQ_V4_F","Land_Medevac_HQ_V1_F",
	"Land_Cargo_House_V1_F","Land_Cargo_House_V2_F","Land_Cargo_House_V3_F","Land_Cargo_House_V4_F","Land_Medevac_house_V1_F",
	"Land_Cargo_Patrol_V1_F","Land_Cargo_Patrol_V2_F","Land_Cargo_Patrol_V3_F","Land_Cargo_Patrol_V4_F",
	"Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V2_F","Land_Cargo_Tower_V3_F","Land_Cargo_Tower_V4_F",
	"Land_HBarrier_01_tower_green_F","Land_HBarrier_01_big_tower_green_F","Land_BagBunker_01_large_green_F","Land_BagBunker_01_small_green_F",
	"Land_HBarrierTower_F","Land_BagBunker_Tower_F","Land_BagBunker_Large_F","Land_BagBunker_Small_F",
	"Land_Airport_01_controlTower_F","Land_Airport_02_controlTower_F",
	"Land_Barracks_01_camo_F","Land_Barracks_01_dilapidated_F","Land_Barracks_01_grey_F","Land_Barracks_06_F",
	"Land_Bunker_01_HQ_F","Land_Bunker_01_big_F","Land_Bunker_01_small_F","Land_Bunker_01_tall_F",
	"Land_Cargo_Tower_V1_No1_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No4_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No7_F",
	"Land_ControlTower_01_F","Land_ControlTower_02_F",
	"Land_DeerStand_01_F","Land_DeerStand_02_F",
	"Land_GuardTower_01_F","Land_GuardTower_02_F","Land_MilOffices_V1_F",
	"Land_i_Barracks_V1_F","Land_i_Barracks_V2_F","Land_u_Barracks_V2_F","Land_vn_airport_02_controltower_f",
	"Land_vn_b_gunpit_01","Land_vn_b_mortarpit_01","Land_vn_b_tower_01","Land_vn_b_trench_bunker_04_01","Land_vn_b_trench_firing_05","Land_vn_bagbunker_01_large_green_f","Land_vn_bagbunker_01_small_green_f","Land_vn_barracks_01_camo_f","Land_vn_barracks_01_dilapidated_f","Land_vn_barracks_01_grey_f","Land_vn_barracks_06_f","Land_vn_bunker_big_01","Land_vn_bunker_big_02","Land_vn_bunker_small_01","Land_vn_controltower_01_f",
	"Land_vn_hut_tower_01","Land_vn_hut_tower_02",
	"Land_vn_i_barracks_v1_dam_f","Land_vn_i_barracks_v1_f","Land_vn_i_barracks_v2_dam_f","Land_vn_i_barracks_v2_f",
	"Land_vn_o_bunker_02","Land_vn_o_bunker_03","Land_vn_o_bunker_04",
	"Land_vn_o_platform_01","Land_vn_o_platform_02","Land_vn_o_platform_03","Land_vn_o_platform_04","Land_vn_o_platform_05","Land_vn_o_platform_06",
	"Land_vn_o_shelter_02","Land_vn_o_shelter_05",
	"Land_vn_o_snipertree_01","Land_vn_o_snipertree_02","Land_vn_o_snipertree_03","Land_vn_o_snipertree_04","Land_vn_o_tower_01","Land_vn_o_tower_02","Land_vn_o_tower_03","Land_vn_pillboxbunker_01_big_f","Land_vn_pillboxbunker_01_hex_f","Land_vn_pillboxbunker_02_hex_f","Land_vn_radar_01_antenna_base_f","Land_vn_radar_01_hq_f",
	"Land_vn_tent_01_01","Land_vn_tent_01_02","Land_vn_tent_01_03","Land_vn_tent_01_04","Land_vn_tent_02_01","Land_vn_tent_02_02","Land_vn_tent_02_03","Land_vn_tent_02_04",
	"vn_o_snipertree_01","vn_o_snipertree_02","vn_o_snipertree_03","vn_o_snipertree_04"
];

private _milGrp = createGroup [_side, true];
private _milBlds = nearestObjects [_centre, _milPrimary, 500];

{
	if (count units _milGrp > _enemyCount) exitWith {};
	
	if (random 1 > 0.25 || count (_x buildingPos -1) < 5) then {
		private _pos = selectRandom (_x buildingPos -1);
		
		if (count (_pos nearEntities ["Man", 1]) < 1) then {
			private _type = selectRandom _enemyMen;	
			private _unit = _milGrp createUnit [_type, [0,0,0], [], 150, "NONE"];
			[_unit] joinSilent _milGrp; 
			_unit setPosATL _pos;
			
			// Force unit to hold - doStop is a 'soft' hold, disableAI stops movement permanently.
			if (random 1 > 0.7) then { doStop _unit } else { _unit disableAI "PATH" };
			
			[_unit] spawn zmm_fnc_unitDirPos;
		};
	};
} forEach _milBlds;

if (count units _milGrp > 0) then {
	["DEBUG", format["Zone%1 - Area Militarise - Garrison Created: %2 units", _zoneID, count units _milGrp]] call zmm_fnc_logMsg;
	
	_milGrp setVariable ["VCM_DISABLE", true];
	_milGrp enableDynamicSimulation true;

	//Add to Zeus
	{ _x addCuratorEditableObjects [units _milGrp, true] } forEach allCurators;
};