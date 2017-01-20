// _missionName		STRING		Name of the mission - ONLY ONE CREATOR PER MISSION!
// _DACZoneList		ARRAY		A list of all the DAC zones to be created by tg_fnc_DACzone_spawn

params ["_missionName", "_DACZoneList"];

if (!isNil (missionNamespace getVariable format["TR_DAC_%1", _missionName])) exitWith {
	[format["[TG] ERROR: Trigger 'TR_DAC_%1' already exists. Only one creator can be called per mission!",_zoneName]] call tg_fnc_debugMsg;
};

private _zoneList = [];

// Iterate the DAC Zones to be created.
{
	private _return = _x call tg_fnc_DACzone_spawn;
	if (count _return > 0) then { _zoneList pushBack _return; };
} forEach _DACZoneList;

private _zoneList_areas_active = [];
private _zoneList_areas_all = [];

private _zoneList_pos = [0, 0, 0];
private _zoneList_size = 1000;
private _zoneList_extra = "";

{
	// TODO: Currently this only assumes ONE SINGLE central position is ever present - Ideally work out the average between all the positions AND extend the side to cover the entire area.
	_x params ["_zoneName", "_zonePos", "_size", "_removeExtras", "_needsActivated"];
	
	//[format["[TG] DEBUG DACZoneCreator: Processing [%1, %2, %3, %4, %5]", _zoneName, _zonePos, _size, _removeExtras, _needsActivated]] call tg_fnc_debugMsg;

	_zoneList_pos = _zonePos;
	_zoneList_extra = _zoneList_extra + _removeExtras;
	_zoneList_areas_all pushBack _zoneName;	// Add the Zone to the master list.
	
	if _needsActivated then { _zoneList_areas_active pushBack _zoneName; };	// Add the Zone to the list to be activated.
	if (_size + 500 > _zoneList_size) then {  _zoneList_size = _size + 500; };
} forEach _zoneList;

private _timeOut = 3;

// If DAC is set to start inactive, spawn a trigger to activate it (_needsActivated lets us know if it needs done)
private _zoneTrigger = createTrigger ["EmptyDetector", _zoneList_pos, false];
_zoneTrigger setTriggerTimeout [_timeOut, _timeOut, _timeOut, false];
_zoneTrigger setTriggerArea [_zoneList_size, _zoneList_size, 0, true];
_zoneTrigger setTriggerActivation [format["%1", tg_playerSide], "PRESENT", true];
// TODO: Future version of Arma can activate a trigger from any playable unit.
//_zoneTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];

// Trigger ACTIVATE - If player enters the area and the mission has not been completed, activate the Zone(s).
private _activate_code = "";

if (count _zoneList_areas_active > 0) then {
	// Replace the variable with the new statement.
	
	_activate_code = format[
		"if !(missionNamespace getVariable ['%1',false]) then { 
			[] spawn {
				waitUntil{ sleep 1; DAC_NewZone == 0; };
				['[TG] DEBUG DAC: Activating [%2]'] call tg_fnc_debugMsg;
				[%2] call DAC_Activate;
			}; 
		};", 
		_missionName,
		(_zoneList_areas_active joinString ",")
	];
};

// Trigger DEACTIVATE
// If player leaves the area and the mission has been completed, shut-down the Zone(s) and delete the trigger otherwise just deactivate the Zone(s).
private _deactivate_code = 
	format["if (missionNamespace getVariable ['%1',false]) then { 
			[] spawn { 
				waitUntil{ sleep 1; DAC_NewZone == 0; };
				['[TG] DEBUG DAC: Deleting %2'] call tg_fnc_debugMsg;
				%2 call DAC_fDeleteZone; 
				%3
				deleteVehicle TR_DAC_%1;
			};
		}", 
		_missionName,
		_zoneList_areas_all, // No brackets needed - Already an array!
		_zoneList_extra
	];

// Add to the variable with the new statement or just close it with ';'
if (count _zoneList_areas_active > 0) then {
	_deactivate_code = _deactivate_code + format[
		" else {
			[] spawn {
				waitUntil{ sleep 1; DAC_NewZone == 0; };
				['[TG] DEBUG DAC: Deactivating [%2]'] call tg_fnc_debugMsg;
				[%2] call DAC_Deactivate;
			}; 
		};", 
		_missionName,
		(_zoneList_areas_active joinString ",")
	];
} else {
	_deactivate_code = _deactivate_code + ";"
};

// Set the statements for the trigger.
_zoneTrigger setTriggerStatements [ "this", _activate_code, _deactivate_code ];
									
// Store trigger and allow it to be deleted after completion.										
missionNamespace setVariable [format["TR_DAC_%1", _missionName], _zoneTrigger];