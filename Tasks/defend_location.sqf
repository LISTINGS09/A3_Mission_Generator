// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 25; // Area of Zone.
_locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
_locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

_missionDesc = [
		"Enemy forces are trying to take over <font color='#00FFFF'>%1</font>. Clear out and then defend the location at all costs.",
		"A number of enemy groups are advancing towards <font color='#00FFFF'>%1</font>. Eliminate any enemy already there, then hold the area until called to exfil.",
		"Eliminate all enemy forces heading into <font color='#00FFFF'>%1</font>. Enemy forces may already be present, secure the area, then hold off the enemy for a specified time.",
		"Enemy forces have launched an attack on <font color='#00FFFF'>%1</font>. Eliminate any contact already present in the area, then defend it until called to extract.",
		"The enemy is trying to occupy <font color='#00FFFF'>%1</font>. Clean out any forces already present, while prevent enemy reinforcements from taking the town.",
		"Enemy forces are planning to invade <font color='#00FFFF'>%1</font>. Eliminate any enemy forces already present, then hold the area from attackers for a specified time before withdrawing."
	];
	
if (count (missionNamespace getVariable [ format["ZMM_%1_QRFLocations", _zoneID], []]) == 0) exitWith { 
	["ERROR", format["Zone%1 - No valid QRF locations, cannot create objective!", _zoneID]] call zmm_fnc_logMsg;
	false 
};

if (missionNamespace getVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 0] == 0) then { missionNamespace setVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 300] };

// Overwrite depending on location
_waves = switch (_locType) do {
	case "Airport": { 5 };
	case "NameCityCapital": { 5 };
	case "NameCity": { 4 };
	case "NameVillage": { 3 };
	case "NameLocal": { 3 };
	default { 3 };
};

_delay = missionNamespace getVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 300];

_timePerWave = 300;
_time = _waves * _timePerWave;

[ _zoneID, false, _delay, _waves] spawn zmm_fnc_areaQRF;

// Create Information Trigger
_infTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_infTrigger setTriggerArea [_radius, _radius, 0, FALSE];
_infTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", FALSE];
_objTrigger setTriggerTimeout [120, 120, 120, true];
_infTrigger setTriggerStatements [  "this", 
									format["['Command','Additional enemy forces are inbound ETA 5 Minutes. Defend %1 for %2 minutes.'] remoteExec ['BIS_fnc_showSubtitle',0];
									[] spawn { sleep 240; [ %3, false, %4, %5 ] spawn zmm_fnc_areaQRF; } 
									", _locName, _time / 60, _zoneID, _delay, _waves],
									"" ];
									
// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerArea [_radius, _radius, 0, FALSE];
_objTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", FALSE];
_objTrigger setTriggerTimeout [(_time + 180), (_time + 240), (_time + 300), true];
_objTrigger setTriggerStatements [ 	"this", 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName], ["Defence"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "AUTOASSIGNED", 1, FALSE, TRUE, "defend"] call BIS_fnc_setTask;

TRUE