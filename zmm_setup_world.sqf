// Spawns a markers/missions over all locations in a world.
// Largest locations take priority over smaller ones on checking distance.

if !isServer exitWith {};

["INFO", "Location Setup - Starting"] call zmm_fnc_logMsg;

{
	_configType = _x;
	{	
		_pos = getArray (_x >> 'position');
		_radius = getNumber (_x >> 'radiusA') max getNumber (_x >> 'radiusB');
		_desc_type = getText (_x >> 'type');
		
		_pos set [2,0];
			
		_create = TRUE;
		_bypass = FALSE;
		_isIsland = FALSE;
		
		// Distance Checks
		{
			_mkrPos = getMarkerPos _x;
			_mkrSiz = (getMarkerSize _x) select 0;
			_mkrStr = toUpper _x;
			
			// Make sure we're far enough away.
			if (_mkrStr find "_MAX" > 0) then {
				if ((_pos distance2D _mkrPos) <= (_radius * 1.5) + (_mkrSiz * 1.5)) exitWith { _create = FALSE };
			};
			// Never create within another area or safe zone.
			if (_mkrStr find "_MIN" > 0 || _mkrStr find "SAFEZONE" >= 0) then {
				if (_pos inArea _x) exitWith { _bypass = TRUE };
			};
		} forEach allMapMarkers;
		
		if (!_bypass) then {
			// Water Check for small islands
			if (surfaceIsWater ([_pos, _radius, 0] call BIS_fnc_relPos) &&
				surfaceIsWater ([_pos, _radius, 90] call BIS_fnc_relPos) &&
				surfaceIsWater ([_pos, _radius, 180] call BIS_fnc_relPos) &&
				surfaceIsWater ([_pos, _radius, 270] call BIS_fnc_relPos)) then { _create = FALSE; _isIsland = TRUE };

			if (missionNamespace getVariable ["ZZM_CTIMode", FALSE]) then {
				// CTI Creates Objective Zones and Ambient Zones
				if _create then { 
					[_pos, _desc_type, _radius ] call zmm_fnc_setupZone; // Objective Zone
				} else {
					if (!_isIsland && random 100 > 50) then {
						[_pos, "Ambient", _radius ] call zmm_fnc_setupZone; // Ambient Zone
					};
				};
			} else {
				// Custom Zones are always Ambient
				if _create then { [_pos, "Ambient", _radius ] call zmm_fnc_setupZone }; // Ambient Zone
			};
		};
	} forEach ("getText (_x >> 'type') == _configType" configClasses (configFile >> "CfgWorlds" >> worldName >> "Names"));
} forEach ["Airport", "NameCityCapital", "NameCity", "NameVillage", "NameLocal"];

["INFO", "Location Setup - Finished"] call zmm_fnc_logMsg;
