// v1.0
// Disable an enemy prisoner transport and unlock it so the cargo can escape.
params [ ["_zoneID", 0], ["_tskPos", [0,0,0]] ];

private _tskCentre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _tskPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyMen = missionNamespace getVariable [format["ZMM_%1_Man", _enemySide], ["O_Soldier_F"]];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];

private _tskDesc = selectRandom [
		"A group of %3 have been captured by enemy forces near %1 and are being transported to a prison camp. Locate the unarmed transport, disable the vehicle and free the <font color='#00FFFF'>%2 %3</font>.",
		"An unarmed transport carrying <font color='#00FFFF'>%2 %3</font> captured by enemy forces will be passing through %1 shortly. Ambush the vehicle, disable it and free the %3 from the vehicle.",
		"A transport carrying captive %3 has been located near %1. Disable the vehicle and free the <font color='#00FFFF'>%2 %3</font> aboard.",
		"Track down and free <font color='#00FFFF'>%2 %3</font> that are being transported near %1.",
		"Enemy forces have captured and are trying to transport <font color='#00FFFF'>%2 %3</font> through %1. Locate the truck and free the %3 from captivity.",
		"A number of %3 have been rounded up by enemy forces somewhere in %1. Locate the truck transporting them and free <font color='#00FFFF'>%2 %3</font>."
	];	

private _prisonerType = selectRandom ['Civilians', 'POWs', 'Prisoners', 'Dissidents', 'Rebels', 'Soldiers', 'Scientists', 'Workers'];
	
if (_tskCentre isEqualTo _tskPos || _tskPos isEqualTo [0,0,0]) then { _tskPos = [_tskCentre, 25, 200, 5, 0, 0.5, 0, [], [ _tskCentre, _tskCentre ]] call BIS_fnc_findSafePos };
if (isNil "_tskPos") then { _tskPos = _tskCentre };

private _vehPos = _tskPos findEmptyPosition [1, 100, "C_Truck_02_covered_F"];

// No empty positions at all
if (_vehPos isEqualTo []) then { _vehPos = _tskPos };
	
// Create Truck
private _vehType = selectRandom ["C_Truck_02_covered_F", "C_Truck_02_transport_F"];
private _tskVeh = createVehicle [_vehType, _vehPos, [], 0, "NONE"];
private _vehName = getText (configFile >> "CfgVehicles" >> _vehType >> "displayName");
private _vehImg = getText (configFile >> "CfgVehicles" >> _vehType >> "editorPreview");

missionNamespace setVariable [format["ZMM_%1_VEH", _zoneID], _tskVeh, true];

// Apply colour variation
switch _vehType do {
	case "C_Truck_02_covered_F": { [_tskVeh, ["BlueBlue", 0.25, "BlueOlive", 0.25, "OrangeOlive", 0.25]] call BIS_fnc_initVehicle };
	case "C_Truck_02_transport_F": { [_tskVeh, ["Blue", 0.5]] call BIS_fnc_initVehicle };
};

// Create Driver
private _enemyGrp = createGroup [_enemySide, true];
private _driver = _enemyGrp createUnit [selectRandom _enemyMen, [0,0,0], [], 0, "NONE"];
[_driver] joinSilent _enemyGrp; 
_driver moveInDriver _tskVeh;
[group _driver, getPos _driver, 50] call bis_fnc_taskPatrol;

_tskVeh lockDriver true;
_tskVeh lock 1;
_tskVeh setVariable ["var_zoneID", _zoneID, true];

zmm_fnc_releasePrisoners = {
	params ["_truck"];

	_truck lock 0;

	{
		unassignVehicle _x;
		moveOut _x;

		_x setSpeedMode "FULL";
		_x setDestination [_x getPos [500, random 360], "LEADER PLANNED", true];

		[_x] spawn {
			params ["_unit"];
			sleep (120 + random 120);
			deleteVehicle _unit;
		};

		sleep (1 + random 2);
	} forEach ((crew _truck) select {alive _x});
};

[_tskVeh,  
	format["<t color='#72E500'>Unlock %1</t>", _vehName],  
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",  
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",  
	"_this distance2d _target < 4 && locked _target >= 1",  
	"_caller distance2d _target < 4 && locked _target >= 1",  
	{},  
	{},  
	{
		[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
		private _zoneID = _target getVariable ["var_zoneID", 0];
		missionNamespace setVariable [format["ZMM_%1_UNLOCK", _zoneID], true, true];
		[_target] remoteExec ["zmm_fnc_releasePrisoners", _target];
	},   
	{},   
	[],   
	3,   
	10] remoteExec ["bis_fnc_holdActionAdd", 0, _tskVeh];

// Add to Zeus
{ _x addCuratorEditableObjects [[_tskVeh], true] } forEach allCurators;

// Get carrying capacity
private _prisMax = getNumber (configFile >> "CfgVehicles" >> _vehType >> "transportSoldier");

for "_i" from 1 to _prisMax do {

	private _civGrp = createGroup civilian;
	_civGrp setGroupIdGlobal [format["ZMM_OBJ%1_CIV%2", _zoneID, _i]];
	private _tempMan = _civGrp ["C_man_w_worker_F", [0,0,0], [], 150, "NONE"];
	_tempMan setVariable ["BIS_fnc_animalBehaviour_disable", true];
	_tempMan assignAsCargo _tskVeh;
	_tempMan moveInCargo _tskVeh;
	
	// Select Uniform
	[] params [["_newU",""],["_newH",""],["_newG",""],["_newV",""]];
	
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
};

// Create Completion Trigger
_tskTrigger = createTrigger ["EmptyDetector", _tskCentre, false];
_tskTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_tskTrigger setTriggerStatements [ 	format["!alive ZMM_%1_VEH || missionNamespace getVariable ['ZMM_%1_UNLOCK',false]", _zoneID], 
	format["['ZMM_%1_TSK', if (%3) then { 'Failed' } else { 'Succeeded' }, true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_Z%1_LOC','MKR_Z%1_MIN']", _zoneID, ZMM_playerSide, format["!alive ZMM_%1_VEH",_zoneID]],
	"" ];
	
missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _tskTrigger, true];
[_tskTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _tskTrigger];
									
// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_tskDesc, _locName, _prisMax, _prisonerType] + format["<br/><br/>Model: <font color='#FFA500'>%1</font><br/>Registration: <font color='#FFA500'>%2</font><br/><img width='350' image='%3'/>", _vehName, getPlateNumber _tskVeh, _vehImg], ["Rescue"] call zmm_fnc_nameGen, format["MKR_Z%1_LOC", _zoneID]], _tskCentre, "CREATED", 1, false, true, "truck"] call BIS_fnc_setTask;

true
