// Adds units (and optionally Insert/Exfil locations) to a Zone.
if !isServer exitWith {};

params [ "_zoneID", ["_locType", ""] ];

// TODO: Add a check if the zone already has a waiting trigger?

// Populate the area
[ _zoneID, _locType] spawn zmm_fnc_areaPatrols;
[ _zoneID] spawn zmm_fnc_areaGarrison;

// Set-up QRF
if (count (missionNamespace setVariable [ format["ZMM_%1_QRFLocations", _zoneID], []]) > 0) then {
	[ _zoneID, TRUE] spawn zmm_fnc_areaQRF;
};