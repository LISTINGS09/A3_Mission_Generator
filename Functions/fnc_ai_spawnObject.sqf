// Spawns an object or associated unit.
// Used for Sites/Supports/Roadblocks
params [
	["_zoneID", 0],
	["_side", WEST],
	["_type",""],
	["_class", ""],
	["_worldPos", [0,0,0]],
	["_worldDir", 0],
	["_flat", true]
];

if (_class isEqualTo "") exitWith {};

private _obj = objNull;
private _manArr = missionNamespace getVariable [format["ZMM_%1Man",_side], ["B_Soldier_F"]];
		
//["DEBUG", format["SpawnObject - %1: %2 [%3]", _type, _class, _side]] call zmm_fnc_logMsg;

switch (_type) do {
	case "V": {
		private _customInit = "";
		// If _class is array, extract the custom init.
		if (_class isEqualType []) then { _customInit = _class#1; _class = _class#0 };
		
		_obj =  createVehicle [_class, [0,0,0], [], 150, "NONE"];
		_obj setDir _worldDir;
		//_obj setPos _worldPos;
		_obj setVehiclePosition [_worldPos, [], 0, "NONE"];
		
		if (_obj isKindOf "StaticWeapon") then { _obj setPosATL _worldPos };
		
		if (canMove _obj && canFire _obj) then { _obj setVehicleLock "LOCKEDPLAYER" };
		
		private _crewArr = [];
		for "_j" from 1 to (count ((fullCrew [_obj, "", true]) - fullCrew [_obj, "cargo", true] - fullCrew [_obj, "turret", true])) do { _crewArr pushBack (selectRandom _manArr) };

		private _tempGrp = [_obj getPos [15, random 360], _side, _crewArr] call BIS_fnc_spawnGroup;
		
		{ _x moveInAny _obj } forEach units _tempGrp;

		// Run custom init for vehicle (set camos etc).
		private _grpVeh = _obj;
		if !(_customInit isEqualTo "") then { call compile _customInit; };
		
		private _clear = createVehicle ["Land_ClutterCutter_large_F", _worldPos, [], 0, "CAN_COLLIDE"];
		
		_tempGrp deleteGroupWhenEmpty true;
		if !(_obj isKindOf "StaticWeapon") then { _tempGrp enableDynamicSimulation true };
		{ _x addCuratorEditableObjects [[_grpVeh] + units _tempGrp, true] } forEach allCurators;
		
		// Add artillery/mortar to the zone supports list.
		if ("Artillery" in getArray (configFile >> "CfgVehicles" >> _class >> "availableForSupportTypes") && getMarkerType format["MKR_%1_MIN", _zoneID] != "") then {
			[leader _tempGrp, format["MKR_%1_MIN", _zoneID], "SHOWMARKER"] spawn zmm_fnc_aiUPS;
		};
	};
	case "O": {
		_obj = createVehicle [_class, [0,0,0], [], 0, "NONE"];
		_obj setDir _worldDir;
		_obj setPosATL _worldPos;
		if !((_obj buildingPos -1) isEqualTo []) then { [_zoneID, 3, _obj] spawn zmm_fnc_areaGarrison };
	};
	default {
		_obj = createSimpleObject [_class, ATLToASL _worldPos];
		_obj setDir _worldDir;
		//_obj setPosATL _worldPos;
	};
};

if _flat then { _obj setVectorUp surfaceNormal getPos _obj };

_obj