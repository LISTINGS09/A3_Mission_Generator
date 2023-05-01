// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _menArray = missionNamespace getVariable [format["ZMM_%1Man", _enemySide], ["O_Solider_F"]];
private _buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];
private _locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = selectRandom [
		"Intel has identified <font color='#00FFFF'>%1x Items</font> being stored at %4, find their containers and obtain the items.",
		"%4 is known to have enemy forces smuggling <font color='#00FFFF'>%1x Items</font> into the area, find where they are keeping them and take the items.",
		"Smugglers have hidden <font color='#00FFFF'>%1x Items</font> within %4. Find the caches containing the item and take it.",
		"Somewhere in %4 are <font color='#00FFFF'>%1x Items</font>. Find and take the items before enemy forces can move them out of the area.",
		"Locate the caches containing <font color='#00FFFF'>%1x Items</font> in %4 and take the items."
	];

// Find one building position.
private _bldPos = _buildings apply { selectRandom (_x buildingPos -1) };

// Merge all locations
{ _locations pushBack position _x } forEach _buildings;

private _crateActivation = [];
private _crateNo = 0;
private _prefix = selectRandom ["Rare","Marked","Special","Unique","Unusual","Specialised","Modified"];
private _findObj = selectRandom ["ChemicalDetector_01_watch_F","ItemCompass","ItemGPS","MineDetector","ItemMap","ItemRadio","ItemWatch"];
private _findName = format["%1 %2", _prefix, getText (configFile >> "CfgWeapons" >> _findObj >> "displayName")];

// Generate the crates.
for "_i" from 1 to (missionNamespace getVariable ["ZZM_ObjectiveCount", 3]) do {
	private _contType = selectRandom ["Box_FIA_Support_F"];
	private _contPos = [];
	private _inBuilding = false;

	if (random 100 > 50 && {count _bldPos > 0}) then {
		_inBuilding = true;
		_contPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _contPos);
		_contType = selectRandom ["Box_IND_Ammo_F","Box_IND_Wps_F","Box_IND_Grenades_F","Box_IND_WpsLaunch_F"];
	} else {
		if (count _locations > 0) then { 
			_contPos = selectRandom _locations;
			_locations deleteAt (_locations find _contPos);
		} else { 
			_contPos = [_centre getPos [50 + random _radius, random 360], 1, _radius, 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
		};
		
		_contPos = _contPos findEmptyPosition [1, 50, _contType];
	};
		
	if (count _contPos > 0) then { 
		_crateNo = _crateNo + 1;
		_contObj = createVehicle [_contType, [0,0,0], [], 150, "NONE"];
		_contObj setPosATL _contPos;
		_contObj setDir random 360;
		_contObj allowDamage false;
		
		// If the crate was moved safely, create the task.
		if (alive _contObj) then {
			clearWeaponCargoGlobal _contObj;
			clearMagazineCargoGlobal _contObj;
			clearItemCargoGlobal _contObj;
			clearBackpackCargoGlobal _contObj;
			
			_contObj addItemCargoGlobal [_findObj, 1];
		
			private _mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _contObj getPos [random 50, random 360]];
			_mrkr setMarkerShape "ELLIPSE";
			_mrkr setMarkerBrush "SolidBorder";
			_mrkr setMarkerSize [50,50];
			_mrkr setMarkerAlpha 0.4;
			_mrkr setMarkerColor format["Color%1",_enemySide];
			
			missionNamespace setVariable [ format["ZMM_%1_OBJ_%2", _zoneID, _i], _contObj, true];
			
			// Child task
			private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate the cache somewhere within the marked area.<br/><br/>Target Cache: <font color='#00FFFF'>%1</font><br/><br/><img width='350' image='%2'/>", getText (configFile >> "CfgVehicles" >> _contType >> "displayName"), getText (configFile >> "CfgVehicles" >> _contType >> "editorPreview")], format["Cache #%1", _i], format["MKR_%1_OBJ_%2", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["move%1", _i]] call BIS_fnc_setTask;
			private _childTrigger = createTrigger ["EmptyDetector", _contObj, false];
			_childTrigger setTriggerStatements [ format["((getItemCargo ZMM_%1_OBJ_%2)#0) find '%3' < 0", _zoneID, _i, _findObj],
				format["missionNamespace setVariable ['ZMM_%1_OBJ_%2_DONE', true, true]; ['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2';", _zoneID, _i],
				"" ];
			
			_crateActivation pushBack format["(missionNamespace getVariable ['ZMM_%1_OBJ_%2_DONE', false])", _zoneID, _i];

			if !(_inBuilding) then { _contObj setVectorUp surfaceNormal position _contObj };
					
			// Create enemy Team
			private _enemyTeam = [];
			for "_j" from 0 to (4 * (missionNamespace getVariable ["ZZM_Diff", 1])) do { _enemyTeam set [_j, selectRandom _menArray] };
			
			private _milGroup = [_contPos getPos [random 10, random 360], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
				
			private _bldArr = if (_inBuilding) then { (nearestBuilding _contPos) buildingPos -1 } else { [] };
			_bldArr deleteAt (_bldArr find _contPos);
			
			{
				if (count _bldArr > 0) then {
					private _tempPos = selectRandom _bldArr;
					_bldArr deleteAt (_bldArr find _tempPos);
					_x setPosATL _tempPos;
					_x disableAI "PATH";
				} else {
					_x setVehiclePosition [_contObj getPos [random 5, random 360], [], 0, "NONE"];
					_x setUnitPos "MIDDLE";
					doStop _x;
				};
			} forEach units _milGroup;

			{ _x addCuratorEditableObjects [[_contObj] + units _milGroup, true] } forEach allCurators;
		};
	};
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [  (_crateActivation joinString " && "), 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_missionDesc + "<br/><br/>Target Item: <font color='#00FFFF'>%2</font><br/><br/><img width='150' image='%3'/>", count _crateActivation, _findName, getText (configFile >> "CfgWeapons" >> _findObj >> "picture"), _locName], ["Take Item"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "box"] call BIS_fnc_setTask;

true