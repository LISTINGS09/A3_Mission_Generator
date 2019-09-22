// Set-up mission variables.
params [ ["_zoneID", 0], "_targetPos"];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];

_missionDesc = [
		"The enemy has engaged a cargo transport flying over the area, search the crash site for nearby for <font color='#00FFFF'>%1 Ammo Crates</font> and destroy them.",
		"An enemy air transport has crashed at the location, search the area for <font color='#00FFFF'>%1 Ammo Crates</font> and destroy them.",
		"<font color='#00FFFF'>%1 Ammo Crates</font> have been spotted near a wreck, move in and destroy them.",
		"Search and destroy the <font color='#00FFFF'>%1 Ammo Crates</font> at a downed transport.",
		"An air transport carrying supplies has crashed. Secure the area and destroy the <font color='#00FFFF'>%1 Ammo Crates</font> before they can fall into enemy hands.",
		"A crashed transport has been spotted near this location. Find the <font color='#00FFFF'>%1 Ammo Crates</font> before the enemy can and destroy them."
	];	

// Create Objective
_wreck = (selectRandom [ "Land_UWreck_Heli_Attack_02_F", "Land_Wreck_Heli_Attack_01_F", "Land_Wreck_Heli_Attack_02_F", "Land_Wreck_Plane_Transport_01_F", "Plane_Fighter_01_wreck_F",
							"Plane_Fighter_03_wreck_F", "Plane_Fighter_02_wreck_F", "Plane_Fighter_04_wreck_F","Land_Mi8_wreck_F"]) createVehicle _targetPos;
_wreck setVectorUp surfaceNormal position _wreck;

_smoke = createVehicle ["test_EmptyObjectForSmoke",position _wreck, [], 0, "CAN_COLLIDE"];
_crater = createSimpleObject ["CraterLong", _targetPos];

_crateActivation = [];
_crateNo = 0;

// Generate the crates.
for "_i" from 1 to round (3 + random 2) do {
	_ammoType = selectRandom ["Box_Syndicate_Ammo_F","Box_Syndicate_WpsLaunch_F"];
	_ammoPos = [_targetPos, 15 + random 50, 150, 2, 0, 0.5, 0, [], [ _targetPos, _targetPos ]] call BIS_fnc_findSafePos;
	_ammoPos = _ammoPos findEmptyPosition [1, 25, _ammoType];

	if (count _ammoPos > 0) then { 
		_crateNo = _crateNo + 1;
		_ammoObj = _ammoType createVehicle _ammoPos;
		_ammoObj setDir random 90;
		
		missionNamespace setVariable [format["ZMM_%1_TSK_Object%2", _zoneID, _i], _ammoObj];
		
		_crateActivation pushBack format["!alive ZMM_%1_TSK_Object%2", _zoneID, _i];
		
		clearWeaponCargoGlobal _ammoObj;
		clearMagazineCargoGlobal _ammoObj;
		clearItemCargoGlobal _ammoObj;
		clearBackpackCargoGlobal _ammoObj;
	};
};

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _targetPos, FALSE];
_objTrigger setTriggerStatements [  (_crateActivation joinString " && "),
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _crateNo], ["Crash"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "AUTOASSIGNED", 1, FALSE, TRUE, "box"] call BIS_fnc_setTask;

TRUE