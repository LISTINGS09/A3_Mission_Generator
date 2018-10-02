// Set-up mission variables.
params [ ["_zoneID", 0], ["_bld", objNull ]];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_enemyTeam = selectRandom (missionNamespace getVariable[format["ZMM_%1Grp_Team",_enemySide],[""]]); // CfgGroups entry.
_buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], []];

_nearLoc = (nearestLocations [_centre, ["Airport", "NameCityCapital", "NameCity", "NameVillage", "NameLocal"], 10000, _centre])#0;
_locName = if (getPos _nearLoc distance2D _centre < 200) then { text _nearLoc } else { "this Location" };

_missionDesc = [
		"Locate and rescue <font color='#00FFFF'>%2 %3</font> who have been captured nearby %1.",
		"Save <font color='#00FFFF'>%2 %3</font> who were spotted by the enemy entering %1, they must be saved.",
		"There are <font color='#00FFFF'>%2 %3</font> who where trying to flee %1 but were captured and are awaiting execution, rescue them.",
		"Find and rescue <font color='#00FFFF'>%2 %3</font> being held hostage somewhere nearby %1.",
		"Set free <font color='#00FFFF'>%2 %3</font> last seen around the area outside %1, find them and rescue them.",
		"A group of <font color='#00FFFF'>%2 %3</font> are confirmed to be in the area near %1, ensure they are brought back to safety."
	];

// Use a zone buildings if no building was passed.
if (count _buildings > 0 && {isNull _bld}) then { _bld = selectRandom _buildings };

// Use location centre if no buildings at all.
_bldLoc = if (isNull _bld) then { _centre } else { getPos _bld };

// Return building positions or empty if not a building.
_bldPos = if !(_bld isEqualType []) then { _bld buildingPos -1 } else { [] };

// Find a random point nearby for markers.
_relPos = [ _bldLoc, random 50, random 360 ] call BIS_fnc_relPos;

// Create Markers
_mrk = createMarker [ format[ "MKR_%1_OBJ", _zoneID ], _relPos ];
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerBrush "SolidBorder";
_mrk setMarkerAlpha 0.5;
_mrk setMarkerColor format[ "color%1", _enemySide ];
_mrk setMarkerSize [ 50, 50 ];

_mrk = createMarker [ format["MKR_%1_ICO", _zoneID ], _relPos ];
_mrk setMarkerType "mil_unknown";
_mrk setMarkerAlpha 0.5;
_mrk setMarkerColor format[ "color%1", _enemySide ];
_mrk setMarkerSize [ 0.8, 0.8 ];

// Create HVT Team
_civNum = 1 + random 2;
_hvtActivation = [];

_rescueType = if (random 50 > 100) then { "Soldiers" } else { "Civilians" };
_tempPlayer = (allPlayers select {alive _x}) select 0;

for "_i" from 0 to _civNum do {
	_hvt = (createGroup civilian) createUnit ["C_man_w_worker_F", [0,0,0], [], 0, "NONE"];
	
	if (_rescueType isEqualTo "Soldiers") then {
		_hvt forceAddUniform (uniform _tempPlayer);
		_hvt addVest (vest _tempPlayer);
		_hvt addHeadgear (headgear _tempPlayer);
	};
	
	missionNamespace setVariable [format["ZMM_%1_HVT_%2", _zoneID, _i], _hvt];

	if (count _bldPos > 0) then {
		_tempPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _tempPos);
		_hvt setPosATL _tempPos;
	} else {
		_hvt setPosATL (_bldLoc findEmptyPosition [5, 25, "B_Soldier_F"]);
	};
	
	// Failure trigger when HVT is dead.
	_hvtTrigger = createTrigger ["EmptyDetector", _centre, false];
	_hvtTrigger setTriggerStatements [ 	format["!alive ZMM_%1_HVT_%2", _zoneID, _i], 
									format["['ZMM_%1_TSK', 'Failed', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];
									
	// Build success trigger when HVT is alive and far from objective.
	_hvtActivation pushBack format["(alive ZMM_%1_HVT_%2 && ZMM_%1_HVT_%2 distance2D %3 > 400)", _zoneID, _i, _centre];
	
	// Select random pose for HVT.
	[_hvt, selectRandom ["AmovPercMstpSnonWnonDnon_Ease", "Acts_JetsMarshallingStop_loop", "Acts_JetsShooterIdle"]] remoteExec ["switchMove"]; 
	_hvt disableAI "ALL";
	_hvt setDir random 360;

	// Add HVT Action for player.
	[_hvt, 
		"<t color='#00FF80'>Untie Hostage</t>", 
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_unbind_ca.paa",  
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_unbind_ca.paa",  
		"_this distance _target < 3",   
		"_caller distance _target < 3",   
		{}, 
		{}, 
		{ 
			[_target, "ALL"] remoteExec ["enableAI", _target]; 
			[_target, ""] remoteExec ["playMoveNow", _target];  
			[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
			sleep 1;
			[_target] joinSilent group _caller; 
		}, 
		{}, 
		[], 
		3, 
		10 
	] remoteExec ["BIS_fnc_holdActionAdd", 0];
	
	{
		_x addCuratorEditableObjects [[_hvt], TRUE];
	} forEach allCurators;
};

// Create enemy Team
_milGroup = [[0,0,0], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;

{
	doStop _x;
	
	if (count _bldPos > 0) then {
		_tempPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _tempPos);
		_x setPosATL _tempPos;
	} else {
		_x setPos (_bldLoc getPos [random 10, random 360]);
	};
	
	_x setUnitPosWeak "MIDDLE";
	_x setDir ((_x getDir _bldLoc) - 180);
	_x setFormDir ((_x getDir _bldLoc) - 180);
} forEach units _milGroup;

// Add to Zeus
{
	_x addCuratorEditableObjects [units _milGroup, TRUE];
} forEach allCurators;

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerStatements [ 	(_hvtActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN','MKR_%1_OBJ','MKR_%1_ICO']", _zoneID, _playerSide],
									"" ];
// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, round _civNum, _rescueType], ["Rescue"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "help"] call BIS_fnc_setTask;

TRUE