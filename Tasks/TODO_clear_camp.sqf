// Clear an enemy training camp.
// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
_buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];
_menArray = missionNamespace getVariable format["ZMM_%1Man", _enemySide];
_locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
_locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

_civMax = switch (_locType) do {
	case "Airport": { 8 };
	case "NameCityCapital": { 6 };
	case "NameCity": { 6 };
	case "NameVillage": { 4 };
	case "NameLocal": { 4 };
	default { 4 };
};

_missionType = [ "Militia", "Insurgent", "Rebel", "Rogue", "Bandit" ];
_missionRank = [ "General", "Supervisor", "Lieutenant", "Soldier", "Leader", "Assassin" ];

_missionDesc = [
		"A local <font color='#00FFFF'>%3 %4</font> and their team are attempting to negotiate an arms deal with forces in %1. Eliminate all %2 members of the group found somewhere inside the marked locations.",
		"Eliminate a <font color='#00FFFF'>%3 %4</font> and their guards (%2 infantry) who have entered %1 to trade intel with enemy forces there, clear all guards at the marked locations.",
		"A group of %2 infantry lead by <font color='#00FFFF'>%3 %4</font> have entered %1 in an attempt to join forces with the enemy. Eliminate all members of the group found at the marked locations.",
		"Local residents have reported a team of %2 men entering %1. A <font color='#00FFFF'>%3 %4</font> is believed to be in charge of the group, ensure the entire team is eliminated by checking the marked locations.",
		"Intel shows that a <font color='#00FFFF'>%3 %4</font> has recently arrived in %1. Find all eliminate all %2 members of the group found somewhere inside the marked locations.",
		"Overnight, %2 men have arrived in %1 and began killing local villagers. Intel indicates they are being lead by a <font color='#00FFFF'>%3 %4</font>. Hunt down all %2 members of the group inside the marked locations."
	];
	
_locArr = [];
	
// Add any missed buildings.
if (count _buildings > 0) then {	
	{
		{ _locArr pushBack _x } forEach (_x buildingPos -1);
	} forEach _buildings;
} else {
	_locArr = _locations;
};

// Create locations if none exist
if (_locArr isEqualTo []) then {
	for "_i" from 0 to (_civMax * 2) do {
		_locArr pushBack (_centre getPos [random 50, random 360]);
	};
};


private _endActivation = [];
private _civMarkers = [];
private _civCount = 0;
private _civTypes = ("configName _x isKindOf 'Man' && getText (_x >> ""editorSubcategory"") isEqualTo ""EdSubcat_Personnel_Bandits""" configClasses (configFile >> "CfgVehicles")) apply { configName _x };
private _foundAreas = (selectBestPlaces [_centre, 250,"(6*hills + 2*forest + 4*houses + 1.5*meadow + 2*trees) - (100*sea)", 100, 10]) apply { _x # 0 };
private _enemyGrp = createGroup [_enemySide, true];

for "_i" from 1 to _civMax do {
	if (count _locArr < 1) exitWith {};
	
	private _tempPos = selectRandom _locArr;
	_locArr deleteAt (_locArr find _tempPos);
	
	private _civUnit = _enemyGrp createUnit [selectRandom _civTypes, [0,0,0], [], 150, "NONE"];
	[_civUnit] joinSilent _enemyGrp;
	_civUnit disableAI "PATH";
	_civUnit setPos _tempPos;
	_civUnit setCombatMode "RED";
	_civUnit setBehaviour "AWARE";
	
	if !(isNil "zmm_fnc_unitDirPos") then {
		[_civUnit] call zmm_fnc_unitDirPos;
	} else {
		_civUnit setDir random 360;
	};
		
	if (alive _civUnit) then {
		// Create marker if not in one already.
		//if ((_civMarkers findIf { _civUnit inArea _x }) < 0) then {		
			_mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _civUnit getPos [random 25, random 360]];
			_mrkr setMarkerShape "ELLIPSE";
			_mrkr setMarkerBrush "SolidBorder";
			_mrkr setMarkerSize [25,25];
			_mrkr setMarkerAlpha 0.4;
			_mrkr setMarkerColor format["Color%1",_enemySide];
			_civMarkers pushBack format["MKR_%1_OBJ_%2", _zoneID, _i];
		//};
		
		missionNamespace setVariable [format["ZMM_%1_HVT_%2", _zoneID, _i], _civUnit];	
		
		_endActivation pushBack format["!alive ZMM_%1_HVT_%2", _zoneID, _i];

		_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], TRUE, [format["Find and eliminate <font color='#FFA500'>%1</font> somewhere near %2.", name _civUnit, _locName], format["%1", name _civUnit], format["MKR_%1_LOC", _zoneID]], objNull, "CREATED", 1, FALSE, TRUE, "kill"] call BIS_fnc_setTask;
		_childTrigger = createTrigger ["EmptyDetector", _centre, false];
		_childTrigger setTriggerStatements [  format["!alive ZMM_%1_HVT_%2", _zoneID, _i],
										format["['ZMM_%1_SUB_%2', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; 'MKR_%1_OBJ_%2' setMarkerAlpha 0;", _zoneID, _i],
										"" ];
										
		_civCount = _civCount + 1;
	};
};

// Add Targets to Zeus
{ _x addCuratorEditableObjects [units _enemyGrp, true] } forEach allCurators;

// Spawn Bandit Hunt Groups
for "_i" from 1 to (_civMax) do {	
    _huntGroup = [selectRandom _foundAreas, _enemySide, (configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "BanditFireTeam")] call BIS_fnc_spawnGroup;
	_huntGroup deleteGroupWhenEmpty true;
	
	// Patrol at start.
	[_huntGroup, getPos leader _huntGroup, 50] call BIS_fnc_taskPatrol;

	missionNamespace setVariable [format["ZMM_%1_HUNT_%2", _zoneID, _i], _huntGroup];	
	
	_huntTrigger = createTrigger ["EmptyDetector", [0,0,0], FALSE];
	_huntTrigger setTriggerTimeout [10, 10, 10, true];
	_huntTrigger setTriggerArea [150, 150, 0, false, 25];
	_huntTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_huntTrigger setTriggerStatements [  "this", 
									format["[ZMM_%1_HUNT_%2, group (selectRandom thisList)] spawn BIS_fnc_stalk;", _zoneID, _i],
									"" ];
									
	_huntTrigger attachTo [leader _huntGroup, [0,0,0]];
	
	// Add Hunters to Zeus
	{ _x addCuratorEditableObjects [units _huntGroup, true] } forEach allCurators;
	
	_huntGroup spawn { sleep 10; _this enableDynamicSimulation TRUE };
};

// Spawn Suicide Bombers
for "_i" from 1 to (_civMax / 2) do {
	_bombGroup = createGroup [_enemySide, true];
	private _bomber = _bombGroup createUnit [selectRandom _civTypes, [0,0,0], [], 150, "NONE"];
	[_bomber] joinSilent _bombGroup;
	_bomber setPos ((selectRandom _foundAreas) findEmptyPosition [1, 25]);
	_bomber setDir random 360;
	removeAllWeapons _bomber;
	removeBackpack _bomber;
	removeVest _bomber;
	
	_ied1 = "DemoCharge_Remote_Ammo" createVehicle [0,0,0];
	_ied2 = "DemoCharge_Remote_Ammo" createVehicle [0,0,0];
	_ied3 = "DemoCharge_Remote_Ammo" createVehicle [0,0,0];

	_ied1 attachTo [_bomber, [-0.1,0.1,0.15],"Pelvis"];
	_ied1 setVectorDirAndUp [[0.5,0.5,0],[-0.5,0.5,0]];

	_ied2 attachTo [_bomber, [0,0.15,0.15],"Pelvis"];
	_ied2 setVectorDirAndUp [[1,0,0],[0,1,0]];

	_ied3 attachTo [_bomber, [0.1,0.1,0.15],"Pelvis"];
	_ied3 setVectorDirAndUp [[0.5,-0.5,0],[0.5,0.5,0]];
	
	_bomber setBehaviour "CARELESS";
	
	_bomber addEventHandler ["killed",{ { deleteVehicle _x } forEach attachedObjects (_this#0) }];

	missionNamespace setVariable [format["ZMM_%1_IED_%2", _zoneID, _i], _bomber];	
	
	_bombTrigger = createTrigger ["EmptyDetector", [0,0,0], FALSE];
	_bombTrigger setTriggerTimeout [10, 10, 10, true];
	_bombTrigger setTriggerArea [150, 150, 0, false, 25];
	_bombTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_bombTrigger setTriggerStatements [  "this", 
									format["[group ZMM_%1_IED_%2, group (selectRandom thisList)] spawn BIS_fnc_stalk;
									[ZMM_%1_IED_%2] spawn {
										params ['_unit'];
										waitUntil { sleep 1; playSound3D ['A3\sounds_f\sfx\beep_target.wss', _unit, false, getPosASL _unit, 1, 0.5, 75]; (!alive _unit || allPlayers findIf { alive _x && _unit distance _x < 5 } >= 0) };
										_exp = 'HelicopterExploSmall' createVehicle (getPos _unit); _exp attachTo [_unit,[-0.02,-0.07,0.042],'rightHand'];
									};", _zoneID, _i],
									"" ];
									
	_bombTrigger attachTo [_bomber, [0,0,0]];
	
	// Add Bombers to Zeus
	{ _x addCuratorEditableObjects [[_bomber],true] } forEach allCurators;
	
	_bombGroup spawn { sleep 5; _this enableDynamicSimulation TRUE };
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerStatements [  (_endActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, count units _enemyGrp, selectRandom _missionType, selectRandom _missionRank], ["Uprising"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "meet"] call BIS_fnc_setTask;

TRUE