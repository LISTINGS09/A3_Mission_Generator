// Set-up mission variables.
params [ ["_zoneID", 0], "_targetPos"];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_vehClass = selectRandom (missionNamespace getVariable[format["ZMM_%1Veh_Util",_enemySide],[""]]);
_vehTank = selectRandom (missionNamespace getVariable[format["ZMM_%1Veh_Heavy",_enemySide],[""]]);
_picture = "truck";

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
	_picture = "destroy";
	
	_missionDesc = [
		"A <font color='#00FFFF'>%1</font> has been active in this area, locate and destroy it.",
		"Enemy forces have recently reinforced this area and brought in a <font color='#00FFFF'>%1</font>. It must be destroyed.",
		"Locate a <font color='#00FFFF'>%1</font> moving within the area and destroy it.",
		"Hunt down a <font color='#00FFFF'>%1</font> that has been spotted around this area.",
		"A <font color='#00FFFF'>%1</font> was spotted entering this area recently, find and eliminate it.",
		"Destroy the <font color='#00FFFF'>%1</font> patrolling somewhere around this location."
	];	
};

if !(isClass (configFile >> "CfgVehicles" >> _vehClass)) exitWith {
	format["[ZMM] Invalid vehicle class: %1", _vehClass] call zmm_fnc_logMsg;
	false
};

_emptyPos = _targetPos findEmptyPosition [1, 25, _vehClass];
	
_veh = createVehicle [_vehClass, _emptyPos, [], 0, "NONE"];
_vehName = [getText (configFile >> "CfgVehicles" >> _vehClass >> "displayName"),"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- "] call BIS_fnc_filterString;

// Crew vehicle
if (_picture isEqualTo "destroy") then {
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
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_%1_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _vehName], ["Target"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, _picture] call BIS_fnc_setTask;

TRUE