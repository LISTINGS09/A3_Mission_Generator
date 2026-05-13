if !isServer exitWith {};

params [["_zoneID", 0], ["_enemyCount", -1], ["_house", objNull]];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
private _side = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _buildings = missionNamespace getVariable [format["ZMM_%1_Buildings", _zoneID], []];
private _enemyMen = missionNamespace getVariable [format["ZMM_%1_Man", _side], ["O_Soldier_F"]];

if (_enemyCount < 0) then { 
	_enemyCount = missionNamespace getVariable [format[ "ZMM_%1_Garrison", _zoneID ], (count _buildings) min 30];
	missionNamespace setVariable [format[ "ZMM_%1_Garrison", _zoneID ], 0];
};

if (_enemyCount < 1) exitWith {};

if (count _buildings isEqualTo 0 && isNull _house) exitWith {};

["DEBUG", format["Zone%1 - Area Garrison - Creating: %2 units (%3)", _zoneID, _enemyCount, if (isNull _house) then { format["%1 Buildings",count _buildings] } else { typeOf _house }]] call zmm_fnc_misc_logMsg;

if (count _enemyMen isEqualTo 0) exitWith { ["ERROR", format["Zone%1 (%2) - No valid units passed, were global unit variables declared?", _zoneID, _side]] call zmm_fnc_misc_logMsg };

// Fill Buildings
{
	if (_enemyCount < 1) exitWith {};
		
	private _bld = _x;
	private _bFill = false;
	private _bPos = _bld buildingPos -1;
	
	if (count _bPos > 0) then {
		//private _uid = missionNamespace getVariable [format["ZMM_%1_UID",_zoneID], 1];
		//missionNamespace setVariable [format["ZMM_%1_UID",_zoneID], _uid + 1];
		
		private _grp = createGroup [_side, true];
		_grp setGroupId [format["ZMM_Z%1_%2_GARRISON", _zoneID, _forEachIndex]];

		private _places = if (count _bPos > 6) then { ceil random 4 } else { 2 };
		
		for "_i" from 0 to _places do {
			if (count _bPos < 1 || _enemyCount < 1) exitWith {};
			
			private _tempPos = selectRandom _bPos;
			_bPos = _bPos - [_tempPos];
			
			if (count (_tempPos nearEntities ["Man", 1]) < 1) then {
				_bFill = true;
				_enemyCount = _enemyCount - 1;
				private _unit = _grp createUnit [selectRandom _enemyMen, getPos _bld, [], 0, "NONE"];
				[_unit] joinSilent _grp;
				_unit setPosATL _tempPos;
				[_unit] spawn zmm_fnc_misc_unitDirPos;
			};
		};
		
		if (_bFill && count (_bld nearEntities ["EmptyDetector", 50]) isEqualTo 0) then {
			private _trg = createTrigger ["EmptyDetector", getPos _bld];
			_trg setTriggerArea [50, 50, 0, false, 15];
			_trg setTriggerActivation ["ANYPLAYER", "PRESENT", false];
			_trg setTriggerInterval 5;
			_trg setTriggerStatements [
				"this", 
				"{ if (local _x) then { if (!(_x checkAIFeature 'PATH') && random 1 < 0.4) then { doStop _x; _x enableAI 'PATH' }; }; } forEach (allUnits inAreaArray thisTrigger);",
				"{ if (local _x) then { if !(_x checkAIFeature 'PATH') then { _x doFollow leader _x; _x enableAI 'PATH' }; }; } forEach (allUnits inAreaArray thisTrigger);"
			];
		};
		
		_grp setVariable ["VCM_DISABLE", true];
		_grp enableDynamicSimulation true;
		
		//Add to Zeus
		{ _x addCuratorEditableObjects [units _grp, true] } forEach allCurators;
	};
	sleep 0.1;
} forEach (if !(isNull _house) then { [_house] select { count (_x buildingPos -1) > 0 } } else { _buildings call BIS_fnc_arrayShuffle });

if (ZZM_Mode == 1 && count _buildings > 0 && isNull _house) then { [selectRandom ((selectRandom _buildings) buildingPos -1)] spawn zmm_fnc_intelAdd };