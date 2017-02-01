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
	_x params ["_objType", "_objPos", "_objDir"];
	//[format["[TG] DEBUG objectSpawner: Creating %1 at %2", _objType, _objPos]] call tg_fnc_debugMsg;
	
	_objDir = -_spawnDir + _objDir;
	_objPos = [(_spawnPos select 0) + ((_objPos select 0) * (cos _spawnDir))- ((_objPos select 1) * (sin _spawnDir)),
				(_spawnPos select 1) + ((_objPos select 1) * (cos _spawnDir))+ ((_objPos select 0) * (sin _spawnDir)), 
				(_spawnPos select 2) + (_objPos select 2)];
	
	private _obj = _objType createVehicle [0,0,0];
	_obj setPos _objPos;
	_obj setDir _objDir;
	
	if (count _x > 3) then { 
		missionNamespace setVariable [_x select 3, _obj];
		// Named objects are always aligned straight (since they are towers etc)
		_obj setVectorUp [0,0,1];
	};
		/* else {
		/*private _tempV = _objType createVehicleLocal _objPos;
		_tempV setPos _objPos;
		_tempV setDir _objDir;		
		_obj = createSimpleObject [(getModelInfo _tempV select 1), (getPosWorld _tempV)];
		_obj setVectorDirAndUp [vectorDir _tempV, vectorUp _tempV];
		
		// TODO: Can't get this to work.
		private _tempV = _objType createVehicleLocal [0,0,0];
		_obj = [[typeOf _tempV, (getModelInfo _tempV) select 1], _objPos, _objDir, true] call BIS_fnc_createSimpleObject;
		
		deleteVehicle _tempV;
	};*/
} forEach _itemList;