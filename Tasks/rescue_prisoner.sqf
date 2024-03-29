// v1.0
// Set-up mission variables.
// TODO: Add support for ZZM_ObjectiveCount
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]], ["_bld", objNull ] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyMen = missionNamespace getVariable [format["ZMM_%1Man", _enemySide], ["O_Solider_F"]];
private _buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], []];
private _locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = selectRandom [
		"Locate and rescue <font color='#00FFFF'>%2 %3s</font> who have been captured nearby %1.",
		"Save <font color='#00FFFF'>%2 %3s</font> who were spotted by the enemy entering %1, they must be saved.",
		"There are <font color='#00FFFF'>%2 %3s</font> who where trying to flee %1 but were captured and are awaiting execution, rescue them.",
		"Find and rescue <font color='#00FFFF'>%2 %3s</font> being held hostage somewhere nearby %1.",
		"Set free <font color='#00FFFF'>%2 %3s</font> last seen around the area outside %1, find them and rescue them.",
		"A group of <font color='#00FFFF'>%2 %3s</font> are confirmed to be in the area near %1, ensure they are brought back to safety."
	];

// Find a random building position.
private _bldPos = _buildings apply { selectRandom (_x buildingPos -1) };

// Merge all locations
{ _locations pushBack position _x } forEach _buildings;

// Create HVT Team
private _hvtActivation = [];
private _hvtFailure = [];
private _hvtGroup = createGroup civilian;
private _inBuilding = true;

selectRandom [
	["Journalist", 	["C_journalist_F","C_Journalist_01_War_F"]],
	["Pilot", 		["C_man_pilot_F","C_IDAP_Pilot_01_F","I_C_Pilot_F"]],
	["Prisoner", 	["C_man_p_fugitive_F","C_man_p_fugitive_F_afro","C_man_p_fugitive_F_asia","C_man_p_fugitive_F_euro"]],
	["Paramedic", 	["C_Man_Paramedic_01_F","C_IDAP_Man_Paramedic_01_F"]],
	["Worker", 		["C_Man_ConstructionWorker_01_Black_F","C_Man_ConstructionWorker_01_Blue_F","C_Man_ConstructionWorker_01_Red_F","C_Man_ConstructionWorker_01_Vrana_F","C_Man_UtilityWorker_01_F"]],
	["Informant", 	["C_man_hunter_1_F"]],
	["Aid Worker", 	["C_IDAP_Man_AidWorker_01_F","C_IDAP_Man_AidWorker_02_F","C_IDAP_Man_AidWorker_03_F","C_IDAP_Man_AidWorker_04_F","C_IDAP_Man_AidWorker_05_F","C_IDAP_Man_AidWorker_06_F","C_IDAP_Man_AidWorker_07_F","C_IDAP_Man_AidWorker_08_F","C_IDAP_Man_AidWorker_09_F"]],
	["Soldier", 	["I_G_Survivor_F"]]
] params ["_rescueType","_rescueClass"];

for "_i" from 1 to (missionNamespace getVariable ["ZZM_ObjectiveCount", 3]) do {
	private _hvtClass = selectRandom _rescueClass;
	private _hvtPos = [];
	private _inBuilding = false;
	
	if (random 100 > 50 && {count _bldPos > 0}) then {
		_hvtPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _hvtPos);
		_inBuilding = true;
	} else {
		if (count _locations > 0) then { 
			_hvtPos = selectRandom _locations;
			_locations deleteAt (_locations find _hvtPos);
		} else { 
			_hvtPos = [_centre getPos [50 + random _radius, random 360], 1, _radius, 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
		};
		
		_hvtPos = _hvtPos findEmptyPosition [1, 50, _hvtClass];
	};
		
	private _hvtObj = _hvtGroup createUnit [_hvtClass, [0,0,0], [], 150, "NONE"];
	[_hvtObj] joinSilent _hvtGroup;
	_hvtObj setCaptive true;
	_hvtObj setPosATL _hvtPos;
	_hvtObj setDir random 360;
	_hvtObj disableAI "ALL";
	
	removeBackpack _hvtObj;
	removeAllWeapons _hvtObj;
	
	_hvtObj setVariable ["var_zoneID", _zoneID, true];
	_hvtObj setVariable ["var_itemID", _i, true];
	
	_hvtObj addEventHandler ["killed",{
		private _killer = if (isNull (_this#2)) then { (_this#0) getVariable ["ace_medical_lastDamageSource", (_this#1)] } else { (_this#2) };
		if (isPlayer _killer) then { format["%1 (%2) killed %3", name _killer, groupId group _killer, name (_this#0)] remoteExec ["systemChat",0] };
	}];

	private _mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _hvtObj getPos [random 50, random 360]];
			_mrkr setMarkerShape "ELLIPSE";
			_mrkr setMarkerBrush "SolidBorder";
			_mrkr setMarkerSize [50,50];
			_mrkr setMarkerAlpha 0.4;
			_mrkr setMarkerColor "ColorCivilian";

	if (_rescueType == "Soldier") then {
		_hvtObj spawn {
			sleep 5;
			_this forceAddUniform (uniform selectRandom allPlayers);
			_this addVest (vest selectRandom allPlayers);
			_this addHeadgear (headgear selectRandom allPlayers);
			removeFromRemainsCollector [_this];
		};
	};				
	
	missionNamespace setVariable [format["ZMM_%1_HVT_%2", _zoneID, _i], _hvtObj];
	
	waitUntil { !(name _hvtObj isEqualTo "") }; // Allow name to assign.
	
	// Child task
	private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Rescue %2, a captured %1 from enemy forces, ensuring they come to no harm.<br/><br/>Target: <font color='#00FFFF'>%2</font><br/><br/><img width='350' image='%3'/>", _rescueType, name _hvtObj, getText (configFile >> "CfgVehicles" >> _hvtClass >> "editorPreview")], format["Rescue %1", name _hvtObj], format["MKR_%1_OBJ", _zoneID]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["move%1", _i]] call BIS_fnc_setTask;
	_childTrigger = createTrigger ["EmptyDetector", _centre, false];
	_childTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_childTrigger setTriggerStatements [  format["(alive ZMM_%1_HVT_%2 && ZMM_%1_HVT_%2 distance2D %3 > 400)", _zoneID, _i, _centre],
		format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState;", _zoneID, _i],
		"" ];
	
	// Failure trigger when HVT is dead.
	private _hvtTrigger = createTrigger ["EmptyDetector", _centre, false];
	_hvtTrigger setTriggerStatements [ 	format["!alive ZMM_%1_HVT_%2", _zoneID, _i], 
		format["['ZMM_%1_SUB_%2', 'Failed', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2';", _zoneID, _i],
		"" ];
										
	// Build success trigger when HVT is alive and far from objective.
	_hvtActivation pushBack format["((alive ZMM_%1_HVT_%2 && ZMM_%1_HVT_%2 distance2D %3 > 400) || !alive ZMM_%1_HVT_%2)", _zoneID, _i, _centre];
	_hvtFailure pushBack format["(!alive ZMM_%1_HVT_%2)", _zoneID, _i];
	
	if (!isNil "ace_captives_setHandcuffed") then {
		[_hvtObj, true] call ace_captives_setHandcuffed;
	} else {
		// Select random pose for HVT.
		[_hvtObj, selectRandom ["AmovPercMstpSnonWnonDnon_Ease", "Acts_JetsMarshallingStop_loop", "Acts_JetsShooterIdle"]] remoteExec ["switchMove"]; 
		
		_hvtObj setVariable ["FAR_var_isStable", true, true];
		
		// Add HVT Action for player.
		[_hvtObj, 
			format["<t color='#00FF80'>Untie %1</t>", name _hvtObj], 
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_unbind_ca.paa",  
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_unbind_ca.paa",  
			"_this distance2d _target < 3",   
			"_caller distance2d _target < 3",   
			{}, 
			{},
			{ 
				[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
				private _zoneID = _target getVariable ["var_zoneID", 0];
				private _itemID = _target getVariable ["var_itemID", 0];
				deleteMarker format["MKR_%1_OBJ_%2", _zoneID, _itemID];
				[_target] joinSilent group _caller; 
				sleep 2;
				[_target, "ALL"] remoteExec ["enableAI", owner _target]; 
				[_target, ""] remoteExec ["playMoveNow", owner _target]; 
				[_target, false] remoteExec ["setCaptive", owner _target];
			}, 
			{}, 
			[], 
			3, 
			10 
		] remoteExec ["BIS_fnc_holdActionAdd", 0, _hvtObj];
	};
	
	// Create enemy Team
	private _enemyTeam = [];
	for "_j" from 0 to (3 * (missionNamespace getVariable ["ZZM_Diff", 1])) do { _enemyTeam set [_j, selectRandom _enemyMen] };
	
	private _milGroup = [_hvtPos getPos [random 2, random 360], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
	
	private _bldArr = if (_inBuilding) then { (nearestBuilding _hvtObj) buildingPos -1 } else { [] };
	_bldArr deleteAt (_bldArr find _hvtPos);
	
	{
		if (count _bldArr > 0) then {
			private _tempPos = selectRandom _bldArr;
			_bldArr deleteAt (_bldArr find _tempPos);
			_x setPosATL _tempPos;
			_x disableAI "PATH";
		} else {
			_x setVehiclePosition [_hvtObj getPos [random 10, random 360], [], 0, "NONE"];
			_x setUnitPos "MIDDLE";
		};
	} forEach units _milGroup;

	{ _x addCuratorEditableObjects [[_hvtObj] + units _milGroup, true] } forEach allCurators;
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_objTrigger setTriggerStatements [ 	(_hvtActivation joinString " && "), 
	format["['ZMM_%1_TSK', if (%3) then { 'Failed' } else { 'Succeeded' }, true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide, (_hvtFailure joinString " || ")],
	"" ];
	
missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _objTrigger, true];
[_objTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _objTrigger];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_missionDesc, _locName, count units _hvtGroup, _rescueType], ["Rescue"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "help"] call BIS_fnc_setTask;

true