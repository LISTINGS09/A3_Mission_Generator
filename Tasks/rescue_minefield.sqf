// v 1.0
// Spawns a minefield and either adds a CASVAC mission or recover object mission.
// TODO: Add support for ZZM_ObjectiveCount
params [ ["_zoneID", 0], ["_tskPos", [0,0,0]] ];

private _tskCentre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _tskPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];

if (_tskCentre isEqualTo _tskPos || _tskPos isEqualTo [0,0,0]) then { _tskPos = [_tskCentre, 25, 200, 5, 0, 0.5, 0, [], [ _tskCentre, _tskCentre ]] call BIS_fnc_findSafePos; _tskPos set [2,0]; };

if (isNil "_tskPos") then { _tskPos = selectRandom (missionNamespace getVariable [ format["ZMM_Z%1_FlatLocations", _zoneID], [_tskCentre getPos [50, random 360]] ]) };

private _tskDesc = selectRandom [
	"An allied Scout Team has hit an enemy minefield nearby %1, locate and stabilise the survivors and evacuate them back to HQ.",
	"A Recon Unit reported discovering an enemy minefield at %1, contact was lost shortly afterwards. Locate the unit and recover any survivors at the site.",
	"While under fire from enemy forces, an allied team have wandered into an minefield. Move into the area and secure the allied team somewhere at %1, extracting any survivors.",
	"A Recon Team are believed to have walked into an enemy minefield in the vicinity of %1. Locate the team and rescue any survivors in the area.",
	"Allied forces have hit an enemy minefield at %1, they are understood to be heavily wounded and required immediate evacuation. Locate the friendly units and extract any survivors.",
	"While retreating from enemy contact an allied team have hit an enemy minefield. Heavy casualties have been reported at %1, locate them and extract any survivors."
];
	
// Create Wreck
private _cutter = "Land_ClutterCutter_small_F" createVehicle _tskPos;
private _crater = createSimpleObject ["Crater", AGLToASL _tskPos];
_crater setVectorUp surfaceNormal position _crater;
_crater setPos ((getPos _crater) vectorAdd [0,0,0.02]);

// Create Bodies
for "_i" from 1 to (random 3) do {
	private _man = (createGroup civilian) createUnit ["C_man_w_worker_F", _tskPos, [], 0, "NONE"];
	_man disableAI "MOVE";
	
	_man spawn {
		sleep 0.1;
		_this setPos ((_this getPos [1.5 + random 3, random 360]) vectorAdd [0,0,2]);
		_this setDir random 360;	
		_this setDamage 1;
		sleep 5;
		_this forceAddUniform (uniform selectRandom allPlayers);
		_this addVest (vest selectRandom allPlayers);
		_this addHeadgear (headgear selectRandom allPlayers);
		removeFromRemainsCollector [_this];
		_this switchMove selectRandom ["KIA_gunner_standup01","KIA_passenger_boat_holdleft","Static_Dead","KIA_gunner_static_low01","KIA_gunner_standup01"];
		
		private _blood = createSimpleObject [ selectRandom ["BloodPool_01_Medium_New_F","BloodSplatter_01_Medium_New_F","BloodSplatter_01_Small_New_F"], [0,0,0]];
		_blood setPos (_this getPos [random 1, random 360]);
		_blood setVectorUp surfaceNormal position _blood;
		_blood setPos ((getPos _blood) vectorAdd [0,0,0.02]);
	};
};

private _mineType = selectRandom ["APERSBoundingMine","APERSMine"];

for "_i" from -25 to 25 step 5 do {
	for "_j" from -25 to 25 step 5 do {
		_minePos = _tskPos vectorAdd [_i, _j];
		_minePos set [2, 0.02];
		if (random 1 > 0.65 && _tskPos distance2D _minePos > 2 && !surfaceIsWater _minePos && count(lineIntersectsObjs [_minePos, [_minePos#0, _minePos#1, 20]]) == 0) then {
			private _mine = createMine [_mineType, _minePos, [], 3];
			_enemySide revealMine _mine;
			CIVILIAN revealMine _mine;
		};
	};
};

private _randPos = _tskPos getPos [random 125, random 360];

private _mrkr = createMarker [format["MKR_%1_OBJ", _zoneID], _randPos];
_mrkr setMarkerShape "ELLIPSE";
_mrkr setMarkerBrush "Border";
_mrkr setMarkerSize [150, 150];
_mrkr setMarkerAlpha 0.4;
_mrkr setMarkerColor "ColorRed";

private _mrkr = createMarker [format["MKR_%1_ICO", _zoneID], _randPos];
_mrkr setMarkerType "MinefieldAP";
_mrkr setMarkerSize [1,1];
_mrkr setMarkerAlpha 0.4;
_mrkr setMarkerColor "ColorRed";

// Create Task
private _evacMan = (createGroup civilian) createUnit ["C_man_w_worker_F", [0,0,0], [], 150, "NONE"];	
_evacMan allowDamage false;
_evacMan disableAI "MOVE";
_evacMan setPos (_tskPos getPos [random 1, random 360]);
_evacMan setDir random 360;

_evacMan spawn {
	sleep 5;
	_this forceAddUniform (uniform selectRandom allPlayers);
	_this addVest (vest selectRandom allPlayers);
	_this addHeadgear (headgear selectRandom allPlayers);
	removeFromRemainsCollector [_this];
	if (isClass(configFile >> "CfgPatches" >> "ace_main")) then { [_this, true] call ace_medical_fnc_setUnconscious } else { _this setUnconscious true; _this switchMove "unconsciousReviveDefault"; };
};

_evacMan addEventHandler ["killed",{
	private _killer = if (isNull (_this#2)) then { (_this#0) getVariable ["ace_medical_lastDamageSource", (_this#1)] } else { (_this#2) };
	if (isPlayer _killer) then { format["%1 (%2) killed %3",name _killer,groupId group _killer,name (_this select 0)] remoteExec ["systemChat",0] };
}];

private _blood = createSimpleObject [ selectRandom ["BloodPool_01_Large_New_F","BloodPool_01_Medium_New_F","BloodSplatter_01_Large_New_F","BloodSplatter_01_Medium_New_F","BloodSplatter_01_Small_New_F"], [0,0,0]];
_blood setPos (_evacMan getPos [random 1, random 360]);
_blood setVectorUp surfaceNormal position _blood;
_blood setPos ((getPos _blood) vectorAdd [0,0,0.02]);

missionNamespace setVariable [format["ZMM_%1_HVT", _zoneID], _evacMan];

// If vanilla add an action to move them.
if !(isClass(configFile >> "CfgPatches" >> "ace_main")) then {
	_evacMan setVariable ["FAR_var_isStable", true, true];
	
	[_evacMan, 
		format["<t color='#00FF80'>Revive %1</t>", name _evacMan], 
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_revive_ca.paa", 
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_revive_ca.paa", 
		"lifeState _target == 'INCAPACITATED' && _this distance2d _target < 3 && 'Medkit' in items _this",   
		"lifeState _target == 'INCAPACITATED' && _caller distance2d _target < 3",   
		{ _caller playAction "medic" },
		{}, 
		{
			[_target, _actionID] remoteExec ["BIS_fnc_holdActionRemove"];
			[_target] joinSilent group _caller;
			sleep 2;
			[_target, false] remoteExec ["setUnconscious", owner _target]; 
			[_target, "MOVE"] remoteExec ["enableAI", owner _target];
		}, 
		{_caller switchMove ""},
		[], 
		5, 
		10 
	] remoteExec ["bis_fnc_holdActionAdd", 0, _evacMan];
};

// Only enable damage when players are near.
private _allowDmgTrigger = createTrigger ["EmptyDetector", _tskPos, false];
_allowDmgTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_allowDmgTrigger setTriggerArea [25, 25, 0, false, 25];
_allowDmgTrigger setTriggerStatements [	"this", 
	format["ZMM_%1_HVT allowDamage true;", _zoneID],
	"" ];

// Create Completion Trigger
private _tskTrigger = createTrigger ["EmptyDetector", _tskCentre, false];
_tskTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_tskTrigger setTriggerStatements [ format["alive ZMM_%1_HVT && %2 distance2D ZMM_%1_HVT > 300", _zoneID, _tskCentre], 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { deleteMarker _x } forEach ['MKR_%1_OBJ','MKR_%1_ICO']; { _x setMarkerColor 'Color%2' } forEach ['MKR_Z%1_LOC','MKR_Z%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _tskTrigger, true];
[_tskTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _tskTrigger];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + (format[_tskDesc, _locName]), ["CASVAC"] call zmm_fnc_nameGen, format["MKR_Z%1_LOC", _zoneID]], _tskCentre, "CREATED", 1, false, true, "mine"] call BIS_fnc_setTask;



