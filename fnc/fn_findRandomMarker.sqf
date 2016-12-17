// Provides a location from a random pre-placed marker.
// Defaults to a random empty area if position not provided.
//
// *** PARAMETERS ***
// _missionType		STRING		Name to search for the markers variable.
//
// *** RETURNS ***
// Position Array

params [["_missionType", (tg_missionTypes select 0), [""]]];

[format ["[TG-findRandomMarker] DEBUG: Separate: %1 Type: %2)", missionNamespace getVariable ["tg_separateMarkers", false], _missionType]] call tg_fnc_debugMsg;

_markerList = [];

if !(missionNamespace getVariable ["tg_separateMarkers", false]) then {
	{
		_markerList append (missionNamespace getVariable format["tg_%1_markers",_x]);
	} forEach tg_missionTypes;
} else {
	_markerList = missionNamespace getVariable format["tg_%1_markers",_missionType];
};

// No markers? Try to find a random world location.
if (count _markerList < 1) exitWith {
	[format ["[TG-findRandomMarker] DEBUG: No markers for tg_%1_markers!", _missionType]] call tg_fnc_debugMsg;
	_finalPos = [] call tg_fnc_findWorldLocation;
	
	_finalPos
};

_marker = selectRandom _markerList;

_finalPos = getMarkerPos _marker;

[format ["[TG-findRandomMarker] DEBUG: Returning %1 for %2", _finalPos, _marker]] call tg_fnc_debugMsg;
//if tg_debug then { _marker setMarkerColorLocal	"ColorYellow"; };

_finalPos