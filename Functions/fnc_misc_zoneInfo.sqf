//[1] execVM "scripts\ZMM\Functions\fnc_misc_zoneInfo.sqf";
if !hasInterface exitWith {};

params [["_zoneID", 0]];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
private _side = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];

//["DEBUG", format["Zone%1 - Creating Garrison: %2 units (%3 positions)", _zoneID, _enemyCount, count _bPos]] call zmm_fnc_logMsg;

if (getMarkerColor format["MKR_%1_MIN", _zoneID] == "") exitWith { systemChat "No Intel!"; };

private _location = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "Location"];
private _doPatrols = missionNamespace getVariable [ format[ "ZMM_%1_Patrols", _zoneID ], true];
private _doGarrison = missionNamespace getVariable [ format[ "ZMM_%1_Garrison", _zoneID ], 0] > 0;
private _doRoadblock = missionNamespace getVariable [ format[ "ZMM_%1_Roadblocks", _zoneID ], 0] > 0;
private _doSupport = missionNamespace getVariable [ format[ "ZMM_%1_Supports", _zoneID ], 0] > 0;
private _doQRF = missionNamespace getVariable ["ZZM_QRF", 1] == 1;
private _doIED = missionNamespace getVariable [ format["ZMM_%1_IEDs", _zoneID], 0] > 0 && missionNamespace getVariable ["ZZM_IED", 1] == 1;

private _ZMMtext = format["<font size='18' color='#80FF00'>Intel for %1 (ID#%2)</font><br/>", _location, _zoneID] + 
	format["
			<br/>%1%2
			<br/>%3%4%5",
			((((vehicles inAreaArray format["MKR_%1_MAX", _zoneID]) select { side _x getFriend ZMM_playerSide < 0.6 && count crew _x > 0}) apply {  getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName") }) call BIS_fnc_consolidateArray) apply { format["%2x <font color='#00FFFF'>%1</font><br/>", _x#0, _x#1] } joinString "",
			format["%1x <font color='#00FFFF'>Infantry Groups</font><br/>", { side _x getFriend ZMM_playerSide < 0.6 && count units _x >= 2 && vehicle leader _x == leader _x} count ((allGroups apply { leader _x }) inAreaArray format["MKR_%1_MAX", _zoneID])],
			if (_doGarrison) then { "<br/>Enemy forces will have occupied buildings within the marked zone.<br/>" } else { "" },
			if (_doRoadblock || _doSupport) then { "<br/>Roadblocks or support buildings are present in the area and will likely have a mechanised or motorised vehicle nearby.<br/>" } else { "" },
			if (_doIED) then { "<br/>The enemy is known to be using IEDs with motion detector triggers - Slow movement will not set them off.<br/>" } else { "" }
		];

if !(player diarySubjectExists "IntelZMM") then { private _idx = player createDiarySubject ["intelZMM","ZMM Intel"] };
player createDiaryRecord ["intelZMM", [format["Intel - %1",_location], _ZMMtext]];


// Admin Menu for Zones - Check if player is authorised admin (or 2600K) ;)
private _show = serverCommandAvailable "#kick";
private _uidList = ["76561197970695190"]; // 2600K
if ((getPlayerUID player) in _uidList || !isMultiplayer) then { _show = true };
if !_show exitWith {};

// Triggers
private _ZMTtext = format["<font size='18' color='#80FF00'>TRIGGER OPTIONS ZONE %1</font><br/><br/>This details all triggers in the zone and will allow them to be force-completed, deleted or resulting code executed on the server. Special syntax such as 'thisTrigger' when used in activation code, WILL NOT be functional if executing the code manually - The trigger should be force Activated instead.<br/>", _zoneID];

private _encodeText = {
	private _specialChars = [38, 60, 62, 34, 39]; //  & < > " '
	private _convertTo = [[38,97,109,112,59], [38,108,116,59], [38,103,116,59], [38,113,117,111,116,59], [38,97,112,111,115,59]]; //  &amp; &lt; &gt; &quot; &apos;
	private _chars = [];
	private "_i";

	{
		_i = _specialChars find _x;
		if (_i isEqualTo -1) then { _chars pushBack _x } else { _chars append (_convertTo select _i) };
	} forEach toArray param [0,"",[""]];

	toString _chars
};

private _triggerList = (allMissionObjects "EmptyDetector" select { _x distance2D _centre <= 500 && vehicleVarName _x != "" });
_triggerList sort true;

{	// Trigger Check
	private _var = missionNamespace getVariable [vehicleVarName _x, objNull];
	private _trg = if (isNull _var) then { _x } else { _var };
	
	//diag_log text format["[F3] INFO (fn_moduleCheck.sqf): Checking Trigger %1 - %2",_x,typeOf _x];
	_ZMTtext = _ZMTtext + format["<br/><font size='16' color='#FF0080'>%1</font> - 
	<font color='#80FF00'><execute expression=""if !(triggerActivated %1) then { { if (!isNil '%1') then { %1 setTriggerStatements ['true',(triggerStatements %1)#1, (triggerStatements %1)#2] };} remoteExec ['BIS_fnc_spawn',2]; hintSilent 'Trigger %1 Activated'; } else { hintSilent 'Trigger %1 already Activated' };"">Activate</execute></font> 
	| <font color='#CF142B'><execute expression=""if (simulationEnabled %1) then {{ if (!isNil '%1') then { %1 enableSimulationGlobal false };} remoteExec ['BIS_fnc_spawn',2]; hintSilent 'Trigger %1 Disabled'} else { hintSilent 'Trigger %1 already Disabled' };"">Disable</execute></font> 
	| <font color='#808800'><execute expression=""if !(simulationEnabled %1) then { if (!isNil '%1') then { %1 enableSimulationGlobal true };} remoteExec ['BIS_fnc_spawn',2]; hintSilent 'Trigger %1 Enabled' } else { hintSilent 'Trigger %1 already Enabled' };"">Enable</execute></font>:<br/>", vehicleVarName _trg];
	if (triggerType _trg != "NONE") then { _ZMTtext = _ZMTtext + format["Type: <font color='#888888'>%1</font>", triggerType _trg] };
	if !(triggerActivation _trg isEqualTo ["NONE","PRESENT",false]) then { _ZMTtext = _ZMTtext + format["Activation: <font color='#888888'>%1</font><br/>", triggerActivation _trg] };
	if ((triggerStatements _trg)#0 != "true") then { _ZMTtext = _ZMTtext + format["Condition: <font color='#8888BB'>%1</font><br/>", [(triggerStatements _trg)#0] call _encodeText] };
	if ((triggerStatements _trg)#1 != "") then { _ZMTtext = _ZMTtext + format["On Activation - 
	<execute expression=""{ call compile ('thisTrigger = %2;' + ((triggerStatements %2)#1)); } remoteExec ['BIS_fnc_spawn',2]; hintSilent '%2 Code Executed (Server)';"">Exec Server</execute> 
	| <execute expression=""{ call compile ('thisTrigger = %2;' + ((triggerStatements %2)#1)); } remoteExec ['BIS_fnc_spawn',0]; hintSilent '%2 Code Executed (Global)';"">Exec Global</execute>:<br/>
	<font color='#88BB88'>%1</font><br/>", [(triggerStatements _trg)#1] call _encodeText, _trg] };
	if ((triggerStatements _trg)#2 != "") then { _ZMTtext = _ZMTtext + format["On Deactivation - 
	<execute expression=""{ call compile ('thisTrigger = %2;' + ((triggerStatements %2)#2)); } remoteExec ['BIS_fnc_spawn',2]; hintSilent '%2 Code Executed (Server)';"">Exec Server</execute> 
	| <execute expression=""{ call compile ('thisTrigger = %2;' + ((triggerStatements %2)#2)); } remoteExec ['BIS_fnc_spawn',0]; hintSilent '%2 Code Executed (Global)';"">Exec Global</execute>:<br/>
	<font color='#BB8888'>%1</font><br/>", [(triggerStatements _trg)#2] call _encodeText, _trg] };
} forEach _triggerList;

if !(player diarySubjectExists "IntelTRG") then { private _idx = player createDiarySubject ["IntelTRG","ZMM Admin"] };
player createDiaryRecord ["IntelTRG", [format["Triggers - %1",_location], _ZMTtext]];

// Tasks



// Varables