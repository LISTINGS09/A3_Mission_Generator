// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetObj", objNull], ["_targetPos", [0,0,0]] ];


if (isNull _targetObj || isNil "_targetObj") then {
	_targetObj = selectRandom ["Land_TTowerSmall_1_F","Land_TTowerSmall_2_F"] createVehicle _targetPos;
};

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];

_missionDesc = [
		"A <font color='#00FFFF'>%1</font> is located in this area, find and destroy it.",
		"Enemy forces have recently reinforced this area and constructed a <font color='#00FFFF'>%1</font>. It must be destroyed.",
		"Locate a <font color='#00FFFF'>%1</font> within the area and destroy it.",
		"Locate and destroy a <font color='#00FFFF'>%1</font> somewhere around this area.",
		"A <font color='#00FFFF'>%1</font> was spotted in this area recently, find and eliminate it.",
		"Destroy the <font color='#00FFFF'>%1</font> somewhere around this location."
	];

missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _targetObj];

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerStatements [ 	format["!alive ZMM_%1_OBJ", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, getText (configFile >> "CfgVehicles" >> (typeOf _targetObj) >> "displayName")] + format["<br/><br/><img width='350' image='%1'/>", getText (configFile >> "CfgVehicles" >> (typeOf _targetObj) >> "editorPreview")], ["Demolition"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "AUTOASSIGNED", 1, FALSE, TRUE, "destroy"] call BIS_fnc_setTask;

TRUE