// Converts an array of numbers into a difficulty string for tasks.
//
// *** PARAMETERS ***
// _difficulty		INT		Difficult value (0 = Easy, 1 = Medium, 2 = Hard, 3 = Extreme)
// _infantryCount	INT		Number of infantry groups.
// _motorisedCount	INT		Number of motorised groups.
// _mechanisedCount	INT		Number of mechanised groups.
// _airCount		INT		Number of air groups.
//
// *** RETURNS ***
// String

params ["_difficulty", ["_infantryCount",[]], ["_motorisedCount",[]], ["_mechanisedCount",[]], ["_airCount",[]]];

_dEasy = ["I'm Bulletproof","Everyone Survives","Fish in a Barrel","Still Learning","Look; No Hands","Which part is the trigger?","Hugh Grant","Piece of Cake","Too Easy","Walk in the park","What a Lovely Day","Baby's First Mission","Too Young To Die"];
_dMedi = ["Bring the Morphine","Not Everyone Survives","Bruce Willis","Lets Rock","It'll be OK","I Think I Left The Stove On","They call me the cleaner","I have pet names for my grenades","Not Too Rough"];
_dHard = ["Bring the body-bags","I'm a big boy now","Chuck Norris","Come Get Some","Freight Train O'Death","None Shall Live","Nightmare"];

_textDifficulty = switch (_difficulty) do {
	case 0: { format["<br/><br/><font color='#00FF80'>Difficulty</font><br/>Easy (%1)<br/>",selectRandom _dEasy]; };
	case 1: { format["<br/><br/><font color='#00FF80'>Difficulty</font><br/>Average (%1)<br/>",selectRandom _dMedi]; };
	default { format["<br/><br/><font color='#00FF80'>Difficulty</font><br/>Hard (%1)<br/>",selectRandom _dHard]; };
}; 

_textDifficulty = _textDifficulty + "<br/><font color='#00FF80'>Enemy Strength</font><br/>";

{
	_typeName = ["Infantry","Motorised","Mechanised","Airborne"] select _forEachIndex;
	
	if (count _x < 3) then {
		_textDifficulty = _textDifficulty + format["%1 - <font color='#777777'>%2</font><br/>", _typeName, ["Unknown","Unlikely","Unlikely","None"] select _forEachIndex];
	} else {
		if (_forEachIndex == 0) then {
			private _infCount = round ((_x select 0) * ((_x select 1) * (_x select 1)) / 10);
			switch _infCount do {
				case 0; case 1: { 
					_textDifficulty = _textDifficulty + format ["%1 - <font color='#008000'>Fireteam</font><br/>", _typeName, _infCount];
				};
				case 2; case 3: { 
					_textDifficulty = _textDifficulty + format ["%1 - <font color='#008000'>Squad</font><br/>", _typeName, _infCount];
				};
				case 4; case 5; case 6; case 7:	{
					_textDifficulty = _textDifficulty + format ["%1 - <font color='#FFA500'>Platoon</font><br/>", _typeName, _infCount];
				};
				default {
					_textDifficulty = _textDifficulty + format ["%1 - <font color='#E50000'>Company</font><br/>", _typeName, _infCount];
				};
			}; 
		} else {
			switch (_x select 0) do {
				case 1: { 
					_textDifficulty = _textDifficulty + format ["%1 - <font color='#008000'>Low</font><br/>",_typeName, _x select 0];
				};
				case 2; case 3: {
					_textDifficulty = _textDifficulty + format ["%1 - <font color='#FFA500'>Medium</font><br/>",_typeName, _x select 0];
				};
				case 4; case 5: {
					_textDifficulty = _textDifficulty + format ["%1 - <font color='#E50000'>High</font><br/>",_typeName, _x select 0];
				};
				default {
					_textDifficulty = _textDifficulty + format ["%1 - <font color='#E50000'>Extreme</font><br/>",_typeName, _x select 0];
				};
			}; 
		};
	};
} forEach [_infantryCount, _motorisedCount, _mechanisedCount, _airCount];

_textDifficulty