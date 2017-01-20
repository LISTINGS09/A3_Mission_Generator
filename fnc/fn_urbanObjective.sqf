// Attempts to allow an urban objective (spawned by fill_towns) to be completed.
//
// *** PARAMETERS ***
// _searchPos	ARRAY		Position to search around.
//	_inDist		INT			Distance to search around.
// _classNames	STRING		Arma Location types to search for
// _returnOne	BOOLEAN		Skip any Blacklist/Safe Zone checking.
//
// *** RETURNS ***
// Array with matched object(s)
//
// *** USAGE ***
// [[0,0,0], 5000, ["Land_Warehouse_03_F"], false] call tg_fnc_findWorldLocation;
if !isServer exitWith {};

params ["_urbanName", "_urbanPos", "_urbanRadius", "_enemyArray"];

[format["[TG] DEBUG urbanObjective: [%1, %2, %3]", _urbanName, _urbanPos, _urbanRadius]] call tg_fnc_debugMsg;

// Find the nearest road to put the flagpole nearby.
private _roadList = _urbanPos nearRoads 200;
private _roadPos = [0,0,0];
// If a road is found, put the new location there.
if (count _roadList > 0) then {
	{
		if (_urbanPos distance2D (getPos _x) < _urbanPos distance2D _roadPos) then {
			_roadPos = getPos _x;
		};
	} forEach _roadList;
};

//_urbanPos = _urbanPos findEmptyPosition [5, 150, "Land_PaperBox_closed_F"];

// Find a safe position to put the flagpole at.
_urbanPos = [_urbanPos, 25, 75, 1, 0, 0.25, 0] call BIS_fnc_findSafePos;

private _flag = "FlagPole_F" createVehicle _urbanPos;
_flag setVectorUp [0,0,1];

[_flag, ["Raise Flag", 
	format["
		if !(missionNamespace getVariable ['%1',false]) then {
			['%1', 'sideMission'] remoteExec ['tg_fnc_missionEnd', 2];
			[(_this select 0), '\A3\Data_F\Flags\Flag_uk_CO.paa'] remoteExec ['setFlagTexture', 2];
			'%1_marker' setMarkerAlpha 0; 
			[%2, %3] remoteExec ['tg_fnc_safeZone_creator', 2];
		};
	", _urbanName, _urbanPos, _urbanRadius]
	]
] remoteExec ["addAction", 0, _flag];

private _flagMarker = createMarkerLocal [format["%1_flag_marker", _urbanName], _urbanPos];
_flagMarker setMarkerType "Mil_Dot";
_flagMarker setMarkerColor "ColorYellow";

/*
_foundObj = [_urbanPos, _urbanRadius, ["Land_Warehouse_03_F","Land_i_Shed_Ind_F","Land_u_Shed_Ind_F"]] call tg_fnc_findObjects;

diag_log format["Returned: %1", _foundObj];

if (count _foundObj > 0) then {
	_obj = _foundObj select 0;
	
	private _objMkr = createMarker [format["%1_%2",_locName, typeOf _obj], (getPos _obj)];
	_objMkr setMarkerColorLocal ([_enemySide, true] call BIS_fnc_sideColor);
	_objMkr setMarkerSizeLocal [0.5,0.5];
	_objMkr setMarkerTypeLocal "mil_pickup";
};*/