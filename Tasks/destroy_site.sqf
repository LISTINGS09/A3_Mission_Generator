// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _missionDesc = [
		"Destroy a <font color='#00FFFF'>%2</font> recently established by enemy forces somewhere within %1.",
		"The enemy has established a <font color='#00FFFF'>%2</font>, it must be destroyed. Search around %1 to locate it.",
		"We've picked up a signal indicating a small <font color='#00FFFF'>%2</font> is present somewhere within %1, find it and destroy it.",
		"Destroy the <font color='#00FFFF'>%2</font> found somewhere within %1.",
		"Intel has identified a small enemy <font color='#00FFFF'>%2</font> around %1, destroy it.",
		"A UAV flying over %1 has spotted enemy movements that indicate a <font color='#00FFFF'>%2</font> is present in the area. Move into %1, locate the site and destroy it swiftly."
	];

if (_centre isEqualTo _targetPos || _targetPos isEqualTo [0,0,0]) then { _targetPos = [_centre, 25, 200, 5, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos; _targetPos set [2,0]; };
	
private _targetType = selectRandom ["Land_TTowerSmall_1_F","Land_TTowerSmall_2_F"];
 
[_zoneID, _targetPos, false] call zmm_fnc_areaSite;
 
private _foundArr = _targetPos nearObjects ["Land_Sacks_heap_F", 50];

if (count _foundArr > 0) then {
	_targetPos = getPos (_foundArr#0);
	deleteVehicle (_foundArr#0);
};

private _obj = createVehicle [_targetType, _targetPos, [], 0, "NONE"];
_obj setVectorUp [0,0,1];

missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _obj];

{ _x addCuratorEditableObjects [[_obj], true] } forEach allCurators;

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [ 	format["!alive ZMM_%1_OBJ", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, format["%1 %2", selectRandom ["Communications", "Listening", "Radio", "LRR"], selectRandom ["Station", "Post", "Site", "Camp"]]] + format["<br/><br/>Target Tower: <font color='#00FFFF'>%1</font><br/><br/><img width='300' image='%2'/>", getText (configFile >> "CfgVehicles" >> _targetType >> "displayName"), getText (configFile >> "CfgVehicles" >> _targetType >> "editorPreview")], ["SITE"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "radio"] call BIS_fnc_setTask;

true