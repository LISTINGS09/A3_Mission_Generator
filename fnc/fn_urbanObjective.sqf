// Attempts to allow an urban objective (spawned by fill_towns) to be completed by spawning a flag pole for players to use.
//
// *** PARAMETERS ***
// _urbanName	STRING		Name of the area - Used in variable names etc
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

params ["_urbanName", "_urbanPos", "_urbanRadius", "_urbanNameText", "_urbanDifficulty",["_flagType","FlagPole_F",[""]]];

[format["[TG] DEBUG urbanObjective: [%1, %2, %3, %4, %5]", _urbanName, _urbanPos, _urbanRadius, _urbanNameText, _urbanDifficulty]] call tg_fnc_debugMsg;

// Find the nearest area to spawn the collection.
private _nearBuilding = getPos (nearestBuilding _urbanPos);
private _emptyPos = _nearBuilding findEmptyPosition [1, 200, "B_Heli_Attack_01_F"];
private _flagOnly = false;

if (count _emptyPos == 0) then {
	_emptyPos = _urbanPos findEmptyPosition [1, 200, _flagType];
	_flagOnly = true;
	[format["[TG] DEBUG urbanObjective: No suitable pos found, using FLAG ONLY at %1.", _urbanPos]] call tg_fnc_debugMsg;
};

//if _flagOnly then {
	// Create objective flagpole.
	private _flagObj = _flagType createVehicle _emptyPos;
	missionNamespace setVariable [format["%1_Pole", _urbanName],_flagObj];
/*} else {
	//Land_BagFence_Round_F
	//Land_BagFence_Long_F
	[[
		[_flagType, [-2,-2,0], 0, format["%1_Pole",_urbanName]],
		["Land_BagFence_01_round_green_F", [-4.56116,-3.51306,-0.2], 29],  
		["Land_BagFence_01_long_green_F", [-1.87915,-3.6095,-0.2], 359], 
		["Land_BagFence_01_long_green_F", [-5.2655,-1.00415,-0.2], 269], 
		["Land_BagFence_01_round_green_F", [-0.986938,5.88501,-0.2], 180], 
		["Land_BagFence_01_round_green_F", [-2.74084,4.23425,-0.2], 89], 
		["Land_TTowerSmall_2_F", [-1.01001,4.28015,0], 180], 
		[selectRandom ["CargoNet_01_box_F", "Land_CargoBox_V1_F", "Land_PaperBox_closed_F", "Land_PaperBox_open_empty_F", "Land_Pallet_MilBoxes_F", "CargoNet_01_barrels_F"], [1.11841,-3.25647,0], random 45], 
		["Land_MetalBarrel_F", [4.25,2.87488,0], random 180], 
		["Land_MetalBarrel_F", [4.62476,3.52441,0], random 180], 
		["Land_BagFence_01_round_green_F", [0.570801,4.09338,-0.2], 270]
	], _emptyPos, random 90] call tg_fnc_objectSpawner;
};*/

if tg_debug then {
	private _flagMarker = createMarkerLocal [format["%1_flag_marker", _urbanName], _emptyPos];
	_flagMarker setMarkerTypeLocal "Mil_Dot";
	_flagMarker setMarkerColorLocal "ColorYellow";
};

// Create Task
private _urbanDesc = [
		"Secure the area around <font color='#0080FF'><marker name='%1_Enemy_Flag'>%2</marker></font color> then locate and capture the flag in the area.",
		"Capture <font color='#0080FF'><marker name='%1_Enemy_Flag'>%2</marker></font color> by claiming the surrounding area and locating the flagpole somewhere in the area.",
		"<font color='#0080FF'><marker name='%1_Enemy_Flag'>%2</marker></font color> is occupied by enemy forces, eliminate them and secure the area by finally claiming the flag.",
		"Claim the flag located somewhere in <font color='#0080FF'><marker name='%1_Enemy_Flag'>%2</marker></font color> after you have eliminated all enemy forces there.",
		"Enemy forces have occupied <font color='#0080FF'><marker name='%1_Enemy_Flag'>%2</marker></font color>, eliminate them and claim the flag in the area.",
		"Locate the flagpole somewhere in <font color='#0080FF'><marker name='%1_Enemy_Flag'>%2</marker></font color> after you have liberated it from enemy forces."
	];	

private _textDifficulty = _urbanDifficulty call tg_fnc_stringDifficulty;
//if (private _urbanNameText = text nearestLocation [_urbanPos, ""];
private _urbanTask = [format["%1_task", _urbanName], true, ["<font color='#00FF80'>Summary</font><br/>" +  format[(selectRandom _urbanDesc), _urbanName, _urbanNameText] + _textDifficulty, "Secure " + _urbanNameText, ""], objNull, "CREATED", 1, true, true, "navigate", true] call BIS_fnc_setTask;
missionNamespace setVariable [format["%1_task", _urbanName], _urbanTask];

private _flag = (missionNamespace getVariable format["%1_Pole", _urbanName]);
[_flag, ["Raise Flag", 
	format["
		['%1', 'sideMission', true] remoteExec ['tg_fnc_missionEnd', 2];
		[(_this select 0), '\A3\Data_F\Flags\Flag_uk_CO.paa'] remoteExec ['setFlagTexture', 2];
		'%1_Enemy_Flag' setMarkerColor '%5';
		['%1', %2, %3, '%4'] remoteExec ['tg_fnc_safeZone_creator', 2];
		[%2,playerSide] remoteExec ['tg_fnc_ammoDrop', 2];
	", _urbanName, _urbanPos, _urbanRadius, _urbanNameText, ([tg_playerSide, true] call BIS_fnc_sideColor)],
	"",
	0,
	true,
	true,
	"",
	format["!(missionNamespace getVariable ['%1',false]) && (missionNamespace getVariable ['var_%1_cleared',0]) >= ((missionNamespace getVariable ['var_%1_total',0]) * 0.5)", _urbanName]
	]
] remoteExec ["addAction", 0, _flag];

private _tempMkr = createMarkerLocal [format["tmp_%1",_urbanName], _urbanPos];
_tempMkr setMarkerShapeLocal "ELLIPSE";
_tempMkr setMarkerSizeLocal [_urbanRadius * 0.5,_urbanRadius * 0.5];

// Get the Enemy Sides colour from the pre-made marker.
private _enemySide = switch (toUpper (getMarkerColor format['%1_Enemy_Flag',_urbanName])) do {
		case "COLORWEST": { west };
		case "COLOREAST": { east };
		default { independent };
	};

// Create the shaded sections.
[_tempMkr, _urbanName, _enemySide, tg_playerSide, 0.6] call tg_fnc_fillGrid;
deleteMarkerLocal _tempMkr;