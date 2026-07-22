// zmm_fnc_areaMilitarise
if !isServer exitWith {};
params [["_zoneID", 0], ["_enemyCount", 30]];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
private _side = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyMen = missionNamespace getVariable [format["ZMM_%1_Man", _side], ["O_Soldier_F"]];

// TODO RANK THESE SO TIER 1 IS ALWAYS OCCUPIED (Towers etc)

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
	"Land_i_Shed_Ind_F","Land_SM_01_shed_F",
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

if (_enemyCount < 1 || count _enemyMen == 0) exitWith {};

private _buildingArr = [];
private _milBlds = nearestObjects [_centre, _milPrimary, 500];

{
	if (isNil {_x getVariable "ZAU_BuildingPositions"} || isNil {_x getVariable "ZAU_BuildingSide"}) then {
		private _positions = _x buildingPos -1;
		_x setVariable ["ZAU_BuildingPositions", _positions];
		_x setVariable ["ZAU_BuildingSide", _side];
		_buildingArr pushBack _x;
	};
} forEach _milBlds;

if (count _buildingArr isEqualTo 0) exitWith {
	["DEBUG", format["Zone%1 - Area Military - No buildings found in zone", _zoneID]] call zmm_fnc_misc_logMsg;
};

["DEBUG", format["Zone%1 - Area Military - Creating: %2 units (%3 buildings) for %4", _zoneID, _enemyCount, count _buildingArr, _side]] call zmm_fnc_misc_logMsg;

private _milLocs = [];

// Fill Military Buildings
{
	private _bld = _x;
	
	if (_enemyCount <= 0) exitWith {};
	
	if !(_bld getVariable ["ZAU_BuildingDone", false]) then {
		// Add Garrison
		private _enemyTeam = [];
		private _bpa = _bld getVariable ["ZAU_BuildingPositions", []];
		private _fillNo = (2 + floor (random 3)) min (count _bpa);
		
		if (_fillNo == 0) exitWith {};
		
		for "_i" from 0 to _fillNo do { _enemyTeam set [_i, selectRandom _enemyMen] };
		//format["[ZAU] Spawning Garrison at %1", _bMid] call _fnc_log;
		
		private _nearPos = (getPos _bld) findEmptyPosition [2, 15, "B_Soldier_F" ];
		
		// SERVER ONLY MARKER
		_milLocs pushBack (getPos _bld);
		private _mrk = createMarkerLocal [format ["MKR_Z%1_L%2_MILI", _zoneID, _forEachIndex], getPos _bld];
		_mrk setMarkerTypeLocal "mil_dot";
		_mrk setMarkerColorLocal "ColorYellow";
		_mrk setMarkerAlphaLocal 0.6;
		_mrk setMarkerTextLocal format ["MILI_Z%1_L%2", _zoneID, _forEachIndex];
		
		private _grp = [_nearPos , _side, _enemyTeam] call BIS_fnc_spawnGroup;
		_grp setGroupIdGlobal [format["Z%1_G%2_MILI", _zoneID, _forEachIndex]];
		_grp setVariable ["VCM_DISABLE", true];
		_grp deleteGroupWhenEmpty true;
		
		{
			private _unit = _x;
			if (count _bpa < 1) exitWith {};
			
			_enemyCount = _enemyCount - 1;
			
			private _tempPos = selectRandom _bpa;
			_bpa = _bpa - [_tempPos];
			
			if (count (_tempPos nearEntities ["Man", 1]) < 1) then {
				_unit setPosATL _tempPos;				
				[_unit] spawn zmm_fnc_misc_unitDirPos;
			};
		} foreach (units _grp);
		
		{ _x addCuratorEditableObjects [units _grp] } forEach allCurators;
		_grp enableDynamicSimulation true;

		private _rad = (round (sizeOf typeOf _bld)) max 40;
		private _trg = createTrigger ["EmptyDetector", getPos _bld];
		_trg setTriggerArea [_rad, _rad, 0, false, 15];
		_trg setTriggerActivation ["ANYPLAYER", "PRESENT", false];
		_trg setTriggerInterval 5;
		_trg setTriggerStatements [
			"this", 
			"{ if (local _x) then { if (!(_x checkAIFeature 'PATH') && random 1 < 0.2) then { doStop _x; _x enableAI 'PATH' }; }; } forEach (allUnits inAreaArray thisTrigger);",
			"{ if (local _x) then { if !(_x checkAIFeature 'PATH') then { _x doFollow leader _x; _x enableAI 'PATH' }; }; } forEach (allUnits inAreaArray thisTrigger);"
		];

		_bld setVariable ["ZAU_BuildingDone", true];
		sleep 1;
	};
} forEach (_buildingArr call BIS_fnc_arrayShuffle);

// Identify HQ with lots of military buildings nearby
private _milPositions = ([
		_milLocs select { private _pos = _x; ( count ( _milLocs select { _x distance2D _pos < 100 })) >= 3 },
		[], 
		{ private _pos = _x; count ( _milLocs select { _x distance2D _pos < 100 })},
		"DESCEND"
	] call BIS_fnc_sortBy);

if (count _milPositions < 1) exitWith {};

private _mrk = createMarkerLocal [format ["MKR_Z%1_HQ", _zoneID], _milPositions#0];
_mrk setMarkerTypeLocal "mil_objective";
_mrk setMarkerColorLocal "ColorYellow";
_mrk setMarkerAlphaLocal 0.6;
_mrk setMarkerTextLocal format ["Z%1_HQ", _zoneID];



