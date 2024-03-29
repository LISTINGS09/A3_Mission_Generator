// Destroy a target building.
// Set-up mission variables.
// TOOD: Support multiple buildings
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]]];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = [
		"<font color='#00FFFF'>%2%3</font> are located in %1, find and destroy them.",
		"Enemy forces have recently reinforced %1 and constructed <font color='#00FFFF'>%2%3</font> there. They must be destroyed.",
		"Locate <font color='#00FFFF'>%2%3</font> within %1 and destroy them.",
		"Locate and destroy <font color='#00FFFF'>%2%3</font> somewhere around %1.",
		"<font color='#00FFFF'>%2%3</font> in %1 have been recently been constructed by the enemy, ensure they are destroyed.",
		"Destroy <font color='#00FFFF'>%2%3</font> somewhere around %1."
	];

private _count = missionNamespace getVariable ["ZZM_ObjectiveCount", 3];
private _targetArr = [];
private _targetTypes = ["Land_Research_house_V1_F", "Land_Research_HQ_F", "Land_dp_bigTank_F", 
	"Land_dp_smallTank_F", "Land_ReservoirTank_V1_F", "Land_ReservoirTank_Airport_F",
	"Land_ReservoirTank_Rust_F", "Land_TTowerSmall_1_F", "Land_TTowerSmall_2_F", 
	"Land_ReservoirTank_01_military_F", "Land_Radar_F", "Land_Radar_Small_F", "Land_TTowerBig_1_F", 
	"Land_TTowerBig_2_F", "Land_Communication_F", "Land_Warehouse_03_F",
	"Land_i_Shed_Ind_F", "Land_u_Shed_Ind_F", "Land_ReservoirTower_F",
	"Land_PowerLine_distributor_F","Land_dp_bigTank_old_F","Land_dp_smallTank_old_F",
	"Land_i_Shed_Ind_old_F","Land_SM_01_reservoirTower_F", "Land_WaterTower_01_F", "Land_WindmillPump_01_F",
	"Land_SM_01_shed_F", "Land_SM_01_shed_unfinished_F", "Land_DPP_01_transformer_F",
	"Land_wpp_Turbine_V2_F", "Land_wpp_Turbine_V1_F", "Land_wpp_Turbine_V2_off_F", "Land_wpp_Turbine_V1_off_F"
];

private _tempArr = (_centre nearObjects ["Building", 200]) select { typeOf _x in _targetTypes };

if (count _tempArr == 0) then { 
	if (_centre isEqualTo _targetPos || _targetPos isEqualTo [0,0,0]) then { _targetPos = [_centre, 25, 200, 5, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos };
	private _targetObj = createVehicle [selectRandom _targetTypes, _targetPos, [], 0, "NONE"];
	_targetObj setVectorUp [0,0,1];
	_targetPos = getPos _targetObj;
	_targetArr pushBack _targetObj;
	
	// Add to Zeus
	{ _x addCuratorEditableObjects [[_targetObj], true] } forEach allCurators;
} else {
	_targetArr pushBack (selectRandom _tempArr);
	
	for "_i" from 0 to _count do {
		if (count _tempArr < 1) exitWith {};
		
		private _bld = selectRandom _tempArr;
		_tempArr = _tempArr - [_bld];
		_targetArr pushBack _bld;
	};
};

private _endActivation = [];
	
{
	private _targetObj = _x;
	missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _forEachIndex], _x];
	_endActivation pushBack format["!alive ZMM_%1_OBJ_%2", _zoneID, _forEachIndex];
	
	private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _forEachIndex], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate and destroy the building.<br/><br/>Target Building: <font color='#FFA500'>%1</font><br/><img width='350' image='%2'/>", getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName"), getText (configFile >> "CfgVehicles" >> typeOf _x >> "editorPreview")], getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName"), format["MKR_%1_LOC", _zoneID]], _x, "CREATED", 1, false, true, format["move%1", _forEachIndex + 1]] call BIS_fnc_setTask;
	private _childTrigger = createTrigger ["EmptyDetector", position _x, false];
	_childTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_childTrigger setTriggerStatements [  format["!alive ZMM_%1_OBJ_%2", _zoneID, _forEachIndex],
		format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState;", _zoneID, _forEachIndex],
		"" ];
										
	missionNamespace setVariable [format["ZMM_%1_TR_%2", _zoneID, _forEachIndex], _childTrigger, true];
		
	[_zoneID, ((count (_x buildingPos -1)) / 2) max (4 + random 4), _x] call zmm_fnc_areaGarrison;
} forEach _targetArr;

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_objTrigger setTriggerStatements [  (_endActivation joinString " && "), 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _objTrigger, true];
[_objTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _objTrigger];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, count _targetArr, if (count _targetArr > 1) then { " Buildings" } else { " Building" }], ["Demolition"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "destroy"] call BIS_fnc_setTask;

true