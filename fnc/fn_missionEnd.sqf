if (!tg_debug) exitWith {};

params ["_missionName","_missionType",["_didWin",false,[false]]];

[format ["[TG-completeTask] DEBUG: %1 (%2) called - Won: %3", _missionName, _missionType, _didWin]] call tg_fnc_debugMsg;

// Remove mission from running list.

// Wait for task thread to be free to edit active missions.
waitUntil{ sleep 5; tg_threadFree; };

// Stop any other tasks to be generated.
tg_threadFree = false;

// Complete the task for players.
if (!isNil missionNamespace getVariable format["tg_task_%1", _missionName]) then {
	_missionTask = missionNamespace getVariable format["tg_task_%1", _missionName];
	_missionTask setTaskState "Succeeded"; 
};

// Locate the running mission.
//_foundIndex = tg_missions_active find _missionName;

_tgEnd = missionNamespace getVariable [format["tg_%1_end", _missionType],0];		// Complete game when 'tg_mainMission_cmp' = this is reached.
_tgCmp = missionNamespace getVariable [format["tg_%1_cmp", _missionType],0];		// Counter of completions.

// Update the completed counter.
if (_didWin) then {
	[format ["[TG-completeTask] DEBUG: %1 updating 'tg_%1_cmp' to %2", _missionType, _tgCmp]] call tg_fnc_debugMsg;
	missionNamespace setVariable [format["tg_%1_cmp", _missionType], _tgCmp + 1];
};

// Do we need to end the scenario?
if (_tgCmp >= _tgEnd && _tgEnd > 0) exitWith {
	[format ["[TG-completeTask] DEBUG: %1 quitting scenario end-limit is %2, completed is %3", _missionType, _tgEnd, _tgCmp]] call tg_fnc_debugMsg;
	["End1"] call BIS_fnc_endMissionServer;
};

// Set global mission variable to true (allows units/zones to be removed)
missionNamespace setVariable [format["tg_%1", _missionName], true];

tg_threadFree = true;

// Select a new mission.
[_missionType] spawn tg_fnc_missionSelect;
