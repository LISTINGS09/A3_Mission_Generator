// [0, player getPos [100, random 360], false, true] call zmm_fnc_areaStatic;
// Returns position created at
if !isServer exitWith {};

params [
	["_zoneID", 0],
	["_centre", (missionNamespace getVariable [ format[ "ZMM_%1_Location", _this#0], [0,0,0]])],
	["_showMarker", true],
	["_forcePos", false],
	["_forceID", -1]
];

if (_centre isEqualTo [0,0,0]) then { _centre = [_centre, 0, 200, 5, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos };

private _side = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locations = missionNamespace getVariable [ format[ "ZMM_%1_StaticLocations", _zoneID ], []];  // Takes too long to populate - Left blank

private _radius = missionNamespace getVariable [ format[ "ZMM_%1_Radius", _zoneID ], 150];
private _count = missionNamespace getVariable [format["ZMM_%1_Supports", _zoneID], 1];
private _menArr = missionNamespace getVariable [format["ZMM_%1Man",_side],[]];

private _vehL = missionNamespace getVariable [format["ZMM_%1Veh_Light",_side],[]];
private _vehM = missionNamespace getVariable [format["ZMM_%1Veh_Medium",_side],[]];
private _vehH = missionNamespace getVariable [format["ZMM_%1Veh_Heavy",_side],[]];
private _vehU = missionNamespace getVariable [format["ZMM_%1Veh_Util",_side],[]];
private _hmgArr = missionNamespace getVariable [format["ZMM_%1Veh_Static",_side],[]];

if (_count == 0) then { _count = 1 };

["DEBUG", format["Zone%1 - Creating Static: Count %2 at %3%4", _zoneID, _count, _centre, [""," [FORCED]"] select _forcePos]] call zmm_fnc_logMsg;

private _vehArr = _vehL;
if ((missionNamespace getVariable ["ZZM_Diff", 1]) >= 1) then { _vehArr append _vehM };
if ((missionNamespace getVariable ["ZZM_Diff", 1]) >= 1.5) then { _vehArr append _vehH };
if (count _hmgArr == 0) then { _hmgArr = ["B_GMG_01_high_F","B_HMG_01_high_F"] };

private _vehAAA = missionNamespace getVariable [format["ZMM_%1Veh_AAA",_side],_vehArr];
private _vehART = missionNamespace getVariable [format["ZMM_%1Veh_ART",_side],_vehArr];

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
		"o_antiair",
		[
			["V", selectRandom _vehAAA, [0,0,0.625],0],
			["S","Land_BagFence_Round_F",[-3.75,5.25,0],135],
			["S","Land_BagFence_Round_F",[3.875,5.25,0],225],
			["S","Land_BagFence_Round_F",[-3.625,-6.125,0],45],
			["S","Land_BagFence_Round_F",[4,-6.125,0],315],
			["S","Land_PaperBox_01_open_empty_F",[-4.81787,-3.60107,0],285],
			["S","Land_BagFence_Short_F",[-1.69287,5.89893,0],0],
			["S","Land_BagFence_Short_F",[-1.69287,-6.85107,0],0],
			["S","Land_BagFence_Short_F",[1.93213,-6.72607,0],180],
			["S","Land_BagFence_Short_F",[2.05713,6.02393,0],180],
			["S","Land_CratesShabby_F",[-3.69287,-4.60107,0],0],
			["S","Land_CratesWooden_F",[5.55713,4.14893,0],90],
			["V", selectRandom _hmgArr,[-2.5,4.5,0.2],330]
		]
	],
	[
		"o_antiair",
		[
			["V", selectRandom _vehAAA, [0,0,0.625],0],
			["S","Land_BagFence_Round_F",[3.375,6.25,0],225],
			["S","Land_BagFence_Round_F",[-4.25,6.25,0],135],
			["S","Land_BagFence_Short_F",[-2.33643,6.88208,0],0],
			["S","Land_BagFence_Short_F",[1.53857,7.00708,0],180],
			["S","Land_CratesShabby_F",[-3.5,-3.125,0],0],
			["S","Land_CratesWooden_F",[5.78857,-2.24292,0],90],
			["S","Land_HBarrier_3_F",[4.125,-2.5,0],270],
			["S","Land_HBarrier_3_F",[-4.75,-2.375,0],270],
			["V", selectRandom _hmgArr,[-2.5,5,0.2],330]
		]
	],
	[
		"o_antiair",
		[
			["V", selectRandom _vehAAA, [0,0,0.625],0],
			["S","Land_BagFence_Round_F",[3.875,5.75,0],225],
			["S","Land_BagFence_Round_F",[-3.625,-5.625,0],45],
			["S","Land_PaperBox_01_open_empty_F",[-4.375,-0.125,0],255],
			["S","Land_CratesShabby_F",[3.625,5.125,0],0],
			["S","Land_CratesWooden_F",[-6.125,-1.375,0],90],
			["S","Land_HBarrier_3_F",[-4.25,-2.875,0],270],
			["S","Land_HBarrier_3_F",[4.5,2.875,0],270],
			["S","Land_BagFence_Long_F",[-1.25,-6.25,0],0],
			["S","Land_BagFence_Long_F",[1.5,6.375,0],180],
			["V", selectRandom _hmgArr,[2,5,0.2],0]
		]
	],
	[
		"o_antiair",
		[
			["V", selectRandom _vehAAA, [0,0,0.625],0],
			["S","Land_BagFence_Round_F",[3.875,7.25,0],225],
			["S","Land_BagFence_Round_F",[-3.75,7.25,0],135],
			["S","Land_CratesShabby_F",[-5.72119,3.78418,0],0],
			["S","Land_HBarrier_3_F",[-4.5,4.625,0],270],
			["S","Land_HBarrier_3_F",[4.5,4.375,0],270],
			["S","Land_BagFence_Long_F",[1.5,7.875,0],180],
			["S","Land_BagFence_Long_F",[-1.25,7.875,0],180],
			["V", selectRandom _hmgArr,[2,5.5,0.2],30],
			["V", selectRandom _hmgArr,[-2,5.5,0.2],315]
		]
	],
	[
		"o_antiair",
		[
			["V", selectRandom _vehAAA, [0,0,0.625],0],
			["S","Land_BagFence_Round_F",[-3.75,5.75,0],135],
			["S","Land_BagFence_Round_F",[3.875,5.75,0],225],
			["S","Land_BagFence_Round_F",[-3.625,-5.625,0],45],
			["S","Land_BagFence_Round_F",[4,-5.625,0],315],
			["S","Land_PaperBox_01_open_empty_F",[-2.5,-7.5,0],0],
			["S","Land_CratesShabby_F",[-1,-7,0],0],
			["S","Land_CratesWooden_F",[6.125,3.375,0],90],
			["S","Land_HBarrier_3_F",[-4.25,-2.875,0],270],
			["S","Land_HBarrier_3_F",[4.625,-3,0],270],
			["S","Land_HBarrier_3_F",[4.5,2.875,0],270],
			["S","Land_BagFence_Long_F",[-4.375,3.375,0],90],
			["S","Land_BagFence_Long_F",[-1.25,6.375,0],180],
			["S","Land_BagFence_Long_F",[1.5,-6.25,0],0],
			["S","Land_BagFence_Long_F",[-1.25,-6.25,0],0],
			["S","Land_BagFence_Long_F",[1.5,6.375,0],180],
			["V", selectRandom _hmgArr,[-2.5,4.5,0.2],315]
		]
	],
	[
		"o_antiair",
		[
			["V", selectRandom _vehAAA, [0,0,0.625],0],
			["S","Land_BagFence_Round_F",[-4.25,5.25,0],135],
			["S","Land_BagFence_Round_F",[3.375,5.25,0],225],
			["S","Land_BagFence_Round_F",[3.5,-6.125,0],315],
			["S","Land_BagFence_Round_F",[-4.125,-6.125,0],45],
			["S","Land_PaperBox_01_open_empty_F",[-5.92627,-4.37427,0],0],
			["S","Land_CratesShabby_F",[-4.80127,-3.87427,0],0],
			["S","Land_BagFence_Long_F",[1,-6.75,0],0],
			["S","Land_BagFence_Long_F",[1,5.875,0],180],
			["S","Land_BagFence_Long_F",[-1.75,5.875,0],180],
			["S","Land_BagFence_Long_F",[-1.75,-6.75,0],0],
			["V", selectRandom _hmgArr,[2.479,3.96826,0.2],45]
		]
	],
	[
		"o_antiair",
		[
			["V", selectRandom _vehAAA, [0,0,0.625],0],
			["S","Land_BagFence_Round_F",[-4.25,6.25,0],135],
			["S","Land_PaperBox_01_open_empty_F",[5.92822,-3.57007,0],0],
			["S","Land_CratesShabby_F",[5.05322,-4.69507,0],90],
			["S","Land_CratesWooden_F",[5.80322,3.42993,0],90],
			["S","Land_HBarrier_3_F",[4.125,-2.5,0],270],
			["S","Land_HBarrier_3_F",[-4.75,-2.375,0],270],
			["S","Land_HBarrier_3_F",[-5,3.625,0],270],
			["S","Land_HBarrier_3_F",[4,3.375,0],270],
			["S","Land_BagFence_Long_F",[4.17822,0.429932,0],90],
			["S","Land_BagFence_Long_F",[-4.69678,0.554932,0],90],
			["S","Land_BagFence_Long_F",[-1.75,6.875,0],0],
			["V", selectRandom _hmgArr,[-2.5,5,0.2],0]
		]
	]
];

["DEBUG", format["Zone%1 - Creating Static: %2 in %3 positions (%4 types)", _zoneID, _count, count _locations, count _buildingList]] call zmm_fnc_logMsg;

for "_i" from 1 to _count do {	
	if (count _locations == 0) exitWith { _centre = [0,0,0] };
	
	private _pos = selectRandom _locations;
	_locations deleteAt (_locations find _pos);

	private _key = "Land_ClutterCutter_small_F" createVehicleLocal _pos;
	_key setDir random 360;
		
	// Clear Area
	{ [_x, true] remoteExec ["hideObject", 0, true] } forEach (nearestTerrainObjects [_pos, ["TREE", "SMALL TREE", "BUSH", "BUILDING", "HOUSE", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "CHURCH", "CHAPEL", "CROSS", "BUNKER", "FORTRESS", "FOUNTAIN", "VIEW-TOWER", "LIGHTHOUSE", "QUAY", "FUELSTATION", "HOSPITAL", "FENCE", "WALL", "HIDE", "BUSSTOP", "FOREST", "TRANSMITTER", "STACK", "RUIN", "TOURISM", "WATERTOWER", "ROCK", "ROCKS", "POWERSOLAR", "POWERWAVE", "POWERWIND", "SHIPWRECK"], 5]);
	
	// Build Support	
	_bID = if (_forceID >= 0 && _forceID < count _buildingList) then { _forceID } else { floor random count _buildingList };
	(_buildingList#_bID) params ["_icon", "_buildingObjects"];
	
	["DEBUG", format["Zone%1 - Spawning Static: %5 of %6 - ID%2 (%3) at %4", _zoneID, _bID, _icon, _pos, _i, _count]] call zmm_fnc_logMsg;

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
			_mrkr setMarkerTypeLocal _icon;
			_mrkr setMarkerColorLocal format["Color%1",_side];
			if (!isMultiplayer) then { _mrkr setMarkerTextLocal format["Static%1", _bID]; };
		};
	};
};

_centre set [2,0];
_centre