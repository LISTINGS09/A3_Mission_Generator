// [getPos selectRandom allPlayers select { alive _x }, [[0,0,0]], EAST, selectRandom ZMM_GUER_CasP] call zmm_fnc_qrf_spawnGroup;
// [getPos (selectRandom (allPlayers select { alive _x })), [((selectRandom (allPlayers select { alive _x })) getPos [4000, random 360])], EAST, selectRandom ZMM_GUER_CasP] call zmm_fnc_qrf_spawnGroup;
// zmm_fnc_qrf_spawnGroup
params [
	["_targetPos", []],			// Target Destination to stop at
	["_spawnArray", []],		// Array of String/Object/Marker Starting Positions
	["_side", WEST],			// Side of spawned vehicle
	["_startClass", ""],		// Classname, Config, Number or Array [classname,code]
	["_spawnDistCheck", 500],	// Don't spawn this close to players
	["_tries", 0],				// If too close to players, then try up to 5 times
	["_zoneID", 0],				// ZMM Compatability - The Zone this group will belong
	["_UPSMkr",""]				// ZMM Compatability - If this exists will call UPS to allow patrol instead of travel
];

if (_startClass isEqualTo "") exitWith { ["WARNING", format["spawnGroup - Empty Unit Passed: %1 (%2)", _startClass, _side]] call zmm_fnc_misc_logMsg };
if (_tries > 5 || count _spawnArray == 0 || count _targetPos == 0) exitWith {};

private _id = if (_zoneID > 0) then { _zoneID } else { missionNamespace getVariable ["ZQR_wave", 0] };
private _uid = (missionNamespace getVariable ["ZQR_count", 0]) + 1;	
ZQR_count = _uid;

//["DEBUG", format["W%1_G%2 - qrf_spawnGroup - Starting - %3 [%4] Attempt:%5", _id, _uid, _startClass, _side, _tries]] call zmm_fnc_misc_logMsg;

private _unitClass = _startClass;
private _mainGrp = grpNull;
private _suppGrp = grpNull;
private _grpVeh = objNull;
private _vehType = "";
private _customInit = "";

// Fix any positions are not in array format
{
	switch (typeName _x) do {
		case "STRING": { _spawnArray set [_forEachIndex, getMarkerPos _x] };
		case "OBJECT": { _spawnArray set [_forEachIndex, getPos _x] };
	};
} forEach _spawnArray;

private _startingPos = selectRandom _spawnArray;
_startingPos set [2,0];
private _enemyMen = missionNamespace getVariable [format["ZMM_%1_Man", _side], ["O_Soldier_F"]];

// Don't spawn object if too close to any players.
if ( isMultiplayer && {allPlayers findIf { alive _x && _x distance2D _startingPos < _spawnDistCheck } > -1} ) exitWith {
	sleep 30;
	[_targetPos, _spawnArray, _side, _startClass, _spawnDistCheck, _tries + 1, _zoneID, _UPSMkr] call zmm_fnc_qrf_spawnGroup;
};

// If _unitClass is array, extract the custom init.
// if (_unitClass isEqualType []) then { _unitClass params ["_unitClass","_customInit"] }; // Does this overwrite class correctly??
if (_unitClass isEqualType []) then { _customInit = _unitClass#1; _unitClass = _unitClass#0 };

// If _unitClass is a number, fill it with random units.
if (_unitClass isEqualType 1) then {
	_vehType = "Man";
	private _enemyTeam = [];
	for "_i" from 0 to (_unitClass - 1) do {  _enemyTeam set [_i, selectRandom _enemyMen] };
	_unitClass = _enemyTeam;
};

private _isArmed = false;
	
//["DEBUG", format["W%1_G%3 - qrf_spawnGroup - Spawning - %4 [%5] at %6", _id, _uid, _unitClass, _side, _startingPos]] call zmm_fnc_misc_logMsg;

if (_unitClass isEqualType "") then {
	_vehType = toLower getText (configFile >> "CfgVehicles" >> _unitClass >> "vehicleClass");
	
	if ("Air" in ([(configFile >> "CfgVehicles" >> _unitClass), true] call BIS_fnc_returnParents)) then { _vehType = "air"; _startingPos set [2, 800]; };
	if ("Ship" in ([(configFile >> "CfgVehicles" >> _unitClass), true] call BIS_fnc_returnParents)) then { _vehType = "ship"; };
	
	_grpVeh = createVehicle [_unitClass, _startingPos, [], 0, if (_vehType == "air") then {"FLY"} else {"NONE"}];
	private _dir = _grpVeh getDir _targetPos;
	_grpVeh setDir _dir;
	
	_isArmed = [_grpVeh] call zmm_fnc_misc_isArmed;
	private _fillVeh = if (_vehType in ["ship","air"] || !_isArmed || random 1 > 0.6) then { true } else { false };
					
	if (_vehType == "air") then {
		//_grpVeh setVelocity ((vectorNormalized (_targetPos vectorDiff _startingPos)) vectorMultiply 100);
		_grpVeh setVelocity [100 * (sin _dir), 100 * (cos _dir), 0];
		if (_isArmed && (count (fullCrew [_grpVeh, "cargo", true]) <= 4)) then { _fillVeh = false };
	};
	
	_mainGrp = [_grpVeh, _side, _fillVeh] call zmm_fnc_qrf_spawnCrew;
	_mainGrp setGroupIdGlobal [format["QRF_W%1_G%2", _id, _uid]];
	
	["DEBUG", format["W%1_G%2 - spawnGroup %3%4%5", _id, _uid, _unitClass, if (_fillVeh) then { " with inf" } else {""}, _startingPos]] call zmm_fnc_misc_logMsg;
	// Leave group as main if its unarmed, otherwise split them into a infantry group
	if _fillVeh then {
		{
			if (isNull _suppGrp) then {
				_suppGrp = createGroup [_side, true];
				_suppGrp setGroupIdGlobal [format["QRF_W%1_G%2_INF", _id, _uid]];
				_suppGrp addVehicle _grpVeh;
				_wp = _suppGrp addWaypoint [_targetPos, 50];
				_wp setWaypointType "GUARD";
			};
			[_x#0] joinSilent _suppGrp;
		} forEach ((fullCrew [_grpVeh, "cargo"]) + (if (count (fullCrew [_grpVeh, "turret"]) <= 4) then { [] } else { fullCrew [_grpVeh, "turret"] }));
	};
} else {
	["DEBUG", format["W%1_G%2 - spawnGroup %3", _id, _uid, _unitClass]] call zmm_fnc_misc_logMsg;
	_mainGrp = [_startingPos, _side, _unitClass] call BIS_fnc_spawnGroup;
	_mainGrp deleteGroupWhenEmpty true;
	_mainGrp setGroupIdGlobal [format["QRF_W%1_G%2", _id, _uid]];
		
	_vehArray = (units _mainGrp apply { assignedVehicle _x }) - [objNull];
	
	if (count (_vehArray arrayIntersect _vehArray) > 0) then {
		_grpVeh = (_vehArray arrayIntersect _vehArray)#0;
		_vehType = "car";
		_isArmed = [_grpVeh] call zmm_fnc_misc_isArmed;
		uiSleep 0.5;
		{ _x moveInAny _grpVeh; if (vehicle _x == _x) then { deleteVehicle _x } } forEach (units _mainGrp select { vehicle _x == _x });
	};
};

if (!isNull _grpVeh && (_vehType == "air" || (random 1 > 0.2 && _isArmed))) then { _grpVeh setVehicleLock "LOCKEDPLAYER" };

// Run custom init for vehicle (set camos etc).
if !(isNil "_customInit") then { 
	if !(_customInit isEqualTo "") then { call compile _customInit; };
};

{ _x addCuratorEditableObjects [[_grpVeh] + (units _mainGrp) + (units _suppGrp)] } forEach allCurators;

// *** UPS Marker was passed, so don't set any further waypoints. ***
if (_UPSMkr != "") exitWith { ([leader _mainGrp, _UPSMkr] + (if (_vehType == "man") then { ["RANDOM", "SHOWMARKER"] } else { ["SHOWMARKER"] })) spawn zmm_fnc_aiUPS };

// SET GROUP WAYPOINTS
switch (toLower _vehType) do {
	// INFANTRY ONLY
	case "man": {
		_wp = _mainGrp addWaypoint [_startingPos, 0];
		_wp setWaypointType "MOVE";
		_largestGrps = [allGroups select { isPlayer leader _x }, [], { count units _x }, "DESCEND"] call BIS_fnc_sortBy;
		[_mainGrp, _largestGrps#0, 10, 25] spawn BIS_fnc_stalk;
	};
	
	// BOAT VEHICLES
	case "ship": {
		private _hasInf = !isNull _suppGrp;
		
		_wp = _mainGrp addWaypoint [_startingPos, 0];
		_wp setWaypointSpeed "FULL";
		_wp setWaypointType "MOVE";
		
		// Armed with no cargo, nothing to dismount
		if (_isArmed && !_hasInf) exitWith {
			_wp = _mainGrp addWaypoint [_startingPos, 300];
			_wp setWaypointType "SAD";
			_mainGrp setCombatMode "RED";
			_wp = _mainGrp addWaypoint [_startingPos, 300];
			_wp setWaypointType "GUARD";
		};
		
		// Find a random point nearby for rough landing position
		private _beachPos = _targetPos getPos [300, random 360];
		for [{_i = 100}, {_i <= (_startingPos distance2D _beachPos)}, {_i = _i + 50}] do {			
			private _checkLand = _beachPos getPos [_i, _beachPos getDir _startingPos];
			if (surfaceIsWater _checkLand) exitWith { _beachPos = _checkLand };
		};
		
		_wp = _mainGrp addWaypoint [_beachPos, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointCompletionRadius 50;
		_wp setWaypointStatements ["true", "
			if (vehicle this == this|| !local this) exitWith {};
			(vehicle this) spawn {
				private _counter = 0;
				waitUntil { 
					sleep 1;
					_counter = _counter + 1;
					if (_counter >= 30) then {
						{
							if (alive _x) then { moveOut _x; unassignVehicle _x; [_x] orderGetIn false; _x allowFleeing 0; };
						} forEach (if ([_this] call zmm_fnc_misc_isArmed) then { (fullCrew [_this, 'cargo']) apply { _x#0 } } else { units _this });
					}; 
					count (fullCrew [_this, 'cargo']) == 0
				};
			};
		"];
					
		// If is armed with cargo just unload the cargo, otherwise everyone gets out.
		_wp = _mainGrp addWaypoint [_beachPos, 0];
		_wp setWaypointType (if _isArmed then { "TR UNLOAD" } else { "GETOUT" });
		_wp setWaypointCompletionRadius 50;
		
		if _isArmed then {
			_wp setWaypointStatements ["count (fullCrew [vehicle this, 'cargo']) == 0", format["
				if !(local this) exitWith{};
				if (random 1 < 0.4) then { [vehicle this, 'SmokeLauncher'] spawn BIS_fnc_fire; };
			", _startingPos]];
	
			_wp = _mainGrp addWaypoint [selectRandom _spawnArray, 50];
			_wp setWaypointSpeed "NORMAL";
			_wp setWaypointType "MOVE";
			
			_wp = _mainGrp addWaypoint [selectRandom _spawnArray, 50];
			_wp setWaypointType "MOVE";
			
			_wp = _mainGrp addWaypoint [selectRandom _spawnArray, 300];
			_wp setWaypointType "GUARD";
		} else {
			_wp = _mainGrp addWaypoint [_targetPos, 300];
			_wp setWaypointType "SAD";
			
			_wp = _mainGrp addWaypoint [_targetPos, 50];
			_wp setWaypointType "GUARD";
		};
		
		if _hasInf then {
			_wp = _suppGrp addWaypoint [_beachPos, 0];
			_wp setWaypointType "GETOUT";
			_wp setWaypointCompletionRadius 50;
				
			_wp = _suppGrp addWaypoint [_targetPos, 300];
			_wp setWaypointType "SAD";
			
			_wp = _suppGrp addWaypoint [_targetPos, 50];
			_wp setWaypointType "GUARD";
		};
	};
	
	// AIR VEHICLES
	case "air": {
		private _hasInf = !isNull _suppGrp;
		
		// Armed with no cargo, nothing to dismount
		if (_isArmed && !_hasInf) exitWith {
			_wp = _mainGrp addWaypoint [_targetPos, 200];
			_wp setWaypointType "SAD";
			_wp setWaypointCompletionRadius 500;
			_wp setWaypointBehaviour "AWARE";
			_wp = _mainGrp addWaypoint [_targetPos getPos [400, random 360], 200];
			_wp setWaypointType "LOITER";
			_wp setWaypointCompletionRadius 1000;
		};
		
		private _infPos = _targetPos;
		if _isArmed then {
			// Far unload WP for transport
			_infPos = _targetPos getPos [600, random 360];
			_wp = _mainGrp addWaypoint [_infPos, 50];
			_wp setWaypointType "TR UNLOAD";
			_wp setWaypointCompletionRadius 100;
		
			// Add tracking code for last WP completion
			_wp setWaypointStatements ["true", "
				if (vehicle this == this || !local this) exitWith {};
				(vehicle this) spawn {
					private _timeOut = time + 600;
					private _mainGrp = group effectiveCommander _this;
					_mainGrp setBehaviour 'AWARE';
					waitUntil {
						uiSleep 15;
						{ if (_mainGrp knowsAbout _x < 4) then { _mainGrp reveal [_x, 4] } } forEach (allPlayers select { _x distance2D leader _mainGrp < 2000 });
						time > _timeOut || (count units _mainGrp == 0 || !(alive vehicle _this));
					};
				};
			"];
			
			_wp = _mainGrp addWaypoint [_targetPos, 0];
			_wp setWaypointType "SAD";
			_wp setWaypointCompletionRadius 500;
			_wp setWaypointBehaviour "AWARE";
			_wp = _mainGrp addWaypoint [_targetPos getPos [400, random 360], 0];
			_wp setWaypointType "LOITER";
			_wp setWaypointCompletionRadius 800;
		} else {
			// Close unload WP
			_infPos = _targetPos getPos [400, random 360];
			_wp = _mainGrp addWaypoint [_infPos, 50];
			_wp setWaypointType "TR UNLOAD";
			_wp setWaypointCompletionRadius 100;
			//_wp setWaypointStatements ["((count fullCrew [vehicle this, 'cargo']) + (count fullCrew [vehicle this, 'turret'])) == 0", ""];
			
			private _farPos = _targetPos getPos [3000, random 360];
			_wp = _mainGrp addWaypoint [_farPos, 200];
			_wp setWaypointType "MOVE";
			_wp setWaypointSpeed "FULL";
			
			_wp = _mainGrp addWaypoint [_farPos, 50];
			_wp setWaypointType "MOVE";
			_wp setWaypointStatements ["true", "private _mainGrp = group this; private _veh = vehicle this; { deleteVehicle _x } forEach (crew _veh); deleteVehicle _veh; deleteGroup _mainGrp;"];
		};
		
		// Infantry WPs 
		if _hasInf then {
			_mainGrp setBehaviour "CARELESS";
			_wp = _suppGrp addWaypoint [_infPos, 0];
			_wp setWaypointType "GETOUT";
			_wp setWaypointCompletionRadius 200;
				
			_wp = _suppGrp addWaypoint [_targetPos, 300];
			_wp setWaypointType "SAD";
			
			_wp = _suppGrp addWaypoint [_targetPos, 50];
			_wp setWaypointType "GUARD";
		};
	};
	
	// ANY OTHER VEHICLE TYPES
	default {
		private _hasInf = !isNull _suppGrp;
		
		_wp = _mainGrp addWaypoint [_startingPos, 0];
		_wp setWaypointType "MOVE";
		
		// Armed with no cargo, nothing to dismount
		if (_isArmed && !_hasInf) exitWith {				
			if (random 1 > 0.3) then {
				_wp = _mainGrp addWaypoint [_targetPos, 100];
				_wp setWaypointType "SAD";
			};

			_wp = _mainGrp addWaypoint [_targetPos, 250];
			_wp setWaypointType "GUARD";
		};
		
		_wp = _mainGrp addWaypoint [_startingPos, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointSpeed selectRandom ["FULL","NORMAL","FULL"];
		
		private _radius = (if _hasInf then { 300 } else { if _isArmed then { 100 } else { 200 } }) + random 200;
		
		// If is armed with cargo just unload the cargo, otherwise everyone gets out.
		_wp = _mainGrp addWaypoint [_targetPos, 0];
		_wp setWaypointType (if _isArmed then { "TR UNLOAD" } else { "GETOUT" });
		_wp setWaypointCompletionRadius _radius;
		_wp setWaypointStatements ["count (fullCrew [vehicle this, 'cargo']) == 0", "if !(local this) exitWith{}; if (random 1 > 0.5) then { [vehicle this, 'SmokeLauncher'] spawn BIS_fnc_fire };"];

		_wp = _mainGrp addWaypoint [_targetPos, 200];
		_wp setWaypointType 'SAD';
		
		_wp = _mainGrp addWaypoint [_targetPos, 50];
		_wp setWaypointType "GUARD";
		
		if !(_isArmed) then { 
			_grpVeh setVehicleLock 'UNLOCKED' 
		};
		
		if _hasInf then {
			_wp = _suppGrp addWaypoint [_targetPos, 0];
			_wp setWaypointType "GETOUT";
			_wp setWaypointCompletionRadius _radius;
			
			_wp = _suppGrp addWaypoint [_targetPos, 300];
			_wp setWaypointType 'SAD';
			
			_wp = _suppGrp addWaypoint [_targetPos, 50];
			_wp setWaypointType 'GUARD';
		};
	};
};