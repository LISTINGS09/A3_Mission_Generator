// Hunt down and either destroy a Utility or Heavily Armoured vehicle.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_vehClass = selectRandom (missionNamespace getVariable[format["ZMM_%1Veh_Util",_enemySide],[""]]);
_vehTank = selectRandom (missionNamespace getVariable[format["ZMM_%1Veh_Heavy",_enemySide],[""]]);
_isHeavy = FALSE;

if (_targetPos isEqualTo _centre || _targetPos isEqualTo [0,0,0]) then { _targetPos = selectRandom (missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [_centre getPos [50, random 360]] ]) };

_missionDesc = [
		"A <font color='#00FFFF'>%1</font> has been seen parked in this area, locate and destroy it.",
		"Enemy forces have recently reinforced this area and brought in a <font color='#00FFFF'>%1</font>. It must be destroyed.",
		"Locate a stationary <font color='#00FFFF'>%1</font> within the area and destroy it.",
		"Hunt down a <font color='#00FFFF'>%1</font> that has stopped somewhere around this area.",
		"A <font color='#00FFFF'>%1</font> was spotted entering this area recently, find where it has been parked and eliminate it.",
		"Destroy the <font color='#00FFFF'>%1</font> stationed somewhere around this location."
	];	

// Chance for heavy armour
if (random 100 > 50) then {
	_vehClass = _vehTank;
	if (_vehClass isEqualType []) then { _vehClass = _vehClass#0 };
	_isHeavy = TRUE;
	
	_missionDesc = [
		"A modified <font color='#00FFFF'>%1</font> has been active in this area, locate and destroy it.",
		"Enemy forces have recently reinforced this area and brought in a refitted <font color='#00FFFF'>%1</font>. It must be destroyed.",
		"Locate an improved <font color='#00FFFF'>%1</font> moving within the area and destroy it.",
		"Hunt down a modified <font color='#00FFFF'>%1</font> that has been spotted moving around this area.",
		"A refitted <font color='#00FFFF'>%1</font> was spotted entering this area recently, find and eliminate it.",
		"Destroy the upgraded <font color='#00FFFF'>%1</font> patrolling somewhere around this location."
	];	
};

if !(isClass (configFile >> "CfgVehicles" >> _vehClass)) exitWith {
	format["[ZMM] Invalid vehicle class: %1", _vehClass] call zmm_fnc_logMsg;
	FALSE
};

_emptyPos = _targetPos findEmptyPosition [1, 50, _vehClass];
	
_veh = createVehicle [_vehClass, _emptyPos, [], 0, "NONE"];

// Crew vehicle
if _isHeavy then {
	createVehicleCrew _veh;
	_nul = [driver _veh, format["MKR_%1_MIN", _zoneID], "SHOWMARKER"] spawn zmm_fnc_aiUPS;
} else {
	_veh lock true;
};

// Orient to road
if (isOnRoad _veh) then { _veh setDir getDir (roadAt _veh); };

// Add to Zeus
{
	_x addCuratorEditableObjects [[_veh], true];
} forEach allCurators;

// Create Completion Trigger
missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _veh];

_objTrigger = createTrigger ["EmptyDetector", _targetPos, false];
_objTrigger setTriggerStatements [ 	format["!alive ZMM_%1_OBJ", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, getText (configFile >> "CfgVehicles" >> _vehClass >> "displayName")] + format["<br/><br/><img width='350' image='%1'/>", getText (configFile >> "CfgVehicles" >> _vehClass >> "editorPreview")], ["Destroy"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], [_veh, FALSE], "CREATED", 1, FALSE, TRUE, "destroy"] call BIS_fnc_setTask;

TRUE