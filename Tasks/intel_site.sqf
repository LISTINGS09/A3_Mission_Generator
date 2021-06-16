// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _menArray = missionNamespace getVariable format["ZMM_%1Man", _enemySide];
private _missionDesc = [
		"Locate a <font color='#00FFFF'>%1</font> that has been recently acquired by enemy forces. It is somewhere in %3 and contains %2, find and return the %1 safely.",
		"Enemy forces at %3 are known to have come into possession of a <font color='#00FFFF'>%1</font>, containing %2. Find and secure the %1.",
		"Somewhere within %3 a <font color='#00FFFF'>%1</font> with %2 is presently being guarded by enemy forces. Find its location and recover the %1.",
		"Locate and take a <font color='#00FFFF'>%1</font> containing %2 somewhere within %3.",
		"Intel has identified a <font color='#00FFFF'>%1</font>, with %2 that is currently somewhere in %3. Find the %1 and take it.",
		"A Recon Unit has confirmed that the enemy are in possession of a <font color='#00FFFF'>%1</font> with %2. It was last seen being transported into %3, move in and secure the %1."
	];
	
private _intelTypes = selectRandom [
	[	"Laptop", 
		selectRandom ["Land_Laptop_unfolded_F","Land_Laptop_03_black_F","Land_Laptop_03_olive_F","Land_Laptop_03_sand_F","Land_Laptop_02_unfolded_F"], 
		format["%1 on %2", selectRandom ["information", "data", "details", "statistics", "a report", "intelligence", "evidence"], selectRandom ["recent enemy movements", "enemy operating procedures", "nuclear rocket tests"]]
	],
	[	format["%1 %2", selectRandom ["Secret", "Confidential", "Signed"], selectRandom ["Document", "File", "Order"]],
		selectRandom ["Land_Document_01_F","Land_File1_F","Land_FilePhotos_F","Land_File2_F","Land_File_research_F"],
		format["a %1 of %2", selectRandom ["list", "collection", "catalogue", "inventory", "register", "check-list", "source"], selectRandom ["enemy commanders", "escaped prisoners", "nuclear rocket tests", "CBRN incidents", "infected wildlife"]]
	],
	[	selectRandom ["Lined Suitcase", "Secure Case", "Metal Suitcase"],
		selectRandom ["Land_Suitcase_F"],
		selectRandom ["counterfeit money inside", "bars of gold bullion", "a radioactive isotope inside"]
	],
	[	selectRandom ["Lined Case", "Secure Case", "Transport Case"],
		selectRandom ["Land_MetalCase_01_small_F", "Land_PlasticCase_01_small_idap_F"],
		format["a %1 %2", selectRandom ["frozen", "thawing", "freezing", "decaying", "suspended"], selectRandom ["chicken", "monkey", "sample of nuclear waste", "vial of a newly-developed nerve agent"]]
	],
	[	selectRandom ["CBRN Case", "Secure Container", "Sealed CBRN Container"],
		selectRandom ["Land_PlasticCase_01_small_CBRN_F", "Land_PlasticCase_01_small_olive_CBRN_F"],
		format["a %1 %2 inside", selectRandom ["highly-advanced", "newly developed", "futuristic", "captured", "never seen"], selectRandom ["item of filtration equipment", "air conditioning system", "sample from a nearby site of interest"]]
	],
	[	selectRandom ["Small Container", "Sealed Container"],
		selectRandom ["Land_FoodContainer_01_F","Land_FoodContainer_01_White_F"],
		format["%1 of %2", selectRandom ["samples", "bottles", "a flask", "a syringe"], selectRandom ["an unknown nerve agent", "radioactive ants", "antibiotics", "blood"]]
	]
];

_intelTypes params ["_intelName", "_intelType", "_intelCont"];

if (_centre isEqualTo _targetPos || _targetPos isEqualTo [0,0,0]) then { _targetPos = [_centre, 25, 200, 5, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos };

_targetPos = [_zoneID, _targetPos, false, true] call zmm_fnc_areaSite;

// No suitable location nearby
if (_targetPos isEqualTo []) then { _targetPos = _centre };
 
private _foundArr = nearestObjects [_targetPos, ["Land_CampingTable_small_F","Land_CampingTable_small_white_F","Land_CampingTable_F","Land_CampingTable_white_F","Land_WoodenTable_large_F","Land_WoodenTable_small_F","Land_TableBig_01_F","OfficeTable_01_new_F","OfficeTable_01_old_F"], 150, true];

if (count _foundArr > 0) then {
	_targetPos = getPos (_foundArr#0);
	
	private _bbr = boundingBoxReal (_foundArr#0);
	_targetPos set [2, 0.05 + (abs ((_bbr#1#2) - (_bbr#0#2)))];
} else {
	// Site failed to create, spawn some filler
	private _table = createVehicle ["Land_WoodenTable_small_F", _targetPos, [], 0, "NONE"];
	_targetPos = getPos _table;
	
	private _bbr = boundingBoxReal _table;
	_targetPos set [2, 0.05 + (abs ((_bbr#1#2) - (_bbr#0#2)))];
	
	for "_i" from 0 to 1 + random 3 do {
		private _sObj = createSimpleObject [selectRandom ["Land_WoodenCrate_01_F", "Land_WoodenCrate_01_stack_x3_F", "Land_WoodenCrate_01_stack_x5_F", "Land_TentA_F", "Land_Pallets_stack_F", "Land_PaperBox_01_open_empty_F", "Land_CratesWooden_F", "Land_Sacks_heap_F"], AGLToASL (_table getPos [2 + random 5, random 360])]; 
		_sObj setDir random 360;
	};

	private _enemyGrp = createGroup [_enemySide, true];
	for "_i" from 0 to 1 + random 2 do {
		private _unit = _enemyGrp createUnit [selectRandom _menArray, (_table getPos [random 15, random 360]), [], 0, "NONE"];
		[_unit] joinSilent _enemyGrp; 
		_unit disableAI "PATH";
		_unit setDir ((_table getRelDir _unit) - 180);
		_unit setFormDir ((_table getRelDir _unit) - 180);
		_unit setUnitPos "MIDDLE";
		_unit setBehaviour "SAFE";
	};
};

private _itemObj = createVehicle [_intelType, [0,0,0], [], 0, "NONE"];
_itemObj setDir random 360;
_itemObj allowDamage false;
_itemObj setPosATL _targetPos;

missionNamespace setVariable [format["ZMM_%1_OBJ", _zoneID], _itemObj];

if (alive _itemObj) then {
	[_itemObj, 
		format["<t color='#00FF80'>Take %1</t>", getText (configFile >> "CfgVehicles" >> _intelType >> "displayName")], 
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_Search_ca.paa", 
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_Search_ca.paa", 
		"_this distance2d _target < 3", 
		"_caller distance2d _target < 3", 
		{}, 
		{}, 
		{
			_caller playAction "PutDown"; 
			sleep 1;
			deleteVehicle _target;
			(parseText format["<t size='1.5' color='#72E500'>Collected:</t><br/><t size='1.25'>%2</t><br/><br/><img size='2' image='%3'/><br/><br/>Found By: <t color='#0080FF'>%1</t><br/>", name _caller, getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName"), getText (configFile >> "CfgVehicles" >> typeOf _target >> "editorPreview")]) remoteExec ["hintSilent"];
		}, 
		{}, 
		[], 
		2, 
		10 
	] remoteExec ["bis_fnc_holdActionAdd", 0, _itemObj];
	
	{ _x addCuratorEditableObjects [[_itemObj], true] } forEach allCurators;
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [ 	format["!alive ZMM_%1_OBJ", _zoneID], 
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _intelName, _intelCont, _locName] + format["<br/><br/>Intel indicates that there is an small enemy POI located somewhere in this area that houses the %1.<br/><br/>Target Item: <font color='#00FFFF'>%1</font><br/><br/><img width='300' image='%2'/>", getText (configFile >> "CfgVehicles" >> _intelType >> "displayName"), getText (configFile >> "CfgVehicles" >> _intelType >> "editorPreview")], ["Site"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "radio"] call BIS_fnc_setTask;

true