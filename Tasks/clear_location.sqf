// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _menArray = missionNamespace getVariable [format["ZMM_%1Man", _enemySide], ["O_Solider_F"]];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _minUnits = missionNamespace getVariable ["ZZM_ObjectiveCount", 3];

private _missionDesc = [
		"Enemy forces have occupied an area near <font color='#00FFFF'>%1</font>, eliminate 90&#37; of their forces.",
		"A number of enemy groups have been spotted nearby <font color='#00FFFF'>%1</font>, locate and eliminate 90&#37; of all contacts.",
		"Eliminate all enemy forces in the area nearby <font color='#00FFFF'>%1</font>. Ensure at least 90&#37; of the enemy forces are killed.",
		"Enemy forces have recently entered <font color='#00FFFF'>%1</font>, destroy 90&#37; of their forces before they can reinforce it.",
		"The enemy appears to have occupied <font color='#00FFFF'>%1</font> overnight, eliminate 90&#37; of all forces there.",
		"Enemy forces are trying to capture <font color='#00FFFF'>%1</font>, move in and eliminate 90&#37; of all resistance."
	];		

private _locPos = [_centre, 1, _radius, 2, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
_locPos = _locPos findEmptyPosition [1, 25, "B_Soldier_F"];

// No near position found, just use the centre.
if (count _locPos <= 0) then { _locPos = _centre; };
	
// Create Objective
private _enemyTeam = [];
for "_j" from 0 to (8 * (missionNamespace getVariable ["ZZM_Diff", 1])) do { _enemyTeam set [_j, selectRandom _menArray] };
			
private _milGroup = [_locPos, _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
[_milGroup, _centre, 10] call bis_fnc_taskPatrol;

// Add to Zeus
{ _x addCuratorEditableObjects [units _milGroup, true] } forEach allCurators;

// Create Completion Trigger
missionNamespace setVariable [format["ZMM_%1_TSK_Group", _zoneID], _milGroup];

private _objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerActivation [format["%1",_enemySide], "NOT PRESENT", false];
_objTrigger setTriggerArea [_radius, _radius, 0, true];
_objTrigger setTriggerStatements [  format["count thisList <=  %1", _minUnits], 
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName], [_locName] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "attack"] call BIS_fnc_setTask;

true