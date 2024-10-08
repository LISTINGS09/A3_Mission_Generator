// Functions
if !(leader player == player) exitWith {};

if !(player diarySubjectExists "ZMMCustom") then { private _idx = player createDiarySubject ["ZMMCustom","ZMM Mission"] };

// Don't do anything if the mission has been selected.
if (missionNamespace getVariable ["ZMM_targetPicked", false]) exitWith {};

zmm_fnc_selectLocation = {
	if (missionNamespace getVariable ["ZMM_targetPicked", false]) exitWith { systemChat "[ZMM] ERROR: Mission is already in progress."; };
	systemChat "Click on any Location, then click 'Confirm Selection' in map screen when done.";
	onMapSingleClick {
		if (missionNamespace getVariable ['ZMM_targetPicked', false]) exitWith { onMapSingleClick "" };
		private _locArr = nearestLocations [_pos, ['NameLocal', 'NameVillage', 'NameCity', 'NameCityCapital', 'Airport', 'Hill'], 300, _pos];
		private _size = 400;
		private _posID = '';
		
		if (_pos inArea 'SAFEZONE_PRE0') exitWith { systemChat 'Objective cannot be within safe-zone!'; 'loc_mkr' setMarkerPos [0,0];};
		
		if (count _locArr > 0) then {
			private _loc = _locArr#0;
			private _cfgLoc = "getText (_x >> 'name') == text _loc && getText (_x >> 'type') == type _loc" configClasses (configFile >> 'CfgWorlds' >> worldName >> 'Names');
			_posID = format['%1 (%2)', text (_locArr#0), getText ((_cfgLoc#0) >> 'type')];
			_size = (getNumber ((_cfgLoc#0) >> 'radiusA') max getNumber ((_cfgLoc#0) >> 'radiusB')) max _size;
			ZMM_targetLocation = position (nearestBuilding (position _loc));
			publicVariableServer 'ZMM_targetLocation';
			'loc_mkr' setMarkerPos ZMM_targetLocation;
			'loc_mkr' setMarkerSize [_size,_size];
			onMapSingleClick "";
		} else {
			if (surfaceIsWater _pos) then {
				systemChat 'A flat location must be selected!';
				ZMM_targetLocation = nil;
				'loc_mkr' setMarkerPos [0,0];
			} else {
				ZMM_targetLocation = _pos;
				_posID = format ['%1 (Rural Area)', mapGridPosition _pos];
				publicVariableServer 'ZMM_targetLocation';
				'loc_mkr' setMarkerPos _pos;
				'loc_mkr' setMarkerSize [_size,_size];
				onMapSingleClick "";
			}
		};
		format['[ZMM] %1: Location - %2', name player, _posID] remoteExec ['SystemChat'];
		true
	};	
};

zmm_fnc_confirm = {
	if (missionNamespace getVariable ["ZMM_targetPicked", false]) exitWith { systemChat "[ZMM] ERROR: Mission is already in progress."; };
	if (!isNil "ZMM_targetLocation") then {
		missionNamespace setVariable ["ZMM_targetPicked", true, true];
		systemChat "[ZMM] LOCATION: Confirmed";
	} else {
		systemChat "[ZMM] ERROR: No location has been selected!";
	};
};

if (isNil "loc_mkr") then {
	private _mkr = createMarker ["loc_mkr",[0,0]];
	_mkr setMarkerShape "ELLIPSE";
	_mkr setMarkerColor "ColorWhite";
	_mkr setMarkerBrush 'Border';
	_mkr setMarkerAlpha 1;
	_mkr setMarkerSize [0,0];
};

// Announce players side if not logged.
if (isNil "ZMM_playerSide") then {
	missionNamespace setVariable ["ZMM_playerSide", side group player, true];
};

ZMM_tasks sort true;

private _ZMMcomp = "<font size='18' color='#FF7F00'>Confirm Mission</font><br/><br/>Once happy with all details <execute expression=""[] call zmm_fnc_confirm;"">Confirm Selections</execute> to generate the mission.<br/><br/>";
_ZMMcomp = _ZMMcomp + format["<br/>ZMM v%1<br/><br/>", missionNamespace getVariable["ZMM_Version",0]];
	
player createDiaryRecord ["ZMMCustom", ["3. Confirm Mission", _ZMMcomp]];



private _ZMMExtra = "<font size='18' color='#FF7F00'>Extra Settings</font><br/><br/>If the mission has been CONFIRMED, changing these will have no effect!<br/><br/><font size='16' color='#80FF00'>Patrol Unit Groups</font><br/>By default unit groups will be chosen by location size and type, they can be overridden using the settings below:<br/>";

{
	_x params [["_varName", "ERROR"], ["_varText", "ERROR"]];
	_ZMMExtra = _ZMMExtra + format["[<execute expression=""systemChat ('%2: ' + str (if ((missionNamespace getVariable ['%1', -1]) < 0) then { 'Mission Default' } else { missionNamespace getVariable ['%1', -1] }))"">Check</execute>] [<execute expression=""missionNamespace setVariable ['%1', -1, true]; systemChat ('%2: Using Mission Default')"">Default</execute>] [<font color='#80FF00'><execute expression=""missionNamespace setVariable ['%1', ((missionNamespace getVariable ['%1', 0]) + 1) min 8, true]; systemChat ('%2: ' + str (missionNamespace getVariable ['%1', 0]))"">Add</execute></font>] [<font color='#CF142B'><execute expression=""missionNamespace setVariable ['%1', ((missionNamespace getVariable ['%1', 0]) - 1) max 0, true]; systemChat ('%2: ' + str (missionNamespace getVariable ['%1', 0]))"">Remove</execute></font>] %2<br/>", _varName, _varText];
} forEach [
	["ZMM_CustomSentry", "Sentries (2-3 Units)"],
	["ZMM_CustomTeam", "Team (4-6 Units)"],
	["ZMM_CustomSquad", "Squads (8+ Units)"],
	["ZMM_CustomLight", "Light Vehicles"],
	["ZMM_CustomMedium", "Medium Vehicles"],
	["ZMM_CustomHeavy", "Heavy Vehicles"]
];

_ZMMExtra = _ZMMExtra + "<br/><br/><font size='16' color='#80FF00'>QRF Type</font><br/>If enabled globally, enemy QRF strength will be determined by difficulty settings. At lower difficult CAS and Heavy Vehicles are very unlikely. You can force the QRF type by selecting below, otherwise it will be weighted by Side (INDFOR always has weaker units and support).<br/><br/>";

{
	_x params [["_varName", "ERROR"], ["_varText", "ERROR"]];
	_ZMMExtra = _ZMMExtra + format["[<execute expression=""systemChat 'QRF: %2';missionNamespace setVariable ['ZMM_QRFType', %1, true]; missionNamespace setVariable ['ZZM_QRF', 1, true];"">Select</execute>] %2 (%3)<br/>", _forEachIndex, _varName, _varText];
} forEach [
	["General","Light to Heavy Vehicles"],
	["Motorized","Light Vehicles"],
	["Mechanised","Medium Vehicles"],
	["Armoured","Heavy Vehicles"],
	["Airborne","Helicopter-based Infantry with Fixed Wing/Rotary CAS"],
	["Infantry","Ground Fireteams and Squads"],
	["Helicopter","Paratroopers, Landed Infantry and CAS"],
	["Aircraft","Ground Fireteams and Squads with Fixed Wing CAS"]
];

_ZMMExtra = _ZMMExtra + format["[<execute expression=""systemChat 'QRF: %2';missionNamespace setVariable ['ZMM_QRFType', %1, true]; missionNamespace setVariable ['ZZM_QRF', 1, true];"">Select</execute>] %2<br/>", -1, "Random"];

_ZMMExtra = _ZMMExtra + "<br/>Global QRF Settings: <font color='#80FF00'><execute expression=""systemChat 'QRF Enabled';missionNamespace setVariable ['ZZM_QRF', 1, true];"">Enable</execute></font> | <font color='#CF142B'><execute expression=""systemChat 'QRF Disabled';missionNamespace setVariable ['ZZM_QRF', 0, true];"">Disable</execute></font>";


_ZMMExtra = _ZMMExtra + "<br/>Global IED Settings: <font color='#80FF00'><execute expression=""systemChat 'IEDs Enabled';missionNamespace setVariable ['ZZM_IED', 1, true];"">Enable</execute></font> | <font color='#CF142B'><execute expression=""systemChat 'IEDs Disabled';missionNamespace setVariable ['ZZM_IED', 0, true];"">Disable</execute></font>";

player createDiaryRecord ["ZMMCustom", ["2. Extra Settings", _ZMMExtra]];



private _ZMMtext = "<font size='18' color='#FF7F00'>Choose Mission</font><br/><br/>";

_ZMMtext = _ZMMtext + "<font size='16' color='#80FF00'>Objective Count (If applicable)</font><br/>The number of Objectives/Targets/Data Packets/Waves<br/>";
{
	_ZMMtext = _ZMMtext + format["<execute expression=""missionNamespace setVariable['ZZM_ObjectiveCount', %2, true]; '[ZMM] %1: Objective Counter - %2' remoteExec ['SystemChat'];"">%2</execute> | ", name player, _x ];
} forEach [1,2,3,4,5,6,7,8];

private _ZMMtext = _ZMMtext + "<execute expression=""missionNamespace setVariable['ZZM_ObjectiveCount', 1 + (floor(random 4)), true]; '[ZMM] Objective Count: Random' remoteExec ['SystemChat'];"">Random</execute><br/><br/>";

private _ZMMtext = _ZMMtext + "<font size='16' color='#80FF00'>Choose Mission</font><br/>
	Choosing any option below will attempt to force a type of mission (if the objective cannot be created, an alternative will be chosen).
	<br/><execute expression=""missionNamespace setVariable['ZMM_MissionChoice', '', true]; format['[ZMM] %1 switched to mission type: Random', name player] remoteExec ['SystemChat'];"">Random</execute> - Choose a random objective <font color='#00FFFF'>DEFAULT</font>.<br/>";
	
private _lastType = "";
{
	_x params ["_mType", "_mName", "_mDesc", "_mIcon"];
	
	if (_lastType != _mType) then {
		_ZMMtext = _ZMMtext + format["<br/><img width='15' image='%3'/> <execute expression=""missionNamespace setVariable['ZMM_MissionChoice', '%2', true]; '[ZMM] %1: Mission - %2 (Random)' remoteExec ['SystemChat'];"">%2</execute><br/>",
			name player,
			_mType,
			_mIcon
		];
		_lastType = _mType;
	};
	
	_ZMMtext = _ZMMtext + format["<execute expression=""missionNamespace setVariable['ZMM_MissionChoice', '%2', true]; '[ZMM] %1: Mission - %2' remoteExec ['SystemChat'];"">%2</execute> - %3.<br/>",
		name player,
		_mName,
		_mDesc
	];
} forEach ZMM_tasks;

private _ZMMtext = _ZMMtext + "<br/><font size='16' color='#80FF00'>Select Location</font><br/><execute expression=""[] call zmm_fnc_selectLocation;"">Select Location</execute> and choose where to begin your Assignment.";

player createDiaryRecord ["ZMMCustom", ["1. Choose Mission", _ZMMtext]];

[] spawn zmm_fnc_selectLocation;
[] spawn {
	// Select the ZMM stuff because people can't see it
	waitUntil { uisleep 1; visibleMap };
	uisleep 4;
	
	_fnc_selectIndex = {
		params[ "_ctrl", "_name" ];

		for "_i" from 0 to ( lnbSize _ctrl select 0 ) -1 do {
			if ( _ctrl lnbText [ _i, 0 ] == _name ) exitWith { _ctrl lnbSetCurSelRow _i };
		};
	};
	[uiNamespace getVariable "RscDiary" displayCtrl 1001, "ZMM Mission" ] call _fnc_selectIndex; 
	[uiNamespace getVariable "RscDiary" displayCtrl 1002, "1. Choose Mission" ] call _fnc_selectIndex;
};
