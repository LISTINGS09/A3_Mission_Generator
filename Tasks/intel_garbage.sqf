// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _buildings = missionNamespace getVariable [format["ZMM_%1_Buildings", _zoneID], []];
private _locations = missionNamespace getVariable [format["ZMM_%1_FlatLocations", _zoneID], []];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = [
		"A local informant has hidden a USB drive containing %2 within %3. Search the <font color='#00FFFF'>%1 Garbage Locations</font> and obtain the USB Drive.",
		"Locate the <font color='#00FFFF'>%1 Junk Piles</font> and search for a discarded document containing %2 around %3.",
		"Travel to %3 and search through <font color='#00FFFF'>%1 Piles of Rubbish</font>. An local rebel group has discarded a Laptop containing %2.",
		"Search %3 for <font color='#00FFFF'>%1 Piles of Junk</font>. Inside one of these a set of documents containing %2 concealed inside.",
		"Allied rebel forces ambushed a convoy travelling though %3, they obtained a Laptop containing %2 but were forced to hide it to avoid capture. Return to %3 and search through <font color='#00FFFF'>%1 Garbage Piles</font> to find the missing Laptop.",
		"Retrieve a data ID card containing %2 that has been hidden in <font color='#00FFFF'>%1 Rubbish Piles</font> somewhere around %3."
	];
	
private _garInfo = selectRandom ["nearby Munitions Caches", "possible Chemical Weapons", "an enemy HQ", "enemy movements", "a planned ambush"];
private _garCount = 0;
private _maxCount = switch (_locType) do {
		case "Airport": { 5 };
		case "NameCityCapital": { 4 };
		case "NameCity": { 4 };
		case "NameVillage": { 3 };
		case "NameLocal": { 3 };
		default { 3 };
	};

// Add a random location from each building.
private _bldPos = _buildings apply { selectRandom (_x buildingPos -1) };

// Find safe locations if none exist or we don't have enough.
if (_locations isEqualTo [] || count _locations < _maxCount) then {
	for "_i" from 0 to (_maxCount) do {
		private _tempPos = [_centre getPos [50 + random 150, random 360], 1, (((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100), 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
		_locations pushBack _tempPos;
	};
};

// Generate the items.
for "_i" from 1 to _maxCount do {
	private _garType = selectRandom ["Land_GarbagePallet_F", "Land_GarbageBags_F", "Land_GarbageWashingMachine_F"];
	private _garPos = [];
	private _garObj = objNull;

	if (random 100 > 50 && {count _bldPos > 0}) then {
		_garPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _garPos);
		_garType = selectRandom ["Land_BarrelTrash_F","Land_BarrelTrash_grey_F"];
		_garObj = _garType createVehicle [0,0,0];
		_garObj setPosATL _garPos;
		_garObj setDir random 360;
		_garObj allowDamage false;
	} else {
		_garPos = selectRandom _locations;
		_locations deleteAt (_locations find _garPos);
		
		_garPos = _garPos findEmptyPosition [1, 25, _garType];
		_garObj = createVehicle [_garType, _garPos, [], 0, "NONE"];
		_garObj setVectorUp surfaceNormal getPos _garObj;
		_garObj setDir random 360;
		_garObj allowDamage false;
		
		_litObj = "Land_Garbage_square5_F" createVehicle [0,0,0];
		_litObj setPosATL getPosATL _garObj;
		_litObj setVectorUp surfaceNormal getPos _garObj;
	};
		
	// If the crate was moved safely, create the task.
	if (alive _garObj) then {
		_garCount = _garCount + 1;	
		
		_mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _garObj getPos [random 50, random 360]];
		_mrkr setMarkerShape "ELLIPSE";
		_mrkr setMarkerBrush "SolidBorder";
		_mrkr setMarkerSize [50,50];
		_mrkr setMarkerAlpha 0.4;
		_mrkr setMarkerColor format["Color%1",_enemySide];
		
		//missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _i], _garObj];
		
		// Child task
		_garObj setVariable ["var_zoneID", _zoneID, true];
		_garObj setVariable ["var_itemID", _i, true];
		
		_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Search the garbage located somewhere inside the marked area.<br/><br/>Object: <font color='#00FFFF'>%1</font><br/><br/><img width='350' image='%2'/>", getText (configFile >> "CfgVehicles" >> _garType >> "displayName"), getText (configFile >> "CfgVehicles" >> _garType >> "editorPreview")], format["Garbage #%1", _i], format["MKR_%1_%2_OBJ", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, "search"] call BIS_fnc_setTask;

		[_garObj, 
			format["<t color='#00FF80'>Search the %1</t>", getText (configFile >> "CfgVehicles" >> _garType >> "displayName")], 
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_search_ca.paa", 
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_search_ca.paa", 
			"_this distance2d _target < 3", 
			"_caller distance2d _target < 3", 
			{}, 
			{}, 
			{
				[_target, _actionId] remoteExec ["BIS_fnc_holdActionRemove"];
				_caller playAction "PutDown";
				sleep 1;
				private _varName = format["ZMM_%1_TSK_Counter", (_target getVariable ["var_zoneID", 0])];
				missionNamespace setVariable [_varName, (missionNamespace getVariable [_varName, 0]) - ((random 1) + 1), true];
				deleteMarker format["MKR_%1_OBJ_%2", (_target getVariable ["var_zoneID", 0]), (_target getVariable ["var_itemID", 0])];
				[name _caller, if (missionNamespace getVariable [_varName, 0] >= 1) then { "There is nothing of value in here." } else { "We have got what we came for, mission complete." }] remoteExec ["BIS_fnc_showSubtitle"];
				[format["ZMM_%1_SUB_%2", (_target getVariable ["var_zoneID", 0]), (_target getVariable ["var_itemID", 0])], 'Succeeded', true] remoteExec ["BIS_fnc_taskSetState"];
				[_target, { sleep 120; deleteVehicle _this }] remoteExec ["BIS_fnc_spawn", _target];
			}, 
			{}, 
			[], 
			2, 
			10 
		] remoteExec ["bis_fnc_holdActionAdd", 0, _garObj];

	};
};

// Countdown so we know the last item == 1
missionNamespace setVariable [format['ZMM_%1_TSK_Counter', _zoneID], _garCount, true];

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [  format["(missionNamespace getVariable ['ZMM_%1_TSK_Counter',0]) < 1", _zoneID, _garCount], 
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _garCount, _garInfo, _locName], ["Intel"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "intel"] call BIS_fnc_setTask;

true