if !isServer exitWith {};

params [
	["_zoneID", 0],
	["_centre", (missionNamespace getVariable [ format[ "ZMM_%1_Location", _this#0], [0,0,0]])]
];

if (_centre isEqualTo [0,0,0]) exitWith { ["ERROR", format["Zone%1 - Invalid support location: %1 (%2)", _zoneID, _centre]] call zmm_fnc_logMsg };

private _side = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locations = missionNamespace getVariable [ format[ "ZMM_%1_SupportLocations", _zoneID ], []];  // Takes too long to populate - Left blank

private _radius = missionNamespace getVariable [ format[ "ZMM_%1_Radius", _zoneID ], 150];
private _count = missionNamespace getVariable [format["ZMM_%1_Supports", _zoneID], 1];
private _menArr = missionNamespace getVariable [format["ZMM_%1Man",_side],[]];

private _vehL = missionNamespace getVariable [format["ZMM_%1Veh_Light",_side],[]];
private _vehM = missionNamespace getVariable [format["ZMM_%1Veh_Medium",_side],[]];
private _vehH = missionNamespace getVariable [format["ZMM_%1Veh_Heavy",_side],[]];
private _vehU = missionNamespace getVariable [format["ZMM_%1Veh_Util",_side],[]];
private _hmgArr = missionNamespace getVariable [format["ZMM_%1Veh_Static",_side],[]];

if (_count == 0) then { _count = 1 };
["DEBUG", format["Zone%1 - Creating Supports: %2", _zoneID, _count]] call zmm_fnc_logMsg;

private _vehArr = [];
if (count _vehL > 1) then { _vehArr append _vehL; _vehArr append _vehL; }; // Common
if (count _vehM > 1) then { _vehArr append _vehM; }; // Medium

if (count _hmgArr == 0) then { _hmgArr = ["B_GMG_01_high_F","B_HMG_01_high_F"] };

if (count _locations == 0) then {
	// Find Support Locations
	for [{_i = 0}, {_i < 360}, {_i = _i + 5}] do {
		for [{_j = _radius * 0.75}, {_j <= (_radius * 2)}, {_j = _j + 25}] do {
			private _tempPos = _centre getPos [_j, _i];
						
			if ({_x distance2D _tempPos < 400} count _locations == 0 && !(_tempPos isFlatEmpty [25, -1, 0.25, 5] isEqualTo [])) then {
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
	};
};

private _supportList = [
	[
		"o_ordinance", // Small Munitions Area
		[
			["S","Land_Net_Fence_pole_F", [-1.75,-2,0], 0],
			["S","Land_Net_Fence_4m_F", [0.25,-6,0], 0],
			["S","Land_Net_Fence_4m_F", [-1.75,-4,0], 90],
			["S","Land_Net_Fence_4m_F", [6.25,-4,0], 270],
			["S","Land_Net_Fence_4m_F", [4.25,-6,0], 0],
			["O","Box_Syndicate_WpsLaunch_F", [5.5,-2.375,0.1], 75],
			["O","Box_Syndicate_WpsLaunch_F", [5,-3.75,0.1], 165],
			["S","Land_PaperBox_closed_F", [3.375,-4.875,0], 210],
			["S","Land_PaperBox_closed_F", [5.375,-5.125,0], 0],
			["S","Land_BagFence_Round_F", [-6.125,-5.5,0], 39],
			["S","Land_BagFence_Round_F", [-6.39063,-3.20068,0], 125],
			["V", selectRandom _hmgArr, [-5.5,-4.125,0.1], 270],
			["S","Land_ToiletBox_F", [-2.875,3.875,0], 105],
			["S","Land_Net_Fence_4m_F", [6.25,0,0], 270],
			["S","Land_Net_Fence_4m_F", [4.25,2,0], 180],
			["S","Land_Net_Fence_4m_F", [0.25,2,0], 180],
			["S","Land_MetalBarrel_F", [2.25488,1.27783,0], 270],
			["S","Land_MetalBarrel_F", [3.125,0.875,0], 300],
			["S","Land_MetalBarrel_F", [4,1.125,0], 165]
		]
	],
	[
		"o_recon", // Small Radio Post
		[
			["S", selectRandom _vehArr, [-5.5,-3.75,0.2], 195, false],
			["O","Land_TTowerSmall_1_F", [-0.75,-6.5,4.76837e-007], 0, false],
			["S","Land_TBox_F", [1.25,-8.75,0], 0],
			["V", selectRandom _hmgArr, [-3.23291,4.0293,0.1], 15],
			["V", selectRandom _hmgArr, [7.625,-0.625,0.1], 45],
			["O","Land_Cargo_House_V2_F", [3,-2.875,0.2], 180, false],
			["S","Land_BagFence_Round_F", [-1.3042,4.53564,0], 225],
			["S","Land_BagFence_Round_F", [8.32129,0.410645,0], 225],
			["S","Land_BagFence_Long_F", [9,-2.125,0], 90],
			["S","Land_BagFence_Long_F", [-0.625,2,0], 90],
			["S","Land_BagFence_Long_F", [6.00049,1.3418,0], 190],
			["S","Land_BagFence_Long_F", [-3.62451,5.4668,0], 190]
		]
	],
	[
		"o_service", // Service Hangar
		[
			["S","Land_HBarrier_3_F", [7.75,-5.875,0], 0],
			["S","Land_HBarrier_3_F", [-7.75,-12.23,0], 225],
			["S","Land_HBarrier_3_F", [-5.375,-13.625,0], 195],
			["S","Land_HBarrier_3_F", [4.625,-5.875,0], 0],
			["S","Land_HBarrier_3_F", [0.649902,-14,0], 180],
			["S","Land_HBarrier_3_F", [-8.75,6.875,0], 90],
			["S","Land_HBarrier_3_F", [-2.37988,-14,0], 180],
			["S","Land_BarrelTrash_grey_F", [2.25,-12.5,0], 120],
			["S","Land_MetalBarrel_empty_F", [-6.25,-11.3452,0], 330],
			["S","Land_MetalBarrel_empty_F", [-7.2002,-10.5,0], 225],
			["S","Land_MetalBarrel_empty_F", [-5.8999,-12,0], 120],
			["S","Land_PaperBox_closed_F", [-6.875,6.625,0], 345],
			["S","Land_PaperBox_closed_F", [-7,3.5,0], 15],
			["S","Land_GarbagePallet_F", [5.75,-4,0], 195],
			["V", selectRandom _vehH, [2.25,6.75,0.2], 0, false],
			["O","Land_RepairDepot_01_green_F", [-4.875,-4.125,0], 90],
			["S","WaterPump_01_forest_F", [7.75,-0.375,0], 15],
			["O","Land_TentHangar_V1_F", [-0.25,-0.625,0], 0],
			["S","Land_Sacks_goods_F", [-2.1499,-12.1001,0], 0],
			["S","Land_HBarrier_3_F", [-8.75,10,0], 90],
			["S","Land_HBarrier_3_F", [-5,12.125,0], 15],
			["S","Land_HBarrier_3_F", [-7.5,11.875,0], 330],
			["V", selectRandom _hmgArr, [8.53076,12.1353,0.1], 0],
			["S","Land_BagFence_Long_F", [9.75,11.875,0], 90],
			["S","Land_BagFence_Long_F", [8.25,13.375,0], 180],
			["S","Land_WaterBarrel_F", [-4.25,9.625,0], 0]
		]
	],
	[
		"o_mortar", // Small Mortar Site
		[
			["S","Land_MetalBarrel_F", [-2.875,-3,0], 105],
			["S","Land_MetalBarrel_F", [-3.75,-2.5,0], 60],
			["V","B_Mortar_01_F", [-0.25,-0.125488,0.1], 0],
			["S","Land_BagFence_Round_F", [1.24316,2.21338,0], 230],
			["S","Land_BagFence_Round_F", [1.375,-2.25,0], 309],
			["S","Land_BagFence_Round_F", [-1.04639,2.55176,0], 144],
			["S","Land_BagFence_Round_F", [-0.924316,-2.51563,0], 35]
		]
	],
	[
		"o_support", // Refuelling Area
		[
			["S","Land_HBarrier_3_F", [-6.25,1.75,0], 270],
			["S","Land_HBarrier_3_F", [-1.25,5.5,0], 0],
			["S","Land_HBarrier_3_F", [-6.25,4.625,0], 270],
			["S","Land_HBarrier_3_F", [-4.125,5.5,0], 0],
			["S","Land_Tank_rust_F", [-1.625,3.125,0], 180],
			["S","Land_MetalBarrel_F", [-5.125,-1.875,0], 90],
			["S","Land_MetalBarrel_F", [-4.50488,-1.0752,0], 135],
			["O","MetalBarrel_burning_F", [-3.625,-5.875,0], 90],
			["S","Land_PaperBox_closed_F", [-6.625,-1,0.1], 270],
			["V", selectRandom _hmgArr, [-5.5,-6.75,0], 180],
			["S","Land_CanisterFuel_F", [-0.0249023,1.74512,0], 0],
			["S","Land_CanisterFuel_F", [-0.25,1.25,0], 120],
			["S","Land_BagFence_Long_F", [-5.50488,-8.625,0], 0],
			["S","Land_BagFence_Long_F", [-6.875,-7.25049,0], 270],
			["O","CamoNet_BLUFOR_open_F", [-1.5,-3.875,0], 0, false],
			["S","Land_BagFence_End_F", [-6.9751,-5.5752,0], 255],
			["S","Land_BagFence_End_F", [-3.88477,-8.875,0], 30],
			["V", selectRandom _vehU, [0,10.25,0.2], 270, false],
			["S","Land_HBarrier_3_F", [1.75,5.5,0], 0],
			["S","Land_MetalBarrel_F", [0.75,1.375,0], 0],
			["S","Land_MetalBarrel_empty_F", [1.5,2.125,0], 210],
			["S","Land_MetalBarrel_empty_F", [3.375,-4.875,0], 0],
			["S","Land_CratesPlastic_F", [2.99316,3.62256,0], 240],
			["V", selectRandom _vehArr, [9.875,3,0.2], 15, false],
			["S","Land_Pallets_F", [4,4,0], 135]
		]
	]
];
	
for "_i" from 1 to _count do {
	private _pos = [];
	
	if (count _locations == 0) exitWith {
		//[center, minDist, maxDist, 25, 0, 0.1] call BIS_fnc_findSafePos 
	};
	
	private _pos = selectRandom _locations;
	_locations deleteAt (_locations find _pos);
	
	private _key = "Land_HelipadEmpty_F" createVehicleLocal _pos;
	_key setDir random 360;
		
	// Clear Area
	{ [_x, true] remoteExec ["hideObject", 0, true] } forEach (nearestTerrainObjects [_pos, [], 25]);
	
	// Build Support	
	(selectRandom _supportList) params ["_icon", "_list"];
	
	{
		_x params ["_type", "_class", "_rel", ["_dir", 0], ["_flat", true]];
		
		private _worldPos = _key modeltoWorld _rel;	
		private _worldDir = getDir _key + _dir;
		private _obj = ObjNull;
		
		_worldPos set [2, _rel#2]; // Set to ground
		
		switch (_type) do {
			case "V": {
				private _customInit = "";
				// If _class is array, extract the custom init.
				if (_class isEqualType []) then { _customInit = _class#1; _class = _class#0 };
				
				_obj = _class createVehicle [0,0,0];
				_obj setDir _worldDir;
				_obj setPosATL _worldPos;
				
				if (canMove _obj) then { _obj setVehicleLock "LOCKEDPLAYER" };
				
				private _crewArr = [];
				for "_j" from 1 to (count ((fullCrew [_obj, "", true]) - fullCrew [_obj, "cargo", true] - fullCrew [_obj, "turret", true])) do {
					_crewArr pushBack (selectRandom _menArr);
				};
	
				private _tempGrp = [_obj getPos [15, random 360], _side, _crewArr] call BIS_fnc_spawnGroup;
				
				{ _x moveInAny _obj } forEach units _tempGrp;
		
				// Run custom init for vehicle (set camos etc).
				private _grpVeh = _obj;
				if !(_customInit isEqualTo "") then { call compile _customInit; };
				
				private _clear = createVehicle ["Land_ClutterCutter_large_F", _worldPos, [], 0, "CAN_COLLIDE"];
				
				_tempGrp deleteGroupWhenEmpty true;
				_tempGrp enableDynamicSimulation true;
			};
			case "O": {
				_obj = _class createVehicle [0,0,0];
				_obj setDir _worldDir;
				_obj setPosATL _worldPos;
			};
			default {
				_obj = createSimpleObject [_class, [0,0,0]];
				_obj setDir _worldDir;
				_obj setPosATL _worldPos;
			};
		};
		
		if _flat then { _obj setVectorUp surfaceNormal getPos _obj };
	} forEach _list;
	
	sleep 1;
	
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
		_mrkr setMarkerTextLocal format["S%1", _i];
	};
};