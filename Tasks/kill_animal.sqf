// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
private _buildings = missionNamespace getVariable [format["ZMM_%1_Buildings", _zoneID], []];
private _locations = missionNamespace getVariable [format["ZMM_%1_FlatLocations", _zoneID], []];
private _locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
private _locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

private _missionDesc = [
		"Hunt down <font color='#00FFFF'>%1 Animals</font> that have been %2 somewhere within %3.",
		"Around %3 are <font color='#00FFFF'>%1 Animals</font> that are suspected of being %2, locate and terminate them.",
		"Local wildlife has been %2 by enemy forces near %3, eliminate <font color='#00FFFF'>%1 Animals</font>.",
		"Within %3, a group of animals have been %2. Locate the <font color='#00FFFF'>%1 Animals</font> and neutralise them before they become a significant threat.",
		"Locate <font color='#00FFFF'>%1 Animals</font> that were last seen in %3. They are known to have been %2 and must be destroyed.",
		"Travel to %3, track down <font color='#00FFFF'>%1 Animals</font> and eliminate them. They likely have been %2 by enemy forces."
	];

private _aniMax = switch (_locType) do {
	case "Airport": { 4 };
	case "NameCityCapital": { 5 };
	case "NameCity": { 4 };
	case "NameVillage": { 3 };
	case "NameLocal": { 3 };
	default { 3 };
};

// Find a random building position.
private _positions = [];
{ _positions pushBack (selectRandom (_x buildingPos -1)) } forEach _buildings;

// Add locations if there is not enough building positions
if (count _positions < _aniMax) then {
	{ _positions pushBack _x } forEach _locations;
};

// Create locations if none exist
if (_positions isEqualTo []) then {
	for "_i" from 0 to (_aniMax) do {
		_positions pushBack (_centre getPos [random 50, random 360]);
	};
};

private _aniActivation = [];
private _aniPrefix = selectRandom ["infected with a brain parasite","used for chemical testing","marked for organ harvesting","poisoned with a radioactive isotope","used to smuggle weapons into the region","placed to infect other livestock"];

// Generate the crates.
for "_i" from 0 to (_aniMax + 2) do {
	if (_positions isEqualTo []) exitWith {};

	private _aniType = selectRandom ["Cock_random_F","Hen_random_F","Goat_random_F","Sheep_random_F"];
	private _aniPos = selectRandom _positions;
	if (count _positions > _aniMax) then { _positions deleteAt (_positions find _aniPos) };

	if (count _aniPos > 0) then { 
		// If not in a building find an empty position.
		if (_aniPos#2 == 0) then { _aniPos = _aniPos findEmptyPosition [1, 25, "B_Soldier_F"] };
		
		private _aniObj = createAgent [_aniType, [0,0,0], [], 0, "NONE"];
		_aniObj setPosATL _aniPos;
		_aniObj setDir random 360;
		
		missionNamespace setVariable [format["ZMM_%1_OBJ_%2", _zoneID, _i], _aniObj, true];
		_aniActivation pushBack format["(missionNamespace getVariable ['ZMM_%1_OBJ_%2', objNull])", _zoneID, _i];
	};
};

// Create Completion Trigger
private _objTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_objTrigger setTriggerStatements [  format["{ !alive _x } count [%1] >= %2", (_aniActivation joinString ","), _aniMax], 
	format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
	"" ];

// Create Task
private _missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc + "<br/><br/>Target creatures will include; Sheep, Goats and Chickens.", _aniMax, _aniPrefix, _locName], ["Hunt"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, true, "target"] call BIS_fnc_setTask;

true