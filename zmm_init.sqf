// Start ZMM by running:
// [] execVM "scripts\ZMM\zmm_init.sqf";
ZMM_Version = 4.27;
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
// ZZM_Diff = 1; // Enemy strength multiplier
// ZZM_IED = 1; // 0 - Disabled  1 - Enabled
// ZZM_QRF = 1; // 0 - Disabled  1 - Enabled

"Group" setDynamicSimulationDistance 800;
"Vehicle" setDynamicSimulationDistance 1000;

#include "zmm_factions.sqf";

if (isNil "ZZM_Mode") then { ZZM_Mode = missionNamespace getVariable ["f_param_ZMMMode", 0] };
if (isNil "ZZM_Diff") then { ZZM_Diff = missionNamespace getVariable ["f_param_ZMMDiff", 1] };
if (isNil "ZZM_IED") then { ZZM_IED = missionNamespace getVariable ["f_param_ZMMIED", 1] };
if (isNil "ZZM_QRF") then { ZZM_QRF = missionNamespace getVariable ["f_param_ZMMQRF", 1] };

if (ZZM_Mode isEqualTo 0 && hasInterface) then { _nul = [] execVM format["%1\zmm_brief_custom.sqf", ZMM_FolderLocation] };
if (ZZM_Mode isEqualTo 2 && hasInterface) then { _nul = [] execVM format["%1\zmm_brief_fixed.sqf", ZMM_FolderLocation] };

// Register Tasks
ZMM_tasks = [
	// ["Category", "Task Name", "Task Desc", "Icon", "Location Type", "Script", "Overwrite Params"];
	// Anywhere
	["Defence", "Defend Location", "Clear and hold a location from enemy forces", "\A3\ui_f\data\igui\cfg\simpleTasks\types\defend_ca.paa", "Anywhere", "defend_location.sqf", [300, false, false, false]]
	,["Defence", "Defend Site", "Capture and hold an enemy side from responding forces", "\A3\ui_f\data\igui\cfg\simpleTasks\types\defend_ca.paa", "Anywhere", "defend_site.sqf", [300, false, false, false]]
	,["Defence", "Defend Vehicle", "Hold a location and assist with repairing a civilian vehicle", "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", "Anywhere", "defend_vehicle.sqf", [300, false, false, false]]
	,["Denial", "Destroy Cache", "Take out a number of enemy weapons caches", "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa", "Anywhere", "destroy_cache.sqf"]
	,["Denial", "Destroy Target", "One or more specific buildings must be destroyed", "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa", "Anywhere", "destroy_target.sqf"]
	,["Denial", "Eliminate Group", "Track down and eliminate a group of infantry", "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa", "Anywhere", "kill_group.sqf"]
	,["Intel", "Intel Transfer", "Transfer data from a Terminal or UAV", "\A3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa", "Anywhere", "intel_transfer.sqf"]
	,["Intel", "Intel Search", "Track down intelligence left behind by an operative", "\A3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa", "Anywhere", "intel_garbage.sqf"]
	,["Intel", "Intel Meeting", "Obtain key intel by talking to local informants", "\A3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa", "Anywhere", "intel_talk.sqf"]
	,["Recovery", "Collect Backpack", "Find and collect one or more special backpacks", "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa", "Anywhere", "collect_backpack.sqf"]
	,["Recovery", "Collect Container", "Obtain the special items located inside containers", "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa", "Anywhere", "collect_container.sqf"]
	,["Recovery", "Collect Items", "Hunt down specific items found around a location", "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa", "Anywhere", "collect_items.sqf"]
	,["Recovery", "Collect Drop", "Secure a drop due to land shortly within the area", "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa", "Anywhere", "collect_paradrop.sqf"]
	,["Recovery", "Collect Weapon", "Obtain one or more weapons located in the location", "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa", "Anywhere", "collect_weapon.sqf"]
	,["Recovery", "Collect Minefield", "Recover an object from an enemy minefield", "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa", "Anywhere", "collect_minefield.sqf"]
	,["Secure", "Capture Location", "Capture the location by securing flags within the location", "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", "Anywhere", "capture_location.sqf"]
	,["Secure", "Capture Object", "Mark the locations of key objects in the area", "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", "Anywhere", "capture_object.sqf"]
	,["Secure", "Clear Location", "Eliminate all enemy forces from the location", "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", "Anywhere", "clear_location.sqf", [900]]
	,["Secure", "Clear Building", "Secure one or more buildings of significant value", "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", "Anywhere", "clear_building.sqf"]
	,["Secure", "Clear Uprising", "Track down HVTs that are directing attacks in the area", "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", "Anywhere", "clear_uprising.sqf"]
	,["Secure", "Kill Animals", "A number of animals must be eliminated", "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", "Anywhere", "kill_animal.sqf"]
	,["Secure", "Combat Patrol", "Move through a number of sectors around a location", "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", "Anywhere", "patrol_area.sqf"]
	
	// Buildings
	,["Denial", "Kill HVT", "Ensure a high value target is eliminated", "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa", "Building", "kill_hvt.sqf"]
	,["Rescue", "Prisoner Rescue", "Save a number of prisoners captured by enemy forces", "\A3\ui_f\data\igui\cfg\simpleTasks\types\help_ca.paa", "Building", "rescue_prisoner.sqf"]

	// Flat Areas
	,["Denial", "Destroy Site", "A target of opportunity will be present at a nearby site", "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa", "Location", "destroy_site.sqf"]
	,["Denial", "Crash Site", "Destroy a crashed wreck and any of its lost cargo", "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa", "Location", "destroy_crashsite.sqf"]
	,["Denial", "Destroy Tower", "Disrupt enemy communications by destroying a tower", "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa", "Location", "destroy_tower.sqf"]
	,["Recovery", "Collect Crash Site", "Locate a crashed wreck and recover its lost cargo", "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa", "Location", "collect_crashsite.sqf"]
	,["Rescue", "Minefield Rescue", "Recover people from an enemy minefield", "\A3\ui_f\data\igui\cfg\simpleTasks\types\help_ca.paa", "Location", "rescue_minefield.sqf"]
	,["Intel", "Intel Site", "Obtain a key item or document from an enemy site", "\A3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa", "Location", "intel_site.sqf"]

	// Roads
	,["Denial", "Destroy Convoy", "Eliminate an enemy convoy of three vehicles", "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa", "Road", "destroy_convoy.sqf"]
	,["Denial", "Destroy Vehicle", "Locate and destroy a mechanised or armoured vehicle", "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa", "Road", "destroy_vehicle.sqf"]
	,["Recovery", "Capture Vehicle", "Locate and capture a motorised enemy asset", "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa", "Road", "capture_vehicle.sqf"]
	,["Rescue", "Ambush Rescue", "Secure a number of personnel from an enemy ambush", "\A3\ui_f\data\igui\cfg\simpleTasks\types\help_ca.paa", "Road", "rescue_ambush.sqf"]
	,["Rescue", "Transport Rescue", "Free a number of personnel from an enemy transport", "\A3\ui_f\data\igui\cfg\simpleTasks\types\help_ca.paa", "Road", "rescue_transport.sqf"]
	,["Disarm", "IED Clearing", "Secure and disarm a number of IEDs within the location", "\A3\ui_f\data\igui\cfg\simpleTasks\types\mine_ca.paa", "Road", "disarm_ied.sqf"]
	
	,["Disarm", "Bomb Squad", "Diffuse charges that have been rigged to go off in the area", "\A3\ui_f\data\igui\cfg\simpleTasks\types\mine_ca.paa", "Anywhere", "disarm_bomb.sqf"]
	,["Disarm", "UXO Search", "Secure and remove a number of UXOs from the location", "\A3\ui_f\data\igui\cfg\simpleTasks\types\mine_ca.paa", "Anywhere", "disarm_uxo.sqf"]
];


// ,["Rescue", "Evacuate Civilians", "", "\A3\ui_f\data\igui\cfg\simpleTasks\types\help_ca.paa", "Anywhere", "rescue_civilians.sqf"]
// ,["Recovery", "Recover Supplies", "", "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", "Anywhere", "collect_supplies.sqf"]
// ,["Secure", "Capture Site", "", "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", "Anywhere", "capture_site.sqf"]
// ,["Intel", "Locate Intel", "Talk to the locals to locate an intelligence document", "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", "Anywhere", "intel_find.sqf"]
// ,["Recovery", "Repatriate Bodies", "", "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", "Anywhere", "collect_bodies.sqf"]
// ,["Denial", "Eliminate Sniper", "", "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa", "Anywhere", "destroy_sniper.sqf"]
// ,["Secure", "Capture Suspect", "", "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", "Anywhere", "capture_suspect.sqf"]
// ,["Denial", "Destroy Mortar", "", "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa", "Anywhere", "destroy_mortar.sqf"]
// ,["Rescue", "Rescue Pilot", "Destroy the crashed vehicle then locate and rescue the crew", "\A3\ui_f\data\igui\cfg\simpleTasks\types\help_ca.paa", "Anywhere", "rescue_pilot.sqf"]
// ,["Rescue", "Rescue Hostage", "", "\A3\ui_f\data\igui\cfg\simpleTasks\types\help_ca.paa", "Anywhere", "rescue_hostage.sqf"]


// INSTALL A SPY MICROPHONE
// neutralise 3 OFFICERS

// FREE A HOSTAGE
// PATROL AN AREA

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
		_makeSZ = true;
		_unit = _x;
		
		// Don't create a safe zone if the unit is already inside one!
		{
			if ((getPos _unit) inArea _x && {(toUpper _x) find "SAFEZONE" >= 0}) exitWith { _makeSZ = false };
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