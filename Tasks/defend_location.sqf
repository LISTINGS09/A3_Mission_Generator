// Set-up mission variables.
params [ ["_zoneID", 0]];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_radius = (getMarkerSize format["MKR_%1_MIN", _zoneID]) select 0; // Area of Zone.

_nearLoc = nearestLocation [_centre, ""];
_locName = if (getPos _nearLoc distance2D _centre < 200) then { text _nearLoc } else { "this Location" };

_missionDesc = [
		"Enemy forces are trying to take over <font color='#00FFFF'>%1</font>, defend the location at all costs.",
		"A number of enemy groups are advancing towards <font color='#00FFFF'>%1</font>, hold the area until called to exfil.",
		"Eliminate all enemy forces heading into <font color='#00FFFF'>%1</font>, hold off the enemy for a specified time.",
		"Enemy forces have launched an attack on <font color='#00FFFF'>%1</font>, defend the area until called to extract.",
		"The enemy is trying to occupy <font color='#00FFFF'>%1</font>, prevent enemy forces from taking the town.",
		"Enemy forces are planning to invade <font color='#00FFFF'>%1</font>, hold the area from attackers for a specified time before withdrawing."
	];		

// Create Information Trigger
_infTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_infTrigger setTriggerArea [_radius, _radius, 0, FALSE];
_infTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", FALSE];
_infTrigger setTriggerStatements [  "this", 
									format["['Command','Enemy forces inbound, hold %1 for 25 minutes.'] remoteExec ['BIS_fnc_showSubtitle',0];", _locName],
									"" ];
									
// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerArea [_radius, _radius, 0, FALSE];
_objTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", FALSE];
_objTrigger setTriggerTimeout [1500, 1500, 1500, FALSE];
_objTrigger setTriggerStatements [ 	"this", 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _targetName], ["Defence"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "defend"] call BIS_fnc_setTask;

TRUE