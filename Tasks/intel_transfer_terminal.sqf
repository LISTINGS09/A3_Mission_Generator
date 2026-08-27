// Set-up mission variables.
params [ ["_zoneID", 0], ["_tskPos", [0,0,0]], ["_bld", objNull] ];

private _tskCentre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _tskPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];
private _locations = missionNamespace getVariable [ format["ZMM_Z%1_FlatLocations", _zoneID], [] ];
private _enemyMen = missionNamespace getVariable [format["ZMM_%1_Man", _enemySide], ["O_Soldier_F"]];

private _tskDesc = selectRandom [
		"We have tracked a complete %1 spread across <font color='#00FFFF'>%3 Locations</font>. Secure and %3 the data at each location."
		//"<font color='#00FFFF'>%1</font> containing %2 has been located. Find the data from it on <font color='#00FFFF'>%3 Terminals</font> within the area.",
		//"We've picked up a signal indicating a <font color='#00FFFF'>%1</font> is in the area. It contains %2 and is vital it is recovered; locate the <font color='#00FFFF'>%4 Terminals</font> and obtain the data.",
		//"The enemy have located a <font color='#00FFFF'>%1</font> that is carrying %2. Find it and %3 the data in <font color='#00FFFF'>%3 Terminals</font> from it before it can be accessed by the enemy.",
		//"Locate the <font color='#00FFFF'>%1</font> which details %2 and %3 the information from it in a series of <font color='#00FFFF'>%3 Terminals</font>.",
		//"A <font color='#00FFFF'>%1</font> has been spotted in this area, find it and %3 %2 from it, <font color='#00FFFF'>%3 Terminals</font> of information will be required."
	];

// Overwrite building if present.
if (!isNull _bld) then { _buildings = [_bld] }; 

private _tskActivation = [];
private _counter = 0;
private _dataAction = selectRandom ["Download","Upload"];
private _dataHeading = selectRandom [
		format["%1 Dataset", selectRandom ["Weapon", "Radio", "Flight", "Cache", "Survey", "NBC", "Target", "Account"]],
		format["%1 Location", selectRandom ["Intel", "Camp", "POW", "Minefield", "HVT", "Storage", "Bunker", "Munition", "Testing"]],
		format["list of %1", selectRandom ["Prisoners", "Informants", "Stockpiles", "Assets", "Codes", "Target", "Recipes"]]
	];

for "_i" from 1 to (missionNamespace getVariable ["ZZM_ObjectiveCount", 3]) do {
	private _dataType = selectRandom (missionNamespace getVariable ["ZMM_Task_Transfer_TermIn", ["Land_DataTerminal_01_F","RuggedTerminal_01_F","RuggedTerminal_01_communications_F"]]);
	private _dataPos = [0,0,0];
	private _bldPos = [];
	private _inBuilding = false;

	if (count _buildings > 0 && random 100 > 20) then {
		private _bld = selectRandom _buildings;
		_buildings = _buildings - [_bld];
		
		_bldPos = _bld buildingPos -1;
		
		if (count _bldPos > 0) then {
			_dataPos = selectRandom _bldPos;
			_bldPos deleteAt (_bldPos find _dataPos);
			_inBuilding = true;
		};
	};

	if (!_inBuilding) then {
		_dataType = selectRandom (missionNamespace getVariable ["ZMM_Task_Transfer_TermOut", ["RuggedTerminal_01_communications_hub_F","RuggedTerminal_02_communications_F"]]);
		if (count _locations > 0) then {
			_dataPos = selectRandom _locations;
			_locations deleteAt (_locations find _dataPos);
		} else {
			_dataPos = [[_tskCentre, 100 + random 150, random 360] call BIS_fnc_relPos, 1, 50, 1, 0, 0.5, 0, [], [ _tskCentre, _tskCentre ]] call BIS_fnc_findSafePos 
		};
	};
	
	if (_dataPos isEqualTo [0,0,0]) then { _dataPos = _tskCentre };

	private _dataObj = createVehicle [_dataType, _dataPos, [], 0, "NONE"];
	private _mkr = createMarkerLocal [format["MKR_%1_OBJ_%2", _zoneID, _i], _dataObj getPos [50, random 360]];
	_mkr setMarkerShapeLocal "ELLIPSE";
	_mkr setMarkerBrushLocal "SolidBorder";
	_mkr setMarkerAlphaLocal 0.3;
	_mkr setMarkerColorLocal "ColorYellow";
	_mkr setMarkerSizeLocal [50,50];

	_dataObj setDir random 360;
	_dataObj setVariable ["var_dataType", _dataHeading, true];
	_dataObj setVariable ["var_zoneID", _zoneID, true];
	_dataObj setVariable ["var_unitID", _i, true];
	_dataObj setVariable ["var_dataName", _dataAction, true];

	[_dataObj, 
		format["<t color='#00FF80'>%1 Data</t>", _dataAction], 
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa",  
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
		"!(_target getVariable ['var_dataSent', false]) && _this distance2d _target < 3", 
		"!(_target getVariable ['var_dataSent', false]) && _caller distance2d _target < 3", 
		{
			switch (typeOf _target) do {
				case "Land_DataTerminal_01_F": { [_target, 3] remoteExec ["BIS_fnc_dataTerminalAnimate", _target] };
				case "RuggedTerminal_01_F";
				case "RuggedTerminal_01_communications_F";
				case "RuggedTerminal_02_communications_F";
				case "RuggedTerminal_01_communications_hub_F": { [_target,["Terminal_source", 100, false]] remoteExec ["animateSource", _target]; };
			};
		}, 
		{ 
			parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\%1_ca.paa'/><br/><br/><t size='1.5'>%1ing</t><br/><br/><t size='1.5' color='#FFFF00'>%2 #%3</t><br/><t color='#FFFF00'>%5</t><br/><br/><t size='1.75' color='#CCCCCC'>%4&#37;</t><br/><br/>", _target getVariable ["var_dataName","Download"], getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName"), _target getVariable ["var_unitID", 0], (round ((_this select 4) * 4.16)), name player] remoteExec ["hintSilent"];
			switch (typeOf _target) do {
				case "Land_DataTerminal_01_F": {};
				case "RuggedTerminal_01_F";
				case "RuggedTerminal_01_communications_F";
				case "RuggedTerminal_02_communications_F";
				case "RuggedTerminal_01_communications_hub_F": { [_target,["Progress_source", (round ((_this select 4) * 4.16)), 0.4]] remoteExec ["animateSource", _target]; };
			};
		}, 
		{ 
			parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\%1_ca.paa'/><br/><br/><t size='1.5'>%1ed</t><br/><br/><t size='1.5' color='#00CD00'>%2 #%3</t><br/><t color='#00CD00'></t><br/><br/><t size='1.5' color='#CCCCCC'>Shutting Down</t><br/><br/>", _target getVariable ["var_dataName","Download"], getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName"), _target getVariable ["var_unitID", 0]] remoteExec ["hintSilent"]; 
			_target setVariable ["var_dataSent", true, true]; 
			[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
			uiSleep 1; 
			switch (typeOf _target) do {
				case "Land_DataTerminal_01_F": { [_target, 0] remoteExec ["BIS_fnc_dataTerminalAnimate", _target] };
				case "RuggedTerminal_01_F";
				case "RuggedTerminal_01_communications_F";
				case "RuggedTerminal_02_communications_F";
				case "RuggedTerminal_01_communications_hub_F": { [_target,["Progress_source", 100, 5]] remoteExec ["animateSource", _target]; };
			};
			missionNamespace setVariable [format["ZMM_%1_OBJ_%2_DONE", _target getVariable ["var_zoneID", 0], _target getVariable ["var_unitID", 0]], true, true];
			uiSleep 6; 
			"" remoteExec ["hintSilent"]; 
		}, 
		{ 
			parseText format["<br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\%1_ca.paa'/><br/><br/><t size='1.5'>%1</t><br/><br/><t size='1.5' color='#FF0000'>Cancelled</t><br/><br/><br/><br/><br/>", _target getVariable ["var_dataName","Download"]] remoteExec ["hintSilent"]; 
			switch (typeOf _target) do {
				case "Land_DataTerminal_01_F": { [_target, 2] remoteExec ["BIS_fnc_dataTerminalAnimate", _target] };
				case "RuggedTerminal_01_F";
				case "RuggedTerminal_01_communications_F";
				case "RuggedTerminal_02_communications_F";
				case "RuggedTerminal_01_communications_hub_F": { 
					[_target,["Progress_source", 0, 5]] remoteExec ["animateSource", _target]; 
					[_target,["Terminal_source", 0, false]] remoteExec ["animateSource", _target]; 
				};
			};
		}, 
		[], 
		30, 
		10,
		false
	] remoteExec ["bis_fnc_holdActionAdd", 0, _dataObj];

	missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _i], _dataObj];
	
	// Child task
	// [taskId, target, description, (destination, state, priority, showNotification, isGlobal, type, visibleIn3D)] call BIS_fnc_setTask
	_childTask = [
		[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], 
			true, 
			[format["Get the info from the terminal.<br/><br/>Target: <font color='#00FFFF'><img>%2</img>%1</font><br/><br/>", getText (configFile >> "CfgVehicles" >> _dataType >> "displayName"), getText (configFile >> "CfgVehicles" >> _dataType >> "image")] + format["<br/><br/>Reference: <font color='#00FFFF'>ZMM_%1_OBJ_%2</font><br/><br/>", _zoneID, _i], format["Terminal #%1", _i],	format["MKR_%1_OBJ_%2", _zoneID, _i]],
			getMarkerPos _mkr,
			"CREATED",
			1,
			false,
			true,
			format["move%1", _i]
		] call BIS_fnc_setTask;
	_childTrigger = createTrigger ["EmptyDetector", _tskCentre, false];
	_childTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_childTrigger setTriggerStatements [  format["(missionNamespace getVariable ['ZMM_%1_OBJ_%2_DONE', false])", _zoneID, _i],
		format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2';", _zoneID, _i],
		"" 
	];
	
	_tskActivation pushBack format["(missionNamespace getVariable ['ZMM_%1_OBJ_%2_DONE', false])", _zoneID, _i];

	// Create enemy Team
	private _enemyTeam = [];
	for "_j" from 0 to (3 * (missionNamespace getVariable ["ZZM_Diff", 1])) do { _enemyTeam set [_j, selectRandom _enemyMen] };
			
	private _milGroup = [_dataPos getPos [random 10, random 360], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;

	{
		if (count _bldPos > 0 && {_inBuilding}) then {
			private _tempPos = selectRandom _bldPos;
			_bldPos deleteAt (_bldPos find _tempPos);
			_x setPosATL _tempPos;
			_x disableAI "PATH";
		} else {
			doStop _x;
			_x setVehiclePosition [_dataObj getPos [random 10, random 360], [], 0, "NONE"];
			_x setUnitPos "MIDDLE";
			_x setDir (_dataObj getRelDir _x);
		};
	} forEach units _milGroup;

	_milGroup setGroupIdGlobal [format["ZMM_%1_OBJGRP_%2", _zoneID, _i]];

	{ _x addCuratorEditableObjects [[_dataObj] + units _milGroup, true] } forEach allCurators;
};

// Create Completion Trigger
_tskTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_tskTrigger setTriggerStatements [  (_tskActivation joinString " && "), 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_OBJ','MKR_Z%1_LOC','MKR_Z%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], false, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_tskDesc, _dataHeading, _dataAction, missionNamespace getVariable ["ZZM_ObjectiveCount", 4]] + format["<br/><br/>Reference: <font color='#00FFFF'>ZMM_%1_OBJ</font><br/><br/>", _zoneID], [_dataAction] call zmm_fnc_nameGen, format["MKR_Z%1_LOC", _zoneID]], _tskCentre, "CREATED", 1, false, true, _dataAction] call BIS_fnc_setTask;

true