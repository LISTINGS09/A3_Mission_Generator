// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _menArray = missionNamespace getVariable [format["ZMM_%1Man", _enemySide], ["O_Solider_F"]];
private _locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
private _buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = selectRandom [
		"Secure the area around <font color='#0080FF'>%1</font color> then locate and mark the locations of <font color='#00FFFF'>%2 Container(s)</font color> in the area.",
		"Investigate <font color='#0080FF'>%1</font color> by searching the surrounding area and locating <font color='#00FFFF'>%2 Container(s)</font color> somewhere in the area.",
		"<font color='#0080FF'>%1</font color> is occupied by enemy forces, eliminate them and secure the area while identifying the <font color='#00FFFF'>%2 Container(s)</font color>.",
		"Hunt down the locations of <font color='#00FFFF'>%2 Container(s)</font color> somewhere in <font color='#0080FF'>%1</font color>.",
		"Enemy forces have occupied <font color='#0080FF'>%1</font color>, eliminate them and find the <font color='#00FFFF'>%2 Container(s)</font color> in the area.",
		"Locate the <font color='#00FFFF'>%2 Container(s)</font color> hidden somewhere in <font color='#0080FF'>%1</font color>."
	];
	
// Find one building position.
private _bldPos = [];
{ _bldPos pushBack selectRandom (_x buildingPos -1) } forEach _buildings;

private _itemNo = 0;
private _itemActivation = [];

for "_i" from 1 to (missionNamespace getVariable ["ZZM_ObjectiveCount", 2]) do {
	private _itemType = selectRandom ["C_IDAP_supplyCrate_F", "Box_FIA_Ammo_F", "Land_MetalCase_01_large_F", "Land_PlasticCase_01_large_F", "Land_PlasticCase_01_large_gray_F"];
	private _itemPos = [];
	private _inBuilding = false;

	if (random 100 > 50 && {count _bldPos > 0}) then {
		_inBuilding = true;
		_itemPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _itemPos);
		_itemType = selectRandom ["Land_MetalCase_01_medium_F", "Land_PlasticCase_01_medium_F", "Land_PlasticCase_01_medium_gray_F", "Land_PlasticCase_01_small_F", "Land_PlasticCase_01_small_gray_F", "Land_MetalCase_01_small_F"];
	} else {
		if (count _locations > 0) then { 
			_itemPos = selectRandom _locations;
			_locations deleteAt (_locations find _itemPos);
		} else { 
			_itemPos = [[_centre, 100 + random 150, random 360] call BIS_fnc_relPos, 1, _radius, 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
		};
		
		_itemPos = _itemPos findEmptyPosition [1, 15, _itemType];
	};
		
	if (count _itemPos > 0) then {
		_itemNo = _itemNo + 1;
		private _item = createVehicle [_itemType, [0,0,0], [], 0, "NONE"];
		_item setPosATL _itemPos;
		_item setDir random 360;
		_item allowDamage false;
	
		_item allowDamage false;
		_item setVariable [ "var_Number", _itemNo, true ];
		_item setVariable [ "var_zoneID", _zoneID, true ];
		
		// Add players action
		[_item, 
			format["<t color='#00FF80'>Mark %1</t>", getText (configFile >> "CfgVehicles" >> _itemType >> "displayName")], 
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_Search_ca.paa",  
			"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_Search_ca.paa",  
			"true", 
			"true", 
			{}, 
			{}, 
			{ 	
				_itemNo = ( _target getVariable [ "var_Number", 0 ] );
				_zoneID = ( _target getVariable [ "var_zoneID", 0 ] );
				missionNamespace setVariable [ format[ "ZMM_%1_ITEM%2", _zoneID, _itemNo ], true, true];
				[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
				(parseText format["<t size='1.5' color='#72E500'>Item Located:</t><br/><t size='1.25'>%1</t><br/><br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\search_ca.paa'/><br/><br/>Found By: <t color='#0080FF'>%2</t><br/>", getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName"), name _caller]) remoteExec ["hintSilent"]; 
			}, 
			{}, 
			[], 
			5, 
			10 
		] remoteExec ["BIS_fnc_holdActionAdd", 0, _item];

		_itemDist = if (_inBuilding) then { 35 } else { 50 };
		
		_relPos = [ position _item, random _itemDist, random 360 ] call BIS_fnc_relPos;	
		_mrk = createMarker [ format[ "MKR_%1_ITEM_%2", _zoneID, _itemNo ], _relPos ];
		_mrk setMarkerPos _relPos;
		_mrk setMarkerShape "ELLIPSE";
		_mrk setMarkerBrush "SolidBorder";
		_mrk setMarkerAlpha 0.5;
		_mrk setMarkerColor format[ "color%1", _enemySide ];
		_mrk setMarkerSize [ _itemDist, _itemDist ];
		
		// Child task
		_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _itemNo], format['ZMM_%1_TSK', _zoneID]], true, [format["Search for the object somewhere within the marked area.<br/><br/>Target Object: <font color='#00FFFF'>%1</font><br/><br/><img width='350' image='%2'/>", [getText (configFile >> "CfgVehicles" >> _itemType >> "displayName"),"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- "] call BIS_fnc_filterString, getText (configFile >> "CfgVehicles" >> _itemType >> "editorPreview")], format["Object #%1", _itemNo], format["MKR_%1_ITEM_%2", _zoneID, _itemNo]], _relPos, "CREATED", 1, false, true, format["move%1", _itemNo]] call BIS_fnc_setTask;
		_childTrigger = createTrigger ["EmptyDetector", _centre, false];
		_childTrigger setTriggerStatements [  format["(missionNamespace getVariable ['ZMM_%1_ITEM_%2', false])", _zoneID, _itemNo],
			format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_ITEM_%2';", _zoneID, _itemNo],
			"" ];
		
		// Build trigger completion.
		_itemActivation pushBack format["(missionNamespace getVariable [ 'ZMM_%1_ITEM_%2', false ])", _zoneID, _itemNo];
		
		if (underwater _item) then {
			_item setPosASL [position _item select 0, position _item select 1, 0];
			_item enableSimulationGlobal false;
		} else {
			// Spawn filler objects
			if !_inBuilding then {
				for "_j" from 0 to 1 + random 3 do {
					_sObj = createSimpleObject [selectRandom ["Land_WoodenCrate_01_F", "Land_WoodenCrate_01_stack_x3_F", "Land_WoodenCrate_01_stack_x5_F", "Land_TentA_F", "Land_Pallets_stack_F", "Land_PaperBox_01_open_empty_F", "Land_CratesWooden_F", "Land_Sacks_heap_F"], AGLToASL (_item getPos [2 + random 5, random 360])]; 
					_sObj setDir random 360;
				};
			};
		
			// Create enemy Team
			private _enemyTeam = [];
			for "_j" from 0 to (4 * (missionNamespace getVariable ["ZZM_Diff", 1])) do { _enemyTeam set [_j, selectRandom _menArray] };

			private _milGroup = [_item getPos [random 10, random 360], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
			
			private _bldArr = if (_inBuilding) then { (nearestBuilding _itemPos) buildingPos -1 } else { [] };
			_bldArr deleteAt (_bldArr find _itemPos);
			
			{
				if (count _bldArr > 0) then {
					private _tempPos = selectRandom _bldArr;
					_bldArr deleteAt (_bldArr find _tempPos);
					_x setPosATL _tempPos;
					_x disableAI "PATH";
				} else {
					_x setVehiclePosition [_item getPos [random 5, random 360], [], 0, "NONE"];
					_x setUnitPos "MIDDLE";
				};
			} forEach units _milGroup;

			{ _x addCuratorEditableObjects [[_item] + units _milGroup, true] } forEach allCurators;
			
			// Wait before setting DS to allow positions to set.
			_milGroup spawn { sleep 5; _this enableDynamicSimulation true };
		};
	};
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerStatements [  (_itemActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_missionDesc, _locName, count _itemActivation], ["Search"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "search"] call BIS_fnc_setTask;

true