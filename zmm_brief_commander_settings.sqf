// Announce players side if not logged.
ZMM_tasks sort true;

private _ZMMtext = "<font size='18' color='#FF7F00'>ZMM Settings</font><br/>";

private _ZMMtext = _ZMMtext + "<font size='16' color='#80FF00'>Objective Count (If applicable)</font><br/>The number of Objectives/Targets/Data Packets/Waves<br/>";
{
	_ZMMtext = _ZMMtext + format["<execute expression=""missionNamespace setVariable['ZZM_ObjectiveCount', %1, true]; SystemChat '[ZMM] Objective Counter - %1';"">%1</execute> | ", _x ];
} forEach [1,2,3,4,5,6,7,8];

private _ZMMtext = _ZMMtext + "<execute expression=""missionNamespace setVariable['ZZM_ObjectiveCount', 1 + (floor(random 4)), true]; SystemChat '[ZMM] Objective Count: Random';"">Random</execute><br/><br/>";

private _ZMMtext = _ZMMtext + "<font size='16' color='#80FF00'>Choose Mission</font><br/>
	Choosing any option below will attempt to force a type of mission (if the objective cannot be created, an alternative will be chosen).
	<br/><execute expression=""missionNamespace setVariable['ZMM_MissionChoice', '', true]; SystemChat '[ZMM] Switched to mission type: Random';"">Random</execute> - Choose a random objective <font color='#00FFFF'>DEFAULT</font>.<br/>";
	
private _lastType = "";
{
	_x params ["_mType", "_mName", "_mDesc", "_mIcon"];
	
	if (_lastType != _mType) then {
		_ZMMtext = _ZMMtext + format["<br/><img width='15' image='%3'/> <execute expression=""missionNamespace setVariable['ZMM_MissionChoice', '%2', true]; SystemChat '[ZMM] Mission - %2 (Random)';"">%2</execute><br/>",
			name player,
			_mType,
			_mIcon
		];
		_lastType = _mType;
	};
	
	_ZMMtext = _ZMMtext + format["<execute expression=""missionNamespace setVariable['ZMM_MissionChoice', '%2', true]; SystemChat '[ZMM] %1: Mission - %2';"">%2</execute> - %3.<br/>",
		name player,
		_mName,
		_mDesc
	];
} forEach ZMM_tasks;

_ZMMtext = _ZMMtext + "<br/><br/><font size='16' color='#80FF00'>Task Location</font><br/>Search distance to find locations, otherwise a random location will be used:<br/>
<execute expression=""missionNamespace setVariable ['ZMM_TaskDistance',5000,true]; systemChat 'Choosing locations within 5KM';"">5KM</execute><br/>
<execute expression=""missionNamespace setVariable ['ZMM_TaskDistance',10000,true]; systemChat 'Choosing locations within 10KM';"">10KM</execute><br/>
<execute expression=""missionNamespace setVariable ['ZMM_TaskDistance',15000,true]; systemChat 'Choosing locations within 15KM';"">15KM (Default)</execute><br/>
<execute expression=""missionNamespace setVariable ['ZMM_TaskDistance',50000,true]; systemChat 'Choosing All Locations';"">All Locations</execute><br/>";

_ZMMtext = _ZMMtext + "<br/><br/><font size='16' color='#80FF00'>Customise Unit Groups</font><br/>By default unit groups will be chosen by mission difficulty, location size and type. Any changes made here will always override anything else:<br/>";

{
	_x params [["_varName", "ERROR"], ["_varText", "ERROR"]];
	_ZMMtext = _ZMMtext + format["[<execute expression=""systemChat ('%2: ' + str (if ((missionNamespace getVariable ['%1', -1]) < 0) then { 'Mission Default' } else { missionNamespace getVariable ['%1', -1] }))"">CHK</execute>] [<execute expression=""missionNamespace setVariable ['%1', -1, true]; systemChat ('%2: Using Mission Default')"">Default</execute>] [<execute expression=""missionNamespace setVariable ['%1', ((missionNamespace getVariable ['%1', 0]) + 1) min 8, true]; systemChat ('%2: ' + str (missionNamespace getVariable ['%1', 0]))"">+</execute>] [<execute expression=""missionNamespace setVariable ['%1', ((missionNamespace getVariable ['%1', 0]) - 1) max 0, true]; systemChat ('%2: ' + str (missionNamespace getVariable ['%1', 0]))"">-</execute>] %2<br/>", _varName, _varText];
} forEach [
	["ZMM_CustomSentry", "Sentries (2-3 Units)"],
	["ZMM_CustomTeam", "Team (4-6 Units)"],
	["ZMM_CustomSquad", "Squads (8+ Units)"],
	["ZMM_CustomLight", "Light Vehicles"],
	["ZMM_CustomMedium", "Medium Vehicles"],
	["ZMM_CustomHeavy", "Heavy Vehicles"]
];

_ZMMtext = _ZMMtext + format["<br/>ZMM v%1<br/><br/>", missionNamespace getVariable["ZMM_Version",0]];
	
player createDiaryRecord ["diary", ["ZMM Settings", _ZMMtext]];