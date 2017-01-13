// Checks if a mission is active within distance '_chkDist' of the position '_nearPos'.
// Used to prevent objectives from appearing where missions are already running.

params [["_nearPos", [], [[]]], ["_missionType", tg_missionTypes, [[],""]], "_overrideDist"];

if (_missionType isEqualType "") then {
	_missionType = [_missionType];
};

_isNear = false;

// Loop through all current missions to see if they're near.
{	
	_actMissionType = _x select 0;
	_actMissionPos = getMarkerPos format["%1_marker", _x select 1];
	
	if (!isNil "_actMissionPos" && _actMissionType in _missionType) then {
		_chkDist = missionNamespace getVariable [format["tg_%1_dist", _actMissionType], 1];

		if (!isNil "_overrideDist") then {
			_chkDist = _overrideDist;
		};

		if (_nearPos distance2D _actMissionPos < _chkDist) exitWith {
			_isNear = true;
		};
	};
} forEach tg_missions_active;

//[format["[TG] fn_isNearMission: %1", _isNear]] call tg_fnc_debugMsg;

_isNear