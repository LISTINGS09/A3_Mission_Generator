// Set-up mission variables.
params [ ["_zoneID", 0], ["_tskPos", [0,0,0]] ];

private _tskCentre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _tskPos];
private _tskRadius = ((getMarkerSize format["MKR_Z%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _tskDesc = [
		"Enemy forces are trying to filter though <font color='#00FFFF'>%1</font>. Clear out and then delay their advance through the centre of %1 for <font color='#00FFFF'>%2 Minutes</font>.",
		"A number of enemy groups are advancing towards <font color='#00FFFF'>%1</font>. Eliminate any enemy already there, then hold the centre for <font color='#00FFFF'>%2 Minutes</font> until allied forces have retreated, after which you will be called to exfil.",
		"Eliminate all enemy forces heading into <font color='#00FFFF'>%1</font>. Enemy forces may already be present, secure the area, then hold off the centre of %1 from enemy forces for <font color='#00FFFF'>%2 Minutes</font> to allow civilians time to escape.",
		"Enemy forces have launched an attack on <font color='#00FFFF'>%1</font>. Eliminate any contact already present in %1 at the centre of the area, then defend it for <font color='#00FFFF'>%2 Minutes</font> until called to extract.",
		"The enemy is trying to occupy <font color='#00FFFF'>%1</font>. Clean out any forces already present at the centre of %1, while preventing enemy reinforcements from taking the town. Hold it for <font color='#00FFFF'>%2 Minutes</font> before withdrawing.",
		"Enemy forces are planning to invade <font color='#00FFFF'>%1</font>. Eliminate any enemy forces already present, then hold the centre area of %1 from attackers to allow friendly forces to finish their operation in a nearby town. Hold the area for <font color='#00FFFF'>%2 Minutes</font> before withdrawing."
	];
	
if !(_tskRadius isEqualType 0) then { _tskRadius = 25 };
	
// Overwrite depending on location
private _waves = missionNamespace getVariable ["ZZM_ObjectiveCount", 3];
private _delay = (missionNamespace getVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 300]) max 200;
private _timePerWave = 300;
private _time = _waves * _timePerWave;

// Create Information Trigger
private _infTrigger = createTrigger ["EmptyDetector", _tskCentre, false];
_infTrigger setTriggerArea [_tskRadius, _tskRadius, 0, false, 150];
_infTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_infTrigger setTriggerTimeout [120, 120, 120, true];
_infTrigger setTriggerStatements [  "this", 
	format["['Command','Additional enemy forces are inbound ETA 5 Minutes. Defend %1 for %2 minutes.'] remoteExec ['BIS_fnc_showSubtitle',0];
	[] spawn { sleep 60; [ %3, false, %4, %5 ] spawn zmm_fnc_areaQRF; };
	[] spawn { sleep 150; [ %3, false, %4, %5, 5 ] spawn zmm_fnc_areaQRF; };
	deleteVehicle TR_%3_TASK_DEFEND;
	", _locName, _time / 60, _zoneID, _delay, _waves],
	"" ];
	
missionNamespace setVariable [format['TR_%1_TASK_DEFEND', _zoneID], _infTrigger, true];
[_infTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _infTrigger];

// Create Completion Trigger
private _tskTrigger = createTrigger ["EmptyDetector", _tskCentre, false];
_tskTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_tskTrigger setTriggerArea [_tskRadius, _tskRadius, 0, false];
_tskTrigger setTriggerTimeout [(_time + 180), (_time + 240), (_time + 300), true];
_tskTrigger setTriggerStatements [ 	"this", 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_Z%1_LOC','MKR_Z%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];
	
missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _tskTrigger, true];
[_tskTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _tskTrigger];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _tskDesc, _locName, round (_time / 60)], ["Defence"] call zmm_fnc_nameGen, format["MKR_Z%1_LOC", _zoneID]], _tskCentre, "CREATED", 1, false, true, "defend"] call BIS_fnc_setTask;

true