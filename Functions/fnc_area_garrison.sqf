if !isServer exitWith {};

params [["_zoneID", 0], ["_enemyCount", -1], ["_bPos",[]]];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_side = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_buildings = missionNamespace getVariable [format["ZMM_%1_Buildings", _zoneID], []];
_menArray = missionNamespace getVariable [format["ZMM_%1Man", _side], []];

if (_enemyCount < 0) then { _enemyCount = missionNamespace getVariable [format[ "ZMM_%1_Garrison", _zoneID ], 14] };

if (_enemyCount < 1) exitWith {};

if (count _buildings isEqualTo 0 && count _bPos isEqualTo 0) exitWith {};

if (count _bPos isEqualTo 0) then {
	{
		if (count (_x buildingPos -1) >= 4) then {
			_bPos append (_x buildingPos -1);
		};
	} forEach _buildings;
};

["DEBUG", format["Creating Garrison -  Zone %1 with %2 units (%3 positions)", _zoneID, _enemyCount, count _bPos]] call zmm_fnc_logMsg;

_grp = createGroup [_side, TRUE];

for "_i" from 1 to (_enemyCount) do {
	if (count _menArray isEqualTo 0) exitWith { ["ERROR", format["Zone%1 (%2) - No valid units passed, were global unit variables declared?", _zoneID, _side]] call zmm_fnc_logMsg };
	 _unitType = selectRandom _menArray;
	 _inHouse = TRUE;
	 
	if (count _bPos == 0) exitWith {
		// Spawn stationary soldiers.
		if (random 1 > 0.8) then {
			_unit = _grp createUnit [_unitType, [0,0,0], [], 0, "NONE"];
			[_unit] joinSilent _grp; 
			_unit setPos (([_centre, random 150, random 360] call BIS_fnc_relPos) findEmptyPosition [0, 25, _unitType]);
			_unit setFormDir ((_unit getRelDir _centre) - 180);
			_unit setDir ((_unit getRelDir _centre) - 180);
			_unit setUnitPos "MIDDLE";
			_unit setBehaviour "SAFE";
			_inHouse = FALSE;
		};
	};
	
	_newPos = selectRandom _bPos;
	_bPos = _bPos - [_newPos];

	_unit = _grp createUnit [_unitType, [0,0,0], [], 0, "NONE"];
	[_unit] joinSilent _grp; 
	_unit setPosATL _newPos;
	
	_unitEyePos = eyePos _unit;
	_emptyCount = 0;
	
	// Make unit crouch if they have sky above their heads.
	if (count (lineIntersectsWith [_unitEyePos, (_unitEyePos vectorAdd [0, 0, 10])] select {_x isKindOf 'Building'}) < 1) then {
		_unit setUnitPos "MIDDLE";
		// Reset source to new height.
		_unitEyePos = eyePos _unit; 
	}; 
	
	// Force unit to hold.
	doStop _unit;
	
	if (_inHouse) then {
		_p1 = []; // Great pos, facing outside building.
		_p2 = []; // Good pos but facing inside building.
		_p3 = []; // OK pos but not best views.
		_p4 = []; // Bad pos facing wall.
		
		// Get Building Direction
		_unitBld = nearestBuilding _unit;
		
		for "_dir" from 0 to 359 step 45 do { 
			// Check 3m
			if (count (lineIntersectsWith [_unitEyePos, [_unitEyePos, 3, _dir] call BIS_fnc_relPos] select {_x isKindOf 'Building'}) > 0) then { 
				_p4 pushBack _dir;
				_helper = "Sign_Arrow_Direction_F";
			} else { 
				// Check 10m
				if (count (lineIntersectsWith [_unitEyePos, [_unitEyePos, 10, _dir] call BIS_fnc_relPos] select {_x isKindOf 'Building'}) > 0) then { 
					_p3 pushBack _dir;
					_helper = "Sign_Arrow_Direction_Yellow_F";
				} else { 
					if (abs ((_unitEyePos getDir (nearestBuilding _unit)) - _dir) >= 120) then {
						_p1 pushBack _dir;
						_helper = "Sign_Arrow_Direction_Green_F";
					} else {
						_p2 pushBack _dir;
						_helper = "Sign_Arrow_Direction_Cyan_F";
					};
					_emptyCount = _emptyCount + 1;
				};
			};
		};  
			
		// Pick a random angle from the best grouping.
		_finalDir = -1;
		{	
			if (count _x > 0) then {_finalDir = selectRandom _x };
			if (_finalDir >= 0) exitWith {}; 
		} forEach [_p1, _p2, _p3, _p4];
		
		_unit setDir _finalDir; // Doesn't work?
		_unit setFormDir _finalDir; // Doesn't work?
		_unit doWatch (_unit getPos [200,_finalDir]); // Works!
		
		// Semi-exposed area, set to kneel.
		if (_emptyCount >= 5 && random 1 > 0.2) then { _unit setUnitPos "MIDDLE" };

		// Exposed area, set to prone.
		if (_emptyCount >= 7) then { 
			if (random 1 > 0.8) then { _unit setUnitPos "MIDDLE" } else { _unit setUnitPos "DOWN" };
		};
	};
	
	if (random 1 < 0.1) then { [_unit] call zmm_fnc_inteladd };
};

if (!(_bPos isEqualTo []) && (missionNamespace getVariable ["ZZM_Mode", 0]) > 0) then {
	[selectRandom _bPos] call zmm_fnc_intelAdd; // Add Intel Item
};

_grp setVariable ["VCM_DISABLE", TRUE];
_grp enableDynamicSimulation TRUE;

//Add to Zeus
{
	_x addCuratorEditableObjects [units _grp, TRUE];
} forEach allCurators;

missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], 0];