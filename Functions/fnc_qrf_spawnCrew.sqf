// zmm_fnc_qrf_spawnCrew
params [
	"_veh",
	"_side",
	["_includeCargo", false],
	["_cargoGroupMax", 8]
];

private _difficulty = missionNamespace getVariable [ "f_param_ZMMDiff", missionNamespace getVariable ["ZZM_Diff", 1]];
private _crewPositions = fullCrew [_veh, "", true];
private _vehicleCrewSeats = _crewPositions select { (_x # 1) in ["driver", "gunner", "commander", "turret"] };
private _cargoSeats = _crewPositions select { (_x # 1) isEqualTo "cargo" };
private _crewCount = count _vehicleCrewSeats;
private _enemyMen = missionNamespace getVariable [ format ["ZMM_%1_Man", _side], [(["O_Soldier_F","B_Soldier_F","I_Soldier_F"] select (_side call BIS_fnc_sideID))]];
private _spawnPos = _veh getPos [5, random 360];

// MAIN VEHICLE CREW
private _crewUnits = [];

for "_i" from 0 to (_crewCount - 1) do {
	_crewUnits pushBack ( if (_i < 3) then { _enemyMen # 0 } else { selectRandom _enemyMen } );
};

private _crewGrp = [ _spawnPos, _side, _crewUnits ] call BIS_fnc_spawnGroup;

_crewGrp addVehicle _veh;

{ _x moveInAny _veh } forEach units _crewGrp;

if !(isNull driver _veh) then { (driver _veh) assignAsDriver _veh };
if !(isNull commander _veh) then { (commander _veh) assignAsCommander _veh };
if !(isNull gunner _veh) then { (gunner _veh) assignAsGunner _veh };

_crewGrp deleteGroupWhenEmpty true;

// CARGO GROUPS
private _cargoGroups = [];

if (_includeCargo && {count _cargoSeats > 0}) then {
	private _cargoRemaining = count _cargoSeats;
	private _groupSizeMax = round (_cargoGroupMax * _difficulty) max 1;

	while { _cargoRemaining > 0 } do {
		private _groupSize = _cargoRemaining min _groupSizeMax;
		private _cargoUnits = [];

		for "_i" from 1 to _groupSize do { _cargoUnits pushBack (selectRandom _enemyMen) };

		private _cargoGrp = [_spawnPos, _side, _cargoUnits] call BIS_fnc_spawnGroup;

		_cargoGrp addVehicle _veh;
		{ _x moveInCargo _veh } forEach units _cargoGrp;

		_cargoGrp deleteGroupWhenEmpty true;
		_cargoGroups pushBack _cargoGrp;
		_cargoRemaining = _cargoRemaining - _groupSize;

		{ _x addCuratorEditableObjects [units _cargoGrp] } forEach allCurators;
	};
};

[_veh, [1,0.8,0.2]] remoteExec ["setVehicleTIPars"];
{ _x addCuratorEditableObjects [[_veh] + (units _crewGrp)] } forEach allCurators;

["DEBUG", format["spawnCrew - %1 - %2 cargo groups", typeOf _veh, count _cargoGroups]] call zmm_fnc_misc_logMsg;

[_crewGrp, _cargoGroups]