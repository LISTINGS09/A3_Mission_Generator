// Find and destroy a cache
// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyTeam = selectRandom (missionNamespace getVariable[format["ZMM_%1Grp_Sentry",_enemySide],[""]]); // CfgGroups entry.
private _buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];
private _locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];
private _missionDesc = [
		"Destroy <font color='#00FFFF'>%1 Equipment Caches</font> recently dropped for enemy forces near %2.",
		"The enemy has collected <font color='#00FFFF'>%1 Weapon Caches</font> being stored somewhere at %2, destroy them.",
		"We've picked up a signal from %2 indicating <font color='#00FFFF'>%1 Weapons Caches</font> are present in the area, destroy them.",
		"Destroy the <font color='#00FFFF'>%1 Enemy Caches</font> concealed somewhere at %2.",
		"Intel has identified <font color='#00FFFF'>%1 Weapons Caches</font> being stored at %2. Find and destroy them.",
		"A UAV flying over %2 has spotted an enemy smuggling <font color='#00FFFF'>%1 Ammo Caches</font> into the area, find and destroy them."
	];

private _cacheNo = switch (_locType) do {
	case "Airport": { 5 };
	case "NameCityCapital": { 4 };
	case "NameCity": { 4 };
	case "NameVillage": { 3 };
	case "NameLocal": { 3 };
	default { 2 };
};

// Find all building positions.
private _bldPos = [];
{ _bldPos append (_x buildingPos -1) } forEach _buildings;

// Merge all locations
{ _locations pushBack position _x } forEach _buildings;

private _crateActivation = [];
private _crateNo = 0;

// Generate the crates.
for "_i" from 0 to _cacheNo do {
	private _ammoType = selectRandom ["Box_FIA_Ammo_F","Box_FIA_Support_F","Box_FIA_Wps_F"];
	private _ammoPos = [];

	if (random 100 > 50 && {count _bldPos > 0}) then {
		_ammoPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _ammoPos);
		_ammoType = selectRandom ["Box_IND_Ammo_F","Box_IND_Wps_F","Box_IND_Grenades_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F"];
	} else {
		if (count _locations > 0) then { 
			_ammoPos = selectRandom _locations;
			_locations deleteAt (_locations find _ammoPos);
		} else { 
			_ammoPos = [[_centre, 100 + random 150, random 360] call BIS_fnc_relPos, 1, _radius, 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
		};
		
		_ammoPos = _ammoPos findEmptyPosition [1, 25, _ammoType];
	};
		
	if (count _ammoPos > 0) then { 
		_crateNo = _crateNo + 1;
		private _ammoObj = _ammoType createVehicle [0,0,0];
		_ammoObj setPosATL _ammoPos;
		_ammoObj setDir random 360;
		
		// If the crate was moved safely, create the task.
		if (alive _ammoObj) then {
			private _mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _ammoObj getPos [random 50, random 360]];
			_mrkr setMarkerShape "ELLIPSE";
			_mrkr setMarkerBrush "SolidBorder";
			_mrkr setMarkerSize [50,50];
			_mrkr setMarkerAlpha 0.4;
			_mrkr setMarkerColor format["Color%1",_enemySide];
			
			missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _i], _ammoObj];
			
			// Child task
			private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate the enemy cache somewhere within the marked area.<br/><br/>Target Cache: <font color='#00FFFF'>%1</font><br/><br/><img width='350' image='%2'/>", getText (configFile >> "CfgVehicles" >> _ammoType >> "displayName"), getText (configFile >> "CfgVehicles" >> _ammoType >> "editorPreview")], format["Cache #%1", _i + 1], format["MKR_%1_%2_OBJ", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["move%1", _i + 1]] call BIS_fnc_setTask;
			private _childTrigger = createTrigger ["EmptyDetector", getPos _ammoObj, false];
			_childTrigger setTriggerStatements [  format["!alive ZMM_%1_OBJ_%2", _zoneID, _i],
										format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2';", _zoneID, _i],
										"" ];
			
			_crateActivation pushBack format["!alive ZMM_%1_OBJ_%2", _zoneID, _i];
			
			clearWeaponCargoGlobal _ammoObj;
			clearMagazineCargoGlobal _ammoObj;
			clearItemCargoGlobal _ammoObj;
			clearBackpackCargoGlobal _ammoObj;
			
			if !(_enemyTeam isEqualTo "") then {
				private _milGroup = [_ammoObj getPos [random 2, random 360], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
				{ _x setUnitPos "MIDDLE" } forEach units _milGroup;
				{ _x addCuratorEditableObjects [[_ammoObj] + units _milGroup, true] } forEach allCurators;
			};
		};
	};
};

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [  (_crateActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _crateNo, _locName], ["Cache Hunt"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "box"] call BIS_fnc_setTask;

true