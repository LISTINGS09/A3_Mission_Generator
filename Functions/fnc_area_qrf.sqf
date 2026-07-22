if !isServer exitWith {};
// [99, false, 30, 6, -1] spawn ZMM_fnc_areaQRF;

params [
	["_zoneID", 0],
	["_triggerOnly", false],
	["_delay", 300],
	["_waveMax", 10],
	["_qrfType", 0],
	["_diff",-1]
];

private _side = missionNamespace getVariable [format["ZMM_%1_enemySide", _zoneID], EAST];

if (_diff < 0) then { _diff = missionNamespace getVariable ["ZZM_Diff", missionNamespace getVariable ["f_param_ZMMDiff", 1]] };

//_randomWeightedElement = ;
private _qrfTypes = [
	"Dynamic"
	,"General"
	,"Motorized"
	,"Mechanised"
	,"Armoured"
	,"Airborne"
	,"Infantry"
	,"Helicopter"
	,"Aircraft"
	,"Naval"
];

// INDEP QRF Weighting
private _indQRF = [
	0,	3.5, 				// Dynamic
	1,	3.5, 				// General
	2,	3.0, 				// Motorized
	3,	1.5, 				// Mechanised
	4,	(0.25 * _diff), 	// Armoured
	5,	0.5, 				// Airborne
	6,	4.0, 				// Infantry
	7,	(0.5 * _diff), 	// Helicopter
	8,	(0.25 * _diff),	// Aircraft
	9,	1					// Naval
];

// OPFOR QRF Weighting
private _opfQRF = [
	0,	3, 					// Dynamic
	1,	3, 					// General
	2,	2.5, 				// Motorized
	3,	2, 					// Mechanised
	4,	(1.0 * _diff),	// Armoured
	5,	2.0, 				// Airborne
	6,	2.5, 				// Infantry
	7,	(1.0 * _diff),	// Helicopter
	8,	(0.5 * _diff),	// Aircraft
	9,	1					// Naval
];

// Overwrite QRF type if specified
private _forceType = missionNamespace getVariable ['ZMM_QRFType', -1];
if (_forceType >= 0) then { 
	_qrfType = _forceType;
	missionNamespace setVariable ['ZMM_QRFType', -1];
};

// Pick a suitable QRF from weights depending on side.
if (_qrfType < 0) then { 
	_qrfType = if (_side == independent) then { selectRandomWeighted _indQRF } else { selectRandomWeighted _opfQRF };
};

// If the value is invalid default it.
if (_qrfType >= count _qrfTypes) then { _qrfType = 0 };

// If set only create the trigger and exit.
if _triggerOnly exitWith {
	if ((missionNamespace getVariable [format['ZMM_%1_QRFTime', _zoneID], 600]) isEqualTo 0 || (missionNamespace getVariable [format['ZMM_%1_QRFWaves', _zoneID], 3]) isEqualTo 0)	exitWith {};
	
	_centre = missionNamespace getVariable [ format[ "ZMM_%1_Location", _zoneID ], [0,0,0]];
	_radius = (getMarkerSize format["MKR_Z%1_MAX", _zoneID]) select 0;
	_timeOut = (missionNamespace getVariable [format["ZMM_%1_QRFTime", _zoneID], 600]) / 2;
	_detectedTrg = createTrigger ["EmptyDetector", _centre, false];
	
	// No side defined, so active when players are near, otherwise allow stealth.
	if (missionNamespace getVariable [format["ZMM_%1_enemySide", _zoneID], CIVILIAN] isEqualTo CIVILIAN) then {
		_detectedTrg setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	} else {
		_detectedTrg setTriggerActivation ["ANYPLAYER", toUpper format["%1 D", (missionNamespace getVariable format["ZMM_%1_enemySide", _zoneID])], false];
	};
	
	_detectedTrg setTriggerTimeout [_timeOut, _timeOut, _timeOut, true];
	_detectedTrg setTriggerArea [_radius, _radius, 0, false];
	_detectedTrg setTriggerStatements ["this", format["
		[
			%1,
			false, 
			(missionNamespace getVariable ['ZMM_%1_QRFTime', %2]),
			(missionNamespace getVariable ['ZMM_%1_QRFWaves', %3]),
			%4,
			%5
		] spawn zmm_fnc_areaQRF; 
		deleteVehicle TR_%1_QRFSpawn;", _zoneID, _delay, _waveMax, _qrfType, _diff], ""];
	missionNamespace setVariable [format['TR_%1_QRFSpawn', _zoneID], _detectedTrg, true];
};

// Set Delay if incorrect.
if (_delay < 1) then {
	["DEBUG", format["Zone%1 - Delay was not set, defaulting to: %2", _zoneID, 300]] call zmm_fnc_misc_logMsg;
	_delay = 300;
};

// Set MaxWave if incorrect.
if (_waveMax < 3) then {  _waveMax = 3 };

missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 0];

private _destination = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
private _spawnDist = 1200;

// Vehicle pools
private _vehTruck = missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]];
private _vehLight = missionNamespace getVariable [format["ZMM_%1_Light",_side],[]];
private _vehMedium = missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]];
private _vehHeavy = missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]];
private _vehAirTransport =  missionNamespace getVariable [format["ZMM_%1_Air",_side],[]];
private _vehAirPlane = missionNamespace getVariable [format["ZMM_%1_CasP",_side], missionNamespace getVariable [format["ZMM_%1_Cas",_side],[]]];
private _vehAirHeli = missionNamespace getVariable [format["ZMM_%1_CasH",_side], missionNamespace getVariable [format["ZMM_%1_Cas",_side],[]]];
private _vehBoat = missionNamespace getVariable [format["ZMM_%1_Boat",_side],[]];
private _vehAirCas = _vehAirHeli + _vehAirPlane;

// Prebuild the defined waves
private _ZMMwaveInfo = [];

if (_qrfType > 0) then {
	private _unitCount = round linearConversion [8, 20, count (allPlayers select { alive _x }), 4, 12, true];
	private _qrfName = _qrfTypes select _qrfType;
	switch (_qrfName) do {
		case "Motorized": {
			_ZMMwaveInfo = [
				// Wave 1
				[
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 2
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 3
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 4
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 5
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["house", _unitCount],
					["house", _unitCount]
				]
			];
		};
		case "Mechanised": {
			_ZMMwaveInfo = [
				// Wave 1
				[
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 2
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 3
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 4
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]])],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 5
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]])],
					["house", _unitCount],
					["house", _unitCount]
				]
			];
		};
		case "Armoured": {
			_ZMMwaveInfo = [
				// Wave 1
				[
					["road", selectRandom (missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]])],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 2
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom (missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]])],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 3
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom (missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]])],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 4
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]))],
					["road", selectRandom (missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]])],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 5
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]))],
					["road", selectRandom (missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]])],
					["house", _unitCount]
				]
			];
		};
		case "Airborne": {
			_ZMMwaveInfo = [
				// Wave 1
				[
					[selectRandom ["air","drop"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]])],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 2
				[
					[selectRandom ["air","drop"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]])],
					[selectRandom ["air","drop"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]])],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 3
				[
					[selectRandom ["air","drop"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]])],
					[selectRandom ["air","drop"], selectRandom ((missionNamespace getVariable [format["ZMM_%1_Air",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_CasH",_side],[]]))],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				]
			];
		};
		case "Infantry": {
			_ZMMwaveInfo = [
				// Wave 1
				[
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 2
				[
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 3
				[
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 4
				[
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				]
			];
		};
		case "Helicopter": {
			_ZMMwaveInfo = [
				// Wave 1
				[
					[selectRandom ["air","drop"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]])],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 2
				[
					[selectRandom ["air","drop"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]])],
					[selectRandom ["air","drop"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]])],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 3
				[
					[selectRandom ["air","drop"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]])],
					[selectRandom ["air","drop"], selectRandom ((missionNamespace getVariable [format["ZMM_%1_Air",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_CasH",_side],[]]))],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 4
				[
					[selectRandom ["air","drop"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]])],
					[selectRandom ["air"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]])],
					[selectRandom ["air"], selectRandom ((missionNamespace getVariable [format["ZMM_%1_Air",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_CasH",_side],[]]))],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				]
			];
		};
		case "Aircraft": {
			_ZMMwaveInfo = [
				// Wave 1
				[
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 2
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 3
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					[selectRandom ["air"], selectRandom (missionNamespace getVariable [format["ZMM_%1_CasH",_side],[]])],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 4
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 5
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]))],
					["cas", selectRandom (missionNamespace getVariable [format["ZMM_%1_CasP",_side],[]])],
					["house", _unitCount]
				],
				// Wave 6
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]])],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]))],
					["house", _unitCount]
				]
			];
		};
		case "Naval": {
			_ZMMwaveInfo = [
				// Wave 1
				[
					[selectRandom ["sea"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Boat",_side],[]])],
					[selectRandom ["sea"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Boat",_side],[]])],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 2
				[
					[selectRandom ["sea"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Boat",_side],[]])],
					[selectRandom ["sea"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Boat",_side],[]])],
					[selectRandom ["air","drop"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]])],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 3
				[
					[selectRandom ["sea"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Boat",_side],[]])],
					[selectRandom ["sea"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Boat",_side],[]])],
					[selectRandom ["sea"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Boat",_side],[]])],
					[selectRandom ["air","drop"], selectRandom (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]])],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				]
			];
		};
		default {
			_ZMMwaveInfo = [
				// Wave 1
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 2
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 3
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 4
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]))],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount],
					[selectRandom ["land","house"], _unitCount]
				],
				// Wave 5
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]))],
					["house", _unitCount],
					["house", _unitCount],
					["house", _unitCount],
					["house", _unitCount]
				],
				// Wave 6
				[
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]))],
					["road", selectRandom ((missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]]) + (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]))],
					["house", _unitCount],
					["house", _unitCount],
					["house", _unitCount],
					["house", _unitCount]
				]
			];
		};
	};
};

// Main Code Start
private _instance = (missionNamespace getVariable ["ZQR_ZoneID", 0]) + 1;
private _difficulty = if !(isNil "_diff") then { _diff } else { missionNamespace getVariable ["ZZM_Diff", missionNamespace getVariable ["f_param_ZMMDiff", 1]] };

// ZMM Stealh Ops support
if !(isNil "_zoneID") then { _instance = _zoneID } else { ZQR_ZoneID = _instance };

missionNamespace setVariable [format["ZQR_%1_WaveMax", _instance], _waveMax * _difficulty];

// Convert passed destination
switch (typeName _destination) do {
	case "STRING": {_destination = getMarkerPos _destination};
	case "OBJECT": {_destination = getPos _destination};
};

// Basic Error Checking
if !(_destination isEqualType []) exitWith { ["ERROR", "Invalid Destination Object/Position"] call zmm_fnc_misc_logMsg };
if isNil "_side" exitWith { ["ERROR", "Variable Undefined: '_side'"] call zmm_fnc_misc_logMsg };
if (count (allGroups select { side _x == _side }) == 0) then { ["WARNING", format["No groups present for %1 - Wrong faction?", _side]] call zmm_fnc_misc_logMsg };
if (count (missionNamespace getVariable [format["ZMM_%1_Man",_side],[]]) == 0) then {
	if (count (missionNamespace getVariable [format["ZMM_%1Man",_side],[]]) > 0) exitWith { 
		missionNamespace setVariable [format["ZMM_%1_Man",_side], missionNamespace getVariable [format["ZMM_%1Man",_side],[]]]
	};
	["ERROR", format["No units in ZMM_%1_Man variable",_side]] call zmm_fnc_misc_logMsg 
};

// Position arrays
private _safePositions = [];
private _spawnAir = [];
private _spawnAirFar = [];
private _spawnHouse = [];
private _spawnLand = [];
private _spawnRoad = [];
private _spawnSea = [];

// Create safe-zones around spawn.
{
	if (_x in allMapMarkers) then {		
		_mkr = createMarkerLocal [format ["safezone_%1", _forEachIndex + 1000], getMarkerPos _x];
		_mkr setMarkerShapeLocal "ELLIPSE";
		_mkr setMarkerSizeLocal [1000,1000];
		_mkr setMarkerAlphaLocal 0.25;
	};
} forEach ["respawn_west","respawn_east","respawn_guerrila","respawn_civilian"];

{	
	if (["safezone_", toLower _x] call BIS_fnc_inString) then { _safePositions pushBackUnique _x; };
} forEach allMapMarkers;

// White list custom spawns - Change this marker if needed!
{	
	if (["qrf_", toLower _x] call BIS_fnc_inString) then { _spawnLand pushBackUnique getMarkerPos _x; };
} forEach allMapMarkers;

// Collect all roads 2km around the location that are not in a safe location.
for [{_i = 0}, {_i <= 360}, {_i = _i + 5}] do {
	private _posR = _destination getPos [_spawnDist, _i];
	_roads = (_posR nearRoads 50) select {((boundingBoxReal _x) select 0) distance2D ((boundingBoxReal _x) select 1) >= 25};
	
	if (count _roads > 0 && { _posR inArea _x } count _safePositions == 0) then {
		_road = _roads select 0;
		if ({_x distance2D _road < 200} count _spawnRoad == 0) then {
			_spawnRoad pushBackUnique (getPos _road);		
		};
	};
	
	// House Pos not in safe area and more than 200m away from another point	
	private _posH = _destination getPos [(_spawnDist * 0.3), _i];
	private _nearBuilds = nearestObjects [_posH, ["House"], 100];
	
	if (_nearBuilds isNotEqualTo []) then {
		private _nearBuild = _nearBuilds#0;
		if (_nearBuild distance2D _posH < 100 && { _posH inArea _x } count _safePositions == 0) then {
			private _bpos = _nearBuild buildingPos -1;		
			_bpos = _bpos select { !(surfaceIsWater _x) };
			if (count _bpos > 0) then {
				private _lowestPos = ([_bpos, [], { _x select 2 }, "ASCEND"] call BIS_fnc_sortBy) select 0;
				if ({_x distance2D _lowestPos < 100} count _spawnHouse == 0) then {
					_spawnHouse pushBackUnique _lowestPos;
				};
			};
		};
	};
	
	// Land Pos not in safe area and more than 400m away from another point	
	private _posL = _destination getPos [(_spawnDist * 0.5), _i];
	if (!surfaceIsWater _posL && { _posL inArea _x } count _safePositions == 0) then {
		if ({_x distance2D _posL < 400} count _spawnLand == 0) then {
			_posL set [2, 0.5];
			_spawnLand pushBackUnique _posL;
		};
	};
	
	// Water Pos not in safe area and more than 400m away from another point
	private _posS = _destination getPos [_spawnDist, _i];
	if (surfaceIsWater _posS && { _posS inArea _x } count _safePositions == 0) then {
		if ({_x distance2D _posS < 400} count _spawnSea == 0 && (0 - (getTerrainHeightASL _posS)) > 15) then {
			_posS set [2, (0 - (getTerrainHeightASL _posS))];
			_spawnSea pushBackUnique _posS;
		};
	};
	
	// Air Pos not in safe area and more than 800m away from another point
	private _posA = _destination getPos [(_spawnDist * 3), _i];
	if ({ _posA inArea _x } count _safePositions == 0) then {
		if ({_x distance2D _posA < 1500} count _spawnAir == 0) then {
			_posA set [2, 500];
			_spawnAir pushBackUnique _posA;
		};
	};
	
	// AirFar Pos not in safe area and more than 5000m away from another point
	private _posAF = _destination getPos [(_spawnDist * 5), _i];
	if ({ _posAF inArea _x } count _safePositions == 0) then {
		if ({_x distance2D _posAF < 5000} count _spawnAirFar == 0) then {
			_posAF set [2, 500];
			_spawnAirFar pushBackUnique _posAF;
		};
	};
};

private _hasLand = count _spawnLand > 1;
private _hasRoad = count _spawnRoad > 1;
private _hasSea = count _spawnSea > 0;
private _hasAir = count _spawnAir > 0;

// DEBUG: Show Spawn Markers in local
{
	_x params ["_posType", "_mkrName", "_mkrText", "_mkrColor"];
	{
		private _mrkr = createMarkerLocal [format [_mkrName, _forEachIndex], _x];
		_mrkr setMarkerPosLocal _x;
		_mrkr setMarkerTypeLocal "mil_dot";
		_mrkr setMarkerColorLocal _mkrColor;
		_mrkr setMarkerTextLocal format[_mkrText,_forEachIndex];
	} forEach _posType;
} forEach [
	[_spawnRoad, "mkr_qrf_road_%1", "R%1", "ColorYellow"]
	,[_spawnLand, "mkr_qrf_land_%1", "L%1", "ColorOrange"]
	,[_spawnHouse, "mkr_qrf_house_%1", "H%1", "ColorRed"]
	,[_spawnSea, "mkr_qrf_water_%1", "W%1", "ColorBlue"]
	,[_spawnAir, "mkr_qrf_air_%1", "A%1", "ColorWhite"]
	,[_spawnAirFar, "mkr_qrf_airf_%1", "F%1", "ColorGreen"]
];

// Correct if no houses are avaliable
if (count _spawnHouse == 0) then { _spawnHouse = _spawnLand };
if (count _spawnAir == 0) then { _spawnAir = _spawnAirFar };
if (count _spawnAirFar == 0) then { _spawnAirFar = _spawnAir };

[_side] call zmm_fnc_misc_checkConfig;

// Spawn waves.
for [{_wave = 1}, {_wave <= (missionNamespace getVariable [format["ZQR_%1_WaveMax", _instance], 3])}, {_wave = _wave + 1}] do {
	missionNamespace setVariable [format["ZQR_%1_Wave", _instance], _wave];
	
	// Stop spawns if no-one is nearby.
	if (({ _destination distance2D _x < (_spawnDist + 1000) } count (switchableUnits + playableUnits)) isEqualTo 0 && isMultiplayer) exitWith {
		["DEBUG", format["Wave %1 - Aborted - No players within %2 meters!", _wave, _spawnDist + 1000]] call zmm_fnc_misc_logMsg;
	};
	
	private _waveInfo = if (isNil "_ZMMwaveInfo") then { [] } else { _ZMMwaveInfo };
	if (
		_waveInfo isEqualTo [] || 
		count (missionNamespace getVariable ["ZQR_WaveDetail",[]]) == 0 ||
		count (missionNamespace getVariable [format["ZQR_%1_WaveDetail", _instance], []]) == 0
	) then {
		_waveInfo = [_wave, _side, _hasLand, _hasRoad, _hasSea, _hasAir, 10] call zmm_fnc_qrf_createWave;
	} else {
		// TODO Add support for: ZQR_%1_WaveDetail
		_waveInfo = ZQR_WaveDetail select ((_wave - 1) min (count ZQR_WaveDetail - 1));
	};
	
	// TODO CHECK FOR VALID POSITIONS AND DEFAULT INF IF NONE FOUND
	//["DEBUG", format["Starting Zone %1 - Wave %2/%3 - %4 %5", _instance, _wave, (missionNamespace getVariable [format["ZQR_%1_WaveMax", _instance], 3]), _side, _waveInfo]] call zmm_fnc_misc_logMsg;
	{
		_x params ["_location","_object"];
		
		if (_object isEqualType []) then { _object = selectRandom _object };
		
		["DEBUG", format["Zone %1 Wave %2/%3 - Spawning %4 (%5)", _instance, _wave, (missionNamespace getVariable [format["ZQR_%1_WaveMax", _instance], 3]), _object, _location]] call zmm_fnc_misc_logMsg;
	
		switch (toLower _location) do {
			case "air": { [_instance, _destination, _spawnAir, _side, _object, 1000] call zmm_fnc_qrf_spawnGroup };
			case "cas": { [_instance, _destination, _spawnAirFar, _side, _object, 1000] call zmm_fnc_qrf_spawnGroup };
			case "drop": { [_instance, _destination, _spawnAir, _side, _object] call zmm_fnc_qrf_spawnPara };
			case "house": { [_instance, _destination, _spawnHouse, _side, _object, 200] call zmm_fnc_qrf_spawnGroup };
			case "land": { [_instance, _destination, _spawnLand, _side, _object, 500] call zmm_fnc_qrf_spawnGroup };
			case "road": { [_instance, _destination, _spawnRoad, _side, _object, 500] call zmm_fnc_qrf_spawnGroup };
			case "sea": { [_instance, _destination, _spawnSea, _side, _object, 800] call zmm_fnc_qrf_spawnGroup };
			default { ["ERROR", format["Wave %1 - Invalid Spawn Location Type (%2)", _wave, _location]] call zmm_fnc_misc_logMsg };
		};
		
		sleep 5;
	} forEach _waveInfo;
	
	_tNextWave = time + _delay;	
	waitUntil {sleep 10; time > _tNextWave};
};