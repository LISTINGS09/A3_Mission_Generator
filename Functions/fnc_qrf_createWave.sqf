// zmm_fnc_qrf_createWave
params [
	["_wave", 1]
	,["_side", EAST]
	,["_hasLand", true]
	,["_hasRoad", true]
	,["_hasSea", false]
	,["_hasAir", true]
	,["_difficulty", missionNamespace getVariable ["ZZM_Diff", missionNamespace getVariable ["f_param_ZMMDiff", 1]]]
];

private _waveInfo = [];
private _players = (if isMultiplayer then { (count (allPlayers select { alive _x })) } else { 8 }) max 4;
private _gunners = (
	count (allPlayers select {
		alive _x &&
		vehicle _x != _x &&
		_x == gunner vehicle _x
	})
) min 4;
private _effectivePlayers = (_players * (1 + (_gunners * 0.6))) * (0.75 + (_difficulty * 0.25));

["INFO", format["W%1 - qrf_createWave - PLRS:%2 EFCT:%3 - LAND:%4 ROAD:%5 SEA:%6 AIR:%7", _wave, _players, _effectivePlayers, _hasLand, _hasRoad, _hasSea, _hasAir]] call zmm_fnc_misc_logMsg;

// Vehicle pools
private _vehTruck = missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]];
private _vehLight = missionNamespace getVariable [format["ZMM_%1_Light",_side],[]];
private _vehMedium = missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]];
private _vehHeavy = missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]];
private _vehUtil = missionNamespace getVariable [format["ZMM_%1_Util",_side],[]];
private _vehStatic = missionNamespace getVariable [format["ZMM_%1_Static",_side],[]];
private _vehAirTransport =  missionNamespace getVariable [format["ZMM_%1_Air",_side],[]];
private _vehAirPlane = missionNamespace getVariable [format["ZMM_%1_CasP",_side], missionNamespace getVariable [format["ZMM_%1_Cas",_side],[]]];
private _vehAirHeli = missionNamespace getVariable [format["ZMM_%1_CasH",_side], missionNamespace getVariable [format["ZMM_%1_Cas",_side],[]]];
private _vehBoat = missionNamespace getVariable [format["ZMM_%1_Boat",_side],[]];
private _vehAirCas = _vehAirHeli + _vehAirPlane;

// Unit Counts
private _unitFactor = switch (true) do { case (_wave < 4): { 1 }; case (_wave < 6): { 1 + ((_wave - 3) * 0.5) }; default { 3 }; };
private _unitCount = (
		round (
			4 * _unitFactor *
			(0.75 + (_difficulty * 0.25)) *
			(1 + ((_players - 4) * 0.03 max 0))
		)
	) min 12 max 3;

// Group Counts
private _infantryFactor = switch (true) do { case (_wave < 3): { 0.75 }; case (_wave < 5): { 1.25 }; default { 2 }; };
private _infantryGroups = (round((_effectivePlayers / 3) * _infantryFactor * _difficulty)) max 1 min 6;
private _lightVehGroups = (floor((_effectivePlayers / 10) * (_wave / 3) * _difficulty)) min 4;
private _mediumVehGroups = if (_wave >= 3) then { floor((_effectivePlayers / 12) * ((_wave - 2) / 3) * _difficulty) min 3 } else { 0 };
private _heavyVehGroups = if (_wave >= 5) then { floor((_effectivePlayers / 14) * ((_wave - 4) / 4) * _difficulty) min 2 } else { 0 };
private _planeVehGroups = 0;

if (_wave >= 3) then {
	// Much rarer aircraft scaling
	private _planeChance = (0.01 * _wave * _difficulty) min 0.25;
	if ((random 1) < _planeChance) then { 
		_planeVehGroups = 1;
		if (_wave >= 5 && _difficulty >= 1.5 && (random 1) < 0.2) then {
			_planeVehGroups = 2;
		};
	};
};

// Work out what the default should be
private _fnc_defaultType = {
	switch (true) do {
		case (_hasLand): { [selectRandom ["house","land"], _unitCount] };
		case (_hasSea): { ["sea", selectRandom _vehBoat] };
		default { ["air", selectRandom _vehAirTransport] };
	};
};

private _chanceHigh = random 1 < (((((_wave min 6) - 1) / (6 - 1)) * 0.5) min 0.5);
private _chanceLow = random 1 < (((((_wave min 6) - 1) / (6 - 1)) * 0.2) min 0.2);

if (_infantryGroups > 0) then {
	for "_i" from 1 to _infantryGroups do {
		switch (true) do {
			case (_chanceHigh && _hasRoad && {count _vehTruck > 0} ): {
				_waveInfo pushBack ["road", selectRandom _vehTruck];
			};
			case (_chanceHigh && _hasSea && {count _vehBoat > 0} ): {
				_waveInfo pushBack ["sea", selectRandom _vehBoat];
			};
			case (_chanceLow && _hasAir && {count _vehAirTransport > 0}): {
				_waveInfo pushBack [ selectRandom ["air", "drop"], selectRandom _vehAirTransport];
			};
			default {
				_waveInfo pushBack call _fnc_defaultType;
			};
		};
	};
};

if (_lightVehGroups > 0) then {
	for "_i" from 1 to _lightVehGroups do {
		switch (true) do {
			case (_chanceHigh && _hasRoad && {count _vehTruck > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehTruck];
			};
			case (_hasRoad && {count _vehLight > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehLight];
			};
			case (_hasSea && {count _vehBoat > 0}): {
				_waveInfo pushBack ["sea", selectRandom _vehBoat];
			};
			default {
				_waveInfo pushBack call _fnc_defaultType;
			};
		};
	};
};

if (_mediumVehGroups > 0) then {
	for "_i" from 1 to _mediumVehGroups do {
		switch (true) do {
			case (_chanceLow && _hasAir && {count _vehAirTransport > 0}): {
				_waveInfo pushBack [ selectRandom ["air", "drop"], selectRandom _vehAirTransport];
			};
			case (_hasRoad && {count _vehMedium > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehMedium];
			};
			case (_hasRoad && {count _vehLight > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehLight];
			};
			case (_hasSea && {count _vehBoat > 0}): {
				_waveInfo pushBack ["sea", selectRandom _vehBoat];
			};
			default {
				_waveInfo pushBack call _fnc_defaultType;
			};
		};
	};
};

if (_heavyVehGroups > 0) then {
	for "_i" from 1 to _heavyVehGroups do {
		// 20% chance to replace with airdrop
		switch (true) do {
			case (_chanceLow && _hasAir && {count _vehAirTransport > 0}): {
				_waveInfo pushBack [ selectRandom ["air", "drop"], selectRandom _vehAirTransport];
			};
			case (_hasRoad && {count _vehHeavy > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehHeavy];
			};
			case (_hasRoad && {count _vehMedium > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehMedium];
			};
			case (_hasRoad && {count _vehLight > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehLight];
			};
			case (_hasSea && {count _vehBoat > 0}): {
				_waveInfo pushBack ["sea", selectRandom _vehBoat];
			};
			case (_hasAir && {count _vehAirTransport > 0}): {
				_waveInfo pushBack [ selectRandom ["air", "drop"], selectRandom _vehAirTransport];
			};
			default {
				_waveInfo pushBack call _fnc_defaultType;
			};
		};
	};
};

if (_planeVehGroups > 0 && {count _vehAirCas > 0}) then {
	for "_i" from 1 to _planeVehGroups do {
		_waveInfo pushBack ["cas", selectRandom _vehAirCas];
		// TODO IF THIS HAS FREE SEATS MAKE IT PARADROP
	};
};

["INFO", format["W%1 - qrf_createWave - INF:%2 LGT:%3 MED:%4 HVY:%5 AIR:%6", _wave, _infantryGroups, _lightVehGroups, _mediumVehGroups, _heavyVehGroups, _planeVehGroups]] call zmm_fnc_misc_logMsg;

_waveInfo
