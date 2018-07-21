// Set-up mission variables.
params [ ["_zoneID", 0], "_targetPos"];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_radius = (getMarkerSize format["MKR_%1_MIN", _zoneID]) select 0; // Area of Zone.
_vehClass = selectRandom (missionNamespace getVariable[format["ZMM_%1Veh_Util",_enemySide],[""]]);

_missionDesc = [
		"Commandeer a <font color='#00FFFF'>%1</font> that has been abandoned in the area.",
		"An enemy crew have dismounted from a <font color='#00FFFF'>%1</font>, move in and capture it.",
		"Capture a <font color='#00FFFF'>%1</font> somewhere in the area.",
		"Steal a <font color='#00FFFF'>%1</font> that is parked somewhere within this location.",
		"The crew of a <font color='#00FFFF'>%1</font> ejected and fled the area, locate and capture the vehicle.",
		"A <font color='#00FFFF'>%1</font> was abandoned by its crew. Find and capture the vehicle."
	];	

if !(isClass (configFile >> "CfgVehicles" >> _vehClass)) exitWith {
	format["[ZMM] Invalid vehicle class: %1", _vehClass] call zmm_fnc_logMsg;
	false
};

_emptyPos = _targetPos findEmptyPosition [1, 25, _vehClass];
	
_veh = _vehClass createVehicle _emptyPos;
_vehName = [getText (configFile >> "CfgVehicles" >> _vehClass >> "displayName"),"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- "] call BIS_fnc_filterString;

missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _veh];

// Orient to road
if (isOnRoad _veh) then { _veh setDir getDir (roadAt _veh); };

_veh setFuel random 0.4;
_veh setVehicleAmmo random 0.6;
_veh lock TRUE;

[_veh,  
format["<t color='#72E500'>Unlock %1</t>", _vehName],  
"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_Search_ca.paa",  
"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_Search_ca.paa",  
"_this distance _target < 4 && locked _target >= 1",  
"_caller distance _target < 4 && locked _target >= 1",  
{},  
{},  
{ [_target, FALSE] remoteExec ["lock",_target]; },   
{},   
[],   
1,   
10] remoteExec ["bis_fnc_holdActionAdd", 0, _veh];

// Add to Zeus
{
	_x addCuratorEditableObjects [[_veh], TRUE];
} forEach allCurators;

// Create Completion Trigger


_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerActivation ["VEHICLE", "NOT PRESENT", FALSE];
_objTrigger setTriggerArea [_radius, _radius, 0, TRUE];
_objTrigger triggerAttachVehicle [_veh];
_objTrigger setTriggerStatements [ 	format["this && alive ZMM_%1_OBJ", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_%1_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];
									
// Create Failure Trigger
_faiTrigger = createTrigger ["EmptyDetector", [0,0,0], FALSE];
_faiTrigger setTriggerStatements [ 	format["!alive ZMM_%1_TSK_Vehicle", _zoneID], 
									format["['ZMM_%1_TSK', 'Failed', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_%1_FAIL', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, "Grey"],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _vehName], ["Target"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "truck"] call BIS_fnc_setTask;

TRUE