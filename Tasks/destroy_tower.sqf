// Set-up mission variables.
params [ ["_zoneID", 0], ["_tskPos", [0,0,0]] ];

_tskCentre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _tskPos];

_tskDesc = [
		"Destroy a <font color='#00FFFF'>%1</font> recently constructed by enemy forces.",
		"The enemy has established a <font color='#00FFFF'>%1</font> at this location, destroy it.",
		"We've picked up a signal indicating a <font color='#00FFFF'>%1</font> is present in the area, destroy it.",
		"Destroy the <font color='#00FFFF'>%1</font> at the marked location.",
		"Intel has identified an enemy <font color='#00FFFF'>%1</font>, destroy it.",
		"A UAV has spotted an enemy <font color='#00FFFF'>%1</font> recently built by the enemy, destroy it."
	];

_objClass = selectRandom ["Land_TTowerBig_1_F","Land_TTowerBig_2_F","Land_Communication_F"];

if (_tskCentre isEqualTo _tskPos || _tskPos isEqualTo [0,0,0]) then { _tskPos = [_tskCentre, 25, 200, 5, 0, 0.5, 0, [], [ _tskCentre, _tskCentre ]] call BIS_fnc_findSafePos };
if (isNil "_tskPos") then { _tskPos = _tskCentre };
_tskPos set [2,0];

// Check a tower isn't already nearby.
_nearTowers = (_tskCentre nearObjects ["building", 300]) select {typeOf _x in ["Land_TTowerBig_1_F", "Land_TTowerBig_2_F", "Land_Communication_F"]};
_obj = objNull;

if (count _nearTowers > 0) then {
	_obj = selectRandom _nearTowers;
} else {
	if !(isClass (configFile >> "CfgVehicles" >> _objClass)) exitWith {
		format["[ZMM] Invalid vehicle class: %1", _objClass] call zmm_fnc_misc_logMsg;
		false
	};

	_emptyPos = _tskPos findEmptyPosition [1, 50, _objClass];

	if !(count _emptyPos > 0) then { _emptyPos = _tskPos; };
		
	_obj = createVehicle [_objClass, _emptyPos, [], 0, "NONE"];
	_obj setVectorUp [0,0,1];
};

missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _obj];

// Create Completion Trigger
_tskTrigger = createTrigger ["EmptyDetector", _tskPos, false];
_tskTrigger setTriggerStatements [ 	format["!alive ZMM_%1_OBJ", _zoneID], 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_Z%1_LOC','MKR_Z%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _tskTrigger, true];
[_tskTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _tskTrigger];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _tskDesc, getText (configFile >> "CfgVehicles" >> _objClass >> "displayName")] + format["<br/><br/><img width='350' image='%1'/>", getText (configFile >> "CfgVehicles" >> _objClass >> "editorPreview")], ["Tower"] call zmm_fnc_nameGen, format["MKR_Z%1_LOC", _zoneID]], _tskCentre, "CREATED", 1, false, true, "destroy"] call BIS_fnc_setTask;

true