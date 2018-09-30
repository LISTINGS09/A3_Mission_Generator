if !isServer exitWith {};

params [
	["_zoneID", 0],
	["_delay", 600],
	["_maxWave", 4],
	["_locType", ""]
];

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

if (count _locations isEqualTo 0) exitWith {};

// MAIN
// Spawn waves.
for [{_wave = 1}, {_wave <= _maxWave}, {_wave = _wave + 1}] do {
	["DEBUG", format["QRF%1 Wave %2 Spawning", _zoneID, _wave]] call zmm_fnc_logMsg;
	
	if (({ _centre distance2D _x < 1500 } count (switchableUnits + playableUnits)) isEqualTo 0) exitWith {
		["DEBUG", format["QRF%1 Aborted - No players nearby", _zoneID]] call zmm_fnc_logMsg;
	};
	
	switch (_wave) do {
		case 1: {
			[_centre, _locations, _side, selectRandom [_light, _truck]] call zmm_fnc_spawnUnit;
			[_centre, _locations, _side, selectRandom [_light, _air]] call zmm_fnc_spawnUnit;
		};
		case 2: {
			[_centre, _locations, _side, selectRandom [_light, _truck]] call zmm_fnc_spawnUnit;
			[_centre, _locations, _side, selectRandom [_light, _medium]] call zmm_fnc_spawnUnit;
			[_centre, _locations, _side, selectRandom [_medium, _air]] call zmm_fnc_spawnUnit;
		};
		default {
			[_centre, _locations, _side, selectRandom [_light, _medium]] call zmm_fnc_spawnUnit;
			[_centre, _locations, _side, selectRandom [_medium, _heavy]] call zmm_fnc_spawnUnit;
			[_centre, _locations, _side, selectRandom [_cas, _air]] call zmm_fnc_spawnUnit;
		};
	};

	_tNextWave = time + _delay;	
	waitUntil {sleep 1; time > _tNextWave};
};