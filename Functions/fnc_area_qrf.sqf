if !isServer exitWith {};
// [99, false, 30, nil, 7] spawn ZMM_fnc_areaQRF;
params [
	["_zoneID", 0],
	["_triggerOnly", false],
	["_delay", 300],
	["_maxWave", 10],
	["_qrfType", -1],
	["_diff",-1]
];

private _side = missionNamespace getVariable [format["ZMM_%1_enemySide", _zoneID], EAST];

//_randomWeightedElement = ;
private _qrfTypes = [
	"Reserve",
	"Motorized",
	"Mechanised",
	"Armoured",
	"Airborne",
	"Infantry",
	"Helicopter",
	"Aircraft"
];

// INDEP QRF Weighting
private _indQRF = [
	0,	3.5, 				// General
	1,	3.0, 				// Motorized
	2,	1.5, 				// Mechanised
	3,	(0.25 * ZZM_Diff), 	// Armoured
	4,	0.5, 				// Airborne
	5,	4.0, 				// Infantry
	6,	(0.5 * ZZM_Diff), 	// Helicopter
	7,	(0.25 * ZZM_Diff)	// Aircraft
];

// OPFOR QRF Weighting
private _opfQRF = [
	0,	3, 					// General
	1,	2.5, 				// Motorized
	2,	2, 					// Mechanised
	3,	(1.0 * ZZM_Diff),	// Armoured
	4,	2.0, 				// Airborne
	5,	2.5, 				// Infantry
	6,	(1.0 * ZZM_Diff),	// Helicopter
	7,	(0.5 * ZZM_Diff)	// Aircraft
];

// Overwrite QRF type if specified
private _forceType = missionNamespace getVariable ['ZMM_QRFType', -1];
if !(_forceType < 0) then { _qrfType = _forceType };

// Pick a suitable QRF from weights depending on side.
if (_qrfType < 0) then { 
	_qrfType = if (_side == independent) then { selectRandomWeighted _indQRF } else { selectRandomWeighted _opfQRF };
};

// If the value is invalid default it.
if (_qrfType >= count _qrfTypes) then { _qrfType = 0 };

missionNamespace setVariable [ format[ "ZMM_%1_QRFTYPE", _zoneID ], _qrfType, true];

// If set only create the trigger and exit.
if _triggerOnly exitWith {
	if ((missionNamespace getVariable [format['ZMM_%1_QRFTime', _zoneID], 600]) isEqualTo 0 || (missionNamespace getVariable [format['ZMM_%1_QRFWaves', _zoneID], 3]) isEqualTo 0)	exitWith {};
	
	_centre = missionNamespace getVariable [ format[ "ZMM_%1_Location", _zoneID ], [0,0,0]];
	_radius = (getMarkerSize format["MKR_%1_MAX", _zoneID]) select 0;
	_timeOut = (missionNamespace getVariable ['ZMM_%1_QRFTime', 600]) / 2;

	_detectedTrg = createTrigger ["EmptyDetector", _centre, false];
	
	// No side defined, so active when players are near, otherwise allow stealth.
	if (missionNamespace getVariable [format["ZMM_%1_enemySide", _zoneID], CIVILIAN] isEqualTo CIVILIAN) then {
		_detectedTrg setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	} else {
		_detectedTrg setTriggerActivation ["ANYPLAYER", toUpper format["%1 D", (missionNamespace getVariable format["ZMM_%1_enemySide", _zoneID])], false];
	};
	
	_detectedTrg setTriggerTimeout [_timeOut, _timeOut, _timeOut, true];
	_detectedTrg setTriggerArea [_radius, _radius, 0, false];
	_detectedTrg setTriggerStatements ["this", format["[%1, false, (missionNamespace getVariable ['ZMM_%1_QRFTime', %2]), (missionNamespace getVariable ['ZMM_%1_QRFWaves', %3]), %4, %5] spawn zmm_fnc_areaQRF; deleteVehicle TR_%1_QRFSpawn;", _zoneID, _delay, _maxWave, _qrfType, _diff], ""];
	missionNamespace setVariable [format['TR_%1_QRFSpawn', _zoneID], _detectedTrg, true];
	[_detectedTrg, format['TR_%1_QRFSpawn', _zoneID]] remoteExec ["setVehicleVarName", 0, _detectedTrg];
};

// Set Delay if incorrect.
if (_delay < 1) then {
	["DEBUG", format["Zone%1 - Delay was not set, defaulting to: %2", _zoneID, 300]] call zmm_fnc_logMsg;
	_delay = 300;
};

// Set MaxWave if incorrect.
if (_maxWave < 1) then {  _maxWave = 3 };

missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 0];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
private _locations = missionNamespace getVariable [format["ZMM_%1_QRFLocations", _zoneID], []];

// If the value is invalid default it.
if (_qrfType >= count _qrfTypes) then { _qrfType = 0 };

private _truck = missionNamespace getVariable [format["ZMM_%1Veh_Truck",_side],[]];
private _light = missionNamespace getVariable [format["ZMM_%1Veh_Light",_side],[]];
private _medium = missionNamespace getVariable [format["ZMM_%1Veh_Medium",_side],[]];
private _heavy = missionNamespace getVariable [format["ZMM_%1Veh_Heavy",_side],[]];
private _air = missionNamespace getVariable [format["ZMM_%1Veh_Air",_side],[]];
private _casH = missionNamespace getVariable [format["ZMM_%1Veh_CasH",_side], (missionNamespace getVariable [format["ZMM_%1Veh_Cas",_side],[]])];
private _casP = missionNamespace getVariable [format["ZMM_%1Veh_CasP",_side], (missionNamespace getVariable [format["ZMM_%1Veh_Cas",_side],[]])];

["DEBUG", format["Zone%1 - Area QRF - Starting - T:%2 D:%3 W:%4", _zoneID, _qrfTypes select _qrfType, _diff, _maxWave]] call zmm_fnc_logMsg;

/*if ((missionNamespace getVariable ["ZZM_Mode",1]) != 1 && isNil "ZMM_Announced") then {
	[selectRandom ["HQ","UAV","Recon"], format["%1 enemy %2 forces are %3.", selectRandom ["Warning,","Caution,","Be advised,","Be aware,"], _qrfTypes select _qrfType, selectRandom ["inbound","en-route","responding","closing in"]]] remoteExec ["BIS_fnc_showSubtitle"];
	ZMM_Announced = true;
};*/

sleep (_delay / 4);

// MAIN
// Spawn waves.
for [{_wave = 1}, {_wave <= _maxWave}, {_wave = _wave + 1}] do {
	["DEBUG", format["Zone%1 - Area QRF - Spawning #%2", _zoneID, _wave]] call zmm_fnc_logMsg;
	
	if (({ _centre distance2D _x < 1000 } count (switchableUnits + playableUnits)) isEqualTo 0) exitWith {
		["DEBUG", format["Zone%1 - Stopping QRF: No players nearby", _zoneID]] call zmm_fnc_logMsg;
	};
	
	switch (_qrfType) do {
		// Motorised
		case 1: {
			switch (_diff) do {
				// Easy
				case 0: {
					switch (_wave) do {
						case 1: {
							[_centre, _locations, _side, selectRandom _truck] spawn zmm_fnc_spawnUnit;
						};
						case 2;
						case 3;
						case 4: {
							[_centre, _locations, _side, selectRandom _truck] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _truck] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, _locations, _side, selectRandom _truck] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _truck] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _light] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				// Hard
				case 2: {
					switch (_wave) do {
						default {
							[_centre, _locations, _side, selectRandom _light] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _light] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _truck] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				default {
					switch (_wave) do {
						case 1: {
							[_centre, _locations, _side, selectRandom _light] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _truck] spawn zmm_fnc_spawnUnit;
						};
						case 2;
						case 3;
						case 4: {
							[_centre, _locations, _side, selectRandom _light] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _truck] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _truck] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, _locations, _side, selectRandom _light] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _truck] spawn zmm_fnc_spawnUnit;
						};
					};
				};
			};
		};
		
		// Mechanised
		case 2: {
			switch (_diff) do {
				// Easy
				case 0: {
					switch (_wave) do {
						default {
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				// Hard
				case 2: {
					switch (_wave) do {
						default {
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				default {
					switch (_wave) do {
						case 1: {
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
						};
						case 2: {
							[_centre, _locations, _side, selectRandom _light] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
						};
						case 3;
						case 4: {
							[_centre, _locations, _side, selectRandom _light] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, _locations, _side, selectRandom _light] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
						};

					};
				};
			};
			switch (_wave) do {
			};
		};
		
		// Armoured
		case 3: {
			switch (_diff) do {
				// Easy
				case 0: {
					switch (_wave) do {
						case 1: {
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
						};
						case 2;
						case 3;
						case 4: {
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				// Hard
				case 2: {
					switch (_wave) do {
						default {
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				default {
					switch (_wave) do {
						case 1: {
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
						};
						case 2: {
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
						};
						case 3;
						case 4: {
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _heavy] spawn zmm_fnc_spawnUnit;
						};
					};
				};
			};
		};
		
		// Airborne
		case 4: {
			switch (_diff) do {
				// Easy
				case 0: {
					switch (_wave) do {
						case 1;
						case 2: {
							[_centre, _side] call zmm_fnc_spawnPara;
						};
						case 3: {
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
						};
						case 4: {
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				// Hard
				case 2: {
					switch (_wave) do {
						case 1;
						case 2: {
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom (_casH + _casP)] spawn zmm_fnc_spawnUnit;
						};
						case 3: {
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _casH] spawn zmm_fnc_spawnUnit;
						};
						case 4: {
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _locations, _side, selectRandom (_casH + _casP)] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				default {
					switch (_wave) do {
						case 1;
						case 2: {
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
							[_centre, _side] call zmm_fnc_spawnPara;
						};
						case 3: {
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _casH] spawn zmm_fnc_spawnUnit;
						};
						case 4: {
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _locations, _side, selectRandom (_casH + _casP)] spawn zmm_fnc_spawnUnit;
						};
					};
				};
			};
		};	
		
		// Infantry
		case 5: {
			switch (_diff) do {
				// Easy
				case 0: {
					switch (_wave) do {
						case 1: {
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 4] spawn zmm_fnc_spawnUnit;
						};
						case 2;
						case 3: {
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 4] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 4] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 4] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 4] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 4] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				// Hard
				case 2: {
					switch (_wave) do {
						case 1: {
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
						};
						case 2;
						case 3: {
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				default {
					switch (_wave) do {
						case 1: {
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 4] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 4] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 4] spawn zmm_fnc_spawnUnit;
						};
						case 2;
						case 3: {
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 4] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 4] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
						};
					};
				};
			};
		};
		
		// Helicopter
		case 6: {
			switch (_diff) do {
				// Easy
				case 0: {
					switch (_wave) do {
						case 3;
						case 4: {
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, _side] call zmm_fnc_spawnPara;
						};
					};
				};
				// Hard
				case 2: {
					switch (_wave) do {
						default {
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _locations, _side, selectRandom (_air + _casH)] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				default {
					switch (_wave) do {
						case 1;
						case 2;
						case 3: {
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
						};
						case 4: {
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, _side] call zmm_fnc_spawnPara;
							[_centre, _locations, _side, selectRandom _casH] spawn zmm_fnc_spawnUnit;
						};
					};
				};
			};
		};	
		
		// Aircraft
		case 7: {
			switch (_diff) do {
				// Easy
				case 0: {
					switch (_wave) do {
						case 3: {
							[_centre, _locations, _side, selectRandom _casP] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				// Hard
				case 2: {
					switch (_wave) do {
						case 1;
						case 3: {
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, _locations, _side, selectRandom _casP] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _casP] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				default {
					switch (_wave) do {
						case 2: {
							[_centre, _locations, _side, selectRandom _casP] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _casP] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
							[_centre, [(_centre getPos [600, random 360]),(_centre getPos [600, random 360]),(_centre getPos [600, random 360])], _side, 8] spawn zmm_fnc_spawnUnit;
						};
					};
				};
			};
		};	
		
		// Reserve Forces
		default {
			switch (_diff) do {
				// Easy
				case 0: {
					switch (_wave) do {
						case 1: {
							[_centre, _side] call zmm_fnc_spawnPara;
						};
						case 2: {
							[_centre, _locations, _side, selectRandom (_light + _truck)] spawn zmm_fnc_spawnUnit;
						};
						case 3;
						case 4: {
							[_centre, _locations, _side, selectRandom (_light + _truck)] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, _locations, _side, selectRandom (_light + _medium)] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				// Hard
				case 2: {
					switch (_wave) do {
						case 1: {
							[_centre, _locations, _side, selectRandom (_light + _truck)] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _casH] spawn zmm_fnc_spawnUnit;
						};
						case 2: {
							[_centre, _locations, _side, selectRandom (_light + _medium)] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom (_light + _medium)] spawn zmm_fnc_spawnUnit;
							[_centre, _side] call zmm_fnc_spawnPara;
						};
						case 3;
						case 4: {
							[_centre, _locations, _side, selectRandom (_medium + _heavy)] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom (_medium + _heavy)] spawn zmm_fnc_spawnUnit;
							[_centre, _side] call zmm_fnc_spawnPara;
						};
						default {
							[_centre, _locations, _side, selectRandom (_medium + _heavy)] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom (_medium + _heavy)] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _air] spawn zmm_fnc_spawnUnit;
						};
					};
				};
				default {
					switch (_wave) do {
						case 1: {
							[_centre, _locations, _side, selectRandom (_light + _truck)] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _light] spawn zmm_fnc_spawnUnit;
						};
						case 2: {
							[_centre, _locations, _side, selectRandom (_light + _truck)] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom (_light + _medium)] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom _medium] spawn zmm_fnc_spawnUnit;
							[_centre, _side] call zmm_fnc_spawnPara;
						};
						case 3;
						case 4: {
							[_centre, _locations, _side, selectRandom (_light + _medium)] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom (_medium + _heavy)] spawn zmm_fnc_spawnUnit;
						};
						default {
							[_centre, _locations, _side, selectRandom (_light + _medium)] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom (_medium + _heavy)] spawn zmm_fnc_spawnUnit;
							[_centre, _locations, _side, selectRandom (_casH + _air)] spawn zmm_fnc_spawnUnit;
						};
					};
				};
			};
		};
	};

	private _tNextWave = time + _delay + (random (_delay / 2));	
	waitUntil {sleep 1; time > _tNextWave};
};