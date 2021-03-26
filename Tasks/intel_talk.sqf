// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _buildings = missionNamespace getVariable [format["ZMM_%1_Buildings", _zoneID], []];
private _locations = missionNamespace getVariable [format["ZMM_%1_FlatLocations", _zoneID], []];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = [
		"Locate and speak to <font color='#00FFFF'>%1 Undercover Informants</font> with information on %2 within %3.",
		"Search around %3 for <font color='#00FFFF'>%1 Contacts</font> regarding %2.",
		"Allied forces wish to identify %2 near %3, speak to <font color='#00FFFF'>%1 Civilians</font> and obtain their intel.",
		"Undercover civilians within %3, are investigating %2. Locate <font color='#00FFFF'>%1 Civilians</font> and speak to them to discover their findings.",
		"Locate <font color='#00FFFF'>%1 Informants</font> around %3, that have information on %2.",
		"Around %3, find <font color='#00FFFF'>%1 Contacts</font> that have information on %2."
	];
	
private _civInfo = selectRandom ["nearby Munitions Caches", "possible Chemical Weapons", "an enemy HQ", "enemy movements", "an underground bunker", "a planned ambush"];

private _talkMax = switch (_locType) do {
	case "Airport": { 3 };
	case "NameCityCapital": { 3 };
	case "NameCity": { 2 };
	case "NameVillage": { 2 };
	case "NameLocal": { 2 };
	default { 1 };
};

// Find a random building position.
private _positions = [];
{ _positions pushBack (selectRandom (_x buildingPos -1)) } forEach _buildings;

// Add locations if there is not enough building positions
if (count _positions < _talkMax) then {
	{ _positions pushBack _x } forEach _locations;
};

// Create locations if none exist
if (_positions isEqualTo []) then {
	for "_i" from 0 to (_talkMax) do {
		_positions pushBack (_centre getPos [25 + random 50, random 360]);
	};
};

private _civCount = 0;

// Generate the crates.
for "_i" from 1 to (_talkMax) do {
	if (_positions isEqualTo []) exitWith {};

	private _civType = selectRandom ["C_man_polo_1_F_afro","C_man_polo_3_F_afro","C_man_polo_6_F_afro","C_man_polo_2_F_euro","C_man_polo_4_F_euro","C_man_polo_5_F_asia"];
	private _civPos = selectRandom _positions;
	_positions deleteAt (_positions find _civPos);

	if (count _civPos > 0) then { 
		// If not in a building find an empty position.
		if (_civPos#2 == 0) then { _civPos = _civPos findEmptyPosition [1, 25, "B_Soldier_F"] };
		
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
			
			_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _i], format['ZMM_%1_TSK', _zoneID]], true, [format["Speak to the civilian somewhere within the marked area.<br/><br/>Contact: <font color='#00FFFF'>%1</font><br/><br/><img width='350' image='%2'/>", name _civObj, getText (configFile >> "CfgVehicles" >> _civType >> "editorPreview")], format["Person #%1", _i], format["MKR_%1_%2_OBJ", _zoneID, _i]], getMarkerPos _mrkr, "CREATED", 1, false, true, format["talk%1", _i]] call BIS_fnc_setTask;

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
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _civCount, _civInfo, _locName], ["Talk"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "talk"] call BIS_fnc_setTask;

true