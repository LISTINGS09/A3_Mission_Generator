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
	[format["[TG] ERROR DACZone_Spawn: DAC init not specified for %1",_zoneName]] call tg_fnc_debugMsg;
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

// DAC can only spawn one zone at a time, wait until the previous is completed.
waitUntil{sleep 3; if (DAC_NewZone != 0) then {[format["[TG] DEBUG DACZone_Spawn: %1 waiting for DAC to finish (%2)", _zoneName, DAC_NewZone]] call tg_fnc_debugMsg;}; DAC_NewZone == 0; };

// Create the DAC Zone
[format["[TG] DEBUG DACZone_Spawn: NewZone: [%1, %2, %2, 0, 0, %3]", _zonePos, _size, [_zoneName] + _DACinit]] call tg_fnc_debugMsg;
[_zonePos, _size, _size, 0, 0, [_zoneName] + _DACinit] call DAC_fNewZone;

private _waitTime = 0;

// DEBUG - Sometimes DAC doesn't reset DAC_NewZone, how could it go so wrong?
// Looks like error was related to DAC_Init_Camps not resetting, or failure to find all suitable WP zones.
waitUntil{	sleep 5;
			_waitTime = _waitTime + 5; 
			if (DAC_NewZone != 0 && _waitTime >= 40 && _waitTime <= 60) then {
				[format["[TG] WARNING: DAC_fNewZone %1 has taken over %2 secs DAC_NewZone (%3) - DAC_Init_Camps (%4)", _zoneName, _waitTime, DAC_NewZone, DAC_Init_Camps]] call tg_fnc_debugMsg; 
			};
			if (DAC_NewZone != 0 && _waitTime > 60) then {
				[format["[TG] ERROR DACZone_Spawn: %1 Resetting - DAC_NewZone was %2, DAC_Init_Camps was %3", _zoneName, DAC_NewZone, DAC_Init_Camps]] call tg_fnc_debugMsg; 
				format["Warning: DAC (%1) - Report to 26K", _zoneName] remoteExec ["SystemChat"];
				DAC_NewZone = 0; 
			};
			DAC_NewZone == 0; 
		};

[_zoneName, _zonePos, _size, _removeExtras, _needsActivated]