// Spawn a convoy of three vehicles and make them patrol around a location.
params [ ["_zoneID", 0], ["_tskPos", [0,0,0]] ];

private _tskCentre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _tskPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];

private _manList = missionNamespace getVariable [format["ZMM_%1_Man", _enemySide],["O_Soldier_F"]];
private _carList = missionNamespace getVariable [format["ZMM_%1_Convoy", _enemySide],[]];

private _tskDesc = [
		"A %3 %4 has just finished a meeting in %1 with an enemy Commander there. Destroy %4s convoy of <font color='#00FFFF'>%2 Vehicles</font>.",
		"Destroy a group of <font color='#00FFFF'>%2 Vehicles</font> understood to be owned by a %3 %4 living somewhere nearby %1.",
		"A %3 %4 is passing through the enemy-controlled area of %1. Locate the %4s <font color='#00FFFF'>%2 Vehicles</font> and destroy them.",
		"Neutralise a %3 %4 by destroying their vehicles and escort; <font color='#00FFFF'>%2 Vehicles</font> in total. The %4 will be travelling somewhere around %1.",
		"The area around %1 has long be controlled by a %3 %4. They will be driving around the enemy-controlled area of %1, locate the %4s <font color='#00FFFF'>%2 Vehicles</font> and eliminate them all.",
		"The %3 %4 of %1 has just completed a deal with rebel forces in the area. Find the %4s <font color='#00FFFF'>%2 Vehicles</font> and ensure both the %4 and all vehicles are destroyed."
	];	

private _conVerb = selectRandom ['feared', 'respected', 'notorious', 'senior', 'high-ranking', 'decorated', 'wealthy', 'rogue', 'dangerous', 'long-wanted', 'reclusive'];
private _conType = selectRandom ['Diplomat', 'Warlord', 'Terrorist', 'Official', 'Advisor', 'Leader', 'Kingpin', 'Drug Baron', 'Arms Dealer', 'Convict'];
private _objArr = selectRandom [
	[selectRandom ["Land_MetalCase_01_small_F","Land_MetalCase_01_small_F","Land_Suitcase_F"], format["%1 %2", selectRandom ["Chemical","Nuclear","Radioactive","Stolen"], selectRandom ["Detonator","Explosive","Substance","Agent","Munition","Weapon","Bomb","Plans"]]],
	["Land_Money_F", format["%1 %2", selectRandom ["Forged","Stolen","Counterfeit"], selectRandom ["Ancient Coin","stack of Banknotes","selection of Bills","stack of Cash"]]]
];

_objArr params ["_itemType","_itemDesc"];
private _itemText = format["<br/><br/>The %1 is known to be travelling with a %2 concealed inside a <font color='#00FFFF'>%3</font>. When either the %1 or the vehicle they are travelling in are destroyed, this item will be dropped nearby and must be collected by our forces.<br/><br/>Mission Item: <font color='#FFA500'>%3</font><br/><img width='350' image='%4'/>", _conType, _itemDesc, getText (configFile >> "CfgVehicles" >> _itemType >> "displayName"), getText (configFile >> "CfgVehicles" >> _itemType >> "editorPreview")];;

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
private _tskCount = 0;
private _tskActivation = [];
private _tskObj = objNull;

{
	_x params [["_vehType", ""], ["_customInit", ""]];
	
	if !(isClass (configFile >> "cfgVehicles" >> _vehType)) exitWith {
	
	};
	
	private _vehPos = [];
	
	for "_i" from 50 to 500 step 50 do {
		private _road = selectRandom (_tskPos nearRoads _i);
		if !(isNil "_road") exitWith { _vehPos = getPos _road };
	};
	
	// No valid road
	if (_vehPos isEqualTo []) then { _vehPos = (_tskCentre getPos [10 + random 40, random 360]) findEmptyPosition [1, 25, _vehType] };
	
	// No empty positions at all
	if (_vehPos isEqualTo []) then { _vehPos = _tskPos };
	
	["DEBUG", format["destroy_convoy (%1) - Creating %2 at %3", _zoneID, _vehType, _vehPos]] call zmm_fnc_misc_logMsg;
	
	private _tskVeh = createVehicle [_vehType, _vehPos, [], 0, "NONE"];
	
	// Run custom script if provided
	if (_customInit != "") then { _nul = call compile _customInit };
		
	missionNamespace setVariable [format["ZMM_%1_VEH_%2", _zoneID, _forEachIndex], _tskVeh];	
	
	private _cargoS = count fullCrew [_tskVeh, "cargo", true];
	private _cargoF = count fullCrew [_tskVeh, "turret", true];	
	private _crew = (count fullCrew [_tskVeh, "", true]) - _cargoS - _cargoF;

	// Create crew.
	for "_i" from 1 to _crew do {
		_tempMan = _enemyGrp createUnit [selectRandom _manList, [0,0,0], [], 150, "NONE"];
		[_tempMan] joinSilent _enemyGrp; 
		_tempMan moveInAny _tskVeh;
	};
	
	// TODO: FFV Seats not included? Open FIA trucks are empty!
	
	// If more than 1 cargo seat free, fill with a support group.
	if ((_cargoS + _cargoF) > 1) then {
		_cargoGrp = createGroup [_enemySide, true];
		for "_i" from 1 to (_cargoS + _cargoF) do {
			_tempMan = _cargoGrp createUnit [selectRandom _manList, [0,0,0], [], 150, "NONE"];
			[_tempMan] joinSilent _enemyGrp; 
			_tempMan moveInAny _tskVeh;
		};
		
		// Add a beret to the middle transport group.
		if (_forEachIndex == 1) then {
			_tskObj = selectRandom (if (count units _cargoGrp > 0) then { units _cargoGrp } else { crew _tskVeh });
			_tskObj addHeadgear "H_Beret_blk";
			_tskObj setVariable ["var_zoneID", _zoneID, true];
			_tskObj setVariable ["var_itemType", _itemType, true];
			_tskObj setVariable ["var_itemDesc", _itemDesc, true];
			_tskObj unlinkItem (hmd _tskObj);
		};
		
		// Add to Zeus
		{ _x addCuratorEditableObjects [units _cargoGrp, true] } forEach allCurators;
	};
		
	if (alive _tskVeh) then {
		// Add to Zeus
		{ _x addCuratorEditableObjects [[_tskVeh], true] } forEach allCurators;
		
		_tskVeh setConvoySeparation 20;
	
		_tskActivation pushBack format["!alive ZMM_%1_VEH_%2", _zoneID, _forEachIndex];
	
		_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _forEachIndex], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate and destroy the convoy vehicle.<br/><br/>Target Vehicle: <font color='#FFA500'>%1</font><br/><img width='350' image='%2'/>", getText (configFile >> "CfgVehicles" >> _vehType >> "displayName"), getText (configFile >> "CfgVehicles" >> _vehType >> "editorPreview")], format["Vehicle #%1", _forEachIndex + 1], format["MKR_Z%1_LOC", _zoneID]], nil, "CREATED", 1, false, true, format["move%1", _forEachIndex + 1]] call BIS_fnc_setTask;
		_childTrigger = createTrigger ["EmptyDetector", _tskCentre, false];
		_childTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
		_childTrigger setTriggerStatements [  format["!alive ZMM_%1_VEH_%2", _zoneID, _forEachIndex],
			format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState;", _zoneID, _forEachIndex],
			"" ];
										
		_tskCount = _tskCount + 1;
	};
} forEach _carList;

// Add HVT Sub-Mission
if (!isNull _tskObj) then {	
	_tskObj addEventHandler ["Killed", {
		params ["_unit", "_killer"];
		private _zoneID = _unit getVariable ["var_zoneID", 0];
		private _itemType = _unit getVariable ["var_itemType", objNull];
		private _itemDesc = _unit getVariable ["var_itemDesc", ""];
		
		private _itemObj = createVehicle [_itemType, position _unit, [], 1, "NONE"];
		_itemObj setVariable ["var_zoneID", _zoneID, true];
		
		private _itemTask = [[format["ZMM_%1_OBJ_TSK", _zoneID], format['ZMM_%1_TSK', _zoneID]], true, [format["Collect the %3.<br/><br/>Target Item: <font color='#FFA500'>%1</font><br/><img width='350' image='%2'/>", getText (configFile >> "CfgVehicles" >> _itemType >> "displayName"), getText (configFile >> "CfgVehicles" >> _itemType >> "editorPreview"), _itemDesc], format["Take %1", _itemDesc], format["MKR_Z%1_LOC", _zoneID]], _itemObj, "ASSIGNED", 1, false, true, "take"] call BIS_fnc_setTask;

		[_itemObj, 
			format["<t color='#00FF80'>Take %1</t>", getText (configFile >> "CfgVehicles" >> _itemType >> "displayName")], 
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_Search_ca.paa", 
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_Search_ca.paa", 
			"_this distance2d _target < 3", 
			"_caller distance2d _target < 3", 
			{}, 
			{}, 
			{
				private _zoneID = _target getVariable ["var_zoneID", 0];
				_caller playAction "PutDown"; 
				[format["ZMM_%1_OBJ_TSK", _zoneID], 'Succeeded', true] spawn BIS_fnc_taskSetState;
				sleep 1;
				deleteVehicle _target;
				missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], true, true];
			}, 
			{}, 
			[], 
			2, 
			10 
		] remoteExec ["bis_fnc_holdActionAdd", 0, _itemObj];
	}];

	// Add final trigger
	_tskActivation pushBack format["(missionNamespace getVariable ['ZMM_%1_OBJ', false])", _zoneID ];
} else {
	_itemText = "";
};

// [_enemyGrp, getPos selectRandom _foundRoads, 200] call bis_fnc_taskPatrol;
[leader _enemyGrp, format["MKR_Z%1_MAX", _zoneID], "SHOWMARKER"] spawn zmm_fnc_aiUPS;

// Add to Zeus
{ _x addCuratorEditableObjects [units _enemyGrp, true] } forEach allCurators;

if (_tskActivation isEqualTo []) exitWith {
	["ERROR", format["Zone %1 failed to generate objectives", _zoneID]] call zmm_fnc_misc_logMsg;
	false
};

// Create Completion Trigger
private _tskTrigger = createTrigger ["EmptyDetector", _tskCentre, false];
_tskTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_tskTrigger setTriggerStatements [ 	(_tskActivation joinString " && "), 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_Z%1_LOC','MKR_Z%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _tskTrigger, true];
[_tskTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _tskTrigger];
									
// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _tskDesc, _locName, _tskCount, _conVerb, _conType] + _itemText, ["Convoy"] call zmm_fnc_nameGen, format["MKR_Z%1_LOC", _zoneID]], _tskCentre, "CREATED", 1, false, true, "car"] call BIS_fnc_setTask;

true
