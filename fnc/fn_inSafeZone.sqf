// PARAMS
// _pos		ARRAY		Position to check if is in safe zone.
//
// RETURNS
// True/False if point is in zone or not

params ["_pos"];

_return = false;

if (isNil "tg_blackList_markers") then { tg_blackList_markers = []; };

if (count _pos < 2 || count tg_blackList_markers == 0) exitWith { 
	_return
};

_pos = [ _pos select 0, _pos select 1, 0];

// Scan the list and check if present inside zone.
{
	if (_pos inArea _x) exitWith { _return = true };
} forEach tg_blackList_markers;

//[format["[TG] DEBUG (isSafeZone): Position: %1 vs %2 (%3)", _pos, _return]] call tg_fnc_debugMsg;

_return