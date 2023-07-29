// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _buildings = missionNamespace getVariable [format["ZMM_%1_Buildings", _zoneID], []];
private _locations = missionNamespace getVariable [format["ZMM_%1_FlatLocations", _zoneID], []];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = [
		"Locate and disarm <font color='#00FFFF'>%1 Explosives</font> that have been planted around %2.",
		"Search %2 to locate and diffuse <font color='#00FFFF'>%1 IEDs</font> that have been placed there.",
		"Find and disarm <font color='#00FFFF'>%1 Explosive Charges</font> located at %2.",
		"Search %2 diffuse <font color='#00FFFF'>%1 Charges</font> placed by enemy forces.",
		"<font color='#00FFFF'>%1 Demo Charges</font> have been placed within %2. Find and disarm all the explosives."
	];

private _bombMax = missionNamespace getVariable ["ZZM_ObjectiveCount", 3];

// Find one building position.
private _positions = [];
{ _positions pushBack selectRandom (_x buildingPos -1) } forEach _buildings;

// Add locations if there is not enough building positions
if (count _positions < _bombMax) then {
	{ _positions pushBack _x } forEach _locations;
};

private _bombCount = 0;
private _bombActivation = [];
private _bombMarker = [];
private _inBuild = true;
private _radius = 20;

// Create locations if none exist
if (_positions isEqualTo []) then {
	for "_i" from 0 to _bombMax do {
		_positions pushBack (_centre getPos [25 + random 50, random 360]);
	};
};

// Generate the bombs.
for "_i" from 1 to _bombMax do {
	if (_positions isEqualTo []) exitWith {};

	private _bombType = selectRandom ["SatchelCharge_Remote_Ammo_Scripted"];
	private _bombPos = selectRandom _positions;
	if (count _positions > _bombMax) then { _positions deleteAt (_positions find _bombPos) };

	if (count _bombPos > 0) then { 
		// If not in a building find an empty position.
		if (_bombPos#2 == 0) then {
			_bombPos = _bombPos findEmptyPosition [1, 25, "B_Soldier_F"];
			_inBuild = false;
			_radius = 10;
		};
		
		_bombCount = _bombCount + 1;
		private _bombObj = createVehicle [_bombType, [0,0,0], [], 0, "NONE"];
		_bombObj setPosATL _bombPos;
		_bombObj setDir random 360;
		
		// If the crate was moved safely, create the task.
		if (alive _bombObj) then {
			private _mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _bombObj getPos [random _radius, random 360]];
			_mrkr setMarkerShape "ELLIPSE";
			_mrkr setMarkerBrush "SolidBorder";
			_mrkr setMarkerSize [_radius,_radius];
			_mrkr setMarkerAlpha 0.4;
			_mrkr setMarkerColor format["Color%1",_enemySide];
			_bombMarker pushBack _mrkr;
			
			private _sign = selectRandom ["RoadCone_F","Land_RoadCone_01_F"];
		
			if !_inBuild then {
				for "_i" from 1 to 360 step 25 do {
					private _relPos = AGLToASL ((getMarkerPos _mrkr) getPos [_radius + 1,_i]);

					if ((_bombMarker findIf { _relPos inArea _x} < 0) && !(lineIntersects [_relPos, _relPos vectorAdd [0,0,15]]))  then {
						_obj = createSimpleObject [_sign, _relPos];
						_obj setDir (_obj getDir (getMarkerPos _mrkr));
					};
				};
			};
			
			missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _i], _bombObj];
			
			// Child task
			private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate the explosive somewhere within the marked area.<br/><br/>Target Object: <font color='#00FFFF'>%1</font><br/><br/><img width='350' image='%2'/>", getText (configFile >> "CfgMagazines" >> "SatchelCharge_Remote_Mag" >> "displayName"), getText (configFile >> "CfgMagazines" >> "SatchelCharge_Remote_Mag" >> "picture")], format["Explosive #%1", _i], format["MKR_%1_OBJ_%2", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["move%1", _i]] call BIS_fnc_setTask;
			private _childTrigger = createTrigger ["EmptyDetector", getPos _bombObj, false];
			_childTrigger setTriggerStatements [  format["!alive ZMM_%1_OBJ_%2", _zoneID, _i],
				format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2';", _zoneID, _i],
				"" ];
			
			_bombActivation pushBack format["!alive ZMM_%1_OBJ_%2", _zoneID, _i];
			
			{ _x addCuratorEditableObjects [[_bombObj], true] } forEach allCurators;
		};
	};
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [  (_bombActivation joinString " && "), 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _objTrigger, true];
[_objTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _objTrigger];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _bombCount, _locName], ["Disarm"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "mine"] call BIS_fnc_setTask;

true