// Capture a Utility or Armoured vehicle.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locations = missionNamespace getVariable [format["ZMM_%1_FlatLocations", _zoneID], []];
private _vehUtil = missionNamespace getVariable[format["ZMM_%1Veh_Util",_enemySide],[""]];
private _vehMed = missionNamespace getVariable[format["ZMM_%1Veh_Medium",_enemySide],[""]];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 150; // Area of Zone.

private _missionDesc = selectRandom [
		"Commandeer <font color='#00FFFF'>%1 %2</font> that has been abandoned in %3.",
		"An enemy crews have dismounted from <font color='#00FFFF'>%1 %2</font> within %3, move in and secure them.",
		"Capture <font color='#00FFFF'>%1 %2</font> somewhere in %3.",
		"Steal <font color='#00FFFF'>%1 %2</font> parked somewhere within %3.",
		"The crew of <font color='#00FFFF'>%1 %2</font> ejected and fled the area, locate them somewhere in %3.",
		"A <font color='#00FFFF'>%1 %2</font> was abandoned by its crew within %3. Find and capture them."
	];
	
private _vehNo = 0;
private _vehArr =  [];
private _roadPos = (_centre nearRoads _radius) apply { getPos _x };
private _vehActivation = [];
private _vehFailure = [];

{
	private _veh = _x;
	if (_x isEqualType []) then { _veh = _x#0 };
	
	if !(isClass (configFile >> "CfgVehicles" >> _veh)) then {
		["WARNING", format["Invalid vehicle class: %1", _veh]] call zmm_fnc_logMsg;
		_veh = "";
	};
	_vehArr set [_forEachIndex, _veh];
} forEach (_vehUtil + _vehMed);

_vehArr = _vehArr - [""];

for "_i" from 1 to (missionNamespace getVariable ["ZZM_ObjectiveCount", 2]) do {
	private _vehClass = selectRandom _vehArr;
	private _vehPos = [0,0,0];

	if (count _roadPos == 0) then {
		if (count _locations > 0) then {
			_vehPos = selectRandom _locations;
			_locations deleteAt (_locations find _vehPos);
		} else {
			_vehPos = _centre findEmptyPosition [50, 150, _vehClass];
		};
	} else {
		_vehPos = selectRandom _roadPos;
		_roadPos deleteAt (_roadPos find _vehPos);
	};

	if ((missionNamespace getVariable ["ZZM_ObjectiveCount", 1] isEqualTo 1 && _targetPos isNotEqualTo _centre && _targetPos isNotEqualTo [0,0,0]) || count _vehPos == 0) then { _vehPos = _targetPos };
	
	["DEBUG", format["capture_vehicle (%1) - Creating %2 at %3", _zoneID, _vehClass, _vehPos]] call zmm_fnc_logMsg;

	private _vehObj = createVehicle [_vehClass, _vehPos, [], 0, "NONE"];
	private _randAnim = [];
	{ 
		_configName = configName _x; 
		_displayName = getText (_x >> "displayName"); 
		if (_displayName != "" && {getNumber (_x >> "scope") > 1 || !isNumber (_x >> "scope")}) then { 
			_randAnim pushBack _configName;
			_randAnim pushBack random 1; 
		}; 
    } forEach (configProperties [configFile >> "cfgVehicles" >> (typeOf _vehObj) >> "animationSources", "isClass _x", true]);
	[_vehObj, "", _randAnim] call bis_fnc_initVehicle;
	
	_vehObj allowDamage false;
	_vehObj spawn {
		{ _x hideObjectGlobal true } forEach (nearestTerrainObjects [getPos _this, ["TREE", "SMALL TREE", "BUSH", "BUILDING", "HOUSE", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "CHURCH", "CHAPEL", "CROSS", "BUNKER", "FORTRESS", "FOUNTAIN", "VIEW-TOWER", "LIGHTHOUSE", "QUAY", "FUELSTATION", "HOSPITAL", "FENCE", "WALL", "HIDE", "BUSSTOP", "FOREST", "TRANSMITTER", "STACK", "RUIN", "TOURISM", "WATERTOWER", "ROCK", "ROCKS", "POWERSOLAR", "POWERWAVE", "POWERWIND", "SHIPWRECK"], 5]);
		sleep 5;
		_this lock true;
		_this allowDamage true;
		_this setFuel random 0.4;
		_this setVehicleAmmo random 0.6;
	};
	
	if (alive _vehObj) then {
		_vehNo = _vehNo + 1;		

		missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _vehNo], _vehObj];
		
		// Orient to road
		if (isOnRoad _vehObj) then { _vehObj setDir getDir (roadAt _vehObj) } else { _vehObj setDir random 360 };

		[_vehObj,  
			format["<t color='#72E500'>Unlock %1</t>", getText (configFile >> "CfgVehicles" >> _vehClass >> "displayName")],  
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_Search_ca.paa",  
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_Search_ca.paa",  
			"_this distance2d _target < 4 && locked _target >= 1",  
			"_caller distance2d _target < 4 && locked _target >= 1",  
			{},  
			{},  
			{
				[_target, false] remoteExec ["lock",_target];
				[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
			},   
			{},   
			[],   
			1,   
			10] remoteExec ["bis_fnc_holdActionAdd", 0, _vehObj];
			
		// Create Completion Trigger
		_vehActivation pushBack format["(triggerActivated ZMM_%1_TRIGGER_%2 || !alive ZMM_%1_OBJ_%2)", _zoneID, _vehNo];
		_vehFailure pushBack format["(!alive ZMM_%1_OBJ_%2)", _zoneID, _vehNo];
		
		_vehSucceed = createTrigger ["EmptyDetector", _centre, false];
		_vehSucceed setTriggerActivation ["VEHICLE", "NOT PRESENT", false];
		_vehSucceed setTriggerArea [_radius * 2, _radius * 2, 0, true];
		_vehSucceed triggerAttachVehicle [_vehObj];
		_vehSucceed setTriggerStatements [ format["this && alive ZMM_%1_OBJ_%2", _zoneID, _vehNo],
			format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState;", _zoneID, _vehNo],
			"" ];
			
		missionNamespace setVariable [format["ZMM_%1_TRIGGER_%2", _zoneID, _vehNo], _vehSucceed];
			
		// Failure trigger when HVT is dead.
		private _vehFail = createTrigger ["EmptyDetector", _centre, false];
		_vehFail setTriggerStatements [ format["!alive ZMM_%1_OBJ_%2", _zoneID, _vehNo], 
			format["['ZMM_%1_SUB_%2', 'Failed', true] spawn BIS_fnc_taskSetState;", _zoneID, _vehNo],
			"" ];

		// Add to Zeus
		{ _x addCuratorEditableObjects [[_vehObj], true] } forEach allCurators;
		
		// Child task
		private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _vehNo], format['ZMM_%1_TSK', _zoneID]], true, [format["Capture the empty vehicle found somewhere within the area. Interact with the vehicle to unlock it.<br/><br/>Target Vehicle: <font color='#00FFFF'>%1</font><br/><br/><img width='300' image='%2'/>", getText (configFile >> "CfgVehicles" >> _vehClass >> "displayName"), getText (configFile >> "CfgVehicles" >> _vehClass >> "editorPreview")], format["Vehicle #%1", _vehNo], format["MKR_%1_LOC", _zoneID]], nil, "CREATED", 1, false, true, "target"] call BIS_fnc_setTask;
	} else { deleteVehicle _vehObj };
};

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerStatements [ 	(_vehActivation joinString " && "), 
	format["['ZMM_%1_TSK', if (%3) then { 'Failed' } else { 'Succeeded' }, true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorGrey' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide, (_vehFailure joinString " || ")],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _objTrigger, true];
[_objTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _objTrigger];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_missionDesc, count _vehActivation, if (count _vehActivation > 1) then {"Vehicles"} else {"Vehicle"}, _locName], ["Steal"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "truck"] call BIS_fnc_setTask;

true