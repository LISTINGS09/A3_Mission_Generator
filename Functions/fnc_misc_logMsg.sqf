params ["_lev", "_msg"];

diag_log text format ["[ZMM] [%1] %2", _lev, _msg];

if (
	(missionNamespace getVariable ["f_param_debugMode",0] == 1 || 
	missionNamespace getVariable ["ZMM_Debug", false] || 
	!( toUpper _lev isEqualTo "DEBUG")) || 
	_lev isEqualTo "ERROR"
) then { 
	format ["[ZMM] [%1] %2", _lev, _msg] remoteExec ["SystemChat"] 
} else {
	systemChat format ["[ZMM] [%1] %2", _lev, _msg]
};