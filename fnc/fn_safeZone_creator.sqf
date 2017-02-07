// _zonePos			STRING		Position to create the marker at.
// _zoneRadius		STRING		Radius of the area.
if !isServer exitWith {};

params ["_zoneName", "_zonePos", "_zoneRadius", "_markerTextName"];

[format ["[TG] DEBUG safeZoneCreator: [%1,%2,%3,%4]", _zoneName, _zonePos, _zoneRadius, _markerTextName]] call tg_fnc_debugMsg;

private _zoneMarkerName = format["%1_SafeZone", _zoneName];

// Add a marker for the Safe Zone.
private _zoneMarker = createMarker [format["%1_SafeZone", _zoneName], _zonePos];
_zoneMarker setMarkerShape "ELLIPSE";
_zoneMarker setMarkerSize  [_zoneRadius + (_zoneRadius / 100 * 15), _zoneRadius + (_zoneRadius / 100 * 15)];
_zoneMarker setMarkerColor ([tg_playerSide, true] call BIS_fnc_sideColor);
_zoneMarker setMarkerBrush  "SolidBorder";
_zoneMarker setMarkerAlpha 0; // Hidden as fillGrid makes this pointless?

// Unlock any locked vehicles (Cars / Boats) in the Safe Zone.
private _nearVehicles = _zonePos nearEntities [["Car", "Boat", "Air"], _zoneRadius + (_zoneRadius / 100 * 50)];
{ _x lock false; } forEach _nearVehicles;

// Add the zone to the blacklist so it excludes missions in future.
if (isNil "tg_blackList_markers") then { tg_blackList_markers = []; };
tg_blackList_markers pushBack format["%1_SafeZone", _zoneName];