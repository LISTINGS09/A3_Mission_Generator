// Set-up mission variables.
params [ ["_zoneID", 0], ["_tskPos", [0,0,0]] ];

_tskCentre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _tskPos];
_tskRadius = ((getMarkerSize format["MKR_Z%1_MIN", _zoneID])#0) max 100; // Area of Zone.

_tskDesc = [
		"A cargo transport flying over the area is due to make a drop, search the area for nearby for one <font color='#00FFFF'>%1</font> and mark its location.",
		"An enemy air transport is due to fly through this area, locate one <font color='#00FFFF'>%1</font> and upload the coordinates of its location.",
		"One <font color='#00FFFF'>%1</font> is due to be dropped into the area, locate it and upload the coordinates.",
		"Search for one <font color='#00FFFF'>%1</font>, due to be dropped into this area.",
		"An air transport carrying supplies will be dropping one <font color='#00FFFF'>%1</font> into this area, locate it and upload the coordinates of its landing point.",
		"A transport has been spotted near this location. It is due to drop one <font color='#00FFFF'>%1</font> locate it and upload its location to allied forces."
	];	

// TODO: Support Objective Counts

// Create Objective
private _dropPos = [_tskCentre getPos [random 100, random 360], 1, _tskRadius, 1, 0, 0.5, 0, [], [ _tskCentre, _tskCentre ]] call BIS_fnc_findSafePos;
_dropType = selectRandom ["CargoNet_01_barrels_F","CargoNet_01_box_F","I_CargoNet_01_ammo_F","O_CargoNet_01_ammo_F","C_IDAP_CargoNet_01_supplies_F","B_CargoNet_01_ammo_F"];
_dropName = [getText (configFile >> "CfgVehicles" >> _dropType >> "displayName"),"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- "] call BIS_fnc_filterString;

private _dropObj = createVehicle [_dropType, [0,0,0], [], 0, "NONE"];
_dropObj allowDamage false; 

clearMagazineCargoGlobal _dropObj;
clearWeaponCargoGlobal _dropObj; 
clearItemCargoGlobal _dropObj;
clearBackpackCargoGlobal _dropObj;

private _lightObj = "PortableHelipadLight_01_white_F" createVehicle [0,0,0];
_lightObj attachTo [_dropObj,[0, 0, ((boundingBoxReal _dropObj) select 1) select 2]];

// Add Action to upload coordinates.
[_dropObj, 
	"<t color='#00FF80'>Upload Drop Position</t>", 
	"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_connect_ca.paa",  
	"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_connect_ca.paa",  
	"(_target getVariable ['var_canUse', true])", 
	"(_target getVariable ['var_canUse', true])", 
	{}, 
	{}, 
	{
		_target setVariable ["var_canUse", false, true]; 
		[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
	}, 
	{}, 
	[], 
	1, 
	10 
] remoteExec ["bis_fnc_holdActionAdd", 0, _dropObj];

missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _dropObj];

// Create Drop Trigger
_dropTrigger = createTrigger ["EmptyDetector", _tskCentre, false];
_dropTrigger setTriggerArea [_tskRadius, _tskRadius, 0, false];
_dropTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_dropTrigger setTriggerStatements ["this", 
	 format["ZMM_%1_OBJ setPos [%2, %3, 250]; [objNull, ZMM_%1_OBJ] call BIS_fnc_curatorobjectedited; playSound3D ['A3\Sounds_F\environment\ambient\battlefield\battlefield_jet1.wss', objNull, false, AGLToASL [%2, %3, 0], 2, 1, 1000]; _nul = [] spawn { waitUntil { sleep 5; playSound3D ['a3\sounds_f\sfx\beep_target.wss', ZMM_%1_OBJ, false, getPosASL ZMM_%1_OBJ, 1, 0.5, 75]; !(ZMM_%1_OBJ getVariable ['var_canUse', true]); }; };", _zoneID, _dropPos select 0, _dropPos select 1],
	 ""];

// Create Completion Trigger
_tskTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_tskTrigger setTriggerStatements [  format["!(ZMM_%1_OBJ getVariable ['var_canUse', true])", _zoneID], 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_Z%1_LOC','MKR_Z%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _tskTrigger, true];
[_tskTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _tskTrigger];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _tskDesc, _dropName] + format["<br/><br/><img width='350' image='%1'/>", getText (configFile >> "CfgVehicles" >> _dropType >> "editorPreview")], ["Drop"] call zmm_fnc_nameGen, format["MKR_Z%1_LOC", _zoneID]], _tskCentre, "CREATED", 1, false, true, "airdrop"] call BIS_fnc_setTask;

true