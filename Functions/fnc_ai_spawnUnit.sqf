params [
	"_targetPos",
	"_posArray",
	"_side",
	"_unitClass"
];

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
	private _veh = createVehicle [_unitClass, _startingPos, [], 0, if _isAir then {"FLY"} else {"NONE"}];

	if _isAir then {
		_sleep = FALSE;
		_veh setDir (_veh getDir _targetPos);
	} else {
		_veh setDir _dir;
	};
	
	if (_vehType == "car") then {
		_soldierArr = [];
	
		for [{_i = 1}, {_i <= count (fullCrew [_veh, "", true])}, {_i = _i + 1}] do {
			_soldierArr pushBack (selectRandom _manArray);
		};
	
		_reinfGrp = [_veh getPos [15, random 360], _side, _soldierArr] call BIS_fnc_spawnGroup;
		_grpVeh = _veh;
		_reinfGrp addVehicle _grpVeh;
		_wp = _reinfGrp addWaypoint [position _veh, 0];
		_wp setWaypointType "GETIN NEAREST";
	} else {
		createVehicleCrew _veh;
		
		// Convert crew if using another faction vehicle.
		if (([getNumber (configFile >> "CfgVehicles" >> _unitClass >> "Side")] call BIS_fnc_sideType) != _side) then {
			_reinfGrp = createGroup [_side, true];
			(crew _veh) join _reinfGrp;
		};
		
		_reinfGrp = group effectiveCommander _veh;
		_grpVeh = vehicle leader _reinfGrp;
	};
} else {
	_reinfGrp = [_startingPos, _side, _unitClass] call BIS_fnc_spawnGroup;
	_grpVeh = (position leader _reinfGrp) nearestObject "Car";
	
	if (leader _reinfGrp distance2D _grpVeh < 75) then {
		_vehType = "car";
		{unassignVehicle _x; [_x] orderGetIn FALSE} forEach units _reinfGrp;
		_reinfGrp addVehicle _grpVeh;	
		_wp = _reinfGrp addWaypoint [position _grpVeh, 0];
		_wp setWaypointType "GETIN NEAREST";
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

			_leader = leader _selGrp;
						
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
	// Unit is a transport.
	_reinfGrp setBehaviour "CARELESS";
	_soldierArr = [selectRandom _manArray];
	
	for [{_i = 1}, {_i < (([_unitClass, true] call BIS_fnc_crewCount) - ([_unitClass, false] call BIS_fnc_crewCount))}, {_i = _i + 1}] do {
		_soldierArr pushBack (selectRandom _manArray);
	};

	_paraUnit = [[0,0,0], _side, _soldierArr] call BIS_fnc_spawnGroup;
	{
		_x assignAsCargo _grpVeh;
		[_x] orderGetIn TRUE;
		_x moveInCargo _grpVeh;
		_x allowFleeing 0;
	} forEach units _paraUnit;
	
	_unloadWP = _reinfGrp addWaypoint [_targetPos getPos [300, random 360], 100];
	_unloadWP setWaypointStatements ["TRUE", "(vehicle this) land 'GET OUT'; {unassignVehicle _x; [_x] orderGetIn FALSE} forEach ((crew vehicle this) select {group _x != group this})"];
	_newWP = _reinfGrp addWaypoint [waypointPosition _unloadWP, 0];
	_newWP setWaypointStatements ["{group _x != group this && alive _x} count crew vehicle this == 0", ""];
	
	_weapCount = 0;
	{
		_weapCount = _weapCount + count (vehicle player weaponsTurret _x);
	} forEach ([[-1]] + (allTurrets vehicle player)); 
	
	// If has turrets hang around AO, otherwise despawn.
	if (_weapCount > 1) then {
		_newWP = _reinfGrp addWaypoint [_targetPos, 0];
		_newWP setWaypointType "LOITER";
		_newWP setWaypointBehaviour "AWARE";
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
	for [{_i = 0}, {_i < 3}, {_i = _i + 1}] do {
		_newWP = _paraUnit addWaypoint [_targetPos, 100];
		_newWP setWaypointType "SAD";
	};
	_newWP = _paraUnit addWaypoint [_targetPos, 100];
	_newWP setWaypointType "GUARD";
	_reinfGrp = _paraUnit;
};

{ _x addCuratorEditableObjects [(units _reinfGrp) + [_grpVeh], TRUE] } forEach allCurators;

if (_sleep) then { sleep random 20 };
