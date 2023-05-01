// _nul = ["marker_1", "var_fillZone", independent, west, 0.2] execVM "fillGrid.sqf";
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

private _centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
private _playerSide = missionNamespace getVariable ["ZMM_playerSide", WEST];
private _enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
private _radius = ((getMarkerSize format["MKR_%1_MIN", _zoneID])#0) max 150; // Area of Zone.

private _gridCount = 0;

for "_z" from ((_centre#0)+(_radius * -1)) to ((_centre#0)+_radius) step 100 do {
	for "_y" from ((_centre#1)+(_radius * -1)) to ((_centre#1)+_radius) step 100 do {	
		private _tempPos = [((floor (_z / 100)) * 100) + 50, ((floor (_y / 100)) * 100) + 50, 0];
		private _gridName = format["MKR_ZMM_GRID_%1_%2", _tempPos#0,  _tempPos#1];		

		if (markerText _gridName isEqualTo "" && {!surfaceIsWater _tempPos} && ((_tempPos inArea format["MKR_%1_MIN", _zoneID]) || markerColor format["MKR_%1_MIN", _zoneID] == "")) then {
			private _tempMkr = createMarker [_gridName, _tempPos];
			_tempMkr setMarkerShape "RECTANGLE";
			_tempMkr setMarkerBrush "Solid"; // FDiagonal
			_tempMkr setMarkerAlpha 0.4;
			_tempMkr setMarkerSize [50,50];
			_tempMkr setMarkerColor ([_enemySide, true] call BIS_fnc_sideColor);
			
			// Create a trigger to switch the area colour.
			private _mrkTrigger = createTrigger ["EmptyDetector", _tempPos, false];
			_mrkTrigger setTriggerTimeout [10, 10, 10, true];
			_mrkTrigger setTriggerArea [50, 50, 0, true, 50];
			_mrkTrigger setTriggerActivation ["ANY", "PRESENT", false];
			_mrkTrigger setTriggerStatements [
				format["%1 countSide thisList < 2 && %2 countSide thisList > 0", _enemySide, _playerSide], 
				format["missionNamespace setVariable ['ZMM_%1_GRID', (missionNamespace getVariable ['ZMM_%1_GRID',0]) + 1, TRUE]; deleteMarker '%2'; deleteVehicle thisTrigger;", _zoneID, _gridName],
				""
			];
			
			_gridCount = _gridCount + 1;
		};
	};
};

_gridCount