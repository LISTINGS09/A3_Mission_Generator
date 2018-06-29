// Adds units (and optionally Insert/Exfil locations) to a Zone.
if !isServer exitWith {};

params [ "_zoneID", "_locType" ];

_centre = missionNamespace getVariable [ format[ "ZMM_%1_Location", _zoneID ], [0,0,0] ];
_side = missionNamespace getVariable [ format[ "ZMM_%1_EnemySide", _zoneID ], EAST ];
_pSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_mkrRad = (getMarkerSize format["MKR_%1_MAX", _zoneID]) select 0;

["DEBUG", format["Populating Zone %1 (%2) at %3 (%4)", _zoneID, _locType, _centre, _side]] call zmm_fnc_logMsg;

_unitCount = 10; // AI Garrison Couunt
_qrfTime = 600; // QRF Response Time (Secs)
_waves = 3; // QRF Total Waves

switch (_locType) do {
	case "Airport": { 
		_unitCount = 24;
		_qrfTime = 300;
		_waves = 5;
	};
	case "NameCityCapital": { 
		_unitCount = 36;
		_qrfTime = 300;
		_waves = 3;
	};
	case "NameCity": { 
		_unitCount = 22;
		_qrfTime = 600;
		_waves = 2;
	};
	case "NameVillage": { 
		_unitCount = 16;
		_qrfTime = 600;
		_waves = 2;
	};
	case "NameLocal": { 
		_unitCount = 12;
		_qrfTime = 600;
		_waves = 2;
	};
	case "Ambient": { 
		_unitCount = 12;
		_qrfTime = 0;
		_waves = 0;
	};
};

// Create Objective
_return = [];

if !(_locType isEqualTo "Ambient") then {
	if (missionNamespace getVariable ["ZZM_CTIMode", FALSE]) then {
		// Filled world only has one type of objective.
		[_zoneID] execVM format["%1\tasks\capture_location.sqf", ZMM_FolderLocation];
	} else {
		// This function returns some settings to overwrite AI population.
		// e.g. Defence missions have no AI to start.
		_return = [_zoneID] call zmm_fnc_setupTask;
	};
};

_return params [["_ovQRF", _qrfTime], ["_patrols", TRUE], ["_garrison", TRUE] ];
if !(_ovQRF isEqualTo _qrfTime) then { _qrfTime = _ovQRF };

["DEBUG", format["Zone %1 Patrol: %2  Garrison: %3  QRF: %4", _zoneID, _patrols, _garrison, _qrfTime]] call zmm_fnc_logMsg;

// Populate the area
if _patrols then { [ _zoneID, _locType ] spawn zmm_fnc_areaPatrols };
if _garrison then { [ _zoneID, _unitCount ] spawn zmm_fnc_areaGarrison };

// Set-up QRF
if (count (missionNamespace setVariable [ format["ZMM_%1_QRFLocations", _zoneID], [] ]) > 0 && {_qrfTime > 0}) then {
	_detectedTrg = createTrigger ["EmptyDetector", _centre, FALSE];
	_detectedTrg setTriggerActivation ["ANYPLAYER", "PRESENT", FALSE];
	_detectedTrg setTriggerTimeout [(_qrfTime / 2), (_qrfTime / 2), (_qrfTime / 2), TRUE];
	_detectedTrg setTriggerArea [_mkrRad, _mkrRad, 0, FALSE];
	_detectedTrg setTriggerStatements ["this", format["[%1, %2, %3, '%4'] spawn zmm_fnc_areaQRF;", _zoneID, _qrfTime, _waves, _locType], ""];
};