// _zonePos			STRING		Position to create the marker at.
// _zoneRadius		STRING		Radius of the area.
if !isServer exitWith {};

params ["_zonePos", "_zoneRadius"];

private _zoneName = format["safeZone_%1", time];

// Add a marker for the zone if required.
private _zoneMarker = createMarker [_zoneName, _zonePos];
_zoneMarker setMarkerShape "ELLIPSE";
_zoneMarker setMarkerSize  [_zoneRadius + (_zoneRadius / 100 * 50), _zoneRadius + (_zoneRadius / 100 * 50)];
_zoneMarker setMarkerColor ([tg_playerSide, true] call BIS_fnc_sideColor);
_zoneMarker setMarkerBrush  "SolidBorder";
_zoneMarker setMarkerAlpha 0.3;

// Add the zone to the blacklist so it excludes missions in future.
if (isNil "tg_blackList_markers") then { tg_blackList_markers = []; };
tg_blackList_markers pushBack _zoneName;