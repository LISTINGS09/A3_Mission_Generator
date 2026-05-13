// Set-up mission variables.
params [ ["_zoneID", 0], ["_tskPos", [0,0,0]] ];

private _tskCentre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _tskPos];
private _tskRadius = ((getMarkerSize format["MKR_Z%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _tskDesc = [
		"Enemy forces are trying to filter though <font color='#00FFFF'>%1</font>. Clear out and then delay their advance through the area by defending the site at %1 for <font color='#00FFFF'>%2 Minutes</font>.",
		"A number of enemy groups are advancing towards <font color='#00FFFF'>%1</font>. Eliminate any enemy already there, then hold the site for <font color='#00FFFF'>%2 Minutes</font> until allied forces have retreated, after which you will be called to exfil.",
		"Eliminate all enemy forces heading into <font color='#00FFFF'>%1</font>. Enemy forces may already be present, secure the area, then hold off the site near %1 from enemy forces for <font color='#00FFFF'>%2 Minutes</font> to allow civilians time to escape.",
		"Enemy forces have launched an attack on <font color='#00FFFF'>%1</font>. Eliminate any contact already present in %1 at a  site located in the area, then defend it for <font color='#00FFFF'>%2 Minutes</font> until called to extract.",
		"The enemy is trying to occupy <font color='#00FFFF'>%1</font>. Clean out any forces already present at a site within %1, while preventing enemy reinforcements from taking that location. Hold it for <font color='#00FFFF'>%2 Minutes</font> before withdrawing.",
		"Enemy forces are planning to invade <font color='#00FFFF'>%1</font>. Eliminate any enemy forces already present, then hold the site at %1 from attackers to allow friendly forces to finish their operation in a nearby town. Hold the area for <font color='#00FFFF'>%2 Minutes</font> before withdrawing."
	];
	
if (_tskCentre isEqualTo _tskPos || _tskPos isEqualTo [0,0,0]) then { _tskPos = [_tskCentre, 25, 200, 5, 0, 0.5, 0, [], [ _tskCentre, _tskCentre ]] call BIS_fnc_findSafePos };

if !(_tskRadius isEqualType 0) then { _tskRadius = 25 };

_tskPos = [_zoneID, _tskPos, false, true] call zmm_fnc_areaSupport;

if (_tskPos isEqualTo []) then { 
	// Site failed to create, spawn some filler
	_tskPos = _tskCentre;

	for "_i" from 0 to 2 do {
		private _sObj = createSimpleObject [selectRandom ["Land_WoodenCrate_01_F", "Land_WoodenCrate_01_stack_x3_F", "Land_WoodenCrate_01_stack_x5_F", "Land_TentA_F", "Land_Pallets_stack_F", "Land_PaperBox_01_open_empty_F", "Land_CratesWooden_F", "Land_Sacks_heap_F"], AGLToASL (_tskPos getPos [2 + random 5, random 360])]; 
		_sObj setDir random 360;
	};

	private _enemyGrp = createGroup [_enemySide, true];
	for "_i" from 0 to 1 + random 3 do {
		private _unit = _enemyGrp createUnit [selectRandom _enemyMen, (_tskPos getPos [random 15, random 360]), [], 0, "NONE"];
		[_unit] joinSilent _enemyGrp; 
		_unit disableAI "PATH";
		_unit setDir random 360;
		_unit setUnitPos "MIDDLE";
		_unit setBehaviour "SAFE";
	};
};

// Overwrite depending on location
private _waves = missionNamespace getVariable ["ZZM_ObjectiveCount", 3];
private _delay = (missionNamespace getVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 300]) max 200;
private _timePerWave = 300;
private _time = _waves * _timePerWave;

private _mrkr = createMarker [format["ZMM_%1_OBJMKR", _zoneID], _tskPos];
_mrkr setMarkerShape "ELLIPSE";
_mrkr setMarkerBrush "Border";
_mrkr setMarkerSize [100,100];
_mrkr setMarkerAlpha 0.4;
_mrkr setMarkerColor "ColorRed";

// Create Information Trigger
private _infTrigger = createTrigger ["EmptyDetector", _tskPos, false];
_infTrigger setTriggerArea [100, 100, 0, false, 150];
_infTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_infTrigger setTriggerTimeout [120, 120, 120, true];
_infTrigger setTriggerStatements [  "this", 
	format["['Command','Additional enemy forces are inbound ETA 5 Minutes. Remain within the site for %2 minutes.'] remoteExec ['BIS_fnc_showSubtitle',0];
	[] spawn { sleep 60; [ %3, false, %4, %5 ] spawn zmm_fnc_areaQRF; };
	[] spawn { sleep 150; [ %3, false, %4, %5, 5 ] spawn zmm_fnc_areaQRF; };
	deleteVehicle TR_%3_TASK_DEFEND;
	", _locName, _time / 60, _zoneID, _delay, _waves],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DEFEND', _zoneID], _infTrigger, true];
[_infTrigger, format['TR_%1_TASK_DEFEND', _zoneID]] remoteExec ["setVehicleVarName", 0, _infTrigger];

// Create Completion Trigger
private _tskTrigger = createTrigger ["EmptyDetector", _tskPos, false];
_tskTrigger setTriggerArea [100, 100, 0, false];
_tskTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_tskTrigger setTriggerTimeout [(_time + 120), (_time + 120), (_time + 120), true];
_tskTrigger setTriggerStatements [ 	"this", 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; deleteMarker 'ZMM_%1_OBJMKR'; { _x setMarkerColor 'Color%2' } forEach ['MKR_Z%1_LOC','MKR_Z%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _tskTrigger, true];
[_tskTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _tskTrigger];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _tskDesc, _locName, round (_time / 60)], ["Site"] call zmm_fnc_nameGen, format["MKR_Z%1_LOC", _zoneID]], _tskPos, "CREATED", 1, false, true, "defend"] call BIS_fnc_setTask;

true