if !isServer exitWith {};

scriptName "paradrop.sqf";

params [["_location", [0,0,0]], ["_side", EAST]];

private _man = missionNamespace getVariable [format["ZMM_%1Man",_side],["O_Soldier_F"]];
private _vehicle = selectRandom (missionNamespace getVariable [format["ZMM_%1Veh_CasH",_side], (missionNamespace getVariable [format["ZMM_%1Veh_Cas",_side],[]])]);

sleep random 30;

private _groupMax = 99; // Maximum para groups
private _groupSize = 8; // Units number per para group

_startPos = _location getPos [3000, random 360];

// Split out init from class.
private _customInit = "";
if (_vehicle isEqualType []) then { _customInit = _vehicle # 1; _vehicle = _vehicle # 0 };

private _grpVeh = createVehicle [_vehicle, _startPos, [], 0, "FLY"];
private _dirTo =  _grpVeh getDir _location;
private _dirFrom =  (_grpVeh getDir _location) + 180;
_grpVeh setDir _dirTo;
//_grpVeh flyInHeight 200;

// Run custom init for vehicle (set camos etc).
if !(isNil "_customInit") then { 
	if !(_customInit isEqualTo "") then { call compile _customInit; };
};

createVehicleCrew _grpVeh;
(group effectiveCommander _grpVeh) deleteGroupWhenEmpty true;

// Convert crew if using another sides vehicle.
if (([getNumber (configFile >> "CfgVehicles" >> _vehicle >> "Side")] call BIS_fnc_sideType) != _side) then {
	_grp = createGroup [_side, true];
	(crew _grpVeh) join _grp;
};

private _grp = group effectiveCommander _grpVeh;

// Find the number of seats we can hold
private _cargoMax = ([_vehicle, true] call BIS_fnc_crewCount) - ([_vehicle, false] call BIS_fnc_crewCount);

if (_cargoMax < 1) exitWith { _grpVeh setDamage [1, false] };

// Create Para Group
private _paraList = [];
private _cargoLeft = _cargoMax;

// Work out how many groups we can have without overfilling the vehicle.
for [{_i = 0}, {_i <= ceil (_cargoMax / _groupSize)}, {_i = _i + 1}] do {
	if (_cargoLeft - _groupSize >= _groupSize) then {
		_paraList set [_i,_groupSize];
	} else {
		// Only part of a group can be added, if its worth adding include it.
		if (_cargoLeft > 2) then {
			_paraList set [_i,_groupSize];
		};
	};
	
	_cargoLeft = _cargoLeft - _groupSize;
};

// If there are more groups than allowed, remove them.
if (count _paraList > _groupMax) then { _paraList resize _groupMax };

// Create the groups and store them in a variable
private _grpVehVar = [];
private _grpVehCount = 0;

{
	private _paraUnits = [];	
	for [{_i = 1}, {_i <= _x}, {_i = _i + 1}] do { _paraUnits pushBack (selectRandom _man) };

	_grpPara = [[0,0,0], _side, _paraUnits] call BIS_fnc_spawnGroup;

	{ _x moveInAny _grpVeh } forEach units _grpPara;
	
	_wp = _grpPara addWaypoint [_location, 0];
	_wp setWaypointType 'SAD';
	_wp = _grpPara addWaypoint [_location, 0];
	_wp setWaypointType 'GUARD';
	
	sleep 0.5;

	_grpVehVar pushBack _grpPara;
	
	_grpVehCount = _grpVehCount + _x;
} forEach _paraList;

_grpVeh setVariable ['var_dropGroup', _grpVehVar];

// Set pilot wayPoints
_wp = _grp addWaypoint [_startPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointSpeed "FULL";
_wp setWaypointBehaviour "CARELESS";
_wp setWaypointStatements ["true","(vehicle this) setPilotLight true;"];

// Set Pilots wayPoints

private  _dropStart = _location getPos [_grpVehCount * 25, _dirFrom];
private _tmp = createMarkerLocal ["dropStart", _dropStart];
_tmp setMarkerTypeLocal "mil_dot";
_tmp setMarkerTextLocal "Start";

_wp = _grp addWaypoint [_dropStart, 0];
_wp setWaypointType "MOVE";
_wp setWaypointStatements ["true","
	(vehicle this) spawn {
		{
			{
				unassignVehicle _x;
				[_x] orderGetIn false;
				moveOut _x; 
				sleep 0.5;
				_pc = createVehicle ['Steerable_Parachute_F', (getPosATL _x), [], 0, 'NONE'];
				_pc setPosATL (getPosatl _x);
				_vel = velocity _pc;
				_dir = random 360;
				_pc setVelocity [(_vel#0) + (sin _dir * 10),  (_vel#1) + (cos _dir * 10), (_vel#2)];
				_x moveinDriver _pc;
			} forEach (units _x);
			sleep 1;
		} forEach (_this getVariable ['var_dropGroup',[]]);
	};
"];

private _dropDelete = _location getPos [3000, _dirTo];
_wp = _grp addWaypoint [_dropDelete, 0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 500;
_wp setWaypointStatements ["true","_delVeh = (vehicle this); { deleteVehicle (_x#0) } forEach (fullCrew _delVeh); deleteVehicle _delVeh; deleteGroup (group this);"];