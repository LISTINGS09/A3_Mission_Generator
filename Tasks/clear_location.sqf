// Set-up mission variables.
params [ ["_zoneID", 0], ["_tskPos", [0,0,0]] ];

private _tskCentre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _tskPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyMen = missionNamespace getVariable [format["ZMM_%1_Man", _enemySide], ["O_Soldier_F"]];
private _tskRadius = ((getMarkerSize format["MKR_Z%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _minUnits = missionNamespace getVariable ["ZZM_ObjectiveCount", 3];

private _tskDesc = [
		"Enemy forces have occupied an area near <font color='#00FFFF'>%1</font>, eliminate 75&#37; of their forces (%2 Grids).",
		"A number of enemy groups have been spotted nearby <font color='#00FFFF'>%1</font>, locate and eliminate 75&#37; of all contacts (%2 Grids).",
		"Eliminate all enemy forces in the area nearby <font color='#00FFFF'>%1</font>. Ensure at least 90&#37; of the enemy forces are killed (%2 Grids).",
		"Enemy forces have recently entered <font color='#00FFFF'>%1</font>, destroy 75&#37; of their forces before they can reinforce it (%2 Grids).",
		"The enemy appears to have occupied <font color='#00FFFF'>%1</font> overnight, eliminate 75&#37; of all forces there (%2 Grids).",
		"Enemy forces are trying to capture <font color='#00FFFF'>%1</font>, move in and eliminate 75&#37; of all resistance (%2 Grids)."
	];		

private _locPos = [_tskCentre, 1, _tskRadius, 2, 0, 0.5, 0, [], [ _tskCentre, _tskCentre ]] call BIS_fnc_findSafePos;
_locPos = _locPos findEmptyPosition [1, 25, "B_Soldier_F"];

// No near position found, just use the centre.
if (count _locPos <= 0) then { _locPos = _tskCentre; };
	
// Create Objective
private _enemyTeam = [];
for "_j" from 0 to (3 * (missionNamespace getVariable ["ZZM_Diff", 1])) do { _enemyTeam set [_j, selectRandom _enemyMen] };
			
private _milGroup = [_locPos, _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
[_milGroup, _tskCentre, 10] call bis_fnc_taskPatrol;

_milGroup setGroupIdGlobal [format["ZMM_%1_OBJGRP", _zoneID]];

// Create Enemy Heatmap
private _gridTotal = [_zoneID, _tskCentre] call zmm_fnc_fillGrid;
private _gridCount = round (_gridTotal * 0.75);

// Add to Zeus
{ _x addCuratorEditableObjects [units _milGroup, true] } forEach allCurators;

// Create Completion Trigger
missionNamespace setVariable [format["ZMM_%1_TSK_Group", _zoneID], _milGroup];

private _tskTrigger = createTrigger ["EmptyDetector", _tskCentre, false];
_tskTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_tskTrigger setTriggerStatements [  format["(missionNamespace getVariable ['ZMM_%1_GRID',0]) >= %2", _zoneID, _gridCount], 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_Z%1_LOC','MKR_Z%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _tskTrigger, true];
[_tskTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _tskTrigger];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _tskDesc, _locName, _gridCount], [_locName] call zmm_fnc_nameGen, format["MKR_Z%1_LOC", _zoneID]], _tskCentre, "CREATED", 1, false, true, "attack"] call BIS_fnc_setTask;

true