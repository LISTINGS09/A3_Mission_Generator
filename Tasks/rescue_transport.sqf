// Disable an enemy prisoner transport and unlock it so the cargo can escape.
params [ ["_zoneID", 0], "_targetPos"];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];

_missionDesc = [
		"A group of %3 have been captured by enemy forces near %1 and are being transported to a prison camp. Locate the unarmed transport, disable the vehicle and free the <font color='#00FFFF'>%2 %3</font>.",
		"An unarmed transport carrying <font color='#00FFFF'>%2 %3</font> captured by enemy forces will be passing through %1 shortly. Ambush the vehicle, disable it and free the %3 from the vehicle.",
		"A transport carrying captive %1 has been located near %1. Disable the vehicle and free the <font color='#00FFFF'>%2 %3</font> aboard.",
		"Track down and free <font color='#00FFFF'>%2 %3</font> that are being transported near %1.",
		"Enemy forces have captured and are trying to transport <font color='#00FFFF'>%2 %3</font> through %1. Locate the truck and free the %3 from captivity.",
		"A number of %3 have been rounded up by enemy forces somewhere in %1. Locate the truck transporting them and free <font color='#00FFFF'>%2 %3</font>."
	];	

_prisonerType = selectRandom ['Civilians', 'POWs', 'Prisoners', 'Dissidents', 'Rebels', 'Soldiers', 'Scientists', 'Workers'];
	
if (isNil "_targetPos") then { _targetPos = selectRandom (missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [_centre getPos [50, random 360]] ]) };

_targetPos = _targetPos findEmptyPosition [1, 50, "C_Truck_02_covered_F"];
	
// Create Truck
_truckType = selectRandom ["C_Truck_02_covered_F", "C_Truck_02_transport_F", "I_G_Van_01_transport_F";
_truck = _truckType createVehicle _targetPos;

missionNamespace setVariable [format["ZMM_%1_VEH", _zoneID], _truck, true];

// Apply colour variation
switch _truckType do {
	case "C_Truck_02_covered_F": { [_truck, ["BlueBlue", 0.25, "BlueOlive", 0.25, "OrangeOlive", 0.25]] call BIS_fnc_initVehicle };
	case "C_Truck_02_transport_F": { [_truck, ["Blue", 0.5]] call BIS_fnc_initVehicle };
};

// Create Driver
_enemyGrp = createGroup [_enemySide, true];
_driver = _enemyGrp createUnit [selectRandom (missionNamespace getVariable format["ZMM_%1Man", _enemySide]), [0,0,0], [], 0, "NONE"];
[_driver] joinSilent _enemyGrp; 
_driver moveInDriver _truck;
[group _driver, getPos _driver, 200] call bis_fnc_taskPatrol;

_truck lockDriver true;
_truck lock true;
_truck setVariable ["var_zoneID", _zoneID, true];

[_truck,  
	format["<t color='#72E500'>Unlock %1</t>", getText (configFile >> "CfgVehicles" >> _truckType >> "displayName")],  
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",  
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",  
	"_this distance _target < 4 && locked _target >= 1",  
	"_caller distance _target < 4 && locked _target >= 1",  
	{},  
	{},  
	{
		_varName = format["ZMM_%1_UNLOCK", (_target getVariable ["var_zoneID", 0])];
		missionNamespace setVariable [_varName, true, true];
		[_target, {{ _x enableAI "ALL"; unassignVehicle _x; _x setSpeedMode "FULL"; _x spawn { sleep (120 + random 120); deleteVehicle _this; } } forEach (crew _this)}] remoteExec ["bis_fnc_spawn", _target]; 
		[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
	},   
	{},   
	[],   
	3,   
	10] remoteExec ["bis_fnc_holdActionAdd", 0, _truck];


// Get carrying capacity
_prisMax = getNumber (configFile >> "CfgVehicles" >> _truckType >> "transportSoldier");
_prisGrp = createGroup [civilian, true];
_prisGrp enableDynamicSimulation true;
_prisGrp enableAttack false;

for "_i" from 1 to _prisMax do {	
	//_tempMan = createAgent ["C_man_w_worker_F", [0,0,0], [], 0, "NONE"];
	_tempMan = _prisGrp createUnit ["C_man_w_worker_F", [0,0,0], [], 0, "NONE"];
	_tempMan DisableAI "ALL";
	_tempMan setBehaviour "CARELESS";
	_tempMan allowCrewInImmobile true;
	_tempMan assignAsCargo _truck;
	_tempMan moveInCargo _truck;
	
	// Select Uniform
	_newU = ""; _newH = ""; _newG = ""; _newV = "";
	
	switch (_prisonerType) do {
		case "Soldiers": { 
			_newU = selectRandom ["U_I_G_Story_Protagonist_F","U_B_CombatUniform_mcam_tshirt","U_B_CombatUniform_mcam"];
			_newH = selectRandom ["H_Booniehat_khk","H_Booniehat_mcamo","H_HeadBandage_stained_F","H_HeadBandage_bloody_F","H_Cap_tan_specops_US","H_Bandanna_mcamo","H_Bandanna_khk",""];
			_newG = selectRandom ["G_Bandanna_blk","","G_Bandanna_khk","","G_Bandanna_oli","",""];
		};
		case "Rebels": { 
			_newU = selectRandom ["U_BG_Guerrilla_6_1","U_BG_Guerilla1_2_F","U_BG_Guerilla1_1","U_BG_leader","U_I_C_Soldier_Para_3_F","U_I_C_Soldier_Para_5_F"]; 
			_newH = selectRandom ["H_Shemag_olive","H_HeadBandage_stained_F","H_ShemagOpen_tan","","H_HeadBandage_bloody_F","",""];
			_newV = selectRandom ["V_BandollierB_blk","","V_BandollierB_rgr","","V_BandollierB_oli",""];
		};
		case "Scientists": {
			_newU = "U_C_Scientist";
			_newH = selectRandom ["H_Cap_White_IDAP_F","H_Construction_basic_orange_F","H_Construction_basic_white_F","H_Construction_basic_red_F","H_Construction_basic_yellow_F","H_HeadBandage_stained_F","H_HeadBandage_bloody_F",""];
			_newG = selectRandom ["G_Respirator_white_F","G_Respirator_blue_F","G_Respirator_yellow_F","G_EyeProtectors_F",""];
		};
		case "Workers": { 
			_newU = "U_C_WorkerCoveralls";
			_newH = selectRandom ["H_Cap_White_IDAP_F","H_Construction_basic_orange_F","H_Construction_basic_white_F","H_Construction_basic_red_F","H_Construction_basic_yellow_F","H_HeadBandage_stained_F","H_HeadBandage_bloody_F",""];
			_newG = selectRandom ["G_Respirator_white_F","G_Respirator_blue_F","G_Respirator_yellow_F","G_EyeProtectors_F",""];
			_newV = selectRandom ["V_Safety_orange_F","V_Safety_blue_F","V_Safety_yellow_F",""];
		};
		default {
			_newU = selectRandom ["U_IG_Guerilla2_1","U_IG_Guerilla2_2","U_IG_Guerilla2_3","U_C_Poor_1","U_BG_Guerilla3_1","U_C_Mechanic_01_F","U_C_Man_casual_4_F","U_C_Man_casual_5_F","U_C_Man_casual_6_F"];
			_newH = selectRandom ["","","H_HeadBandage_stained_F","","","H_HeadBandage_bloody_F","",""];
		};
	};
	
	// Apply Uniform
	if (_newU != "") then { _tempMan forceAddUniform _newU } else { removeUniform _tempMan };
	if (_newH != "") then { _tempMan addHeadgear _newH } else { removeHeadgear _tempMan };
	if (_newG != "") then { _tempMan addGoggles _newG } else { removeGoggles _tempMan };
	if (_newV != "") then { _tempMan addVest _newV } else { removeVest _tempMan };
	//missionNamespace setVariable [format["ZMM_%1_HVT_%2", _zoneID, _i], _tempMan];
};

// Create Failure Trigger
_failTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_failTrigger setTriggerStatements [ 	format["!alive ZMM_%1_VEH", _zoneID], 
									format["['ZMM_%1_TSK', 'Failed', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, "Grey"],
									"" ];


// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerStatements [ 	format["ZMM_%1_UNLOCK", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];
									
// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, _prisMax, _prisonerType] + format["<br/><br/>Model: <font color='#FFA500'>%1</font><br/>Registration: <font color='#FFA500'>%2</font><br/><img width='350' image='%3'/>", getText (configFile >> "CfgVehicles" >> _truckType >> "displayName"), getPlateNumber _truck, getText (configFile >> "CfgVehicles" >> _truckType >> "editorPreview")], ["Rescue"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "AUTOASSIGNED", 1, FALSE, TRUE, "truck"] call BIS_fnc_setTask;

TRUE
