// Fills a zone with units - patrols (UPS Script), garrison (Spawn AI), QRF (QRF Script)
if !isServer exitWith {};

params [ "_zoneID", ["_locType", ""] ];

// TODO: Add a check if the zone already has a waiting trigger?

// If we're running non-CTI and a location was chosen, create a task.
if (!(_locType isEqualTo "Ambient") && ZZM_Mode isEqualTo 0) then {
	// This function returns some settings to overwrite AI population.
	// e.g. Defence missions have no AI to start.
	//[_zoneID] execVM format["%1\tasks\hvt_rescue.sqf", ZMM_FolderLocation];
	[_zoneID] call zmm_fnc_setupTask;
};

// Populate the area
if (missionNamespace getVariable [ format[ "ZMM_%1_Patrols", _zoneID ], TRUE]) then { [ _zoneID, _locType] spawn zmm_fnc_areaPatrols };
if (missionNamespace getVariable [ format[ "ZMM_%1_Garrison", _zoneID ], 14] > 0) then { [ _zoneID] spawn zmm_fnc_areaGarrison };
if (count (missionNamespace getVariable [ format["ZMM_%1_QRFLocations", _zoneID], []]) > 0) then { [ _zoneID, TRUE] spawn zmm_fnc_areaQRF };



