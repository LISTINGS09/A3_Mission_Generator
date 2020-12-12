// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyTeam = selectRandom (missionNamespace getVariable[format["ZMM_%1Grp_Team",_enemySide],[""]]); // CfgGroups entry.
_buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];
_locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
_radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
_locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
_locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];


_missionDesc = [
		"Intel has identified <font color='#00FFFF'>%1x Items</font> being stored at %4, find their containers and obtain the items.",
		"%4 is known to have enemy forces smuggling <font color='#00FFFF'>%1x Items</font> into the area, find where they are keeping them and take the items.",
		"Smugglers have hidden <font color='#00FFFF'>%1x Items</font> within %4. Find the caches containing the item and take it.",
		"Somewhere in %4 are <font color='#00FFFF'>%1x Items</font>. Find and take the items before enemy forces can move them out of the area.",
		"Locate the caches containing <font color='#00FFFF'>%1x Items</font> in %4 and take the items."
	];

_cacheNo = switch (_locType) do {
	case "Airport": { 3 };
	case "NameCityCapital": { 3 };
	case "NameCity": { 3 };
	case "NameVillage": { 2 };
	case "NameLocal": { 2 };
	default { 2 };
};

// Find one building position.
_bldPos = [];
{ _bldPos pushBack selectRandom (_x buildingPos -1) } forEach _buildings;

// Merge all locations
{
	_locations pushBack position _x;
} forEach _buildings;

private _crateActivation = [];
private _crateNo = 0;
private _prefix = selectRandom ["Rare","Marked","Special","Unique","Unusual","Specialised","Modified"];
private _findObj = selectRandom ["ChemicalDetector_01_watch_F","ItemCompass","ItemGPS","MineDetector","ItemMap","ItemRadio","ItemWatch"];
private _findName = format["%1 %2", _prefix, getText (configFile >> "CfgWeapons" >> _findObj >> "displayName")];

// Generate the crates.
for "_i" from 0 to _cacheNo do {
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
			_contPos = [[_centre, 100 + random 150, random 360] call BIS_fnc_relPos, 1, _radius, 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
		};
		
		_contPos = _contPos findEmptyPosition [1, 25, _contType];
		
	};
		
	if (count _contPos > 0) then { 
		_crateNo = _crateNo + 1;
		_contObj = _contType createVehicle [0,0,0];
		_contObj setPosATL _contPos;
		_contObj setDir random 360;
		_contObj allowDamage false;
		
		// If the crate was moved safely, create the task.
		if (alive _contObj) then {
			_mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _contObj getPos [random 50, random 360]];
			_mrkr setMarkerShape "ELLIPSE";
			_mrkr setMarkerBrush "SolidBorder";
			_mrkr setMarkerSize [50,50];
			_mrkr setMarkerAlpha 0.4;
			_mrkr setMarkerColor format["Color%1",_enemySide];
			
			_contStr = format["ZMM_%1_OBJ_%2", _zoneID, _i];
			missionNamespace setVariable [_contStr, _contObj, true];
			_contObj setVariable ["ZMM_Id", _contStr + "_DONE", true];
			_contObj setVariable ["ZMM_Type", _findObj, true];
			
			// Child task
			_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Locate the cache somewhere within the marked area.<br/><br/>Target Cache: <font color='#00FFFF'>%1</font><br/><br/><img width='350' image='%2'/>", getText (configFile >> "CfgVehicles" >> _contType >> "displayName"), getText (configFile >> "CfgVehicles" >> _contType >> "editorPreview")], format["Cache #%1", _i + 1], format["MKR_%1_%2_OBJ", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["move%1", _i + 1]] call BIS_fnc_setTask;
			_childTrigger = createTrigger ["EmptyDetector", _contObj, false];
			_childTrigger setTriggerStatements [  format["(missionNamespace getVariable ['ZMM_%1_OBJ_%2_DONE', false])", _zoneID, _i],
										format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2';", _zoneID, _i],
										"" ];
			
			_crateActivation pushBack format["(missionNamespace getVariable ['ZMM_%1_OBJ_%2_DONE', false])", _zoneID, _i];
						
			clearWeaponCargoGlobal _contObj;
			clearMagazineCargoGlobal _contObj;
			clearItemCargoGlobal _contObj;
			clearBackpackCargoGlobal _contObj;
			
			_contObj addItemCargoGlobal [_findObj, 1];
			
			if !(_inBuilding) then { _contObj setVectorUp surfaceNormal position _contObj };
			
			[_contObj, ["ContainerClosed", { 
				params ["_cont", "_unit"]; 
				
				private _id = _cont getVariable ["ZMM_Id", "NULL"];
				private _item = _cont getVariable ["ZMM_Type", "Item_FirstAidKit"];
				
				if !(_item in ((weaponCargo _cont) + (itemCargo _cont) + (magazineCargo _cont))) then {
					missionNamespace setVariable [_id, true, true];
					(parseText format["<t size='1.5' color='#72E500'>Collected:</t><br/><t size='1.25'>%2</t><br/><br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\search_ca.paa'/><br/><br/>Found By: <t color='#0080FF'>%1</t><br/>", name _unit, getText (configFile >> "CfgWeapons" >> _item >> "displayName")]) remoteExec ["hintSilent"];
					[_cont, "ContainerClosed"] remoteExec ["removeAllEventHandlers"];
				};
			}]] remoteExec ["addEventHandler"];
		
			// Create enemy guards if valid group
			if !(_enemyTeam isEqualTo "") then {
				// Create enemy Team
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
					};
				} forEach units _milGroup;

				{ _x addCuratorEditableObjects [[_contObj] + units _milGroup, true] } forEach allCurators;
			};
		};
	};
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [  (_crateActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc + "<br/><br/>Target Item: <font color='#00FFFF'>%2</font><br/><br/><img width='150' image='%3'/>", _crateNo, _findName, getText (configFile >> "CfgWeapons" >> _findObj >> "picture"), _locName], ["Take Item"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "box"] call BIS_fnc_setTask;

true