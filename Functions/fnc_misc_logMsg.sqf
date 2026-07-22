params ["_lev", "_msg"];

diag_log text format ["[ZMM] [%1] %2", _lev, _msg];

if (
	missionNamespace getVariable ["ZMM_Debug", false] || 
	_lev isEqualTo "ERROR"
) then { 
	format ["[ZMM] [%1] %2", _lev, _msg] remoteExec ["SystemChat"]
} else {
	systemChat format ["[ZMM] [%1] %2", _lev, _msg]
};