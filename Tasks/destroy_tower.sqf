// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];

_missionDesc = [
		"Destroy a <font color='#00FFFF'>%1</font> recently constructed by enemy forces.",
		"The enemy has established a <font color='#00FFFF'>%1</font> at this location, destroy it.",
		"We've picked up a signal indicating a <font color='#00FFFF'>%1</font> is present in the area, destroy it.",
		"Destroy the <font color='#00FFFF'>%1</font> at the marked location.",
		"Intel has identified an enemy <font color='#00FFFF'>%1</font>, destroy it.",
		"A UAV has spotted an enemy <font color='#00FFFF'>%1</font> recently built by the enemy, destroy it."
	];

_objClass = selectRandom ["Land_TTowerBig_1_F","Land_TTowerBig_2_F","Land_Communication_F"];

// Check a tower isn't already nearby.
_nearTowers = (_centre nearObjects ["building", 300]) select {typeOf _x in ["Land_TTowerBig_1_F", "Land_TTowerBig_2_F", "Land_Communication_F"]};
_obj = objNull;

if (count _nearTowers > 0) then {
	_obj = selectRandom _nearTowers;
} else {
	if !(isClass (configFile >> "CfgVehicles" >> _objClass)) exitWith {
		format["[ZMM] Invalid vehicle class: %1", _objClass] call zmm_fnc_logMsg;
		false
	};

	_emptyPos = _targetPos findEmptyPosition [1, 50, _objClass];

	if !(count _emptyPos > 0) then { _emptyPos = _targetPos; };
		
	_obj = createVehicle [_objClass, _emptyPos, [], 0, "NONE"];
	_obj setVectorUp [0,0,1];
};

missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _obj];

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _targetPos, false];
_objTrigger setTriggerStatements [ 	format["!alive ZMM_%1_OBJ", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, getText (configFile >> "CfgVehicles" >> _objClass >> "displayName")] + format["<br/><br/><img width='350' image='%1'/>", getText (configFile >> "CfgVehicles" >> _objClass >> "editorPreview")], ["Tower"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "AUTOASSIGNED", 1, FALSE, TRUE, "destroy"] call BIS_fnc_setTask;

TRUE