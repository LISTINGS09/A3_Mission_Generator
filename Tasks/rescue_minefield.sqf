// Spawns a minefield and either adds a CASVAC mission or recover object mission.
// Set-up mission variables.
// [0, player getPos [50, random 360]] execVM "mine_field.sqf
params [ ["_zoneID", 0], "_targetPos"];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];

if (isNil "_targetPos") then { _targetPos = selectRandom (missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [_centre getPos [50, random 360]] ]) };

// Replaced later.
_missionDesc = "";
	
// Create Wreck
_cutter = "Land_ClutterCutter_small_F" createVehicle _targetPos;
_crater = createSimpleObject ["Crater", _targetPos];
_crater setVectorUp surfaceNormal position _crater;
_crater setPos ((getPos _crater) vectorAdd [0,0,0.02]);

// Create Bodies
_tempPlayer = (allPlayers select {alive _x}) select 0;

for "_i" from 0 to (random 1 + 2) do {
	_man = (createGroup civilian) createUnit ["C_man_w_worker_F", [0,0,0], [], 0, "NONE"];	
	_man forceAddUniform (uniform _tempPlayer);
	_man addVest (vest _tempPlayer);
	_man addHeadgear (headgear _tempPlayer);
	_man disableAI "ALL";
	_man setPos ((_targetPos getPos [1.5 + random 3, random 360]) vectorAdd [0,0,1]);
	_man setDir random 360;
	_man setDamage 1;
	removeFromRemainsCollector [_man];
	
	_blood = createSimpleObject [ selectRandom ["BloodPool_01_Medium_New_F","BloodSplatter_01_Medium_New_F","BloodSplatter_01_Small_New_F"], _targetPos];
	_blood setPos (_man getPos [random 1, random 360]);
	_blood setVectorUp surfaceNormal position _blood;
	_blood setPos ((getPos _blood) vectorAdd [0,0,0.02]);
};

_mineType = selectRandom ["APERSMine_Range_Ammo", "APERSBoundingMine_Range_Ammo"];

for "_i" from -25 to 25 step 5 do {
	for "_j" from -25 to 25 step 5 do {
		_minePos = _targetPos vectorAdd [_i, _j, 0];
		if (random 1 > 0.35 && _targetPos distance2D _minePos > 2 && !surfaceIsWater _minePos) then {
			_mine = createVehicle [_mineType, _minePos, [], 3, "NONE"];
			_enemySide revealMine _mine;
		};
	};
};

_randPos = _targetPos getPos [random 40, random 360];

_mrkr = createMarker [format["MKR_%1_OBJ", _zoneID], _randPos];
_mrkr setMarkerShape "ELLIPSE";
_mrkr setMarkerBrush "SolidBorder";
_mrkr setMarkerSize [50, 50];
_mrkr setMarkerAlpha 0.4;
_mrkr setMarkerColor "ColorRed";

_mrkr = createMarker [format["MKR_%1_ICO", _zoneID], _randPos];
_mrkr setMarkerType "mil_warning";
_mrkr setMarkerSize [1,1];
_mrkr setMarkerAlpha 0.4;
_mrkr setMarkerColor "ColorRed";

// Create Task
_taskType = selectRandom ["CASVAC","Item Hunt"];
_endTrigger = "";

if (_taskType == "Item Hunt") then {
	_itemType = selectRandom ["Land_Suitcase_F","Land_MetalCase_01_small_F","Land_PlasticCase_01_small_F","Land_PlasticCase_01_small_gray_F"];
	
	_itemObj = _itemType createVehicle (_targetPos getPos [1 + random 2, random 360]);
	_itemObj setDir random 360;
		
	_missionData = selecTRandom [
		format["%1 Data", selectRandom ["Weapon", "Radio", "Flight", "Mapping", "Survey", "NBC", "Target", "Account"]],
		format["%1 Locations", selectRandom ["Intel", "Camp", "POW", "Minefield", "HVT", "Storage", "Bunker", "GOAT", "Testing"]],
		format["a list of %1", selectRandom ["Prisoners", "Informants", "Stockpiles", "Assets", "Codes", "Target", "Recipes"]]
	];
	
	_missionDesc = selectRandom [
		"A Ranger Team carrying %1 has fell silent having entered an enemy minefield near %3, locate and recover the <font color='#00FFFF'>%2</font> and evac any wounded back to HQ.<br/><br/>Target Container:<br/><img width='350' image='%3'/>",
		"An allied unit as wiped out when it entered a minefield. They were transporting %1 from %3, it is vital this is recovered. Locate the fallen team and recover the <font color='#00FFFF'>%2</font><br/><br/>Target Container:<br/><img width='350' image='%3'/>.",
		"A friendly team encountered a minefield while escaping with %1 nearby %3. The entire team was killed but enemy forces have not yet secured the <font color='#00FFFF'>%2</font>. Locate and retrieve it before the enemy can.<br/><br/>Target Container:<br/><img width='350' image='%3'/>",
		"Zulu Unit went MIA while carrying %1 inside a <font color='#00FFFF'>%2</font>. It is believed they ran into an enemy minefield somewhere nearby %3. Locate and secure any survivors and the intelligence.<br/><br/>Target Container:<br/><img width='350' image='%3'/>",
		"A Recon Team have been hit by a mine while carrying vital %1 within a <font color='#00FFFF'>%2</font>. The team are all KIA however it is vital the intelligence is recovered - Locate it somewhere around %3 and bring it back.<br/><br/>Target Container:<br/><img width='350' image='%3'/>",
		"We have lost contact with a team moving though an enemy minefield, they were carrying %1 and it is vital this intel is returned to base. Locate the <font color='#00FFFF'>%2</font> the team was carrying near %3 and return it safely.<br/><br/>Target Container:<br/><img width='350' image='%3'/>"
	];
	
	_missionDesc = format[_missionDesc, _missionData, getText (configFile >> "CfgVehicles" >> _itemType >> "displayName"), getText (configFile >> "CfgVehicles" >> _itemType >> "editorPreview"), _locName];
			
	_itemObj setVariable ["var_zoneID", _zoneID, TRUE];
	_endTrigger = format["(missionNamespace getVariable ['ZMM_%1_TSK_Completed', false])", _zoneID];

	[_itemObj, 
		format["<t color='#00FF80'>Take %1</t>", getText (configFile >> "CfgVehicles" >> _itemType >> "displayName")], 
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_Search_ca.paa", 
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_Search_ca.paa", 
		"_this distance _target < 3", 
		"_caller distance _target < 3", 
		{}, 
		{}, 
		{
			_varName = format["ZMM_%1_TSK_Completed", (_target getVariable ["var_zoneID", 0])];
			missionNamespace setVariable [_varName, true, true];
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
};

if (_taskType == "CASVAC") then {
	_evacMan = (createGroup civilian) createUnit ["C_man_w_worker_F", [0,0,0], [], 0, "NONE"];	
	_evacMan setCaptive true;
	_evacMan forceAddUniform (uniform _tempPlayer);
	_evacMan addVest (vest _tempPlayer);
	_evacMan addHeadgear (headgear _tempPlayer);
	_evacMan setPos (_targetPos getPos [random 1, random 360]);
	_evacMan setDir random 360;
	
	_blood = createSimpleObject [ selectRandom ["BloodPool_01_Large_New_F","BloodPool_01_Medium_New_F","BloodSplatter_01_Large_New_F","BloodSplatter_01_Medium_New_F","BloodSplatter_01_Small_New_F"], _targetPos];
	_blood setPos (_evacMan getPos [random 1, random 360]);
	_blood setVectorUp surfaceNormal position _blood;
	_blood setPos ((getPos _blood) vectorAdd [0,0,0.02]);
	
	missionNamespace setVariable [format["ZMM_%1_HVT", _zoneID], _evacMan];
	
	_endTrigger = format["alive ZMM_%1_HVT && %2 distance2D ZMM_%1_HVT > 300", _zoneID, _centre];
	
	// Check if ACE is enabled
	if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {
		_evacMan disableAI "ALL";
		[_evacMan, true] call ace_medical_fnc_setUnconscious;
		[_evacMan, 0.4, "leg_r", "bullet"] call ace_medical_fnc_addDamageToUnit;
		[_evacMan, 0.2, "leg_l", "bullet"] call ace_medical_fnc_addDamageToUnit;
		[_evacMan, 0.4, "body", "bullet"] call ace_medical_fnc_addDamageToUnit;
		[_evacMan] call ACE_medical_fnc_handleDamage_advancedSetDamage;
	} else {
		_evacMan setUnconscious TRUE;
		[_evacMan, 
			format["<t color='#00FF80'>Revive %1</t>", name _evacMan], 
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_revive_ca.paa", 
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_revive_ca.paa", 
			"lifeState _target == 'INCAPACITATED' && _this distance _target < 3 && 'Medkit' in items _this",   
			"lifeState _target == 'INCAPACITATED' && _caller distance _target < 3",   
			{ _caller playAction "medic" },
			{}, 
			{
				[_target, false] remoteExec ["setUnconscious", _target]; 
				[_target, "ALL"] remoteExec ["enableAI", _target];
				[_target, _actionID] remoteExec ["BIS_fnc_holdActionRemove"];
				sleep 2;
				[_target] joinSilent group _caller;
			}, 
			{_caller switchMove ""},
			[], 
			5, 
			10 
		] remoteExec ["bis_fnc_holdActionAdd", 0, _evacMan];
	};
	
	_missionDesc = selectRandom [
		"An allied Scout Team has hit an enemy minefield nearby %1, locate and stabilise the survivors and evacuate them back to HQ.",
		"A Recon Unit reported discovering an enemy minefield at %1, contact was lost shortly afterwards. Locate the unit and recover any survivors at the site.",
		"While under fire from enemy forces, an allied team have wandered into an minefield. Move into the area and secure the allied team somewhere at %1, extracting any survivors.",
		"A Recon Team are believed to have walked into an enemy minefield in the vicinity of %1. Locate the team and rescue any survivors in the area.",
		"Allied forces have hit an enemy minefield at %1, they are understood to be heavily wounded and required immediate evacuation. Locate the friendly units and extract any survivors.",
		"While retreating from enemy contact an allied team have hit an enemy minefield. Heavy casualties have been reported at %1, locate them and extract any survivors."
	];
	
	_missionDesc = format[_missionDesc, _locName];

	// Create Failure Trigger
	_failTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
	_failTrigger setTriggerStatements [	format["!alive ZMM_%1_HVT", _zoneID], 
										format["['ZMM_%1_TSK', 'Failed', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN','MKR_%1_MIN','MKR_%1_ICO']", _zoneID, "Grey"],
										"" ];
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerStatements [  _endTrigger, 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_OBJ','MKR_%1_MIN','MKR_%1_ICO']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + _missionDesc, [_taskType] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "AUTOASSIGNED", 1, FALSE, TRUE, "mine"] call BIS_fnc_setTask;



