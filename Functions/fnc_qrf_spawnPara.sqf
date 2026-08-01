// [] call zmm_fnc_qrf_spawnPara;
// zmm_fnc_qrf_spawnPara from QRF
params [
	["_zoneID", 0],
	["_targetPos", (getPos selectRandom (allPlayers select { alive _x }))],
	["_spawnArray", []],
	["_side", CIVILIAN],
	["_veh", ""]
];

if (_side isEqualTo CIVILIAN && !isNil "zmm_fnc_misc_findEnemySide") then { _side = [_targetPos] call zmm_fnc_misc_findEnemySide } else { _side = EAST };
if (_veh isEqualTo "") then { 
	private _vehArray = missionNamespace getVariable [format["ZMM_%1_Air",_side],[]];
	
	_veh = if (count _vehArray > 0) then {
		selectRandom _vehArray;
	} else {
		["O_Heli_Light_02_unarmed_F","B_Heli_Transport_01_F","I_Heli_light_03_unarmed_F"] select (_side call BIS_fnc_sideID);
	};
};

if (_spawnArray isEqualTo []) then { _spawnArray = [_targetPos getPos [3000, random 360]] };

private _enemyMen = missionNamespace getVariable [format["ZMM_%1_Man",_side], [(["O_Soldier_F","B_Soldier_F","I_Soldier_F"] select (_side call BIS_fnc_sideID))]];

private _id = missionNamespace getVariable [format["ZQR_%1_Wave", _zoneID], 0];
private _num = (missionNamespace getVariable [format["ZQR_%1_Count", _zoneID], 0]) + 1;	
missionNamespace setVariable [format["ZQR_%1_Count", _zoneID], _num];

private _gid = format["W%1_G%2", _id, _num];
if (_zoneID > 0) then { _gid = format["Z%1_%2", _zoneID, _gid] };

private _groupMax = 99; // Maximum para groups
private _groupSize = 8; // Units number per para group
private _startPos = selectRandom _spawnArray;
private _flyHeight = 100 + (selectRandom [0,100]);

// Split out init from class.
private _customInit = "";
if (_veh isEqualType []) then { _customInit = _veh#1; _veh = _veh#0 };

["DEBUG", format["%1 - spawnPara %2", _gid, _veh]] call zmm_fnc_misc_logMsg;

_startPos set [2, _flyHeight];
private _grpVeh = createVehicle [_veh, _startPos, [], 0, "FLY"];
private _dirTo = _startPos getDir _targetPos;
private _dirFrom = _dirTo + 180;
private _isArmed = [_grpVeh] call zmm_fnc_misc_isArmed;
_grpVeh setDir _dirTo;
_grpVeh setVehicleLock "LOCKEDPLAYER";

// Find the number of seats we can hold
private _cargoMax = count (fullCrew [_grpVeh, "cargo", true]);

// Run the custom init 
if !(isNil "_customInit") then { if !(_customInit isEqualTo "") then { call compile _customInit; } };

([_grpVeh, _side, true] call zmm_fnc_qrf_spawnCrew) params ["_grpPilot", ["_grpCargo",[]]];

//["DEBUG", format["%1 - spawnPara %2 - GP:%3 GC:%4", _gid, _veh, count units _grpPilot, count _grpCargo]] call zmm_fnc_misc_logMsg;

private _doDelete = false;
if (count _grpCargo == 0 && !_isArmed) then {
    // No cargo groups: split pilot group into vehicle crew and infantry cargo
    private _cargoUnits = (units _grpPilot) select { _x != commander _grpVeh && _x != driver _grpVeh && _x != gunner _grpVeh };

    // Need enough infantry to make a cargo group
    if (count _cargoUnits >= 4) then {
        private _cargoGrp = createGroup [_side, true];
        { [_x] joinSilent _cargoGrp } forEach _cargoUnits;
        _grpCargo pushBack _cargoGrp;
    } else {
		_doDelete = true
    };
} else {
	if (count _grpCargo > 1) then {
		private _validCargo = [];
		// Remove undersized cargo groups
		{
			if (count units _x < 4) then {
				{ deleteVehicle _x } forEach units _x;
				deleteGroup _x;
			} else {
				_validCargo pushBack _x;
			};

		} forEach _grpCargo;
		_grpCargo = _validCargo;
	};
};

if (_doDelete) exitWith {
	["WARNING", format["%1 - spawnPara %2 DELETED - Does not have enough cargo", _gid, _veh]] call zmm_fnc_misc_logMsg;
	{ deleteVehicle _x } forEach (crew _grpVeh);
	deleteVehicle _grpVeh;
	deleteGroup _grpPilot;
	false
};

{
	_x setGroupIdGlobal [format["QRF_%1_PARA%2", _gid, _forEachIndex]];
	private _wp = _x addWaypoint [_targetPos, 0];
	_wp setWaypointType 'SAD';
	_wp = _x addWaypoint [_targetPos, 0];
	_wp setWaypointType 'GUARD';
} forEach _grpCargo;

// Set pilot wayPoints
_wp = _grpPilot addWaypoint [_startPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointSpeed "FULL";
_wp setWaypointBehaviour "CARELESS";
_wp setWaypointStatements ["true","(vehicle this) setCollisionLight true;"];

// Set Pilots wayPoints
//_grpVeh flyInHeight _flyHeight;
private  _dropStart = _targetPos getPos [_cargoMax * 30, _dirFrom];
//private _tmp = createMarkerLocal ["dropStart", _dropStart];
//_tmp setMarkerTypeLocal "mil_dot";
//_tmp setMarkerTextLocal "Drop Start";

_wp = _grpPilot addWaypoint [_dropStart, 0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 25;
_wp setWaypointSpeed "FULL";
_wp setWaypointBehaviour "CARELESS";
_wp setWaypointStatements ["true","
	if (!local this) exitWith {};
	(vehicle this) spawn {
		{
			unassignVehicle _x;
			[_x] orderGetIn false;
			[_x] allowGetIn false;
			moveOut _x;
			sleep 0.5;
			private _pc = createVehicle ['Steerable_Parachute_F', (getPosATL _x), [], 0, 'NONE'];
			_pc setPosATL (getPosatl _x);
			private _vel = velocity _pc;
			private _dir = random 360;
			_pc setVelocity [(_vel#0) + (sin _dir * 10),  (_vel#1) + (cos _dir * 10), (_vel#2)];
			_x moveinDriver _pc;
		} forEach ((crew _this) - (units group driver _this));
	};
"];

if (_isArmed && random 1 > 0.65) then {
	_grpPilot setGroupIdGlobal [format["QRF_%1_CREW", _gid]];
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
	_wp setWaypointCompletionRadius 200;
	_wp setWaypointSpeed "FULL";
	_wp setWaypointBehaviour "CARELESS";
	_wp setWaypointStatements ["true","private _mainGrp = group this; private _veh = vehicle this; { deleteVehicle _x } forEach (crew _veh); deleteVehicle _veh; deleteGroup _mainGrp;"];
};

true