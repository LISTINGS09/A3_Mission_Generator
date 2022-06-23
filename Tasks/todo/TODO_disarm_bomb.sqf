// Rescue pilots from a crashed plane.
// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];


_targetPos = getPos player;
private _key = createSimpleObject [selectRandom ["Land_ShellCrater_01_F","CraterLong_small"], AGLToASL _targetPos];
_key setDir random 360;

if (_targetPos distance (_targetPos nearestBuilding) < 15) then {
	{
		_x params ["_type", ["_class",""], ["_rel",[0,0,0]], ["_dir", 0], ["_flat", true]];
		private _worldPos = _key modelToWorld _rel;	
		private _obj = [_zoneID, _side, _type, _class, [_worldPos#0, _worldPos#1, _rel#2], getDir _key + _dir, _flat] call zmm_fnc_spawnObject;		
	} forEach [
		["S","Land_PlasticNetFence_01_short_F",[-4,-2,0],270],
		["S","Land_PlasticNetFence_01_short_d_F",[-3.875,2,0],270],
		["S","Land_PlasticNetFence_01_short_d_F",[3.875,-2,0],90],
		["S","Land_PlasticNetFence_01_long_d_F",[0,-4,0],180],
		["S","Land_PlasticBarrier_03_F",[5.25,3,0],75],
		["S","Land_PlasticNetFence_01_roll_F",[4.875,0,0],285],
		["S","Land_PlasticNetFence_01_long_d_F",[0,4,0],0],
		["S","Land_PlasticNetFence_01_pole_F",[4,4,0],0]
	];
};
_obj = createVehicle ["BombCluster_02_Ammo_F", [0,0,0], [], 0, "NONE"];
_obj enableSimulationGlobal false;
_obj setPos (_targetPos vectorAdd [0,0,0.75]);
_obj setVectorDirAndUp [[random 0.8 - 0.4, 1, -0.8], [random 0.8 - 0.4, 0, 0.8]];

private _childTrigger = createTrigger ["EmptyDetector", _ammoPos, false];
_childTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
_childTrigger setTriggerArea [3, 3, 5, false];
_childTrigger setTriggerStatements [ format["this", _zoneID, _i],
	format["['ZMM_%1_SUB_%2', 'Failed', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2';", _zoneID, _i],
	"" ];