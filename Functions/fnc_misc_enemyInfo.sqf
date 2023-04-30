//[1] execVM "scripts\ZMM\Functions\fnc_misc_enemyInfo.sqf";
if !hasInterface exitWith {};

params [["_zoneID", 0]];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
private _side = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];

//["DEBUG", format["Zone%1 - Creating Garrison: %2 units (%3 positions)", _zoneID, _enemyCount, count _bPos]] call zmm_fnc_logMsg;

if (getMarkerColor format["MKR_%1_MAX", _zoneID] == "") exitWith { systemChat "No Intel!"; };

private _location = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "Location"];
private _doPatrols = missionNamespace getVariable [ format[ "ZMM_%1_Patrols", _zoneID ], true];
private _doGarrison = missionNamespace getVariable [ format[ "ZMM_%1_Garrison", _zoneID ], 14] > 0;
private _doRoadblock = missionNamespace getVariable [ format[ "ZMM_%1_Roadblocks", _zoneID ], floor random 2] > 0;
private _doSupport = missionNamespace getVariable [ format[ "ZMM_%1_Supports", _zoneID ], 0] > 0;
private _doQRF = count (missionNamespace getVariable [ format["ZMM_%1_QRFLocations", _zoneID], []]) > 0 && missionNamespace getVariable ["f_param_ZMMQRF", 1] == 1;
private _doIED = missionNamespace getVariable [ format["ZMM_%1_IEDs", _zoneID], 0] > 0 && missionNamespace getVariable ["f_param_ZMMIED", 1] == 1;

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

if !(player diarySubjectExists "IntelZMM") then { private _idx = player createDiarySubject ["intelZMM","Intel"] };

player createDiaryRecord ["intelZMM", [format["Intel - %1",_location], _ZMMtext]];