// Only run on server
if !isServer exitWith {};

params [["_missionType", (tg_missionTypes select 0), [""]], ["_missionName", "", [""]]];

// Only start in-game.
private _worldCentre = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");

{
	(
		[
			["AIR", 	600, 	1.25,	-150,	4, 		true,	true, 	false, 	true, 	2000],
			["CAP", 	800, 	1.25,	-150,	6, 		true, 	true, 	true, 	false, 	2000],
			["CTY", 	500, 	1, 		-100,	3,		false, 	true, 	true, 	false, 	1750],
			["VIL", 	300, 	0.7, 	-50,	2, 		false, 	true, 	true, 	false, 	1500],
			["OTH", 	200, 	0.7, 	-50,	2, 		true, 	true, 	true, 	false, 	1500]
		] select _forEachIndex
	) params ["_locShortName", "_locRadius", "_locMkrSize", "_locOffset", "_locVehicles", "_spawnA", "_spawnL", "_spawnS", "_spawnM", "_activateRange"];
	
	{
		private _locPos = getPos _x;
					
		// Don't do anything if the location is within a Safe Zone.
		if !([_locPos] call tg_fnc_inSafeZone) then {
			private _locName = format["%1%2_%3", _locShortName, _forEachIndex, ([text _x] call BIS_fnc_filterString)];
		
			// Get enemy side settings.
			([_locPos] call tg_fnc_findSide) params ["_enemySide", "_enemyDAC", "_enemySoldier", "_enemyFlag"];
			
			//[format["[TG] DEBUG findWorldLocations: %1 %2", _locName, _enemySide]] call tg_fnc_debugMsg;
			
			// String to identify the Zone's difficulty when called in tg_fnc_urbanObjective.
			private _locDiffString = "";
			
			private _tmpMkr = createMarker [format["%1_Enemy_Flag",_locName], (getPos _x vectorAdd [_locOffset,0,0])];
			_tmpMkr setMarkerColor ([_enemySide, true] call BIS_fnc_sideColor);
			_tmpMkr setMarkerSize [_locMkrSize,_locMkrSize];
			_tmpMkr setMarkerType (if (_enemySide == west) then { "b_unknown" } else { if (_enemySide == east) then { "o_unknown" } else { "n_unknown" };}); //_enemyFlag;
			
			_enemyDAC set [2,6];
			
			private _DACZone = "";
			switch (_forEachIndex) do {
				case 0; case 1: { 
					_DACZone = format["%1, '%2', 'urbanZone', %3, %4, [[%5, 1, 0], [([4, 'light', _missionType] call tg_fnc_balanceUnits), 2, 15, 10], [([2, 'medium', _missionType] call tg_fnc_balanceUnits), ceil random 2, 10, 5], [([random 2, 'heavy', _missionType] call tg_fnc_balanceUnits), 1, 10, 6], [%7], %6]",
						_enemySide,
						_locName,
						_locPos,
						_locRadius,
						_locRadius + _forEachIndex,
						_enemyDAC,
						if (_locShortName == "AIR" || random 1 > 0.75) then { "1,2,5" } else { "1, 2, 50, 0, 100, 5" }
					];
					_locDiffString = "2,[4 + random 4,2,0],[random 5,0,0],[random 2,0,0]";
				};
				case 2: { 
					_DACZone = format["%1, '%2', 'urbanZone', %3, %4, [[%5, 1, 0], [([2, 'light', _missionType] call tg_fnc_balanceUnits), 2, 10, 6], [([1, 'medium', _missionType] call tg_fnc_balanceUnits), 1, 10, 5], [([random 1, 'heavy', _missionType] call tg_fnc_balanceUnits), 1, 8, 4], [%7], %6]",
						_enemySide,
						_locName,
						_locPos,
						_locRadius,
						_locRadius + _forEachIndex,
						_enemyDAC,
						if (random 1 > 0.65) then { "1, 2, 50, 0, 100, 5" } else { "" }
					];
					_locDiffString = "1,[random 4,2,0],[random 2,0,0],[random 1,0,0]";
				};
				case default { 
					_DACZone = format["%1, '%2', 'urbanZone', %3, %4, [[%5, 1, 0], [([random 2, 'light', _missionType] call tg_fnc_balanceUnits), 1, 10, 5], [([random 1, 'medium', _missionType] call tg_fnc_balanceUnits), 1, 6, 3], [], [], %6]",
						_enemySide,
						_locName,
						_locPos,
						_locRadius,
						_locRadius + _forEachIndex,
						_enemyDAC
					];
					_locDiffString = "0,[random 2,1,0],[random 1,0,0]";
				};	
			};
					
			// Create a trigger that sets up a DAC Zone (we don't want 100's of active zones at the start takes ~20mins to initialise!)
			private _locTrigger = createTrigger ["EmptyDetector", _locPos, false];
			_locTrigger setTriggerTimeout [1, 1, 1, false];
			_locTrigger setTriggerArea [_activateRange, _activateRange, 0, true, 500];
			_locTrigger setTriggerActivation [format["%1", tg_playerSide], "PRESENT", false];
			// TODO: Future version of Arma can activate a trigger from any playable unit.
			//_engTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
			_locTrigger setTriggerStatements [ 	"this", 
												format["['%1',[[%2]]] spawn tg_fnc_DACzone_creator; deleteVehicle thisTrigger;",
													_locName,
													_DACZone], 
												""
											];
						
			// TODO: Future version of Arma can activate a trigger from any playable unit.
			//_locTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
			
			// Create a trigger that spawns an end trigger for the zone when players are nearer
			private _engTrigger = createTrigger ["EmptyDetector", _locPos, false];
			_engTrigger setTriggerTimeout [1, 1, 1, false];
			_engTrigger setTriggerArea [600, 600, 0, true, 400];
			_engTrigger setTriggerActivation [format["%1", tg_playerSide], "PRESENT", false];
			// TODO: Future version of Arma can activate a trigger from any playable unit.
			//_engTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
			_engTrigger setTriggerStatements [ 	"this", 
												format["['%1', %2, %3, '%4', [%5], '%6'] spawn tg_fnc_urbanObjective;
													deleteVehicle thisTrigger;",
													_locName,
													_locPos,
													_locRadius,
													(text _x),
													_locDiffString,
													_enemyFlag
													], 
												""
											];
											
			private _buildingList = [];
			{
				if (typeOf _x != "") then {
					_buildingList pushBack _x;
				};
			} forEach (_locPos nearObjects ["Building", _locRadius]);
			
			missionNamespace setVariable [format["%1_Buildings", _locName], _buildingList];
			
			// Create a trigger that spawns vehicles and end trigger for the zone when players are nearer
			private _vehTrigger = createTrigger ["EmptyDetector", _locPos, false];
			_vehTrigger setTriggerTimeout [1, 1, 1, false];
			_vehTrigger setTriggerArea [round (_activateRange / 2), round (_activateRange / 2), 0, true, 400];
			_vehTrigger setTriggerActivation [format["%1", tg_playerSide], "PRESENT", false];
			// TODO: Future version of Arma can activate a trigger from any playable unit.
			//_engTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
			_vehTrigger setTriggerStatements [ 	"this", 
												format["[%1, %2, %3, [%4, %5, %6, %7], %8_Buildings ] spawn tg_fnc_spawnVehicle;
													deleteVehicle thisTrigger;",
													_locPos,
													_locRadius,
													_locVehicles + random (_locVehicles / 2),
													_spawnA,
													_spawnL,
													_spawnS,
													if _spawnM then { _enemySide } else { civilian },
													_locName
												], 
												""
											];
											
			private _milTrigger = createTrigger ["EmptyDetector", _locPos, false];
			_milTrigger setTriggerTimeout [1, 1, 1, false];
			_milTrigger setTriggerArea [round (_activateRange / 2.5), round (_activateRange / 2.5), 0, true, 400];
			_milTrigger setTriggerActivation [format["%1", tg_playerSide], "PRESENT", false];
			// TODO: Future version of Arma can activate a trigger from any playable unit.
			//_engTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
			_milTrigger setTriggerStatements [ 	"this", 
												format["[%1, %2, %3, %4, '%5', %6_Buildings ] spawn tg_fnc_spawnMilitary;
													deleteVehicle thisTrigger;",
													_locPos,
													_locRadius,
													_locVehicles * 4,
													_enemySide,
													_enemySoldier,
													_locName
												], 
												""
											];

			// The below spawns all vehicles on the map at start.		
			//[_locPos, _locRadius, _locVehicles + random (_locVehicles / 2), [_spawnA, _spawnL, _spawnS, if _spawnM then { _enemySide } else { civilian }, _enemySoldier], _buildingList] spawn tg_fnc_spawnVehicle; 
		};
	} forEach (nearestLocations [_worldCentre, [_x], 10000]);
} forEach ["Airport","NameCityCapital","NameCity","NameVillage","NameLocal"];