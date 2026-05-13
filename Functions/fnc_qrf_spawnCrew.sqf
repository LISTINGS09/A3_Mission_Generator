// zmm_fnc_qrf_spawnCrew
params ["_veh", "_side", ["_inclueCargo", false], ["_maxCargo", 12]];

private _vehCfg = configFile >> "CfgVehicles" >> typeOf _veh;
private _difficulty = missionNamespace getVariable ["f_param_ZMMDiff", missionNamespace getVariable ["ZZM_Diff", 1]];

private _crewPositions = (fullCrew [_veh, "", true]) apply { _x#1 };

private _crewCount = count (_crewPositions select { _x in ["driver","gunner","commander","turret"] });

// Adjust for difficulty
_maxCargo = _maxCargo * _difficulty;

if (_inclueCargo) then { 
	private _cargoCount = count (_crewPositions select { _x in ["cargo"] });
	// Cap the max size of the cargo
	_crewCount = (count _crewPositions) + (_cargoCount min _maxCargo);
};

private _enemyMen = missionNamespace getVariable [format["ZMM_%1_Man",_side],["O_Soldier_F"]];

private _crew = [];	
for "_i" from 0 to (_crewCount - 1) do {
	_crew pushBack ( if (_i < 3) then { _enemyMen#0 } else { selectRandom _enemyMen } );
};

private _crewGrp = [[0,0,0], _side, _crew] call BIS_fnc_spawnGroup;

[_veh,[1, 0.8, 0.2]] remoteExec ["setVehicleTIPars"];
_crewGrp addVehicle _veh;	
{ _x moveInAny _veh } forEach units _crewGrp;

(driver _veh) assignAsDriver _veh;
(commander _veh) assignAsCommander _veh;
(gunner _veh) assignAsGunner _veh;

_crewGrp deleteGroupWhenEmpty true;
_crewGrp
