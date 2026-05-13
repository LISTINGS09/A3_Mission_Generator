if !isServer exitWith {};

if ((missionNamespace getVariable ["ZZM_Mode", 0]) isEqualTo 0) exitWith {}; // Only CTI Mode needs intel.

params [
	"_reference",
	["_type", "object"],
	["_chance", 40]
];

if (_chance >= random 100) exitWith {};

// Position Object - Add intel on the object
if (typeOf _reference isEqualType objNull) exitWith {
	private _unit = _reference;
	private _intelType = ["Files", "FileTopSecret", "FilesSecret", "FlashDisk", "DocumentsSecret", "Wallet_ID", "FileNetworkStructure", "MobilePhone", "SmartPhone"];

	private _containers = [];
	if !(isNull (uniformContainer _unit)) then {_containers pushBack 1;};
	if !(isNull (vestContainer _unit)) then {_containers pushBack 2;};

	switch (selectRandom _containers) do {
		case 1: { _unit addItemToUniform (selectRandom _intelType) };
		case 2: { _unit addItemToVest (selectRandom _intelType) };
		default { _unit addMagazineGlobal (selectRandom _intelType) };
	};
	
	// TODO - What happens when the intel is taken?
};

// Position Array - Create intel at the location.
if (typeOf _reference isEqualType []) exitWith {
	private _intelType = selectRandom ["Land_Suitcase_F","Land_PlasticCase_01_small_F","Land_PlasticCase_01_small_gray_F","Land_MetalCase_01_small_F"];

	private _intel = createVehicle [_intelType, _reference, [], 0, "NONE"];

	[_intel, 
		"<t color='#00FF80'>Take Intel</t>", 
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