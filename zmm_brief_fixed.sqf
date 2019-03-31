// Functions

waitUntil {getMarkerType "loc_mkr" != "" };

_centre = getMarkerPos "loc_mkr";
_nearLoc = (nearestLocations [getMarkerPos "loc_mkr", ["Airport", "NameCityCapital", "NameCity", "NameVillage", "NameLocal"], 1000, _centre])#0;
_locName = if (getPos _nearLoc distance2D _centre < 200) then { text _nearLoc } else { "This Location" };

_ZMM = format["
	<font size='18' color='#FF7F00'>Commander Selection</font><br/>
	Mission Location: <marker name='loc_mkr'>%2</marker><br/>
	<br/>
	Choosing any option below will attempt to force a type of mission.<br/>
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
",profileName,_locName];

player createDiaryRecord ["diary", ["Mission Selection",_ZMM]];