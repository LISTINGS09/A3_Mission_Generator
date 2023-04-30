// Spawns a markers/missions over all locations in a world.
if !isServer exitWith {};

// Create the Commander to receive objectives.
if (isNil "ZMM_CMDR") then { 
	private _cmdPos = (["respawn_west","respawn_east","respawn_guerrila"] apply { getMarkerPos _x }) - [[0,0,0]];
	
	_cmdPos = selectRandom (if (_cmdPos isEqualTo []) then { allPlayers apply { getPosATL _x } } else { _cmdPos });

	private _agent = createAgent ["C_Man_Messenger_01_F", _cmdPos, [], 0, "NONE"];
	removeAllWeapons _agent;
	removeAllItems _agent;
	removeAllAssignedItems _agent;
	removeUniform _agent;
	removeVest _agent;
	removeBackpack _agent;
	removeHeadgear _agent;
	removeGoggles _agent;

	_agent allowDamage false;
	_agent disableAI "ALL";
	
	switch (missionNamespace getVariable ["ZMM_playerSide", WEST]) do {
		case EAST: {
			_agent forceAddUniform "U_O_ParadeUniform_01_CSAT_F";
			_agent addHeadgear "H_Beret_CSAT_01_F";
		};
		case INDEPENDENT: { 
			_agent forceAddUniform "U_I_ParadeUniform_01_AAF_F";
			_agent addHeadgear "H_Beret_blk";
		};
		default { 
			_agent forceAddUniform "U_I_E_ParadeUniform_01_LDF_F";
			_agent addHeadgear "H_Beret_Colonel";
		};
	};

	missionNamespace setVariable ["ZMM_CMDR",_agent, true];
	
	if (surfaceIsWater _cmdPos) then {
		ZMM_CMDR setPosASL (lineIntersectsSurfaces [_cmdPos vectorAdd [0,0,1000], AGLToASL _cmdPos] #0 #0);
	};
};

// Create Trigger to Track Completions
private _endTrigger = createTrigger ["EmptyDetector", [0,0,0], false];
_endTrigger setTriggerActivation ["ANY", "PRESENT", true];
_endTrigger setTriggerTimeout [5,5,5,true];
_endTrigger setTriggerInterval 5;
_endTrigger setTriggerStatements [
	"missionNamespace getVariable ['ZMM_DONE', false]",
	"missionNamespace setVariable ['ZMM_TASKSDONE', (missionNamespace getVariable ['ZMM_TASKSDONE',0]) + 1, true];
	if ((missionNamespace getVariable ['ZMM_TASKSDONE',0]) >= (missionNamespace getVariable ['ZMM_TASKSMAX',3])) then { 'END1' call BIS_fnc_endMissionServer };",
	""
];