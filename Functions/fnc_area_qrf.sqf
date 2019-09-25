if !isServer exitWith {};

params [
	["_zoneID", 0],
	["_triggerOnly", FALSE],
	["_delay", 300],
	["_maxWave", 6],
	["_locType", ""]
];

// TODO: Implement _locType

// If set only create the trigger and exit.
if _triggerOnly exitWith {
	if ((missionNamespace getVariable [format['ZMM_%1_QRFTime', _zoneID], 600]) isEqualTo 0 || (missionNamespace getVariable [format['ZMM_%1_QRFWaves', _zoneID], 3]) isEqualTo 0)	exitWith {};
	
	_centre = missionNamespace getVariable [ format[ "ZMM_%1_Location", _zoneID ], [0,0,0]];
	_radius = (getMarkerSize format["MKR_%1_MAX", _zoneID]) select 0;
	_timeOut = (missionNamespace getVariable ['ZMM_%1_QRFTime', 600]) / 2;

	_detectedTrg = createTrigger ["EmptyDetector", _centre, FALSE];
	_detectedTrg setTriggerActivation ["ANYPLAYER", "PRESENT", FALSE];
	_detectedTrg setTriggerTimeout [_timeOut, _timeOut, _timeOut, TRUE];
	_detectedTrg setTriggerArea [_radius, _radius, 0, FALSE];
	_detectedTrg setTriggerStatements ["this", format["[%1, FALSE, (missionNamespace getVariable ['ZMM_%1_QRFTime', 600]), (missionNamespace getVariable ['ZMM_%1_QRFWaves', 3])] spawn zmm_fnc_areaQRF;", _zoneID, _locType], ""];
};

missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 0];

// TODO: Add custom QRFs per Location Type.
sleep (_delay / 4);

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
private _side = missionNamespace getVariable [format["ZMM_%1_enemySide", _zoneID], EAST];
private _locations = missionNamespace getVariable [format["ZMM_%1_QRFLocations", _zoneID], []];

private _sentry = missionNamespace getVariable [format["ZMM_%1Grp_Sentry",_side],[]];
private _team = missionNamespace getVariable [format["ZMM_%1Grp_Team",_side],[]];
private _squad = missionNamespace getVariable [format["ZMM_%1Grp_Squad",_side],[]];
private _truck = missionNamespace getVariable [format["ZMM_%1Veh_Truck",_side],[]];
private _light = missionNamespace getVariable [format["ZMM_%1Veh_Light",_side],[]];
private _medium = missionNamespace getVariable [format["ZMM_%1Veh_Medium",_side],[]];
private _heavy = missionNamespace getVariable [format["ZMM_%1Veh_Heavy",_side],[]];
private _air = missionNamespace getVariable [format["ZMM_%1Veh_AirH",_side],[]];
private _casH = missionNamespace getVariable [format["ZMM_%1Veh_CasH",_side], (missionNamespace getVariable [format["ZMM_%1Veh_Cas",_side],[]])];
private _casP = missionNamespace getVariable [format["ZMM_%1Veh_CasP",_side], (missionNamespace getVariable [format["ZMM_%1Veh_Cas",_side],[]])];

if (count _locations isEqualTo 0) exitWith {};

//if (_locType isEqualTo "") then { _locType = type (nearestLocation [_centre,""]) };

// MAIN
// Spawn waves.
for [{_wave = 1}, {_wave <= _maxWave}, {_wave = _wave + 1}] do {
	["DEBUG", format["QRF%1 Wave %2 Spawning", _zoneID, _wave]] call zmm_fnc_logMsg;
	
	if (({ _centre distance2D _x < 1000 } count (switchableUnits + playableUnits)) isEqualTo 0) exitWith {
		["DEBUG", format["QRF%1 Aborted - No players nearby", _zoneID]] call zmm_fnc_logMsg;
	};
	
	switch (_wave) do {
		case 1: {
			[_centre, _locations, _side, selectRandom (_light + _truck)] call zmm_fnc_spawnUnit;
			[_centre, _locations, _side, selectRandom (_light + _air)] call zmm_fnc_spawnUnit;
		};
		case 2: {
			[_centre, _locations, _side, selectRandom (_light + _truck)] call zmm_fnc_spawnUnit;
			[_centre, _locations, _side, selectRandom (_light + _medium)] call zmm_fnc_spawnUnit;
			[_centre, _locations, _side, selectRandom (_medium + _air)] call zmm_fnc_spawnUnit;
		};
		case 3: {
			[_centre, _locations, _side, selectRandom (_light + _medium)] call zmm_fnc_spawnUnit;
			[_centre, _locations, _side, selectRandom (_medium + _heavy)] call zmm_fnc_spawnUnit;
		};
		default {
			[_centre, _locations, _side, selectRandom (_light + _medium)] call zmm_fnc_spawnUnit;
			[_centre, _locations, _side, selectRandom (_medium + _heavy)] call zmm_fnc_spawnUnit;
			[_centre, _locations, _side, selectRandom (_casH + _air)] call zmm_fnc_spawnUnit;
		};
	};

	private _tNextWave = time + _delay;	
	waitUntil {sleep 1; time > _tNextWave};
};