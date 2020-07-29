// v 1.0
// Spawns a damaged vehicle with men that need rescuing.
// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];

private _missionDesc = [
		"An allied team attempted to infiltrate %1 but were ambushed when attempting to escape. <font color='#00FFFF'>%2 Soldiers</font> have been left wounded in critical condition, secure the area and evacuate the casualties.",
		"Friendly units have been ambushed near %1, <font color='#00FFFF'>%2 Soldiers</font> are wounded and require immediate rescue. Locate and extract them.",
		"Find and rescue <font color='#00FFFF'>%2 Soldiers</font> wounded when their vehicle hit and IED somewhere within %1.",
		"An enemy ambush at %1 has left <font color='#00FFFF'>%2 Soldiers</font> wounded and requiring immediate evacuation, locate the ambush site and save the Soldiers.",
		"One of our vehicles has hit a mine when passing through %1, at least <font color='#00FFFF'>%2 Soldiers</font> are reported to be injured. Locate them and extract them from the area.",
		"Enemy forces have quickly moved into %1 and attacked an allied convoy, the rear vehicle took a wrong turn and <font color='#00FFFF'>%2 Soldiers</font> are believed MIA, likely requiring immediate evacuation. Locate the Soldiers and rescue them."
	];	

if (isNil "_targetPos") then { _targetPos = selectRandom (missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [_centre getPos [50, random 360]] ]) };

private _targetPos = _targetPos findEmptyPosition [1, 50, "Land_Wreck_Ural_F"];
	
// Create Wreck
private _wreck = (selectRandom ["Land_Wreck_Ural_F", "Land_Wreck_UAZ_F", "Land_Wreck_HMMWV_F"]) createVehicle _targetPos;
_wreck setVectorUp surfaceNormal position _wreck;

private _smoke = createVehicle ["test_EmptyObjectForFireBig", (position _wreck) vectorAdd [0,0,-3], [], 0, "CAN_COLLIDE"];
private _crater = createSimpleObject ["Crater", AGLToASL _targetPos];
_crater setPos ((getPos _crater) vectorAdd [0,0,0.02]);

// Find a random point nearby for markers.
private _relPos = [ _targetPos, random 50, random 360 ] call BIS_fnc_relPos;

// Create Bodies
private _deadBody = (createGroup civilian) createUnit ["C_man_w_worker_F", [0,0,0], [], 150, "NONE"];	
_deadBody forceAddUniform (uniform selectRandom allPlayers);
_deadBody addVest (vest selectRandom allPlayers);
_deadBody addHeadgear (headgear selectRandom allPlayers);
_deadBody disableAI "ALL";
_deadBody setDir random 360;
_deadBody setPos ((_wreck getPos [random 1, random 360]) vectorAdd [0,0,5]);
_deadBody setDamage 1;
removeFromRemainsCollector [_deadBody];

private _hvtActivation = [];
private _hvtNum = 0;

for "_i" from 0 to (random 1 + 2) do {
	_hvtNum = _hvtNum + 1;
		
	private _tempPos = (_targetPos getPos [2 + random 2, random 360]) findEmptyPosition [0, 5, "C_man_w_worker_F"];
	private _evacMan = (createGroup civilian) createUnit ["C_man_w_worker_F", _tempPos, [], 0, "NONE"];	
	_evacMan setCaptive true;
	_evacMan forceAddUniform (uniform selectRandom allPlayers);
	_evacMan addVest (vest selectRandom allPlayers);
	_evacMan addHeadgear (headgear selectRandom allPlayers);
	_evacMan disableAI "ALL";
	_evacMan setDir random 360;
	removeFromRemainsCollector [_evacMan];
	
	// Add to Zeus
	{ _x addCuratorEditableObjects [[_evacMan], TRUE] } forEach allCurators;
	
	_evacMan spawn {
		sleep 3;
		private _blood = createSimpleObject [ selectRandom ["BloodPool_01_Large_New_F","BloodPool_01_Medium_New_F","BloodSplatter_01_Large_New_F","BloodSplatter_01_Medium_New_F","BloodSplatter_01_Small_New_F"], [0,0,0]];
		_blood setPos getPos _this;
		_blood setVectorUp surfaceNormal position _blood;
		_blood setPos ((getPos _blood) vectorAdd [0,0,0.02]);
	};

	missionNamespace setVariable [format["ZMM_%1_HVT_%2", _zoneID, _i], _evacMan];

	// Check if ACE is enabled
	if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {
		[_evacMan, true] call ace_medical_fnc_setUnconscious;
		//[_evacMan, 0.1, selectRandom ["leg_r","leg_l","body"], "bullet"] call ace_medical_fnc_addDamageToUnit;
	} else {
		_evacMan setUnconscious TRUE;
		[_evacMan, 
			format["<t color='#00FF80'>Revive %1</t>", name _evacMan], 
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_revive_ca.paa", 
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_revive_ca.paa", 
			"lifeState _target == 'INCAPACITATED' && _this distance _target < 3",   
			"lifeState _target == 'INCAPACITATED' && _caller distance _target < 3",   
			{ _caller playAction "medic" },
			{}, 
			{
				[_target, _actionID] remoteExec ["BIS_fnc_holdActionRemove"];
				[_target, false] remoteExec ["setUnconscious", _target]; 
				[_target, "ALL"] remoteExec ["enableAI", _target];
				sleep 2;
				[_target] join group _caller;
			}, 
			{_caller switchMove ""},
			[], 
			5, 
			10 
		] remoteExec ["bis_fnc_holdActionAdd", 0, _evacMan];
	};

	// Child task
	private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], TRUE, [format["Locate and stabilize <font color='#00FFFF'>%1</font>, then extract them from the area.", name _evacMan], format["Rescue Soldier #%1", _i + 1], format["MKR_%1_OBJ", _zoneID]], objNull, "CREATED", 1, FALSE, TRUE, format["move%1", _i + 1]] call BIS_fnc_setTask;
	private _childTrigger = createTrigger ["EmptyDetector", _centre, false];
	_childTrigger setTriggerStatements [  format["(alive ZMM_%1_HVT_%2 && ZMM_%1_HVT_%2 distance2D %3 > 400)", _zoneID, _i, _centre],
									format["['ZMM_%1_SUB_%2', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState;", _zoneID, _i],
									"" ];
	
	// Failure trigger when HVT is dead.
	private _hvtTrigger = createTrigger ["EmptyDetector", _centre, false];
	_hvtTrigger setTriggerStatements [ 	format["!alive ZMM_%1_HVT_%2", _zoneID, _i], 
									format["['ZMM_%1_TSK', 'Failed', TRUE] spawn BIS_fnc_taskSetState; ['ZMM_%1_SUB_%2', 'Failed', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'ColorGrey' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _i],
									"" ];
									
	// Build success trigger when HVT is alive and far from objective.
	_hvtActivation pushBack format["(alive ZMM_%1_HVT_%2 && ZMM_%1_HVT_%2 distance2D %3 > 400)", _zoneID, _i, _centre];
};

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerStatements [ 	(_hvtActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'ColorGrey' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];
// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, round _hvtNum], ["Rescue"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "heal"] call BIS_fnc_setTask;

TRUE
