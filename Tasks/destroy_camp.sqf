// Set-up mission variables.
params [ ["_zoneID", 0], "_targetPos" ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];

_missionDesc = [
		"Destroy a <font color='#00FFFF'>Communications Station</font> recently occupied by enemy forces.",
		"The enemy has established a <font color='#00FFFF'>Communications Station</font>, it must be destroyed.",
		"We've picked up a signal indicating a small <font color='#00FFFF'>Communications Station</font> is present, destroy it.",
		"Destroy the <font color='#00FFFF'>Communications Station</font> at the marked location.",
		"Intel has identified a small enemy <font color='#00FFFF'>Communications Station</font>, destroy it.",
		"A UAV has spotted an enemy <font color='#00FFFF'>Communications Station</font>, it must be destroyed quickly."
	];	

_centreObj = "Land_ClutterCutter_small_F" createVehicle _targetPos; 
_centreObj setDir random 360; 
 
{ 
 _x params ["_type", ["_script",""], ["_flat", TRUE], ["_offset", [0,0,0]], ["_dir", 0]]; 
  
	_obj = _type createVehicle [0,0,0]; 
	
	
	_localPos = [_centreObj worldToModel (getPosATL _centreObj),_offset] call BIS_fnc_vectorAdd;
	_worldPos = _centreObj modelToWorld _localPos;
	_worldPos = ATLtoASL _worldPos;

	_obj setPosASL _worldPos;
	_obj setDir ((getDir _centreObj) + _dir);
  
	if _flat then { _obj setVectorUp [0,0,1] };
	
	if !(_script isEqualTo "") then { _nul = call _script };
} forEach [ 
	["Land_Cargo_House_V2_F", {[_zoneID, 2, (_obj buildingPos -1)] spawn zmm_fnc_areaGarrison; TRUE}],  
	["Land_TTowerSmall_2_F", {missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _obj]; TRUE}, TRUE, [-3.5,-3,0]],  
	["Land_PaperBox_01_open_empty_F", {}, FALSE, [-5,-2.5,0], random 90],  
	["Land_PaperBox_01_open_empty_F", {}, FALSE, [-5.5,0.5,0], random 90],  
	["CamoNet_ghex_open_F", {}, TRUE, [-2,0,0.75]] 
];

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [ 	format["!alive ZMM_%1_OBJ", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc], ["Outpost"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "radio"] call BIS_fnc_setTask;

TRUE