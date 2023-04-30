// Spawns random debris and IEDs around a location (300m).
// [69, nil, 4] spawn zmm_fnc_areaIED;
if !isServer exitWith {};

params [
	["_zoneID", 0],
	["_centre", (missionNamespace getVariable [ format[ "ZMM_%1_Location", _this#0], [0,0,0]])],
	["_count", (missionNamespace getVariable [ format[ "ZMM_%1_IEDs", _this#0], 10])],
	["_radius", (missionNamespace getVariable [ format[ "ZMM_%1_Radius", _this#0], 300])]
];

if (_centre isEqualTo [0,0,0]) exitWith { ["ERROR", format["Zone%1 - Invalid IED location: %1 (%2)", _zoneID, _centre]] call zmm_fnc_logMsg };

private _mineLocs = [];

{
	private _road = _x;
	if ({ _road distance2D _x < 100 } count _mineLocs == 0) then {
		if (count roadsConnectedTo _road > 0) then {
			_mineLocs pushBack (_road getPos [(boundingBoxReal _road#0#0) * 0.5, ((_road getDir ((roadsConnectedTo _road)#0)) + 90) + selectRandom [0,180]]); // Left or right of road.
		};
	};
} forEach (_centre nearRoads _radius);

// Create locations if none exist
if (count _mineLocs < _count) then {
	for "_i" from 0 to (_count) do {
		_mineLocs pushBack (_centre getPos [25 + random 50, random 360]);
	};
};

["DEBUG", format["Zone%1 - Area IED - Creating: %2 in %4 positions (%3m)", _zoneID, ((_count * 3) max 6), _radius, count _mineLocs]] call zmm_fnc_logMsg;

// Generate the IEDs.
for "_i" from 0 to ((_count * 3) max 6) do {
	if (_mineLocs isEqualTo []) exitWith {};
	
	private _minePos = selectRandom _mineLocs;
	_mineLocs deleteAt (_mineLocs find _minePos);
	
	private _isUrban = _minePos distance2D nearestBuilding _minePos < 100;

	// Create debris
	private _tempObj = createSimpleObject [selectRandom ["Land_Garbage_square3_F", "Land_Garbage_square5_F", "Land_Garbage_line_F"], AGLToASL _minePos];
	_tempObj setVectorUp surfaceNormal getPos _tempObj;
	_tempObj setDir random 360;
	
	// Spawn an IED
	if (_count < _i) then {
		private _mineObj = createMine [if (_isUrban) then { selectRandom ["IEDUrbanBig_F","IEDUrbanSmall_F"] } else { selectRandom ["IEDLandBig_F","IEDLandSmall_F"] }, _minePos vectorAdd [0,0,0.1], [], 1];
		_mineObj setDir random 360;
		
		private _mineMkr = createMarkerLocal [format ["OBLK_%1_%2", _zoneID, _i], _minePos];
		_mineMkr setMarkerTypeLocal "mil_dot";
		_mineMkr setMarkerColorLocal "ColorRed";
		_mineMkr setMarkerTextLocal format["IED_%1", _i];
	
		private _mineTrigger = createTrigger ["EmptyDetector", _mineObj, false];
		_mineTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
		_mineTrigger setTriggerArea [10, 10, 5, false];
		_mineTrigger setTriggerStatements [ "{ stance _x != 'PRONE' && speed _x > 6 } count thisList > 0",
				"if ({ thisTrigger distance2D _x < 1.5} count allMines > 0) then { createVehicle [selectRandom ['Bo_Mk82','Rocket_03_HE_F','M_Mo_82mm_AT_LG','Bo_GBU12_LGB','Bo_GBU12_LGB_MI10','HelicopterExploSmall'], getPosATL thisTrigger, [], 0, ''];
				createVehicle ['Crater', getPosASL thisTrigger, [], 0, ''];
				{ deleteVehicle _x } forEach (allMines select { thisTrigger distance2D _x < 1.5 }) }; deleteVehicle thisTrigger;", "" ];
	};
};