// [] call ZMM_fnc_side
if !isServer exitWith {};

params [
	["_zoneID", 0],
	["_centre", (missionNamespace getVariable [ format[ "ZMM_%1_Location", _this#0], [0,0,0]])]
];

if (_centre isEqualTo [0,0,0]) exitWith { ["ERROR", format["Zone%1 - Invalid site location: %1 (%2)", _zoneID, _centre]] call zmm_fnc_logMsg; false };

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

private _vehArr = [];
if (count _vehL > 1) then { _vehArr append _vehL; _vehArr append _vehL; }; // Common
if (count _vehM > 1) then { _vehArr append _vehM; }; // Medium

if (count _hmgArr == 0) then { _hmgArr = ["B_GMG_01_high_F","B_HMG_01_high_F"] };

if (count _locations == 0) then {
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
};

private _buildingList = [
	[
		"o_recon",
		[
			["S","CamoNet_BLUFOR_open_F", [0,0,0.625], 90],
			["S","Land_BagFence_Round_F", [-2.875,6.875,0], 129],
			["S","Land_BagFence_Round_F", [0.5,-6.125,0], 35],
			["S","Land_PaperBox_closed_F", [-5.125,0.75,0], 210],
			["S","Land_PaperBox_closed_F", [-4.375,2.5,0], 0],
			["S","Land_NetFence_03_m_3m_hole_F", [-3.5,-1.25,0], 270],
			["S","Land_Pallet_F", [-2.875,-5.875,0], 240],
			["V", selectRandom _hmgArr, [-0.125,6.375,0.2], 0],
			["S","Land_CampingChair_V2_F", [-1.125,-1.5,0], 30],
			["S","Land_NetFence_03_m_3m_d_F", [1,-2.75,0], 180],
			["S","Land_BagFence_Long_F", [-0.375,7.625,0], 0],
			["S","Land_Sacks_heap_F", [-1.875,2.25,0], 165],
			["S","Land_NetFence_03_m_3m_F", [1,3.25,0], 0],
			["S","Land_NetFence_03_m_3m_F", [-2,-2.75,0], 180],
			["S","Land_NetFence_03_m_3m_F", [-2,3.25,0], 0],
			["S","Land_NetFence_03_m_3m_F", [-3.5,1.75,0], 270],
			["S","Land_Sacks_goods_F", [-6.125,2.125,0], 255],
			["S","Land_CampingTable_F", [-1.625,-2.125,0], 0],
			["S","Land_BagFence_Long_F", [2.875,-6.625,0], 180],
			["S","Land_BagFence_Round_F", [2,7.125,0], 215],
			["S","Land_BagFence_Round_F", [5.375,-5.875,0], 309],
			["S","Land_NetFence_03_m_3m_hole_F", [2.5,1.75,0], 90],
			["V", selectRandom _hmgArr, [2.625,-5.375,0.2], 180],
			["S","Land_BagFence_Long_F", [5.875,-3.375,0], 270],
			["S","Land_NetFence_03_m_3m_F", [2.5,-1.25,0], 90],
			["V", selectRandom (_vehL + _vehM), [8.25,4.49805,0.2], 15],
			["S","Land_Pallet_F", [1.375,2.25,0], 255]
		]
	],
	[
		"o_recon",
		[
			["S","CamoNet_BLUFOR_open_F", [-0.25,-0.125,0.625], 90],
			["S","Land_TinWall_01_m_4m_v1_F", [-4.25,-2.25,0], 90],
			["S","Land_TinWall_01_m_4m_v2_F", [-2.38867,-4.2124,0], 0],
			["V", selectRandom _hmgArr, [-2.875,-6.375,0.2], 180],
			["S","Land_CampingChair_V2_F", [-2.25,-2.75,0], 30],
			["S","Land_Sacks_heap_F", [-3.25,-1.125,0], 90],
			["S","Land_CampingTable_F", [-2.75,-3.375,0], 0],
			["S","Land_TinWall_01_m_4m_v2_F", [-2.25,3.625,0], 180],
			["S","Land_TinWall_01_m_4m_v2_F", [-4.25,1.625,0], 90],
			["S","Land_FieldToilet_F", [-2.875,1.125,0], 270],
			["S","Land_CratesWooden_F", [-2,4.875,0], 0],
			["S","Land_Pallets_stack_F", [-0.5,2.5,0], 165],
			["S","Land_TinWall_01_m_4m_v1_F", [3.625,-2.25,0], 270],
			["O","Land_TinWall_01_m_gate_v2_F", [1.625,-4.25,0], 0],
			["S","Land_PaperBox_closed_F", [1.375,2.5,0], 0],
			["S","Land_TinWall_01_m_4m_v1_F", [1.625,3.625,0], 180],
			["S","Land_TinWall_01_m_4m_v1_F", [3.625,1.625,0], 270],
			["V", selectRandom (_vehL + _vehM), [6.25,1.12305,0.2], 0]
		]
	],
	[
		"o_recon",
		[
			["S","Land_PaperBox_closed_F", [-5.875,-2.625,0], 210],
			["S","Land_PaperBox_closed_F", [-3.125,-4.75,0], 0],
			["S","Land_NetFence_01_m_4m_F", [-3.875,-1.75,0], 90],
			["S","Land_NetFence_01_m_4m_F", [-1.875,-3.75,0], 0],
			["S","Land_Sacks_heap_F", [-2.375,-2.125,0], 15],
			["S","Land_CratesShabby_F", [-4.625,-1,0], 0],
			["S","Land_BagFence_Round_F", [-2.625,8,0], 129],
			["O","Land_NetFence_01_m_gate_F", [-3.875,2.25,0], 90],
			["S","Land_NetFence_01_m_4m_F", [-1.875,4.25,0], 0],
			["S","Land_Pallets_F", [0.625,-2.125,0], 300],
			["S","CamoNet_BLUFOR_open_F", [-0.375,0.25,0.625], 180],
			["S","Land_NetFence_01_m_4m_F", [2.125,-3.75,0], 180],
			["S","Land_NetFence_01_m_d_F", [4.125,-1.75,0], 270],
			["S","Land_NetFence_01_m_pole_F", [4.125,0.25,0], 0],
			["S","Land_NetFence_01_m_pole_F", [0.125,-3.75,0], 0],
			["V", selectRandom (_vehL + _vehM), [-0.5,-7.62695,0.2], 255],
			["S","Land_Pallets_stack_F", [2.5,-2.375,0], 0],
			["S","Land_WoodenTable_large_F", [1.375,3,0], 0],
			["S","Land_BagFence_Round_F", [2.25,8.25,0], 215],
			["S","Land_NetFence_01_m_4m_F", [2.125,4.25,0], 180],
			["S","Land_NetFence_01_m_d_F", [4.125,2.25,0], 90],
			["S","Land_NetFence_01_m_pole_F", [0.125,4.25,0], 0],
			["V", selectRandom _hmgArr, [0.125,7.5,0.2], 0],
			["S","Land_ChairWood_F", [0.75,2.50293,0], 255],
			["S","Land_ChairWood_F", [2,3.37793,0], 75],
			["S","Land_BagFence_Long_F", [-0.125,8.75,0], 0],
			["S","Land_FieldToilet_F", [6.375,2.625,0], 285],
			["S","Land_FieldToilet_F", [6.75,4.5,0], 255]
		]
	],
	[
		"o_recon",
		[
			["S","Land_Mil_WallBig_corner_battered_F", [-4.875,-4.875,0], 0],
			["S","Land_CampingChair_V2_F", [-3.5,1.125,0], 30],
			["S","Land_Mil_WallBig_4m_battered_F", [-5.125,1.875,0], 90],
			["S","Land_Mil_WallBig_4m_battered_F", [-2.125,-5.125,0], 0],
			["S","Land_Mil_WallBig_4m_battered_F", [-5.125,-2.125,0], 90],
			["S","Land_CratesWooden_F", [-0.5,-3.625,0], 0],
			["S","Land_Pallets_stack_F", [-3.125,-3.5,0], 30],
			["S","Land_CampingTable_F", [-4,0.5,0], 0],
			["S","Land_BagFence_Round_F", [-3.25,8.5,0], 129],
			["S","Land_PaperBox_closed_F", [-3,5.25,0], 0],
			["S","Land_PaperBox_closed_F", [-3.875,3.5,0], 210],
			["S","Land_Mil_WallBig_corner_battered_F", [-4.875,4.625,0], 90],
			["V", selectRandom _hmgArr, [-0.5,8,0.2], 0],
			["S","Land_BagFence_Long_F", [-0.75,9.25,0], 0],
			["S","Land_Mil_WallBig_debris_F", [3.875,-3,0], 150],
			["S","Land_Mil_WallBig_4m_damaged_left_F", [4.875,1.875,0], 270],
			["S","Land_Mil_WallBig_4m_damaged_center_F", [4.875,-2.125,0], 270],
			["S","Land_Mil_WallBig_4m_damaged_right_F", [1.875,-5.125,0], 0],
			["S","Land_Sacks_heap_F", [1,0.875,0], 330],
			["S","Land_FoodSacks_01_large_brown_F", [3.5,3,0], 330],
			["V", selectRandom (_vehL + _vehM), [7.75,-6.87695,0.2], 195],
			["S","Land_BagFence_Round_F", [1.625,8.75,0], 215],
			["S","Land_Mil_WallBig_corner_battered_F", [4.625,4.625,0], 180],
			["S","Land_PaperBox_01_small_ransacked_brown_F", [3.125,4.375,0], 285],
			["S","Land_PaperBox_01_open_empty_F", [6.75,3.75,0], 30]
		]
	],
	[
		"o_recon",
		[
			["S","Land_PaperBox_closed_F", [-4.25,2.375,0], 0],
			["S","Land_Mil_WallBig_4m_F", [-5.5,1.875,0], 90],
			["S","Land_Mil_WallBig_4m_F", [-5.5,-2.125,0], 90],
			["S","Land_Mil_WallBig_4m_F", [-2.5,-5.125,0], 0],
			["S","Land_Mil_WallBig_Corner_F", [-5.25,-4.875,0], 0],
			["S","Land_Sacks_heap_F", [-3.375,-3,0], 15],
			["S","Land_BagFence_Corner_F", [-7.75,8.875,0], 270],
			["S","Land_PaperBox_closed_F", [-3.75,6.125,0], 285],
			["S","Land_PaperBox_closed_F", [-3.5,4.25,0], 210],
			["V", selectRandom _hmgArr, [-6.625,8.125,0.2], 270],
			["S","Land_Mil_WallBig_Corner_F", [-5.25,4.625,0], 90],
			["S","Land_BagFence_Short_F", [-6.479,9.20264,0], 0],
			["S","Land_BagFence_Short_F", [-8.104,7.45264,0], 90],
			["S","Land_WoodenTable_large_F", [2.375,-3.125,0], 30],
			["S","Land_Pallets_F", [3.25,1.125,0], 0],
			["S","Land_Mil_WallBig_4m_F", [4.5,-2.125,0], 270],
			["S","Land_Mil_WallBig_4m_F", [4.5,1.875,0], 270],
			["S","Land_Mil_WallBig_4m_F", [1.5,-5.125,0], 0],
			["S","Land_Mil_WallBig_Corner_F", [4.25,-4.875,0], 270],
			["S","Land_ChairWood_F", [3.13135,-3.11377,0], 105],
			["S","Land_ChairWood_F", [1.61133,-3.24658,0], 285],
			["S","Land_PaperBox_01_small_open_white_IDAP_F", [3.5,2.5,0], 315],
			["S","Land_Mil_WallBig_Corner_F", [4.25,4.625,0], 180],
			["S","Land_FieldToilet_F", [4.625,5.5,0], 105],
			["V", selectRandom (_vehL + _vehM), [6,10.123,0.2], 75]
		]
	],
	[
		"o_recon",
		[
			["S","Land_IndFnc_3_Hole_F", [1.125,-3.125,0], 180],
			["S","Land_FieldToilet_F", [-4.125,-4.375,0], 105],
			["S","Land_IndFnc_3_F", [-1.875,-3.12549,0], 180],
			["S","Land_WoodenTable_large_F", [-6,0.625,0], 30],
			["S","Land_BagFence_Corner_F", [-6.5,5.25,0], 270],
			["S","CamoNet_BLUFOR_open_F", [0,0,0.625], 90],
			["S","Land_PaperBox_closed_F", [1.25,4.375,0], 0],
			["S","Land_PaperBox_closed_F", [-0.875,4.5,0], 210],
			["S","Land_Pallet_F", [1.125,-2,0], 0],
			["S","Land_IndFnc_3_D_F", [-3.375,-1.62549,0], 270],
			["S","Land_ChairWood_F", [-5.24365,0.63623,0], 105],
			["S","Land_ChairWood_F", [-6.76367,0.503418,0], 285],
			["S","Land_BagFence_Short_F", [-6.854,3.82764,0], 90],
			["S","Land_BagFence_Short_F", [-5.229,5.57764,0], 0],
			["S","Land_FoodSacks_01_small_brown_F", [1.125,-2,0.2], 300],
			["S","Land_Sacks_heap_F", [-0.125,1.75,0], 150],
			["S","Land_CratesWooden_F", [-2.125,1,0], 90],
			["S","Land_IndFnc_3_F", [1.125,2.87451,0], 0],
			["S","Land_IndFnc_3_F", [-3.375,1.37451,0], 270],
			["S","Land_IndFnc_3_F", [-1.875,2.87451,0], 0],
			["S","Land_BagFence_Corner_F", [6,-6,0], 90],
			["V", selectRandom _hmgArr, [4.875,-5.25,0.2], 90],
			["S","Land_BagFence_Short_F", [4.729,-6.32764,0], 180],
			["S","Land_BagFence_Short_F", [6.354,-4.57764,0], 270],
			["S","Land_IndFnc_3_D_F", [2.625,1.37451,0], 90],
			["S","Land_IndFnc_3_F", [2.625,-1.62549,0], 90],
			["V", selectRandom (_vehL + _vehM), [9.75,5.49805,0.2], 15]
		]
	],
	[
		"o_recon",
		[
			["S","Land_PaperBox_closed_F", [-0.875,-2.375,0], 210],
			["S","Land_ChairWood_F", [-0.689941,1.58057,0], 165],
			["S","Land_Wall_IndCnc_2deco_F", [-2,-3.875,0], 180],
			["S","Land_Wall_IndCnc_2deco_F", [-4.125,-2.75,0], 255],
			["S","Land_FieldToilet_F", [-2.875,-2.125,0], 195],
			["S","Land_Wall_IndCnc_2deco_F", [-1,3,0], 0],
			["S","Land_Wall_IndCnc_2deco_F", [-3.625,2,0], 135],
			["V", selectRandom (_vehL + _vehM), [-5,5.87305,0.2], 255],
			["S","Land_WoodenTable_large_F", [-1.125,2.25,0], 90],
			["S","Land_FoodSack_01_full_brown_F", [0.25,2.25,0], 45],
			["S","Land_Pallets_F", [2,-4.5,0], 120],
			["V", selectRandom _hmgArr, [5.125,-0.875,0.2], 120],
			["S","Land_Wall_IndCnc_2deco_F", [1,-3.5,0], 165],
			["S","Land_Wall_IndCnc_2deco_F", [2.875,-1.625,0], 105],
			["S","Land_BagFence_Short_F", [6.64697,-0.263672,0], 90],
			["S","Land_BagFence_Short_F", [6.64697,1.36133,0], 90],
			["S","Land_BagFence_Short_F", [6.25,-1.75,0], 120],
			["S","Land_BagFence_Short_F", [5.375,-3.125,0], 120],
			["S","Land_Sacks_heap_F", [1.25,-1.875,0], 330],
			["S","Land_Wall_IndCnc_2deco_F", [2,3.375,0], 345],
			["S","Land_BagFence_Short_F", [6.07959,4.44482,0], 255],
			["S","Land_BagFence_Short_F", [6.5,2.875,0], 255],
			["S","Land_FoodSacks_01_small_brown_F", [1.25,2.375,0], 60],
			["S","Land_FoodSacks_01_small_brown_F", [2.03369,2.82568,0], 165]
		]
	],
	[
		"o_recon",
		[
			["S","Land_WoodenTable_large_F", [-2.75,-1.75,0], 180],
			["S","Land_CamoConcreteWall_01_l_end_v1_F", [-2.5,2.625,0], 0],
			["S","Land_CamoConcreteWall_01_l_end_v1_F", [1.125,3,0], 180],
			["S","Land_PaperBox_closed_F", [-2.5,1.625,0], 0],
			["S","Land_ChairWood_F", [-2.1123,-1.35449,0], 75],
			["S","Land_FoodSacks_01_small_brown_F", [-2.625,-0.375,0], 330],
			["S","Land_CamoConcreteWall_01_l_4m_v1_F", [-0.75,-3.125,0], 0],
			["S","Land_CamoConcreteWall_01_l_4m_v1_F", [-3.625,-0.125,0], 90],
			["S","Land_Sacks_heap_F", [0.125,-2.125,0], 0],
			["S","Land_CratesWooden_F", [0.625,-4.375,0], 0],
			["S","Land_FoodSacks_01_large_brown_F", [1.25,1.875,0], 0],
			["V", selectRandom (_vehL + _vehM), [-6,-4.87695,0.2], 165],
			["S","Land_BagFence_Corner_F", [-5.771,6.29736,0], 270],
			["S","Land_BagFence_Short_F", [-6.125,4.875,0], 90],
			["S","Land_BagFence_Short_F", [-4.5,6.625,0], 0],
			["S","Land_Pallets_stack_F", [-2.25,4.375,0], 45],
			["S","Land_CamoConcreteWall_01_l_4m_d_v1_F", [1.875,-0.25,0], 270],
			["S","Land_BagFence_Corner_F", [4.5,6.125,0], 0],
			["V", selectRandom _hmgArr, [3.75,5,0.2], 0],
			["S","Land_BagFence_Short_F", [3.07764,6.479,0], 180],
			["S","Land_BagFence_Short_F", [4.82764,4.854,0], 90]
		]
	],
	[
		"o_recon",
		[
			["S","Land_Mil_WiredFence_F", [-4.18994,-0.231934,0], 90],
			["S","Land_Mil_WiredFenceD_F", [-0.75,-3.75,0], 0],
			["S","Land_PaperBox_closed_F", [-3.125,-2.375,0], 210],
			["S","Land_PaperBox_closed_F", [-3.25,-0.5,0], 0],
			["V", selectRandom (_vehL + _vehM), [-7.75,-5,0.2], 330],
			["S","Land_FoodSacks_01_cargo_brown_F", [-3.375,1.375,0], 0],
			["S","Land_Mil_WiredFence_F", [-0.689941,3.26807,0], 180],
			["S","Land_Mil_WiredFence_F", [2.81006,-0.231934,0], 270],
			["S","Land_BagFence_Corner_F", [6.271,-7.92236,0], 90],
			["V", selectRandom _hmgArr, [4.75,-6.875,0.2], 180],
			["S","Land_CampingChair_V2_F", [1.875,1.875,0], 300],
			["S","Land_BagFence_Short_F", [5,-8.25,0], 180],
			["S","Land_BagFence_Short_F", [6.625,-3.125,0], 270],
			["S","Land_BagFence_Short_F", [6.625,-4.875,0], 270],
			["S","Land_BagFence_Short_F", [6.625,-1.5,0], 270],
			["S","Land_BagFence_Short_F", [6.625,-6.5,0], 270],
			["S","Land_Sacks_heap_F", [1.625,-2,0], 300],
			["S","Land_Pallets_stack_F", [4.125,2.125,0], 0],
			["S","Land_CampingTable_F", [2.5,1.375,0], 270],
			["S","Land_CratesWooden_F", [0.625,5,0], 0]
		]
	]
];

["DEBUG", format["Zone%1 - Creating Sites: %2 in %4 positions (%3m)", _zoneID, _count, _radius, count _locations]] call zmm_fnc_logMsg;

for "_i" from 1 to _count do {
	private _pos = [];
	
	if (count _locations == 0) exitWith { false };
	
	private _pos = selectRandom _locations;
	_locations deleteAt (_locations find _pos);
	
	private _key = "Land_HelipadEmpty_F" createVehicleLocal _pos;
	_key setDir random 360;
		
	// Clear Area
	{ [_x, true] remoteExec ["hideObject", 0, true] } forEach (nearestTerrainObjects [_pos, [], 25]);
	
	// Build Support	
	_bID = floor random count _buildingList;
	(_buildingList#_bID) params ["_icon", "_buildingObjects"];
	
	["DEBUG", format["Zone%1 - Creating Site: %2 (%3)", _zoneID, _bID, _icon]] call zmm_fnc_logMsg;

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
	
	if (missionNamespace getVariable ["ZZM_Mode", 0] != 1) then {
		private _mrkr = createMarker [format["MKR_%1_SP_%2", _zoneID, _i], _pos getPos [25, random 360]];
		_mrkr setMarkerType "mil_unknown";
		_mrkr setMarkerColor format["Color%1",_side];

		private _cpTrigger = createTrigger ["EmptyDetector", _pos, FALSE];
		_cpTrigger setTriggerActivation [format["%1",_side], "NOT PRESENT", FALSE];
		_cpTrigger setTriggerArea [25, 25, 0, false];
		_cpTrigger setTriggerStatements [  "this", format["'MKR_%1_SP_%2' setMarkerColor 'ColorGrey'", _zoneID, _i], "" ];
		
		private _hdTrigger = createTrigger ["EmptyDetector", _pos, FALSE];
		_hdTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", FALSE];
		_hdTrigger setTriggerArea [150, 150, 0, false, 25];
		_hdTrigger setTriggerStatements [  "this", format["'MKR_%1_SP_%2' setMarkerType '%3'", _zoneID, _i, _icon], "" ];
	} else {
		private _mrkr = createMarkerLocal [format ["MKR_%1_SP_%2", _zoneID, _i], _pos];
		_mrkr setMarkerTypeLocal "mil_dot";
		_mrkr setMarkerColorLocal "ColorGreen";
		_mrkr setMarkerTextLocal format["Site%1", _i];
	};
};

true