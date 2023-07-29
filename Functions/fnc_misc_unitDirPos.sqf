params [["_unit", objNull]];

if !(alive _unit) exitWith {};

// Force unit to hold - doStop is a 'soft' hold, disableAI stops movement permanently.
if (random 1 > 0.7) then { doStop _unit } else { _unit disableAI "PATH" };

private _unitEyePos = eyePos _unit;

// Make unit crouch if they have sky above their heads.
if (count (lineIntersectsWith [_unitEyePos, (_unitEyePos vectorAdd [0, 0, 10])] select {_x isKindOf 'Building'}) < 1) then {
	_unit setUnitPos "MIDDLE";
	// Reset source to new height.
	_unitEyePos = eyePos _unit; 
}; 

private _p1 = []; // Great pos, facing outside building.
private _p2 = []; // Good pos but facing inside building.
private _p3 = []; // OK pos but not best views.
private _p4 = []; // Bad pos facing wall.

// Get Building Direction
private _unitBld = nearestBuilding _unit;

if (!isNull _unitBld) then {
	for "_dir" from (getDir _unitBld) to ((getDir _unitBld) + 359) step 45 do { 
		// Check 3m
		if (count (lineIntersectsWith [_unitEyePos, [_unitEyePos, 3, _dir] call BIS_fnc_relPos] select {_x isKindOf 'Building'}) > 0) then { 
			_p4 pushBack _dir;
		} else { 
			// Check 10m
			if (count (lineIntersectsWith [_unitEyePos, [_unitEyePos, 10, _dir] call BIS_fnc_relPos] select {_x isKindOf 'Building'}) > 0) then { 
				_p3 pushBack _dir;
			} else { 
				if (abs ((_unitEyePos getDir _unitBld) - _dir) >= 120) then {
					_p1 pushBack _dir;
				} else {
					_p2 pushBack _dir;
				};
			};
		};
	};  
};
	
// Pick a random angle from the best grouping.
private _finalDir = random 360;
{	
	if (count _x > 0) exitWith {_finalDir = selectRandom _x };
} forEach [_p1, _p2, _p3, _p4];

_unit setDir _finalDir;
_unit doWatch (_unit getPos [200,_finalDir]);

// Semi-exposed area, set to kneel.
if (count (_p1 + _p2) >= 5 && random 1 > 0.2) then { _unit setUnitPos "MIDDLE" };

// Exposed area, set to prone.
if (count (_p1 + _p2) >= 7) then { 
	if (random 1 > 0.8) then { _unit setUnitPos "MIDDLE" } else { _unit setUnitPos "DOWN" };
};