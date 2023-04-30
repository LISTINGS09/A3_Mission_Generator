// Spawns a markers/missions over all locations in a world.
// Largest locations take priority over smaller ones on checking distance.

if !isServer exitWith {};

["INFO", format["Populating World: %1 (%2km)", worldName, round (worldSize / 1000)]] call zmm_fnc_logMsg;

private _counter = 0;
{
	_configType = _x;
	{	
		_pos = getArray (_x >> 'position');
		_radius = getNumber (_x >> 'radiusA') max getNumber (_x >> 'radiusB');
		_locType = getText (_x >> 'type');
		_locName = getText (_x >> 'name');
		
		_pos set [2,0];
			
		_create = true;
		_bypass = false;
		
		// Distance Checks
		{
			_mkrPos = getMarkerPos _x;
			_mkrSiz = (getMarkerSize _x) select 0;
			_mkrStr = toUpper _x;
			
			// Make sure we're far enough away.
			if (_mkrStr find "_MAX" > 0) then {
				if ((_pos distance2D _mkrPos) <= (_radius * 2) + (_mkrSiz * 1.5)) then { _create = false };
			};
			// Never create within another area or safe zone.
			if (_mkrStr find "_MIN" > 0 || _mkrStr find "SAFEZONE" >= 0) then {
				if (_pos inArea _x) then { _bypass = true };
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
					if (ZZM_Mode > 0) then {
						_zoneId = [_pos, _locType, _radius, _locName ] call zmm_fnc_setupZone;
						_counter = _counter + 1;
					} else {
						_zoneId = [_pos, "Ambient", _radius, _locName, _locType ] call zmm_fnc_setupZone;
						_counter = _counter + 1;
					};
				} else {
					if (random 100 > 50) then {
						_zoneID = [_pos, "Ambient", _radius, _locName, _locType] call zmm_fnc_setupZone;
						_counter = _counter + 1;
					};
				};
			};
		};
	} forEach ("getText (_x >> 'type') == _configType" configClasses (configFile >> "CfgWorlds" >> worldName >> "Names"));
} forEach ["Airport", "NameCityCapital", "NameCity", "NameVillage", "NameLocal"];

// TODO: Custom Locations Here?
//
{
	_zoneId = [getPos _x,  "NameVillage", 250, format["Location %1", _forEachIndex] ] call zmm_fnc_setupZone;
	_counter = _counter + 1;
} forEach (allMissionObjects "logic" select { str _x find "ZMM_LOC_" >= 0 });

["INFO", format["Populating World: Complete (%1 Zones)", _counter]] call zmm_fnc_logMsg;