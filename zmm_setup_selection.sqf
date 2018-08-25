// Waits for a custom location to be selected by a player.
if !isServer exitWith {};

// Remind the players if nothing has been selected.
[] spawn {
	waitUntil {time > 10};
	if (isNil "ZMM_targetLocation") then {
		["INFO", "The Commander must choose an Objective location! (Press M)"] call zmm_fnc_logMsg;
	};
};

// Wait for Location Selection.
waitUntil {!isNil "ZMM_targetLocation"};

// Remove click action for all players.
"" remoteExec ["onMapSingleClick"];
		
_centre = ZMM_targetLocation;
_centre set [2,0];

_nearLoc = nearestLocation [_centre, ""];
_locType = if (getPos _nearLoc distance2D _centre < 200) then { type _nearLoc } else { "Custom" };
_locRadius = 300 * (if (getPos _nearLoc distance2D _centre < 200) then { 
		switch (_locType) do {
			case "Airport": { 1.5 };
			case "NameCityCapital": { 1.25 };
			case "NameCity": { 1 };
			case "NameVillage": { 0.75 };
			case "NameLocal": { 0.75 };
			default { 0.75 };
		};
	} else { 0.75 });
		
[_centre, _locType, _locRadius] spawn zmm_fnc_setupZone;

missionNamespace setVariable ["ZMM_targetLocation", nil, TRUE];

