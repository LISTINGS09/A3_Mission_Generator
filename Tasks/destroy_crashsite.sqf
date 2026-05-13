// Find and destroy caches
// Set-up mission variables.
params [ ["_zoneID", 0], ["_tskPos", [0,0,0]] ];

private _tskCentre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _tskPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyMen = missionNamespace getVariable [format["ZMM_%1_Man", _enemySide], ["O_Soldier_F"]];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];
private _tskDesc = [
		"The enemy has engaged a cargo transport flying over %2, search the crash site for nearby for <font color='#00FFFF'>%1 Ammo Crates</font> and destroy them.",
		"An enemy air transport has crashed near %2, search the area for <font color='#00FFFF'>%1 Ammo Crates</font> and destroy them.",
		"<font color='#00FFFF'>%1 Ammo Crates</font> have been spotted near a wreck at %2, move in and destroy them.",
		"Search and destroy the <font color='#00FFFF'>%1 Ammo Crates</font> at a downed transport somewhere around %2.",
		"An air transport carrying supplies has crashed at %2. Secure the area and destroy the <font color='#00FFFF'>%1 Ammo Crates</font> before they can fall into enemy hands.",
		"A crashed transport has been spotted near %2. Find the <font color='#00FFFF'>%1 Ammo Crates</font> before the enemy can and destroy them."
	];
	
private _crateNo = missionNamespace getVariable ["ZZM_ObjectiveCount", 3];
	
if (_tskCentre isEqualTo _tskPos || _tskPos isEqualTo [0,0,0]) then { _tskPos = [_tskCentre, 25, 200, 5, 0, 0.5, 0, [], [ _tskCentre, _tskCentre ]] call BIS_fnc_findSafePos; _tskPos set [2,0]; };

// Create Objective
private _wreck = (selectRandom [ "Land_Mi8_wreck_F", "Land_Wreck_Heli_02_Wreck_01_F"]) createVehicle _tskPos;
_wreck setVectorUp surfaceNormal position _wreck;

[_wreck, ["Explosion", {
	params ["_vehicle", "_damage"];
	for "_i" from 0 to random 3 do { private _exp = "Bo_GBU12_LGB" createVehicle (_vehicle getPos [random 3, random 360]) };
	deleteVehicle _vehicle;
	[_vehicle, ["Explosion", _thisEventhandler]] remoteExec ["removeEventHandler"];	
}]] remoteExec ["addEventHandler"];

missionNamespace setVariable [format["ZMM_%1_OBJ_WRECK", _zoneID], _wreck];

private _wreckTask = [[format["ZMM_%1_SUB_WRECK", _zoneID], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate the wreck somewhere within the marked area.<br/><br/>Target: <font color='#00FFFF'>%1</font><br/><br/><img width='300' image='%2'/>", getText (configFile >> "CfgVehicles" >> typeOf _wreck >> "displayName"), getText (configFile >> "CfgVehicles" >> typeOf _wreck >> "editorPreview")], "Destroy Wreck", format["MKR_Z%1_LOC", _zoneID]], objNull, "CREATED", 1, false, true, "destroy"] call BIS_fnc_setTask;
private _wreckTrigger = createTrigger ["EmptyDetector", _tskPos, false];
_wreckTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_wreckTrigger setTriggerStatements [ format["!alive ZMM_%1_OBJ_WRECK", _zoneID],
	format["['ZMM_%1_SUB_WRECK', 'Succeeded', true] spawn BIS_fnc_taskSetState;", _zoneID, _i],
	"" ];

private _tskActivation = [format["!alive ZMM_%1_OBJ_WRECK", _zoneID]];

private _smoke = createVehicle ["test_EmptyObjectForSmoke",position _wreck, [], 0, "CAN_COLLIDE"];
private _crater = createSimpleObject ["CraterLong", AGLToASL position _wreck];
_crater setVectorUp surfaceNormal position _wreck;

// Add to Zeus
{ _x addCuratorEditableObjects [[_wreck], true] } forEach allCurators;

//TODO: HANDLE IF THIS FAILS AS THE COUNT WILL BE WRONG!

// Generate the crates.
for "_i" from 1 to _crateNo do {
	private _ammoType = selectRandom ["Box_Syndicate_Ammo_F","Box_Syndicate_WpsLaunch_F"];
	private _ammoPos = [_tskCentre, 100 + random 50, 200, 2, 0, 0.5, 0, [], [ _tskPos, _tskPos ]] call BIS_fnc_findSafePos;
	_ammoPos = _ammoPos findEmptyPosition [1, 25, _ammoType];

	if (count _ammoPos > 0) then { 
		private _ammoObj = _ammoType createVehicle _ammoPos;
		_ammoObj setDir random 90;
		
		missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _i], _ammoObj];
		
		_tskActivation pushBack format["!alive ZMM_%1_OBJ_%2", _zoneID, _i];
		
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
		private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate the crate somewhere within the marked area.<br/><br/>Target Object: <font color='#00FFFF'>%1</font><br/><br/><img width='300' image='%2'/>", getText (configFile >> "CfgVehicles" >> _ammoType >> "displayName"), getText (configFile >> "CfgVehicles" >> _ammoType >> "editorPreview")], format["Crate #%1", _i], format["MKR_%1_OBJ_%2", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["move%1", _i]] call BIS_fnc_setTask;
		private _childTrigger = createTrigger ["EmptyDetector", _ammoPos, false];
		_childTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
		_childTrigger setTriggerStatements [ format["!alive ZMM_%1_OBJ_%2", _zoneID, _i],
			format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2';", _zoneID, _i],
			"" ];

		// Create enemy Team
		private _enemyTeam = [];
		for "_j" from 0 to (3 * (missionNamespace getVariable ["ZZM_Diff", 1])) do { _enemyTeam set [_j, selectRandom _enemyMen] };
		
		private _milGroup = [_ammoObj getPos [random 2, random 360], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
		{ _x setUnitPos "MIDDLE" } forEach units _milGroup;
		_milGroup setGroupIdGlobal [format["ZMM_%1_OBJGRP_%2", _zoneID, _i]];
		{ _x addCuratorEditableObjects [[_ammoObj] + units _milGroup, true] } forEach allCurators;
	};
};

if (_tskActivation isEqualTo []) exitWith {
	["ERROR", format["Zone %1 failed to generate objectives", _zoneID]] call zmm_fnc_misc_logMsg;
	false
};

// Create Completion Trigger
private _tskTrigger = createTrigger ["EmptyDetector", _tskPos, false];
_tskTrigger setTriggerStatements [  (_tskActivation joinString " && "),
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_Z%1_LOC','MKR_Z%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _tskTrigger, true];
[_tskTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _tskTrigger];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _tskDesc, _crateNo, _locName], ["Crash"] call zmm_fnc_nameGen, format["MKR_Z%1_LOC", _zoneID]], _tskCentre, "CREATED", 1, false, true, "plane"] call BIS_fnc_setTask;

true