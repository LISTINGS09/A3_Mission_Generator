// Functions
zmm_fnc_canSelect = { missionNamespace getVariable ["ZMM_missionStarted",FALSE] };

zmm_fnc_selectLocation = {
	if (call zmm_fnc_canSelect) exitWith { systemChat "[ZMM] ERROR: Mission is already in progress."; };
	systemChat "Click on a Location, then click confirm in map screen when done.";
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
	<font color='#66B2FF'><execute expression=""[] call zmm_fnc_selectLocation;"">Select Location</execute></font><br/>
	<br/>
	<br/>
	Once happy with your location, click confirm.<br/>
	<font color='#66B2FF'><execute expression=""[] call zmm_fnc_confirm;"">Confirm Selection</execute></font><br/>
	<br/>
",profileName];

player createDiaryRecord ["diary", ["Mission Selection",_ZMM]];