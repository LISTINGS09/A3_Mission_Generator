// Functions

if !(leader player == player) exitWith {};

zmm_fnc_canSelect = { missionNamespace getVariable ["ZMM_missionStarted",FALSE] };

// TODO: handle safe zones?

zmm_fnc_selectLocation = {
	if (call zmm_fnc_canSelect) exitWith { systemChat "[ZMM] ERROR: Mission is already in progress."; };
	systemChat "Click on any Location, then click 'Confirm Selection' in map screen when done.";
	onMapSingleClick 	"private _locArr = nearestLocations [_pos, ['NameLocal', 'NameVillage', 'NameCity', 'NameCityCapital', 'Airport'], 150];
						if (count _locArr > 0) then {
								systemChat format['Target: %1', text (_locArr select 0)];
								ZMM_targetLocation = position (_locArr select 0);
								'loc_mkr' setMarkerPos ZMM_targetLocation;
						} else {
							if (surfaceIsWater _pos) then {
								systemChat 'A flat location must be selected!';
							} else {
								ZMM_targetLocation = _pos;
								'loc_mkr' setMarkerPos ZMM_targetLocation;
							}
						};
						'loc_mkr' setMarkerAlpha 1;
						format['[ZMM] Located selected by %1', name player] remoteExec ['SystemChat'];
						true";	
};

zmm_fnc_confirm = {
	if (call zmm_fnc_canSelect) exitWith { systemChat "[ZMM] ERROR: Mission is already in progress."; };
	if (!isNil "ZMM_targetLocation") then {
		publicVariable "ZMM_targetLocation";
		"loc_mkr" setMarkerType "mil_circle";
	} else {
		systemChat "[ZMM] ERROR: No location has been selected!";
	};
};

// Don't do anything if the mission has been selected.
if (call zmm_fnc_canSelect) exitWith {};

if (isNil "loc_mkr") then {
	_mkr = createMarker ["loc_mkr",[0,0]];
	_mkr setMarkerShape "ICON";
	_mkr setMarkerColor format["Color%1",side group player];
	_mkr setMarkerType "selector_selectedMission";
};

// Announce players side if not logged.
if (isNil "ZMM_playerSide") then {
	missionNamespace setVariable ["ZMM_playerSide", side group player, true];
};

_ZMM = format["
	<font size='18' color='#FF7F00'>Commander Selection</font><br/>
	Click 'Select Location' to choose where to begin your Assignment.<br/>
	<execute expression=""[] call zmm_fnc_selectLocation;"">Select Location</execute><br/>
	<br/>
	<br/>
	Choosing any option below will attempt to force a type of mission (if the location allows it).<br/>
	<execute expression=""missionNamespace setVariable['ZMM_MissionChoice', '', true]; format['[ZMM] %1 switched to mission type: Random', name player] remoteExec ['SystemChat'];"">Random</execute> - Choose a random objective (DEFAULT).<br/>
	<execute expression=""missionNamespace setVariable['ZMM_MissionChoice', 'Building', true]; format['[ZMM] %1 switched to mission type: Building', name player] remoteExec ['SystemChat'];"">Building</execute> - Destroy or capture an area specific building (Comms Tower etc)<br/>
	<execute expression=""missionNamespace setVariable['ZMM_MissionChoice', 'Clear', true]; format['[ZMM] %1 switched to mission type: Clear', name player] remoteExec ['SystemChat'];"">Clear</execute> - Clear a building/location of enemies.<br/>
	<execute expression=""missionNamespace setVariable['ZMM_MissionChoice', 'Convoy', true]; format['[ZMM] %1 switched to mission type: Convoy', name player] remoteExec ['SystemChat'];"">Convoy</execute> - Destroy a Convoy.<br/>
	<execute expression=""missionNamespace setVariable['ZMM_MissionChoice', 'Data', true]; format['[ZMM] %1 switched to mission type: Data', name player] remoteExec ['SystemChat'];"">Data</execute> - Download or Upload a set of data.<br/>
	<execute expression=""missionNamespace setVariable['ZMM_MissionChoice', 'Defend', true]; format['[ZMM] %1 switched to mission type: Defend', name player] remoteExec ['SystemChat'];"">Defend</execute> - Hold a location.<br/>
	<execute expression=""missionNamespace setVariable['ZMM_MissionChoice', 'Destroy', true]; format['[ZMM] %1 switched to mission type: Destroy', name player] remoteExec ['SystemChat'];"">Destroy</execute> - Destroy a target.<br/>
	<execute expression=""missionNamespace setVariable['ZMM_MissionChoice', 'Rescue', true]; format['[ZMM] %1 switched to mission type: Rescue', name player] remoteExec ['SystemChat'];"">Rescue</execute> - Capture a person or vehicle.<br/>
	<execute expression=""missionNamespace setVariable['ZMM_MissionChoice', 'Search', true]; format['[ZMM] %1 switched to mission type: Search', name player] remoteExec ['SystemChat'];"">Search</execute> - Locate an object or vehicle.<br/>
	<br/>
	<br/>
	Once happy with your location, click confirm.<br/>
	<execute expression=""[] call zmm_fnc_confirm; format['[ZMM] Location confirmed by %1!', name player] remoteExec ['SystemChat'];"">Confirm Selection</execute><br/>
	<br/>
",profileName];

player createDiaryRecord ["diary", ["Mission Selection",_ZMM]];