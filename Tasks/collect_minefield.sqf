// v 1.0
// Spawns a minefield and either adds a CASVAC mission or recover object mission.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];

if (_centre isEqualTo _targetPos || _targetPos isEqualTo [0,0,0]) then { _targetPos = [_centre, 25, 200, 5, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos; _targetPos set [2,0]; };

if (isNil "_targetPos") then { _targetPos = selectRandom (missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [_centre getPos [50, random 360]] ]) };

private _missionDesc = selectRandom [
	"A Ranger Team carrying %1 has fell silent having entered an enemy minefield near %4, locate and recover the <font color='#00FFFF'>%2</font> and evac any wounded back to HQ.",
	"An allied unit was wiped out when it entered a minefield. They were transporting %1 from %4, it is vital this is recovered. Locate the fallen team and recover the <font color='#00FFFF'>%2</font>.",
	"A friendly team encountered a minefield while escaping with %1 nearby %4. The entire team was killed but enemy forces have not yet secured the <font color='#00FFFF'>%2</font>. Locate and retrieve it before the enemy can.",
	"Zulu Unit went MIA while carrying %1 inside a <font color='#00FFFF'>%2</font>. It is believed they ran into an enemy minefield somewhere nearby %4. Locate and secure any survivors and the intelligence.",
	"A Recon Team have been hit by a mine while carrying vital %1 within a <font color='#00FFFF'>%2</font>. The team are all KIA however it is vital the intelligence is recovered - Locate it somewhere around %4 and bring it back.",
	"We have lost contact with a team moving though an enemy minefield, they were carrying %1 and it is vital this intel is returned to base. Locate the <font color='#00FFFF'>%2</font> the team was carrying near %4 and return it safely."
];
	
// Create Wreck
private _cutter = "Land_ClutterCutter_small_F" createVehicle _targetPos;
_crater = createSimpleObject ["Crater", AGLToASL _targetPos];
_crater setVectorUp surfaceNormal position _crater;
_crater setPos ((getPos _crater) vectorAdd [0,0,0.02]);

// Create Bodies
for "_i" from 0 to (random 1 + 2) do {
	private _man = (createGroup civilian) createUnit ["C_man_w_worker_F", _targetPos, [], 0, "NONE"];
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
		_minePos = _targetPos vectorAdd [_i, _j];
		_minePos set [2, 0.02];
		if (random 1 > 0.65 && _targetPos distance2D _minePos > 2 && !surfaceIsWater _minePos && count(lineIntersectsObjs [_minePos, [_minePos#0, _minePos#1, 20]]) == 0) then {
			private _mine = createMine [_mineType, _minePos, [], 3];
			_enemySide revealMine _mine;
			CIVILIAN revealMine _mine;
		};
	};
};

private _randPos = _targetPos getPos [random 125, random 360];

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
private _endTrigger = "";

private _itemType = selectRandom ["Land_Suitcase_F","Land_MetalCase_01_small_F","Land_PlasticCase_01_small_F","Land_PlasticCase_01_small_gray_F"];

private _itemObj = _itemType createVehicle (_targetPos getPos [1 + random 2, random 360]);
_itemObj setDir random 360;
		
private _missionData = selecTRandom [
	format["%1 Data", selectRandom ["Weapon", "Radio", "Flight", "Mapping", "Survey", "NBC", "Target", "Account"]],
	format["%1 Locations", selectRandom ["Intel", "Camp", "POW", "Minefield", "HVT", "Storage", "Bunker", "Cache", "Testing"]],
	format["a list of %1", selectRandom ["Prisoners", "Informants", "Stockpiles", "Assets", "Codes", "Target", "Recipes"]]
];

private _missionDesc = format[_missionDesc + "<br/><br/><font color='#00FF80'>Target Item:</font><br/><img width='350' image='%3'/>", _missionData, getText (configFile >> "CfgVehicles" >> _itemType >> "displayName"), getText (configFile >> "CfgVehicles" >> _itemType >> "editorPreview"), _locName];
		
_itemObj setVariable ["var_zoneID", _zoneID, true];

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
		missionNamespace setVariable [format["ZMM_%1_TSK_Completed", _zoneID], true, true];
		_caller playAction "PutDown"; 
		sleep 1;
		deleteVehicle _target;
		(parseText format["<t size='1.5' color='#72E500'>Intelligence Collected:</t><br/><t size='1.25'>%2</t><br/><br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\search_ca.paa'/><br/><br/>Found By: <t color='#0080FF'>%1</t><br/>", name _caller, getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName")]) remoteExec ["hintSilent"];
	}, 
	{}, 
	[], 
	2, 
	10 
] remoteExec ["bis_fnc_holdActionAdd", 0, _itemObj];

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerStatements [  format["(missionNamespace getVariable ['ZMM_%1_TSK_Completed', false])", _zoneID], 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { deleteMarker _x } forEach ['MKR_%1_OBJ','MKR_%1_ICO']; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _objTrigger, true];
[_objTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _objTrigger];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + _missionDesc, ["Recover"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "mine"] call BIS_fnc_setTask;