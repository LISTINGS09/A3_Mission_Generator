// Find and destroy caches
// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyTeam = selectRandom (missionNamespace getVariable[format["ZMM_%1Grp_Sentry",_enemySide],[""]]); // CfgGroups entry.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];
private _missionDesc = [
		"The enemy has engaged a cargo transport flying over %2, search the crash site for nearby for <font color='#00FFFF'>%1 Ammo Crates</font> and destroy them.",
		"An enemy air transport has crashed near %2, search the area for <font color='#00FFFF'>%1 Ammo Crates</font> and destroy them.",
		"<font color='#00FFFF'>%1 Ammo Crates</font> have been spotted near a wreck at %2, move in and destroy them.",
		"Search and destroy the <font color='#00FFFF'>%1 Ammo Crates</font> at a downed transport somewhere around %2.",
		"An air transport carrying supplies has crashed at %2. Secure the area and destroy the <font color='#00FFFF'>%1 Ammo Crates</font> before they can fall into enemy hands.",
		"A crashed transport has been spotted near %2. Find the <font color='#00FFFF'>%1 Ammo Crates</font> before the enemy can and destroy them."
	];
	
private _crateNo = switch (_locType) do {
	case "Airport": { 4 };
	case "NameCityCapital": { 4 };
	case "NameCity": { 4 };
	case "NameVillage": { 3 };
	case "NameLocal": { 3 };
	default { 2 };
};
	
if (_centre isEqualTo _targetPos || _targetPos isEqualTo [0,0,0]) then { _targetPos = [_centre, 25, 200, 5, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos; _targetPos set [2,0]; };

// Create Objective
private _wreck = (selectRandom [ "Land_Mi8_wreck_F", "Land_Wreck_Heli_02_Wreck_01_F"]) createVehicle _targetPos;
_wreck setVectorUp surfaceNormal position _wreck;

_wreck addEventHandler ["Explosion", {
	params ["_vehicle", "_damage"];
	for "_i" from 0 to random 3 do { private _exp = "Bo_GBU12_LGB" createVehicle (_vehicle getPos [random 3, random 360]) };
	deleteVehicle _vehicle;
	_vehicle removeEventHandler ["Explosion", _thisEventhandler];
}];

missionNamespace setVariable [format["ZMM_%1_OBJ_WRECK", _zoneID], _wreck];

private _wreckTask = [[format["ZMM_%1_SUB_WRECK", _zoneID], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate the wreck somewhere within the marked area.<br/><br/>Target: <font color='#00FFFF'>%1</font><br/><br/><img width='300' image='%2'/>", getText (configFile >> "CfgVehicles" >> typeOf _wreck >> "displayName"), getText (configFile >> "CfgVehicles" >> typeOf _wreck >> "editorPreview")], "Destroy Wreck", format["MKR_%1_LOC", _zoneID]], objNull, "CREATED", 1, false, true, "destroy"] call BIS_fnc_setTask;
private _wreckTrigger = createTrigger ["EmptyDetector", _targetPos, false];
_wreckTrigger setTriggerStatements [ format["!alive ZMM_%1_OBJ_WRECK", _zoneID],
	format["['ZMM_%1_SUB_WRECK', 'Succeeded', true] spawn BIS_fnc_taskSetState;", _zoneID, _i],
	"" ];

private _crateActivation = [format["!alive ZMM_%1_OBJ_WRECK", _zoneID]];

private _smoke = createVehicle ["test_EmptyObjectForSmoke",position _wreck, [], 0, "CAN_COLLIDE"];
private _crater = createSimpleObject ["CraterLong", AGLToASL position _wreck];
_crater setVectorUp surfaceNormal position _wreck;

// Add to Zeus
{ _x addCuratorEditableObjects [[_wreck], true] } forEach allCurators;

// Generate the crates.
for "_i" from 1 to _crateNo do {
	private _ammoType = selectRandom ["Box_Syndicate_Ammo_F","Box_Syndicate_WpsLaunch_F"];
	private _ammoPos = [_centre, 100 + random 50, 200, 2, 0, 0.5, 0, [], [ _targetPos, _targetPos ]] call BIS_fnc_findSafePos;
	_ammoPos = _ammoPos findEmptyPosition [1, 25, _ammoType];

	if (count _ammoPos > 0) then { 
		private _ammoObj = _ammoType createVehicle _ammoPos;
		_ammoObj setDir random 90;
		
		missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _i], _ammoObj];
		
		_crateActivation pushBack format["!alive ZMM_%1_OBJ_%2", _zoneID, _i];
		
		clearWeaponCargoGlobal _ammoObj;
		clearMagazineCargoGlobal _ammoObj;
		clearItemCargoGlobal _ammoObj;
		clearBackpackCargoGlobal _ammoObj;
				
		private _mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _ammoPos getPos [random 50, random 360]];
		_mrkr setMarkerShape "ELLIPSE";
		_mrkr setMarkerBrush "SolidBorder";
		_mrkr setMarkerSize [50,50];
		_mrkr setMarkerAlpha 0.4;
		_mrkr setMarkerColor format["Color%1",_enemySide];
						
		// Child task
		private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate the crate somewhere within the marked area.<br/><br/>Target Object: <font color='#00FFFF'>%1</font><br/><br/><img width='300' image='%2'/>", getText (configFile >> "CfgVehicles" >> _ammoType >> "displayName"), getText (configFile >> "CfgVehicles" >> _ammoType >> "editorPreview")], format["Crate #%1", _i], format["MKR_%1_%2_OBJ", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["move%1", _i]] call BIS_fnc_setTask;
		private _childTrigger = createTrigger ["EmptyDetector", _ammoPos, false];
		_childTrigger setTriggerStatements [ format["!alive ZMM_%1_OBJ_%2", _zoneID, _i],
			format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2';", _zoneID, _i],
			"" ];

		if !(_enemyTeam isEqualTo "") then {
			private _milGroup = [_ammoObj getPos [random 2, random 360], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
			{ _x setUnitPos "MIDDLE" } forEach units _milGroup;
			{ _x addCuratorEditableObjects [[_ammoObj] + units _milGroup, true] } forEach allCurators;
		};
	};
};

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _targetPos, false];
_objTrigger setTriggerStatements [  (_crateActivation joinString " && "),
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
	"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _crateNo, _locName], ["Crash"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "plane"] call BIS_fnc_setTask;

true