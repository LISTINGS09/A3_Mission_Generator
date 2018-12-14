// Set-up mission variables.
params [ ["_zoneID", 0], "_targetBld"];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];

_missionDesc = [
		"A <font color='#00FFFF'>%1</font> is located in this area, find and clear it.",
		"Enemy forces have recently reinforced this area and occupied a <font color='#00FFFF'>%1</font>. It must be secured.",
		"Locate a <font color='#00FFFF'>%1</font> within the area and clear it.",
		"Locate and clear a <font color='#00FFFF'>%1</font> somewhere around this area.",
		"A <font color='#00FFFF'>%1</font> was occupied by enemy forces, find and clear it.",
		"Clear out the enemy <font color='#00FFFF'>%1</font> in this location."
	];

_vehName = [getText (configFile >> "CfgVehicles" >> (typeOf _targetBld) >> "displayName"),"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- "] call BIS_fnc_filterString;

// Fill with some units.
[_zoneID, 8, (_targetBld buildingPos -1)] call zmm_fnc_areaGarrison;

// Mark out the target.
_mrkr = _targetBld call BIS_fnc_boundingBoxMarker;
_mrkr setMarkerColor format["Color%1", _enemySide];

_max = ((getMarkerSize _mrkr) select 0) max ((getMarkerSize _mrkr) select 1);

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", position _targetBld, FALSE];
_objTrigger setTriggerActivation [format["%1",_enemySide], "NOT PRESENT", FALSE];
_objTrigger setTriggerArea [_max, _max, 0, TRUE];
_objTrigger setTriggerStatements [  "count thisList <= 2", 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _vehName] + format["<br/><br/><img width='350' image='%1'/>", getText (configFile >> "CfgVehicles" >> (typeOf _targetBld) >> "editorPreview")], ["Clean Up"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "AUTOASSIGNED", 1, FALSE, TRUE, "target"] call BIS_fnc_setTask;

TRUE