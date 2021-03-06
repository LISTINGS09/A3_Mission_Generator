// Fills a zone with units - patrols (UPS Script), garrison (Spawn AI), QRF (QRF Script)
if !isServer exitWith {};

params [ "_zoneID", ["_locType", ""], ["_forceTask", ""] ];

// TODO: Add a check if the zone already has a waiting trigger?

// If we're running non-CTI and a location was chosen, create a task.
if (!(_locType isEqualTo "Ambient") && (ZZM_Mode != 1 || _forceTask != "")) then {
	// This function returns some settings to overwrite AI population.
	// e.g. Defence missions have no AI to start.
	//[_zoneID] execVM format["%1\tasks\hvt_rescue.sqf", ZMM_FolderLocation];
	[_zoneID, _forceTask] call zmm_fnc_setupTask;
};

private _doPatrols = missionNamespace getVariable [ format[ "ZMM_%1_Patrols", _zoneID ], true];
private _doGarrison = missionNamespace getVariable [ format[ "ZMM_%1_Garrison", _zoneID ], 14] > 0;
private _doRoadblock = missionNamespace getVariable [ format[ "ZMM_%1_Roadblocks", _zoneID ], floor random 2] > 0;
private _doSupport = missionNamespace getVariable [ format[ "ZMM_%1_Supports", _zoneID ], 0] > 0;
private _doQRF = count (missionNamespace getVariable [ format["ZMM_%1_QRFLocations", _zoneID], []]) > 0 && missionNamespace getVariable ["f_param_ZMMQRF", 1] == 1;
private _doIED = missionNamespace getVariable [ format["ZMM_%1_IEDs", _zoneID], 0] > 0 && missionNamespace getVariable ["f_param_ZMMIED", 1] == 1;

["DEBUG", format["Zone%1 - Populating %2 %3 [%4%5%6%7]", _zoneID, _locType, _forceTask, ["","+Patrols"] select _doPatrols, ["","+Garrison"] select _doGarrison, ["","+Roadblock"] select _doRoadblock, ["","+Support"] select _doSupport, ["","+QRF"] select _doQRF]] call zmm_fnc_logMsg;

// Populate the area
if _doPatrols then { [_zoneID, _locType] call zmm_fnc_areaPatrols };
if _doGarrison then { [_zoneID] spawn zmm_fnc_areaGarrison };
if _doRoadblock then { [_zoneID] spawn zmm_fnc_areaRoadblock };
if _doSupport then { [_zoneID] spawn zmm_fnc_areaSupport };
if _doQRF then { [_zoneID, true] spawn zmm_fnc_areaQRF };
if _doIED then { [_zoneID] spawn zmm_fnc_areaIED };

if (_locType != "Ambient") then {
	[
		format["ZMM_%1_PatrolsStrength", _zoneID],
		format["Intel Sector #%1", _zoneID],
		format["
		<br/><font size='18' color='#80FF00'>ENEMY INTEL</font>
		<br/>The following units are known to be operational in the AO:
		<br/>%1%2
		<br/>%3%4%5
		<br/>",
		(((vehicles select { side _x getFriend ZMM_playerSide < 0.6 && !(_x isKindOf "staticWeapon" || _x isKindOf "static") && count crew _x > 0}) apply {  getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName") }) call BIS_fnc_consolidateArray) apply { format["%2x <font color='#00FFFF'>%1</font><br/>", _x#0, _x#1] } joinString "",
		format["%1x <font color='#00FFFF'>Infantry Groups</font><br/>", { side _x getFriend ZMM_playerSide < 0.6 && count units _x >= 2 && vehicle leader _x == leader _x} count allGroups],
		if (_doGarrison) then { "<br/>Enemy forces will have occupied buildings within the marked zone.<br/>" } else { "" },
		if (_doRoadblock || _doSupport) then { "<br/>Roadblocks or support buildings are present in the area and will likely have a mechanised or motorised vehicle nearby.<br/>" } else { "" },
		if (_doIED) then { "<br/>The enemy is known to be using IEDs with motion detector triggers - Slow movement will not set them off.<br/>" } else { "" }
		]
	] spawn {
		uiSleep 2;
		[player,["IntelZMM","Intel"]] remoteExec ["createDiarySubject"];		
		[player,["IntelZMM",[_this#1, _this#2]]] remoteExec ["createDiaryRecord"];
	};
};