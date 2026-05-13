// zmm_fnc_misc_checkConfig
params [["_side", EAST]];

private _toCheck = [];
_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]);
_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]);
_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]);
_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]]);
_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]]);
_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_CasP",_side],[]]);
_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_CasH",_side],[]]);
_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Cas",_side],[]]);
_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Boat",_side],[]]);
_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Convoy",_side],[]]);
_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Static",_side],[]]);
_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Util",_side],[]]);

// Check Vehicles
{
	{
		_x params [["_obj",""],["_init",""]];
		
		if (_obj isEqualType "") then {
			if !(isClass (configFile >> "CfgVehicles" >> _obj)) then { ["ERROR", format["Invalid Unit: %1", _obj]] call zmm_fnc_misc_logMsg };
		} else {
			if !(isClass _obj) then { ["ERROR", format["Invalid Config: %1", _obj]] call zmm_fnc_misc_logMsg };
		};
	} forEach _x;
} forEach _toCheck;

// Check Units
private _unitArray = missionNamespace getVariable [format["ZMM_%1_Man", _side], []];
{ if !(isClass (configFile >> "CfgVehicles" >> _x)) then { ["ERROR", format["Invalid %2 Unit: %1", _x, _side]] call zmm_fnc_misc_logMsg } } forEach _unitArray;