if (!tg_debug) exitWith {};

params ["_missionName", "_missionType", ["_didWin", false, [false]]];

[format ["[TG] missionEnd: %1 (%2) called - Won: %3", _missionName, _missionType, _didWin]] call tg_fnc_debugMsg;

// Remove mission from running list.

// Wait for task thread to be free to edit active missions.
waitUntil{ sleep 5; tg_threadFree; };

// Stop any other tasks to be generated.
tg_threadFree = false;

// Locate the running mission.
private _foundIndex = ([tg_missions_active, _missionName] call BIS_fnc_findNestedElement) select 0;

[format ["[TG] missionEnd: Index of %1 (%2) in %3", _missionName, _foundIndex, tg_missions_active]] call tg_fnc_debugMsg;

if (_foundIndex >= 0) then {
	tg_missions_active deleteAt _foundIndex;
};

private _tgEnd = missionNamespace getVariable [format["tg_%1_end", _missionType],0];		// Complete game when 'tg_mainMission_cmp' = this is reached.
private _tgCmp = missionNamespace getVariable [format["tg_%1_cmp", _missionType],0];		// Counter of completions.

// Update the completed counter.
if (_didWin) then {
	_tgCmp = _tgCmp + 1;
	missionNamespace setVariable [format["tg_%1_cmp", _missionType], _tgCmp];
	[format ["[TG] missionEnd: %1 updating 'tg_%1_cmp' to %2", _missionType, _tgCmp]] call tg_fnc_debugMsg;
};

// Complete the task for players.
private _missionTask = missionNamespace getVariable format["%1_task", _missionName];
if (!isNil _missionTask) then {
	if (_didWin) then {
		[_missionTask, "Succeeded", true] spawn BIS_fnc_taskSetState;
	} else {
		[_missionTask, "Failed", true] spawn BIS_fnc_taskSetState;
	};
};

// Do we need to end the scenario?
if (_tgCmp >= _tgEnd && _tgEnd > 0) exitWith {
	[format ["[TG] missionEnd: %1 quitting scenario end-limit is %2, completed is %3", _missionType, _tgEnd, _tgCmp]] call tg_fnc_debugMsg;
	["End1"] call BIS_fnc_endMissionServer;
};

// Set global mission variable to true (allows units/zones to be removed)
missionNamespace setVariable [format["%1", _missionName], true];

tg_threadFree = true;

sleep tg_taskDelay + random tg_taskDelay;

// Call the mission selection function for a new mission.
[_missionType] spawn tg_fnc_missionSelect;
