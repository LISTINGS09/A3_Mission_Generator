// [] call zmm_fnc_areaRoadblock;
if !isServer exitWith {};

params [
	["_zoneID", 0],
	["_centre", (missionNamespace getVariable [ format[ "ZMM_%1_Location", _this#0], [0,0,0]])],
	["_showMarker", true],
	["_forcePos", false],
	["_forceLayout", -1]
];

if (_centre isEqualTo [0,0,0]) exitWith { ["ERROR", format["Zone%1 - Invalid roadblock location: %1 (%2)", _zoneID, _centre]] call zmm_fnc_logMsg };

private _side = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locations = missionNamespace getVariable [ format[ "ZMM_%1_BlockLocations", _zoneID ], []]; // Takes too long to populate - Left blank

private _radius = missionNamespace getVariable [ format[ "ZMM_%1_Radius", _zoneID ], 150];
private _count = missionNamespace getVariable [format["ZMM_%1_Roadblocks", _zoneID], 1];
private _menArr = missionNamespace getVariable [format["ZMM_%1Man",_side],[]];

private _vehL = missionNamespace getVariable [format["ZMM_%1Veh_Light",_side],[]];
private _vehM = missionNamespace getVariable [format["ZMM_%1Veh_Medium",_side],[]];
private _vehH = missionNamespace getVariable [format["ZMM_%1Veh_Heavy",_side],[]];
private _hmgArr = missionNamespace getVariable [format["ZMM_%1Veh_Static",_side],[]];

if (_count == 0) then { _count = 1 };

["DEBUG", format["Zone%1 - Creating Roadblocks: %2", _zoneID, _count]] call zmm_fnc_logMsg;

// Populate Vehicles
private _vehArr = _vehL;
if ((missionNamespace getVariable ["ZZM_Diff", 1]) >= 1) then { _vehArr append _vehM };
if ((missionNamespace getVariable ["ZZM_Diff", 1]) >= 1.5) then { _vehArr append _vehH };
if (count _hmgArr == 0) then { _hmgArr = ["I_HMG_02_high_F"] };

if (!_forcePos && count _locations == 0) then {
	// Find Road Block Locations
	for [{_i = 0}, {_i < 360}, {_i = _i + 10}] do {
		private _roads = ((_centre getPos [(_radius * (1 + random 0.5)) max 300, _i]) nearRoads 100) select {count roadsConnectedTo _x > 0 && (nearestBuilding _x) distance _x > 75 && !((getPos _x) isFlatEmpty [-1, -1, 0.25, 6] isEqualTo [])};
			
		if (count _roads > 0) then {
			private _road = _roads#0;
			if ({_x distance2D _road < 600} count _locations == 0) then {
				_locations pushBack _road;
			};
		};
	};
	
	if (count _locations > _count) exitWith {};
} else {
	private _tempRoad = "Land_ClutterCutter_small_F" createVehicleLocal _centre; // Create Fake Object
	if _forcePos then { _locations = [_tempRoad] };
};

private _buildingList = [
	[
		["S","Land_BagBunker_Small_F", [8.25,-0.5,-0.1], 180, false],
		["S","Land_BagFence_Long_F", [-10.25,3.5,0], 0],
		["S","Land_BagFence_Long_F", [-7.5,3.5,0], 0],
		["S","Land_BagFence_Round_F", [-13,3.25,0], 150],
		["S","Land_CncBarrierMedium4_F", [-6.5,-0.5,0], 90],
		["S","Land_CncBarrierMedium_F", [-14.5,1,0], 270],
		["S","Land_CncBarrierMedium_F", [11.75,-1.5,0], 0],
		["S","Land_CncBarrierMedium_F", [13.75,-2.5,0], 30],
		["S","Land_CncBarrier_F", [-11.5,6.5,0], 165],
		["S","Land_CncBarrier_F", [12.25,4.5,0], 30],
		["S","Land_CncBarrier_stripes_F", [-7.5,6.5,0], 0],
		["S","Land_CncBarrier_stripes_F", [8.25,5.5,0], 0],
		["V", selectRandom _hmgArr, [8.5,-0.25,0.2], 0, false],
		["V", selectRandom _vehArr, [-10.125,-2,0.2], 0, false]
	],
	[
		["S","Land_BagFence_End_F", [-7.25,4.5,0], 60],
		["S","Land_BagFence_Long_F", [-10.25,6.5,0], 0],
		["S","Land_BagFence_Long_F", [-13.5,3.75,0], 90],
		["S","Land_BagFence_Round_F", [-12.75,5.75,0], 135],
		["S","Land_BagFence_Round_F", [-8,5.75,0], 225],
		["S","Land_BagFence_Round_F", [11.25,2,0], 225],
		["S","Land_BagFence_Round_F", [9.25,2,0], 135],
		["S","RoadBarrier_F", [-14,10,0], 0],
		["S","RoadBarrier_F", [-8,10,0], 0],
		["V", selectRandom _hmgArr, [10.5,1.25,0.2], 0, false],
		["V", selectRandom _vehArr, [-10,0,0.2], 0, false]
	],
	[
		["S","Land_BagBunker_Tower_F", [-11,1,-0.1], 180, false],
		["S","Land_CncBarrier_F", [-11,7,0], 0],
		["S","Land_CncBarrier_F", [-14.5,6.25,0], 315],
		["S","Land_CncBarrier_F", [12,7,0], 0],
		["S","Land_CncBarrier_F", [15,6,0], 45],
		["S","Land_CncBarrier_F", [16,3,0], 90],
		["S","Land_CncBarrier_stripes_F", [-8,7,0], 0],
		["S","Land_CncBarrier_stripes_F", [16,-0.75,0], 90],
		["S","Land_CncBarrier_stripes_F", [9,7,0], 0],
		["S","RoadBarrier_F", [-9,10,0], 0],
		["S","RoadBarrier_F", [10,10,0], 0],
		["S","RoadBarrier_small_F", [-12,10,0], 330],
		["S","RoadBarrier_small_F", [14,10,0], 15],
		["V", selectRandom _hmgArr, [-10.25,3,2.8], 0, false],
		["V", selectRandom _vehArr, [11.25,0.5,0.2], 0, false]
	]
];

["DEBUG", format["Zone%1 - Creating Roadblocks: %2 in %4 positions (%3m)", _zoneID, _count, _radius, count _locations]] call zmm_fnc_logMsg;

for "_i" from 1 to _count do {
	if (count _locations == 0) exitWith {};
	
	private _road = selectRandom _locations;
	private _pos = getPos _road;
	_locations deleteAt (_locations find _road);
	
	private _key = "Land_ClutterCutter_small_F" createVehicleLocal (getPosATL _road);
	
	// If nothing connected to it (or forced) just rotate...
	if (count (roadsConnectedTo _road) > 0) then {
		private _farRoad = objNull;
		{if ((_x distance _centre) < (_farRoad distance _centre)) then {_farRoad = _x}} forEach (roadsConnectedTo _road);
		_key setDir ((_road getDir _farRoad) + 180);
		/*private _blockMkr = createMarkerLocal [format ["OBLK_%1_%2", _zoneID, _i], position _road];
		_blockMkr setMarkerDirLocal (_road getDir _farRoad) + 180;
		_blockMkr setMarkerTypeLocal "mil_arrow";
		_blockMkr setMarkerColorLocal "ColorYellow";
		_blockMkr setMarkerTextLocal format["block_%1", _i];*/
	} else {
		_key setDir ((getDir _road) + 90);
	};
	
	// Clear Area
	{ [_x, true] remoteExec ["hideObject", 0, true] } forEach (nearestTerrainObjects [_pos, ["TREE", "SMALL TREE", "BUSH", "BUILDING", "HOUSE", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "CHURCH", "CHAPEL", "CROSS", "BUNKER", "FORTRESS", "FOUNTAIN", "VIEW-TOWER", "LIGHTHOUSE", "QUAY", "FUELSTATION", "HOSPITAL", "FENCE", "WALL", "HIDE", "BUSSTOP", "FOREST", "TRANSMITTER", "STACK", "RUIN", "TOURISM", "WATERTOWER", "ROCK", "ROCKS", "POWERSOLAR", "POWERWAVE", "POWERWIND", "SHIPWRECK"], 25]);
	
	// Build Roadblock
	_bID = if (_forceLayout >= 0 && _forceLayout < count _buildingList) then { _forceLayout } else { floor random count _buildingList };
	private _list = _buildingList#_bID;
	private _icon = "o_installation";
	
	["DEBUG", format["Zone%1 - Area Roadblock - Spawning: %4 of %5 - ID%2 at %3", _zoneID, _bID, _pos, _i, _count]] call zmm_fnc_logMsg;
	
	{
		_x params ["_type", ["_class",""], ["_rel",[0,0,0]], ["_dir", 0], ["_flat", true]];
		private _worldPos = _key modeltoWorld _rel;	
		private _obj = [_zoneID, _side, _type, _class, [_worldPos#0, _worldPos#1, _rel#2], getDir _key + _dir, _flat] call zmm_fnc_spawnObject;		
	} forEach selectRandom _buildingList;
	
	// Create a local patrolling group
	private _grpArr = [];
	for "_j" from 0 to (1 + random 3) do { _grpArr pushBack (selectRandom _menArr) };

	private _tempGrp = [_key getPos [25, random 360], _side, _grpArr] call BIS_fnc_spawnGroup;
	[_tempGrp, getPos _key] call BIS_fnc_taskDefend;
	_tempGrp deleteGroupWhenEmpty true;
	_tempGrp enableDynamicSimulation true;
	{ _x addCuratorEditableObjects [units _tempGrp, true] } forEach allCurators;
	
	if (_showMarker) then {
		if (missionNamespace getVariable ["ZZM_Mode", 0] == 0) then {
			private _mrkr = createMarker [format["MKR_%1_RB_%2", _zoneID, _i], _pos getPos [25, random 360]];
			_mrkr setMarkerType "mil_unknown";
			_mrkr setMarkerColor format["Color%1",_side];

			private _cpTrigger = createTrigger ["EmptyDetector", _pos, false];
			_cpTrigger setTriggerActivation [format["%1",_side], "NOT PRESENT", false];
			_cpTrigger setTriggerArea [25, 25, 0, false];
			_cpTrigger setTriggerStatements [  "this", format["'MKR_%1_RB_%2' setMarkerColor 'ColorGrey'", _zoneID, _i], "" ];
			
			private _hdTrigger = createTrigger ["EmptyDetector", _pos, false];
			_hdTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
			_hdTrigger setTriggerArea [150, 150, 0, false, 25];
			_hdTrigger setTriggerStatements [  "this", format["'MKR_%1_RB_%2' setMarkerType '%3'; 'MKR_%1_RB_%2' setMarkerPos %4", _zoneID, _i, _icon, _pos], "" ];
		} else {
			private _mrkr = createMarkerLocal [format ["MKR_%1_RB_%2", _zoneID, _i], _pos];
			_mrkr setMarkerTypeLocal _icon;
			_mrkr setMarkerColorLocal format["Color%1",_side];
			if (!isMultiplayer) then { _mrkr setMarkerTextLocal format["RoadBlock%1", _bID]; };
		};
	};
};

missionNamespace setVariable [ format[ "ZMM_%1_BlockLocations", _zoneID ], _locations];

_centre set [2,0];
_centre