// V1.0 - By 2600K - FEB-2017
// Fills an area with shaded squares and adds a trigger to shade those squares.
// If _trStart is SIDE then will only trigger a cell when ZERO units of _trStart AND _trSide is present.
// Counts are maintained as SERVER ONLY variables in the format: var_[areaName]_total and var_[areaName]_cleared.
//
// PARAMS:
// _object		OBJECT			* REQUIRED * TRIGGER or AREA MARKER to spawn the sectors in.  
// _areaName	STRING			The variable name to store the count of completions and total sectors (allows triggers to be linked to separate zones)
// _trStart		STRING/SIDE		The starting colour or SIDE of the sector
// _trSide		SIDE			The side that triggers completion of the sector.
// _rFill		INT				Random value to make a cell have no shade (to break up solid areas).
//
// USAGE:
// _nul = ["marker_1", "var_fillZone", independent, west, 0.2] execVM "fillSquares.sqf";
if !isServer exitWith {};

params [["_object",objNull], ["_areaName", "var_sector", [""]], ["_trStart", east, ["",west]], ["_trSide", west, [west]], ["_rFill", 0, [0]]];

private _objPos = [];
private _radX = 0;
private _radY = 0;

if (_object in allMapMarkers) then {
	_objPos = getMarkerPos _object;
	_object setMarkerAlpha 0;
	_radX = getMarkerSize _object select 0;
	_radY = getMarkerSize _object select 1;
} else {
	_objPos = getPos _object;
	if (_object isKindOf "EmptyDetector") then {
		_radX = triggerArea _object select 0;
		_radY = triggerArea _object select 1;
	};
};

if (_radX <= 0 || _radY <= 0) exitWith {};

private _maxArea = if (_radX > _radY) then { _radX } else { _radY };

// Find the centre of the cell the point is in.
_objPos = [((floor ((_objPos select 0) / 100)) * 100) + 50, ((floor ((_objPos select 1) / 100)) * 100) + 50, 0];

for [{_z = _maxArea * -1}, {_z <= _maxArea}, {_z = _z + 100}] do {
	for [{_y = _maxArea * -1}, {_y <= _maxArea}, {_y = _y + 100}] do {
		
		private _tempPos = _objPos vectorAdd [_z, _y, 0];
		if (random 1 > _rFill && {!surfaceIsWater _tempPos} && {_tempPos inArea _object}) then {
			private _tempMkr = createMarker [format["girdMK_%1%2",_tempPos select 0, _tempPos select 1], _tempPos];
			_tempMkr setMarkerShape "RECTANGLE";
			_tempMkr setMarkerBrush "Solid"; // FDiagonal
			_tempMkr setMarkerAlpha 0.5;
			_tempMkr setMarkerSize [50,50];

			// If a side was provided as the starting colour, use that sides default.
			if (_trStart isEqualType west) then {
				_tempMkr setMarkerColor ([_trStart, true] call BIS_fnc_sideColor);
			} else {
				_tempMkr setMarkerColor _trStart;
			};
						
			// Create a trigger to switch the area colour.
			private _mrkTrigger = createTrigger ["EmptyDetector", _tempPos, false];
			_mrkTrigger setTriggerTimeout [15, 15, 15, false];
			_mrkTrigger setTriggerArea [40, 40, 0, true, 40];
			_mrkTrigger setTriggerActivation [format["%1",_trSide], "PRESENT", false];
			private _triggerInit = "this";
			
			// If a side was specified, make sure the selected type is NOT PRESENT before running the trigger.
			if (_trStart isEqualType west) then {
				_mrkTrigger setTriggerActivation ["ANY", "PRESENT", false];
				_triggerInit = format["({side _x == %1} count thisList) == 0 && ({side _x == %2} count thisList) > 0", 
					if (_trStart in [west,east]) then { _trStart } else { "independent" },
					if (_trSide in [west,east]) then { _trSide } else { "independent" }
				];
			};
			
			_mrkTrigger setTriggerStatements [ 	_triggerInit, 
												format["missionNamespace setVariable ['var_%4_cleared', (missionNamespace getVariable ['var_%4_cleared',0]) + 1, true]; 'girdMK_%1%2' setMarkerColor '%3'; deleteVehicle thisTrigger;",
													round (_tempPos select 0),
													round (_tempPos select 1),
													([_trSide, true] call BIS_fnc_sideColor),
													_areaName
												], 
												"" ];

			missionNamespace setVariable [format["var_%1_total",_areaName], (missionNamespace getVariable [format["var_%1_total",_areaName],0]) + 1, true];
		};
	};
};