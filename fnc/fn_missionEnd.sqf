// Remove mission from running list.
if !isServer exitWith {};

params ["_missionName", "_missionType", ["_didWin", false, [false]]];

// Complete the task for players.
private _missionTask = missionNamespace getVariable format["%1_task", _missionName];
if (!isNil _missionTask) then {
	if (_didWin) then {
		[_missionTask, "Succeeded", true] spawn BIS_fnc_taskSetState;
	} else {
		[_missionTask, "Failed", true] spawn BIS_fnc_taskSetState;
	};
};

private _tgEnd = missionNamespace getVariable [format["tg_%1_end", _missionType],0];		// Complete game when 'tg_mainMission_cmp' = this is reached.
private _tgCmp = missionNamespace getVariable [format["tg_%1_cmp", _missionType],0];		// Counter of completions.

// Update the completed counter.
if (_didWin) then {
	_tgCmp = _tgCmp + 1;
	missionNamespace setVariable [format["tg_%1_cmp", _missionType], _tgCmp];
	[format ["[TG] DEBUG: (fn_missionEnd) %1 updating 'tg_%1_cmp' to %2", _missionType, _tgCmp]] call tg_fnc_debugMsg;
};

// Do we need to end the scenario?
if (_tgCmp >= _tgEnd && _tgEnd > 0) exitWith {
	[format ["[TG] DEBUG: (fn_missionEnd) %1 quitting scenario end-limit is %2, completed is %3", _missionType, _tgEnd, _tgCmp]] call tg_fnc_debugMsg;
	["End1"] call BIS_fnc_endMissionServer;
};

// Wait for task thread to be free to edit active missions.
waitUntil{ sleep 5; if tg_threadActive then { [format["[TG] DEBUG: (fn_missionEnd) %1 (Type: %2) waiting for free thread (%3).", _missionName, _missionType, tg_threadLockedBy]] call tg_fnc_debugMsg; }; !tg_threadActive; };

// Stop any other tasks to be generated.
tg_threadActive = true;
tg_threadLockedBy = format["Ending %1",_missionName];

// Locate the running mission.
private _foundIndex = ([tg_missions_active, _missionName] call BIS_fnc_findNestedElement) select 0;

//[format ["[TG] DEBUG: (fn_missionEnd) Index of %1 (%2) in %3", _missionName, _foundIndex, tg_missions_active]] call tg_fnc_debugMsg;

if (_foundIndex >= 0) then {
	tg_missions_active deleteAt _foundIndex;
};

// Set global mission variable to true (allows units/zones to be removed)
missionNamespace setVariable [format["%1", _missionName], true];

tg_threadActive = false;
tg_threadLockedBy = "-";

sleep tg_taskDelay + random tg_taskDelay;

// Call the mission selection function for a new mission.
[_missionType] spawn tg_fnc_missionSelect;
