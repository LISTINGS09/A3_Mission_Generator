// Set-up mission variables.
params [ ["_zoneID", 0], ["_doTask", TRUE], ["_markerName",""] ];

// If no marker was passed use 'MKR_[ZONEID]_MIN'
if (_markerName isEqualTo "") then { _markerName = format["MKR_%1_MIN", _zoneID] };

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], [0,0,0]];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_radius = (getMarkerSize _markerName) select 0; // Area of Marker.

_nearLoc = nearestLocation [_centre, ""];
_locName = if (getPos _nearLoc distance2D _centre < 200) then { text _nearLoc } else { "this Location" };
_locType = if (getPos _nearLoc distance2D _centre < 200) then { type _nearLoc } else { "Custom" };

_minGrids = switch (_locType) do {
	case "Airport": { 4 };
	case "NameCityCapital": { 4 };
	case "NameCity": { 3 };
	case "NameVillage": { 2 };
	case "NameLocal": { 2 };
	default { 1 };
};

_missionDesc = [
		"Enemy forces have occupied an area near <font color='#00FFFF'>%1</font>, eliminate them.",
		"A number of enemy groups have been spotted nearby <font color='#00FFFF'>%1</font>, locate and eliminate all contacts.",
		"Eliminate all enemy forces in the area nearby <font color='#00FFFF'>%1</font>.",
		"Enemy forces have recently entered <font color='#00FFFF'>%1</font>, destroy them before they can reinforce it.",
		"The enemy appears to have occupied <font color='#00FFFF'>%1</font> overnight, eliminate all forces there.",
		"Enemy forces are trying to capture <font color='#00FFFF'>%1</font>, move in and eliminate all resistance."
	];

// Hide marker
_markerName setMarkerAlpha 0;
	
// Find the centre of the cell the point is in.
_gridCentre = [((floor (_centre#0 / 100)) * 100) + 50, ((floor (_centre#1 / 100)) * 100) + 50, 0];
_gridCount = 0;

for [{_z = (floor (_radius / 100)) * -100}, {_z <= _radius}, {_z = _z + 100}] do {
	for [{_y = (floor (_radius / 100)) * -100}, {_y <= _radius}, {_y = _y + 100}] do {
		_tempPos = _gridCentre vectorAdd [_z, _y, 0];
		
		if (random 1 > 0.2 && {!surfaceIsWater _tempPos} && {_tempPos inArea _markerName}) then {
			_tempMrkName = format["MRK_%1_GRID_%2%3", _zoneID, _z, _y];
			_tempMkr = createMarker [ _tempMrkName, _tempPos];
			_tempMkr setMarkerShape "RECTANGLE";
			_tempMkr setMarkerBrush "Solid"; // FDiagonal
			_tempMkr setMarkerAlpha 0.4;
			_tempMkr setMarkerSize [50,50];
			_tempMkr setMarkerColor format["color%1", _enemySide];
						
			// Create a trigger to switch the area colour.
			private _mrkTrigger = createTrigger ["EmptyDetector", _tempPos, false];
			_mrkTrigger setTriggerTimeout [10, 10, 10, false];
			_mrkTrigger setTriggerArea [50, 50, 0, true, 40];
			_mrkTrigger setTriggerActivation ["ANY", "PRESENT", false];			
			_mrkTrigger setTriggerStatements [ 	format["({side _x == %1} count thisList) == 0 && ({side _x == %2} count thisList) > 0", _enemySide, _playerSide], 
												format["missionNamespace setVariable ['ZMM_%1_GRID', (missionNamespace getVariable ['ZMM_%1_GRID',0]) + 1, TRUE]; '%2' setMarkerColor 'color%3'; deleteVehicle thisTrigger;",
													_zoneID,
													_tempMrkName,
													_playerSide
												], "" ];

			_gridCount = _gridCount + 1;
		};
	};
};

// Stop here if task isn't required.
if !_doTask exitWith { TRUE };

// Create Completion Trigger
missionNamespace setVariable [format["ZMM_%1_TSK_Group", _zoneID], _milGroup];

_objTrigger = createTrigger ["EmptyDetector", _centre, FALSE];
_objTrigger setTriggerStatements [  format["(missionNamespace getVariable ['ZMM_%1_GRID',0]) >= %2", _zoneID, 1 max (_gridCount - _minGrids)], 
									format["['ZMM_%1_TSK', 'Succeeded', TRUE] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', TRUE, TRUE]; { _x setMarkerColor 'Color%2' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID, _playerSide],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], TRUE, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName], [_locName] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, FALSE, TRUE, "attack"] call BIS_fnc_setTask;

TRUE