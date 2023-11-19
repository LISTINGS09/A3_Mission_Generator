// Set-up mission variables.
// TODO Spawn some bunkers?
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyMen = missionNamespace getVariable format["ZMM_%1Man", _enemySide];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];

private _missionDesc = [
		"Secure the area around <font color='#0080FF'>%1</font color> by investigating <font color='#00FFFF'>%2 grid%3</font color> in the area.",
		"Recon <font color='#0080FF'>%1</font color> by patrolling the <font color='#00FFFF'>%2 grid%3</font color> in the area.",
		"<font color='#0080FF'>%1</font color> is occupied by enemy forces, eliminate them and secure the <font color='#00FFFF'>%2 grid%3</font color>.",
		"Patrol the <font color='#00FFFF'>%2 grid%3</font color> located in <font color='#0080FF'>%1</font color> and eliminate any enemy forces encountered along the way.",
		"Enemy forces have occupied <font color='#0080FF'>%1</font color>, eliminate any you find while moving through <font color='#00FFFF'>%2 grid%3</font color> in the area.",
		"Locate the <font color='#00FFFF'>%2 grid%3</font color> within <font color='#0080FF'>%1</font color>, move through each and eliminate any enemy forces there."
	];

_enemyGrp = createGroup [_enemySide, true];
_areaActivation = [];
_areaGrids = [];

{
	private _gridRef = _x call BIS_fnc_posToGrid;
	private _gridID = _forEachIndex + 1;
		
	private _gridRef = format["%1%2", _gridRef#0, _gridRef#1];
	
	if (!(surfaceIsWater _x) && !(_gridRef in _areaGrids)) then {
		_areaGrids pushBack _gridRef;
		
		(_gridRef call BIS_fnc_gridToPos) params ["_gridPos","_gridXY"];
		
		_gridPos = _gridPos vectorAdd (_gridXY apply { _x / 2 });
				
		private _mrk = createMarker [ format[ "MKR_%1_ICON_%2", _zoneID, _gridID ], _gridPos];
		_mrk setMarkerShape "RECTANGLE";
		_mrk setMarkerBrush "BDiagonal";
		_mrk setMarkerAlpha 0.5;
		_mrk setMarkerColor format[ "color%1", _enemySide ];
		_mrk setMarkerSize [_gridXY#0 / 2, _gridXY#1 / 2];
		
		private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _gridID], format['ZMM_%1_TSK', _zoneID]], true, [format["Patrol within the area of %1.", _gridRef], format["Position #%1", _gridID], format["MKR_%1_ICON_%2", _zoneID, _gridID]], _gridPos, "CREATED", 1, false, true, format["move%1", _gridID]] call BIS_fnc_setTask;
		private _childTrigger = createTrigger ["EmptyDetector", _gridPos, false];
		_childTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
		_childTrigger setTriggerArea [(_gridXY#0) / 2, (_gridXY#0) / 2, 0, true, 50];
		_childTrigger setTriggerTimeout [5, 5, 5, false];
		_childTrigger setTriggerStatements [ "this",
			format["missionNamespace setVariable ['ZMM_%1_OBJ_%2', true, true]; ['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_ICON_%2';", _zoneID, _gridID],
			"" ];
			
		_areaActivation pushBack format["(missionNamespace getVariable ['ZMM_%1_OBJ_%2', false])", _zoneID, _gridID];
			
		for "_i" from 0 to 1 + random 2 do {
			private _unitType = selectRandom _enemyMen;
			private _unit = _enemyGrp createUnit [_unitType, _gridPos getPos [random 25, random 360], [], 0, "NONE"];
			[_unit] joinSilent _enemyGrp; 
			_unit disableAI "PATH";
			_unit setDir random 360;
			_unit setFormDir random 360;
			_unit setUnitPos "MIDDLE";
			_unit setBehaviour "SAFE";
		};
	};
} forEach [
	 _centre getPos [100 + random _radius, 15 + random 60],
	 _centre getPos [100 + random _radius, 105 + random 60],
	 _centre getPos [100 + random _radius, 195 + random 60],
	 _centre getPos [100 + random _radius, 285 + random 60]
];

// Wait before setting DS to allow positions to set.
_enemyGrp spawn { sleep 5; _this enableDynamicSimulation true };

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_objTrigger setTriggerStatements [  (_areaActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, count _areaActivation, if (count _areaActivation > 1) then {"s"} else {""}], ["Patrol"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "walk"] call BIS_fnc_setTask;

true