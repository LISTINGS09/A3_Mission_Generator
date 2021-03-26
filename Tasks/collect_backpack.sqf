// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _buildings = missionNamespace getVariable [format["ZMM_%1_Buildings", _zoneID], []];
private _locations = missionNamespace getVariable [format["ZMM_%1_FlatLocations", _zoneID], []];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyTeam = selectRandom (missionNamespace getVariable[format["ZMM_%1Grp_Sentry",_enemySide],[""]]); // CfgGroups entry.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = [
		"Intel has identified <font color='#00FFFF'>%1x Radio Packs</font> being stored at %2, find them and extract them.",
		"%2 is known to have enemy forces trying to smuggle <font color='#00FFFF'>%1x Radio Packs</font> out the area, find where they are keeping them and take the items.",
		"Smugglers have hidden <font color='#00FFFF'>%1x Portable Radio Packs</font> within %2. Find the packs and take them from the area.",
		"Somewhere in %2 are <font color='#00FFFF'>%1x Radio Packs</font>. Find and take the packs before enemy forces can move them out of the area.",
		"Locate <font color='#00FFFF'>%1x Radio Packs</font> in %2 and remove the items from the area."
	];

private _itemMax = switch (_locType) do {
	case "Airport": { 4 };
	case "NameCityCapital": { 4 };
	case "NameCity": { 3 };
	case "NameVillage": { 2 };
	case "NameLocal": { 2 };
	default { 2 };
};

// Find a random building position.
private _positions = [];
{ _positions pushBack (selectRandom (_x buildingPos -1)) } forEach _buildings;

// Add locations if there is not enough building positions
if (count _positions < _itemMax) then {
	{ _positions pushBack _x } forEach _locations;
};

private _itemCount = 0;
private _itemType = selectRandom ["B_RadioBag_01_eaf_F","B_RadioBag_01_ghex_F","B_RadioBag_01_mtp_F","B_RadioBag_01_tropic_F","B_RadioBag_01_oucamo_F","B_RadioBag_01_wdl_F"];

// Create locations if none exist
if (_positions isEqualTo []) then {
	for "_i" from 0 to (_itemMax) do {
		_positions pushBack (_centre getPos [25 + random 50, random 360]);
	};
};

// Generate the crates.
for "_i" from 1 to (_itemMax) do {
	if (_positions isEqualTo []) exitWith {};

	
	private _itemPos = selectRandom _positions;
	if (count _positions > _itemMax) then { _positions deleteAt (_positions find _itemPos) };

	if (count _itemPos > 0) then { 
		// If not in a building find an empty position.
		if (_itemPos#2 == 0) then { _itemPos = _itemPos findEmptyPosition [1, 25, "B_Soldier_F"] };
		
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
		_mrkr setMarkerColor "ColorCivilian";
		
		missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _i], _itemHolder, true];
		
		_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Find and collect the item somewhere within the marked area.<br/><br/>Target: <font color='#00FFFF'>%1</font><br/><br/>", getText (configFile >> "CfgVehicles" >> _itemType >> "displayName")], format["Item #%1", _i], format["MKR_%1_%2_OBJ", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["move%1", _i]] call BIS_fnc_setTask;
		
		private _objTrigger = createTrigger ["EmptyDetector", _itemPos, false];
		_objTrigger setTriggerStatements [  format["!('%3' in (backpackCargo ZMM_%1_OBJ_%2))", _zoneID, _i, _itemType], 
			format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2'; missionNamespace setVariable ['ZMM_%1_TSK_Counter', (missionNamespace getVariable ['ZMM_%1_TSK_Counter', 0]) + 1, true]; [] spawn { sleep 120; deleteVehicle ZMM_%1_OBJ_%2; }", _zoneID, _i],
			"" ];
			
		if !(_enemyTeam isEqualTo "") then {
			private _milGroup = [_itemHolder getPos [random 2, random 360], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
			{ _x setUnitPos "MIDDLE" } forEach units _milGroup;
			{ _x addCuratorEditableObjects [[_itemHolder] + units _milGroup, true] } forEach allCurators;
		};
	};
};

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [  format["(missionNamespace getVariable ['ZMM_%1_TSK_Counter',0]) >= %2", _zoneID, _itemCount], 
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc + format["<br/><br/>Backpack: <font color='#00FFFF'>%1</font><br/><br/><img width='350' image='%2'/>", getText (configFile >> "CfgVehicles" >> _itemType >> "displayName"), getText (configFile >> "CfgVehicles" >> _itemType >> "picture")], _itemCount, _locName], ["Find"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "radio"] call BIS_fnc_setTask;

true