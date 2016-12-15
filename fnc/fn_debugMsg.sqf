if (!tg_debug) exitWith {};

params ["_message"];

systemChat _message;
diag_log text _message;

sleep 2;