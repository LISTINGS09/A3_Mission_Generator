// Should run at game start and is called after each completion.
// Will either end the scenario or spawn another task as appropriate.

// Iterate all types or only a passed type.
params [["_typeList", tg_missionTypes, [[],""]]];

// Convert to array if string was passed.
if (_typeList isEqualType "") then { _typeList = [_typeList]; };

{
	// Wait for task thread to be free (prevents multiple tasks generating at once).
	waitUntil{ sleep 5; tg_threadFree; };
	
	// Stop any other tasks to be generated.
	tg_threadFree = false;
	
	private _missionType = _x;
	
	// Count of active tasks for a type.
	private _missionCount = {(_x select 0) isEqualTo _missionType} count tg_missions_active;	

	// List all task scripts for the type.
	private _missionList = missionNamespace getVariable format["tg_%1_list", _missionType];	
	
	private _selectTry = 0;
	private _selectMaxTry = 15;
	
	// Spawn scripts while the number of current missions are below the required limit.
	for [{private _i = _missionCount}, {_i < (missionNamespace getVariable [format["tg_%1_max", _missionType], 0])}, {_i = _i + 1}] do {		
		if (count _missionList == 0) exitWith {
			[format ["[TG] ERROR: 'tg_%1_list' has no listed missions.", _missionType]] call tg_fnc_debugMsg;
		};
			
		// Get a random script from the mission list.
		private  _chosenScript = selectRandom _missionList;
		
		// Remove the task so it won't get selected next run.
		_missionList = _missionList - [_chosenScript];
		missionNamespace setVariable [format["tg_%1_list", _missionType], _missionList];
		
		// Re-add the last played Task back onto the list.
		private _lastRanMission = missionNamespace getVariable [format["tg_%1_last", _missionType], ""];	
		if (_lastRanMission != "") then {
			_missionList append [_lastRanMission];
		};
					
		// Update the last played mission so it can be re-added next time around.
		missionNamespace setVariable [format["tg_%1_last", _missionType], _chosenScript];
		
		// Execute the chosen mission.
		private _missionName = format["%1_%2", _chosenScript, tg_counter];
		private _missionResult = [_missionType, _missionName] call (missionNamespace getVariable format["%1", _chosenScript]);
		
		// Store the mission if it executed correctly.
		if (_missionResult) then {
			tg_missions_active append [[_missionType, _missionName]];
			tg_counter = tg_counter + 1;
			_selectTry = 0;
		} else {
			_i = _i - 1;
			_selectTry = _selectTry + 1;
			[format["[TG] DEBUG: %1 (%2) cancelled, try %3/%4", _missionName, _missionType, _selectTry, _selectMaxTry]] call tg_fnc_debugMsg;
		};
		
		if (_selectTry >= _selectMaxTry) exitWith {
			[format ["[TG] ERROR: Tried %1 times to find a '%2' - Aborting.", _selectTry, _missionType]] call tg_fnc_debugMsg;
		};
		
		// Increment the internal counters & allow any other tasks to be generated.
		tg_threadFree = true;
		
		sleep tg_taskDelay;
	};		
} forEach _typeList;