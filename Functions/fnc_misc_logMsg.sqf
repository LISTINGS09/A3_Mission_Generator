params ["_lev", "_msg"];

if (missionNamespace getVariable ["ZMM_Debug", false] || !( toUpper _lev isEqualTo "DEBUG")) then { format["[ZMM] [%1] %2", _lev, _msg] remoteExec ["systemChat"] };
diag_log text format ["[ZMM] [%1] %2", _lev, _msg];
if (_lev isEqualTo "ERROR") then { format ["[ZMM] [%1] %2", _lev, _msg] remoteExec ["SystemChat"] };

