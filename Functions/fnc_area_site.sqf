// [0, player getPos [100, random 360], false, true] call zmm_fnc_areaSite;
// Returns position created at
if !isServer exitWith {};

params [
	["_zoneID", 0],
	["_centre", (missionNamespace getVariable [ format[ "ZMM_%1_Location", _this#0], [0,0,0]])],
	["_showMarker", true],
	["_forcePos", false]
];

if (_centre isEqualTo [0,0,0]) then { _centre = [_centre, 0, 200, 5, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos };

private _side = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locations = missionNamespace getVariable [ format[ "ZMM_%1_SiteLocations", _zoneID ], []];  // Takes too long to populate - Left blank

private _radius = missionNamespace getVariable [ format[ "ZMM_%1_Radius", _zoneID ], 150];
private _count = missionNamespace getVariable [format["ZMM_%1_Supports", _zoneID], 1];
private _menArr = missionNamespace getVariable [format["ZMM_%1Man",_side],[]];

private _vehL = missionNamespace getVariable [format["ZMM_%1Veh_Light",_side],[]];
private _vehM = missionNamespace getVariable [format["ZMM_%1Veh_Medium",_side],[]];
private _vehH = missionNamespace getVariable [format["ZMM_%1Veh_Heavy",_side],[]];
private _vehU = missionNamespace getVariable [format["ZMM_%1Veh_Util",_side],[]];
private _hmgArr = missionNamespace getVariable [format["ZMM_%1Veh_Static",_side],[]];

if (_count == 0) then { _count = 1 };

["DEBUG", format["Zone%1 - Creating Site: Count %2 at %3%4", _zoneID, _count, _centre, [""," [FORCED]"] select _forcePos]] call zmm_fnc_logMsg;

private _vehArr = [];
if (count _vehL > 1) then { _vehArr append _vehL; _vehArr append _vehL; }; // Common
if (count _vehM > 1) then { _vehArr append _vehM; }; // Medium
if (count _hmgArr == 0) then { _hmgArr = ["B_GMG_01_high_F","B_HMG_01_high_F"] };

if (!_forcePos && count _locations == 0) then {
	// Find Support Locations
	for [{_i = 0}, {_i < 360}, {_i = _i + 5}] do {
		for [{_j = _radius * 0.25}, {_j <= (_radius * 1.5)}, {_j = _j + 25}] do {
			private _tempPos = _centre getPos [_j, _i];
						
			if ({_x distance2D _tempPos < 400} count _locations == 0 && !(_tempPos isFlatEmpty [8, -1, 0.25, 5] isEqualTo [])) then {
				/*private _tempMkr = createMarkerLocal [format ["TSUP_%1_%2", _zoneID, (_i * 10000) + _j], _tempPos];
				_tempMkr setMarkerTypeLocal "mil_dot";
				_tempMkr setMarkerColorLocal "ColorGrey";
				_tempMkr setMarkerAlphaLocal 0.2;*/
				
				if (count (_tempPos nearRoads 50) == 0 &&
					count (nearestObjects [_tempPos, ["House", "Building"], 50]) == 0)
				then {
					/*_tempMkr setMarkerAlphaLocal 0.4;
					_tempMkr setMarkerColorLocal "ColorOrange";
					_tempMkr setMarkerTextLocal format["S%1", _i];*/
					_locations pushBack _tempPos;
				};
			};
		};
		
		if (count _locations > _count) exitWith {};
	};
} else {
	if _forcePos then { _locations = [_centre] };
};

// Special Locations:
// "Land_Sacks_heap_F"
// ["Land_CampingTable_small_F","Land_CampingTable_small_white_F","Land_CampingTable_white_F","Land_WoodenTable_large_F","Land_WoodenTable_small_F","Land_TableBig_01_F","OfficeTable_01_new_F","OfficeTable_01_old_F"]

private _buildingList = [
	[
		"o_recon",
		[
			["O","Land_CampingTable_F", [-1.625,-2.125,0], 0],
			["O","Land_Sacks_heap_F", [-1.875,2.25,0], 165],
			["S","CamoNet_BLUFOR_open_F", [0,0,0.625], 90],
			["S","Land_BagFence_Long_F", [-0.375,7.625,0], 0],
			["S","Land_BagFence_Long_F", [2.875,-6.625,0], 180],
			["S","Land_BagFence_Long_F", [5.875,-3.375,0], 270],
			["S","Land_BagFence_Round_F", [-2.875,6.875,0], 129],
			["S","Land_BagFence_Round_F", [0.5,-6.125,0], 35],
			["S","Land_BagFence_Round_F", [2,7.125,0], 215],
			["S","Land_BagFence_Round_F", [5.375,-5.875,0], 309],
			["S","Land_CampingChair_V2_F", [-1.125,-1.5,0], 30],
			["S","Land_NetFence_03_m_3m_F", [-2,-2.75,0], 180],
			["S","Land_NetFence_03_m_3m_F", [-2,3.25,0], 0],
			["S","Land_NetFence_03_m_3m_F", [-3.5,1.75,0], 270],
			["S","Land_NetFence_03_m_3m_F", [1,3.25,0], 0],
			["S","Land_NetFence_03_m_3m_F", [2.5,-1.25,0], 90],
			["S","Land_NetFence_03_m_3m_d_F", [1,-2.75,0], 180],
			["S","Land_NetFence_03_m_3m_hole_F", [-3.5,-1.25,0], 270],
			["S","Land_NetFence_03_m_3m_hole_F", [2.5,1.75,0], 90],
			["S","Land_Pallet_F", [-2.875,-5.875,0], 240],
			["S","Land_Pallet_F", [1.375,2.25,0], 255],
			["S","Land_PaperBox_closed_F", [-4.375,2.5,0], 0],
			["S","Land_PaperBox_closed_F", [-5.125,0.75,0], 210],
			["S","Land_Sacks_goods_F", [-6.125,2.125,0], 255],
			["V", selectRandom (_vehL + _vehM), [8.25,4.49805,0.2], 15],
			["V", selectRandom _hmgArr, [-0.125,6.375,0.2], 0],
			["V", selectRandom _hmgArr, [2.625,-5.375,0.2], 180]
		]
	],
	[
		"o_recon",
		[
			["O","Land_CampingTable_F", [-2.75,-3.375,0], 0],
			["O","Land_Sacks_heap_F", [-3.25,-1.125,0], 90],
			["O","Land_TinWall_01_m_gate_v2_F", [1.625,-4.25,0], 0],
			["S","CamoNet_BLUFOR_open_F", [-0.25,-0.125,0.625], 90],
			["S","Land_CampingChair_V2_F", [-2.25,-2.75,0], 30],
			["S","Land_CratesWooden_F", [-2,4.875,0], 0],
			["S","Land_FieldToilet_F", [-2.875,1.125,0], 270],
			["S","Land_Pallets_stack_F", [-0.5,2.5,0], 165],
			["S","Land_PaperBox_closed_F", [1.375,2.5,0], 0],
			["S","Land_TinWall_01_m_4m_v1_F", [-4.25,-2.25,0], 90],
			["S","Land_TinWall_01_m_4m_v1_F", [1.625,3.625,0], 180],
			["S","Land_TinWall_01_m_4m_v1_F", [3.625,-2.25,0], 270],
			["S","Land_TinWall_01_m_4m_v1_F", [3.625,1.625,0], 270],
			["S","Land_TinWall_01_m_4m_v2_F", [-2.25,3.625,0], 180],
			["S","Land_TinWall_01_m_4m_v2_F", [-2.38867,-4.2124,0], 0],
			["S","Land_TinWall_01_m_4m_v2_F", [-4.25,1.625,0], 90],
			["V", selectRandom (_vehL + _vehM), [6.25,1.12305,0.2], 0],
			["V", selectRandom _hmgArr, [-2.875,-6.375,0.2], 180]
		]
	],
	[
		"o_recon",
		[
			["O","Land_NetFence_01_m_gate_F", [-3.875,2.25,0], 90],
			["O","Land_Sacks_heap_F", [-2.375,-2.125,0], 15],
			["O","Land_WoodenTable_large_F", [1.375,3,0], 0],
			["S","CamoNet_BLUFOR_open_F", [-0.375,0.25,0.625], 180],
			["S","Land_BagFence_Long_F", [-0.125,8.75,0], 0],
			["S","Land_BagFence_Round_F", [-2.625,8,0], 129],
			["S","Land_BagFence_Round_F", [2.25,8.25,0], 215],
			["S","Land_ChairWood_F", [0.75,2.50293,0], 255],
			["S","Land_ChairWood_F", [2,3.37793,0], 75],
			["S","Land_CratesShabby_F", [-4.625,-1,0], 0],
			["S","Land_FieldToilet_F", [6.375,2.625,0], 285],
			["S","Land_FieldToilet_F", [6.75,4.5,0], 255],
			["S","Land_NetFence_01_m_4m_F", [-1.875,-3.75,0], 0],
			["S","Land_NetFence_01_m_4m_F", [-1.875,4.25,0], 0],
			["S","Land_NetFence_01_m_4m_F", [-3.875,-1.75,0], 90],
			["S","Land_NetFence_01_m_4m_F", [2.125,-3.75,0], 180],
			["S","Land_NetFence_01_m_4m_F", [2.125,4.25,0], 180],
			["S","Land_NetFence_01_m_d_F", [4.125,-1.75,0], 270],
			["S","Land_NetFence_01_m_d_F", [4.125,2.25,0], 90],
			["S","Land_NetFence_01_m_pole_F", [0.125,-3.75,0], 0],
			["S","Land_NetFence_01_m_pole_F", [0.125,4.25,0], 0],
			["S","Land_NetFence_01_m_pole_F", [4.125,0.25,0], 0],
			["S","Land_Pallets_F", [0.625,-2.125,0], 300],
			["S","Land_Pallets_stack_F", [2.5,-2.375,0], 0],
			["S","Land_PaperBox_closed_F", [-3.125,-4.75,0], 0],
			["S","Land_PaperBox_closed_F", [-5.875,-2.625,0], 210],
			["V", selectRandom (_vehL + _vehM), [-0.5,-7.62695,0.2], 255],
			["V", selectRandom _hmgArr, [0.125,7.5,0.2], 0]
		]
	],
	[
		"o_installation",
		[
			["O","Land_CampingTable_F", [-4,0.5,0], 0],
			["O","Land_Sacks_heap_F", [1,0.875,0], 330],
			["S","Land_BagFence_Long_F", [-0.75,9.25,0], 0],
			["S","Land_BagFence_Round_F", [-3.25,8.5,0], 129],
			["S","Land_BagFence_Round_F", [1.625,8.75,0], 215],
			["S","Land_CampingChair_V2_F", [-3.5,1.125,0], 30],
			["S","Land_CratesWooden_F", [-0.5,-3.625,0], 0],
			["S","Land_FoodSacks_01_large_brown_F", [3.5,3,0], 330],
			["S","Land_Mil_WallBig_4m_battered_F", [-2.125,-5.125,0], 0],
			["S","Land_Mil_WallBig_4m_battered_F", [-5.125,-2.125,0], 90],
			["S","Land_Mil_WallBig_4m_battered_F", [-5.125,1.875,0], 90],
			["S","Land_Mil_WallBig_4m_damaged_center_F", [4.875,-2.125,0], 270],
			["S","Land_Mil_WallBig_4m_damaged_left_F", [4.875,1.875,0], 270],
			["S","Land_Mil_WallBig_4m_damaged_right_F", [1.875,-5.125,0], 0],
			["S","Land_Mil_WallBig_corner_battered_F", [-4.875,-4.875,0], 0],
			["S","Land_Mil_WallBig_corner_battered_F", [-4.875,4.625,0], 90],
			["S","Land_Mil_WallBig_corner_battered_F", [4.625,4.625,0], 180],
			["S","Land_Mil_WallBig_debris_F", [3.875,-3,0], 150],
			["S","Land_Pallets_stack_F", [-3.125,-3.5,0], 30],
			["S","Land_PaperBox_01_open_empty_F", [6.75,3.75,0], 30],
			["S","Land_PaperBox_01_small_ransacked_brown_F", [3.125,4.375,0], 285],
			["S","Land_PaperBox_closed_F", [-3,5.25,0], 0],
			["S","Land_PaperBox_closed_F", [-3.875,3.5,0], 210],
			["V", selectRandom (_vehL + _vehM), [7.75,-6.87695,0.2], 195],
			["V", selectRandom _hmgArr, [-0.5,8,0.2], 0]
		]
	],
	[
		"o_installation",
		[
			["O","Land_Sacks_heap_F", [-3.375,-3,0], 15],
			["O","Land_WoodenTable_large_F", [2.375,-3.125,0], 30],
			["S","Land_BagFence_Corner_F", [-7.75,8.875,0], 270],
			["S","Land_BagFence_Short_F", [-6.479,9.20264,0], 0],
			["S","Land_BagFence_Short_F", [-8.104,7.45264,0], 90],
			["S","Land_ChairWood_F", [1.61133,-3.24658,0], 285],
			["S","Land_ChairWood_F", [3.13135,-3.11377,0], 105],
			["S","Land_FieldToilet_F", [4.625,5.5,0], 105],
			["S","Land_Mil_WallBig_4m_F", [-2.5,-5.125,0], 0],
			["S","Land_Mil_WallBig_4m_F", [-5.5,-2.125,0], 90],
			["S","Land_Mil_WallBig_4m_F", [-5.5,1.875,0], 90],
			["S","Land_Mil_WallBig_4m_F", [1.5,-5.125,0], 0],
			["S","Land_Mil_WallBig_4m_F", [4.5,-2.125,0], 270],
			["S","Land_Mil_WallBig_4m_F", [4.5,1.875,0], 270],
			["S","Land_Mil_WallBig_Corner_F", [-5.25,-4.875,0], 0],
			["S","Land_Mil_WallBig_Corner_F", [-5.25,4.625,0], 90],
			["S","Land_Mil_WallBig_Corner_F", [4.25,-4.875,0], 270],
			["S","Land_Mil_WallBig_Corner_F", [4.25,4.625,0], 180],
			["S","Land_Pallets_F", [3.25,1.125,0], 0],
			["S","Land_PaperBox_01_small_open_white_IDAP_F", [3.5,2.5,0], 315],
			["S","Land_PaperBox_closed_F", [-3.5,4.25,0], 210],
			["S","Land_PaperBox_closed_F", [-3.75,6.125,0], 285],
			["S","Land_PaperBox_closed_F", [-4.25,2.375,0], 0],
			["V", selectRandom (_vehL + _vehM), [6,10.123,0.2], 75],
			["V", selectRandom _hmgArr, [-6.625,8.125,0.2], 270]
		]
	],
	[
		"o_recon",
		[
			["O","Land_Sacks_heap_F", [-0.125,1.75,0], 150],
			["O","Land_WoodenTable_large_F", [-6,0.625,0], 30],
			["S","CamoNet_BLUFOR_open_F", [0,0,0.625], 90],
			["S","Land_BagFence_Corner_F", [-6.5,5.25,0], 270],
			["S","Land_BagFence_Corner_F", [6,-6,0], 90],
			["S","Land_BagFence_Short_F", [-5.229,5.57764,0], 0],
			["S","Land_BagFence_Short_F", [-6.854,3.82764,0], 90],
			["S","Land_BagFence_Short_F", [4.729,-6.32764,0], 180],
			["S","Land_BagFence_Short_F", [6.354,-4.57764,0], 270],
			["S","Land_ChairWood_F", [-5.24365,0.63623,0], 105],
			["S","Land_ChairWood_F", [-6.76367,0.503418,0], 285],
			["S","Land_CratesWooden_F", [-2.125,1,0], 90],
			["S","Land_FieldToilet_F", [-4.125,-4.375,0], 105],
			["S","Land_FoodSacks_01_small_brown_F", [1.125,-2,0.2], 300],
			["S","Land_IndFnc_3_D_F", [-3.375,-1.62549,0], 270],
			["S","Land_IndFnc_3_D_F", [2.625,1.37451,0], 90],
			["S","Land_IndFnc_3_F", [-1.875,-3.12549,0], 180],
			["S","Land_IndFnc_3_F", [-1.875,2.87451,0], 0],
			["S","Land_IndFnc_3_F", [-3.375,1.37451,0], 270],
			["S","Land_IndFnc_3_F", [1.125,2.87451,0], 0],
			["S","Land_IndFnc_3_F", [2.625,-1.62549,0], 90],
			["S","Land_IndFnc_3_Hole_F", [1.125,-3.125,0], 180],
			["S","Land_Pallet_F", [1.125,-2,0], 0],
			["S","Land_PaperBox_closed_F", [-0.875,4.5,0], 210],
			["S","Land_PaperBox_closed_F", [1.25,4.375,0], 0],
			["V", selectRandom (_vehL + _vehM), [9.75,5.49805,0.2], 15],
			["V", selectRandom _hmgArr, [4.875,-5.25,0.2], 90]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_Sacks_heap_F", [1.25,-1.875,0], 330],
			["O","Land_WoodenTable_large_F", [-1.125,2.25,0], 90],
			["S","Land_BagFence_Short_F", [5.375,-3.125,0], 120],
			["S","Land_BagFence_Short_F", [6.07959,4.44482,0], 255],
			["S","Land_BagFence_Short_F", [6.25,-1.75,0], 120],
			["S","Land_BagFence_Short_F", [6.5,2.875,0], 255],
			["S","Land_BagFence_Short_F", [6.64697,-0.263672,0], 90],
			["S","Land_BagFence_Short_F", [6.64697,1.36133,0], 90],
			["S","Land_ChairWood_F", [-0.689941,1.58057,0], 165],
			["S","Land_FieldToilet_F", [-2.875,-2.125,0], 195],
			["S","Land_FoodSack_01_full_brown_F", [0.25,2.25,0], 45],
			["S","Land_FoodSacks_01_small_brown_F", [1.25,2.375,0], 60],
			["S","Land_FoodSacks_01_small_brown_F", [2.03369,2.82568,0], 165],
			["S","Land_Pallets_F", [2,-4.5,0], 120],
			["S","Land_PaperBox_closed_F", [-0.875,-2.375,0], 210],
			["S","Land_Wall_IndCnc_2deco_F", [-1,3,0], 0],
			["S","Land_Wall_IndCnc_2deco_F", [-2,-3.875,0], 180],
			["S","Land_Wall_IndCnc_2deco_F", [-3.625,2,0], 135],
			["S","Land_Wall_IndCnc_2deco_F", [-4.125,-2.75,0], 255],
			["S","Land_Wall_IndCnc_2deco_F", [1,-3.5,0], 165],
			["S","Land_Wall_IndCnc_2deco_F", [2,3.375,0], 345],
			["S","Land_Wall_IndCnc_2deco_F", [2.875,-1.625,0], 105],
			["V", selectRandom (_vehL + _vehM), [-5,5.87305,0.2], 255],
			["V", selectRandom _hmgArr, [5.125,-0.875,0.2], 120]
		]
	],
	[
		"o_installation",
		[
			["O","Land_Sacks_heap_F", [0.125,-2.125,0], 0],
			["O","Land_WoodenTable_large_F", [-2.75,-1.75,0], 180],
			["S","Land_BagFence_Corner_F", [-5.771,6.29736,0], 270],
			["S","Land_BagFence_Corner_F", [4.5,6.125,0], 0],
			["S","Land_BagFence_Short_F", [-4.5,6.625,0], 0],
			["S","Land_BagFence_Short_F", [-6.125,4.875,0], 90],
			["S","Land_BagFence_Short_F", [3.07764,6.479,0], 180],
			["S","Land_BagFence_Short_F", [4.82764,4.854,0], 90],
			["S","Land_CamoConcreteWall_01_l_4m_d_v1_F", [1.875,-0.25,0], 270],
			["S","Land_CamoConcreteWall_01_l_4m_v1_F", [-0.75,-3.125,0], 0],
			["S","Land_CamoConcreteWall_01_l_4m_v1_F", [-3.625,-0.125,0], 90],
			["S","Land_CamoConcreteWall_01_l_end_v1_F", [-2.5,2.625,0], 0],
			["S","Land_CamoConcreteWall_01_l_end_v1_F", [1.125,3,0], 180],
			["S","Land_ChairWood_F", [-2.1123,-1.35449,0], 75],
			["S","Land_CratesWooden_F", [0.625,-4.375,0], 0],
			["S","Land_FoodSacks_01_large_brown_F", [1.25,1.875,0], 0],
			["S","Land_FoodSacks_01_small_brown_F", [-2.625,-0.375,0], 330],
			["S","Land_Pallets_stack_F", [-2.25,4.375,0], 45],
			["S","Land_PaperBox_closed_F", [-2.5,1.625,0], 0],
			["V", selectRandom (_vehL + _vehM), [-6,-4.87695,0.2], 165],
			["V", selectRandom _hmgArr, [3.75,5,0.2], 0]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_CampingTable_F", [2.5,1.375,0], 270],
			["O","Land_Sacks_heap_F", [1.625,-2,0], 300],
			["S","Land_BagFence_Corner_F", [6.271,-7.92236,0], 90],
			["S","Land_BagFence_Short_F", [5,-8.25,0], 180],
			["S","Land_BagFence_Short_F", [6.625,-1.5,0], 270],
			["S","Land_BagFence_Short_F", [6.625,-3.125,0], 270],
			["S","Land_BagFence_Short_F", [6.625,-4.875,0], 270],
			["S","Land_BagFence_Short_F", [6.625,-6.5,0], 270],
			["S","Land_CampingChair_V2_F", [1.875,1.875,0], 300],
			["S","Land_CratesWooden_F", [0.625,5,0], 0],
			["S","Land_FoodSacks_01_cargo_brown_F", [-3.375,1.375,0], 0],
			["S","Land_Mil_WiredFenceD_F", [-0.75,-3.75,0], 0],
			["S","Land_Mil_WiredFence_F", [-0.689941,3.26807,0], 180],
			["S","Land_Mil_WiredFence_F", [-4.18994,-0.231934,0], 90],
			["S","Land_Mil_WiredFence_F", [2.81006,-0.231934,0], 270],
			["S","Land_Pallets_stack_F", [4.125,2.125,0], 0],
			["S","Land_PaperBox_closed_F", [-3.125,-2.375,0], 210],
			["S","Land_PaperBox_closed_F", [-3.25,-0.5,0], 0],
			["V", selectRandom (_vehL + _vehM), [-7.75,-5,0.2], 330],
			["V", selectRandom _hmgArr, [4.75,-6.875,0.2], 180]
		]
	],
	[
		"o_installation",
		[
			["O","Land_CampingTable_F", [1.375,2.75,0], 180],
			["O","Land_Sacks_heap_F", [3,-3.5,0], 330],
			["S","Land_BagFence_Short_F", [-6.875,-2.5,0], 85],
			["S","Land_BagFence_Short_F", [-7,-0.875,0], 85],
			["S","Land_BagFence_Short_F", [5.52979,-3.2959,0], 325],
			["S","Land_BagFence_Short_F", [6.75,-2.125,0], 310],
			["S","Land_Bunker_01_blocks_1_F", [-1,-5.375,0], 180],
			["S","Land_Bunker_01_blocks_1_F", [-2.75,-5.125,0], 195],
			["S","Land_Bunker_01_blocks_1_F", [-4.375,-4.375,0], 210],
			["S","Land_Bunker_01_blocks_1_F", [-6.5,4.125,0], 300],
			["S","Land_Bunker_01_blocks_1_F", [-7.125,2.5,0], 285],
			["S","Land_Bunker_01_blocks_1_F", [-7.375,0.75,0], 270],
			["S","Land_Bunker_01_blocks_1_F", [0.75,-5.375,0], 180],
			["S","Land_Bunker_01_blocks_1_F", [2.5,-5.25,0], 165],
			["S","Land_Bunker_01_blocks_1_F", [4.25,-4.5,0], 150],
			["S","Land_Bunker_01_blocks_1_F", [5.875,3.625,0], 60],
			["S","Land_Bunker_01_blocks_1_F", [6.5,2,0], 75],
			["S","Land_Bunker_01_blocks_1_F", [6.75,0.25,0], 90],
			["S","Land_Bunker_01_small_F", [-0.125,5.375,0], 180],
			["S","Land_CampingChair_V2_F", [1.88916,2.20898,0], 150],
			["S","Land_CratesWooden_F", [-0.5,-3.75,0], 0],
			["S","Land_PaperBox_open_full_F", [-3.25,-3.125,0], 120],
			["V", selectRandom (_vehL + _vehM), [-3.875,-11.252,0.2], 105],
			["V", selectRandom _hmgArr, [-5.75,-1.5,0.2], 270],
			["V", selectRandom _hmgArr, [5,-2,0.2], 135]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_CampingTable_F", [-3.25,-2,0], 150],
			["O","Land_Sacks_heap_F", [3.875,-2.375,0], 105],
			["S","Land_BagBunker_Small_F", [-3.25,2.5,0], 150],
			["S","Land_BagFence_Long_F", [1.125,4.125,0], 180],
			["S","Land_BagFence_Round_F", [-6.25,-4.25,0], 45],
			["S","Land_BagFence_Round_F", [-6.25,1.125,0], 135],
			["S","Land_BagFence_Round_F", [3.62549,3.49951,0], 225],
			["S","Land_BagFence_Round_F", [5.625,-4.125,0], 315],
			["S","Land_BagFence_Short_F", [-1,4.125,0], 180],
			["S","Land_BagFence_Short_F", [-2.625,-5,0], 0],
			["S","Land_BagFence_Short_F", [-4.375,-5,0], 0],
			["S","Land_BagFence_Short_F", [-6.875,-0.625,0], 270],
			["S","Land_BagFence_Short_F", [-6.875,-2.25,0], 270],
			["S","Land_BagFence_Short_F", [3.75,-4.75,0], 180],
			["S","Land_BagFence_Short_F", [4.25,1.5,0], 90],
			["S","Land_BagFence_Short_F", [6.25,-2.25,0], 270],
			["S","Land_BarrelTrash_grey_F", [0.875,-3.125,0], 0],
			["S","Land_CampingChair_V2_F", [-2.53418,-2.21143,0], 120],
			["S","Land_CratesWooden_F", [-0.179199,-1.83301,0], 0],
			["S","Land_PaperBox_open_empty_F", [2.0708,-2.33301,0], 0],
			["S","Land_PaperBox_open_full_F", [1.32031,-0.33,0], 120],
			["S","Land_Razorwire_F", [-4.6792,6.66699,0], 165],
			["S","Land_Razorwire_F", [3.0708,6.79199,0], 195],
			["V", selectRandom (_vehL + _vehM), [-11.125,0.623047,0.2], 0],
			["V", selectRandom _hmgArr, [-3.25,2.5,0.2], 330]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_CampingTable_F", [6.75,0,0], 90],
			["O","Land_Sacks_heap_F", [0.5,-2.25,0], 60],
			["S","Land_BagBunker_Small_F", [0,4.125,0], 180],
			["S","Land_BagFence_Corner_F", [5.125,2.125,0], 0],
			["S","Land_BagFence_Corner_F", [5.23975,-3.75195,0], 90],
			["S","Land_BagFence_Long_F", [3.5,-4.125,0], 180],
			["S","Land_BagFence_Round_F", [-3.20801,2.91406,0], 135],
			["S","Land_BagFence_Round_F", [-3.25,0.75,0], 45],
			["S","Land_BagFence_Short_F", [3.75,2.375,0], 0],
			["S","Land_BagFence_Short_F", [5.5,-2.375,0], 90],
			["S","Land_CampingChair_V2_F", [7.29102,0.51416,0], 60],
			["S","Land_CratesPlastic_F", [1.5,-5.125,0], 60],
			["S","Land_CratesWooden_F", [3.75,-0.25,0], 90],
			["S","Land_GarbagePallet_F", [-3.25,-3.875,0], 195],
			["S","Land_GarbageWashingMachine_F", [-0.51,-5.3,0], 315],
			["S","Land_HBarrier_3_F", [5.5,0.125,0], 90],
			["S","Land_Razorwire_F", [-6.75,2.25,0], 90],
			["S","Land_Tyre_F", [-0.943848,-3.021,0], 195],
			["S","Land_Wreck_Ural_F", [-3.5,-6.625,0], 120],
			["S","MetalBarrel_burning_F", [4.125,-2.125,0], 300],
			["V", selectRandom (_vehL + _vehM), [6.75,-8.5,0.2], 75],
			["V", selectRandom _hmgArr, [0.25,4.125,0.2], 0]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_CampingTable_F", [1.375,-1,0], 150],
			["O","Land_Sacks_heap_F", [-2.375,-2.625,0], 0],
			["S","Land_BagBunker_Small_F", [-3.35815,1.41455,0], 180],
			["S","Land_BagFence_Long_F", [-2.10815,-3.83545,0], 0],
			["S","Land_BagFence_Long_F", [-4.98315,-0.585449,0], 270],
			["S","Land_BagFence_Long_F", [3.52222,2.1084,0], 90],
			["S","Land_BagFence_Round_F", [-0.852783,4.6084,0], 135],
			["S","Land_BagFence_Round_F", [-4.3584,-3.21045,0], 45],
			["S","Land_BagFence_Round_F", [2.94995,4.61914,0], 225],
			["S","Land_BagFence_Short_F", [1.02222,5.2334,0], 180],
			["S","Land_CampingChair_V2_F", [2.09082,-1.21143,0], 120],
			["S","Land_CratesShabby_F", [-1.25,-4.5,0], 96],
			["S","Land_CratesShabby_F", [4.51685,-3.08545,0], 312],
			["S","Land_GarbagePallet_F", [2.89185,-3.83545,0], 54],
			["S","Land_Pallet_MilBoxes_F", [-2.625,-5,0], 180],
			["S","MetalBarrel_burning_F", [0.516846,-0.335449,0], 300],
			["V", selectRandom _hmgArr, [-3.125,1.25,0.2], 0]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_CampingTable_F", [3,-6.25,0], 270],
			["O","Land_Sacks_heap_F", [-0.875,-4.125,0], 180],
			["S","Land_BagBunker_Small_F", [0.296387,1.07861,0], 180],
			["S","Land_BagFence_Long_F", [-1.125,-3.25,0], 0],
			["S","Land_BagFence_Long_F", [-3.0459,0.490234,0], 180],
			["S","Land_BagFence_Long_F", [2.00049,-0.931152,0], 270],
			["S","Land_BagFence_Round_F", [2.62549,-3.55615,0], 45],
			["S","Land_BarrelSand_F", [3.17139,-4.79639,0], 0],
			["S","Land_CampingChair_V2_F", [2.45898,-6.76416,0], 240],
			["S","Land_CratesShabby_F", [-3.125,-4.625,0], 336],
			["S","Land_CratesWooden_F", [-4.875,-5,0], 0],
			["S","Land_HBarrier_3_F", [-4.125,-3.25,0], 0],
			["S","Land_HBarrier_3_F", [-5.0459,-0.884766,0], 90],
			["S","Land_HBarrier_3_F", [4.37549,-5.55615,0], 90],
			["S","Land_Pallets_F", [3.54639,-1.42139,0], 165],
			["S","Land_PaperBox_open_empty_F", [-3.375,-1.5,0], 0],
			["S","Land_Razorwire_F", [0.250488,5.69385,0], 180],
			["V", selectRandom (_vehL + _vehM), [-3.75,-9.37695,0.2], 285],
			["V", selectRandom _hmgArr, [0.375,1.25,0.2], 0]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_CampingTable_F", [-4,-4.875,0], 180],
			["O","Land_Sacks_heap_F", [2.625,-6,0], 105],
			["S","Land_BagBunker_Tower_F", [-0.100586,2.57666,0], 90],
			["S","Land_BagFence_End_F", [-5.19727,0.282715,0], 180],
			["S","Land_BagFence_End_F", [-7.07227,-1.71729,0], 90],
			["S","Land_BagFence_End_F", [5.80273,-2.34277,0], 270],
			["S","Land_BagFence_Round_F", [-6.44727,-0.342285,0], 135],
			["S","Land_BagFence_Round_F", [-6.44751,-2.96729,0], 45],
			["S","Land_BagFence_Round_F", [5.05273,-3.71777,0], 315],
			["S","Land_BagFence_Round_F", [5.17798,-1.09229,0], 225],
			["S","Land_BarrelSand_F", [3.14941,-0.79834,0], 0],
			["S","Land_CampingChair_V2_F", [-3.48584,-5.41602,0], 150],
			["S","Land_CratesWooden_F", [0.625,-6.375,0], 0],
			["S","Land_HBarrier_3_F", [-3.94727,-3.59229,0], 0],
			["S","Land_PaperBox_closed_F", [1.14941,-4.79883,0], 0],
			["S","Land_PaperBox_open_empty_F", [-7.125,-4.5,0], 120],
			["V", selectRandom (_vehL + _vehM), [-1,-10.877,0.2], 105],
			["V", selectRandom _hmgArr, [-1.25,2.75,2.8], 0]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_CampingTable_F", [-4.75,0.25,0], 180],
			["O","Land_Sacks_heap_F", [-1.875,-7.25,0], 180],
			["S","Land_BagBunker_Tower_F", [1.34814,1.73975,0], 90],
			["S","Land_BagFence_Corner_F", [4.12012,3.28174,2.75], 180],
			["S","Land_BagFence_Corner_F", [4.24512,0.531738,2.75], 90],
			["S","Land_BagFence_End_F", [0.745117,0.156738,2.75], 180],
			["S","Land_BagFence_Long_F", [-6.15186,3.61475,0], 90],
			["S","Land_BagFence_Long_F", [-6.375,-0.625,0], 90],
			["S","Land_BagFence_Long_F", [0.598145,-5.88525,0], 180],
			["S","Land_BagFence_Long_F", [2.12012,3.53174,2.75], 180],
			["S","Land_BagFence_Long_F", [2.37012,0.156738,2.75], 180],
			["S","Land_BagFence_Long_F", [4.49512,1.65674,2.75], 270],
			["S","Land_BagFence_Round_F", [-3.27661,5.86475,0], 225],
			["S","Land_BagFence_Round_F", [-5.44092,5.90674,0], 135],
			["S","Land_BagFence_Round_F", [3.09814,-5.26025,0], 315],
			["S","Land_CampingChair_V2_F", [-4.23584,-0.291016,0.2], 150],
			["S","Land_GarbageBags_F", [-4.75,-6.625,0], 0],
			["S","Land_HBarrier_3_F", [-2.27686,-5.63525,0], 180],
			["S","Land_HBarrier_3_F", [-5.02686,1.61475,0], 0],
			["S","Land_HBarrier_3_F", [3.84814,-2.63525,0], 90],
			["S","Land_Pallets_F", [-7.375,-7.5,0], 255],
			["S","Land_PaperBox_open_full_F", [0.598145,-2.13525,0], 75],
			["V", selectRandom (_vehL + _vehM), [-11.375,0.623047,0], 345],
			["V", selectRandom _hmgArr, [-4.125,5.25,0.2], 0],
			["V", selectRandom _hmgArr, [2.75,2,2.8], 0]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_CampingTable_F", [6.875,1.875,0], 180],
			["O","Land_Sacks_heap_F", [-5,0.625,0], 240],
			["S","Land_BagBunker_Tower_F", [0.677246,2.31348,0], 90],
			["S","Land_CampingChair_V2_F", [7.38916,1.33398,0], 150],
			["S","Land_HBarrier_1_F", [-6.94775,2.31348,0], 195],
			["S","Land_HBarrier_1_F", [10.0522,-0.186523,0], 345],
			["S","Land_HBarrier_3_F", [-5.19775,2.56348,0], 165],
			["S","Land_HBarrier_3_F", [-7.57275,-2.93652,0], 90],
			["S","Land_HBarrier_3_F", [6.67725,3.18848,0], 0],
			["S","Land_HBarrier_3_F", [8.55225,-4.18652,0], 0],
			["S","Land_HBarrier_Big_F", [0.80249,-4.56152,0], 180],
			["S","Land_MetalBarrel_F", [2.92725,-1.06152,0], 270],
			["S","Land_MetalBarrel_F", [3.302,-1.71094,0], 60],
			["S","Land_MetalBarrel_F", [3.71875,-1.18213,0], 195],
			["S","Land_Pallet_MilBoxes_F", [4.05225,-6.31152,0], 345],
			["S","Land_Pallets_F", [-8.375,2.875,0], 270],
			["S","Land_Pallets_stack_F", [-1.57275,-6.68652,0], 0],
			["S","Land_PaperBox_closed_F", [0.302246,-6.56152,0], 345],
			["S","Land_PaperBox_closed_F", [2.05225,-6.56152,0], 180],
			["V", selectRandom _hmgArr, [-0.375,2.375,2.8], 0]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_CampingTable_F", [2.625,-2.625,0], 270],
			["O","Land_Sacks_heap_F", [-1.375,-4.625,0], 60],
			["S","Land_BagBunker_Tower_F", [0.121582,1.479,0], 90],
			["S","Land_BagFence_Round_F", [-2,-5.625,0], 45],
			["S","Land_BagFence_Round_F", [3.375,-5.625,0], 315],
			["S","Land_BagFence_Round_F", [7.12158,0.479004,0], 315],
			["S","Land_BagFence_Round_F", [7.12183,2.479,0], 225],
			["S","Land_BagFence_Short_F", [-0.25,-6.25,0], 180],
			["S","Land_BagFence_Short_F", [-2.625,-3.75,0], 270],
			["S","Land_BagFence_Short_F", [1.5,-6.25,0], 0],
			["S","Land_BagFence_Short_F", [5.24658,3.229,0], 180],
			["S","Land_CampingChair_V2_F", [2.08398,-3.13916,0], 240],
			["S","Land_HBarrier_3_F", [3.99658,-2.896,0], 90],
			["V", selectRandom (_vehL + _vehM), [-8.75,-2.50195,0.2], 345],
			["V", selectRandom _hmgArr, [-1.625,1.625,2.8], 0],
			["V", selectRandom _hmgArr, [1.125,-4.875,0.2], 180]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_Sacks_heap_F", [2.625,-2.125,0], 180],
			["O","Land_WoodenTable_small_F", [-1.25,-4.125,0], 120],
			["S","Land_BagBunker_Tower_F", [-1.47388,1.74951,0], 90],
			["S","Land_BagFence_Long_F", [-2.74976,-5.875,0], 180],
			["S","Land_BagFence_Long_F", [-5.59888,-2.62549,0], 270],
			["S","Land_BagFence_Long_F", [6.27612,1.24951,0], 90],
			["S","Land_BagFence_Round_F", [-5,-5.25,0], 45],
			["S","Land_BagFence_Round_F", [1.25024,-5.25,0], 315],
			["S","Land_BagFence_Round_F", [5.62842,3.75391,0], 225],
			["S","Land_BagFence_Short_F", [-0.624756,-5.875,0], 180],
			["S","Land_BagFence_Short_F", [3.77612,4.49951,0], 180],
			["S","Land_ChairWood_F", [-1.00537,-3.58057,0], 15],
			["S","Land_CratesWooden_F", [-2.5,-7.125,0], 0],
			["S","Land_Pallets_stack_F", [-4.375,-2.25,0], 165],
			["S","Land_PaperBox_open_empty_F", [-6.75,-2.375,0], 0],
			["S","Land_PaperBox_open_full_F", [2.375,-6.5,0], 195],
			["S","Land_Razorwire_F", [-1.34888,5.49951,0], 180],
			["V", selectRandom (_vehL + _vehM), [9.625,-4.12695,0.2], 30],
			["V", selectRandom _hmgArr, [-2.26,1.46,2.8], 0],
			["V", selectRandom _hmgArr, [4.875,1.875,0.2], 90]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_Sacks_heap_F", [4.375,0.75,0], 180],
			["O","Land_WoodenTable_small_F", [1.375,-2,0], 270],
			["S","Land_BagBunker_Tower_F", [-1.4519,1.80322,0], 90],
			["S","Land_BagFence_Corner_F", [5.2981,1.55322,0], 0],
			["S","Land_BagFence_Corner_F", [5.41089,-3.93848,0], 90],
			["S","Land_BagFence_Long_F", [3.54614,-4.31152,0], 180],
			["S","Land_BagFence_Long_F", [5.67114,-0.186523,0], 270],
			["S","Land_BagFence_Short_F", [3.92114,1.81348,0], 0],
			["S","Land_BagFence_Short_F", [5.67114,-2.56201,0], 90],
			["S","Land_BarrelSand_F", [-2.5,-4.875,0], 0],
			["S","Land_ChairWood_F", [1.47266,-2.68555,0], 165],
			["S","Land_CratesWooden_F", [-4.75,-2.25,0], 180],
			["S","Land_HBarrier_3_F", [-2.3269,-2.82178,0], 90],
			["S","Land_Pallet_MilBoxes_F", [4.25,-6,0], 255],
			["S","Land_PaperBox_closed_F", [-1.125,-5.125,0], 225],
			["V", selectRandom (_vehL + _vehM), [-3.75,-9.00195,0.2], 285],
			["V", selectRandom _hmgArr, [-2.17,1.39,2.8], 0]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_Sacks_heap_F", [0.625,-4,0], 0],
			["O","Land_WoodenTable_small_F", [-3,-4.125,0], 105],
			["S","Land_BagBunker_Tower_F", [1.2312,2.68604,0], 90],
			["S","Land_ChairWood_F", [-2.91772,-3.53906,0], 0],
			["S","Land_HBarrier_1_F", [-2.646,-5.64209,0], 90],
			["S","Land_HBarrier_1_F", [-3.875,-5.5,0], 105],
			["S","Land_HBarrier_1_F", [-4.875,-4.875,0], 315],
			["S","Land_HBarrier_1_F", [-6.1228,3.45313,0], 240],
			["S","Land_HBarrier_3_F", [1.354,-5.64209,0], 180],
			["S","Land_HBarrier_3_F", [3.7522,-1.67188,0], 90],
			["S","Land_Pallets_F", [-6.25,1.75,0], 255],
			["S","Land_PaperBox_closed_F", [-1.0188,-1.18896,0], 90],
			["S","Land_WaterBarrel_F", [0.481201,-0.938965,0], 360],
			["S","MetalBarrel_burning_F", [-4.25,0.5,0], 300],
			["V", selectRandom (_vehL + _vehM), [-11.375,0,0.2], 345],
			["V", selectRandom _hmgArr, [0.168,2.57,2.8], 0]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_Sacks_heap_F", [1.375,-4.25,0], 180],
			["O","Land_WoodenTable_small_F", [-1.625,-1.5,0], 15],
			["S","Land_BagBunker_Small_F", [-2.31201,2.66846,0], 180],
			["S","Land_BagFence_Long_F", [-4.18701,0.293457,0], 90],
			["S","Land_BagFence_Long_F", [0.562988,-3.08105,0], 180],
			["S","Land_BagFence_Long_F", [0.687988,1.79395,0], 180],
			["S","Land_BagFence_Round_F", [3.06738,-2.43359,0], 315],
			["S","Land_BagFence_Round_F", [3.18823,1.16846,0], 225],
			["S","Land_BagFence_Short_F", [-4.43701,-1.95654,0], 105],
			["S","Land_BagFence_Short_F", [3.81299,-0.581055,0], 270],
			["S","Land_ChairWood_F", [-2.25537,-1.47461,0], 270],
			["S","Land_CratesShabby_F", [-0.563721,0.988281,0], 90],
			["S","Land_CratesShabby_F", [0.437988,0.918945,0], 0],
			["S","Land_Pallet_F", [1.875,3.5,0], 253],
			["S","Land_PaperBox_closed_F", [3.875,2.75,0], 300],
			["S","Land_Razorwire_F", [-1.18701,5.91846,0], 180],
			["S","MetalBarrel_burning_F", [-4.875,0.5,0], 300],
			["V", selectRandom (_vehL + _vehM), [-5.75,-6.25195,0.2], 285],
			["V", selectRandom _hmgArr, [-2,3,0.2], 0],
			["V", selectRandom _hmgArr, [2.75,-1,0.2], 90]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_Sacks_heap_F", [-6.50342,-3.2998,0], 210],
			["O","Land_WoodenTable_small_F", [-3.75,-2.75,0], 180],
			["S","Land_BagBunker_Small_F", [-0.175537,2.03223,0], 180],
			["S","Land_BagFence_Long_F", [-4.92554,-1.96777,0], 90],
			["S","Land_BagFence_Round_F", [-4.30054,0.532227,0], 135],
			["S","Land_BagFence_Round_F", [-4.30078,-4.34277,0], 45],
			["S","Land_BagFence_Round_F", [2.44971,0.407227,0], 225],
			["S","Land_BagFence_Round_F", [3.69922,-1.84277,0], 45],
			["S","Land_BagFence_Short_F", [-2.55054,-4.96777,0], 0],
			["S","Land_BagFence_Short_F", [-2.55054,1.15723,0], 180],
			["S","Land_ChairWood_F", [-3.10913,-2.70947,0], 75],
			["S","Land_Pallets_F", [-6.25,0.375,0], 120],
			["S","Land_Pallets_stack_F", [4.5,-1,0], 109],
			["S","Land_PaperBox_closed_F", [-6.375,-1.375,0], 225],
			["S","Land_PaperBox_open_empty_F", [-3.80054,-0.967773,0], 0],
			["S","Land_Razorwire_F", [-0.25,5.875,0], 180],
			["V", selectRandom (_vehL + _vehM), [0.875,-7.75195,0.2], 255],
			["V", selectRandom _hmgArr, [0.125,2.125,0.2], 0]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_Sacks_heap_F", [3,-1.875,0], 255],
			["O","Land_WoodenTable_small_F", [-0.451172,-5.2373,0], 255],
			["S","Land_BagBunker_Small_F", [1.38965,2.91455,0], 180],
			["S","Land_BagFence_Corner_F", [-3.75,0.75,0], 180],
			["S","Land_BagFence_Corner_F", [-3.87476,4.375,0], 270],
			["S","Land_BagFence_Corner_F", [3.76465,-0.835449,0], 0],
			["S","Land_BagFence_Long_F", [-2.125,4.75,0], 180],
			["S","Land_BagFence_Long_F", [-4.125,2.5,0], 90],
			["S","Land_BagFence_Long_F", [3.13965,0.789551,0], 270],
			["S","Land_BagFence_Long_F", [4.13965,-2.58545,0], 270],
			["S","Land_ChairWood_F", [-0.192383,-5.87744,0], 150],
			["S","Land_CratesPlastic_F", [-0.360352,-1.83545,0], 120],
			["S","Land_Pallet_F", [-2.48535,-4.58545,0], 95],
			["S","Land_Pallets_F", [-4.27466,-2.01416,0], 330],
			["S","Land_PaperBox_closed_F", [-0.735352,-3.21045,0], 195],
			["S","Land_PaperBox_closed_F", [-2.48535,-2.83545,0], 0],
			["S","Land_PaperBox_open_empty_F", [-1.61035,-1.08545,0], 105],
			["V", selectRandom (_vehL + _vehM), [3.5,-7.75195,0.2], 60],
			["V", selectRandom _hmgArr, [-3,3.625,0.2], 315],
			["V", selectRandom _hmgArr, [1.625,3.125,0.2], 0]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_Sacks_heap_F", [2.625,1.5,0], 180],
			["O","Land_WoodenTable_small_F", [-2,-0.75,0], 300],
			["S","Land_BagBunker_Small_F", [0.0510254,3.44629,0], 180],
			["S","Land_BagFence_Long_F", [-2.94897,2.44629,0], 0],
			["S","Land_BagFence_Long_F", [3,-3.625,0], 0],
			["S","Land_BagFence_Long_F", [3.17603,2.44629,0], 180],
			["S","Land_BagFence_Long_F", [6.25,-0.75,0], 90],
			["S","Land_BagFence_Round_F", [-5.32397,1.82129,0], 135],
			["S","Land_BagFence_Round_F", [0.749756,-2.875,0], 45],
			["S","Land_BagFence_Round_F", [5.5,-3,0], 315],
			["S","Land_BagFence_Round_F", [5.62524,1.75,0], 225],
			["S","Land_ChairWood_F", [-2.23193,-1.396,0], 195],
			["S","Land_Pallets_F", [-7.375,0.5,0], 210],
			["S","Land_PaperBox_closed_F", [-0.5,-3.625,0], 150],
			["S","Land_PaperBox_closed_F", [1.375,-4.75,0], 195],
			["V", selectRandom (_vehL + _vehM), [-5.875,-4.87695,0.2], 300],
			["V", selectRandom _hmgArr, [0.375,3.75,0.2], 0],
			["V", selectRandom _hmgArr, [5.125,-1,0.2], 90]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_CampingTable_F", [-3.5,-3,0], 270],
			["O","Land_Sacks_heap_F", [-0.375,-2,0], 0],
			["S","Land_BagBunker_Small_F", [4.125,0.5,0], 210],
			["S","Land_BagFence_Long_F", [0.845215,0.407227,0], 180],
			["S","Land_BagFence_Round_F", [-1.22705,3.04297,0], 225],
			["S","Land_BagFence_Round_F", [-5.03076,3.15137,0], 135],
			["S","Land_BagFence_Round_F", [-5.0791,-0.586426,0], 45],
			["S","Land_BagFence_Short_F", [-0.529785,1.15723,0], 270],
			["S","Land_BagFence_Short_F", [-3.07959,3.78857,0], 180],
			["S","Land_BagFence_Short_F", [-3.22656,-1.33203,0], 0],
			["S","Land_BagFence_Short_F", [-5.77637,1.29932,0], 90],
			["S","Land_BagFence_Short_F", [2.47021,-3.71777,0], 0],
			["S","Land_CampingChair_V2_F", [-4.04102,-3.51416,0], 240],
			["S","Land_GarbageWashingMachine_F", [0.25,5.75,0], 15],
			["S","Land_HBarrier_3_F", [-2.15479,-2.71777,0], 90],
			["S","Land_HBarrier_3_F", [0.0952148,-3.59277,0], 0],
			["S","Land_Pallets_stack_F", [2.22021,-5.21777,0], 330],
			["S","Land_PaperBox_open_empty_F", [-1.40479,-5.46777,0], 90],
			["S","Land_PaperBox_open_full_F", [0.345215,-5.46777,0], 90],
			["S","Land_WaterBarrel_F", [-2.90479,-5.21777,0], 360],
			["V", selectRandom (_vehL + _vehM), [10.875,-5.00195,0.2], 60],
			["V", selectRandom _hmgArr, [-2.875,2.625,0.2], 0],
			["V", selectRandom _hmgArr, [4.625,0.5,0.2], 30]
		]
	],
	[
		"o_installation",
		[
			["O","Land_Cargo_Patrol_V2_F", [-0.160645,-0.798828,0], 180],
			["O","Land_Sacks_heap_F", [-0.875,-5,0], 135],
			["O","Land_WoodenTable_small_F", [2.25,0.625,0], 0],
			["S","Land_BagFence_Long_F", [-4.16064,-1.79883,0], 90],
			["S","Land_BagFence_Long_F", [4.33936,-1.79883,0], 90],
			["S","Land_BagFence_Round_F", [-3.53564,-4.17383,0], 45],
			["S","Land_BagFence_Round_F", [3.71436,-4.17383,0], 315],
			["S","Land_BagFence_Short_F", [-0.910645,3.70117,0], 0],
			["S","Land_BagFence_Short_F", [0.589355,3.70117,0], 180],
			["S","Land_BarrelTrash_grey_F", [-0.160645,-2.54883,0], 360],
			["S","Land_ChairWood_F", [1.62158,0.482422,0], 255],
			["S","Land_CratesWooden_F", [-2.03564,1.45117,0], 285],
			["S","Land_GarbageBags_F", [-2.03564,-1.79883,0], 0],
			["S","Land_HBarrier_3_F", [-3.28564,3.70117,0], 180],
			["S","Land_HBarrier_3_F", [-4.16064,1.45117,0], 90],
			["S","Land_HBarrier_3_F", [2.96436,3.45117,0], 180],
			["S","Land_HBarrier_3_F", [3.83936,1.20117,0], 270],
			["V", selectRandom (_vehL + _vehM), [-9.5,-1,0.2], 0],
			["V", selectRandom _hmgArr, [-1.625,0.25,4.55], 0]
		]
	],
	[
		"o_installation",
		[
			["O","Land_Cargo_Patrol_V3_F", [-1.41602,1.9375,0], 180],
			["O","Land_Sacks_heap_F", [6.625,-2.125,0], 75],
			["O","Land_WoodenTable_small_F", [-1.25,-2.625,0], 165],
			["S","Land_BagFence_Long_F", [-3.16602,-5.4375,0], 0],
			["S","Land_BagFence_Long_F", [-6.16602,-2.4375,0], 90],
			["S","Land_BagFence_Long_F", [-6.16602,0.4375,0], 90],
			["S","Land_BagFence_Long_F", [5.45898,-2.6875,0], 90],
			["S","Land_BagFence_Round_F", [-5.41602,2.9375,0], 135],
			["S","Land_BagFence_Round_F", [-5.54126,-4.8125,0], 45],
			["S","Land_BagFence_Round_F", [4.70898,-4.9375,0], 315],
			["S","Land_BagFence_Short_F", [-0.916016,-5.4375,0], 0],
			["S","Land_BagFence_Short_F", [2.95898,-5.5625,0], 180],
			["S","Land_BarrelSand_F", [-4.54102,2.1875,0], 0],
			["S","Land_ChairWood_F", [-0.654297,-2.42285,0], 60],
			["S","Land_CratesWooden_F", [7.20898,1.6875,0], 270],
			["S","Land_HBarrier_3_F", [-2.79102,3.4375,0], 180],
			["S","Land_HBarrier_3_F", [0.458984,3.4375,0], 180],
			["S","Land_HBarrier_3_F", [5.45898,0.4375,0], 90],
			["S","Land_MetalBarrel_F", [-1.5,-6.75,0], 225],
			["S","Land_MetalBarrel_F", [-2.125,-7,0], 90],
			["S","Land_MetalBarrel_F", [-2.12524,-6.25,0], 300],
			["S","Land_Pallet_MilBoxes_F", [-3.25,-6.625,0], 180],
			["S","Land_WaterBarrel_F", [7.08398,-0.3125,0], 0],
			["S","Land_WaterTank_F", [-3.16602,0.8125,0], 90],
			["S","MetalBarrel_burning_F", [-3.41602,-1.1875,0], 90],
			["V", selectRandom (_vehL + _vehM), [-10.375,0.5,0.2], 0],
			["V", selectRandom _hmgArr, [-5,-3.25,0.2], 270],
			["V", selectRandom _hmgArr, [0.375,3,4.55], 0]
		]
	],
	[
		"o_recon",
		[
			["O","CamoNet_BLUFOR_open_F", [0.479004,0.344727,0], 0],
			["O","Land_Sacks_heap_F", [-6.75,-5.125,0], 150],
			["O","Land_WoodenTable_small_F", [1.552,0.250977,0], 270],
			["S","Land_Ammobox_rounds_F", [-1.11328,-4.09961,0], 270],
			["S","Land_Ammobox_rounds_F", [0.894043,0.4375,0], 70],
			["S","Land_Ammobox_rounds_F", [1.28369,0.580078,0], 219],
			["S","Land_BagBunker_Small_F", [-2.92627,2.49707,0], 180],
			["S","Land_BagFence_End_F", [2.771,1.01758,0], 90],
			["S","Land_BagFence_Long_F", [-5.59424,0.887695,0], 300],
			["S","Land_BagFence_Long_F", [1.16943,1.74902,0], 180],
			["S","Land_BagFence_Long_F", [5.29492,-1.77441,0], 85],
			["S","Land_BagFence_Round_F", [-6.74561,-3.6416,0], 349],
			["S","Land_BagFence_Round_F", [-7.56104,-0.335938,0], 160],
			["S","Land_BagFence_Round_F", [-8.6604,-2.37793,0], 74],
			["S","Land_BagFence_Round_F", [3.34399,2.41309,0], 129],
			["S","Land_BagFence_Round_F", [5.49878,2.61719,0], 214],
			["S","Land_BagFence_Round_F", [5.96582,0.5,0], 300],
			["S","Land_BottlePlastic_V1_F", [2.52075,-3.74707,0], 53],
			["S","Land_BottlePlastic_V1_F", [2.74487,-3.76953,0], 293],
			["S","Land_CanisterFuel_F", [-0.509766,-4.02344,0], 239],
			["S","Land_CanisterFuel_F", [0.0668945,-4.02832,0], 266],
			["S","Land_CanisterFuel_F", [1.94092,0.385742,0], 140],
			["S","Land_CncBarrierMedium4_F", [0.59668,-4.99023,0], 180],
			["S","Land_CncBarrierMedium_F", [0.169434,1.53711,0], 180],
			["S","Land_CncBarrierMedium_F", [1.66943,1.53711,0], 180],
			["S","Land_CratesWooden_F", [1.86865,-3.55469,0], 5],
			["S","Land_Garbage_square5_F", [-1.77832,-2.08594,0], 270],
			["S","Land_Garbage_square5_F", [1.38013,3.06445,0], 8],
			["S","Land_Pallet_vertical_F", [-5.33813,0.56543,0], 120],
			["S","Land_PlasticCase_01_small_F", [0.0131836,-3.59668,0], 70],
			["S","Land_PortableLongRangeRadio_F", [2.85498,-3.13086,0], 220],
			["S","Land_Sack_F", [3.3667,-3.96094,0], 270],
			["V", selectRandom _hmgArr, [-2.625,2.625,0.2], 0],
			["V", selectRandom _hmgArr, [4.875,1.125,0.2], 45]
		]
	],
	[
		"o_unknown",
		[
			["O","CamoNet_BLUFOR_F", [0.224365,-0.899414,0], 180],
			["O","Land_Sacks_heap_F", [-1.31543,3.87207,0], 330],
			["O","Land_WoodenTable_small_F", [-1.125,0.5,0], 210],
			["S","Land_BagBunker_Small_F", [2.59375,3.2168,0], 180],
			["S","Land_BagFence_Long_F", [-0.65625,2.5918,0], 180],
			["S","Land_BagFence_Long_F", [-3.40625,2.5918,0], 180],
			["S","Land_BagFence_Long_F", [-6.40625,-0.533203,0], 90],
			["S","Land_BagFence_Round_F", [-5.78149,1.9668,0], 135],
			["S","Land_ChairWood_F", [-0.522949,0.210938,0], 105],
			["S","Land_CratesShabby_F", [1.96875,-3.5332,0], 300],
			["S","Land_Garbage_square5_F", [2.18384,-0.757813,0], 180],
			["S","Land_Pallet_vertical_F", [-2.68994,-2.7334,0], 200],
			["S","Land_Pallets_stack_F", [-0.78125,-3.0332,0], 270],
			["S","Land_Sack_F", [1.21875,-3.03418,0], 135],
			["V", selectRandom _hmgArr, [-4.875,0.875,0.2], 315],
			["V", selectRandom _hmgArr, [3,3.5,0.2], 0]
		]
	],
	[
		"o_recon",
		[
			["O","CamoNet_BLUFOR_open_F", [0.302979,0.00390625,0], 0],
			["O","Land_Sacks_heap_F", [-3.28809,-6.4375,0], 225],
			["O","Land_WoodenTable_small_F", [-3.875,-0.75,0], 240],
			["S","Land_Ammobox_rounds_F", [2.67798,-1.99609,0], 315],
			["S","Land_BagBunker_Small_F", [-0.947021,4.25391,0], 180],
			["S","Land_BagFence_End_F", [-2.94702,-4.24609,0], 225],
			["S","Land_BagFence_End_F", [-6.32202,-4.49609,0], 75],
			["S","Land_BagFence_End_F", [2.42798,-1.62109,0], 150],
			["S","Land_BagFence_End_F", [2.55298,-4.99512,0], 345],
			["S","Land_BagFence_Long_F", [-6.69702,-0.496094,0], 105],
			["S","Land_BagFence_Long_F", [2.55298,4.62891,0], 0],
			["S","Land_BagFence_Round_F", [-2.07227,-5.62109,0], 45],
			["S","Land_BagFence_Round_F", [-5.69702,2.00391,0], 135],
			["S","Land_BagFence_Round_F", [-6.94702,-2.99609,0], 75],
			["S","Land_BagFence_Round_F", [1.42798,-6.12109,0], 315],
			["S","Land_BagFence_Round_F", [4.05298,-1.12109,0], 330],
			["S","Land_BagFence_Round_F", [4.80322,4.00391,0], 225],
			["S","Land_BagFence_Short_F", [-0.447021,-6.49609,0], 195],
			["S","Land_BagFence_Short_F", [5.17798,0.378906,0], 105],
			["S","Land_BagFence_Short_F", [5.42798,2.00391,0], 90],
			["S","Land_ChairWood_F", [-3.47168,-1.30469,0], 135],
			["S","Land_Garbage_square5_F", [-0.572021,0.50293,0], 0],
			["S","Land_HBarrier_1_F", [1.05298,2.75391,0], 0],
			["S","Land_HBarrier_3_F", [-0.0720215,-2.49609,0], 90],
			["S","Land_HBarrier_3_F", [-2.82202,2.62891,0], 0],
			["S","Land_HBarrier_3_F", [2.17798,1.25488,0], 0],
			["V", selectRandom _hmgArr, [-0.75,4.625,0.2], 0],
			["V", selectRandom _hmgArr, [0.75,-5.5,0.2], 180]
		]
	],
	[
		"o_unknown",
		[
			["O","Land_Sacks_heap_F", [-1.44141,-5.19238,0], 180],
			["O","Land_WoodenTable_small_F", [4.75,-0.5,0], 0],
			["S","Land_BagBunker_Tower_F", [-1.65234,4.09082,0], 90],
			["S","Land_BagFence_Long_F", [-2.27148,-0.362305,0], 180],
			["S","Land_BagFence_Round_F", [-4.10742,-5.2793,0], 315],
			["S","Land_BagFence_Round_F", [-6.27173,-5.2373,0], 45],
			["S","Land_BagFence_Round_F", [0.228516,0.262695,0], 315],
			["S","Land_BagFence_Round_F", [5.58081,4.64258,0], 225],
			["S","Land_BagFence_Short_F", [3.72852,5.38672,0], 180],
			["S","Land_BagFence_Short_F", [6.21729,2.69043,0], 270],
			["S","Land_BarrelSand_F", [-2.77148,-4.8623,0], 0],
			["S","Land_ChairWood_F", [4.12158,-0.642578,0], 255],
			["S","Land_CratesWooden_F", [5.47852,-5.3623,0], 0],
			["S","Land_HBarrier_3_F", [-2.39648,-3.6123,0], 0],
			["S","Land_HBarrier_3_F", [-6.77148,-2.3623,0], 90],
			["S","Land_HBarrier_3_F", [-6.77148,0.637695,0], 90],
			["S","Land_HBarrier_3_F", [3.97852,-3.7373,0], 0],
			["S","Land_HBarrier_3_F", [6.21729,-2.80957,0], 90],
			["S","Land_HBarrier_3_F", [6.21729,0.31543,0], 90],
			["S","Land_MetalBarrel_F", [4.06201,-2.24219,0], 15],
			["S","Land_MetalBarrel_F", [4.47852,-1.71289,0], 240],
			["S","Land_MetalBarrel_F", [4.85352,-2.3623,0], 90],
			["S","Land_Pallet_F", [3.10352,-5.9873,0], 22],
			["S","Land_Pallet_F", [4.97852,-7.4873,0], 232],
			["V", selectRandom _hmgArr, [-2.58,3.89,2.8], 0],
			["V", selectRandom _hmgArr, [4.75,3.875,0.2], 60]
		]
	],
	[
		"o_recon",
		[
			["O","CamoNet_BLUFOR_open_F", [1.03149,-0.807617,0], 180],
			["O","Land_Sacks_heap_F", [2.25,-6.25,0], 120],
			["O","Land_WoodenTable_small_F", [-3.25,-0.75,0], 165],
			["S","Land_Ammobox_rounds_F", [7.1123,-2.80566,0], 187],
			["S","Land_BagBunker_Small_F", [3.40161,4.08691,0], 180],
			["S","Land_BagFence_End_F", [7.01147,-3.42871,0], 152],
			["S","Land_BagFence_Long_F", [6.28149,2.19238,0], 62],
			["S","Land_BagFence_Round_F", [-6.96899,-2.05469,0], 72],
			["S","Land_BagFence_Round_F", [7.78198,-2.05566,0], 277],
			["S","Land_CanisterFuel_F", [7.47339,-2.37402,0], 157],
			["S","Land_ChairWood_F", [-2.6543,-0.547852,0], 60],
			["S","Land_CncBarrierMedium4_F", [-2.09351,2.56738,0], 180],
			["S","Land_CncBarrierMedium_F", [-6.46851,1.81738,0], 135],
			["S","Land_CncBarrierMedium_F", [-7.09326,0.192383,0], 90],
			["S","Land_CncBarrierMedium_F", [7.40649,0.0664063,0], 75],
			["S","Land_CratesWooden_F", [0.625,-2.125,0], 30],
			["S","Land_Garbage_square5_F", [3.77637,1.08594,0], 0],
			["S","Land_PlasticCase_01_small_F", [7.40698,-1.86035,0], 347],
			["S","Land_Sack_F", [-6.71851,-3.55859,0], 17],
			["V", selectRandom _hmgArr, [3.625,4.375,0.2], 0]
		]
	],
	[
		"o_installation",
		[
			["O","Land_Cargo_Patrol_V2_F", [-1.87109,0.65332,0.0627961], 180],
			["O","Land_Sacks_heap_F", [3.125,-7.75,0], 345],
			["O","Land_WoodenTable_small_F", [2.5,3,0], 270],
			["S","Land_BagFence_Long_F", [1.62891,-4.47168,0], 180],
			["S","Land_BagFence_Long_F", [5.00391,-1.34668,0], 270],
			["S","Land_BagFence_Long_F", [5.00391,1.40332,0], 270],
			["S","Land_BagFence_Round_F", [-0.746094,-5.09668,0], 135],
			["S","Land_BagFence_Round_F", [-5.24634,-6.72168,0], 45],
			["S","Land_BagFence_Round_F", [4.25391,-3.84668,0], 315],
			["S","Land_BagFence_Round_F", [4.37915,3.77832,0], 225],
			["S","Land_BagFence_Short_F", [-1.49609,-6.97168,0], 90],
			["S","Land_BagFence_Short_F", [-5.87109,-4.84668,0], 90],
			["S","Land_ChairWood_F", [2.59814,2.31445,0], 165],
			["S","Land_GarbageBags_F", [-3.37109,2.27832,0], 333],
			["S","Land_GarbageWashingMachine_F", [-3.24609,-0.84668,0], 210],
			["S","Land_Garbage_square5_F", [-1.24609,1.90332,0], 0],
			["S","Land_Garbage_square5_F", [-3.62109,-3.22168,0], 0],
			["S","Land_HBarrier_3_F", [-0.871094,4.65332,0], 180],
			["S","Land_HBarrier_3_F", [-3.87109,4.65332,0], 180],
			["S","Land_HBarrier_3_F", [-5.87109,-2.34668,0], 270],
			["S","Land_HBarrier_3_F", [-5.87109,0.65332,0], 270],
			["S","Land_HBarrier_3_F", [-5.87109,3.65332,0], 270],
			["S","Land_HBarrier_3_F", [2.12891,4.65332,0], 180],
			["S","Land_Pallet_F", [-0.246094,-10.3467,0], 121],
			["S","Land_Pallets_F", [1.51465,-8.54395,0], 315],
			["S","Land_PaperBox_open_empty_F", [-0.246094,2.90332,0], 90],
			["S","Land_Razorwire_F", [-2.24609,6.40332,0], 180],
			["S","Land_Razorwire_F", [-7.24609,2.65332,0], 90],
			["S","Land_Wreck_Skodovka_F", [3.37915,-9.84668,0], 60],
			["V", selectRandom _hmgArr, [-3.5,1.625,4.6], 0],
			["V", selectRandom _hmgArr, [3.58398,0.163086,0.2], 90]
		]
	],
	[
		"o_unknown",
		[
			["O","CamoNet_BLUFOR_F", [-0.594971,-1.40527,0], 180],
			["O","Land_CampingTable_F", [-1.82617,-3.54395,0], 17],
			["O","Land_Sacks_heap_F", [1.125,3.5,0], 15],
			["S","Land_BagBunker_Small_F", [-3.21973,3.21875,0], 180],
			["S","Land_BagFence_End_F", [0.155029,1.34473,0], 105],
			["S","Land_BagFence_End_F", [3.15503,1.59473,0], 45],
			["S","Land_BagFence_End_F", [4.28003,1.34473,0], 120],
			["S","Land_BagFence_Long_F", [1.65503,1.84375,0], 0],
			["S","Land_BagFence_Long_F", [6.15454,-2.03125,0], 120],
			["S","Land_BagFence_Round_F", [5.65503,1.84473,0], 180],
			["S","Land_BagFence_Round_F", [7.15503,0.34375,0], 270],
			["S","Land_BottlePlastic_V1_F", [-2.44995,-2.55859,0], 270],
			["S","Land_BottlePlastic_V1_F", [-2.54028,-2.46777,0], 270],
			["S","Land_Bucket_clean_F", [-2.25024,-3.09961,0], 270],
			["S","Land_CampingChair_V1_F", [-0.978516,-3.01855,0], 60],
			["S","Land_CanisterPlastic_F", [-4.03052,-1.56641,0], 75],
			["S","Land_CncBarrierMedium4_F", [-1.21997,-5.03027,0], 0],
			["S","Land_CncBarrierMedium4_F", [-5.09473,-1.53125,0], 90],
			["S","Land_CncBarrierMedium_F", [-0.594971,2.21875,0], 180],
			["S","Land_CncBarrierMedium_F", [3.40552,-5.03027,0], 165],
			["S","Land_CncBarrierMedium_F", [3.78003,2.46875,0], 180],
			["S","Land_CncBarrierMedium_F", [4.65503,-3.78027,0], 120],
			["S","Land_CratesWooden_F", [2.40503,-1.65527,0], 30],
			["S","Land_Garbage_square5_F", [0.155029,-1.53125,0], 270],
			["S","Land_MetalCase_01_small_F", [3.28003,-0.905273,0], 315],
			["S","Land_PaperBox_open_empty_F", [-3.59497,-2.78027,0], 0],
			["V", selectRandom _hmgArr, [-3.125,3.875,0.2], 0]
		]
	],
	[
		"o_unknown",
		[
			["O","CamoNet_BLUFOR_F", [0.0830078,3.11816,0], 180],
			["O","Land_Sacks_heap_F", [-2.10278,-2.00293,0], 150],
			["O","Land_WoodenTable_large_F", [1.875,-1.875,0], 265],
			["S","Land_BagBunker_Small_F", [-0.166992,3.99316,0], 180],
			["S","Land_BagFence_End_F", [-2.58398,-6.29785,0], 225],
			["S","Land_BagFence_End_F", [-4.54199,-2.00684,0], 30],
			["S","Land_BagFence_End_F", [2.29102,-5.92188,0], 315],
			["S","Land_BagFence_Long_F", [-0.958984,-6.54785,0], 180],
			["S","Land_BagFence_Long_F", [5.33301,-1.88184,0], 135],
			["S","Land_BagFence_Round_F", [-5.91724,-1.13184,0], 45],
			["S","Land_BagFence_Round_F", [-6.16699,1.11914,0], 120],
			["S","Land_BagFence_Round_F", [6.20825,1.86914,0], 225],
			["S","Land_BagFence_Short_F", [-4.41699,2.24316,0], 345],
			["S","Land_BagFence_Short_F", [1.33301,-6.38281,0], 345],
			["S","Land_BagFence_Short_F", [4.33301,2.49316,0], 180],
			["S","Land_BagFence_Short_F", [6.58301,-0.00683594,0], 105],
			["S","Land_CampingChair_V2_F", [1.25,-2.625,0], 203],
			["S","Land_CampingChair_V2_F", [2.375,-2.5,0], 168],
			["S","Land_CanisterPlastic_F", [2.75,-3.25,0], 180],
			["S","Land_CncBarrierMedium4_F", [-0.0419922,-0.506836,0], 180],
			["S","Land_CncBarrierMedium_F", [-0.416992,0.868164,0], 180],
			["S","Land_CncBarrierMedium_F", [-2.2915,0.618164,0], 165],
			["S","Land_CncBarrierMedium_F", [-2.7915,2.86816,0], 165],
			["S","Land_CncBarrierMedium_F", [-3.66699,-1.63184,0], 270],
			["S","Land_CncBarrierMedium_F", [-3.66699,-3.50684,0], 90],
			["S","Land_CncBarrierMedium_F", [1.45752,0.618164,0], 195],
			["S","Land_CncBarrierMedium_F", [2.70752,2.86816,0], 195],
			["S","Land_CncBarrierMedium_F", [3.58301,-1.63184,0], 90],
			["S","Land_CncBarrierMedium_F", [3.58301,-3.50684,0], 90],
			["V", selectRandom _hmgArr, [-1.625,-5.375,0.2], 180],
			["V", selectRandom _hmgArr, [0.125,4.375,0.2], 0]
		]
	]
];

["DEBUG", format["Zone%1 - Creating Sites: %2 in %4 positions (%3m)", _zoneID, _count, _radius, count _locations]] call zmm_fnc_logMsg;

for "_i" from 1 to _count do {	
	if (count _locations == 0) exitWith { _centre = [] };
	
	private _pos = selectRandom _locations;
	_locations deleteAt (_locations find _pos);

	private _key = "Land_ClutterCutter_small_F" createVehicleLocal _pos;
	_key setDir random 360;
		
	// Clear Area
	{ [_x, true] remoteExec ["hideObject", 0, true] } forEach (nearestTerrainObjects [_pos, ["TREE", "SMALL TREE", "BUSH", "BUILDING", "HOUSE", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "CHURCH", "CHAPEL", "CROSS", "BUNKER", "FORTRESS", "FOUNTAIN", "VIEW-TOWER", "LIGHTHOUSE", "QUAY", "FUELSTATION", "HOSPITAL", "FENCE", "WALL", "HIDE", "BUSSTOP", "FOREST", "TRANSMITTER", "STACK", "RUIN", "TOURISM", "WATERTOWER", "ROCK", "ROCKS", "POWERSOLAR", "POWERWAVE", "POWERWIND", "SHIPWRECK"], 25]);
	
	// Build Support	
	_bID = floor random count _buildingList;
	(_buildingList#_bID) params ["_icon", "_buildingObjects"];
	
	["DEBUG", format["Zone%1 - Spawning Site: ID%2 (%3) at %4", _zoneID, _bID, _icon, _pos]] call zmm_fnc_logMsg;

	{
		_x params ["_type", ["_class",""], ["_rel",[0,0,0]], ["_dir", 0], ["_flat", true]];
		private _worldPos = _key modeltoWorld _rel;	
		private _obj = [_zoneID, _side, _type, _class, [_worldPos#0, _worldPos#1, _rel#2], getDir _key + _dir, _flat] call zmm_fnc_spawnObject;		
	} forEach _buildingObjects;

	// Create a local patrolling group
	private _grpArr = [];
	for "_j" from 0 to (1 + random 3) do { _grpArr pushBack (selectRandom _menArr) };

	private _tempGrp = [_key getPos [15, random 360], _side, _grpArr] call BIS_fnc_spawnGroup;
	[_tempGrp, getPos _key] call BIS_fnc_taskDefend;
	_tempGrp deleteGroupWhenEmpty true;
	_tempGrp enableDynamicSimulation true;
	{ _x addCuratorEditableObjects [units _tempGrp, true] } forEach allCurators;
	
	if (_showMarker) then {
		if (missionNamespace getVariable ["ZZM_Mode", 0] != 1) then {
			private _mrkr = createMarker [format["MKR_%1_SP_%2", _zoneID, _i], _pos getPos [25, random 360]];
			_mrkr setMarkerType "mil_unknown";
			_mrkr setMarkerColor format["Color%1",_side];

			private _cpTrigger = createTrigger ["EmptyDetector", _pos, false];
			_cpTrigger setTriggerActivation [format["%1",_side], "NOT PRESENT", false];
			_cpTrigger setTriggerArea [25, 25, 0, false];
			_cpTrigger setTriggerStatements [  "this", format["'MKR_%1_SP_%2' setMarkerColor 'ColorGrey'", _zoneID, _i], "" ];
			
			private _hdTrigger = createTrigger ["EmptyDetector", _pos, false];
			_hdTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
			_hdTrigger setTriggerArea [250, 250, 0, false, 100];
			_hdTrigger setTriggerStatements [  "this", format["'MKR_%1_SP_%2' setMarkerType '%3'", _zoneID, _i, _icon], "" ];
		} else {
			private _mrkr = createMarkerLocal [format ["MKR_%1_SP_%2", _zoneID, _i], _pos];
			_mrkr setMarkerTypeLocal "mil_dot";
			_mrkr setMarkerColorLocal "ColorGreen";
			_mrkr setMarkerTextLocal format["Site%1", _i];
		};
	};
};

_centre set [2,0];
_centre