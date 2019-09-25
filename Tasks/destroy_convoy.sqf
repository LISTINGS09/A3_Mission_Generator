// Spawn a convoy of three vehicles and make them patrol around a location.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];

_manList = missionNamespace getVariable [format["ZMM_%1Man", _enemySide],["O_Solider_F"]];
_carList = missionNamespace getVariable [format["ZMM_%1Veh_Convoy", _enemySide],[]];

_missionDesc = [
		"A %3 %4 has just finished a meeting in %1 with an enemy Commander there. Destroy %4s convoy of <font color='#00FFFF'>%2 Vehicles</font> and ensure they don't escape.",
		"Destroy a group of <font color='#00FFFF'>%2 Vehicles</font> understood to be owned by a %3 %4 living somewhere nearby %1.",
		"A %3 %4 is passing through the enemy-controlled area of %1. Locate the %4s <font color='#00FFFF'>%2 Vehicles</font> and destroy them.",
		"Neutralise a %3 %4 by destroying their vehicles and escort; <font color='#00FFFF'>%2 Vehicles</font> in total. The %4 will be travelling somewhere around %1.",
		"The area around %1 has long be controlled by a %3 %4. They will be driving around the enemy-controlled area of %1, locate the %4s <font color='#00FFFF'>%2 Vehicles</font> and eliminate them all.",
		"The %3 %4 of %1 has just completed a deal with rebel forces in the area. Find the %4s <font color='#00FFFF'>%2 Vehicles</font> and ensure both the %4 and all vehicles are destroyed."
	];	

_conVerb = selectRandom ['feared', 'respected', 'notorious', 'senior', 'high-ranking', 'decorated', 'wealthy', 'rogue', 'dangerous', 'long-wanted', 'reclusive'];
_conType = selectRandom ['Diplomat', 'Warlord', 'Terrorist', 'Official', 'Advisor', 'Leader', 'Kingpin', 'Drug Baron', 'Arms Dealer', 'Convict'];

// No vehicles defined, so use basic ones - 2nd Vehicle will always carry the HVT.
if (count _carList == 0) then {
	_carList = switch _enemySide do {
		case west: {
			[ 
				["B_LSV_01_armed_F", "[_grpVeh, ['Black',1] ] call BIS_fnc_initVehicle;"]
				,["B_LSV_01_unarmed_F", "[_grpVeh, ['Black',1] ] call BIS_fnc_initVehicle;"]
				,["B_LSV_01_armed_F", "[_grpVeh, ['Black',1] ] call BIS_fnc_initVehicle;"]
			]
		};
		case east: {
			[
				["O_LSV_02_armed_F", "[_grpVeh, ['Black',1] ] call BIS_fnc_initVehicle;"]
				,["O_LSV_02_unarmed_F", "[_grpVeh, ['Black',1] ] call BIS_fnc_initVehicle;"]
				,["O_LSV_02_armed_F", "[_grpVeh, ['Black',1] ] call BIS_fnc_initVehicle;"]
			]
		};	
		case independent: {
			[ 
				["I_G_Offroad_01_armed_F",""]
				,["I_G_Offroad_01_F",""]
				,["I_G_Offroad_01_armed_F",""]
			]
		};
	};
};

// Create Group
private _enemyGrp = createGroup [_enemySide, true];
private _vehCount = 0;
private _endActivation = [];

{
	_x params [["_vehType", ""], ["_customInit", ""]];
	
	if !(isClass (configFile >> "cfgVehicles" >> _vehType)) exitWith {
	
	};
	
	private _foundRoad = selectRandom (_targetPos nearRoads 150);
	private _tempPos = [0,0,0];
	
	// No valid road
	if !(isNil "_foundRoad") then {
		_tempPos = (getPos _foundRoad) findEmptyPosition [1, 25, _vehType];
	} else {
		_tempPos = (_centre getPos [10 + random 40, random 360]) findEmptyPosition [1, 25, _vehType];
	};
	
	_grpVeh = _vehType createVehicle _tempPos;
	
	// Set direction to nearby road
	if !(isNil "_foundRoad") then { _grpVeh setDir ([_tempRoad, (roadsConnectedTo _tempRoad) # 0] call BIS_fnc_DirTo) };

	// Run custom script if provided
	if (_customInit != "") then { _nul = call compile _customInit };
		
	missionNamespace setVariable [format["ZMM_%1_VEH_%2", _zoneID, _forEachIndex], _grpVeh];	
	
	_cargoS = count fullCrew [_grpVeh, "cargo", true];
	_cargoF = count fullCrew [_grpVeh, "turret", true];	
	_crew = (count fullCrew [_grpVeh, "", true]) - _cargoS - _cargoF;

	// Create crew.
	for "_i" from 1 to _crew do {
		_tempMan = _enemyGrp createUnit [selectRandom _manList, [0,0,0], [], 150, "NONE"];
		[_tempMan] joinSilent _enemyGrp; 
		_tempMan moveInAny _grpVeh;
	};
	
	// TODO: FFV Seats not included? Open FIA trucks are empty!
	
	// If more than 1 cargo seat free, fill with a support group.
	if ((_cargoS + _cargoF) > 1) then {
		_cargoGrp = createGroup [_enemySide, true];
		for "_i" from 1 to (_cargoS + _cargoF) do {
			_tempMan = _cargoGrp createUnit [selectRandom _manList, [0,0,0], [], 150, "NONE"];
			[_tempMan] joinSilent _enemyGrp; 
			_tempMan moveInAny _grpVeh;
		};
		
		// Add a beret to the transport group.
		if (_forEachIndex == 1) then {
			_hvt = selectRandom (units _cargoGrp);
			if (!isNil "_hvt") then { _hvt addHeadgear "H_Beret_blk" };
		};
		
		// Add to Zeus
		{ _x addCuratorEditableObjects [units _cargoGrp, true] } forEach allCurators;
	};
		
	if (alive _grpVeh) then {
		// Add to Zeus
		{ _x addCuratorEditableObjects [[_grpVeh], true] } forEach allCurators;
		
		_grpVeh setConvoySeparation 20;
	
		_endActivation pushBack format["!alive ZMM_%1_VEH_%2", _zoneID, _forEachIndex];
	
		_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _forEachIndex], format['ZMM_%1_TSK', _zoneID]], TRUE, [format["Locate and destroy the convoy vehicle.<br/><br/>Target Vehicle: <font color='#FFA500'>%1</font><br/><img width='350' image='%2'/>", getText (configFile >> "CfgVehicles" >> _vehType >> "displayName"), getText (configFile >> "CfgVehicles" >> _vehType >> "editorPreview")], format["Vehicle #%1", _forEachIndex + 1], format["MKR_%1_LOC", _zoneID]], _grpVeh, "CREATED", 1, FALSE, TRUE, format["move%1", _forEachIndex + 1]] call BIS_fnc_setTask;
		_childTrigger = createTrigger ["EmptyDetector", _centre, false];
		_childTrigger setTriggerStatements [  format["!alive ZMM_%1_VEH_%2", _zoneID, _forEachIndex],
										format["['ZMM_%1_SUB_%2', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState;", _zoneID, _forEachIndex],
										"" ];
										
		_vehCount = _vehCount + 1;
	};
} forEach _carList;

// [_enemyGrp, getPos selectRandom _foundRoads, 200] call bis_fnc_taskPatrol;
[leader _enemyGrp, format["MKR_%1_MAX", _zoneID], "SHOWMARKER"] spawn zmm_fnc_aiUPS;

// Add to Zeus
{ _x addCuratorEditableObjects [units _enemyGrp, true] } forEach allCurators;

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerStatements [ 	(_endActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];
									
// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, _vehCount, _conVerb, _conType], ["Convoy"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "AUTOASSIGNED", 1, FALSE, TRUE, "car"] call BIS_fnc_setTask;

TRUE
