// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyMen = missionNamespace getVariable [format["ZMM_%1Man", _enemySide], ["O_Solider_F"]];
private _buildings = missionNamespace getVariable [format["ZMM_%1_Buildings", _zoneID], []];
private _locations = missionNamespace getVariable [format["ZMM_%1_FlatLocations", _zoneID], []];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = selectRandom [
		"Intel has identified <font color='#00FFFF'>%1x %2s</font> being stored at %3, find them and extract them.",
		"%3 is known to have enemy forces trying to smuggle <font color='#00FFFF'>%1x %2s</font> out the area, find where they are keeping them and take the items.",
		"Smugglers have hidden <font color='#00FFFF'>%1x %2s</font> within %3. Find the packs and take them from the area.",
		"Somewhere in %3 are <font color='#00FFFF'>%1x %2s</font>. Find and take the packs before enemy forces can move them out of the area.",
		"Locate <font color='#00FFFF'>%1x %2s</font> in %3 and remove the items from the area."
	];

// Find one building position.
private _bldPos = _buildings apply { selectRandom (_x buildingPos -1) };

// Merge all locations
{ _locations pushBack position _x } forEach _buildings;

private _itemCount = 0;
private _itemType = selectRandom ["B_RadioBag_01_eaf_F","B_RadioBag_01_ghex_F","B_RadioBag_01_mtp_F","B_RadioBag_01_tropic_F","B_RadioBag_01_oucamo_F","B_RadioBag_01_wdl_F"];

// Generate the crates.
for "_i" from 1 to (missionNamespace getVariable ["ZZM_ObjectiveCount", 3]) do {
	private _itemPos = [];

	if (random 100 > 50 && {count _bldPos > 0}) then {
		_itemPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _itemPos);
	} else {
		if (count _locations > 0) then { 
			_itemPos = selectRandom _locations;
			_locations deleteAt (_locations find _itemPos);
		} else { 
			_itemPos = [_centre getPos [50 + random _radius, random 360], 1, _radius, 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
		};
		
		_itemPos = _itemPos findEmptyPosition [1, 50, "B_Soldier_F"];
	};
	
	if (count _itemPos > 0) then { 		
		_itemCount = _itemCount + 1;
		
		private _itemHolder = createVehicle ["GroundWeaponHolder_scripted", [0,0,0], [], 0, "CAN_COLLIDE"];
		_itemHolder setPosATL _itemPos;
		_itemHolder setDir random 360;
		_itemHolder addBackpackCargoGlobal [_itemType, 1];
		{ clearMagazineCargoGlobal _x; clearItemCargoGlobal _x } forEach [firstBackpack _itemHolder];
			
		// Create the task.
		private _mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _itemHolder getPos [random 50, random 360]];
		_mrkr setMarkerShape "ELLIPSE";
		_mrkr setMarkerBrush "SolidBorder";
		_mrkr setMarkerSize [50,50];
		_mrkr setMarkerAlpha 0.4;
		_mrkr setMarkerColor format[ "color%1", _enemySide ];
		
		missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _i], _itemHolder, true];
		
		_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Find and collect the item somewhere within the marked area.<br/><br/>Target: <font color='#00FFFF'>%1</font><br/><br/>", getText (configFile >> "CfgVehicles" >> _itemType >> "displayName")], format["Item #%1", _i], format["MKR_%1_OBJ_%2", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["move%1", _i]] call BIS_fnc_setTask;
		
		private _objTrigger = createTrigger ["EmptyDetector", _itemPos, false];
		_objTrigger setTriggerStatements [  format["!('%3' in (backpackCargo ZMM_%1_OBJ_%2))", _zoneID, _i, _itemType], 
			format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2'; missionNamespace setVariable ['ZMM_%1_TSK_Counter', (missionNamespace getVariable ['ZMM_%1_TSK_Counter', 0]) + 1, true]; [] spawn { sleep 120; deleteVehicle ZMM_%1_OBJ_%2; }", _zoneID, _i],
			"" ];

		private _enemyTeam = [];
		for "_j" from 0 to (3 * (missionNamespace getVariable ["ZZM_Diff", 1])) do { _enemyTeam set [_j, selectRandom _enemyMen] };
		
		private _milGroup = [_itemHolder getPos [random 2, random 360], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
		{ _x setUnitPos "MIDDLE" } forEach units _milGroup;
		{ _x addCuratorEditableObjects [[_itemHolder] + units _milGroup, true] } forEach allCurators;
	};
};

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [  format["(missionNamespace getVariable ['ZMM_%1_TSK_Counter',0]) >= %2", _zoneID, _itemCount], 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_missionDesc + format["<br/><br/>Backpack: <font color='#00FFFF'>%1</font><br/><br/><img width='350' image='%2'/>", getText (configFile >> "CfgVehicles" >> _itemType >> "displayName"), getText (configFile >> "CfgVehicles" >> _itemType >> "picture")], _itemCount, getText (configFile >> "CfgVehicles" >> _itemType >> "displayName"), _locName], ["Find"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "radio"] call BIS_fnc_setTask;

true