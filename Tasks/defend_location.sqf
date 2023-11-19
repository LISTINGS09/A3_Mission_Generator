// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = [
		"Enemy forces are trying to filter though <font color='#00FFFF'>%1</font>. Clear out and then delay their advance through the centre of %1 for <font color='#00FFFF'>%2 Minutes</font>.",
		"A number of enemy groups are advancing towards <font color='#00FFFF'>%1</font>. Eliminate any enemy already there, then hold the centre for <font color='#00FFFF'>%2 Minutes</font> until allied forces have retreated, after which you will be called to exfil.",
		"Eliminate all enemy forces heading into <font color='#00FFFF'>%1</font>. Enemy forces may already be present, secure the area, then hold off the centre of %1 from enemy forces for <font color='#00FFFF'>%2 Minutes</font> to allow civilians time to escape.",
		"Enemy forces have launched an attack on <font color='#00FFFF'>%1</font>. Eliminate any contact already present in %1 at the centre of the area, then defend it for <font color='#00FFFF'>%2 Minutes</font> until called to extract.",
		"The enemy is trying to occupy <font color='#00FFFF'>%1</font>. Clean out any forces already present at the centre of %1, while preventing enemy reinforcements from taking the town. Hold it for <font color='#00FFFF'>%2 Minutes</font> before withdrawing.",
		"Enemy forces are planning to invade <font color='#00FFFF'>%1</font>. Eliminate any enemy forces already present, then hold the centre area of %1 from attackers to allow friendly forces to finish their operation in a nearby town. Hold the area for <font color='#00FFFF'>%2 Minutes</font> before withdrawing."
	];
	
if !(_radius isEqualType 0) then { _radius = 25 };
	
if (count (missionNamespace getVariable [ format["ZMM_%1_QRFLocations", _zoneID], []]) == 0) then { 
	private _QRFLocs = [];
	private _qrfDist = if ((_radius * 3) < 1000) then { 1500 } else { (_radius * 3) min 2000 };

	for [{_i = 0}, {_i <= 360}, {_i = _i + 5}] do {
		private _roads = ((_centre getPos [_qrfDist, _i]) nearRoads 150) select {count (roadsConnectedTo _x) > 0};
		private _tempPos = [];	
		
		_tempPos = if (count _roads > 0) then { getPos (_roads#0) } else { (_centre getPos [_qrfDist, _i]) isFlatEmpty  [15, -1, -1, -1, -1, false] };
		
		if !(_tempPos isEqualTo []) then {
			if ({_x distance2D _tempPos < 350} count _QRFLocs == 0) then {
				_QRFLocs pushBack _tempPos;
			};
		};
	};
	missionNamespace setVariable [ format["ZMM_%1_QRFLocations", _zoneID], _QRFLocs ]; // Set QRF Locations
};

// Overwrite depending on location
private _waves = missionNamespace getVariable ["ZZM_ObjectiveCount", 3];
private _delay = (missionNamespace getVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 300]) max 200;
private _timePerWave = 300;
private _time = _waves * _timePerWave;

// Create Information Trigger
private _infTrigger = createTrigger ["EmptyDetector", _centre, false];
_infTrigger setTriggerArea [_radius, _radius, 0, false, 150];
_infTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_infTrigger setTriggerTimeout [120, 120, 120, true];
_infTrigger setTriggerStatements [  "this", 
	format["['Command','Additional enemy forces are inbound ETA 5 Minutes. Defend %1 for %2 minutes.'] remoteExec ['BIS_fnc_showSubtitle',0];
	[] spawn { sleep 140; [ %3, false, %4, %5 ] spawn zmm_fnc_areaQRF; };
	[] spawn { sleep 150; [ %3, false, %4, %5, 5 ] spawn zmm_fnc_areaQRF; };
	deleteVehicle TR_%3_TASK_DEFEND;
	", _locName, _time / 60, _zoneID, _delay, _waves],
	"" ];
	
missionNamespace setVariable [format['TR_%1_TASK_DEFEND', _zoneID], _infTrigger, true];
[_infTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _infTrigger];

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_objTrigger setTriggerArea [_radius, _radius, 0, false];
_objTrigger setTriggerTimeout [(_time + 180), (_time + 240), (_time + 300), true];
_objTrigger setTriggerStatements [ 	"this", 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];
	
missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _objTrigger, true];
[_objTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _objTrigger];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, round (_time / 60)], ["Defence"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "defend"] call BIS_fnc_setTask;

true