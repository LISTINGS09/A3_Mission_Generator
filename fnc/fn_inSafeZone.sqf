// PARAMS
// _pos		ARRAY		Position to check if is in safe zone.
//
// RETURNS
// True/False if point is in zone or not

params ["_pos"];

_return = false;

if (isNil "tg_blackList") then { tg_blackList = []; };

if (count _pos < 1 || count tg_blackList == 0) exitWith { 
	[format["[TG-isSafeZone] WARNING: Position: %1 SafeZones: %2", _pos, count tg_blackList]] call tg_fnc_debugMsg;
	_return
};

_posX = _pos select 0;
_posY = _pos select 1;

// Scan the list and check if present inside zone.
{
	if ((_posX >= ((_x select 0) select 0) && _posX <= ((_x select 1) select 0)) && 
	(_posY >= ((_x select 0) select 1) && _posY <= ((_x select 1) select 1))) exitWith { _return = true };
} forEach tg_blackList;

_return