// Set-up mission variables.
// TODO Spawn some bunkers?
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyMen = missionNamespace getVariable [format["ZMM_%1Man", _enemySide], ["O_Solider_F"]];
private _playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
private _locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
private _buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = selectRandom [
		"Secure the area around <font color='#0080FF'>%1</font color> then locate and capture the <font color='#00FFFF'>%2 flag%3</font color> in the area.",
		"Capture <font color='#0080FF'>%1</font color> by claiming the surrounding area and locating the <font color='#00FFFF'>%2 flag%3</font color> somewhere in the area.",
		"<font color='#0080FF'>%1</font color> is occupied by enemy forces, eliminate them and secure the area by claiming the <font color='#00FFFF'>%2 flag%3</font color>.",
		"Claim the <font color='#00FFFF'>%2 flag%3</font color> located somewhere in <font color='#0080FF'>%1</font color> after you have eliminated all enemy forces there.",
		"Enemy forces have occupied <font color='#0080FF'>%1</font color>, eliminate them and claim the <font color='#00FFFF'>%2 flag%3</font color> in the area.",
		"Locate the <font color='#00FFFF'>%2 flag%3</font color> somewhere in <font color='#0080FF'>%1</font color> after you have liberated it from enemy forces."
	];
	
// Add any missed buildings.
if (count _buildings > 0) then {
	{
		private _building = _x;
		if ({_x distance2D _building < 250} count _locations == 0) then {		
				_locations pushBack getPos _building;
		};
	} forEach _buildings;
};

private _zmm_getFlag = {
	// Gets a flags object and texture from variable or assigns default.
	params [ "_flagSide", "_getTexture" ];
	
	_defaultFlag = switch ( _flagSide ) do { 
		case WEST: { ["Flag_Blue_F", "\A3\Data_F\Flags\Flag_Blue_CO.paa"]}; 
		case EAST: { ["Flag_Red_F", "\A3\Data_F\Flags\Flag_Red_CO.paa"]}; 
		case INDEPENDENT: { ["Flag_Green_F", "\A3\Data_F\Flags\Flag_Green_CO.paa"]}; 
		default { ["Flag_White_F", "\A3\Data_F\Flags\Flag_White_CO.paa"]};
	};
		
	_flagVar = missionNamespace getVariable [ format[ "ZMM_%1Flag", _flagSide ], _defaultFlag ];
	
	// Return Texture
	if (_getTexture) exitWith { _flagVar select 1 };
	
	// Return Model
	_flagVar select 0
};

private _enemyGrp = createGroup [_enemySide, true];
private _flagNo = 0;
private _flagType = [ _enemySide, false ] call _zmm_getFlag;
private _flagPTex = [ _playerSide, true ] call _zmm_getFlag;
private _flagActivation = [];

for "_i" from 1 to (missionNamespace getVariable ["ZZM_ObjectiveCount", 3]) do {
	private _flagPos = [];

	if (count _locations > 0) then { 
		_flagPos = selectRandom _locations;
		_locations deleteAt (_locations find _flagPos);
	} else { 
		_flagPos = [[_centre, 100 + random 150, random 360] call BIS_fnc_relPos, 1, _radius, 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
	};
		
	_flagPos = _flagPos findEmptyPosition [1, 15, _flagType];
		
	if (count _flagPos > 0) then {
		_flagNo = _flagNo + 1;
		private _flagObj = createVehicle [ _flagType, _flagPos, [], 5, "NONE" ];
		_flagObj allowDamage false;
		_flagObj setVariable [ "var_number", _flagNo, true ];
		_flagObj setVariable [ "var_zoneID", _zoneID, true ];
		_flagObj setVariable [ "var_texture", _flagPTex, true ];

		[_flagObj, 
			"<t color='#00FF80'>Capture Flag</t>", 
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestleadership_ca.paa",
			"!(_target getVariable ['var_claimed', false]) && _this distance2d _target < 5", 
			"!(_target getVariable ['var_claimed', false]) && _caller distance2d _target < 5", 
			{}, 
			{}, 
			{ 	[ _target, _target getVariable ["var_texture", "\A3\Data_F\Flags\Flag_White_CO.paa"]] remoteExec ['setFlagTexture', 2];
				private _flagNo = _target getVariable ["var_number", 0];
				private _zoneID = _target getVariable ["var_zoneID", 0];
				_target setVariable ['var_claimed', true, true];
				missionNamespace setVariable [ format["ZMM_%1_FLAG_%2", _zoneID, _flagNo], true, true ];
				[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
			}, 
			{}, 
			[], 
			5, 
			10 
		] remoteExec ["bis_fnc_holdActionAdd", 0, _flagObj];
			
		_flagActivation pushBack format["(missionNamespace getVariable ['ZMM_%1_FLAG_%2', false])", _zoneID, _flagNo];
		
		_relPos = [ position _flagObj, random 75, random 360 ] call BIS_fnc_relPos;
		
		_mrk = createMarker [ format[ "MKR_%1_FLAG_%2", _zoneID, _flagNo ], _relPos ];
		_mrk setMarkerShape "ELLIPSE";
		_mrk setMarkerBrush "SolidBorder";
		_mrk setMarkerAlpha 0.5;
		_mrk setMarkerColor format[ "color%1", _enemySide ];
		_mrk setMarkerSize [ 75, 75 ];
		
		// Child task
		private _childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _flagNo], format['ZMM_%1_TSK', _zoneID]], true, ["Find and capture the flag located somewhere within the marked area.", format["Flag #%1", _flagNo], format["MKR_%1_FLAG_%2", _zoneID, _flagNo]], _relPos, "CREATED", 1, false, true, format["move%1", _flagNo]] call BIS_fnc_setTask;
		_childTrigger = createTrigger ["EmptyDetector", _centre, false];
		_childTrigger setTriggerStatements [  format["(missionNamespace getVariable [ 'ZMM_%1_FLAG_%2', false ])", _zoneID, _flagNo],
										format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_FLAG_%2';", _zoneID, _flagNo],
										"" ];
		
		if (surfaceIsWater _relPos) then {
			_flagObj setPosASL [position _flagObj select 0, position _flagObj select 1, 0];
			_flagStone = createSimpleObject [ "Land_W_sharpStone_02", [0,0,0] ];
			_flagStone setPosASL [ getMarkerPos _flagMarker select 0, (getMarkerPos _flagMarker select 1) - 5, -1 ];
		} else {
			// Spawn filler objects
			for "_i" from 0 to 1 + random 3 do {
				_sObj = createSimpleObject [selectRandom ["Land_WoodenCrate_01_F", "Land_WoodenCrate_01_stack_x3_F", "Land_WoodenCrate_01_stack_x5_F", "Land_TentA_F", "Land_Pallets_stack_F", "Land_PaperBox_01_open_empty_F", "Land_CratesWooden_F", "Land_Sacks_heap_F"], AGLToASL (_flagObj getPos [2 + random 5, random 360])]; 
				_sObj setDir random 360;
			};
			
			// Create enemy Team
			private _enemyTeam = [];
			for "_j" from 0 to (3 * (missionNamespace getVariable ["ZZM_Diff", 1])) do { _enemyTeam set [_j, selectRandom _enemyMen] };
			
			private _milGroup = [_flagObj getPos [random 10, random 360], _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;
			
			{
				_x setVehiclePosition [_flagObj getPos [10 + random 5, random 360], [], 0, "NONE"];
				_x disableAI "PATH";
				_x setDir ((_flagObj getRelDir _x) - 180);
				_x setFormDir ((_flagObj getRelDir _x) - 180);
				_x setBehaviour "SAFE";
				_x setUnitPos "MIDDLE";
			} forEach units _milGroup;

			{ _x addCuratorEditableObjects [[_flagObj] + units _milGroup, true] } forEach allCurators;
			
			// Wait before setting DS to allow positions to set.
			_milGroup spawn { sleep 5; _this enableDynamicSimulation true };
		};
	};
}; 

// Wait before setting DS to allow positions to set.
_enemyGrp spawn { sleep 5; _this enableDynamicSimulation true };

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerStatements [  (_flagActivation joinString " && "), 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _objTrigger, true];
[_objTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _objTrigger];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_missionDesc, _locName, count _flagActivation, if (count _flagActivation > 1) then {"s"} else {""}], ["Capture"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "attack"] call BIS_fnc_setTask;

true