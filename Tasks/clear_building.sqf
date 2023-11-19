// Clear a building of enemy forces.
// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]]];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

_missionDesc = [
		"A number of enemy strongholds have been located within %1. Clear out the <font color='#00FFFF'>%2%3</font> identified in this area.",
		"Enemy forces have recently reinforced %1 and occupied <font color='#00FFFF'>%2%3</font>. Eliminate all contacts found within.",
		"Locate <font color='#00FFFF'>%2%3</font> within the %1 and clear them of all enemy forces.",
		"Locate and clear <font color='#00FFFF'>%2%3</font> somewhere around %1.",
		"<font color='#00FFFF'>%2%3</font> located within %1 have been occupied by enemy forces, recapture all marked areas.",
		"Clear out the enemy found within <font color='#00FFFF'>%2%3</font> in %1."
	];

_buildCount = missionNamespace getVariable ["ZZM_ObjectiveCount", 3];

private _targetArr = [];
private _tempBlds = nearestObjects [_centre, ["building","static"], 150, true];
private _bldHuge = _tempBlds select { count (_x buildingPos -1) >= 12 }; // Get Huge Buildings
private _bldLarge = _tempBlds select { count (_x buildingPos -1) >= 8 }; // Get Large Buildings
private _bldSmall = _tempBlds select { count (_x buildingPos -1) >= 3 }; // Get Normal Buildings
private _foundBlds = if (count _bldHuge >= _buildCount) then { _bldHuge } else { if (count _bldLarge >= _buildCount) then { _bldLarge } else { _bldSmall }; };

// Sill nothing? Use nearest building.
if (count _foundBlds == 0) then { 
	_targetArr pushBack (nearestBuilding _centre);
} else {
	for "_i" from 0 to _buildCount do {
		if (count _foundBlds < 1) exitWith {};
		
		private _bld = selectRandom _foundBlds;
		_foundBlds = _foundBlds - [_bld];
		_targetArr pushBack _bld;
	};
};

private _endActivation = [];

{
	missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _forEachIndex], _x];
	_endActivation pushBack format["triggerActivated ZMM_%1_TR_%2", _zoneID, _forEachIndex];
	
	// Mark out the target.
	private _mrkr = _x call BIS_fnc_boundingBoxMarker;
	_mrkr setMarkerColor format["Color%1", _enemySide];

	private _max = ((getMarkerSize _mrkr)#0) max ((getMarkerSize _mrkr)#1);

	private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _forEachIndex], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate and clear the building.<br/><br/>Target Building: <font color='#FFA500'>%1</font><br/><img width='350' image='%2'/>", getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName"), getText (configFile >> "CfgVehicles" >> typeOf _x >> "editorPreview")], getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName"), format["MKR_%1_LOC", _zoneID]], _x, "CREATED", 1, false, true, format["move%1", _forEachIndex + 1]] call BIS_fnc_setTask;
	private _childTrigger = createTrigger ["EmptyDetector", position _x, false];
	_childTrigger setTriggerActivation [format["%1",_enemySide], "NOT PRESENT", false];
	_childTrigger setTriggerArea [_max, _max, 0, true];
	_childTrigger setTriggerTimeout [10, 10, 10, true];
	_childTrigger setTriggerStatements [  format["count thisList <= %1", (count (_x buildingPos -1) min 2)], 
										format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker '%3';", _zoneID, _forEachIndex, _mrkr],
										"" ];
										
	missionNamespace setVariable [format["ZMM_%1_TR_%2", _zoneID, _forEachIndex], _childTrigger, true];

	[_zoneID, ((count (_x buildingPos -1)) / 2) max (4 + random 4), _x] call zmm_fnc_areaGarrison; // Fill with some units.
} forEach _targetArr;

_endActivation pushBack true; // Fix single objective join

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_objTrigger setTriggerStatements [  (_endActivation joinString " && "), 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _objTrigger, true];
[_objTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _objTrigger];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, count _targetArr, if (count _targetArr > 1) then { " Buildings" } else { " Building" }], ["Clear"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "target"] call BIS_fnc_setTask;

true