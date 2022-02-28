// [] spawn 
// [getPos selectRandom allPlayers select { alive _x }, [[0,0,0]], EAST, selectRandom ZMM_GUERVeh_CasP] call zmm_fnc_spawnUnit;
// [getPos (selectRandom (allPlayers select { alive _x })), [((selectRandom (allPlayers select { alive _x })) getPos [4000, random 360])], EAST, selectRandom ZMM_GUERVeh_CasP] call zmm_fnc_spawnUnit;
params [
	["_targetPos", []],
	["_posArray", []],
	"_side",
	["_unitClass", ""],
	["_tries", 1]
];

if (_unitClass isEqualTo "") exitWith { ["ERROR", format["SpawnUnit - Empty Unit Passed: %1 (%2)", _unitClass, _side]] call zmm_fnc_logMsg };
if (_tries > 10) exitWith {};

["DEBUG", format["SpawnUnit - Passed %1: %2 [%3] Try:%4", _targetPos, _unitClass, _side, _tries]] call zmm_fnc_logMsg;

private _reinfGrp = grpNull;
private _grpVeh = objNull;
private _vehType = "";
private _sleep = true;
private _dir = 0;
private _customInit = "";

// No positions to use
if (count _posArray == 0 || count _targetPos == 0) exitWith {};

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
_isAir = false;
if (_unitClass isEqualType "") then {
	if ("Air" in ([(configFile >> "CfgVehicles" >> _unitClass), true] call BIS_fnc_returnParents)) then { _isAir = true; _startingPos set [2, 500]; };
};

// Don't spawn object if too close to any players.
if ({ alive _x && _x distance2D _startingPos < (if _isAir then {1000} else {500})} count allPlayers > 0 && isMultiplayer) exitWith { 
	sleep 30;
	[_targetPos, _posArray, _side, _unitClass, _tries + 1] call zmm_fnc_spawnUnit;
};

if (_unitClass isEqualType "") then {
	_vehType = toLower getText (configFile >> "CfgVehicles" >> _unitClass >> "vehicleClass");
	_vehName = toLower getText (configFile >> "CfgVehicles" >> _unitClass >> "displayName");
	_grpVeh = createVehicle [_unitClass, _startingPos, [], 15, if _isAir then {"FLY"} else {"NONE"}];
	_grpVeh setVehicleLock "LOCKEDPLAYER";
	_grpVeh setVehicleTIPars [1, 0.5, 0.5];

	if _isAir then {
		_sleep = false;
		_grpVeh setDir (_grpVeh getDir _targetPos);
		_grpVeh setVelocity [100 * (sin (_grpVeh getDir _targetPos)), 100 * (cos (_grpVeh getDir _targetPos)), 0];
	} else {
		_grpVeh setDir _dir;
	};
	
	_startingPos set [2,0]; // Reset Starting Pos
	
	if (_vehType == "car" || (!canFire _grpVeh && !_isAir)) then {
		_vehType = "car";
		private _soldierArr = [];
		private _cargoNo = (count fullCrew [_grpVeh, "", true]) min 12;
		
		for "_i" from 1 to _cargoNo do { _soldierArr pushBack (if (_cargoNo > 4) then { selectRandom _manArray } else { _manArray#0 }) }; // Random units for cargo
	
		_reinfGrp = [_grpVeh getPos [15, random 360], _side, _soldierArr] call BIS_fnc_spawnGroup;
		_reinfGrp addVehicle _grpVeh;
		
		{ if !(_x moveInAny _grpVeh) then { /* deleteVehicle _x */ }; uiSleep 0.1; } forEach (units _reinfGrp select { vehicle _x == _x });
		
		uiSleep 0.5;
		
		_reinfGrp selectLeader effectiveCommander _grpVeh;
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
		
		uiSleep 0.5;
		
		{ if !(_x moveInAny _grpVeh) then { deleteVehicle _x }; uiSleep 0.1; } forEach (units _reinfGrp select { vehicle _x == _x });
		
		_reinfGrp selectLeader effectiveCommander _grpVeh;
	};
};

// Run custom init for vehicle (set camos etc).
if !(isNil "_customInit") then { 
	if !(_customInit isEqualTo "") then { call compile _customInit; };
};

if !_isAir then {
	if (random 1 > 0.3) then {
		_newWP = _reinfGrp addWaypoint [_targetPos, 100];
		_newWP setWaypointType "SAD";
	};

	_newWP = _reinfGrp addWaypoint [_targetPos, 100];
	_newWP setWaypointType "GUARD";
	
	if (_vehType == "car") then {
		_null = [_reinfGrp, _startingPos, _grpVeh, _targetPos] spawn {
			params ["_selGrp", "_startPos", "_selVeh", "_destPos"];

			private _leader = effectiveCommander _selVeh;
						
			waitUntil{ uiSleep 10; if (_leader distance2D _destPos < (400 + random 200) || !alive _leader || !canMove _selVeh) exitWith {true}; false; };
			
			if (!alive _leader || !canMove _selVeh) exitWith {};
			
			// Leave team in if it can fire
			if (canFire _selVeh) then {
				_vehGrp = createGroup [side group _leader, true];
				[_leader, driver _selVeh, gunner _selVeh] joinSilent _vehGrp;
			};
			
			_selGrp leaveVehicle _selVeh;
			{unassignVehicle _x; [_x] orderGetIn false; _x allowFleeing 0} forEach units _selGrp;
			
			waitUntil{ uiSleep 1; if ({vehicle _x == _selVeh} count units _selGrp == 0 || !alive _leader || !canMove _selVeh) exitWith {true}; false; };
			
			if (!alive _leader || !canMove _selVeh) exitWith {};
							
			uiSleep 5;
			
			if (canFire _selVeh) then {
				if (random 1 > 0.7) then {
					_newWP = group _leader addWaypoint [_destPos, 100];
					_newWP setWaypointType "SAD";
				};
				
				_newWP = group _leader addWaypoint [_destPos, 100];
				_newWP setWaypointType "GUARD";
			} else {
				_newWP = group _leader addWaypoint [_startPos, 0];
				waitUntil{ uiSleep 0.5; if (_selVeh distance2D _startPos < 50 || !alive _leader || !canMove _selVeh) exitWith {true}; false; };
				if (!alive _leader || !canMove _selVeh) exitWith {};
				_selVeh deleteVehicleCrew driver _selVeh;
				deleteGroup group _leader;
				deleteVehicle _selVeh;
			};
		};
	};
} else {
	private _paraGrp = grpNull;
	private _cargoNo = ((count fullCrew [_grpVeh, "", true]) - (count fullCrew [_grpVeh, "", false])) min 12;
	
	// No cargo seats so assume its CAS
	if (_cargoNo > 1) then {
		_reinfGrp setBehaviour "CARELESS";
		_soldierArr = [];
		
		for "_i" from 1 to _cargoNo do { _soldierArr pushBack (selectRandom _manArray) };

		_paraGrp = [[0,0,0], _side, _soldierArr] call BIS_fnc_spawnGroup;
		
		{ if !(_x moveInAny _grpVeh) then { deleteVehicle _x }; uiSleep 0.1; } forEach (units _paraGrp select { vehicle _x == _x });
		
		_landPos = [_targetPos, 300, random 360] call BIS_fnc_relPos;		
		_unloadWP = _reinfGrp addWaypoint [_landPos, 100];
		_unloadWP setWaypointStatements ["true", "(vehicle this) land 'GET OUT'; {unassignVehicle _x; [_x] orderGetIn false} forEach ((crew vehicle this) select {group _x != group this})"];
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
				uiSleep 30;
				{ if (_rGrp knowsAbout _x < 4) then { _rGrp reveal [_x, 4] } } forEach (allPlayers select {_x distance2D leader _rGrp < 1200 && vehicle _x == _x && stance _x == "STAND" });
			};
		};
	} else {
		_newWP = _reinfGrp addWaypoint [_startingPos, 0];
		_null = [_reinfGrp, _startingPos] spawn {
			params ["_reinfGrp","_startingPos"];
			_heli = vehicle leader _reinfGrp;
			waitUntil{ uiSleep 5; if ((leader _reinfGrp) distance2D _startingPos > 200 || !alive (leader _reinfGrp) || !canMove _heli) exitWith {true}; false; };
			waitUntil{ uiSleep 0.5; if ((leader _reinfGrp) distance2D _startingPos < 200 || !alive (leader _reinfGrp) || !canMove _heli) exitWith {true}; false; };
			if (!alive (leader _reinfGrp) || !canMove _heli) exitWith {};
			{_heli deleteVehicleCrew _x} forEach crew _heli;
			deleteGroup _reinfGrp;
			deleteVehicle _heli;
		};
	};
	
	if (count units _paraGrp > 0) then {
		_newWP = _paraGrp addWaypoint [_targetPos, 100];
		_newWP setWaypointType "SAD";
		_newWP = _paraGrp addWaypoint [_targetPos, 100];
		_newWP setWaypointType "GUARD";
		_reinfGrp = _paraGrp;
	};
};

if (!isNull _reinfGrp) then { _reinfGrp deleteGroupWhenEmpty true };

{ _x addCuratorEditableObjects [(units _reinfGrp) + [_grpVeh], true] } forEach allCurators;

if (_sleep) then { sleep random 20 };
