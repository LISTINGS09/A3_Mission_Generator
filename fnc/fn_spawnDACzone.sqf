// _missionName	STRING		Mission this is related to - Trigger will be created to DELETE the zone when this is TRUE (i.e. done)
// _part		STRING		Unique name for the DAC Zone itself.
// _zonePos	ARRAY		Position of the 
// _size		INThe		Size of the DAC Zone (+300 for the trigger).
// _DACinit		ARRAY		DAC Init array.

params [["_missionSide", west, [west]], ["_missionName","",[""]], ["_part","",[""]], "_zonePos", ["_size",500,[0]], "_DACinit", ["_addMarker", false, [false]]];

_zoneName = format["%1_%2", _missionName, _part];
_timeOut = 5;
_removeExtras = "";

// Check something isn't badly wrong.
if (!isNil (missionNamespace getVariable format["TR_%1", _zoneName])) exitWith {
	[format["[TG] ERROR: Trigger 'TR_%1' already exists. DAC Zone names must be unique!",_zoneName]] call tg_fnc_debugMsg;
};

if (isNil "_DACinit") exitWith {
	[format["[TG] ERROR: DAC init not specified for %1",_zoneName]] call tg_fnc_debugMsg;
};

// DAC can only spawn one zone at a time, wait until the previous is completed.
waitUntil{sleep 2 + random 5; DAC_NewZone == 0;};

// DAC is set to start inactive, spawn a trigger to activate it.
if ((_DACinit select 0) select 1 == 1) then {
	_initTrigger = createTrigger ["EmptyDetector", _zonePos, false];
	_initTrigger setTriggerTimeout [0, 0, 0, false];
	_initTrigger setTriggerArea [2000, 2000, 0, true, 100];
	_initTrigger setTriggerActivation [format["%1", tg_playerSide], "PRESENT", true];
	
	// Only fire the trigger/DACzones if the mission has not been completed.
	_initTrigger setTriggerStatements [	format["!(missionNamespace getVariable ['%1',false]) && this", _missionName], 
										format["[] spawn {waitUntil{sleep 3; DAC_NewZone == 0;}; if !(missionNamespace getVariable ['%2',false]) then { [%1] call DAC_Activate;}; };", _zoneName, _missionName],
										format["[] spawn {waitUntil{sleep 3; DAC_NewZone == 0;}; if !(missionNamespace getVariable ['%2',false]) then { [%1] call DAC_Deactivate; }; };", _zoneName, _missionName]];
										//format["[%1] call DAC_Deactivate;", _zoneName]]; // DAC doesn't always re-activate a deactivated zone correctly!

	// Store trigger and allow it to be deleted after completion.										
	missionNamespace setVariable [format["TR_%1_toggle", _zoneName], _initTrigger];
	_removeExtras = format["deleteVehicle TR_%1_toggle; ", _zoneName];
};

// Add a marker for the zone.
if (_addMarker) then {
	_zoneMarker = createMarker[format["%1_marker", _zoneName], _zonePos];
	_zoneMarker setMarkerShape "ELLIPSE";
	_zoneMarker setMarkerSize  [_size + (_size / 100 * 15), _size + (_size / 100 * 15)];
	_zoneMarker setMarkerColor ([_missionSide, true] call BIS_fnc_sideColor);
	_zoneMarker setMarkerBrush  "Border";
	
	// Store marker and allow it to be deleted after completion.										
	_removeExtras = format["deleteMarker '%1_marker'; ", _zoneName];
};

// Create the DAC Zone
[format["[TG] DEBUG (spawnDACZone - %1): Zone Init: %2",_zoneName,_DACinit]] call tg_fnc_debugMsg;
[_zonePos, _size, _size, 0, 0, [_zoneName] + _DACinit] call DAC_fNewZone;

// Create a Trigger to delete the Zone after mission completed and no-one is present.
_deleteAreaTrigger = createTrigger ["EmptyDetector", _zonePos, false];
_deleteAreaTrigger setTriggerTimeout [_timeOut, _timeOut, _timeOut, false];
_deleteAreaTrigger setTriggerArea [_size + 300, _size + 300, 0, true];
_deleteAreaTrigger setTriggerActivation [format["%1", tg_playerSide], "NOT PRESENT", false];
//_deleteAreaTrigger setTriggerActivation ["ANYPLAYER", "NOT PRESENT", false];
_deleteAreaTrigger setTriggerStatements [	format["(missionNamespace getVariable ['%1',false]) && this", _missionName], 
											_removeExtras + format["[] spawn {waitUntil{sleep 5 + random 5; DAC_NewZone == 0;}; ['%1'] call DAC_fDeleteZone; ['[TG] DEBUG (spawnDACZone): Deleting TR_%1 - Completed %2 and %3 not present.'] call tg_fnc_debugMsg;}; ", _zoneName, _missionName, tg_playerSide], 
											"" ];

missionNamespace setVariable [format["TR_%1", _zoneName], _deleteAreaTrigger];

