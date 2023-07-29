// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _buildings = missionNamespace getVariable [format["ZMM_%1_Buildings", _zoneID], []];
private _locations = missionNamespace getVariable [format["ZMM_%1_FlatLocations", _zoneID], []];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = selectRandom [
		"Locate and speak to <font color='#00FFFF'>%1 Undercover Informants</font> with information on %2 within %3.",
		"Search around %3 for <font color='#00FFFF'>%1 Contacts</font> regarding %2.",
		"Allied forces wish to identify %2 near %3, speak to <font color='#00FFFF'>%1 Civilians</font> and obtain their intel.",
		"Undercover civilians within %3, are investigating %2. Locate <font color='#00FFFF'>%1 Civilians</font> and speak to them to discover their findings.",
		"Locate <font color='#00FFFF'>%1 Informants</font> around %3, that have information on %2.",
		"Around %3, find <font color='#00FFFF'>%1 Contacts</font> that have information on %2."
	];
	
private _civInfo = selectRandom ["nearby Munitions Caches", "possible Chemical Weapons", "an enemy HQ", "enemy movements", "an underground bunker", "a planned ambush"];

// Find a random building position.
private _bldPos = _buildings apply { selectRandom (_x buildingPos -1) };

// Merge all locations
{ _locations pushBack position _x } forEach _buildings;

private _civCount = 0;

// Generate the crates.
for "_i" from 1 to (missionNamespace getVariable ["ZZM_ObjectiveCount", 3]) do {
	private _civType = selectRandom ["C_man_polo_1_F_afro","C_man_polo_3_F_afro","C_man_polo_6_F_afro","C_man_polo_2_F_euro","C_man_polo_4_F_euro","C_man_polo_5_F_asia"];
	private _civPos = [];
	
	if (random 100 > 50 && {count _bldPos > 0}) then {
		_civPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _civPos);
		_contType = selectRandom ["Box_NATO_Wps_F","Box_EAF_Wps_F","Box_East_Wps_F","Box_T_East_Wps_F","Box_IND_Wps_F"];
	} else {
		if (count _locations > 0) then { 
			_civPos = selectRandom _locations;
			_locations deleteAt (_locations find _civPos);
		} else { 
			_civPos = [_centre getPos [50 + random _radius, random 360], 1, _radius, 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
		};
		
		_civPos = _civPos findEmptyPosition [1, 50, _civType];
	};

	if (count _civPos > 0) then {		
		_civCount = _civCount + 1;
		private _civObj = createAgent [_civType, [0,0,0], [], 0, "NONE"];
		_civObj setVariable ["BIS_fnc_animalBehaviour_disable", true];
		_civObj setPosATL _civPos;
		_civObj setDir random 360;
		_civObj allowDamage false;
			
		// If the crate was moved safely, create the task.
		if (alive _civObj) then {
			private _mrkr = createMarker [format["MKR_%1_OBJ_%2", _zoneID, _i], _civObj getPos [random 50, random 360]];
			_mrkr setMarkerShape "ELLIPSE";
			_mrkr setMarkerBrush "SolidBorder";
			_mrkr setMarkerSize [50,50];
			_mrkr setMarkerAlpha 0.4;
			_mrkr setMarkerColor "ColorCivilian";
			
			_civObj setVariable ["var_zoneID", _zoneID, true];
			_civObj setVariable ["var_itemID", _i, true];
			
			_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Speak to the civilian somewhere within the marked area.<br/><br/>Contact: <font color='#00FFFF'>%1</font><br/><br/><img width='350' image='%2'/>", name _civObj, getText (configFile >> "CfgVehicles" >> _civType >> "editorPreview")], format["Person #%1", _i], format["MKR_%1_OBJ_%2", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["talk%1", _i]] call BIS_fnc_setTask;

			[_civObj, 
				format["<t color='#00FF80'>Speak to %1</t>", name _civObj], 
				"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_requestleadership_ca.paa", 
				"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_requestleadership_ca.paa", 
				"_this distance2d _target < 3", 
				"_caller distance2d _target < 3", 
				{}, 
				{}, 
				{
					private _zoneID = _target getVariable ["var_zoneID", 0];
					private _itemID = _target getVariable ["var_itemID", 0];
					private _varName = format["ZMM_%1_TSK_Counter", _zoneID];
					missionNamespace setVariable [_varName, (missionNamespace getVariable [_varName, 0]) + 1, true];
					deleteMarker format["MKR_%1_OBJ_%2", _zoneID, _itemID];
					[_target, _actionId] remoteExec ["BIS_fnc_holdActionRemove"];
									
					[name _target, 
						format[ selectRandom ["Yes, here is the %1 you need.",
							"OK, I will leave the %1 with the usual contact.",
							"No, but I will give you the %1 in two days.",
							"The %1 has already been left with another Operative, I have nothing more for you.",
							"I hid the %1 to stop it from falling into enemy hands, here it is."], selectRandom ["information","papers","drive","documents","recording","intelligence"]]
					] remoteExec ["BIS_fnc_showSubtitle"];
					sleep 3;
					[_target, [_target getPos [500, random 360], "LEADER PLANNED", true]] remoteExec ["setDestination", _target];
					[_target, { sleep 120; deleteVehicle _this }] remoteExec ["BIS_fnc_spawn", _target];
					[format["ZMM_%1_SUB_%2", _zoneID, _itemID], 'Succeeded', true] remoteExec ["BIS_fnc_taskSetState"];
				}, 
				{}, 
				[], 
				2, 
				10 
			] remoteExec ["bis_fnc_holdActionAdd", 0, _civObj];
		};
	};
};

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [  format["(missionNamespace getVariable ['ZMM_%1_TSK_Counter',0]) >= %2", _zoneID, _civCount], 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _objTrigger, true];
[_objTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _objTrigger];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_missionDesc, _civCount, _civInfo, _locName], ["Talk"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "talk"] call BIS_fnc_setTask;

true