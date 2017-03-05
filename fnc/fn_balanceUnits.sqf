params [["_number", 1, [1]], ["_typeOfUnit", "light", [""]], ["_missionType", (tg_missionTypes select 0), [""]]];

private _before = _number;

// Always reduce number for non-main missions.
if (_missionType != tg_missionTypes select 0) then {
	_number = _number * 0.5;
};

private _return = _number;

// Get the number of current players.
private _playerCount = count (playableUnits + switchableUnits);

if (missionNamespace getVariable["f_param_hardMode",0] == 1) then {
	_playerCount = 20; // For testing limits.
};

// Cap off, as we don't want 100+ units per objective.
if (_playerCount > 20) then { _playerCount = 20; };

// Identify the type of unit to balance and determine the value.
switch (toLower _typeOfUnit) do {
	case "light": { 
		_return = round random [0, (_number * 0.5) + (_playerCount * 0.2), 0];
	};
	case "medium": { 
		_return = round random [0, (_number * 0.5) + (_playerCount * 0.1), 0];
	};
	case "heavy": { 
		_return = floor random [0, (_number * 0.5) + (_playerCount * 0.05), 0];
	};
};

//[format["[TG] DEBUG balanceUnit: %1 (%2 to %3)", _typeOfUnit, _before, _return]] call tg_fnc_debugMsg;

_return