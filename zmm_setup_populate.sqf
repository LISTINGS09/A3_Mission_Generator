// Fills a zone with units - patrols (UPS Script), garrison (Spawn AI), QRF (QRF Script)
if !isServer exitWith {};

params [ "_zoneID", ["_locType", ""] ];

// TODO: Add a check if the zone already has a waiting trigger?

// If we're running non-CTI and a location was chosen, create a task.
if (!(_locType isEqualTo "Ambient") && ZZM_Mode isEqualTo 0) then {
	// This function returns some settings to overwrite AI population.
	// e.g. Defence missions have no AI to start.
	//[_zoneID] execVM format["%1\tasks\capture_object.sqf", ZMM_FolderLocation];
	[_zoneID] call zmm_fnc_setupTask;
};

// Populate the area
[ _zoneID, _locType] spawn zmm_fnc_areaPatrols;
[ _zoneID] spawn zmm_fnc_areaGarrison;
[ _zoneID, TRUE] spawn zmm_fnc_areaQRF;

