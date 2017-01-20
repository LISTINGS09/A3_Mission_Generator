params [["_number", 1, [1]], ["_typeOfUnit", "light", [""]], ["_missionType", (tg_missionTypes select 0), [""]]];

// Always reduce number for non-main missions.
if (_missionType != tg_missionTypes select 0) then {
	_number = _number * 0.5;
};

private _return = _number;

// Auto-Balance is enabled, adjust the values.
private _autoBal = if (missionNamespace getVariable ["f_param_enemyAutoBalance",0] == 1) then {true} else {false};

// Get the number of current players.
private _playerCount = count (playableUnits + switchableUnits);
//private _playerCount = 20; // For testing limits.

// Cap off, as we don't want 100+ units per objective.
if (_playerCount > 20) then { _playerCount = 20; };

// Identify the type of unit to balance and determine the value.
switch (toLower _typeOfUnit) do {
	case "light": { 
		if (_autoBal) then {
			_return = ceil random [1, (_number * 0.5) + (_playerCount * 0.2), 0];
		} else {
			_return = ceil random [(_number * 0.5), _number, 0];
		};
	};
	case "medium": { 
		if (_autoBal) then {
			_return = round random [1, (_number * 0.5) + (_playerCount * 0.1), 0];
		} else {
			_return = round random [(_number * 0.5), _number, 0];
		};
	};
	case "heavy": { 
		if (_autoBal) then {
			_return = round random [0, (_number * 0.5) + (_playerCount * 0.05), 0];
		} else {
			_return = round random [0, _number, 0]; 
		};
	};
};

_return