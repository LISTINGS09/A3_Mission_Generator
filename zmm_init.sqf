// Start ZMM by running:
// [] execVM "scripts\ZMM\zmm_init.sqf";
ZMM_Version = 3.7;
ZMM_FolderLocation = "scripts\ZMM"; // No '\' at end!
ZMM_Debug = !isMultiplayer;
// ZZM_Mode = 0 - Objective Selection
// ZZM_Mode = 1 - CTI Intel Mode
// ZZM_Mode = 2 - Fixed location, objective selection.
// ZZM_Mode = 0;
// ZZM_Diff = 0.5 - Which Part Is The Trigger
// ZZM_Diff = 0.7 - Walk In The Park
// ZZM_Diff = 1 - Lean Mean Killing Machine
// ZZM_Diff = 1.5 - Reaper Man
// ZZM_Diff = 2 - Freight Train O' Death
ZZM_Diff = 1; // Enemy strength multiplier
ZZM_IED = 1; // 0 - Disabled  1 - Enabled
ZZM_QRF = 1; // 0 - Disabled  1 - Enabled

"Group" setDynamicSimulationDistance 800;
"Vehicle" setDynamicSimulationDistance 1000;

#include "zmm_factions.sqf";

if (isNil "ZZM_Mode") then { ZZM_Mode = missionNamespace getVariable ["f_param_ZMMMode", 0] };
if (isNil "ZZM_Diff") then { ZZM_Diff = missionNamespace getVariable ["f_param_ZMMDiff", 1] };
if (isNil "ZZM_IED") then { ZZM_IED = missionNamespace getVariable ["f_param_ZMMIED", 1] };
if (isNil "ZZM_QRF") then { ZZM_QRF = missionNamespace getVariable ["f_param_ZMMQRF", 1] };

if (ZZM_Mode isEqualTo 0 && hasInterface) then { _nul = [] execVM format["%1\zmm_brief_custom.sqf", ZMM_FolderLocation] };
if (ZZM_Mode isEqualTo 2 && hasInterface) then { _nul = [] execVM format["%1\zmm_brief_fixed.sqf", ZMM_FolderLocation] };

if isServer then {
	EAST setFriend [RESISTANCE, 0];
	RESISTANCE setFriend [EAST, 0];
	WEST setFriend [RESISTANCE, 0];
	RESISTANCE setFriend [WEST, 0];
	
	// Register Functions
	if (isNil("zmm_fnc_aiUPS")) then {zmm_fnc_aiUPS = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_ai_ups.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_areaIED")) then {zmm_fnc_areaIED = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_area_ied.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_areaGarrison")) then {zmm_fnc_areaGarrison = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_area_garrison.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_areaPatrols")) then {zmm_fnc_areaPatrols = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_area_patrols.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_areaQRF")) then {zmm_fnc_areaQRF = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_area_qrf.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_areaRoadblock")) then {zmm_fnc_areaRoadblock = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_area_roadblock.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_areaSite")) then {zmm_fnc_areaSite = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_area_site.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_areaSupport")) then {zmm_fnc_areaSupport = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_area_support.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_intelAdd")) then {zmm_fnc_intelAdd = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_intel_add.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_logMsg")) then {zmm_fnc_logMsg = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_misc_logMsg.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_nameGen")) then {zmm_fnc_nameGen = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_misc_nameGen.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_setupPopulate")) then {zmm_fnc_setupPopulate = compileFinal preprocessFileLineNumbers format["%1\zmm_setup_populate.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_setupTask")) then {zmm_fnc_setupTask = compileFinal preprocessFileLineNumbers format["%1\zmm_setup_task.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_setupWorld")) then {zmm_fnc_setupWorld = compileFinal preprocessFileLineNumbers format["%1\zmm_setup_world.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_setupZone")) then {zmm_fnc_setupZone = compileFinal preprocessFileLineNumbers format["%1\zmm_setup_zone.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_spawnPara")) then {zmm_fnc_spawnPara = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_ai_spawnPara.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_spawnUnit")) then {zmm_fnc_spawnUnit = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_ai_spawnUnit.sqf", ZMM_FolderLocation]; };
	if (isNil("zmm_fnc_spawnObject")) then {zmm_fnc_spawnObject = compileFinal preprocessFileLineNumbers format["%1\Functions\fnc_ai_spawnObject.sqf", ZMM_FolderLocation]; };
	
	// Create a safe zone around all players.
	{
		_makeSZ = TRUE;
		_unit = _x;
		
		// Don't create a safe zone if the unit is already inside one!
		{
			if ((getPos _unit) inArea _x && {(toUpper _x) find "SAFEZONE" >= 0}) exitWith { _makeSZ = FALSE };
		} forEach allMapMarkers;
	
		if _makeSZ then {
			_safeMrk = createMarker [ format["SAFEZONE_PRE%1",_forEachIndex], getPos _x ];
			_safeMrk setMarkerShape "ELLIPSE";
			_safeMrk setMarkerBrush "FDiagonal";
			_safeMrk setMarkerAlpha 0.3;
			_safeMrk setMarkerColor format["color%1", side _x];
			_safeMrk setMarkerSize [ 2000, 2000];
			["DEBUG", format["Safe Zone '%1' created at %2", _safeMrk, getPos _x]] call zmm_fnc_logMsg;
		};
		
		if (isNil "ZMM_playerSide") then { ZMM_playerSide = side _x };
	} forEach (playableUnits + switchableUnits);
	
	ZMM_enemySides = [ WEST, EAST, INDEPENDENT ] - [ ZMM_playerSide ];
	
	// Populate Locations
	[] spawn zmm_fnc_setupWorld;
	
	// Waits for publicVariable then creates zone.
	if (ZZM_Mode isEqualTo 0) exitWith { _nul = [] execVM format["%1\zmm_setup_custom.sqf", ZMM_FolderLocation]; }; 
	if (ZZM_Mode isEqualTo 2) exitWith { _nul = [] execVM format["%1\zmm_setup_fixed.sqf", ZMM_FolderLocation]; }; 
};