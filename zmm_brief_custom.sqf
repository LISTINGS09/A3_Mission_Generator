// Functions
if !(leader player == player) exitWith {};

zmm_fnc_selectLocation = {
	if (missionNamespace getVariable ["ZMM_targetPicked", false]) exitWith { systemChat "[ZMM] ERROR: Mission is already in progress."; };
	systemChat "Click on any Location, then click 'Confirm Selection' in map screen when done.";
	onMapSingleClick 	"private _locArr = nearestLocations [_pos, ['NameLocal', 'NameVillage', 'NameCity', 'NameCityCapital', 'Airport', 'Hill'], 300, _pos];
						private _size = 400;
						private _posID = '';
						systemChat format['Count: %1', count _locArr];
						if (count _locArr > 0) then {
							private _loc = _locArr#0;
							private _cfgLoc = ""getText (_x >> 'name') == text _loc && getText (_x >> 'type') == type _loc"" configClasses (configFile >> 'CfgWorlds' >> worldName >> 'Names');
							_posID = format['%1 (%2)', text (_locArr#0), getText ((_cfgLoc#0) >> 'type')];
							_size = (getNumber ((_cfgLoc#0) >> 'radiusA') max getNumber ((_cfgLoc#0) >> 'radiusB')) max _size;
							ZMM_targetLocation = position (nearestBuilding (position _loc));
							publicVariableServer 'ZMM_targetLocation';
							'loc_mkr' setMarkerPos ZMM_targetLocation;
							'loc_mkr' setMarkerSize [_size,_size];
						} else {
							if (surfaceIsWater _pos) then {
								systemChat 'A flat location must be selected!';
								ZMM_targetLocation = nil;
								'loc_mkr' setMarkerPos [0,0];
							} else {
								ZMM_targetLocation = _pos;
								_posID = format ['%1 (Rural Area)', mapGridPosition _pos];
								publicVariableServer 'ZMM_targetLocation';
								'loc_mkr' setMarkerPos _pos;
								'loc_mkr' setMarkerSize [_size,_size];
							}
						};
						format['[ZMM] %1: Location - %2', name player, _posID] remoteExec ['SystemChat'];
						true";	
};

zmm_fnc_confirm = {
	if (missionNamespace getVariable ["ZMM_targetPicked", false]) exitWith { systemChat "[ZMM] ERROR: Mission is already in progress."; };
	if (!isNil "ZMM_targetLocation") then {
		missionNamespace setVariable ["ZMM_targetPicked", true, true];
		systemChat "[ZMM] LOCATION: Confirmed";
	} else {
		systemChat "[ZMM] ERROR: No location has been selected!";
	};
};

// Don't do anything if the mission has been selected.
if (missionNamespace getVariable ["ZMM_targetPicked", false]) exitWith {};

if (isNil "loc_mkr") then {
	_mkr = createMarker ["loc_mkr",[0,0]];
	_mkr setMarkerShape "ELLIPSE";
	_mkr setMarkerColor "ColorWhite";
	_mkr setMarkerBrush 'Border';
	_mkr setMarkerAlpha 1;
	_mkr setMarkerSize [0,0];
};

// Announce players side if not logged.
if (isNil "ZMM_playerSide") then {
	missionNamespace setVariable ["ZMM_playerSide", side group player, true];
};

private _ZMMtext = "<font size='18' color='#FF7F00'>Commander Selection</font><br/>
	<font size='16' color='#80FF00'>1. Select Location</font><br/>
	<execute expression=""[] call zmm_fnc_selectLocation;"">Select Location</execute> and choose where to begin your Assignment. Any place not on water may be selected.<br/><br/>
	<font size='16' color='#80FF00'>2. Choose Mission</font><br/>
	Choosing any option below will attempt to force a type of mission (if the objective cannot be created, an alternative will be chosen).
	<br/><execute expression=""missionNamespace setVariable['ZMM_MissionChoice', '', true]; format['[ZMM] %1 switched to mission type: Random', name player] remoteExec ['SystemChat'];"">Random</execute> - Choose a random objective <font color='#00FFFF'>DEFAULT</font>.<br/>";
	
	{
		_x params ["_mIcon","_mType","_mDesc"];
		
		_ZMMtext = _ZMMtext + format["<img width='15' image='%4'/> <execute expression=""missionNamespace setVariable['ZMM_MissionChoice', '%1', true]; '[ZMM] %2: Mission - %1'remoteExec ['SystemChat'];"">%1</execute> - %3.<br/>",
			_mType,
			name player,
			_mDesc,
			_mIcon
		];
	} forEach [
		["\A3\ui_f\data\igui\cfg\simpleTasks\types\defend_ca.paa","Defence","Clear and hold a location from enemy forces"],
		["\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa","Denial","Destroy or weaken the opposing sides ability to wage war"],
		["\A3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa","Intel","Find, download or upload Intelligence"],
		["\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa","Recovery","Find and obtain an object or vehicle"],
		["\A3\ui_f\data\igui\cfg\simpleTasks\types\help_ca.paa","Rescue","Assist an ally in need of protection or aid"],
		["\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa","Secure","Clear a building or location of enemy forces"]
	];

_ZMMtext = _ZMMtext + "<br/><br/><font size='16' color='#80FF00'>3. Confirm</font><br/>Once happy with your location <execute expression=""[] call zmm_fnc_confirm;"">Confirm Selection</execute><br/><br/>";
	

player createDiaryRecord ["diary", ["Mission Selection", _ZMMtext]];