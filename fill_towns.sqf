// Only run on server
if !isServer exitWith {};

params [["_missionType", (tg_missionTypes select 0), [""]], ["_missionName", "", [""]]];

// Only start in-game.
private _worldCentre = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");

{
	private _locationPos = nearestLocations [_worldCentre, [_x], 10000];
	
	(
		[
			["Airport", 600, 	1, 		-150,	8, 	true, true, false, true],
			["Capital", 800, 	1, 		-150,	8, 	true, true, true, false],
			["City", 	500, 	0.75, 	-100,	4,	true, true, true, false],
			["Village", 200, 	0.5, 	-50,	2, 	true, true, true, false],
			["Other", 	200, 	0.5, 	-50,	2, 	true, true, true, false]
		] select _forEachIndex
	) params ["_locShortName", "_locRadius", "_locMkrSize", "_locMkrDist", "_locVehicles", "_spawnA", "_spawnL", "_spawnS", "_spawnM"];
	
	{
		private _locName = format["%1_%2", _locShortName, _forEachIndex];
		private _locPos = getPos _x;
		
		// Don't do anything if the location is within a Safe Zone.
		if !([_locPos] call tg_fnc_inSafeZone) then {
			// Get enemy side settings.
			private _enemyArray = [_locPos] call tg_fnc_findSide;
			_enemyArray params ["_enemySide", "_enemyDAC", "_enemySoldier", "_enemyFlag"];
			
			private _tmpMkr = createMarker [format["%1_Marker",_locName], (getPos _x vectorAdd [_locMkrDist,0,0])];
			_tmpMkr setMarkerColorLocal ([_enemySide, true] call BIS_fnc_sideColor);
			_tmpMkr setMarkerSizeLocal [_locMkrSize,_locMkrSize];
			_tmpMkr setMarkerTypeLocal _enemyFlag;
			
			_enemyDAC set [2,6];
			
			// TODO: _enemySide converts side to string which cannot be read by tg_fnc_DACzone_spawn (results in civilian colour).
			private _DACZone = switch _forEachIndex do {
				case 0; case 1: { format["%1, '%2', 'urbanZone', %3, %4, [[%5, 1, 0], [([6, 'light', _missionType] call tg_fnc_balanceUnits), 2, 15, 10], [([3, 'medium', _missionType] call tg_fnc_balanceUnits), 2, 10, 5], [([2, 'heavy', _missionType] call tg_fnc_balanceUnits), 1, 10, 6], [], %6]",
					_enemySide,
					_locName,
					_locPos,
					_locRadius,
					_locRadius + _forEachIndex,
					_enemyDAC
					];
				};
				case 2: { format["%1, '%2', 'urbanZone', %3, %4, [[%5, 1, 0], [([6, 'light', _missionType] call tg_fnc_balanceUnits), 2, 10, 6], [([2, 'medium', _missionType] call tg_fnc_balanceUnits), 2, 10, 5], [([random 1, 'heavy', _missionType] call tg_fnc_balanceUnits), 1, 8, 4], [], %6]",
					_enemySide,
					_locName,
					_locPos,
					_locRadius,
					_locRadius + _forEachIndex,
					_enemyDAC
					];
				};
				case default { format["%1, '%2', 'urbanZone', %3, %4, [[%5, 1, 0], [([random 2, 'light', _missionType] call tg_fnc_balanceUnits), 1, 10, 5], [([random 2, 'medium', _missionType] call tg_fnc_balanceUnits), 1, 6, 3], [], [], %6]",
					_enemySide,
					_locName,
					_locPos,
					_locRadius,
					_locRadius + _forEachIndex,
					_enemyDAC
					];
				};	
			};
					
			// Create a trigger that sets up a DAC Zone (we don't want 100's of active zones at the start takes ~20mins to initialise!)
			private _locTrigger = createTrigger ["EmptyDetector", _locPos, false];
			_locTrigger setTriggerTimeout [1, 1, 1, false];
			_locTrigger setTriggerArea [1250 + (_locRadius / 2), 1250 + (_locRadius / 2), 0, true];
			_locTrigger setTriggerActivation [format["%1", tg_playerSide], "PRESENT", false];
			_locTrigger setTriggerStatements [ 	"this", 
												format["['%1',[[%2]]] spawn tg_fnc_DACzone_creator; 
													['%1', %3, %4, %5] spawn tg_fnc_urbanObjective; 
													[%3, %4, %6 + random (%6 / 2), [%7, %8, %9, '%10']] spawn tg_fnc_spawnVehicle; 
													deleteVehicle thisTrigger;",
													_locName,
													_DACZone,
													_locPos,
													_locRadius,
													_enemyArray,
													_locVehicles,
													_spawnA,
													_spawnL,
													_spawnS,
													if _spawnM then { _enemySide } else { "Civ" }
													], 
												""
											];
						
			// TODO: Future version of Arma can activate a trigger from any playable unit.
			//_locTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
		};
	} forEach _locationPos;
} forEach ["Airport","NameCityCapital","NameCity","NameVillage","NameLocal"];