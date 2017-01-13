params [["_number", 1, [1]], ["_typeOfUnit", "light", [""]], ["_missionType", (tg_missionTypes select 0), [""]]];

// Always reduce number for non-main missions.
if (_missionType != tg_missionTypes select 0) then {
	_number = _number * 0.5;
};

// Auto-Balance is enabled, adjust the values
_autoBal = if (missionNamespace getVariable ["f_param_enemyAutoBalance",0] == 1) then {true} else {false};

_return = 0;

// Identify the type of unit to balance and determine the value.
switch (toLower _typeOfUnit) do {
	case "light": { 
		if (_autoBal) then {
			_return = ceil random [1, (_number * 0.5) + ((count (playableUnits + switchableUnits)) * 0.4), 0];
		} else {
			_return = ceil random [(_number * 0.5), _number, 0];
		};
	};
	case "medium": { 
		if (_autoBal) then {
			_return = floor random [1, (_number * 0.5) + ((count (playableUnits + switchableUnits)) * 0.2), 0];
		} else {
			_return = floor random [(_number * 0.5), _number, 0];
		};
	};
	case "heavy": { 
		if (_autoBal) then {
			_return = floor random [0, (_number * 0.5) + ((count (playableUnits + switchableUnits)) * 0.1), 0];
		} else {
			_return = floor random [0, _number, 0]; 
		};
	};
};

_return