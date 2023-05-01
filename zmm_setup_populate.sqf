// Fills a zone with units - patrols (UPS Script), garrison (Spawn AI), QRF (QRF Script)
if !isServer exitWith {};

params [ "_zoneID", ["_locType", ""], ["_forceTask", ""] ];

// TODO: Add a check if the zone already has a waiting trigger?

// If we're running non-CTI and a location was chosen, create a task.
if (!(_locType isEqualTo "Ambient") && (ZZM_Mode == 0 || _forceTask != "")) then {
	// This function returns some settings to overwrite AI population.
	// e.g. Defence missions have no AI to start.
	//[_zoneID] execVM format["%1\tasks\hvt_rescue.sqf", ZMM_FolderLocation];
	[_zoneID, _forceTask] call zmm_fnc_setupTask;
};

private _doPatrols = missionNamespace getVariable [ format[ "ZMM_%1_Patrols", _zoneID ], true];
private _doGarrison = missionNamespace getVariable [ format[ "ZMM_%1_Garrison", _zoneID ], 14] > 0;
private _doRoadblock = missionNamespace getVariable [ format[ "ZMM_%1_Roadblocks", _zoneID ], floor random 2] > 0;
private _doSupport = missionNamespace getVariable [ format[ "ZMM_%1_Supports", _zoneID ], 0] > 0;
private _doQRF = count (missionNamespace getVariable [ format["ZMM_%1_QRFLocations", _zoneID], []]) > 0 && missionNamespace getVariable ["ZZM_QRF", 1] == 1;
private _doIED = missionNamespace getVariable [ format["ZMM_%1_IEDs", _zoneID], 0] > 0 && missionNamespace getVariable ["ZZM_IED", 1] == 1;

["DEBUG", format["Zone%1 - Setup Populate - %2 %3 [%4%5%6%7]", _zoneID, _locType, _forceTask, ["","+Patrols"] select _doPatrols, ["","+Garrison"] select _doGarrison, ["","+Roadblock"] select _doRoadblock, ["","+Support"] select _doSupport, ["","+QRF"] select _doQRF]] call zmm_fnc_logMsg;

// Populate the area
if _doPatrols then { [_zoneID, _locType] call zmm_fnc_areaPatrols };
if _doGarrison then { [_zoneID] spawn zmm_fnc_areaGarrison; 
	if !(_locType isEqualTo "Ambient") then { [_zoneID] spawn zmm_fnc_areaMilitarise };
};
if _doRoadblock then { [_zoneID] spawn zmm_fnc_areaRoadblock };
if _doSupport then { [_zoneID] spawn zmm_fnc_areaSupport };
if _doQRF then { [_zoneID, true] spawn zmm_fnc_areaQRF };
if _doIED then { [_zoneID] spawn zmm_fnc_areaIED };

// Change sector colour when cleared on CTI Mode
if (ZZM_Mode > 0 && ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) > 0 && isNil format["TR_%1_CLEAR", _zoneID]) then {
	private _clearTrg = createTrigger [ "EmptyDetector", missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]], false ];
	_clearTrg setTriggerArea [ ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0), ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0), 0, false, 150 ];
	_clearTrg setTriggerActivation [ str (missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST]), "NOT PRESENT", true ];
	_clearTrg setTriggerTimeout [10, 10, 10, true];
	_clearTrg setTriggerStatements [ "count thisList < 4", 
		format["{ _x setMarkerColor 'ColorGrey' } forEach ['MKR_%1_LOC','MKR_%1_MIN']; ZMM_ZoneMarkers = ZMM_ZoneMarkers - [_zoneID];", _zoneID],
		format["{ _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST]]];
		
	missionNamespace setVariable [format["TR_%1_CLEAR", _zoneID], _clearTrg];
};