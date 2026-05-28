// Start ZMM by running:
// [] execVM "scripts\ZMM\zmm_init.sqf";
ZMM_Version = 4.75;
ZMM_FolderLocation = "scripts\ZMM"; // No '\' at end!
ZMM_Debug = !isMultiplayer;
// ZZM_Template = "vanilla"; // Force Template
// ZZM_Mode = 0; // Objective Selection
// ZZM_Mode = 1; // CTI Intel Mode
// ZZM_Mode = 2; // C&C Mode.
// ZZM_Diff = 0.5; // Which Part Is The Trigger
// ZZM_Diff = 0.7; // Walk In The Park
// ZZM_Diff = 1; -//Lean Mean Killing Machine
// ZZM_Diff = 1.5; // Reaper Man
// ZZM_Diff = 2; // Freight Train O' Death
// ZZM_IED = 1; // 0 - Disabled  1 - Enabled
// ZZM_QRF = 1; // 0 - Disabled  1 - Enabled

"Group" setDynamicSimulationDistance 800;
"Vehicle" setDynamicSimulationDistance 1500;

if (isNil "ZZM_Mode") then { ZZM_Mode = missionNamespace getVariable ["f_param_ZMMMode", 1] };
if (isNil "ZZM_Diff") then { ZZM_Diff = missionNamespace getVariable ["f_param_ZMMDiff", 1] };
if (isNil "ZZM_IED") then { ZZM_IED = missionNamespace getVariable ["f_param_ZMMIED", 1] };
if (isNil "ZZM_QRF") then { ZZM_QRF = missionNamespace getVariable ["f_param_ZMMQRF", 1] };
if (isNil "ZZM_ZAU") then { ZZM_ZAU = missionNamespace getVariable ["f_param_ZZM_ZAU", 1] };
if (isNil "ZZM_Template") then {
	if ("rhs_main" in activatedAddons) exitWith { ZZM_Template = "RHS" };
	if ("gm_core" in activatedAddons) exitWith { ZZM_Template = "GM" };
	if ("ww2_spe_core_c_data_c" in activatedAddons) exitWith { ZZM_Template = "SPE" };
	if ("vn_data_f" in activatedAddons) exitWith { ZZM_Template = "VN" };
	if ("data_f_lxws" in activatedAddons && toLower worldName in ["sefrouramal"]) exitWith { ZZM_Template = "WS" };
};

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

// TODO:
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

if hasInterface then {
	switch (ZZM_Mode) do {
		case 0: { _nul = [] execVM format["%1\zmm_brief_custom.sqf", ZMM_FolderLocation] };
		case 2: { _nul = [] execVM format["%1\zmm_brief_commander.sqf", ZMM_FolderLocation] };
	};
};

if isServer then {
	EAST setFriend [RESISTANCE, 0];
	RESISTANCE setFriend [EAST, 0];
	WEST setFriend [RESISTANCE, 0];
	RESISTANCE setFriend [WEST, 0];

	// Load Units from Templates
	switch (toUpper (missionNamespace getVariable ["ZZM_Template","DEFAULT"])) do {
		case "GM": { call compileScript [format["%1\zmm_factions_gm.sqf", ZMM_FolderLocation]] };
		case "VN": { call compileScript [format["%1\zmm_factions_sog.sqf", ZMM_FolderLocation]] };
		case "WS": { call compileScript [format["%1\zmm_factions_sahara.sqf", ZMM_FolderLocation]] };
		case "SPE": { call compileScript [format["%1\zmm_factions_spe.sqf", ZMM_FolderLocation]] };
		case "RHS": { call compileScript [format["%1\zmm_factions_rhs.sqf", ZMM_FolderLocation]] };
		default { call compileScript [format["%1\zmm_factions_vanilla.sqf", ZMM_FolderLocation]] };		
	};
	// Broadcast Factions loaded from above
	{ missionNamespace setVariable [format["ZMM_%1_FactionName", _x], missionNamespace getVariable [format["ZMM_%1_FactionName", _x], "Unknown"], true] } forEach [WEST, EAST, INDEPENDENT];
	
	// Register Functions	
	{
		_x params ["_fncName", "_path"];

		if (isNil _fncName) then {
			missionNamespace setVariable [ _fncName, compileFinal preprocessFileLineNumbers format ["%1\%2", ZMM_FolderLocation, _path] ];
		};
	} forEach [
		["zmm_fnc_aiUPS", "Functions\fnc_ai_ups.sqf"]
		,["zmm_fnc_areaIED", "Functions\fnc_area_ied.sqf"]
		,["zmm_fnc_areaGarrison","Functions\fnc_area_garrison.sqf"]
		,["zmm_fnc_areamilitarise", "Functions\fnc_area_militarise.sqf"]
		,["zmm_fnc_areaPatrols", "Functions\fnc_area_patrols.sqf"]
		,["zmm_fnc_areaQRF", "Functions\fnc_area_qrf.sqf"]
		,["zmm_fnc_areaRoadblock", "Functions\fnc_area_roadblock.sqf"]
		,["zmm_fnc_areaSite", "Functions\fnc_area_site.sqf"]
		,["zmm_fnc_areaSupport", "Functions\fnc_area_support.sqf"]
		,["zmm_fnc_areaStatic", "Functions\fnc_area_static.sqf"]
		,["zmm_fnc_fillGrid", "Functions\fnc_misc_fillGrid.sqf"]
		,["zmm_fnc_intelAdd", "Functions\fnc_intel_add.sqf"]
		,["zmm_fnc_misc_logMsg", "Functions\fnc_misc_logMsg.sqf"]
		,["zmm_fnc_nameGen", "Functions\fnc_misc_nameGen.sqf"]
		,["zmm_fnc_misc_unitDirPos", "Functions\fnc_misc_unitDirPos.sqf"]
		,["zmm_fnc_setupPopulate", "zmm_setup_populate.sqf"]
		,["zmm_fnc_setupTask", "zmm_setup_task.sqf"]
		,["zmm_fnc_setupWorld", "zmm_setup_world.sqf"]
		,["zmm_fnc_setupZone", "zmm_setup_zone.sqf"]
		,["zmm_fnc_spawnObject", "Functions\fnc_ai_spawnObject.sqf"]
		,["zmm_fnc_zoneInfo", "Functions\fnc_misc_zoneInfo.sqf"]
		,["zmm_fnc_qrf_spawnPara", "Functions\fnc_qrf_spawnPara.sqf"]
		,["zmm_fnc_qrf_spawnGroup", "Functions\fnc_qrf_spawnGroup.sqf"]
		,["zmm_fnc_qrf_spawnCrew", "Functions\fnc_qrf_spawnCrew.sqf"]
		,["zmm_fnc_qrf_createWave", "Functions\fnc_qrf_createWave.sqf"]
		,["zmm_fnc_misc_isArmed", "Functions\fnc_misc_isArmed.sqf"]
		,["zmm_fnc_misc_checkConfig", "Functions\fnc_misc_checkConfig.sqf"]
		,["zmm_fnc_misc_findEnemySide", "Functions\fnc_misc_findEnemySide.sqf"]
		
	];
	
	// Create a safe zone around all players.
	{
		private _makeSZ = true;
		private _unit = _x;
		
		// Don't create a safe zone if the unit is already inside one!
		{
			if ((getPos _unit) inArea _x && {(toUpper _x) find "SAFEZONE" >= 0}) exitWith { _makeSZ = false };
		} forEach allMapMarkers;
	
		if _makeSZ then {
			private  _safeMrk = createMarker [ format["SAFEZONE_PRE%1",_forEachIndex], getPos _x ];
			_safeMrk setMarkerShape "ELLIPSE";
			_safeMrk setMarkerBrush "FDiagonal";
			_safeMrk setMarkerAlpha 0.8;
			_safeMrk setMarkerColor format["color%1", side group _x];
			_safeMrk setMarkerSize [ 2000, 2000];
			["DEBUG", format["Safe Zone '%1' created at %2", _safeMrk, getPos _x]] call zmm_fnc_misc_logMsg;
			
			private _blackList = missionNamespace getVariable ["ZCS_var_BlackList",[]];
			_blackList pushBackUnique _safeMrk;
			missionNamespace setVariable ["ZCS_var_BlackList", _blackList];
		};
		
		if (isNil "ZMM_playerSide") then { ZMM_playerSide = side group _x };
	} forEach (playableUnits + switchableUnits);
	
	ZMM_enemySides = [ WEST, EAST, INDEPENDENT ] - [ ZMM_playerSide ];
	
	// Populate Locations
	[] spawn zmm_fnc_setupWorld;
	
	// Waits for publicVariable then creates zone.
	switch (ZZM_Mode) do {
		case 0: { _nul = [] execVM format["%1\zmm_setup_custom.sqf", ZMM_FolderLocation] };
		case 2: { _nul = [] execVM format["%1\zmm_setup_commander.sqf", ZMM_FolderLocation] };
	};
	
	if (ZZM_ZAU == 1) then { _nul = [] execVM format["%1\zmm_script_ambientUnits.sqf", ZMM_FolderLocation] };
	
	// Check classnames
	{ [_x] call zmm_fnc_misc_checkConfig } forEach ZMM_enemySides;
};