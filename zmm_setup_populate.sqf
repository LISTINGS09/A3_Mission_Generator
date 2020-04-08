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
private _doQRF = count (missionNamespace getVariable [ format["ZMM_%1_QRFLocations", _zoneID], []]) > 0;

["DEBUG", format["Zone%1 - Populating %2 %3 [%4%5%6%7]", _zoneID, _locType, _forceTask, ["","+Patrols"] select _doPatrols, ["","+Garrison"] select _doGarrison, ["","+Roadblock"] select _doRoadblock, ["","+Support"] select _doSupport, ["","+QRF"] select _doQRF]] call zmm_fnc_logMsg;

// Populate the area
if _doPatrols then { [_zoneID, _locType] spawn zmm_fnc_areaPatrols };
if _doGarrison then { [_zoneID] spawn zmm_fnc_areaGarrison };
if _doRoadblock then { [_zoneID] spawn zmm_fnc_areaRoadblock };
if _doSupport then { [_zoneID] spawn zmm_fnc_areaSupport };
if _doQRF then { [_zoneID, true] spawn zmm_fnc_areaQRF };



