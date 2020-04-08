// Set-up mission variables.
params [ ["_zoneID", 0], ["_bld", objNull], ["_targetPos", [0,0,0]] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_enemyTeam = selectRandom (missionNamespace getVariable[format["ZMM_%1Grp_Team",_enemySide],["O_Soldier_F"]]); // CfgGroups entry.
_buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], []];
_locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];

_missionDesc = [
		"Locate and eliminate <font color='#00FFFF'>El %3</font> also known as %2.<br/><br/>They can be found nearby %1 within the marked location.",
		"An Officer named %2 or better identified as <font color='#00FFFF'>The %3</font> has been spotted entering the area near %1, they must be eliminated.",
		"There is an enemy insurgent known as <font color='#00FFFF'>The %3</font>, real name %2.<br/><br/>%2 is trying to leave %1 and is awaiting extraction from this location, they must be tracked down and eliminated.",
		"Find and eliminate <font color='#00FFFF'>%2</font> codename '%3' hiding somewhere in or near %1.",
		"A local known as <font color='#00FFFF'>The %3</font> has been identified as %2.<br/><br/>%2 has been seen moving around the area outside %1, find them and kill them.",
		"A high-ranking Officer until only identified as <font color='#00FFFF'>La %3</font>, has recently been uncovered as %2.<br/><br/>%2 has been confirmed to be somewhere in the area near %1, ensure they are eliminated."
	];

if (isNil "_bld") then { _bld = objNull };
	
// Use a zone building if none passed.
if (count _buildings > 0 && {isNull _bld}) then { _bld = selectRandom _buildings };

// Get any building if we have none
if (isNull _bld) then { _bld = nearestBuilding _centre };

// Return building positions
private _bldPos = _bld buildingPos -1;

// If building is too far ignore it
if (_bld distance _centre > 100) then { _bldPos = [] };

// Create HVT Team
private _milGroup = [([_centre, 1, 150, 2, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos), _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
{
	if (leader _x == _x) then { 
		_x addHeadGear "H_Beret_blk";
		_x setVariable ["var_zoneID", _zoneID, true];
		removeFromRemainsCollector [_x];
	};
	
	_x disableAI "PATH";
	_x setSkill 0.5 + random 0.3;
	
	if (count _bldPos > 0) then {
		_tempPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _tempPos);
		_x setPosATL _tempPos;
	} else {
		_x setPosATL ((getPos leader _x) findEmptyPosition [3, 25, "B_Soldier_F"]);
		_x setDir random 360;
		_x setUnitPosWeak "MIDDLE";
	};
} forEach units _milGroup;

private _alias = ["Butcher", "Diablo", "Doctor", "Reaper", "Scorpion", "Hyena", "Jackal", "Lion", "Serpent"];

private _headText = if (isClass (configFile >> "CfgWeapons" >> headgear (leader _milGroup))) then {
		format["<br/><br/>You will need to verify the identity of the target when eliminated. The target is known to be wearing a <font color='#00FFFF'>%1</font>.<br/><br/><img image='%2' width='60'/>", getText (configFile >> "CfgWeapons" >> headgear (leader _milGroup) >> "displayName"), getText (configFile >> "CfgWeapons" >> headgear (leader _milGroup) >> "picture")];
	} else { "" };
	
// Create Completion Action
[leader _milGroup, 
	format["<t color='#00FF80'>Verify identify of %1</t>", name leader _milGroup], 
	"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_forceRespawn_ca.paa", 
	"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_forceRespawn_ca.paa", 
	"_this distance _target < 3 && !alive _target", 
	"_caller distance _target < 3 && !alive _target", 
	{}, 
	{}, 
	{
		[_target, _actionId] remoteExec ["BIS_fnc_holdActionRemove"];
		_caller playAction "PutDown";
		sleep 1;
		private _zoneID = _target getVariable ["var_zoneID", 0];
		format["MKR_%1_OBJ_%2", _zoneID] setMarkerAlpha 0;
		[name _caller, format["Target %1 as eliminated.", selectRandom ["verified", "confirmed", "identified"]]] remoteExec ["BIS_fnc_showSubtitle"];
		[format["ZMM_%1_TSK", _zoneID], 'Succeeded', true] remoteExec ["BIS_fnc_taskSetState"];
		missionNamespace setVariable ['ZMM_DONE', true, true];
		{ _x setMarkerColor "ColorWest" } forEach [format['MKR_%1_LOC', _zoneID], format['MKR_%1_MIN', _zoneID]];
		[_target, { sleep 120; deleteVehicle _this }] remoteExec ["BIS_fnc_spawn", _target];
	}, 
	{}, 
	[], 
	2, 
	10 
] remoteExec ["bis_fnc_holdActionAdd", 0, leader _milGroup];

// Add to Zeus
{ _x addCuratorEditableObjects [units _milGroup, true] } forEach allCurators;

// Create Completion Trigger
missionNamespace setVariable [format["ZMM_%1_HVT", _zoneID], leader _milGroup];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc + _headText, _locName, name leader _milGroup, selectRandom _alias], ["Killer"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "target"] call BIS_fnc_setTask;

TRUE