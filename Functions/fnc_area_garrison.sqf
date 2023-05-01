if !isServer exitWith {};

params [["_zoneID", 0], ["_enemyCount", -1], ["_bPos",[]]];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
private _side = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _buildings = missionNamespace getVariable [format["ZMM_%1_Buildings", _zoneID], []];
private _menArray = missionNamespace getVariable [format["ZMM_%1Man", _side], []];

if (_enemyCount < 0) then { 
	_enemyCount = missionNamespace getVariable [format[ "ZMM_%1_Garrison", _zoneID ], 14];
	missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], 0];
};

if (_enemyCount < 1) exitWith {};

if (count _buildings isEqualTo 0 && count _bPos isEqualTo 0) exitWith {};

if (count _bPos isEqualTo 0) then {
	{
		if (count (_x buildingPos -1) >= 4) then {
			_bPos append (_x buildingPos -1);
		};
	} forEach _buildings;
};

["DEBUG", format["Zone%1 - Area Garrison - Creating: %2 units (%3 positions)", _zoneID, _enemyCount, count _bPos]] call zmm_fnc_logMsg;

if (count _menArray isEqualTo 0) exitWith { ["ERROR", format["Zone%1 (%2) - No valid units passed, were global unit variables declared?", _zoneID, _side]] call zmm_fnc_logMsg };

private _grp = createGroup [_side, true];

for "_i" from 1 to (_enemyCount) do {
	 _unitType = selectRandom _menArray;
	 _inHouse = true;
	
	if (count _bPos == 0) exitWith {
		// Spawn stationary soldiers.
		if (random 1 > 0.8) then {
			_unit = _grp createUnit [_unitType, [0,0,0], [], 150, "NONE"];
			[_unit] joinSilent _grp; 
			_unit setPos (([_centre, random 150, random 360] call BIS_fnc_relPos) findEmptyPosition [0, 25, _unitType]);
			_unit setFormDir ((_unit getRelDir _centre) - 180);
			_unit setDir ((_unit getRelDir _centre) - 180);
			_unit setUnitPos "MIDDLE";
			_unit setBehaviour "SAFE";
			_inHouse = false;
		};
	};
	
	_newPos = selectRandom _bPos;
	_bPos = _bPos - [_newPos];
	
	if (count (_newPos nearEntities ["Man", 1]) < 1) then {
		_unit = _grp createUnit [_unitType, [0,0,0], [], 150, "NONE"];
		[_unit] joinSilent _grp; 
		_unit setPosATL _newPos;

		// Force unit to hold - doStop is a 'soft' hold, disableAI stops movement permanently.
		if (random 1 > 0.7) then { doStop _unit } else { _unit disableAI "PATH" };

		[_unit] spawn zmm_fnc_unitDirPos;
		
		if (count (_unit nearEntities ["EmptyDetector", 50]) isEqualTo 0) then {
			private _trg = createTrigger ["EmptyDetector", getPos _unit];
			_trg setTriggerArea [50, 50, 0, false, 15];
			_trg setTriggerActivation ["ANYPLAYER", "PRESENT", false];
			_trg setTriggerInterval 5;
			_trg setTriggerStatements [
				"this", 
				"{ if (local _x) then { if (!(_x checkAIFeature 'PATH') && random 1 < 0.2) then { doStop _x; _x enableAI 'PATH' }; }; } forEach (allUnits inAreaArray thisTrigger);",
				"{ if (local _x) then { if !(_x checkAIFeature 'PATH') then { _x doFollow leader _x; _x enableAI 'PATH' }; }; } forEach (allUnits inAreaArray thisTrigger);"
			];
		};
	};
};

if (!(_bPos isEqualTo []) && ZZM_Mode == 1) then { [selectRandom _bPos] call zmm_fnc_intelAdd };

_grp setVariable ["VCM_DISABLE", true];
_grp enableDynamicSimulation true;

//Add to Zeus
{ _x addCuratorEditableObjects [units _grp, true] } forEach allCurators;

["DEBUG", format["Zone%1 - Garrison Centre - Created: %2 units", _zoneID, count units _grp]] call zmm_fnc_logMsg;