// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locations = missionNamespace getVariable [format["ZMM_%1_FlatLocations", _zoneID], []];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = [
		"Locate and disarm <font color='#00FFFF'>%1 UXOs</font> that have been planted around %2.",
		"Search %2 to locate and diffuse <font color='#00FFFF'>%1 UXOs</font> that have been placed there.",
		"Find and disarm <font color='#00FFFF'>%1 UXOs</font> located at %2.",
		"Search %2 diffuse <font color='#00FFFF'>%1 UXOs</font> placed by enemy forces.",
		"<font color='#00FFFF'>%1 UXOs</font> have been placed within %2. Find and disarm all the explosives."
	];

private _bombMax = missionNamespace getVariable ["ZZM_ObjectiveCount", 3];

// Find all outdoor positions.
private _positions = _locations;
private _bombCount = 0;
private _bombActivation = [];
private _bombAreas = [];
private _radius = 20;
private _uxoSide = ceil random 3;

// Create locations if none exist
if (_positions isEqualTo []) then {
	for "_i" from 0 to _bombMax do {
		_positions pushBack (_centre getPos [50 + random 100, random 360]);
	};
};

// Generate the bombs.
for "_i" from 1 to _bombMax do {
	if (_positions isEqualTo []) exitWith {};

	private _bombType = format["BombCluster_0%1_UXO%2_F", _uxoSide, ceil random 4];
	private _bombPos = selectRandom _positions;
	
	_positions deleteAt (_positions find _bombPos);
	
	if (count _bombPos > 0) then { 	
		private _bombObj = createMine [_bombType, [0,0,0], [], 2];
		_bombPos set [2, 0.1];
		_bombObj setPos _bombPos;
		_enemySide revealMine _bombObj;
		CIVILIAN revealMine _bombObj;
		_bombObj spawn { sleep 5; _this enableSimulationGlobal false; };
		
		// If the crate was moved safely, create the task.
		if (alive _bombObj) then {
			private _mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _bombObj getPos [random _radius, random 360]];
			_mrkr setMarkerShape "ELLIPSE";
			_mrkr setMarkerBrush "SolidBorder";
			_mrkr setMarkerSize [_radius,_radius];
			_mrkr setMarkerAlpha 0.4;
			_mrkr setMarkerColor format["Color%1",_enemySide];
			
			private _sign = selectRandom ["RoadCone_F","Land_RoadCone_01_F","Land_Sign_Mines_F","Land_Sign_MinesTall_F","Land_Sign_MinesTall_English_F"];
			
			// Add to areas to ignore
			_bombAreas pushBack _mrkr;
			
			missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _i], _bombObj, true];
			
			_objEnable = createTrigger ["EmptyDetector", _bombObj, false];
			_objEnable setTriggerActivation ["ANYPLAYER", "PRESENT", false];
			_objEnable setTriggerArea [25, 25, 0, false];
			_objEnable setTriggerStatements [ "this", 
									format["if (alive ZMM_%1_OBJ_%2) then { ZMM_%1_OBJ_%2 enableSimulationGlobal true };", _zoneID, _i],
									"" ];
			
			// Child task
			private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate the UXO somewhere within the marked area.<br/><br/>Target Object: <font color='#00FFFF'>%1</font><br/><br/><img width='300' image='%2'/>", getText (configFile >> "CfgVehicles" >> _bombType >> "displayName"), getText (configFile >> "CfgVehicles" >> _bombType >> "editorPreview")], format["UXO #%1", _i], format["MKR_%1_OBJ_%2", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["move%1", _i]] call BIS_fnc_setTask;
			private _childTrigger = createTrigger ["EmptyDetector", _bombObj, false];
			_childTrigger setTriggerStatements [  format["(!mineActive ZMM_%1_OBJ_%2 || !alive ZMM_%1_OBJ_%2 || 'empty.p3d' in (getModelInfo ZMM_%1_OBJ_%2))", _zoneID, _i],
										format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2';", _zoneID, _i],
										"" ];
			
			_bombActivation pushBack format["(!alive ZMM_%1_OBJ_%2 || 'empty.p3d' in (getModelInfo ZMM_%1_OBJ_%2))", _zoneID, _i];
			
			{ _x addCuratorEditableObjects [[_bombObj], true] } forEach allCurators;
			
			_bombCount = _bombCount + 1;
		};
	};
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [  (_bombActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _bombCount, _locName], ["Disarm"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "mine"] call BIS_fnc_setTask;

true