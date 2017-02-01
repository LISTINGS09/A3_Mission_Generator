// _missionName	STRING		Mission this is related to - Trigger will be created to DELETE the zone when this is TRUE (i.e. done)
// _part		STRING		Unique name for the DAC Zone itself.
// _zonePos	ARRAY		Position of the 
// _size		INThe		Size of the DAC Zone (+300 for the trigger).
// _DACinit		ARRAY		DAC Init array.

params [["_missionSide", civilian, [civilian]], ["_missionName","",[""]], ["_part","",[""]], "_zonePos", ["_size",500,[0]], "_DACinit", ["_addMarker", false, [false]]];

private _zoneName = format["%1_%2", _missionName, _part];
private _timeOut = 5;
private _removeExtras = "";

// Check something isn't badly wrong.
if (isNil "_DACinit") exitWith {
	["[TG] DAC init not specified (%1)",_zoneName] call bis_fnc_error;
};

// If a string was passed, convert it to a side.
if (_missionSide isEqualType "") then {
	_missionSide = switch (toLower _missionSide) do {
		case "west": { west };
		case "east": { east };
		case "guer": { independent };
		default { civilian };
	};
};

// Add a marker for the zone if required.
if (_addMarker) then {
	private _zoneMarker = createMarker [format["%1_marker", _zoneName], _zonePos];
	_zoneMarker setMarkerShape "ELLIPSE";
	_zoneMarker setMarkerSize  [_size + (_size / 100 * 25), _size + (_size / 100 * 25)];
	_zoneMarker setMarkerColor ([_missionSide, true] call BIS_fnc_sideColor);
	_zoneMarker setMarkerBrush  "Border";
	
	// Store marker and allow it to be deleted after completion.										
	_removeExtras = format["deleteMarker '%1_marker'; ", _zoneName];
};

private _needsActivated = if ((_DACinit select 0) select 1 == 1) then {true} else {false};
// (_DACinit select 0) set [1,0]; // DEBUG: Set the zone as active regardless.

// DAC can only spawn one zone at a time, wait until the previous is completed.
waitUntil{sleep 1; DAC_NewZone == 0; };

// Create the DAC Zone
[format["[TG] DEBUG DACZone_Spawn: NewZone: [%1, %2, %2, 0, 0, %3]", _zonePos, _size, [_zoneName] + _DACinit]] call tg_fnc_debugMsg;
[_zonePos, _size, _size, 0, 0, [_zoneName] + _DACinit] call DAC_fNewZone;
/*
private _waitTime = 0;
private _waitTimeMax = ((_size / 100) * 8); // Estimate the time to wait roughly before forcing closure of the zone.
if (_waitTimeMax < 40) then { _waitTimeMax = 40 };
if (_waitTimeMax > 80) then { _waitTimeMax = 80 };

// DEBUG - Sometimes DAC doesn't reset DAC_NewZone, how could it go so wrong?
// Looks like error was related to DAC_Init_Camps not resetting, or failure to find all suitable WP zones.
waitUntil{	sleep 1;
			_waitTime = _waitTime + 1; 
			if (DAC_NewZone != 0 && (_waitTime mod 5 == 0) && _waitTime > 10 && _waitTime <= _waitTimeMax) then {
				[format["[TG] WARNING: DAC_fNewZone %1 taken %2/%3 (IC:%4 CR:%5 MI:%6)", _zoneName, _waitTime, _waitTimeMax, DAC_Init_Counter, DAC_InCreate, DAC_Master_Init]] call tg_fnc_debugMsg; 
			};
			if (DAC_NewZone != 0 && _waitTime > _waitTimeMax) then {
				["[TG] DAC Zone killed after %2s ('%1' IC: %3 MI: %4)", _zoneName, _waitTimeMax, DAC_Init_Counter, DAC_Master_Init] call bis_fnc_error;
				DAC_NewZone = 0; 
			};
			DAC_NewZone == 0; 
		};
*/
[_zoneName, _zonePos, _size, _removeExtras, _needsActivated]