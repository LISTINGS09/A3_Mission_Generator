// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = [
		"Enemy forces are trying to filter though <font color='#00FFFF'>%1</font>. Assist the civilian with repairs and defend the vehicle, before extracting it from the area.",
		"A number of enemy groups are advancing towards <font color='#00FFFF'>%1</font>. Help with the repairing of the vehicle and hold the location until the vehicle has been repaired and it can be driven away.",
		"Eliminate all enemy forces heading into <font color='#00FFFF'>%1</font>. Enemy forces may already be present, secure and assist with the repairs of a disabled vehicle. When repaired, drive it from the location.",
		"Enemy forces have launched an attack on <font color='#00FFFF'>%1</font>. Eliminate any contact already present in %1, then begin repairs on a stranded vehicle before driving it away when repaired.",
		"The enemy is trying to occupy <font color='#00FFFF'>%1</font>. Clean out any forces already present at %1, while preventing enemy reinforcements from destroying a damaged vehicle there. Assist with repairs before withdrawing with the fixed vehicle.",
		"Enemy forces are planning to invade <font color='#00FFFF'>%1</font>. Eliminate any enemy forces already present, then defend and assist with repairing a vehicle until fully working. You should then extract with the vehicle."
	];
	
if (_centre isEqualTo _targetPos || _targetPos isEqualTo [0,0,0]) then { _targetPos = [_centre, 25, 200, 5, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos; _targetPos set [2,0]; missionNamespace setVariable [format["ZMM_%1_Location", _zoneID], _targetPos]; };
 
if (count (missionNamespace getVariable [ format["ZMM_%1_QRFLocations", _zoneID], []]) == 0) then { 
	private _QRFLocs = [];
	private _qrfDist = if ((_radius * 3) < 1000) then { 1500 } else { (_radius * 3) min 2000 };

	for [{_i = 0}, {_i <= 360}, {_i = _i + 5}] do {
		private _roads = ((_centre getPos [_qrfDist, _i]) nearRoads 150) select {count (roadsConnectedTo _x) > 0};
		private _tempPos = [];	
		
		_tempPos = if (count _roads > 0) then { getPos (_roads#0) } else { (_centre getPos [_qrfDist, _i]) isFlatEmpty  [15, -1, -1, -1, -1, false] };
		
		if !(_tempPos isEqualTo []) then {
			if ({_x distance2D _tempPos < 350} count _QRFLocs == 0) then {
				_QRFLocs pushBack _tempPos;
			};
		};
	};
	missionNamespace setVariable [ format["ZMM_%1_QRFLocations", _zoneID], _QRFLocs ]; // Set QRF Locations
};

// Overwrite depending on location
private _waves = 5;
private _delay = (missionNamespace getVariable [format[ "ZMM_%1_QRFTime", _zoneID ], 300]) max 200;

// Select vehicle type
selectRandom [
	["C_IDAP_Truck_02_transport_F", [[0,0,-0.15], [0,-2,-0.15]],["Land_PaperBox_01_small_stacked_F","Land_FoodSacks_01_cargo_white_idap_F","Land_FoodSacks_01_cargo_brown_F","Land_WaterBottle_01_stack_F"]],
	["C_Truck_02_transport_F", [[-0.3,-3,-0.1], [0.3,-2,-0.1], [-0.3,-1,-0.1], [0.3,0,-0.1]], ["Land_GarbageBarrel_02_F"]],
	["C_Van_01_transport_F", [[0,-1,0.3], [0,-2.5,0.3]], ["Land_WoodenCrate_01_stack_x5_F","Land_WoodenCrate_01_stack_x3_F"]],
	["C_Truck_02_covered_F", [[0,-2.5,0]], ["Box_NATO_AmmoVeh_F","Box_EAF_AmmoVeh_F","Box_East_AmmoVeh_F","Box_IND_AmmoVeh_F","Land_CargoBox_V1_F"]]
	
] params ["_vehClass", "_objAtt", "_objArr"];

private _iconName = "Repair";
private _veh = createVehicle [_vehClass, _targetPos, [], 0, "NONE"];
_veh allowDamage false;
_veh setFuel 0;
_veh setPos (getPos _veh vectorAdd [0, 0, 3]);
_veh setVectorUp surfaceNormal position _veh;
_veh spawn {
	{ _x hideObjectGlobal true } forEach (nearestTerrainObjects [getPos _this, ["TREE", "SMALL TREE", "BUSH", "BUILDING", "HOUSE", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "CHURCH", "CHAPEL", "CROSS", "BUNKER", "FORTRESS", "FOUNTAIN", "VIEW-TOWER", "LIGHTHOUSE", "QUAY", "FUELSTATION", "HOSPITAL", "FENCE", "WALL", "HIDE", "BUSSTOP", "FOREST", "TRANSMITTER", "STACK", "RUIN", "TOURISM", "WATERTOWER", "ROCK", "ROCKS", "POWERSOLAR", "POWERWAVE", "POWERWIND", "SHIPWRECK"], 5]);
	sleep 5;
	_this lock true;
	_this allowDamage true;
	_this setDamage 0.5;
};
_veh setVariable ["var_zoneID", _zoneID];

missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _veh];

{
	private _tempObj = createSimpleObject [selectRandom _objArr,[0,0,0]];
	_tempObj attachTo [_veh, _x];
} forEach _objAtt;

[_veh, 
	"<t color='#00FF80'>Check Vehicle</t>", 
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
	"!(_target getVariable ['var_allDone', false]) && !(_target getVariable ['var_inProgress', false]) && _this distance2d _target < 5",
	"!(_target getVariable ['var_allDone', false]) && !(_target getVariable ['var_inProgress', false]) && _caller distance2d _target < 5",
	{}, 
	{ parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\%1_ca.paa'/><br/><br/><t size='1.5'>%4 (%5)</t><br/><br/><t size='1.5' color='#FFFF00'>Checking</t><br/>%3<br/><t color='#FFFF00'></t><br/><br/><t size='1.75' color='#CCCCCC'>%2&#37;</t><br/><br/>", "repair", (round ((_this select 4) * 4.16)), getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName"), if (_caller getUnitTrait "engineer") then { "Engineer" } else { "Non-Engineer" }, name _caller] remoteExec ["hintSilent"]}, 
	{ 
		_target setVariable ["var_inProgress", true, true]; 
		_target setVariable ["var_counter", (_target getVariable ["var_counter", 0]) + 1, true]; 
		private _zoneID = _target getVariable ["var_zoneID", 1]; 
		private _countMax = missionNamespace getVariable ["ZZM_ObjectiveCount", 4]; 
		private _repairMan = missionNamespace getVariable [format["ZMM_%1_MAN", _zoneID], objNull];

		if ((_target getVariable "var_counter") <= _countMax) then { 
			private _percent = 0; 
			private _max = if (_caller getUnitTrait "engineer") then { 240 } else { 300 }; 
			
			[_repairMan, selectRandom ["REPAIR_VEH_STAND", "REPAIR_VEH_KNEEL"], "ASIS"] remoteExecCall ["BIS_fnc_ambientAnim", _repairMan];
			
			for "_i" from 0 to _max do { 
				parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\%1_ca.paa'/><br/><br/><t size='1.5'>Repairing</t><br/>%5<br/><br/><t size='1.5' color='#FFFF00'>Part %2/%3</t><br/><t color='#FFFF00'></t><br/><br/><t size='1.75' color='#CCCCCC'>%4&#37;</t><br/><br/>", "repair", _target getVariable "var_counter", _countMax, round ((_percent / _max) * 100), getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName")] remoteExec ["hintSilent"]; 
				_percent = _percent + 1;
				uiSleep 1;
			};
			_repairMan remoteExecCall ["BIS_fnc_ambientAnim__terminate", _repairMan];
			_repairMan setUnitPos "MIDDLE";
			parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\%1_ca.paa'/><br/><br/><t size='1.5'>Repaired</t><br/>%4<br/><br/><t size='1.5' color='#FFFF00'>Part %2/%3</t><br/><t color='#FFFF00'></t><br/><br/><t size='1.5' color='#CCCCCC'>Waiting on Engineer</t><br/><br/>", "repair", _target getVariable "var_counter", _countMax, getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName")] remoteExec ["hintSilent"]; 
			_target setVariable ["var_inProgress", false, true]; 
		} else { 
			parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\%1_ca.paa'/><br/><br/><t size='1.5'>Checking</t><br/>%2<br/><br/><t size='1.5' color='#00CD00'>Complete</t><br/><t color='#00CD00'></t><br/><br/><t size='1.5' color='#CCCCCC'>Vehicle Ready!</t><br/><br/>", "repair", getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName")] remoteExec ["hintSilent"]; 
			_target setVariable ["var_allDone", true, true]; 
			[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
			_target setFuel 1;
			_target setDamage 0;
			_target engineOn true;
			_target lock false;
			
			[_repairMan, { if (!alive _this) exitWith {}; 
				[name _this,"Vehicle is repaired; it is all yours!"] remoteExec ["BIS_fnc_showSubtitle"];
				_this setUnitPos "UP";
				_this setSpeedMode "FULL";
				_this setDestination [(_this getPos [500, random 360]), "LEADER PLANNED", true]; sleep 120; deleteVehicle _this;
			} ] remoteExec ["BIS_fnc_spawn", _repairMan];
		}; 
		uiSleep 5; 
		"" remoteExec ["hintSilent"]; 
	}, 
	{ parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\%1_ca.paa'/><br/><br/><t size='1.5'>Checking</t><br/><br/><t size='1.5' color='#FF0000'>Cancelled</t><br/><br/><br/><br/><br/>", "repair"] remoteExec ["hintSilent"]; }, 
	[], 
	10, 
	10,
	false
] remoteExec ["bis_fnc_holdActionAdd", 0, _veh];

private _civObj = createAgent ["C_Man_UtilityWorker_01_F", _veh getPos [1.7, 90], [], 0, "NONE"];
_civObj setVariable ["BIS_fnc_animalBehaviour_disable", true];
_civObj setUnitPos "MIDDLE";
_civObj setDir (_civObj getRelDir _veh);
_civObj allowDamage false;

missionNamespace setVariable [format["ZMM_%1_MAN", _zoneID], _civObj];

// Create Information Trigger
private _qrfTrigger = createTrigger ["EmptyDetector", _targetPos, false];
_qrfTrigger setTriggerArea [100, 100, 0, false, 150];
_qrfTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_qrfTrigger setTriggerTimeout [240, 240, 240, true];
_qrfTrigger setTriggerStatements [ "this",
	format["_nul = [] spawn {  [ %2, false, %3, (%4 / 2), 5 ] spawn zmm_fnc_areaQRF; sleep 10; [ %2, false, %3, %4 ] spawn zmm_fnc_areaQRF; sleep 10; [ %2, false, %3, %4, 0] spawn zmm_fnc_areaQRF; }", 0, _zoneID, _delay, _waves],
	"" ];

// Add to Zeus
{ _x addCuratorEditableObjects [[_veh,_civObj], true] } forEach allCurators;

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _targetPos, false];
_objTrigger setTriggerActivation ["VEHICLE", "NOT PRESENT", false];
_objTrigger setTriggerArea [_radius, _radius, 0, true];
_objTrigger triggerAttachVehicle [_veh];
_objTrigger setTriggerStatements [ 	format["this && (alive ZMM_%1_OBJ || !alive ZMM_%1_OBJ)", _zoneID], 
	format["deleteVehicle ZMM_%1_MAN; ['ZMM_%1_TSK', if (!alive ZMM_%1_OBJ) then { 'Failed' } else { 'Succeeded' }, true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _objTrigger, true];
[_objTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _objTrigger];
									
// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[(selectRandom _missionDesc) + "<br/><br/>Target Vehicle: <font color='#00FFFF'>%2</font><br/><br/><img width='300' image='%3'/>", _locName, getText (configFile >> "CfgVehicles" >> _vehClass >> "displayName"), getText (configFile >> "CfgVehicles" >> _vehClass >> "editorPreview")], ["Repair"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _targetPos, "CREATED", 1, false, true, "defend"] call BIS_fnc_setTask;

true