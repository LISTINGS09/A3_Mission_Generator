// Should run at game start and is called after each completion.
// Will either end the scenario or spawn another task as appropriate.

// Iterate all types or only a passed type.
params [["_typeList", tg_missionTypes, [[],""]]];

// Wait for task thread to be free (prevents multiple tasks generating at once).
waitUntil{ sleep 5; tg_threadFree; };

// Stop any other tasks to be generated.
tg_threadFree = false;

// Convert to array if string was passed.
if (_typeList isEqualType "") then { _typeList = [_typeList]; };

{
	_missionType = _x;
	[format ["[TG-missionSelect] DEBUG: Start for %1 ", _missionType]] call tg_fnc_debugMsg;

	// Count of active tasks for a type.
	_missionCount = {(_x select 0) isEqualTo _missionType} count tg_missions_active;	
	
	/*
	// Max no missions to be active at any time.
	_missionMax = missionNamespace getVariable [format["tg_%1_max", _missionType], 0];		
	
	// Don't start a new task if we've reached the limit.
	if (_missionCount >= _missionMax) exitWith {
		[format ["[TG-missionSelect] DEBUG: Exit for %1 (%2 >= %3)", _missionType, _missionCount, _missionMax]] call tg_fnc_debugMsg;
	};*/
	
	// List all task scripts for the type.
	_missionList = missionNamespace getVariable format["tg_%1_list", _missionType];	
	
	// Spawn scripts while the number of current missions are below the required limit.
	for [{private _i = _missionCount}, {_i < (missionNamespace getVariable [format["tg_%1_max", _missionType], 0])}, {_i = _i + 1}] do {
		if (count _missionList == 0) exitWith {
			[format ["[TG-missionSelect] ERROR: 'tg_%1_list' has no listed missions.", _missionType]] call tg_fnc_debugMsg;
		};
			
		// Get a random script from the mission list.
		_chosenScript = selectRandom _missionList;
		
		// Remove the task so it won't get selected next run.
		_missionList = _missionList - [_chosenScript];
		missionNamespace setVariable [format["tg_%1_list", _missionType], _missionList];
		
		// Re-add the last played Task back onto the list.
		_lastRanMission = missionNamespace getVariable [format["tg_%1_last", _missionType], ""];	
		if (_lastRanMission != "") then {
			_missionList append [_lastRanMission];
		};
					
		// Update the last played mission so it can be re-added next time around.
		missionNamespace setVariable [format["tg_%1_last", _missionType], _chosenScript];
		
		// Execute the chosen mission.
		_missionName = format["%1_%2", _chosenScript, tg_counter];
		[format ["[TG-missionSelect] DEBUG: Running %1 from tg_%2_list", _chosenScript, _missionType]] call tg_fnc_debugMsg;
		_result = [_missionType, _missionName] call (missionNamespace getVariable format["%1", _chosenScript]);
		[format ["[TG-missionSelect] DEBUG: Completed %1 (%2)", _chosenScript, _result]] call tg_fnc_debugMsg;
		
		// Store the mission if it executed correctly.
		if (_result) then {
			tg_missions_active append [[_missionType, _missionName]];
		} else {
			_i = _i - 1;
		};
		
		// Increment the internal mission counter
		tg_counter = tg_counter + 1;
	};
	
	/*[format ["[TG-missionSelect] DEBUG: End Loop (Counter: %1, Cur: %2, Max: %3, Cmp: %4, End: %5)", 
		tg_counter, 
		{(_x select 0) isEqualTo _missionType} count tg_missions_active, 
		missionNamespace getVariable [format["tg_%1_max", _missionType],"-"],
		missionNamespace getVariable [format["tg_%1_cmp", _missionType],"-"],
		missionNamespace getVariable [format["tg_%1_end", _missionType],"-"]]
	] call tg_fnc_debugMsg;*/
		
} forEach _typeList;

// Allow any other tasks to be generated.
tg_threadFree = true;