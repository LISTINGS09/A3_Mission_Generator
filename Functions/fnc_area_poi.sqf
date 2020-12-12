// Generate something at these special POIs?
if !isServer exitWith {};

params [
	["_zoneID", 0]
];

private _side = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _centre = missionNamespace getVariable [ format[ "ZMM_%1_Location", _zoneID ], [0,0,0]];
private _radius = missionNamespace getVariable [ format[ "ZMM_%1_Radius", _zoneID ], 150];

_nearPOIs = nearestTerrainObjects [_centre, ["CHURCH", "CHAPEL", "CROSS", "BUNKER", "FORTRESS", "FOUNTAIN", "VIEW-TOWER", "LIGHTHOUSE", "FUELSTATION", "HOSPITAL", "HIDE", "BUSSTOP", "TRANSMITTER", "TOURISM", "WATERTOWER", "POWER LINES", "POWERSOLAR", "POWERWIND"], _radius, false];

