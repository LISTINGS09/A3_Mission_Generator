// Announce players side if not logged.
if (isNil "ZMM_playerSide") then {
	missionNamespace setVariable ["ZMM_playerSide", side group player, true];
};

addMissionEventHandler ["Draw3D", {
	if (isNull (missionNamespace getVariable ["ZMM_CMDR",objNull])) exitWith {};
	if (ZMM_CMDR distance player > 10) exitWith {};
	
	drawIcon3D [
		"",
		[1,1,1,1],
		visiblePosition ZMM_CMDR vectorAdd [0,0,2],
		2,
		-1.40,
		0,
		"Task Commander",
		2,
		0.04,
		"PuristaBold",
		"Center"
	];
}];

[] spawn { 
	sleep 1;
	waitUntil{!isNil "ZMM_CMDR"};

	// Start Mission
	[
		ZMM_CMDR,
		"Get Mission",
		"a3\ui_f\data\igui\cfg\holdactions\holdaction_requestleadership_ca.paa",
		"a3\ui_f\data\igui\cfg\holdactions\holdaction_requestleadership_ca.paa",
		"_this distance _target < 3  && (missionNamespace getVariable ['ZMM_DONE', true]) && (missionNamespace getVariable ['ZMM_LEADER',objNull] isEqualto player)",
		"_caller distance _target < 3  && (missionNamespace getVariable ['ZMM_DONE', true]) && (missionNamespace getVariable ['ZMM_LEADER',objNull] isEqualto player)",	
		{},
		{},
		{
			private _forceMission = missionNamespace getVariable ["ZMM_MissionChoice", ""];
			missionNamespace setVariable ["ZMM_MissionChoice", "", true];
			[nil, _forceMission] remoteExec ["zmm_fnc_setupTask", 2];
			["Commander","Orders Assigned - Check your Tasks"] call BIS_fnc_showSubtitle;
		},
		{},
		[],
		1,
		1,
		false
	] call BIS_fnc_holdActionAdd;

	// Cancel Mission
	[
		ZMM_CMDR,
		"Cancel Mission",
		"a3\ui_f\data\igui\cfg\holdactions\holdaction_passleadership_ca.paa",
		"a3\ui_f\data\igui\cfg\holdactions\holdaction_passleadership_ca.paa",
		"_this distance _target < 3 && !(missionNamespace getVariable ['ZMM_DONE', true]) && (missionNamespace getVariable ['ZMM_LEADER',objNull] isEqualto player)",
		"_caller distance _target < 3 && !(missionNamespace getVariable ['ZMM_DONE', true]) && (missionNamespace getVariable ['ZMM_LEADER',objNull] isEqualto player)",	
		{},
		{},
		{
			private _zoneID = missionNamespace getVariable ["ZMM_ZONE", -1];
			[format["ZMM_%1_TSK",_zoneID], 'CANCELED', true] spawn BIS_fnc_taskSetState; 
			{ deleteVehicle _x } forEach ((allMissionObjects "EmptyDetector") select { ((triggerStatements _x)#1) find format["ZMM_%1_TSK",_zoneID] >= 0 });
			missionNamespace setVariable ['ZMM_DONE', true, true];
			missionNamespace setVariable ['ZMM_TASKSDONE', ((missionNamespace getVariable ["ZMM_TASKSDONE",0]) - 1) max 0, true];
			["Commander","Task Cancelled"] call BIS_fnc_showSubtitle;
		},
		{},
		[],
		5,
		1,
		false
	] call BIS_fnc_holdActionAdd;

	// Change Settings
	[
		ZMM_CMDR,
		"Extra Settings",
		"a3\ui_f\data\igui\cfg\holdactions\holdaction_hack_ca.paa",
		"a3\ui_f\data\igui\cfg\holdactions\holdaction_hack_ca.paa",
		"_this distance _target < 3 && (serverCommandAvailable '#kick' || (missionNamespace getVariable ['ZMM_LEADER',objNull] isEqualto player))",
		"_caller distance _target < 3 && (serverCommandAvailable '#kick' || (missionNamespace getVariable ['ZMM_LEADER',objNull] isEqualto player))",	
		{},
		{},
		{ ["Commander","Settings Added - Check Briefing"] call BIS_fnc_showSubtitle; [] execVM "scripts\ZMM\zmm_brief_commander_settings.sqf"; },
		{},
		[],
		1,
		0,
		true
	] call BIS_fnc_holdActionAdd;
	
	// Become Commander
	[
		ZMM_CMDR,
		"Take Command",
		"a3\ui_f\data\igui\cfg\actions\getincommander_ca.paa",
		"a3\ui_f\data\igui\cfg\actions\getincommander_ca.paa",
		"_this distance _target < 3 && (serverCommandAvailable '#kick' || !alive (missionNamespace getVariable ['ZMM_LEADER',objNull]))",
		"_caller distance _target < 3 && (serverCommandAvailable '#kick' || !alive (missionNamespace getVariable ['ZMM_LEADER',objNull]))",
		{},
		{},
		{ 
			missionNamespace setVariable ["ZMM_LEADER", player, true];
			["Commander","You are now the mission Commander - Select 'Get Mission' to receive your first task."] call BIS_fnc_showSubtitle;
		},
		{},
		[],
		1,
		0,
		false
	] call BIS_fnc_holdActionAdd;
	
	// Leave Commander
	[
		ZMM_CMDR,
		"Leave Command",
		"a3\ui_f\data\igui\cfg\actions\returnflag_ca.paa",
		"a3\ui_f\data\igui\cfg\actions\returnflag_ca.paa",
		"_this distance _target < 3 && (missionNamespace getVariable ['ZMM_LEADER',objNull] isEqualto player)",
		"_caller distance _target < 3 && (missionNamespace getVariable ['ZMM_LEADER',objNull] isEqualto player)",	
		{},
		{},
		{ 
			missionNamespace setVariable ["ZMM_LEADER", objNull, true];
		},
		{},
		[],
		1,
		0,
		false
	] call BIS_fnc_holdActionAdd;
};