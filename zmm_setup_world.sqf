// Spawns a markers/missions over all locations in a world.
// Largest locations take priority over smaller ones on checking distance.

if !isServer exitWith {};

["INFO", "Location Setup - Starting"] call zmm_fnc_logMsg;

{
	_configType = _x;
	{	
		_pos = getArray (_x >> 'position');
		_radius = getNumber (_x >> 'radiusA') max getNumber (_x >> 'radiusB');
		_locType = getText (_x >> 'type');
		_locName = getText (_x >> 'name');
		
		_pos set [2,0];
			
		_create = TRUE;
		_bypass = FALSE;
		
		// Distance Checks
		{
			_mkrPos = getMarkerPos _x;
			_mkrSiz = (getMarkerSize _x) select 0;
			_mkrStr = toUpper _x;
			
			// Make sure we're far enough away.
			if (_mkrStr find "_MAX" > 0) then {
				if ((_pos distance2D _mkrPos) <= (_radius * 1.5) + (_mkrSiz * 1.5)) then { _create = FALSE };
			};
			// Never create within another area or safe zone.
			if (_mkrStr find "_MIN" > 0 || _mkrStr find "SAFEZONE" >= 0) then {
				if (_pos inArea _x) then { _bypass = TRUE };
			};
			
			// Don't let the area be too big.
			if (_radius > 500) then { _radius = 500 };
			
			if _bypass exitWith {};
		} forEach allMapMarkers;
		
		if (!_bypass) then {
			// Water Check for small islands
			if !(surfaceIsWater (_pos getPos [_radius, 0]) && surfaceIsWater (_pos getPos [_radius, 90]) && surfaceIsWater (_pos getPos [_radius, 180]) && surfaceIsWater (_pos getPos [_radius, 270])) then { 
				// Objective Zone
				if _create then { 
					// Are we in CTI Mode?
					if (ZZM_Mode == 1) then {
						_zoneId = [_pos, _locType, _radius, _locName ] call zmm_fnc_setupZone;
					} else {
						_zoneId = [_pos, "Ambient", _radius, _locName, _locType ] call zmm_fnc_setupZone;
					};
				} else {
					if (random 100 > 50) then {
						_zoneID = [_pos, "Ambient", _radius, _locName, _locType] call zmm_fnc_setupZone;
					};
				};
			};
		};
	} forEach ("getText (_x >> 'type') == _configType" configClasses (configFile >> "CfgWorlds" >> worldName >> "Names"));
} forEach ["Airport", "NameCityCapital", "NameCity", "NameVillage", "NameLocal"];

["INFO", "Location Setup - Finished"] call zmm_fnc_logMsg;
