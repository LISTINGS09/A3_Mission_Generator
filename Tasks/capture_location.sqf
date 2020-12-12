// Set-up mission variables.
// TODO Spawn some bunkers?
params [ ["_zoneID", 0], ["_targetPos", [0,0,0]] ];

_centre = missionNamespace getVariable [format["ZMM_%1_Location", _zoneID], _targetPos];
_enemySide = missionNamespace getVariable [format["ZMM_%1_EnemySide", _zoneID], EAST];
_playerSide = missionNamespace getVariable [ "ZMM_playerSide", WEST ];
_locations = missionNamespace getVariable [ format["ZMM_%1_FlatLocations", _zoneID], [] ];
_buildings = missionNamespace getVariable [ format["ZMM_%1_Buildings", _zoneID], [] ];
_menArray = missionNamespace getVariable format["ZMM_%1Man", _enemySide];
_locName = missionNamespace getVariable [format["ZMM_%1_Name", _zoneID], "this Location"];
_locType = missionNamespace getVariable [format["ZMM_%1_Type", _zoneID], "Custom"];

_flagNo = switch (_locType) do {
	case "Airport": { 4 };
	case "NameCityCapital": { 5 };
	case "NameCity": { 3 };
	case "NameVillage": { 2 };
	case "NameLocal": { 2 };
	default { 2 };
};

_missionDesc = [
		"Secure the area around <font color='#0080FF'>%1</font color> then locate and capture the <font color='#00FFFF'>%2 flag%3</font color> in the area.",
		"Capture <font color='#0080FF'>%1</font color> by claiming the surrounding area and locating the <font color='#00FFFF'>%2 flag%3</font color> somewhere in the area.",
		"<font color='#0080FF'>%1</font color> is occupied by enemy forces, eliminate them and secure the area by claiming the <font color='#00FFFF'>%2 flag%3</font color>.",
		"Claim the <font color='#00FFFF'>%2 flag%3</font color> located somewhere in <font color='#0080FF'>%1</font color> after you have eliminated all enemy forces there.",
		"Enemy forces have occupied <font color='#0080FF'>%1</font color>, eliminate them and claim the <font color='#00FFFF'>%2 flag%3</font color> in the area.",
		"Locate the <font color='#00FFFF'>%2 flag%3</font color> somewhere in <font color='#0080FF'>%1</font color> after you have liberated it from enemy forces."
	];
	
// Add any missed buildings.
if (count _buildings > 0) then {
	{
		_building = _x;
		if ({_x distance2D _building < 250} count _locations == 0) then {		
				_locations pushBack getPos _building;
		};
	} forEach _buildings;
};

if (count _locations == 0) then {
	_bPos = getPos (nearestBuilding _centre);

	if (_centre distance2D _bPos <= 250) then { 
		_locations pushBack _bPos;
	} else {
		_locations pushBack _centre;
	};
};

// Choose Flag Positions
_flagLocs = [];

for [{ _i = 1 }, { _i <= _flagNo && _i <= count _locations }, { _i = _i + 1 }] do {
	_rPos = selectRandom _locations;
	_locations deleteAt (_locations find _rPos);
	
	_emptyPos = _rPos findEmptyPosition [1, 25, "B_Soldier_F"];
	
	if (count _emptyPos == 0) then {
		_flagLocs pushBack _rPos;													
	} else {
		_flagLocs pushBack _emptyPos;
	};
};

_zmm_getFlag = {
	// Gets a flags object and texture from variable or assigns default.
	params [ "_flagSide", "_getTexture" ];
	
	_defaultFlag = switch ( _flagSide ) do { 
		case WEST: { ["Flag_Blue_F", "\A3\Data_F\Flags\Flag_Blue_CO.paa"]}; 
		case EAST: { ["Flag_Red_F", "\A3\Data_F\Flags\Flag_Red_CO.paa"]}; 
		case INDEPENDENT: { ["Flag_Green_F", "\A3\Data_F\Flags\Flag_Green_CO.paa"]}; 
		default { ["Flag_White_F", "\A3\Data_F\Flags\Flag_White_CO.paa"]};
	};
		
	_flagVar = missionNamespace getVariable [ format[ "ZMM_%1Flag", _flagSide ], _defaultFlag ];
	
	// Return Texture
	if (_getTexture) exitWith { _flagVar select 1 };
	
	// Return Model
	_flagVar select 0
};

_enemyGrp = createGroup [_enemySide, true];
_flagType = [ _enemySide, false ] call _zmm_getFlag;
_flagPTex = [ _playerSide, true ] call _zmm_getFlag;
_flagActivation = [];

{
	_flag = createVehicle [ _flagType, _x, [], 5, "NONE" ];
	_flag allowDamage false;
	_flag setVariable [ "var_number", _forEachIndex, true ];
	_flag setVariable [ "var_zoneID", _zoneID, true ];
	_flag setVariable [ "var_texture", _flagPTex, true ];
	
	[_flag, 
		"<t color='#00FF80'>Capture Flag</t>", 
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_unbind_ca.paa",  
		"\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_unbind_ca.paa",  
		"!(_target getVariable ['var_claimed', false]) && _this distance _target < 3", 
		"!(_target getVariable ['var_claimed', false]) && _caller distance _target < 3", 
		{}, 
		{}, 
		{ 	[ _target, _target getVariable ["var_texture", "\A3\Data_F\Flags\Flag_White_CO.paa"]] remoteExec ['setFlagTexture', 2];
			_flagNo = _target getVariable ["var_number", 0];
			_zoneID = _target getVariable ["var_zoneID", 0];
			{ _x setMarkerColor "ColorWest" } forEach [format["MKR_%1_FLAG_%2", _zoneID, _flagNo], format["MKR_%1_ICON_%2", _zoneID, _flagNo]];
			_target setVariable ['var_claimed', true];
			missionNamespace setVariable [ format["ZMM_%1_FLAG_%2", _zoneID, _flagNo], true];
			[ _target, _actionID ] remoteExec ["BIS_fnc_holdActionRemove"];
		}, 
		{}, 
		[], 
		5, 
		10 
	] remoteExec ["BIS_fnc_holdActionAdd", 0];
	
	// Child task
	_childTask = [[format["ZMM_%1_SUB_%2", _zoneID, _forEachIndex], format['ZMM_%1_TSK', _zoneID]], true, ["Find and capture the flag located somewhere within the marked area.", format["Flag #%1", _forEachIndex + 1], format["MKR_%1_ICON_%2", _zoneID, _forEachIndex]], objNull, "CREATED", 1, false, true, format["move%1", _forEachIndex + 1]] call BIS_fnc_setTask;
	_childTrigger = createTrigger ["EmptyDetector", _centre, false];
	_childTrigger setTriggerStatements [  format["(missionNamespace getVariable [ 'ZMM_%1_FLAG_%2', false ])", _zoneID, _forEachIndex],
									format["['ZMM_%1_SUB_%2', 'Succeeded', true] spawn BIS_fnc_taskSetState; deleteMarker 'MKR_%1_FLAG_%2'; deleteMarker 'MKR_%1_ICON_%2';", _zoneID, _forEachIndex],
									"" ];
	
	_flagActivation pushBack format["(missionNamespace getVariable ['ZMM_%1_FLAG_%2', false])", _zoneID, _forEachIndex];
	
	_relPos = [ position _flag, random 75, random 360 ] call BIS_fnc_relPos;
	
	_mrk = createMarker [ format[ "MKR_%1_FLAG_%2", _zoneID, _forEachIndex ], _relPos ];
	_mrk setMarkerShape "ELLIPSE";
	_mrk setMarkerBrush "SolidBorder";
	_mrk setMarkerAlpha 0.5;
	_mrk setMarkerColor format[ "color%1", _enemySide ];
	_mrk setMarkerSize [ 75, 75 ];
	
	_mrk = createMarker [ format["MKR_%1_ICON_%2", _zoneID, _forEachIndex ], _relPos ];
	_mrk setMarkerType "mil_flag";
	_mrk setMarkerAlpha 0.5;
	_mrk setMarkerColor format[ "color%1", _enemySide ];
	_mrk setMarkerSize [ 0.8, 0.8 ];
	
	if (surfaceIsWater _relPos) then {
		_flag setPosASL [position _flag select 0, position _flag select 1, 0];
		_flagStone = createSimpleObject [ "Land_W_sharpStone_02", [0,0,0] ];
		_flagStone setPosASL [ getMarkerPos _flagMarker select 0, (getMarkerPos _flagMarker select 1) - 5, -1 ];
	} else {
		// Spawn filler objects
		for "_i" from 0 to 1 + random 3 do {
			_sObj = createSimpleObject [selectRandom ["Land_WoodenCrate_01_F", "Land_WoodenCrate_01_stack_x3_F", "Land_WoodenCrate_01_stack_x5_F", "Land_TentA_F", "Land_Pallets_stack_F", "Land_PaperBox_01_open_empty_F", "Land_CratesWooden_F", "Land_Sacks_heap_F"], AGLToASL (_flag getPos [2 + random 5, random 360])]; 
			_sObj setDir random 360;
		};
		
		for "_i" from 0 to 1 + random 2 do {
			_unitType = selectRandom _menArray;
			_unit = _enemyGrp createUnit [_unitType, (_flag getPos [random 15, random 360]), [], 0, "NONE"];
			[_unit] joinSilent _enemyGrp; 
			_unit disableAI "PATH";
			_unit setDir ((_flag getRelDir _unit) - 180);
			_unit setFormDir ((_flag getRelDir _unit) - 180);
			_unit setUnitPos "MIDDLE";
			_unit setBehaviour "SAFE";
		};
	};
} forEach _flagLocs; 

// Wait before setting DS to allow positions to set.
_enemyGrp spawn { sleep 5; _this enableDynamicSimulation true };

// Create Completion Trigger
_objTrigger = createTrigger ["EmptyDetector", _centre, false];
_objTrigger setTriggerStatements [  (_flagActivation joinString " && "), 
									format["['ZMM_%1_TSK', 'Succeeded', true] spawn BIS_fnc_taskSetState; missionNamespace setVariable ['ZMM_DONE', true, true]; { _x setMarkerColor 'ColorWest' } forEach ['MKR_%1_LOC','MKR_%1_MIN']", _zoneID],
									"" ];

// Create Task
_missionTask = [format["ZMM_%1_TSK", _zoneID], true, [format["<font color='#00FF80'>Mission (#ID%1)</font><br/>", _zoneID] + format[selectRandom _missionDesc, _locName, count _flagActivation, if (count _flagActivation > 1) then {"s"} else {""}], ["Capture"] call zmm_fnc_nameGen, format["MKR_%1_LOC", _zoneID]], _centre, "CREATED", 1, false, true, "attack"] call BIS_fnc_setTask;

true