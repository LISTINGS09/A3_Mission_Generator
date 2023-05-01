if !isServer exitWith {};

if ((missionNamespace getVariable ["ZZM_Mode", 0]) isEqualTo 0) exitWith {}; // Only CTI Mode needs intel.

params ["_value"]; // ARRAY/UNIT can be passed.

private _intelType = selectRandom ["Land_Suitcase_F","Land_PlasticCase_01_small_F","Land_PlasticCase_01_small_gray_F","Land_MetalCase_01_small_F"];

// Position Array - Create intel at the location.
if (_value isEqualType []) exitWith {
	_intel = createVehicle [_intelType, [0,0,0], [], 0, "NONE"];
	_intel setPosATL _value;

	[_intel, 
		"<t color='#00FF80'>Gather Intel</t>", 
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_search_ca.paa", 
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_search_ca.paa", 
		"_this distance2d _target < 3", 
		"_caller distance2d _target < 3", 
		{}, 
		{}, 
		{
			_caller playAction "PutDown"; 
			sleep 1;
			deleteVehicle _target;
			sleep 2;
			if (missionNamespace getVariable ["ZMM_DONE", true]) then {
				[name player, "Intel Collected - Check the map for a Task!"] remoteExec ["BIS_fnc_showSubtitle"];
				[] remoteExec ["zmm_fnc_setupTask", 2];
			} else {
				[name player, "Intel Collected - Nothing of value was found!"] remoteExec ["BIS_fnc_showSubtitle"];
			}; 
			[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
		}, 
		{}, 
		[], 
		3, 
		10
	] remoteExec ["bis_fnc_holdActionAdd", 0, _intel];
};