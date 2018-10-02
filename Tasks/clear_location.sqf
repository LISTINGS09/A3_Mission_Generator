// Set-up mission variables.
params [ ["_zoneID", 0] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_enemyType = selectRandom (missionNamespace getVariable[format["ZMM_%1Grp_Squad",_enemySide],[""]]); // CfgGroups entry.
_radius = (getMarkerSize format["MKR_%1_MIN", _zoneID]) select 0; // Area of Zone.

_nearLoc = (nearestLocations [_centre, ["Airport", "NameCityCapital", "NameCity", "NameVillage", "NameLocal"], 10000, _centre])#0;
_locName = if (getPos _nearLoc distance2D _centre < 200) then { text _nearLoc } else { "this Location" };
_locType = if (getPos _nearLoc distance2D _centre < 200) then { type _nearLoc } else { "Custom" };

_minUnits = switch (_locType) do {
	case "Airport": { 6 };
	case "NameCityCapital": { 5 };
	case "NameCity": { 4 };
	case "NameVillage": { 3 };
	case "NameLocal": { 3 };
	default { 2 };
};

_missionDesc = [
		"Enemy forces have occupied an area near <font color='#00FFFF'>%1</font>, eliminate them.",
		"A number of enemy groups have been spotted nearby <font color='#00FFFF'>%1</font>, locate and eliminate all contacts.",
		"Eliminate all enemy forces in the area nearby <font color='#00FFFF'>%1</font>.",
		"Enemy forces have recently entered <font color='#00FFFF'>%1</font>, destroy them before they can reinforce it.",
		"The enemy appears to have occupied <font color='#00FFFF'>%1</font> overnight, eliminate all forces there.",
		"Enemy forces are trying to capture <font color='#00FFFF'>%1</font>, move in and eliminate all resistance."
	];		

_locPos = [_centre, 1, _radius, 2, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
_locPos = _locPos findEmptyPosition [1, 25, "B_Soldier_F"];

// No near position found, just use the centre.
if (count _locPos <= 0) then { _locPos = _centre; };
	
// Create Objective
_milGroup = [_locPos, _enemySide, _enemyType] call BIS_fnc_spawnGroup;
[_milGroup, _centre, 50] call bis_fnc_taskPatrol;

// Add to Zeus
{
	_x addCuratorEditableObjects [units _milGroup, TRUE];
} forEach allCurators;

// Create Completion Trigger
missionNamespace setVariable [format["ZMM_%1_TSK_Group", _zoneID], _milGroup];

_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerActivation [format["%1",_enemySide], "NOT PRESENT", FALSE];
_objTrigger setTriggerArea [_radius, _radius, 0, TRUE];
_objTrigger setTriggerStatements [  format["count thisList <=  %1", _minUnits], 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName], [_locName] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "attack"] call BIS_fnc_setTask;

TRUE