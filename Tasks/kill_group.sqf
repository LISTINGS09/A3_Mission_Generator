// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyTeam = selectRandom (missionNamespace getVariable[format["ZMM_%1Grp_Team",_enemySide],[""]]); // CfgGroups entry.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];

private _missionDesc = [
		"A <font color='#00FFFF'>%2</font> has been spotted at %1, find, kill and confirm the deaths of the <font color='#00FFFF'>%3 Members</font>.",
		"A <font color='#00FFFF'>%2</font> has been spotted moving around %1, hunt them down and verify the elimination of the <font color='#00FFFF'>%3 Targets</font>.",
		"Track and eliminate a <font color='#00FFFF'>%2</font> somewhere near %1. You will need to confirm the identity of the <font color='#00FFFF'>%3 Targets</font> when killed.",
		"One <font color='#00FFFF'>%2</font> is located somewhere nearby, find them, kill them then verify each the <font color='#00FFFF'>%3 members</font>.",
		"A <font color='#00FFFF'>%2</font> of enemy soldiers have para-dropped into %1, locate and eliminate the <font color='#00FFFF'>%3 Units</font> and verify their identities.",
		"Find and kill a <font color='#00FFFF'>%2</font>, patrolling somewhere around %1. Each person in the <font color='#00FFFF'>%3 Man Group</font> will need their identity verified."
	];	
	
private _grpName = format["%1 %2", selectRandom ["Elite","Specialist","Special","Veteran"], selectRandom ["Group","Unit","Forces Team","Squad","Operator Team"] ];

// Create Objective
private _milGroup = [([_centre, 1, 150, 2, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos), _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
private _endActivation = [];
private _headGear = selectRandom ["H_Beret_blk","H_Beret_CSAT_01_F","H_Beret_gen_F","H_Beret_EAF_01_F"];

{
	_x addHeadGear _headGear;
	_x unlinkItem (hmd _x);
	_x setSkill 0.5 + random 0.3;
	_x setVariable ["var_zoneID", _zoneID, true];
	_x setVariable ["var_unitID", _forEachIndex, true];
	removeFromRemainsCollector [_x];
			
	_x addEventHandler ["Killed", {
		params ["_unit", "_killer"];
		private _zoneID = _unit getVariable ["var_zoneID", 0];
		private _unitID = _unit getVariable ["var_unitID", 0];
		
		private _mrkr = createMarker [format["MKR_%1_LOC_%2", _zoneID, _unitID], getPos _unit];
		_mrkr setMarkerShape "ICON";
		_mrkr setMarkerType "mil_unknown";
		_mrkr setMarkerAlpha 0.4;
		_mrkr setMarkerColor format["Color%1", side group _unit];
	}];
	
	[_x, 
		format["<t color='#00FF80'>Verify identify of %1</t>", name _x], 
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_forceRespawn_ca.paa", 
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_forceRespawn_ca.paa", 
		"_this distance _target < 4 && !alive _target", 
		"_caller distance _target < 4 && !alive _target", 
		{}, 
		{}, 
		{
			[_target, _actionId] remoteExec ["BIS_fnc_holdActionRemove"];
			_caller playAction "PutDown";
			sleep 1;
			private _zoneID = _target getVariable ["var_zoneID", 0];
			private _unitID = _target getVariable ["var_unitID", 0];
			deleteMarker format["MKR_%1_LOC_%2", _zoneID, _unitID];
			[name _caller, format["Target %1 as %2.", selectRandom ["verified", "confirmed", "identified"], selectRandom ["Eliminated","Deceased","Dead","Killed"]]] remoteExec ["BIS_fnc_showSubtitle"];
			addToRemainsCollector [_target];
			
			[format["ZMM_%1_SUB_%2", _zoneID, _unitID], 'Succeeded', true] remoteExec ["BIS_fnc_taskSetState"];
			missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _unitID], true];
		}, 
		{}, 
		[], 
		2, 
		10 
	] remoteExec ["bis_fnc_holdActionAdd", 0, _x];
	
	private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _forEachIndex], format['ZMM_%1_TSK', _zoneID]], true, [format["Verify the elimination of <font color='#FFA500'>%1</font> somewhere near %2.", name _x, _locName], format["%1", name _x], format["MKR_%1_LOC", _zoneID]], objNull, "CREATED", 1, false, true, "target"] call BIS_fnc_setTask;
	
	_endActivation pushBack format["(missionNamespace getVariable ['ZMM_%1_OBJ_%2', false])", _zoneID, _forEachIndex];
} forEach units _milGroup;

[_milGroup, _centre, 15] call bis_fnc_taskPatrol;

private _headText = if (isClass (configFile >> "CfgWeapons" >> headgear (leader _milGroup))) then {
		format["<br/><br/>You will need to verify the identity of each group member when eliminated. The targets can be identified as those wearing a <font color='#00FFFF'>%1</font>.<br/><br/><img image='%2' width='60'/>", getText (configFile >> "CfgWeapons" >> headgear (leader _milGroup) >> "displayName"), getText (configFile >> "CfgWeapons" >> headgear (leader _milGroup) >> "picture")];
	} else { "" };

// Add to Zeus
{
	_x addCuratorEditableObjects [units _milGroup, true];
} forEach allCurators;

private _objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerStatements [ 	(_endActivation joinString " && "),
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, _grpName, count units _milGroup] + _headText, ["Hunter"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "kill"] call BIS_fnc_setTask;

true