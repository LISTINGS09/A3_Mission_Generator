params [
	"_targetPos",
	"_posArray",
	"_side",
	["_unitClass", ""]
];

if (_unitClass isEqualTo "") exitWith { ["ERROR", format["SpawnUnit - Empty Unit Passed: %1 (%2)", _unitClass, _side]] call zmm_fnc_logMsg };

["DEBUG", format["SpawnUnit - Passed %1: %2 [%3]", _targetPos, _unitClass, _side]] call zmm_fnc_logMsg;

private _reinfGrp = grpNull;
private _grpVeh = objNull;
private _vehType = "";
private _sleep = TRUE;
private _tooClose = FALSE;
private _dir = 0;
private _customInit = "";

// No positions to use
if (count _posArray == 0) exitWith {};

// Fix any positions are not in array format
{
	switch (typeName _x) do {
		case "STRING": { _posArray set [_forEachIndex, getMarkerPos _x] };
		case "OBJECT": { _posArray set [_forEachIndex, getPos _x] };
	};
} forEach _posArray;

private _startingPos = selectRandom _posArray;
_startingPos set [2,0];
_dir = _startingPos getDir _targetPos;
private _manArray = missionNamespace getVariable [format["ZMM_%1Man", _side], ["B_Soldier_F"]];

// If _unitClass is array, extract the custom init.
if (_unitClass isEqualType []) then { _customInit = _unitClass # 1; _unitClass = _unitClass # 0 };

// Check if _unitClass is an air vehicle.
_isAir = FALSE;
if (_unitClass isEqualType "") then {
	if ("Air" in ([(configFile >> "CfgVehicles" >> _unitClass), TRUE] call BIS_fnc_returnParents)) then { _isAir = TRUE };
};

// Don't spawn object if too close to any players.
private _maxDist = if _isAir then {1000} else {500};
{
	if (alive _x && _x distance2D _startingPos < _maxDist) exitWith { _tooClose = true};
} forEach (playableUnits + switchableUnits);

if _tooClose exitWith { [_targetPos, _posArray, _side, _unitClass] call zmm_fnc_spawnUnit };

if (_unitClass isEqualType "") then {
	_vehType = toLower getText (configFile >> "CfgVehicles" >> _unitClass >> "vehicleClass");
	_grpVeh = createVehicle [_unitClass, _startingPos, [], 0, if _isAir then {"FLY"} else {"NONE"}];
	_grpVeh setVehicleLock "LOCKEDPLAYER"; 

	if _isAir then {
		_sleep = FALSE;
		_grpVeh setDir (_grpVeh getDir _targetPos);
	} else {
		_grpVeh setDir _dir;
	};
	
	if (_vehType == "car" || (!canFire _grpVeh && !_isAir)) then {
		_vehType = "car";
		_soldierArr = [];
	
		for [{_i = 1}, {_i < count (fullCrew [_grpVeh, "", true])}, {_i = _i + 1}] do {
			_soldierArr pushBack (selectRandom _manArray);
		};
	
		_reinfGrp = [_grpVeh getPos [15, random 360], _side, _soldierArr] call BIS_fnc_spawnGroup;
		_reinfGrp addVehicle _grpVeh;
		_wp = _reinfGrp addWaypoint [position _grpVeh, 0];
		_wp setWaypointType "GETIN NEAREST";
		
		uiSleep 0.5;
		
		{ _x moveInAny _grpVeh } forEach (units _reinfGrp select { vehicle _x == _x });
	} else {
		createVehicleCrew _grpVeh;
		
		// Convert crew if using another faction vehicle.
		if (([getNumber (configFile >> "CfgVehicles" >> _unitClass >> "Side")] call BIS_fnc_sideType) != _side) then {
			_reinfGrp = createGroup [_side, true];
			(crew _grpVeh) join _reinfGrp;
		};
		
		_reinfGrp = group effectiveCommander _grpVeh;
	};	
} else {
	_reinfGrp = [_startingPos, _side, _unitClass] call BIS_fnc_spawnGroup;
	
	_vehArray = (units _reinfGrp apply { assignedVehicle _x }) - [objNull];
	
	if (count (_vehArray arrayIntersect _vehArray) > 0) then {
		_grpVeh = (_vehArray arrayIntersect _vehArray)#0;
		_vehType = "car";
		
		_wp = _reinfGrp addWaypoint [position _grpVeh, 0];
		_wp setWaypointType "GETIN NEAREST";
		
		uiSleep 0.5;
		
		{ _x moveInAny _grpVeh } forEach (units _reinfGrp select { vehicle _x == _x });
	};
};

// Run custom init for vehicle (set camos etc).
if !(_customInit isEqualTo "") then { call compile _customInit; };

if !_isAir then {
	_newWP = _reinfGrp addWaypoint [_targetPos, 100];
	_newWP setWaypointType "SAD";

	_newWP = _reinfGrp addWaypoint [_targetPos, 100];
	_newWP setWaypointType "GUARD";
	
	if (_vehType == "car") then {
		_null = [_reinfGrp, _startingPos, _grpVeh, _targetPos] spawn {
			params ["_selGrp", "_startPos", "_selVeh", "_destPos"];

			private _leader = leader _selGrp;
						
			waitUntil{sleep 15; if (_leader distance2D _destPos < 400 || !alive _leader || !canMove _selVeh) exitWith {true}; false; };
			
			if (!alive _leader || !canMove _selVeh) exitWith {};
			
			[_leader] joinSilent grpNull;
			_newGrp = group _leader;
			
			[commander _selVeh] joinSilent (group _leader);
			[gunner _selVeh] joinSilent (group _leader);
			
			_selGrp leaveVehicle _selVeh;
			{unassignVehicle _x; [_x] orderGetIn FALSE; _x allowFleeing 0} forEach units _selGrp;
			
			waitUntil{sleep 1; if ({vehicle _x == _selVeh} count units _selGrp == 0 || !alive _leader || !canMove _selVeh) exitWith {true}; false; };
			
			if (!alive _leader || !canMove _selVeh) exitWith {};
			
			_leader assignAsDriver _selVeh;
			[_leader] orderGetIn TRUE;
			
			if (vehicle _leader == _selVeh) then {
				_leader setPos position _selVeh;
				_leader moveInDriver _selVeh;
			};
			
			sleep 20;
			
			if (canFire _selVeh) then {
				_newWP = _newGrp addWaypoint [_destPos, 100];
				_newWP setWaypointType "GUARD";
			} else {
				_newWP = _newGrp addWaypoint [_startPos, 0];
				waitUntil{sleep 0.5; if (_selVeh distance2D _startPos < 50 || !alive _leader || !canMove _selVeh) exitWith {true}; false; };
				if (!alive _leader || !canMove _selVeh) exitWith {};
				_selVeh deleteVehicleCrew driver _selVeh;
				deleteGroup _newGrp;
				deleteVehicle _selVeh;
			};
		};
	};
} else {
	private _paraGrp = grpNull;
	
	// No cargo seats so assume its CAS
	if (count fullCrew [_grpVeh, "cargo", true] > 0) then {
		_reinfGrp setBehaviour "CARELESS";
		_soldierArr = [];
		
		for [{_i = 1}, {_i < (([_unitClass, true] call BIS_fnc_crewCount) - ([_unitClass, false] call BIS_fnc_crewCount))}, {_i = _i + 1}] do {
			_soldierArr pushBack (selectRandom _manArray);
		};

		_paraGrp = [[0,0,0], _side, _soldierArr] call BIS_fnc_spawnGroup;
		{
			_x assignAsCargo _grpVeh;
			[_x] orderGetIn TRUE;
			_x moveInCargo _grpVeh;
			_x allowFleeing 0;
		} forEach units _paraGrp;
		
		_landPos = [_targetPos, 300, random 360] call BIS_fnc_relPos;		
		_unloadWP = _reinfGrp addWaypoint [_landPos, 100];
		_unloadWP setWaypointStatements ["TRUE", "(vehicle this) land 'GET OUT'; {unassignVehicle _x; [_x] orderGetIn FALSE} forEach ((crew vehicle this) select {group _x != group this})"];
		_newWP = _reinfGrp addWaypoint [waypointPosition _unloadWP, 0];
		_newWP setWaypointStatements ["{group _x != group this && alive _x} count crew vehicle this == 0", ""];
	};

	_weapCount = 0;
	{ _weapCount = _weapCount + count _x } forEach (([[-1]] + (allTurrets _grpVeh)) apply { (_grpVeh weaponsTurret _x) - [
		"rhsusf_weap_CMDispenser_ANALE39",
		"rhsusf_weap_CMDispenser_ANALE40",
		"rhsusf_weap_CMDispenser_ANALE52",
		"rhsusf_weap_CMDispenser_M130",
		"rhs_weap_CMDispenser_ASO2",
		"rhs_weap_CMDispenser_BVP3026",
		"rhs_weap_CMDispenser_UV26",
		"rhs_weap_MASTERSAFE",
		"rhsusf_weap_LWIRCM",
		"Laserdesignator_pilotCamera",
		"rhs_weap_fcs_ah64"]
	});
	
	// If has turrets hang around AO, otherwise despawn.
	if (_weapCount > 1) then {
		// TODO: Could be better? Make heli leave after a few SAD wps?
		_newWP = _reinfGrp addWaypoint [_targetPos, 0];
		_newWP setWaypointType "SAD";
		_newWP setWaypointCompletionRadius 300;
		_newWP setWaypointBehaviour "AWARE";
		_newWP = _reinfGrp addWaypoint [_targetPos, 1];
		_newWP setWaypointType "LOITER";
		_newWP setWaypointCompletionRadius 500;
		
		_null = [_reinfGrp, _startingPos, _targetPos] spawn {
				params ["_rGrp","_sPos","_tPos"];
								
				private _time = time + 600;
				while {	alive (vehicle leader _rGrp) && time < _time } do {
					sleep 10; 
					{ _rGrp reveal [_x, 4] } forEach ((_targetPos nearEntities 600) select {side _x != side _rGrp && vehicle _x == _x && stance _x == "STAND" });
				};
			};
	} else {
		_newWP = _reinfGrp addWaypoint [_startingPos, 0];
		_null = [_reinfGrp, _startingPos] spawn {
			params ["_reinfGrp","_startingPos"];
			_heli = vehicle leader _reinfGrp;
			waitUntil{sleep 5; if ((leader _reinfGrp) distance2D _startingPos > 200 || !alive (leader _reinfGrp) || !canMove _heli) exitWith {true}; false; };
			waitUntil{sleep 0.5; if ((leader _reinfGrp) distance2D _startingPos < 200 || !alive (leader _reinfGrp) || !canMove _heli) exitWith {true}; false; };
			if (!alive (leader _reinfGrp) || !canMove _heli) exitWith {};
			{_heli deleteVehicleCrew _x} forEach crew _heli;
			deleteGroup _reinfGrp;
			deleteVehicle _heli;
		};
	};
	
	if (count units _paraGrp > 0) then { 
		_paraGrp deleteGroupWhenEmpty true;
	
		for [{_i = 0}, {_i < 3}, {_i = _i + 1}] do {
			_newWP = _paraGrp addWaypoint [_targetPos, 100];
			_newWP setWaypointType "SAD";
		};
		_newWP = _paraGrp addWaypoint [_targetPos, 100];
		_newWP setWaypointType "GUARD";
		_reinfGrp = _paraGrp;
	};
};

if (!isNull _reinfGrp) then { _reinfGrp deleteGroupWhenEmpty true };

{ _x addCuratorEditableObjects [(units _reinfGrp) + [_grpVeh], TRUE] } forEach allCurators;

if (_sleep) then { sleep random 20 };
