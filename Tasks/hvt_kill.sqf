// Set-up mission variables.
params [ ["_zoneID", 0], ["_bld", objNull] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_enemyTeam = selectRandom (missionNamespace getVariable[format["ZMM_%1Grp_Team",_enemySide],[""]]); // CfgGroups entry.
_buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], []];

_nearLoc = (nearestLocations [_centre, ["Airport", "NameCityCapital", "NameCity", "NameVillage", "NameLocal"], 10000, _centre])#0;
_locName = if (getPos _nearLoc distance2D _centre < 200) then { text _nearLoc } else { "this Location" };

_missionDesc = [
		"Locate and eliminate a <font color='#00FFFF'>HVT</font> nearby %1 within the marked location.",
		"An <font color='#00FFFF'>Officer</font> has been spotted entering the area near %1, they must be eliminated.",
		"There is an enemy <font color='#00FFFF'>HVT</font> is trying to leave %1 and is awaiting extraction from this location, they must be eliminated.",
		"Find and eliminate the <font color='#00FFFF'>Officer</font> hiding somewhere nearby %1.",
		"An <font color='#00FFFF'>HVT</font> has been seen moving around the area outside %1, find them and kill them.",
		"A high-ranking <font color='#00FFFF'>Officer</font> is confirmed to be in the area near %1, ensure they are eliminated."
	];

// Use a zone buildings if none was passed.
if (count _buildings > 0 && {isNull _bld}) then { _bld = selectRandom _buildings };

// Return building positions
_bldPos = _bld buildingPos -1;

// Create HVT Team
_milGroup = [[0,0,0], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
{
	if (leader _x == _x) then { _x addHeadGear "H_Beret_blk"; removeFromRemainsCollector [_x]; };
	
	doStop _x;

	_x setSkill 0.5 + random 0.3;
	if (count _bldPos > 0) then {
		_tempPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _tempPos);
		_x setPosATL _tempPos;
	} else {
		_x setPosATL ((position _bld) findEmptyPosition [1, 25, "B_Soldier_F"]);
		_x setDir ((_x getDir _bld) - 180);
		_x setUnitPosWeak "MIDDLE";
	};
} forEach units _milGroup;

// Add to Zeus
{
	_x addCuratorEditableObjects [units _milGroup, true];
} forEach allCurators;

// Create Completion Trigger
missionNamespace setVariable [format["ZMM_%1_HVT", _zoneID], leader _milGroup];

_objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerStatements [ 	format["!alive ZMM_%1_HVT", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];
// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName], ["Killer"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "target"] call BIS_fnc_setTask;
//missionNamespace setVariable ["ZMM_Task", _missionTask, TRUE];

TRUE