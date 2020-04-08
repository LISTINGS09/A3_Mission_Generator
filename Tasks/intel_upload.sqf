// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];
_locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];

_missionDesc = [
		"We have tracked a leak of %2, to a crashed <font color='#00FFFF'>%1</font> at this location, upload the data to our network.",
		"A <font color='#00FFFF'>%1</font> crashed containing %2. Locate it and upload the data to your PDA, erasing the vehicles memory banks.",
		"We've picked up a signal indicating a <font color='#00FFFF'>%1</font> was forced to land, it contains %2, upload the data to an overhead satellite.",
		"The enemy have located a <font color='#00FFFF'>%1</font> containing %2. Upload the data to a secure location before it can be accessed by the enemy.",
		"Locate the <font color='#00FFFF'>%1</font> somewhere in the area and upload %2 found on it to our network.",
		"A <font color='#00FFFF'>%1</font> has crashed somewhere nearby, locate it and upload %2 from it to your PDA."
	];

private _bldPos = [];
{ _bldPos append (_x buildingPos -1) } forEach _buildings;
	
private _dataType = selectRandom ["B_UAV_02_dynamicLoadout_F","B_UAV_05_F","B_UGV_01_F","O_UAV_02_dynamicLoadout_F","Land_Wreck_Heli_Attack_01_F"];
private _dataPos = [0,0,0];
private _dataObj = objNull;

if (random 100 > 50 && count _bldPos > 0) then {
	_dataType = "Land_DataTerminal_01_F";
	_dataObj = _dataType createVehicle [0,0,0];
	_dataPos = selectRandom _bldPos;
	_dataObj setPosATL _dataPos;
	
	// Add Action to open Terminal.
	[_dataObj, 
	"<t color='#00FF80'>Open Terminal</t>", 
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa",  
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa",  
	"!(_target getVariable ['var_canUse', FALSE]) && _this distance _target < 3", 
	"!(_target getVariable ['var_canUse', FALSE]) && _caller distance _target < 3", 
	{}, 
	{}, 
	{
		[_target,3] remoteExec ["BIS_fnc_dataTerminalAnimate",_target]; 
		_target setVariable ["var_canUse", TRUE, TRUE];
		[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
	}, 
	{}, 
	[], 
	1, 
	10 
	] remoteExec ["bis_fnc_holdActionAdd"];
} else {
	_dataPos = if (count _locations > 0) then { selectRandom _locations } else { [_centre, 100 + random 150, random 360] call BIS_fnc_relPos };
	_dataPos = [_dataPos, 1, 250, 1, 0, 0.5, 0, [], [ _dataPos, _dataPos ]] call BIS_fnc_findSafePos;
	_dataPos = _dataPos findEmptyPosition [1, 25, _dataType];
	
	_dataObj = _dataType createVehicle [0,0,0];
	_dataObj setPos _dataPos;
	_dataObj setDir random 360;
	_dataObj lock TRUE;
	_dataObj setVehicleAmmo 0;
	_dataObj setVectorUp surfaceNormal position _dataObj;
	_dataObj setVariable ['var_canUse', TRUE, TRUE]; // Isn't a terminal.
	_dataObj setDamage 0.25;
	_dataObj allowDamage false;
	
	private _crater = createSimpleObject ["Crater", getPosASL _dataObj];
	private _debirs = createSimpleObject ["Land_Garbage_square5_F", getPosASL _dataObj];
	
	private _smokeObj = createVehicle ["test_EmptyObjectForSmoke",[0,0,0], [], 0, "CAN_COLLIDE"];
	_smokeObj attachTo [_dataObj, [0,0,0]];
};

_dataObj allowDamage FALSE;
_dataName = [getText (configFile >> "CfgVehicles" >> _dataType >> "displayName"),"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- "] call BIS_fnc_filterString;
_dataHeading = selecTRandom [
		format["%1 Data", selectRandom ["Weapon", "Radio", "Flight", "Mapping", "Survey", "NBC", "Target", "Account"]],
		format["%1 Locations", selectRandom ["Intel", "Camp", "POW", "Minefield", "HVT", "Storage", "Bunker", "GOAT", "Testing"]],
		format["a list of %1", selectRandom ["Prisoners", "Informants", "Stockpiles", "Assets", "Codes", "Target", "Recipes"]]
	];

[_dataObj, 
	"<t color='#00FF80'>Start Transmission</t>", 
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa",  
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
	"_target getVariable ['var_canUse', FALSE] && !(_target getVariable ['var_isSending', FALSE]) && _this distance _target < 3", 
	"_target getVariable ['var_canUse', FALSE] && !(_target getVariable ['var_isSending', FALSE]) && _caller distance _target < 3", 
	{}, 
	{ parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\upload_ca.paa'/><br/><br/><t size='1.5'>Initiating</t><br/><br/><t size='1.5' color='#FFFF00'>Synchronising</t><br/><t color='#FFFF00'></t><br/><br/><t size='1.75' color='#CCCCCC'>%1&#37;</t><br/><br/>", (round ((_this select 4) * 4.16))] remoteExec ["hintSilent"]}, 
	{ 
		_target setVariable ["var_isSending", TRUE, TRUE]; 
		_target setVariable ["var_packetNo", (_target getVariable ["var_packetNo", 0]) + 1, TRUE]; 

		_packetMax = 4; 

		if ((_target getVariable "var_packetNo") <= _packetMax) then { 
		   _percent = 0; 
		   _max = 30; 
		   for "_i" from 0 to _max do { 
				parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\upload_ca.paa'/><br/><br/><t size='1.5'>Uploading</t><br/><br/><t size='1.5' color='#FFFF00'>Packet %1/%2</t><br/><t color='#FFFF00'></t><br/><br/><t size='1.75' color='#CCCCCC'>%3&#37;</t><br/><br/>", _target getVariable "var_packetNo", _packetMax, round ((_percent / _max) * 100)] remoteExec ["hintSilent"]; 
				_percent = _percent + 1; 
				sleep 1; 
		   }; 
			
		   parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\upload_ca.paa'/><br/><br/><t size='1.5'>Uploaded</t><br/><br/><t size='1.5' color='#FFFF00'>Packet %1/%2</t><br/><t color='#FFFF00'></t><br/><br/><t size='1.5' color='#CCCCCC'>Waiting for Action</t><br/><br/>", _target getVariable "var_packetNo", _packetMax] remoteExec ["hintSilent"]; 
		   _target setVariable ["var_isSending", FALSE, TRUE]; 
		} else { 
			parseText "<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\upload_ca.paa'/><br/><br/><t size='1.5'>Upload</t><br/><br/><t size='1.5' color='#00CD00'>Complete</t><br/><t color='#00CD00'></t><br/><br/><t size='1.5' color='#CCCCCC'>Shutting Down</t><br/><br/>" remoteExec ["hintSilent"]; 
			_target setVariable ["var_dataSent", TRUE, TRUE]; 
			[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
			sleep 1; 
			[_target, 0] remoteExec ["BIS_fnc_dataTerminalAnimate", _target]; 
		}; 
		sleep 5; 
		"" remoteExec ["hintSilent"]; 
		}, 
	{ parseText "<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\upload_ca.paa'/><br/><br/><t size='1.5'>Upload</t><br/><br/><t size='1.5' color='#FF0000'>Cancelled</t><br/><br/><br/><br/><br/>" remoteExec ["hintSilent"]; }, 
	[], 
	15, 
	10, 
	FALSE 
] remoteExec ["bis_fnc_holdActionAdd"];

missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _dataObj];

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerStatements [ 	format["(ZMM_%1_OBJ getVariable ['var_dataSent', FALSE])", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _dataName, _dataHeading], ["Upload"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "upload"] call BIS_fnc_setTask;

TRUE