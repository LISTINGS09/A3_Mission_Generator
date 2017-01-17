// Emulates the GroupCFG object spawning, iterates the array and spawns objects relative to a position.
//
// *** PARAMETERS ***
// _itemList	ARRAY		Array of objects with locations and direction.
// _spawnPos	ARRAY		Position to spawn at.
// _spawnDir	INT
//
// *** RETURNS ***
// Nothing

params [["_itemList", [], [[]]], ["_spawnPos", [0, 0, 0], [[]]], ["_spawnDir", 0, [0]]];

{
	private _obj = (_x select 0) createVehicle [0,0,0];
	private _objPos = _x select 1;	// Position of the item.
	private _objDir = _x select 2;	// Direction of the item.
	
	if (count _x > 3) then { missionNamespace setVariable [_x select 3, _obj]; };
	
	_obj setDir (-_spawnDir + _objDir);
	_obj setPos [(_spawnPos select 0) + ((_objPos select 0) * (cos _spawnDir))- ((_objPos select 1) * (sin _spawnDir)),
					(_spawnPos select 1) + ((_objPos select 1) * (cos _spawnDir))+ ((_objPos select 0) * (sin _spawnDir)), 
					(_spawnPos select 2) + (_objPos select 2)];
} forEach _itemList;