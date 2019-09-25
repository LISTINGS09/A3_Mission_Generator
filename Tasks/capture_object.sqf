// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
_buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];
_menArray = missionNamespace getVariable format["ZMM_%1Man", _enemySide];
_locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
_locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

_itemNo = switch (_locType) do {
	case "Airport": { 3 };
	case "NameCityCapital": { 4 };
	case "NameCity": { 2 };
	case "NameVillage": { 1 };
	case "NameLocal": { 1 };
	default { 1 };
};

_missionDesc = [
		"Secure the area around <font color='#0080FF'>%1</font color> then locate and mark the locations of <font color='#00FFFF'>%2 Container(s)</font color> in the area.",
		"Investigate <font color='#0080FF'>%1</font color> by searching the surrounding area and locating <font color='#00FFFF'>%2 Container(s)</font color> somewhere in the area.",
		"<font color='#0080FF'>%1</font color> is occupied by enemy forces, eliminate them and secure the area while identifying the <font color='#00FFFF'>%2 Container(s)</font color>.",
		"Hunt down the locations of <font color='#00FFFF'>%2 Container(s)</font color> somewhere in <font color='#0080FF'>%1</font color>.",
		"Enemy forces have occupied <font color='#0080FF'>%1</font color>, eliminate them and find the <font color='#00FFFF'>%2 Container(s)</font color> in the area.",
		"Locate the <font color='#00FFFF'>%2 Container(s)</font color> hidden somewhere in <font color='#0080FF'>%1</font color>."
	];
	
// Add any missed buildings.
if (count _buildings > 0) then {
	{
		_building = _x;
		if ({_x distance2D _building < 250} count _locations == 0) then {		
				_locations pushBack getPos _building;
		};
	} forEach _buildings;
};

if (count _locations == 0) then {
	_bPos = getPos (nearestBuilding _centre);

	if (_centre distance2D _bPos <= 250) then { 
		_locations pushBack _bPos;
	} else {
		_locations pushBack _centre;
	};
};

// Choose Item Positions
_itemLocs = [];

for [{ _i = 1 }, { _i <= _itemNo && _i <= count _locations }, { _i = _i + 1 }] do {
	_rPos = selectRandom _locations;
	_locations deleteAt (_locations find _rPos);
	
	_emptyPos = _rPos findEmptyPosition [1, 25, "B_Soldier_F"];
	
	if (count _emptyPos == 0) then {
		_itemLocs pushBack _rPos;													
	} else {
		_itemLocs pushBack _emptyPos;
	};
};

_enemyGrp = createGroup [_enemySide, TRUE];
_itemText = [];
_itemActivation = [];
_itemType = "";
_inBuilding = FALSE;

{	
	_itemType = selectRandom ["C_IDAP_supplyCrate_F", "Box_FIA_Ammo_F", "Land_MetalCase_01_large_F", "Land_PlasticCase_01_large_F", "Land_PlasticCase_01_large_gray_F"];
	
	if (_x distance2D nearestBuilding _x < 5) then {
		_inBuilding = TRUE;
		_itemType = selectRandom["Land_MetalCase_01_medium_F", "Land_PlasticCase_01_medium_F", "Land_PlasticCase_01_medium_gray_F", "Land_PlasticCase_01_small_F", "Land_PlasticCase_01_small_gray_F", "Land_MetalCase_01_small_F"];
	};
	
	_item = createVehicle [ _itemType, _x, [], 0, "NONE" ];
	_item allowDamage FALSE;
	_item setVariable [ "var_Number", _forEachIndex, TRUE ];
	_item setVariable [ "var_zoneID", _zoneID, TRUE ];
	
	// Add players action
	[_item, 
		format["<t color='#00FF80'>Mark %1</t>", getText (configFile >> "CfgVehicles" >> _itemType >> "displayName")], 
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_Search_ca.paa",  
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_Search_ca.paa",  
		"TRUE", 
		"TRUE", 
		{}, 
		{}, 
		{ 	
			_itemNo = ( _target getVariable [ "var_Number", 0 ] );
			_zoneID = ( _target getVariable [ "var_zoneID", 0 ] );
			format[ "MKR_%1_ITEM_%2", _zoneID, _itemNo ] setMarkerColor format["Color%1",side player];
			format[ "MKR_%1_ICON_%2", _zoneID, _itemNo ] setMarkerColor format["Color%1",side player];
			missionNamespace setVariable [ format[ "ZMM_%1_ITEM%2", _zoneID, _itemNo ], TRUE];
			[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
			(parseText format["<t size='1.5' color='#72E500'>Item Located:</t><br/><t size='1.25'>%1</t><br/><br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\search_ca.paa'/><br/><br/>Found By: <t color='#0080FF'>%2</t><br/>", getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName"), name _caller]) remoteExec ["hintSilent"]; 
		}, 
		{}, 
		[], 
		5, 
		10 
	] remoteExec ["BIS_fnc_holdActionAdd", 0];

	_itemDist = if (_inBuilding) then { 35 } else { 50 };
	
	_relPos = [ position _item, random _itemDist, random 360 ] call BIS_fnc_relPos;	
	_mrk = createMarker [ format[ "MKR_%1_ITEM_%2", _zoneID, _forEachIndex ], _relPos ];
	_mrk setMarkerPos _relPos;
	_mrk setMarkerShape "ELLIPSE";
	_mrk setMarkerBrush "SolidBorder";
	_mrk setMarkerAlpha 0.5;
	_mrk setMarkerColor format[ "color%1", _enemySide ];
	_mrk setMarkerSize [ _itemDist, _itemDist ];
	
	_mrk = createMarker [ format["MKR_%1_ICON_%2", _zoneID, _forEachIndex ], _relPos ];
	_mrk setMarkerPos _relPos;
	_mrk setMarkerType "mil_unknown";
	_mrk setMarkerAlpha 0.5;
	_mrk setMarkerColor format[ "color%1", _enemySide ];
	_mrk setMarkerSize [ 0.8, 0.8 ];
	
	// Child task
	_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _forEachIndex], format['ZMM_%1_TSK', _zoneID]], TRUE, [format["Search for the object somewhere within the marked area.<br/><br/>Target Object: <font color='#00FFFF'>%1</font><br/><br/><img width='350' image='%2'/>", [getText (configFile >> "CfgVehicles" >> _itemType >> "displayName"),"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- "] call BIS_fnc_filterString, getText (configFile >> "CfgVehicles" >> _itemType >> "editorPreview")], format["Object #%1", _forEachIndex + 1], format["MKR_%1_ICON_%2", _zoneID, _forEachIndex]], nil, "CREATED", 1, FALSE, TRUE, format["move%1", _forEachIndex + 1]] call BIS_fnc_setTask;
	_childTrigger = createTrigger ["EmptyDetector", _centre, false];
	_childTrigger setTriggerStatements [  format["(missionNamespace getVariable ['ZMM_%1_ITEM_%2', FALSE])", _zoneID, _forEachIndex],
									format["['ZMM_%1_SUB_%2', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; 'MKR_%1_ITEM_%2' setMarkerColor 'ColorGrey'; 'MKR_%1_ICON_%2' setMarkerColor 'ColorGrey';", _zoneID, _forEachIndex],
									"" ];
	
	// Build trigger completion.
	_itemActivation pushBack format["(missionNamespace getVariable [ 'ZMM_%1_ITEM_%2', FALSE ])", _zoneID, _forEachIndex];
	
	if (underwater _item) then {
		_item setPosASL [position _item select 0, position _item select 1, 0];
		_item enableSimulationGlobal FALSE;
	} else {
		// Spawn filler objects
		if !_inBuilding then {
			for "_i" from 0 to 1 + random 3 do {
				_sObj = createSimpleObject [selectRandom ["Land_WoodenCrate_01_F", "Land_WoodenCrate_01_stack_x3_F", "Land_WoodenCrate_01_stack_x5_F", "Land_TentA_F", "Land_Pallets_stack_F", "Land_PaperBox_01_open_empty_F", "Land_CratesWooden_F", "Land_Sacks_heap_F"], AGLToASL (_item getPos [2 + random 5, random 360])]; 
				_sObj setDir random 360;
			};
		};
		
		for "_i" from 0 to 1 + random 2 do {
			_unitType = selectRandom _menArray;
			_unit = _enemyGrp createUnit [_unitType, (_item getPos [random 15, random 360]), [], 0, "NONE"];
			[_unit] joinSilent _enemyGrp; 
			doStop _unit;
			_unit setDir ((_item getRelDir _unit) - 180);
			_unit setFormDir ((_item getRelDir _unit) - 180);
			_unit setUnitPos "MIDDLE";
		};
	};
} forEach _itemLocs; 

// Wait before setting DS to allow positions to set.
_enemyGrp spawn { sleep 5; _this enableDynamicSimulation TRUE };

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerStatements [  (_itemActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, count _itemActivation], ["Search"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "AUTOASSIGNED", 1, FALSE, TRUE, "search"] call BIS_fnc_setTask;

TRUE