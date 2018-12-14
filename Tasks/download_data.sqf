// Set-up mission variables.
params [ ["_zoneID", 0] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
_buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];

_missionDesc = [
		"We have tracked a leak of %2 to a <font color='#00FFFF'>%1</font> at this location, find it and download the data.",
		"A <font color='#00FFFF'>%1</font> containing %2 has been located. Find it and download the data from it.",
		"We've picked up a signal indicating a <font color='#00FFFF'>%1</font> is in the area. It contains %2 and is vital it is recovered; locate it and download the data.",
		"The enemy have located a <font color='#00FFFF'>%1</font> that is carrying %2. Download the data from it before it can be accessed by the enemy.",
		"Locate the <font color='#00FFFF'>%1</font> which details %2 and download the information from it.",
		"A <font color='#00FFFF'>%1</font> has been spotted in this area, find it and download %2 from it."
	];

_bldPos = [];
{ _bldPos append (_x buildingPos -1) } forEach _buildings;
	
_dataType = selectRandom ["B_UAV_02_dynamicLoadout_F", "B_UAV_05_F", "B_UGV_01_F", "O_UAV_02_dynamicLoadout_F"];
_dataPos = [0,0,0];

if (count _locations > 0) then { 
	_dataPos = selectRandom _locations;
} else { 
	_dataPos = [[_centre, 100 + random 150, random 360] call BIS_fnc_relPos, 1, 150, 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos 
};

_dataPos = _dataPos findEmptyPosition [1, 25, _dataType];
_dataObj = objNull;

if (random 100 > 50 && count _bldPos > 0) then {
	_dataType = "Land_DataTerminal_01_F";
	_dataObj = _dataType createVehicle [0,0,0];
	_dataPos = selectRandom _bldPos;
	_dataObj setPosATL _dataPos;
} else {
	_dataObj = _dataType createVehicle _dataPos;
	_dataObj setDir random 360;
	_dataObj setVectorUp surfaceNormal position _dataObj;
	_dataObj lock TRUE;
	_dataObj setVehicleAmmo 0;
	_dataObj setDamage 0.25;
	
	_smokeObj = createVehicle ["test_EmptyObjectForSmoke",[0,0,0], [], 0, "CAN_COLLIDE"];
	_smokeObj attachTo [_dataObj, [0,0,0]];
};

_dataHeading = selecTRandom [
		format["%1 Data", selectRandom ["Weapon", "Radio", "Flight", "Mapping", "Survey", "NBC", "Target", "Account"]],
		format["%1 Locations", selectRandom ["Intel", "Camp", "POW", "Minefield", "HVT", "Storage", "Bunker", "GOAT", "Testing"]],
		format["a list of %1", selectRandom ["Prisoners", "Informants", "Stockpiles", "Assets", "Codes", "Target", "Recipes"]]
	];

_dataObj setVariable ["var_dataType", _dataHeading, TRUE];
_dataObj setVariable ["var_zoneID", _zoneID, TRUE];

[_dataObj, 
	"<t color='#00FF80'>Download Data</t>", 
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa", 
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
	"!(_target getVariable ['var_dataSent', FALSE]) && _this distance _target < 3", 
	"!(_target getVariable ['var_dataSent', FALSE]) && _caller distance _target < 3", 
	{}, 
	{parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\download_ca.paa'/><br/><br/><t size='1.5'>%1</t><br/><br/><t size='1.5' color='#FFFF00'>Downloading</t><br/><t color='#FFFF00'></t><br/><br/><t size='1.75' color='#CCCCCC'>%2&#37;</t><br/><br/>", _target getVariable ["var_dataType","Data"], (round ((_this select 4) * 4.16)),name _caller] remoteExec ["hintSilent"]}, 
	{parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\download_ca.paa'/><br/><br/><t size='1.5'>%1</t><br/><br/><t size='1.5' color='#00FF00'>Downloaded</t><br/><t color='#00FF00'>(%2)</t><br/><br/><br/><br/>", _target getVariable ["var_dataType","Data"], name _caller] remoteExec ["hintSilent"]; 
	_target setVariable ["var_dataSent", TRUE, TRUE]; 
	sleep 5; 
	"" remoteExec ["hintSilent"]; 
	[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
	}, 
	{parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\download_ca.paa'/><br/><br/><t size='1.5'>%1</t><br/><br/><t size='1.5' color='#FF0000'>Cancelled</t><br/><t color='#FF0000'>(%2)</t><br/><br/><br/><br/>", _target getVariable ["var_dataType","Data"], name _caller] remoteExec ["hintSilent"];}, 
	[], 
	30, 
	10 
] remoteExec ["bis_fnc_holdActionAdd"];

missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _dataObj];

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", [0,0,0], FALSE];
_objTrigger setTriggerStatements [ 	format["(ZMM_%1_OBJ getVariable ['var_dataSent', FALSE])", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Failure Trigger
_faiTrigger = createTrigger ["EmptyDetector", [0,0,0], FALSE];
_faiTrigger setTriggerStatements [ 	format["!alive ZMM_%1_OBJ", _zoneID], 
									format["['ZMM_%1_TSK', 'Failed', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, "Grey"],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, getText (configFile >> "CfgVehicles" >> _dataType >> "displayName"), _dataHeading], ["Download"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "AUTOASSIGNED", 1, FALSE, TRUE, "download"] call BIS_fnc_setTask;

TRUE