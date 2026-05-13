// zmm_fnc_qrf_spawnPara from QRF
params [["_targetPos", [0,0,0]], ["_spawnArray", []], ["_side", EAST], ["_veh", ""]];

private _enemyMen = missionNamespace getVariable [format["ZMM_%1_Man",_side],["O_Soldier_F"]];
private _wave = missionNamespace getVariable ["ZQR_wave", 0];
private _uid = (missionNamespace getVariable ["ZQR_count", 0]) + 1;	
ZQR_count = _uid;

private _groupMax = 99; // Maximum para groups
private _groupSize = 8; // Units number per para group
private _startPos = selectRandom _spawnArray;
_startPos set [2, 500];

// Split out init from class.
private _customInit = "";
if (_veh isEqualType []) then { _customInit = _veh#1; _veh = _veh#0 };

["DEBUG", format["W%1_G%2 - spawnPara %3", _wave, _uid, _veh]] call zmm_fnc_misc_logMsg;

private _grpVeh = createVehicle [_veh, _startPos, [], 0, "FLY"];
private _dirTo =  _grpVeh getDir _targetPos;
private _dirFrom =  (_grpVeh getDir _targetPos) + 180;
_grpVeh setDir _dirTo;
_grpVeh setVehicleLock "LOCKEDPLAYER";

// Find the number of seats we can hold
private _cargoMax = fullCrew [_veh, "cargo", true];

if (_cargoMax < 1) exitWith { deleteVehicle _grpVeh };

// Run the custom init 
if !(isNil "_customInit") then { if !(_customInit isEqualTo "") then { call compile _customInit; } };

private _grpPilot = [_grpVeh, _side] call zmm_fnc_ai_spawnCrew;

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
	for [{_i = 1}, {_i <= _x}, {_i = _i + 1}] do { _paraUnits pushBack (selectRandom _enemyMen) };

	_grpPara = [[0,0,0], _side, _paraUnits] call BIS_fnc_spawnGroup;
	_grpPara deleteGroupWhenEmpty true;
	_grpPara setGroupIdGlobal [format["QRF_W%1_G%2_PARA%3", _wave, _uid, _forEachIndex]];

	{ _x moveInAny _grpVeh } forEach units _grpPara;
	
	_wp = _grpPara addWaypoint [_targetPos, 0];
	_wp setWaypointType 'SAD';
	_wp = _grpPara addWaypoint [_targetPos, 0];
	_wp setWaypointType 'GUARD';

	sleep 0.5;
	
	_grpVehCount = _grpVehCount + _x;
} forEach _paraList;

// Set pilot wayPoints
_wp = _grpPilot addWaypoint [_startPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointSpeed "FULL";
_wp setWaypointBehaviour "CARELESS";
_wp setWaypointStatements ["true","(vehicle this) setCollisionLight true;"];

// Set Pilots wayPoints
private  _dropStart = _targetPos getPos [_grpVehCount * 25, _dirFrom];
/*private _tmp = createMarkerLocal ["dropStart", _dropStart];
_tmp setMarkerTypeLocal "mil_dot";
_tmp setMarkerTextLocal "Drop Start";*/

_wp = _grpPilot addWaypoint [_dropStart, 0];
_wp setWaypointType "MOVE";
_wp setWaypointStatements ["true","
	(vehicle this) spawn {
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
		} forEach ((crew _this) select { group driver _this != group _x });
	};
"];

if (([_grpVeh] call zmm_fnc_misc_isArmed) && random 1 > 0.7) then {
	_grpPilot setGroupIdGlobal [format["QRF_W%1_G%2_CREW", _wave, _uid]];
	_wp = _grpPilot addWaypoint [_targetPos, 0];
	_wp setWaypointType "SAD";
	_wp setWaypointCompletionRadius 300;
	_wp setWaypointBehaviour "AWARE";
	_wp = _grpPilot addWaypoint [_targetPos, 1];
	_wp setWaypointType "LOITER";
	_wp setWaypointCompletionRadius 500;
} else {
	private _dropDelete = _targetPos getPos [3000, _dirTo];
	_wp = _grpPilot addWaypoint [_dropDelete, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius 500;
	_wp setWaypointStatements ["true","private _mainGrp = group this; private _veh = vehicle this; { deleteVehicle _x } forEach (crew _veh); deleteVehicle _veh; deleteGroup _mainGrp;"];
};