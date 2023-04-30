// v 1.0
// Spawns a damaged vehicle with men that need rescuing.
// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];

private _missionDesc = [
		"An allied team attempted to infiltrate %1 but were ambushed when attempting to escape in an a %3. <font color='#00FFFF'>%2 Soldiers</font> have been left wounded in critical condition, secure the area and evacuate the casualties.",
		"Friendly units have been ambushed near %1, <font color='#00FFFF'>%2 Soldiers</font> attempted to flee in a %3 and require immediate rescue. Locate and extract them.",
		"Find and rescue <font color='#00FFFF'>%2 Soldiers</font> wounded when their vehicle, a %3 hit an IED somewhere within %1.",
		"An enemy ambush at %1 has left <font color='#00FFFF'>%2 Soldiers</font> trying to recover a captured %3 wounded and requiring immediate evacuation. Locate the ambush site and save the Soldiers.",
		"A %3 captured from the enemy has hit a mine when passing through %1, at least <font color='#00FFFF'>%2 Soldiers</font> are reported to be injured. Locate them and extract them from the area.",
		"Enemy forces within %1 attacked a convoy escorting a captured %3. <font color='#00FFFF'>%2 Soldiers</font> are believed MIA, likely requiring immediate evacuation. Locate the Soldiers and rescue them."
	];	

if (_centre isEqualTo _targetPos || _targetPos isEqualTo [0,0,0]) then { _targetPos = [_centre, 25, 200, 5, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos };
if (isNil "_targetPos") then { _targetPos = _centre };

private _targetPos = _targetPos findEmptyPosition [1, 100, "Land_Wreck_Ural_F"];
	
// Create Wreck
private _wreck = objNull;
private _wreckList = (missionNamespace getVariable [format["ZMM_%1Veh_Light", _enemySide], []]) + (missionNamespace getVariable [format["ZMM_%1Veh_Medium", _enemySide], []]) + (missionNamespace getVariable [format["ZMM_%1Veh_Heavy", _enemySide], []]);

if (count _wreckList > 0) then {
	_wreckType = selectRandom _wreckList;
	
	if (_wreckType isEqualType []) then { _wreckType = _wreckType#0 };
	
	_wreck = createVehicle [_wreckType, _targetPos, [], 5, "NONE"];
	_wreck setDir random 360;
	_wreck lock true;
	_wreck setVehicleAmmo 0;
	_wreck allowDamage false;	
	{ _wreck setObjectTextureGlobal [_forEachIndex, "a3\structures_f\wrecks\data\plane_transport_01_body_co.paa"] } forEach (getObjectTextures _wreck);	
	removeFromRemainsCollector [_wreck];
	
	_targetPos = getPos _wreck;
} else {
	_wreck = (selectRandom ["Land_Wreck_Ural_F", "Land_Wreck_UAZ_F", "Land_Wreck_HMMWV_F"]) createVehicle _targetPos;
};

_wreck setVectorUp surfaceNormal position _wreck;

private _smoke = createVehicle ["test_EmptyObjectForFireBig", (position _wreck) vectorAdd [0,0,-3], [], 0, "CAN_COLLIDE"];
private _crater = createSimpleObject ["Crater", AGLToASL _targetPos];
_crater setPos ((getPos _crater) vectorAdd [0,0,0.02]);

// Find a random point nearby for markers.
private _relPos = [ _targetPos, random 50, random 360 ] call BIS_fnc_relPos;

private _hvtGroup = createGroup civilian;
private _hvtActivation = [];
private _hvtFailure = [];
private _hvtNum = 0;

for "_i" from 1 to (missionNamespace getVariable ["ZZM_ObjectiveCount", 3]) do {
	_hvtNum = _hvtNum + 1;
		
	private _evacMan = _hvtGroup createUnit ["C_man_w_worker_F", _targetPos getPos [5 + random 25, random 360], [], 3, "NONE"];	
	_evacMan setCaptive true;
	_evacMan disableAI "MOVE";
	_evacMan setDir random 360;
	
	_evacMan addEventHandler ["killed",{
		private _killer = if (isNull (_this#2)) then { (_this#0) getVariable ["ace_medical_lastDamageSource", (_this#1)] } else { (_this#2) };
		if (isPlayer _killer) then { format["%1 (%2) killed %3",name _killer,groupId group _killer,name (_this select 0)] remoteExec ["systemChat",0] };
	}];
	
	// Add to Zeus
	{ _x addCuratorEditableObjects [[_evacMan], true] } forEach allCurators;
	
	_evacMan spawn {
		sleep 5;
		_this forceAddUniform (uniform selectRandom allPlayers);
		_this addVest (vest selectRandom allPlayers);
		_this addHeadgear (headgear selectRandom allPlayers);
		removeFromRemainsCollector [_this];
		
		private _blood = createSimpleObject [ selectRandom ["BloodPool_01_Large_New_F","BloodPool_01_Medium_New_F","BloodSplatter_01_Large_New_F","BloodSplatter_01_Medium_New_F","BloodSplatter_01_Small_New_F"], [0,0,0]];
		_blood setPos getPos _this;
		_blood setVectorUp surfaceNormal position _blood;
		_blood setPos ((getPos _blood) vectorAdd [0,0,0.02]);
		
		if (isClass(configFile >> "CfgPatches" >> "ace_main")) then { [_this, true] call ace_medical_fnc_setUnconscious } else { _this setUnconscious true; _this switchMove "unconsciousReviveDefault"; };
	};

	missionNamespace setVariable [format["ZMM_%1_HVT_%2", _zoneID, _i], _evacMan];

	// Check if ACE is enabled
	if !(isClass(configFile >> "CfgPatches" >> "ace_main")) then {
		_evacMan setVariable ["FAR_var_isStable", true, true];
		
		[_evacMan, 
			format["<t color='#00FF80'>Revive %1</t>", name _evacMan], 
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_revive_ca.paa", 
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_revive_ca.paa", 
			"lifeState _target == 'INCAPACITATED' && _this distance2d _target < 3",   
			"lifeState _target == 'INCAPACITATED' && _caller distance2d _target < 3",   
			{ _caller playAction "medic" },
			{}, 
			{
				[_target, _actionID] remoteExecCall ["BIS_fnc_holdActionRemove"];			
				[_target] join group _caller;
				sleep 2;
				[_target, false] remoteExecCall ["setUnconscious", owner _target]; 
				[_target, "MOVE"] remoteExecCall ["enableAI", owner _target];
				[_target, false] remoteExec ["setCaptive", owner _target];
			}, 
			{_caller switchMove ""},
			[], 
			5, 
			10 
		] remoteExec ["bis_fnc_holdActionAdd", 0, _evacMan];
	};

	// Child task
	private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate and stabilize <font color='#00FFFF'>%1</font>, then extract them from the area.", name _evacMan], format["Rescue Soldier #%1", _i], format["MKR_%1_OBJ", _zoneID]], objNull, "CREATED", 1, false, true, format["move%1", _i]] call BIS_fnc_setTask;
	private _childTrigger = createTrigger ["EmptyDetector", _centre, false];
	_childTrigger setTriggerStatements [  format["(alive ZMM_%1_HVT_%2 && ZMM_%1_HVT_%2 distance2D %3 > 400)", _zoneID, _i, _centre],
									format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState;", _zoneID, _i],
									"" ];
	
	// Failure trigger when HVT is dead.
	private _hvtTrigger = createTrigger ["EmptyDetector", _centre, false];
	_hvtTrigger setTriggerStatements [ 	format["!alive ZMM_%1_HVT_%2", _zoneID, _i], 
									format["['ZMM_%1_SUB_%2', 'Failed', true] spawn BIS_fnc_taskSetState;", _zoneID, _i],
									"" ];
									
	// Build success trigger when HVT is alive and far from objective.
	_hvtActivation pushBack format["((alive ZMM_%1_HVT_%2 && ZMM_%1_HVT_%2 distance2D %3 > 400) || !alive ZMM_%1_HVT_%2)", _zoneID, _i, _centre];
	_hvtFailure pushBack format["(!alive ZMM_%1_HVT_%2)", _zoneID, _i];
};

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerStatements [ 	(_hvtActivation joinString " && "), 
									format["if (%2) then { ['ZMM_%1_TSK', 'Failed', true] spawn BIS_fnc_taskSetState; { _x setMarkerColor 'ColorGrey' } forEach ['MKR_%1_LOC','MKR_%1_MIN'] } else { ['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN'] }; missionNamespace setVariable ['ZMM_DONE', true, true];", _zoneID, (_hvtFailure joinString " || ")],
									"" ];
// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, round _hvtNum], ["Rescue"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "heal"] call BIS_fnc_setTask;

true
