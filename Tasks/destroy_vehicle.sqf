// Hunt down and either destroy a Utility or Heavily Armoured vehicle.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locations = missionNamespace getVariable [format["ZMM_%1_FlatLocations", _zoneID], []];
private _vehUtil = missionNamespace getVariable[format["ZMM_%1Veh_Util",_enemySide],[""]];
private _vehMed = missionNamespace getVariable[format["ZMM_%1Veh_Medium",_enemySide],[""]];
private _vehTank = missionNamespace getVariable[format["ZMM_%1Veh_Heavy",_enemySide],[""]];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 150; // Area of Zone.

private _missionDesc = selectRandom [
		"Locate and destroy <font color='#00FFFF'>%1 Prototype %2</font> spotted in %3. Each prototype will need an item collected from the wreck.",
		"Enemy forces have recently reinforced %3 with modified vehicles. Destroy the <font color='#00FFFF'>%1 %2</font> located there and obtain key parts from each.",
		"Hunt down <font color='#00FFFF'>%1 %2</font> found somewhere around %3, the %2 has been modified and HQ will need a part bought back for research.",
		"<font color='#00FFFF'>%1 %2</font> entered %3 recently. The %3 will have modified parts which must be collected after they are destroyed.",
		"Destroy <font color='#00FFFF'>%1 Modified %2</font> stationed somewhere around %3. When destroyed move in and collect the modified part from each vehicle."
	];	
	
private _vehNo = 0;
private _vehArr =  [];
private _roadPos = (_centre nearRoads _radius) apply { getPos _x };
private _vehActivation = [];

{
	private _veh = _x;
	if (_x isEqualType []) then { _veh = _x#0 };
	
	if !(isClass (configFile >> "CfgVehicles" >> _veh)) then {
		["WARNING", format["Invalid vehicle class: %1", _veh]] call zmm_fnc_logMsg;
		_veh = "";
	};
	_vehArr set [_forEachIndex, _veh];
} forEach (_vehUtil + _vehMed + _vehTank);

_vehArr = _vehArr - [""];

for "_i" from 1 to (missionNamespace getVariable ["ZZM_ObjectiveCount", 1]) do {
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
	
	["DEBUG", format["destroy_vehicle (%1) - Creating %2 at %3", _zoneID, _vehClass, _vehPos]] call zmm_fnc_logMsg;

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
	};
	
	if (alive _vehObj) then {
		_vehNo = _vehNo + 1;		
		_vehObj setVariable [ "var_Number", _vehNo, true ];
		_vehObj setVariable [ "var_zoneID", _zoneID, true ];
		
		createVehicleCrew _vehObj;

		// Orient to road
		if (isOnRoad _vehObj) then { 
			_vehObj setDir getDir (roadAt _vehObj); 
			_nul = [driver _vehObj, format["MKR_%1_MIN", _zoneID], "SHOWMARKER"] spawn zmm_fnc_aiUPS;
		} else {
			_vehObj setDir random 360;
			if (random 100 < 25) then { _nul = [driver _vehObj, format["MKR_%1_MIN", _zoneID], "SHOWMARKER"] spawn zmm_fnc_aiUPS };
		};
		
		_vehText = selectRandom [
			"Lift Hook",
			"Reinforced Wheel",
			"Armour Plate",
			"Battery Cell",
			"Tow Hook",
			"Spare Track",
			"Sloped Vent",
			"Fender Flap",
			"Rear Muffler",
			"Main Aerial",
			"Left Headlight",
			"Rear Door",
			"Oil Sample",
			"Fuel Sample",
			"Radio Array",
			"Muzzle Case",
			"Steel Bolts"
		];

		// Add to Zeus
		{ _x addCuratorEditableObjects [[_vehObj], true] } forEach allCurators;

		removeFromRemainsCollector [_vehObj];
		
		missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _vehNo], _vehObj];

		// Create Completion Trigger
		_vehActivation pushBack format["(missionNamespace getVariable ['ZMM_%1_OBJ_%2_DEAD', false])", _zoneID, _vehNo];
		
		_childTrigger = createTrigger ["EmptyDetector", _centre, false];
		_childTrigger setTriggerStatements [  format["!alive (missionNamespace getVariable ['ZMM_%1_OBJ_%2', objNull])", _zoneID, _vehNo],
			format["['ZMM_%1_SUB_%2', [missionNamespace getVariable ['ZMM_%1_OBJ_%2', objNull], true]] spawn BIS_fnc_taskSetDestination;", _zoneID, _vehNo],
			"" ];
		
		[_vehObj, 
			format["<t color='#00FF80'>Remove %1 from %2</t>", _vehText, getText (configFile >> "CfgVehicles" >> _vehClass >> "displayName")], 
			"\a3\missions_f_oldman\data\img\holdactions\holdAction_box_ca.paa", 
			"\a3\missions_f_oldman\data\img\holdactions\holdAction_box_ca.paa", 
			"!alive _target && _this distance2d _target < 10", 
			"!alive _target && _caller distance2d _target < 10", 
			{}, 
			{}, 
			{
				private _vehNo = ( _target getVariable ["var_Number", 0]);
				private _zoneID = ( _target getVariable ["var_zoneID", 0]);
				missionNamespace setVariable [ format["ZMM_%1_OBJ_%2_DEAD", _zoneID, _vehNo], true, true];
				[_target, _actionID] remoteExecCall ["BIS_fnc_holdActionRemove"];			
				[format["ZMM_%1_SUB_%2", _zoneID, _vehNo], 'Succeeded', true] remoteExec ["BIS_fnc_taskSetState"];
			}, 
			{}, 
			[], 
			2, 
			10 
		] remoteExec ["bis_fnc_holdActionAdd", 0, _vehObj];
						
		// Child task
		private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _vehNo], format['ZMM_%1_TSK', _zoneID]], true, [format["Destroy the vehicle somewhere within the area and then approach it. Interact with the destroyed vehicle collect the <font color='#00FFFF'>%3</font> from it.<br/><br/>Target Vehicle: <font color='#00FFFF'>%1</font><br/><br/><img width='300' image='%2'/>", getText (configFile >> "CfgVehicles" >> _vehClass >> "displayName"), getText (configFile >> "CfgVehicles" >> _vehClass >> "editorPreview"), _vehText], format["Vehicle #%1", _vehNo], format["MKR_%1_MIN", _zoneID]], nil, "CREATED", 1, false, true, "target"] call BIS_fnc_setTask;
	} else { deleteVehicle _vehObj };
};

_objTrigger = createTrigger ["EmptyDetector", _targetPos, false];
_objTrigger setTriggerStatements [ 	(_vehActivation joinString " && "),
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _objTrigger, true];
[_objTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _objTrigger];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_missionDesc, count _vehActivation, if (count _vehActivation > 1) then {"Vehicles"} else {"Vehicle"}, _locName], ["Destroy"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "destroy"] call BIS_fnc_setTask;

true