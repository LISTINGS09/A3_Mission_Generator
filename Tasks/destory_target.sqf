// Set-up mission variables.
params [ ["_zoneID", 0], "_targetObj" ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];

_missionDesc = [
		"A <font color='#00FFFF'>%1</font> is located in this area, find and destroy it.",
		"Enemy forces have recently reinforced this area and constructed a <font color='#00FFFF'>%1</font>. It must be destroyed.",
		"Locate a <font color='#00FFFF'>%1</font> within the area and destroy it.",
		"Locate and destroy <font color='#00FFFF'>%1</font> somewhere around this area.",
		"A <font color='#00FFFF'>%1</font> was spotted in this area recently, find and eliminate it.",
		"Destroy the <font color='#00FFFF'>%1</font> somewhere around this location."
	];

_vehName = [getText (configFile >> "CfgVehicles" >> (typeOf _targetObj) >> "displayname"),"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- "] call BIS_fnc_filterString;

missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _targetObj];

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerStatements [ 	format["!alive ZMM_%1_OBJ", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _vehName], ["Demolition"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "destroy"] call BIS_fnc_setTask;

TRUE