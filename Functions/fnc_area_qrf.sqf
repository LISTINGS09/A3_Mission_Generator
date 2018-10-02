if !isServer exitWith {};

params [
	["_zoneID", 0],
	["_triggerOnly", FALSE],
	["_delay", 600],
	["_maxWave", 4]
];

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
	_detectedTrg setTriggerStatements ["this", format["[%1, FALSE, (missionNamespace getVariable ['ZMM_%1_QRFTime', 600]), (missionNamespace getVariable ['ZMM_%1_QRFWaves', 3])] spawn zmm_fnc_areaQRF;", _zoneID], ""];
};

missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 0];

["DEBUG", format["QRF Timer Started - Zone %1 (%2s %3 Waves)", _zoneID, _delay, _maxWave]] call zmm_fnc_logMsg;

// TODO: Add custom QRFs per Location Type.
sleep (_delay / 4);

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_side = missionNamespace getVariable [format["ZMM_%1_enemySide", _zoneID], EAST];
_locations = missionNamespace getVariable [format["ZMM_%1_QRFLocations", _zoneID], []];

_sentry = missionNamespace getVariable [format["ZMM_%1Grp_Sentry",_side],[]];
_team = missionNamespace getVariable [format["ZMM_%1Grp_Team",_side],[]];
_squad = missionNamespace getVariable [format["ZMM_%1Grp_Squad",_side],[]];
_truck = missionNamespace getVariable [format["ZMM_%1Veh_Truck",_side],[]];
_light = missionNamespace getVariable [format["ZMM_%1Veh_Light",_side],[]];
_medium = missionNamespace getVariable [format["ZMM_%1Veh_Medium",_side],[]];
_heavy = missionNamespace getVariable [format["ZMM_%1Veh_Heavy",_side],[]];
_air = missionNamespace getVariable [format["ZMM_%1Veh_Air",_side],[]];
_cas = missionNamespace getVariable [format["ZMM_%1Veh_CAS",_side],[]];

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
		default {
			[_centre, _locations, _side, selectRandom (_light + _medium)] call zmm_fnc_spawnUnit;
			[_centre, _locations, _side, selectRandom (_medium + _heavy)] call zmm_fnc_spawnUnit;
			[_centre, _locations, _side, selectRandom (_cas + _air)] call zmm_fnc_spawnUnit;
		};
	};

	_tNextWave = time + _delay;	
	waitUntil {sleep 1; time > _tNextWave};
};