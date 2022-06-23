// Defend a specified location or area.
// Set-up mission variables.
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];




private _veh = group player createUnit ["C_IDAP_Heli_Transport_02_F", player getPos [500,random 360], [], 0, "FLYING"];








private _veh = createVehicle ["C_IDAP_Heli_Transport_02_F", player getPos [500, random 360], [], 0, "FLY"];
createVehicleCrew _veh;

private _rescueGrp = group _veh;

private _newWP = _rescueGrp addWaypoint [getPos _veh, 0];
_newWP setWaypointType "MOVE";
_newWP setWaypointBehaviour "CARELESS";
_newWP setWaypointSpeed "FULL";

private _newWP = _rescueGrp addWaypoint [POD_1, -1];
_newWP waypointAttachVehicle POD_1;
_newWP setWaypointType "HOOK";

private _newWP = _rescueGrp addWaypoint [POD_1 getPos [1000, random 360], 50];
_newWP setWaypointType "MOVE";