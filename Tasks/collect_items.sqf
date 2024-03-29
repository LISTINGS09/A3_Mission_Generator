// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _buildings = missionNamespace getVariable [format["ZMM_%1_Buildings", _zoneID], []];
private _locations = missionNamespace getVariable [format["ZMM_%1_FlatLocations", _zoneID], []];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = selectRandom [
		"Collect <font color='#00FFFF'>%1 %2 Supplies</font> that were recently left by enemy forces in %3.",
		"Search %3 for <font color='#00FFFF'>%1 %2 Supplies</font> left around the area by enemy forces.",
		"Allied forces were forced to quickly withdraw from %3, leaving <font color='#00FFFF'>%1 %2 Supplies</font>. Enter the area and recover the items.",
		"Enemy forces ambushed a convoy travelling though %3, transporting <font color='#00FFFF'>%1 %2 Supplies</font>. Locate and recover the items.",
		"Locate <font color='#00FFFF'>%1 %2 Supplies</font> that have been hidden somewhere around %3.",
		"Retrieve <font color='#00FFFF'>%1 %2 Supplies</font> that have been hidden by enemy forces somewhere around %3."
	];

private _itemMax = missionNamespace getVariable ["ZZM_ObjectiveCount", 4];

// Find one building position.
private _bldPos = _buildings apply { selectRandom (_x buildingPos -1) };

// Merge all locations
{ _locations pushBack position _x } forEach _buildings;

(selectRandom [
	["Aid",["Land_PaperBox_01_small_closed_brown_IDAP_F","Land_PaperBox_01_small_closed_white_med_F","Land_PaperBox_01_small_closed_white_IDAP_F","Land_PaperBox_01_small_closed_brown_food_F","Land_FoodSack_01_full_white_idap_F","Land_FoodSack_01_full_brown_idap_F","Land_PlasticCase_01_small_idap_F"]]
	,["Refugee",["Land_WaterBottle_01_pack_F","Land_FoodContainer_01_White_F","Land_PlasticBucket_01_closed_F","Land_Sleeping_bag_folded_F","Land_CanisterPlastic_F","Land_Ground_sheet_folded_yellow_F","Land_Ground_sheet_folded_blue_F","Land_Sleeping_bag_blue_folded_F","Land_EmergencyBlanket_02_stack_F","Land_EmergencyBlanket_01_stack_F"]]
	,["Fuel",["Land_GasTank_01_blue_F","Land_GasTank_01_yellow_F","Land_GasTank_01_khaki_F","Land_CanisterFuel_F","Land_CanisterFuel_Red_F","Land_CanisterFuel_Blue_F","Land_CanisterFuel_White_F"]]
	,["CBRN",["CBRNCase_01_F","CBRNContainer_01_closed_olive_F","CBRNContainer_01_closed_yellow_F","Land_PlasticCase_01_small_CBRN_F","Land_PlasticCase_01_small_black_CBRN_F","Land_PlasticCase_01_small_olive_CBRN_F"]]
]) params ["_itemName","_itemArr"];

private _itemTask = "<br/><br/>Search for any of the following items Located in the Area:";
{
	_itemTask = _itemTask + format["<br/><br/>%1:<br/><img width='200' image='%2'/>", getText (configFile >> "CfgVehicles" >> _x >> "displayName"), getText (configFile >> "CfgVehicles" >> _x >> "editorPreview")];
} forEach _itemArr;

private _itemCount = 0;

// Generate the crates.
for "_i" from 1 to (_itemMax + 3) do {
	private _itemType = selectRandom _itemArr;
	private _itemPos = [];

	if (random 100 > 25 && {count _bldPos > 0}) then {
		_itemPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _itemPos);
	} else {
		if (count _locations > 0) then { 
			_itemPos = selectRandom _locations;
			_locations deleteAt (_locations find _itemPos);
		} else { 
			_itemPos = [_centre getPos [50 + random 100, random 360], 1, _radius, 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
		};
		
		_itemPos = _itemPos findEmptyPosition [1, 50, _itemType];
	};
		
	if (count _itemPos > 0) then {		
		_itemCount = _itemCount + 1;
		_itemObj = createVehicle [_itemType, [0,0,0], [], 0, "NONE"];
		_itemObj setPosATL _itemPos;
		_itemObj setDir random 360;
			
		// If the item was moved safely, create the task.
		if (alive _itemObj) then {
			_itemObj setVariable ["var_zoneID", _zoneID, true];

			[_itemObj, 
				format["<t color='#00FF80'>Take %1</t>", getText (configFile >> "CfgVehicles" >> _itemType >> "displayName")], 
				"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_Search_ca.paa", 
				"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_Search_ca.paa", 
				"_this distance2d _target < 3", 
				"_caller distance2d _target < 3", 
				{}, 
				{}, 
				{
					_varName = format["ZMM_%1_TSK_Counter", (_target getVariable ["var_zoneID", 0])];
					missionNamespace setVariable [_varName, (missionNamespace getVariable [_varName, 0]) + 1, true];
					_caller playAction "PutDown"; 
					sleep 1;
					deleteVehicle _target;
					(parseText format["<t size='1.5' color='#72E500'>Item Collected:</t><br/><t size='1.25'>%2</t><br/><br/><img size='2' image='\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\search_ca.paa'/><br/><br/>Found By: <t color='#0080FF'>%1</t><br/>Total Collected: <t color='#FF7F00'>%3</t>", name _caller, getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName"), missionNamespace getVariable _varName]) remoteExec ["hintSilent"];
				}, 
				{}, 
				[], 
				2, 
				10 
			] remoteExec ["bis_fnc_holdActionAdd", 0, _itemObj];
		};
	};
};

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [  format["(missionNamespace getVariable ['ZMM_%1_TSK_Counter',0]) >= %2", _zoneID, _itemMax], 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _objTrigger, true];
[_objTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _objTrigger];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_missionDesc, _itemMax, _itemName, _locName] + _itemTask, ["Item Hunt"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "box"] call BIS_fnc_setTask;

true