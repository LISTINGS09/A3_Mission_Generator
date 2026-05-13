// Set-up mission variables.
params [ ["_zoneID", 0], ["_tskPos", [0,0,0]] ];

private _tskCentre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _tskPos];
private _buildings = missionNamespace getVariable [format["ZMM_%1_Buildings", _zoneID], []];
private _locations = missionNamespace getVariable [format["ZMM_Z%1_FlatLocations", _zoneID], []];
private _tskRadius = ((getMarkerSize format["MKR_Z%1_MIN", _zoneID])#0) max 100; // Area of Zone.
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _tskDesc = selectRandom [
		"Hunt down <font color='#00FFFF'>%1 Animals</font> that have been %2 somewhere within %3.",
		"Around %3 are <font color='#00FFFF'>%1 Animals</font> that are suspected of being %2, locate and terminate them.",
		"Local wildlife has been %2 by enemy forces near %3, eliminate <font color='#00FFFF'>%1 Animals</font>.",
		"Within %3, a group of animals have been %2. Locate the <font color='#00FFFF'>%1 Animals</font> and neutralise them before they become a significant threat.",
		"Locate <font color='#00FFFF'>%1 Animals</font> that were last seen in %3. They are known to have been %2 and must be destroyed.",
		"Travel to %3, track down <font color='#00FFFF'>%1 Animals</font> and eliminate them. They likely have been %2 by enemy forces."
	];

// Find one building position.
private _bldPos = _buildings apply { selectRandom (_x buildingPos -1) };

// Merge all locations
{ _locations pushBack position _x } forEach _buildings;

private _tskActivation = [];
private _aniNo = missionNamespace getVariable ["ZZM_ObjectiveCount", 3];
private _aniType = selectRandom ["Cock_random_F","Hen_random_F","Goat_random_F","Sheep_random_F"];
private _aniPrefix = selectRandom ["infected with a brain parasite","used for chemical testing","marked for organ harvesting","poisoned with a radioactive isotope","used to smuggle weapons into the region","placed to infect other livestock"];

// Generate the crates.
for "_i" from 1 to (_aniNo + 2) do {
	
	private _aniPos = [];

	if (random 100 > 75 && {count _bldPos > 0}) then {
		_aniPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _aniPos);
	} else {
		if (count _locations > 0) then { 
			_aniPos = selectRandom _locations;
			_locations deleteAt (_locations find _aniPos);
		} else { 
			_aniPos = [_tskCentre getPos [50 + random 100, random 360], 1, _tskRadius, 1, 0, 0.5, 0, [], [ _tskCentre, _tskCentre ]] call BIS_fnc_findSafePos;
		};
		
		_aniPos = _aniPos findEmptyPosition [1, 50, _aniType];
	};
	
	if (count _aniPos > 0) then { 		
		private _aniObj = createAgent [_aniType, [0,0,0], [], 0, "NONE"];
		_aniObj setPosATL _aniPos;
		_aniObj setDir random 360;
		
		missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _i], _aniObj, true];
		_tskActivation pushBack format["(missionNamespace getVariable ['ZMM_%1_OBJ_%2', objNull])", _zoneID, _i];
	};
};

if (_tskActivation isEqualTo []) exitWith {
	["ERROR", format["Zone %1 failed to generate objectives", _zoneID]] call zmm_fnc_misc_logMsg;
	false
};

// Create Completion Trigger
private _tskTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_tskTrigger setTriggerStatements [  format["{ !alive _x } count [%1] >= %2", (_tskActivation joinString ","), _aniNo], 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_Z%1_LOC','MKR_Z%1_MIN']", _zoneID, ZMM_playerSide],
	"" ];

missionNamespace setVariable [format['TR_%1_TASK_DONE', _zoneID], _tskTrigger, true];
[_tskTrigger, format['TR_%1_TASK_DONE', _zoneID]] remoteExec ["setVehicleVarName", 0, _tskTrigger];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[_tskDesc + "<br/><br/>Target Animal: <font color='#00FFFF'>%4</font><br/>", count _tskActivation, _aniPrefix, _locName, getText (configFile >> "CfgVehicles" >> _aniType >> "displayName")], ["Hunt"] call zmm_fnc_nameGen, format["MKR_Z%1_LOC", _zoneID]], _tskCentre, "CREATED", 1, false, true, "target"] call BIS_fnc_setTask;

true