// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
_locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
_vehClass = selectRandom (missionNamespace getVariable[format["ZMM_%1Veh_Util",_enemySide],[""]]);

_missionDesc = [
		"Commandeer a <font color='#00FFFF'>%1</font> that has been abandoned in %2.",
		"An enemy crew have dismounted from a <font color='#00FFFF'>%1</font> within %2, move in and capture it.",
		"Capture a <font color='#00FFFF'>%1</font> somewhere in %2.",
		"Steal a <font color='#00FFFF'>%1</font> that is parked somewhere within %2.",
		"The crew of a <font color='#00FFFF'>%1</font> ejected and fled the area, locate and capture the vehicle somewhere in %2.",
		"A <font color='#00FFFF'>%1</font> was abandoned by its crew within %2. Find and capture the vehicle."
	];	

if !(isClass (configFile >> "CfgVehicles" >> _vehClass)) exitWith {
	format["[ZMM] Invalid vehicle class: %1", _vehClass] call zmm_fnc_logMsg;
	false
};

if (_targetPos isEqualTo _centre || _targetPos isEqualTo [0,0,0]) then { _targetPos = selectRandom (missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [_centre getPos [50, random 360]] ]) };
if (isNil "_targetPos") then { _targetPos = _centre };

_emptyPos = _targetPos findEmptyPosition [1, 100, _vehClass];
if (_emptyPos isEqualTo []) then { _emptyPos = _targetPos };

_veh = createVehicle [_vehClass, _emptyPos, [], 0, "NONE"];
_veh allowDamage false;

missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _veh];

// Orient to road
if (isOnRoad _veh) then { _veh setDir getDir (roadAt _veh); };

_veh setPos (getPos _veh vectorAdd [0, 0, 3]);
_veh setVectorUp surfaceNormal position _veh;
_veh spawn {
	{ _x hideObjectGlobal true } forEach (nearestTerrainObjects [getPos _this, ["TREE", "SMALL TREE", "BUSH", "BUILDING", "HOUSE", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "CHURCH", "CHAPEL", "CROSS", "BUNKER", "FORTRESS", "FOUNTAIN", "VIEW-TOWER", "LIGHTHOUSE", "QUAY", "FUELSTATION", "HOSPITAL", "FENCE", "WALL", "HIDE", "BUSSTOP", "FOREST", "TRANSMITTER", "STACK", "RUIN", "TOURISM", "WATERTOWER", "ROCK", "ROCKS", "POWERSOLAR", "POWERWAVE", "POWERWIND", "SHIPWRECK"], 5]);
	sleep 5;
	_this lock true;
	_this allowDamage true;
	_this setFuel random 0.4;
	_this setVehicleAmmo random 0.6;
};

[_veh,  
format["<t color='#72E500'>Unlock %1</t>", _vehName],  
"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_Search_ca.paa",  
"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_Search_ca.paa",  
"_this distance2d _target < 4 && locked _target >= 1",  
"_caller distance2d _target < 4 && locked _target >= 1",  
{},  
{},  
{ [_target, false] remoteExec ["lock",_target]; [ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"]; },   
{},   
[],   
1,   
10] remoteExec ["bis_fnc_holdActionAdd", 0, _veh];

// Add to Zeus
{ _x addCuratorEditableObjects [[_veh], true] } forEach allCurators;

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerActivation ["VEHICLE", "NOT PRESENT", false];
_objTrigger setTriggerArea [_radius, _radius, 0, true];
_objTrigger triggerAttachVehicle [_veh];
_objTrigger setTriggerStatements [ 	format["this && alive ZMM_%1_OBJ", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];
									
// Create Failure Trigger
_faiTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_faiTrigger setTriggerStatements [ 	format["!alive ZMM_%1_OBJ", _zoneID], 
									format["['ZMM_%1_TSK', 'Failed', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorGrey' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, getText (configFile >> "CfgVehicles" >> _vehClass >> "displayName")] + format["<br/><br/>Type: <font color='#FFA500'>%1</font><br/>Registration: <font color='#FFA500'>%3</font><br/><img width='350' image='%4'/>", getText (configFile >> "CfgVehicles" >> _vehClass >> "displayName"), _locName, getPlateNumber _veh, getText (configFile >> "CfgVehicles" >> _vehClass >> "editorPreview")], ["Steal"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], [_veh, false], "CREATED", 1, false, true, "truck"] call BIS_fnc_setTask;

true