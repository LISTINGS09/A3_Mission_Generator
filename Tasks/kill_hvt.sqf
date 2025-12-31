// v1.0 - kill_hvt
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]], ["_bld", objNull] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _enemyMen = missionNamespace getVariable [format["ZMM_%1Man", _enemySide], ["O_Solider_F"]];
private _buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], []];
private _locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];

private _missionDesc = selectRandom [
		"Locate and eliminate <font color='#00FFFF'>El %2</font> and any of their nearby %3.<br/><br/>They can be found nearby %1 within the marked location.",
		"An Officer identified as <font color='#00FFFF'>The %2</font> has been spotted entering the area near %1, they must be eliminated along with any of their %3.",
		"There is an enemy insurgent known as <font color='#00FFFF'>The %2</font>.<br/><br/>The %2 is trying to leave %1 and is awaiting extraction from this location, they must be tracked down and eliminated along with any of their %3.",
		"Find and eliminate <font color='#00FFFF'>%2</font> and any of their %3. They are hiding somewhere in or near %1.",
		"A local known as <font color='#00FFFF'>The %3</font> has been identified.<br/><br/>They have been seen moving around the area outside %1, find them and kill the leader and all their %3.",
		"A high-ranking Officer until only identified as <font color='#00FFFF'>La %3</font> has been confirmed to be somewhere in the area near %1, ensure they are eliminated along with any of their %3."
	];
	
// Overwrite building if present.
if (!isNull _bld) then { _buildings = [_bld] }; 
	
// Find a building position in each building.
private _bldPos = _buildings apply { selectRandom (_x buildingPos -1) };

// Merge all locations
{ _locations pushBack position _x } forEach _buildings;

private _activation = [];
private _counter = 0;
private _hat = selectRandom (["H_Beret_blk","H_Beret_CSAT_01_F","H_Beret_gen_F","H_Beret_EAF_01_F"] select { isClass (configFile >> "CfgWeapons" >> _x) });
private _alias = selectRandom ["Butcher", "Diablo", "Doctor", "Reaper", "Scorpion", "Hyena", "Jackal", "Lion", "Serpent"];
private _team = selectRandom ["Henchmen", "Generals", "Commandos", "Sympathisers", "Associates", "Bodyguards", "Protectors", "Guards"];
	
for "_i" from 1 to (missionNamespace getVariable ["ZZM_ObjectiveCount", 3]) do {
	// Create HVT Team
	private _pos = [];
	private _inBuilding = false;
	private _enemyTeam = [];
	for "_j" from 0 to (3 * (missionNamespace getVariable ["ZZM_Diff", 1])) do { _enemyTeam set [_j, selectRandom _enemyMen] };

	private _milGroup = [([_centre, 1, 150, 2, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos), _enemySide, _enemyTeam] call BIS_fnc_spawnGroup;

	if (random 100 > 50 && {count _bldPos > 0}) then {
		_inBuilding = true;
		_pos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _pos);
	} else {
		if (count _locations > 0) then { 
			_pos = selectRandom _locations;
			_locations deleteAt (_locations find _pos);
		} else { 
			_pos = [_centre getPos [50 + random _radius, random 360], 1, _radius, 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
		};
		
		_pos = _pos findEmptyPosition [1, 50, "B_Soldier_F"];
	};
	
	private _bldArr = if (_inBuilding) then { (nearestBuilding _pos) buildingPos -1 } else { [] };
	_bldArr deleteAt (_bldArr find _pos);

	{
		if (leader _x == _x) then {
			// HVT Target
			_x setPosATL _pos;
			_x addHeadGear _hat;
			_x addGoggles "G_Aviator";
			_x unlinkItem (hmd _x);
			_x setSkill 0.5 + random 0.3;
			_x setUnitPos "MIDDLE";
			_x setVariable ["var_zoneID", _zoneID, true];
			_x setVariable ["var_unitID", _i, true];
			removeFromRemainsCollector [_x];

			
			if (_inBuilding) then { _x disableAI "PATH" };
			
			_x addEventHandler ["Killed", {
				params ["_unit", "_killer"];
				private _zID = _unit getVariable ["var_zoneID", 0];
				private _uID = _unit getVariable ["var_unitID", 0];
				
				private _mrkr = createMarker [format["MKR_%1_LOC_%2", _zID, _uID], getPos _unit];
				_mrkr setMarkerShape "ICON";
				_mrkr setMarkerType "mil_unknown";
				_mrkr setMarkerAlpha 0.4;
				_mrkr setMarkerColor format["Color%1", side group _unit];
			}];
					
			// Create Completion Action
			[_x, 
				format["<t color='#00FF80'>Verify identify of %1</t>", name _x], 
				"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_forceRespawn_ca.paa", 
				"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_forceRespawn_ca.paa", 
				"_this distance2d _target < 3 && !alive _target", 
				"_caller distance2d _target < 3 && !alive _target", 
				{}, 
				{}, 
				{
					[_target, _actionId] remoteExec ["BIS_fnc_holdActionRemove"];
					_caller playAction "PutDown";
					sleep 1;
					private _zID = _target getVariable ["var_zoneID", 0];
					private _uID = _target getVariable ["var_unitID", 0];
					deleteMarker format["MKR_%1_OBJ_%2", _zID, _uID];
					deleteMarker format["MKR_%1_LOC_%2", _zID, _uID];
					[name _caller, format["Target %1 is %2.", selectRandom ["verified", "confirmed", "identified"], selectRandom ["eliminated","deceased","dead","killed"]]] remoteExec ["BIS_fnc_showSubtitle"];
					addToRemainsCollector [_target];
					
					missionNamespace setVariable [format["ZMM_%1_OBJ_%2_DONE", _zID, _uID], true, true];
				}, 
				{}, 
				[], 
				2, 
				10 
			] remoteExec ["bis_fnc_holdActionAdd", 0, _x];
		} else {
			// HVT Guards - Move nearby or in building
			if (count _bldArr > 0) then {
				private _tempPos = selectRandom _bldArr;
				_bldArr deleteAt (_bldArr find _tempPos);
				_x setPosATL _tempPos;
				_x disableAI "PATH";
			} else {
				_x setVehiclePosition [leader _x getPos [random 10, random 360], [], 0, "NONE"];
				_x setUnitPos "MIDDLE";
				_x setDir (leader _x getRelDir getPos _x);
				doStop _x;
			};
		};
	} forEach units _milGroup;
	
	private _mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], leader _milGroup getPos [random 50, random 360]];
	_mrkr setMarkerShape "ELLIPSE";
	_mrkr setMarkerBrush "SolidBorder";
	_mrkr setMarkerSize [100,100];
	_mrkr setMarkerAlpha 0.4;
	_mrkr setMarkerColor format["Color%1",_enemySide];
	
	// Child task
	_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Eliminate the target within the marked area.<br/><br/>Target: <font color='#00FFFF'>%1</font><br/><br/>", name leader _milGroup], format["HVT #%1", _i], format["MKR_%1_OBJ_%2", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["move%1", _i]] call BIS_fnc_setTask;
	_childTrigger = createTrigger ["EmptyDetector", _centre, false];
	_childTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
	_childTrigger setTriggerStatements [  format["(missionNamespace getVariable ['ZMM_%1_OBJ_%2_DONE', false])", _zoneID, _i],
		format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_OBJ_%2';", _zoneID, _i],
		"" ];
	
	_activation pushBack format["(missionNamespace getVariable ['ZMM_%1_OBJ_%2_DONE', false])", _zoneID, _i];

	// Add to Zeus
	{ _x addCuratorEditableObjects [units _milGroup, true] } forEach allCurators;
};

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [  (_activation joinString " && "), 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _objTrigger, true];
[_objTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _objTrigger];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_missionDesc + format["<br/><br/>You will need to verify the identity of any target when eliminated. Each target is known to be wearing a <font color='#00FFFF'>%1</font>.<br/><br/><img image='%2' width='60'/>", getText (configFile >> "CfgWeapons" >> _hat >> "displayName"), getText (configFile >> "CfgWeapons" >> _hat >> "picture")], _locName, _alias, _team], ["Killer"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "target"] call BIS_fnc_setTask;

true