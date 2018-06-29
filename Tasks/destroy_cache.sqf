// Set-up mission variables.
params [ ["_zoneID", 0] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];
_locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
_radius = (getMarkerSize format["MKR_%1_MIN", _zoneID]) select 0; // Area of Zone.

_missionDesc = [
		"Destroy <font color='#00FFFF'>%1 Equipment Caches</font> recently dropped for enemy forces.",
		"The enemy has collected <font color='#00FFFF'>%1 Weapon Caches</font> at this location, destroy it.",
		"We've picked up a signal indicating <font color='#00FFFF'>%1 Weapons Caches</font> are present in the area, destroy it.",
		"Destroy the <font color='#00FFFF'>%1 Enemy Caches</font> at the marked location.",
		"Intel has identified <font color='#00FFFF'>%1 Weapons Caches</font> here, destroy them.",
		"A UAV has spotted an enemy smuggling <font color='#00FFFF'>%1 Ammo Caches</font> into the area, find and destroy them."
	];

_nearLoc = nearestLocation [_centre, ""];
_locType = if (getPos _nearLoc distance2D _centre < 200) then { type _nearLoc } else { "Custom" };

_cacheNo = switch (_locType) do {
	case "Airport": { 5 };
	case "NameCityCapital": { 4 };
	case "NameCity": { 4 };
	case "NameVillage": { 3 };
	case "NameLocal": { 3 };
	default { 2 };
};

// Find all building positions.
_bldPos = [];
{ _bldPos append (_x buildingPos -1) } forEach _buildings;

// Merge all locations
{
	_locations pushBack position _x;
} forEach _buildings;

_crateActivation = [];
_crateNo = 0;

// Generate the crates.
for "_i" from 0 to _cacheNo do {
	_ammoType = selectRandom ["Box_FIA_Ammo_F","Box_FIA_Support_F","Box_FIA_Wps_F"];
	_ammoPos = [];

	if (random 100 > 50 && {count _bldPos > 0}) then {
		_ammoPos = selectRandom _bldPos;
		_bldPos deleteAt (_bldPos find _ammoPos);
		_ammoType = selectRandom ["Box_IND_Ammo_F","Box_IND_Wps_F","Box_IND_Grenades_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F"];
	} else {
		if (count _locations > 0) then { 
			_ammoPos = selectRandom _locations;
			_locations deleteAt (_locations find _ammoPos);
		} else { 
			_ammoPos = [[_centre, 100 + random 150, random 360] call BIS_fnc_relPos, 1, _radius, 1, 0, 0.5, 0, [], [ _centre, _centre ]] call BIS_fnc_findSafePos;
		};
		
		_ammoPos = _ammoPos findEmptyPosition [1, 25, _ammoType];
	};
		
	if (count _ammoPos > 0) then { 
		_crateNo = _crateNo + 1;
		_ammoObj = _ammoType createVehicle [0,0,0];
		_ammoObj setPosATL _ammoPos;
		_ammoObj setDir random 360;
		
		_mrkr = createMarker [format["MKR_%1_%2_OBJ", _zoneID, _i], [_ammoPos, random 50, random 360] call BIS_fnc_relPos];
		_mrkr setMarkerShape "ELLIPSE";
		_mrkr setMarkerBrush "SolidBorder";
		_mrkr setMarkerSize [50,50];
		_mrkr setMarkerAlpha 0.4;
		_mrkr setMarkerColor format["Color%1",_enemySide];
		
		missionNamespace setVariable [format["ZMM_%1_%2_OBJ", _zoneID, _i], _ammoObj];
		
		_crateActivation pushBack format["!alive ZMM_%1_%2_OBJ", _zoneID, _i];
		
		clearWeaponCargoGlobal _ammoObj;
		clearMagazineCargoGlobal _ammoObj;
		clearItemCargoGlobal _ammoObj;
		clearBackpackCargoGlobal _ammoObj;
	};
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", [0,0,0], FALSE];
_objTrigger setTriggerStatements [  (_crateActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_%1_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _crateNo], ["Cache Hunt"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "box"] call BIS_fnc_setTask;

TRUE