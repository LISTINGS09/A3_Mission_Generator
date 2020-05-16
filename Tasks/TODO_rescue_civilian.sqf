// Rescue civilians from enemy forces. 
// Set-up mission variables.
params [ ["_zoneID", 0], ["_bld", objNull ], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
private _enemyTeam = selectRandom (missionNamespace getVariable[format["ZMM_%1Grp_Sentry",_enemySide],[""]]); // CfgGroups entry.
private _buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], []];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = [
		"Locate and rescue <font color='#00FFFF'>%2 %3s</font> who have been captured nearby %1.",
		"Save <font color='#00FFFF'>%2 %3s</font> who were spotted by the enemy entering %1, they must be saved.",
		"There are <font color='#00FFFF'>%2 %3s</font> who where trying to flee %1 but were captured and are awaiting execution, rescue them.",
		"Find and rescue <font color='#00FFFF'>%2 %3s</font> being held hostage somewhere nearby %1.",
		"Set free <font color='#00FFFF'>%2 %3s</font> last seen around the area outside %1, find them and rescue them.",
		"A group of <font color='#00FFFF'>%2 %3s</font> are confirmed to be in the area near %1, ensure they are brought back to safety."
	];

private _hvtMax = round (2 + random 2);

// Find a random building position.
private _positions = [];
{ _positions pushBack (selectRandom (_x buildingPos -1)) } forEach _buildings;

// Create locations if none exist
if (count _positions < _hvtMax) then {
	for "_i" from 0 to _hvtMax do {
		_positions pushBack (_centre getPos [25 + random 50, random 360]);
	};
};

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

for "_i" from 0 to _hvtMax do {
	if (_positions isEqualTo []) exitWith {};
	
	private _hvtClass = selectRandom _rescueClass;
	private _hvtPos = selectRandom _positions;
	_positions deleteAt (_positions find _hvtPos);
	
	if (_hvtPos#2 == 0) then { 
		_hvtPos = _hvtPos findEmptyPosition [1, 25, "B_Soldier_F"];
		_inBuilding = false;
	};
	
	private _hvtObj = _hvtGroup createUnit [_hvtClass, [0,0,0], [], 150, "NONE"];
	_hvtObj setCaptive true;
	_hvtObj setPosATL _hvtPos;
	_hvtObj setDir random 360;
	_hvtObj disableAI "ALL";
	
	removeBackpack _hvtObj;
	removeAllWeapons _hvtObj;
	
	_hvtObj setVariable ["var_zoneID", _zoneID, true];
	_hvtObj setVariable ["var_itemID", _i, true];
	
	removeFromRemainsCollector [_hvtObj];

	private _mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _hvtObj getPos [random 50, random 360]];
			_mrkr setMarkerShape "ELLIPSE";
			_mrkr setMarkerBrush "SolidBorder";
			_mrkr setMarkerSize [50,50];
			_mrkr setMarkerAlpha 0.4;
			_mrkr setMarkerColor "ColorCivilian";

	if (_rescueType == "Soldier") then {
		_hvtObj forceAddUniform (uniform selectRandom (allPlayers select {alive _x}));
		_hvtObj addVest (vest selectRandom (allPlayers select {alive _x}));
		_hvtObj addHeadgear (headgear selectRandom (allPlayers select {alive _x}));
	};				
	
	missionNamespace setVariable [format["ZMM_%1_HVT_%2", _zoneID, _i], _hvtObj];
	
	waitUntil { !(name _hvtObj isEqualTo "") }; // Allow name to assign.
	
	// Child task
	private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], TRUE, [format["Rescue %2, a captured %1 from enemy forces, ensuring they come to no harm.<br/><br/>Target: <font color='#00FFFF'>%2</font><br/><br/><img width='350' image='%3'/>", _rescueType, name _hvtObj, getText (configFile >> "CfgVehicles" >> _hvtClass >> "editorPreview")], format["Rescue %1", name _hvtObj], format["MKR_%1_OBJ", _zoneID]], objNull, "CREATED", 1, FALSE, TRUE, format["move%1", _i + 1]] call BIS_fnc_setTask;
	_childTrigger = createTrigger ["EmptyDetector", _centre, false];
	_childTrigger setTriggerStatements [  format["(alive ZMM_%1_HVT_%2 && ZMM_%1_HVT_%2 distance2D %3 > 400)", _zoneID, _i, _centre],
									format["['ZMM_%1_SUB_%2', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState;", _zoneID, _i],
									"" ];
	
	// Failure trigger when HVT is dead.
	private _hvtTrigger = createTrigger ["EmptyDetector", _centre, false];
	_hvtTrigger setTriggerStatements [ 	format["!alive ZMM_%1_HVT_%2", _zoneID, _i], 
									format["['ZMM_%1_TSK', 'Failed', TRUE] spawn BIS_fnc_taskSetState; ['ZMM_%1_SUB_%2', 'Failed', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'ColorGrey' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _i],
									"" ];
									
	// Build success trigger when HVT is alive and far from objective.
	_hvtActivation pushBack format["((alive ZMM_%1_HVT_%2 && ZMM_%1_HVT_%2 distance2D %3 > 400) || !(alive ZMM_%1_HVT_%2))", _zoneID, _i, _centre];
	
	if (!isNil "ace_captives_setHandcuffed") then {
		[_hvtObj, TRUE] call ace_captives_setHandcuffed;
	} else {
		// Select random pose for HVT.
		[_hvtObj, selectRandom ["AmovPercMstpSnonWnonDnon_Ease", "Acts_JetsMarshallingStop_loop", "Acts_JetsShooterIdle"]] remoteExec ["switchMove"]; 
		
		// Add HVT Action for player.
		[_hvtObj, 
			format["<t color='#00FF80'>Untie %1</t>", name _hvtObj], 
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_unbind_ca.paa",  
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_unbind_ca.paa",  
			"_this distance _target < 3",   
			"_caller distance _target < 3",   
			{}, 
			{},
			{ 
				[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
				private _zoneID = _target getVariable ["var_zoneID", 0];
				private _itemID = _target getVariable ["var_itemID", 0];
				deleteMarker format["MKR_%1_OBJ_%2", _zoneID, _itemID];
				[_target, "ALL"] remoteExec ["enableAI", _target]; 
				[_target, ""] remoteExec ["playMoveNow", _target]; 
				sleep 1;
				[_target] joinSilent group _caller; 
				_hvtObj setCaptive false;
			}, 
			{}, 
			[], 
			3, 
			10 
		] remoteExec ["BIS_fnc_holdActionAdd", 0, _hvtObj];
	};
	
	// Create enemy guards if valid group
	if !(_enemyTeam isEqualTo "") then {
		// Create enemy Team
		private _milGroup = [[0,0,0], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
		
		{ _x setUnitPosWeak "MIDDLE" } forEach units _milGroup;
		
		private _bldArr = if (_inBuilding) then { (nearestBuilding _hvtObj) buildingPos -1 } else { [] };
		_bldArr deleteAt (_bldArr find _hvtPos);
		
		{
			if (count _bldArr > 0) then {
				private _tempPos = selectRandom _bldArr;
				_bldArr deleteAt (_bldArr find _tempPos);
				_x setPosATL _tempPos;
			} else {
				_x setPos (_hvtObj getPos [random 10, random 360]);
			};
		} forEach units _milGroup;

		{ _x addCuratorEditableObjects [[_hvtObj] + units _milGroup, TRUE] } forEach allCurators;
	};
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerStatements [ 	(_hvtActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'ColorGrey' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];
// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, count units _hvtGroup, _rescueType], ["Rescue"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "help"] call BIS_fnc_setTask;

TRUE