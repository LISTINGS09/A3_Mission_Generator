// Wait for Location Selection.
params [ ["_zoneID", 0], ["_locType", ""], ["_markerOverride", ""] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
private _side = missionNamespace getVariable [format["ZMM_%1_enemySide", _zoneID], EAST];

if (_locType isEqualTo "") then { _locType = type (nearestLocation [_centre,""]) };

private _mkrLg = format["MKR_Z%1_MAX", _zoneID];
private _mkrSm = format["MKR_Z%1_MIN", _zoneID];

// Overwrite the defaults if a marker was forced
if !(_markerOverride isEqualTo "") then { _mkrLg = _markerOverride; _mkrSm = _markerOverride; };

private _multiplier = missionNamespace getVariable ["ZZM_Diff", 1];
private _customInf = missionNamespace getVariable ["ZMM_CustomInfantry", -1];
private _customLight = missionNamespace getVariable ["ZMM_CustomLight", -1];
private _customMedium = missionNamespace getVariable ["ZMM_CustomMedium", -1];
private _customHeavy = missionNamespace getVariable ["ZMM_CustomHeavy", -1];

// Balancing Logic
private _difficulty = missionNamespace getVariable ["ZZM_Diff", 1];
private _players = (if isMultiplayer then { (count (allPlayers select { alive _x })) } else { 8 }) max 4;
private _gunners = (
		count (allPlayers select {
			alive _x &&
			vehicle _x != _x &&
			_x == gunner vehicle _x
		})
	) min 4;

private _effectivePlayers = (_players * (1 + (_gunners * 0.6))) * (0.75 + (_difficulty * 0.25));

private _locLevel = switch (_locType) do {
	case "Airport": { 12 };
	case "NameCityCapital": { 12 };
	case "NameCity": { 10 };
	case "NameVillage": { 8 };
	case "NameLocal": { 6 };
	case "Ambient": { 4 };
	default { 5 };
};

_locLevel = _locLevel * _difficulty;

missionNamespace setVariable [format["ZMM_%1_Level", _zoneID], _locLevel];

// Unit Counts
private _unitCount = round linearConversion [8, 30, _effectivePlayers, 2, 12, true];
	
// Group Counts
private _infantryFactor = switch (true) do { case (_locLevel < 3): { 0.75 }; case (_locLevel < 5): { 1.25 }; default { 2 }; };
private _infantryGroups = (round(((_effectivePlayers / 3) + 0.5) * _infantryFactor * _difficulty)) max 2 min 8;
private _lightGroups = (floor((_effectivePlayers / 10) * (_locLevel / 3) * _difficulty)) min 4;
private _mediumGroups = if (_locLevel >= 3) then { floor((_effectivePlayers / 12) * ((_locLevel - 2) / 3) * _difficulty) min 3 } else { 0 };
private _heavyGroups = if (_locLevel >= 5) then { floor((_effectivePlayers / 14) * ((_locLevel - 4) / 4) * _difficulty) min 2 } else { 0 };

//private _lightGroups = floor linearConversion [ 8, 70, _effectivePlayers, 0, 4, true ];
//private _mediumGroups = floor linearConversion [ 20, 70, _effectivePlayers, 0, 3, true ];
//private _heavyGroups = floor linearConversion [ 35, 70, _effectivePlayers, 0, 2, true ];

// Small chance for 1 light vehicle in low intensity zones
if (_lightGroups == 0 && { random 1 < (_effectivePlayers / 100) }) then { _lightGroups = 1 };

// Spawn vehicle on a road.
private _roads = (_centre nearRoads ((getMarkerSize _mkrSm select 0) max 300)) select { count (roadsConnectedTo _x) > 0};
private _spawnArr = if (count _roads > 0) then { _roads apply { position _x } } else { [_centre] };
private _lastPos = [];

["DEBUG", format["Zone%1 - Area Patrols (%2 level: %8):%3%4%5%6%7", 
	_zoneID,
	_locType,
	if (_infantryGroups > 0) then { " I:" + str _infantryGroups + " (" + str _unitCount + ")" } else { "" },
	if (_lightGroups > 0) then { " L:" + str _lightGroups } else { "" },
	if (_mediumGroups > 0) then { " M:" + str _mediumGroups } else { "" },
	if (_heavyGroups > 0) then { " H:" + str _heavyGroups } else { "" },
	if (([_customInf,_customLight,_customMedium,_customHeavy] findIf { _x >= 0 }) >= 0) then { " [CUSTOM]" } else { " [DEFAULT]" },
	_locLevel
	]
] call zmm_fnc_misc_logMsg;

for "_i" from 1 to (if (_customInf >= 0) then { _customInf } else { _infantryGroups }) do {
	[_zoneID, _centre, _spawnArr, _side, _unitCount, 200, 0, _mkrSm] call zmm_fnc_qrf_spawnGroup;
};

for "_i" from 1 to (if (_customLight >= 0) then { _customLight } else { _lightGroups }) do {
	[_zoneID, _centre, _spawnArr, _side, selectRandom (missionNamespace getVariable [format["ZMM_%1_Light",_side], []]), 300, 0, selectRandom [_mkrLg,_mkrSm]] call zmm_fnc_qrf_spawnGroup;
};

for "_i" from 1 to (if (_customMedium >= 0) then { _customMedium } else { _mediumGroups }) do {
	[_zoneID, _centre, _spawnArr, _side, selectRandom (missionNamespace getVariable [format["ZMM_%1_Medium",_side], []]), 300, 0, selectRandom [_mkrLg,_mkrSm]] call zmm_fnc_qrf_spawnGroup;
};

for "_i" from 1 to (if (_customHeavy >= 0) then { _customHeavy } else { _heavyGroups }) do {
	[_zoneID, _centre, _spawnArr, _side, selectRandom (missionNamespace getVariable [format["ZMM_%1_Heavy",_side], []]), 400, 0, selectRandom [_mkrLg,_mkrSm]] call zmm_fnc_qrf_spawnGroup;
};

missionNamespace setVariable [format[ "ZMM_%1_PatrolsEnabled", _zoneID], false];

true