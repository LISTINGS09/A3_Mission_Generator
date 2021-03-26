// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
private _buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];
private _enemyTeam = selectRandom (missionNamespace getVariable[format["ZMM_%1Grp_Sentry",_enemySide],[""]]); // CfgGroups entry.

private _missionDesc = [
		"We have tracked a leak of %2 to a <font color='#00FFFF'>%1</font> at this location, find it and %3 the data.",
		"A <font color='#00FFFF'>%1</font> containing %2 has been located. Find it and %3 the data from it.",
		"We've picked up a signal indicating a <font color='#00FFFF'>%1</font> is in the area. It contains %2 and is vital it is recovered; locate it and %3 the data.",
		"The enemy have located a <font color='#00FFFF'>%1</font> that is carrying %2. Find it and %3 the data from it before it can be accessed by the enemy.",
		"Locate the <font color='#00FFFF'>%1</font> which details %2 and %3 the information from it.",
		"A <font color='#00FFFF'>%1</font> has been spotted in this area, find it and %3 %2 from it."
	];
	
private _dataName = selectRandom ["download","upload"];

private _bldPos = [];
{ _bldPos append (_x buildingPos -1) } forEach _buildings;
	
private _dataType = "Land_DataTerminal_01_F";
private _dataPos = [0,0,0];
private _dataObj = objNull;
private _inBuilding = false;

if (random 100 > 50 && count _bldPos > 0) then {
	_dataObj = _dataType createVehicle [0,0,0];
	_dataPos = selectRandom _bldPos;
	_dataObj setPosATL _dataPos;	
	_inBuilding = true;
} else {
	_dataType = selectRandom ["B_UAV_02_dynamicLoadout_F", "B_UAV_05_F", "B_UGV_01_F", "O_UAV_02_dynamicLoadout_F"];
	
	if (count _locations > 0) then { 
		_dataPos = selectRandom _locations;
	} else { 
		_dataPos = [[_centre, 100 + random 150, random 360] call BIS_fnc_relPos, 1, 150, 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos 
	};

	_dataObj = createVehicle [_dataType, _dataPos, [], 5, "NONE"];
	_dataObj setDir random 360;
	_dataObj lock true;
	_dataObj setVehicleAmmo 0;
	_dataObj enableSimulationGlobal false;
	_dataObj allowDamage false;
	_dataObj setDamage [0.6,false];
	removeFromRemainsCollector [_dataObj];
	
	if (_dataType in ["B_UGV_01_F"]) then {
		private _crater = createSimpleObject ["Crater", getPosASL _dataObj];
		private _debirs = createSimpleObject ["Land_Garbage_square5_F", getPosASL _dataObj];
	} else {
		_dataObj setPos ((getPos _dataObj) vectorAdd [0,0,-1]);
		_dataObj setVectorDirAndUp [[-0.33,0.66,-0.33], [-0.33,0.13,0.66]];
		
		_dataPos = getPos _dataObj;
		_dataPos set [2,0];
		
		private _crater = createSimpleObject ["CraterLong", ATLToASL _dataPos];
		_crater setDir getDir _dataObj;
		_crater setVectorUp surfaceNormal position _crater;
	};
	
	//private _smokeObj = createVehicle ["test_EmptyObjectForSmoke", _dataPos, [], 0, "CAN_COLLIDE"];
};

_dataHeading = selecTRandom [
		format["%1 Data", selectRandom ["Weapon", "Radio", "Flight", "Mapping", "Survey", "NBC", "Target", "Account"]],
		format["%1 Locations", selectRandom ["Intel", "Camp", "POW", "Minefield", "HVT", "Storage", "Bunker", "Munition", "Testing"]],
		format["a list of %1", selectRandom ["Prisoners", "Informants", "Stockpiles", "Assets", "Codes", "Target", "Recipes"]]
	];

_dataObj setVariable ["var_dataType", _dataHeading, true];
_dataObj setVariable ["var_zoneID", _zoneID, true];

[_dataObj, 
	"<t color='#00FF80'>Start Transmission</t>", 
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa",  
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
	"!(_target getVariable ['var_dataSent', false]) && !(_target getVariable ['var_isSending', false]) && _this distance2d _target < 3", 
	"!(_target getVariable ['var_dataSent', false]) && !(_target getVariable ['var_isSending', false]) && _caller distance2d _target < 3", 
	{}, 
	{ parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\%1_ca.paa'/><br/><br/><t size='1.5'>Initiating</t><br/><br/><t size='1.5' color='#FFFF00'>Synchronising</t><br/><t color='#FFFF00'></t><br/><br/><t size='1.75' color='#CCCCCC'>%2&#37;</t><br/><br/>", _dataName, (round ((_this select 4) * 4.16))] remoteExec ["hintSilent"]}, 
	{ 
		_target setVariable ["var_isSending", true, true]; 
		_target setVariable ["var_packetNo", (_target getVariable ["var_packetNo", 0]) + 1, true]; 
		private _packetMax = 5; 

		if ((_target getVariable "var_packetNo") <= _packetMax) then { 
		   private _percent = 0; 
		   private _max = 60; 
		   for "_i" from 0 to _max do { 
				parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\%1_ca.paa'/><br/><br/><t size='1.5'>Sending</t><br/><br/><t size='1.5' color='#FFFF00'>Packet %2/%3</t><br/><t color='#FFFF00'></t><br/><br/><t size='1.75' color='#CCCCCC'>%4&#37;</t><br/><br/>", _dataName, _target getVariable "var_packetNo", _packetMax, round ((_percent / _max) * 100)] remoteExec ["hintSilent"]; 
				_percent = _percent + 1; 
				uiSleep 1; 
		   }; 
			
		   parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\%1_ca.paa'/><br/><br/><t size='1.5'>Sent</t><br/><br/><t size='1.5' color='#FFFF00'>Packet %2/%3</t><br/><t color='#FFFF00'></t><br/><br/><t size='1.5' color='#CCCCCC'>Waiting for Action</t><br/><br/>", _dataName, _target getVariable "var_packetNo", _packetMax] remoteExec ["hintSilent"]; 
		   _target setVariable ["var_isSending", false, true]; 
		} else { 
			parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\%1_ca.paa'/><br/><br/><t size='1.5'>Sending</t><br/><br/><t size='1.5' color='#00CD00'>Complete</t><br/><t color='#00CD00'></t><br/><br/><t size='1.5' color='#CCCCCC'>Shutting Down</t><br/><br/>", _dataName] remoteExec ["hintSilent"]; 
			_target setVariable ["var_dataSent", true, true]; 
			[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
			uiSleep 1; 
			[_target, 0] remoteExec ["BIS_fnc_dataTerminalAnimate", _target]; 
		}; 
		uiSleep 5; 
		"" remoteExec ["hintSilent"]; 
		}, 
	{ parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\%1_ca.paa'/><br/><br/><t size='1.5'>Sending</t><br/><br/><t size='1.5' color='#FF0000'>Cancelled</t><br/><br/><br/><br/><br/>", _dataName] remoteExec ["hintSilent"]; }, 
	[], 
	30, 
	10,
	false
] remoteExec ["bis_fnc_holdActionAdd", 0, _dataObj];

missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _dataObj];

// Create enemy guards if valid group
if !(_enemyTeam isEqualTo "") then {
	// Create enemy Team
	private _milGroup = [_dataPos getPos [random 10, random 360], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
		
	private _bldArr = if (_inBuilding) then { (nearestBuilding _dataPos) buildingPos -1 } else { [] };
	_bldArr deleteAt (_bldArr find _dataPos);
	
	{
		if (count _bldArr > 0) then {
			private _tempPos = selectRandom _bldArr;
			_bldArr deleteAt (_bldArr find _tempPos);
			_x setPosATL _tempPos;
			_x disableAI "PATH";
		} else {
			_x setPos (_dataPos getPos [random 10, random 360]);
			_x setUnitPos "MIDDLE";
		};
	} forEach units _milGroup;

	{ _x addCuratorEditableObjects [[_dataObj] + units _milGroup, true] } forEach allCurators;
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [ 	format["(ZMM_%1_OBJ getVariable ['var_dataSent', false])", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Failure Trigger
/*_faiTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_faiTrigger setTriggerStatements [ 	format["!alive ZMM_%1_OBJ", _zoneID], 
									format["['ZMM_%1_TSK', 'Failed', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, "Grey"],
									"" ];
*/

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, getText (configFile >> "CfgVehicles" >> _dataType >> "displayName"), _dataHeading, _dataName], [toUpper _dataName] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, _dataName] call BIS_fnc_setTask;

true