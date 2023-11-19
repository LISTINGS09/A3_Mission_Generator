// Disarm an IED along a road or location.
// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = selectRandom [
		"Locate and disarm or destroy <font color='#00FFFF'>%1 IEDs</font> that have been planted around %2.",
		"Search %2 to locate and diffuse or destroy <font color='#00FFFF'>%1 IEDs</font> that have been placed there.",
		"Find, disarm or destroy <font color='#00FFFF'>%1 IEDs</font> located at %2.",
		"Search %2 diffuse or destroy <font color='#00FFFF'>%1 IEDs</font> placed by enemy forces.",
		"<font color='#00FFFF'>%1 IEDs</font> have been placed within %2. Find, disarm or destroy all the explosives."
	];

_missionDesc = _missionDesc + "<br/><br/>The IEDs are wired to a motion sensor; walking or crawling slowly to an IED will stop it from detonating.<br/><br/>IEDs can either be disarmed by an engineer or disabled with an explosive.";
	
private _bombMax = switch (_locType) do {
	case "Airport": { 5 };
	case "NameCityCapital": { 5 };
	case "NameCity": { 4 };
	case "NameVillage": { 3 };
	case "NameLocal": { 3 };
	default { 2 };
};

private _bombLocs = [];

{
	private _road = _x;
	if ({ _road distance2D _x < 100 } count _bombLocs == 0) then {
		_bombLocs pushBack (_road getPos [(boundingBoxReal _road#0#0) * 0.5, ((_road getDir ((roadsConnectedTo _road)#0)) + 90) + selectRandom [0,180]]); // Left or right of road.
	};
} forEach (_centre nearRoads 250);

private _bombActivation = []; // Also counter

// Create locations if none exist
if (count _bombLocs < _bombMax) then {
	for "_i" from 0 to (_bombMax) do {
		_bombLocs pushBack (_centre getPos [50 + random 50, random 360]);
	};
};

// Generate the bombs.
for "_i" from 1 to _bombMax do {
	if (_bombLocs isEqualTo []) exitWith {};

	private _bombPos = selectRandom _bombLocs;
	_bombLocs deleteAt (_bombLocs find _bombPos);
	
	private _isUrban = _bombPos distance2D nearestBuilding _bombPos < 100;
	
	private _bombType = if (_isUrban) then { selectRandom ["IEDUrbanBig_F","IEDUrbanSmall_F"] } else { selectRandom ["IEDLandBig_F","IEDLandSmall_F"] };
	
	private _mineObj = createMine [_bombType, _bombPos, [], 1];
	_mineObj setDir random 360;

	private _tempObj = createSimpleObject [selectRandom ["Land_Garbage_square3_F","Land_Garbage_square5_F","Land_Garbage_line_F"], AGLToASL _bombPos];
	_tempObj setVectorUp surfaceNormal getPos _tempObj;
	_tempObj setDir random 360;
	//private _tempObj = createVehicle [selectRandom ["Land_Garbage_square3_F","Land_Garbage_square5_F","Land_Garbage_line_F"], getPosATL _mineObj, [], 0, 'CAN_COLLIDE'];
	
	private _mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _mineObj getPos [random 25, random 360]];
	_mrkr setMarkerShape "ELLIPSE";
	_mrkr setMarkerBrush "SolidBorder";
	_mrkr setMarkerSize [25,25];
	_mrkr setMarkerAlpha 0.4;
	_mrkr setMarkerColor format["Color%1",_enemySide];
	
	missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _i], _mineObj];
	
	private _bombTrigger = createTrigger ["EmptyDetector", getPos _mineObj, false];
	_bombTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_bombTrigger setTriggerArea [10, 10, 5, false];
	_bombTrigger setTriggerStatements [ format["alive ZMM_%1_OBJ_%2 && { stance _x != 'PRONE' && speed _x > 6 } count thisList > 0", _zoneID, _i],
			format["createVehicle [selectRandom ['Bo_Mk82','Rocket_03_HE_F','M_Mo_82mm_AT_LG','Bo_GBU12_LGB','Bo_GBU12_LGB_MI10','HelicopterExploSmall'], getPosATL thisTrigger, [], 0, ''];
			createVehicle ['Crater', getPosATL thisTrigger, [], 0, ''];
			deleteMarker 'MKR_%1_OBJ_%2';
			deleteVehicle ZMM_%1_OBJ_%2;",
		_zoneID, _i], "" ];
	
	// Child task
	private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate the IED somewhere within the marked area.<br/><br/>Target Explosive: <font color='#00FFFF'>%1</font><br/><br/><img width='350' image='%2'/>", getText (configFile >> "CfgVehicles" >> _bombType >> "displayName"), getText (configFile >> "CfgVehicles" >> _bombType >> "editorPreview")], format["IED #%1", _i], format["MKR_%1_%2_OBJ", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["move%1", _i]] call BIS_fnc_setTask;
	private _childTrigger = createTrigger ["EmptyDetector", getPos _mineObj, false];
	_childTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_childTrigger setTriggerTimeout [1, 1, 1, true];
	_childTrigger setTriggerStatements [  format["!alive ZMM_%1_OBJ_%2", _zoneID, _i],
			format["if (getMarkerColor 'MKR_%1_OBJ_%2' == '') then { ['ZMM_%1_SUB_%2', 'Failed', true] spawn BIS_fnc_taskSetState; } else { ['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2'; };", _zoneID, _i],
		"" ];
	
	_bombActivation pushBack format["!alive ZMM_%1_OBJ_%2", _zoneID, _i];
	
	{ _x addCuratorEditableObjects [[_mineObj], true] } forEach allCurators;
};

// Spawn fake IEDs
for "_i" from 0 to 8 do {
	if (_bombLocs isEqualTo []) exitWith {};
	
	private _bombPos = selectRandom _bombLocs;
	_bombLocs deleteAt (_bombLocs find _bombPos);
	
	private _isUrban = _bombPos distance2D nearestBuilding _bombPos < 100;

	private _tempObj = createSimpleObject [selectRandom ["Land_GarbagePallet_F","Land_GarbageWashingMachine_F","Land_JunkPile_F","Land_Garbage_square3_F", "Land_Garbage_square5_F", "Land_Garbage_line_F"], AGLToASL _bombPos];
	_tempObj setVectorUp surfaceNormal getPos _tempObj;
	
	_tempObj setDir random 360;
	
	if (random 1 > 0.7) then {
		private _mineObj = createMine [if (_isUrban) then { selectRandom ["IEDUrbanBig_F","IEDUrbanSmall_F"] } else { selectRandom ["IEDLandBig_F","IEDLandSmall_F"] }, _bombPos, [], 1];
		_mineObj setDir random 360;
	
		private _bombTrigger = createTrigger ["EmptyDetector", getPos _mineObj, false];
		_bombTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
		_bombTrigger setTriggerArea [10, 10, 5, false];
		_bombTrigger setTriggerStatements [ format["{ stance _x != 'PRONE' && speed _x > 6 } count thisList > 0", _zoneID, _i],
				format["if ({ thisTrigger distance2D _x < 1.5} count allMines > 0) then { createVehicle [selectRandom ['Bo_Mk82','Rocket_03_HE_F','M_Mo_82mm_AT_LG','Bo_GBU12_LGB','Bo_GBU12_LGB_MI10','HelicopterExploSmall'], getPosATL thisTrigger, [], 0, ''];
				createVehicle ['Crater', getPosATL thisTrigger, [], 0, ''];
				deleteVehicle ZMM_%1_OBJ_%2; }",
			_zoneID, _i], "" ];
			
		{ _x addCuratorEditableObjects [[_mineObj], true] } forEach allCurators;
	};
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [  (_bombActivation joinString " && "), 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_missionDesc, count _bombActivation, _locName], ["Disarm"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "mine"] call BIS_fnc_setTask;

true