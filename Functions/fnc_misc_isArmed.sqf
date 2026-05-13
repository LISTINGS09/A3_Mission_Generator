// zmm_fnc_misc_isArmed 
params ["_veh"];

if (isNil "_veh" || {isNull _veh}) exitWith { false };

private _weapCount = 0;

{
	_weapCount = _weapCount + count ((_veh weaponsTurret _x) select { 
		!(
			"dispenser" in toLower _x ||
			"fcs" in toLower _x ||
			"flare" in toLower _x ||
			"horn" in toLower _x ||
			"laser" in toLower _x ||
			"safe" in toLower _x ||
			"smoke" in toLower _x
		)
	})
} forEach [[-1]] + allTurrets _veh;

_weapCount > 0
