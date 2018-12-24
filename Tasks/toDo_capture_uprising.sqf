// Set-up mission variables.
params [ ["_zoneID", 0] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
_buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];
_menArray = missionNamespace getVariable format["ZMM_%1Man", _enemySide];
_locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
_locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

_civMax = switch (_locType) do {
	case "Airport": { 12 };
	case "NameCityCapital": { 12 };
	case "NameCity": { 8 };
	case "NameVillage": { 6 };
	case "NameLocal": { 6 };
	default { 4 };
};

_missionType = [ "Militia", "Insurgent", "Rebel", "Rogue", "Bandit" ];
_missionRank = [ "General", "Supervisor", "Leader", "Assassin" ];

_missionDesc = [
		"%1 %2 %3"
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

// Exit if we have no locations.
if (count _locArr == 0) exitWith { false };

_endActivation = [];
_civMarkers = [];
_civCount = 0;
_civTypes = ("configName _x isKindOf 'Man' && getText (_x >> ""editorSubcategory"") isEqualTo ""EdSubcat_Personnel_Bandits""" configClasses (configFile >> "CfgVehicles")) apply { configName _x };

_foundAreas = (selectBestPlaces [_centre, 250,"(6*hills + 2*forest + 4*houses + 1.5*meadow + 2*trees) - ((10*sea) + (10*deadbody))", 100, 10]) apply { _x # 0 };

_enemyGrp = createGroup [_enemySide, true];

for "_i" from 1 to _civMax do {
	if (count _locArr < 1) exitWith {};
	
	_tempPos = selectRandom _locArr;
	_locArr deleteAt (_locArr find _tempPos);
	
	private _civUnit = _enemyGrp createUnit [selectRandom _civTypes, [0,0,0], [], 0, "NONE"];
	[_civUnit] joinSilent _enemyGrp;
	_civUnit disableAI "PATH";
	_civUnit setPos _tempPos;
	_civUnit setCombatMode "RED";
	_civUnit setBehaviour "AWARE";
	
	// Force unit to hold - doStop is a 'soft' hold, disableAI stops movement permanently.
	if (random 1 > 0.7) then { doStop _civUnit } else { _civUnit disableAI "PATH" };
	
	if !(isNil "zmm_fnc_unitDirPos") then {
		[_civUnit] call zmm_fnc_unitDirPos;
	} else {
		_civUnit setDir random 360;
	};
		
	if (alive _civUnit) then {
		// Create marker if not in one already.
		if ((_civMarkers findIf { _civUnit inArea _x }) < 0) then {		
			_mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _civUnit getPos [random 25, random 360]];
			_mrkr setMarkerShape "ELLIPSE";
			_mrkr setMarkerBrush "SolidBorder";
			_mrkr setMarkerSize [25,25];
			_mrkr setMarkerAlpha 0.4;
			_mrkr setMarkerColor format["Color%1",_enemySide];
			_civMarkers pushBack format["MKR_%1_OBJ_%2", _zoneID, _i];
		};
	
		sleep 0.1; // Allow time for name to generate.
		missionNamespace setVariable [format["ZMM_%1_HVT_%2", _zoneID, _i], _civUnit];	
		
		_endActivation pushBack format["!alive ZMM_%1_HVT_%2", _zoneID, _i];

		_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], TRUE, [format["Find and eliminate <font color='#FFA500'>%1</font> somewhere near %2.", name _civUnit, _locName], format["Neutralise %1", name _civUnit], format["MKR_%1_LOC", _zoneID]], objNull, "CREATED", 1, FALSE, TRUE, "kill"] call BIS_fnc_setTask;
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
for "_i" from 1 to (_civMax / 2) do {	
    _huntGroup = [selectRandom _foundAreas, _enemySide, (configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "BanditFireTeam")] call BIS_fnc_spawnGroup;
	_huntGroup deleteGroupWhenEmpty true;
	
	// Patrol at start.
	[_huntGroup, getPos leader _huntGroup, 25] call BIS_fnc_taskPatrol;

	missionNamespace setVariable [format["ZMM_%1_HUNT_%2", _zoneID, _i], _huntGroup];	
	
	_huntTrigger = createTrigger ["EmptyDetector", [0,0,0], FALSE];
	_huntTrigger setTriggerTimeout [10, 10, 10, true];
	_huntTrigger setTriggerArea [100, 100, 0, false, 25];
	_huntTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_huntTrigger setTriggerStatements [  "this", 
									format["[ZMM_%1_HUNT_%2, group (selectRandom (allPlayers select { alive _x && _x distance ZMM_%1_HUNT_%2 < 150 }))] call BIS_fnc_stalk;", _zoneID, _i],
									"" ];
									
	_huntTrigger attachTo [leader _huntGroup, [0,0,0]];
	
	// Add Hunters to Zeus
	{ _x addCuratorEditableObjects [units _huntGroup, true] } forEach allCurators;
	
	_huntGroup spawn { sleep 5; _this enableDynamicSimulation TRUE };
};

// Spawn Suicide Bombers
for "_i" from 1 to (_civMax / 2) do {
	_agent = createAgent [selectRandom _civTypes, [0,0,0], [], 0, "NONE"];
	_agent setPos ((selectRandom _foundAreas) findEmptyPosition [1, 25]);
	_agent setDir random 360;
	_agent setCaptive true;
	removeAllWeapons _agent;
	removeBackpack _agent;
	removeVest _agent;
	
	_ied1 = "DemoCharge_Remote_Ammo" createVehicle [0,0,0];
	_ied2 = "DemoCharge_Remote_Ammo" createVehicle [0,0,0];
	_ied3 = "DemoCharge_Remote_Ammo" createVehicle [0,0,0];

	sleep 0.01;

	_ied1 attachTo [_agent, [-0.1,0.1,0.15],"Pelvis"];
	_ied1 setVectorDirAndUp [[0.5,0.5,0],[-0.5,0.5,0]];

	_ied2 attachTo [_agent, [0,0.15,0.15],"Pelvis"];
	_ied2 setVectorDirAndUp [[1,0,0],[0,1,0]];

	_ied3 attachTo [_agent, [0.1,0.1,0.15],"Pelvis"];
	_ied3 setVectorDirAndUp [[0.5,-0.5,0],[0.5,0.5,0]];
	
	if (random 1 > 0.3) then { _agent setUnitPos "UP" };

	_agentVar = format["ZMM_%1_IED_%2", _zoneID, _i];
	
	missionNamespace setVariable [_agentVar, _agent];	
	
	_agentTrigger = format["_nul = [] spawn {
		_tGroup = allPlayers select { alive _x && _x distance %1 < 150 };
	
		while { alive %1 && ({alive _x} count _tGroup > 0)} do {
			if (simulationEnabled %1) then {
				_tUnit = (_tGroup select { alive _x }) # 0;
				%1 setDestination [getPos _tUnit, 'LEADER PLANNED', true];
			};
			sleep 2;
			
			if (allPlayers findIf { alive _x && %1 distance _x < 8 } >= 0) exitWith {};
		};
		
		{ deleteVehicle _x } forEach (attachedObjects %1);

		if(random 1 > 0.2) then {
			_object = 'HelicopterExploSmall' createVehicle (getPos %1);
			_object attachTo [%1,[-0.02,-0.07,0.042],'rightHand'];
		};
	};", _agentVar];
	
	_iedTrigger = createTrigger ["EmptyDetector", [0,0,0], FALSE];
	_iedTrigger setTriggerArea [50, 50, 0, false, 25];
	_iedTrigger setTriggerTimeout [10, 10, 10, true];
	_iedTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_iedTrigger setTriggerStatements [  "this", 
									_agentTrigger,
									"" ];
									
	_iedTrigger attachTo [_agent, [0,0,0]];
	
	// Add Bombers to Zeus
	{ _x addCuratorEditableObjects [[_agent], true] } forEach allCurators;
	
	_agent spawn { sleep 5; _this enableDynamicSimulation TRUE };
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerStatements [  (_endActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName], ["Uprising"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "AUTOASSIGNED", 1, FALSE, TRUE, "meet"] call BIS_fnc_setTask;

TRUE