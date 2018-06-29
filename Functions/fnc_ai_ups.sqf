// =========================================================================================================
//  Urban Patrol Script  
//  Version: 2.2.0
//  Author: Kronzky (www.kronzky.info / kronzky@gmail.com)
//  BIS Forum: http://forums.bistudio.com/showthread.php?147904-Urban-Patrol-Script&highlight=Urban+Patrol+Script
// ---------------------------------------------------------------------------------------------------------
//  Required parameters:
//    unit          = Unit to patrol area (1st argument)
//    markername    = Name of marker that covers the active area. (2nd argument)
//    (e.g. nul=[this,"town"] execVM "ups.sqf")
//
//  Optional parameters: 
//    random        = Place unit at random start position.
//    randomdn      = Only use random positions on ground level.
//    randomup      = Only use random positions at top building positions. 
//    min:n/max:n   = Create a random number (between min and max) of 'clones'.
//    prefix:string = Cloned units' names will start with this prefix.
//    nomove        = Unit will stay at start position until enemy is spotted.
//    nofollow      = Unit will only follow an enemy within the marker area.
//    delete:n      = Delete dead units after 'n' seconds.
//    nowait        = Do not wait at patrol end points.
//    noslow        = Keep default behaviour of unit (don't change to "safe" and "limited").
//    noai          = Don't use enhanced AI for evasive and flanking maneuvers.
//    showmarker    = Display the area marker.
//    trigger       = Display a message when no more units are left in sector.
//    empty:n       = Consider area empty, even if 'n' units are left.
//    track         = Display a position and destination marker for each unit.
//
//	  _nul = [this,"UPSZ","RANDOM"] execVM "scripts\UPS\UPS_Lite.sqf";
// =========================================================================================================

if (!isServer) exitWith {};
	
// how far opfors should move away if they're under attack
// set this to 200-300, when using the script in open areas (rural surroundings)
#define SAFEDIST 150

// how close unit has to be to target to generate a new one 
#define CLOSEENOUGH 10

// how close units have to be to each other to share information
#define SHAREDIST 500

// how long AI units should be in alert mode after initially spotting an enemy
#define ALERTTIME 120

// ---------------------------------------------------------------------------------------------------------
//echo format["[K] %1",_this];

// convert argument list to uppercase
_UCthis = [];
for [{_i=0},{_i<count _this},{_i=_i+1}] do {_e=_this select _i; if (typeName _e=="STRING") then {_e=toUpper(_e)};_UCthis set [_i,_e]};

// ***************************************** SERVER INITIALIZATION *****************************************

	// global functions
if (isNil("KRON_UPS_INIT")) then {
	KRON_UPS_INIT=0;

	// find a random position within a radius
	KRON_randomPos = {
		private["_tx","_ty","_xout","_yout"];
		params["_cx","_cy","_rx","_ry","_cd","_sd","_ad"];
		_tx=random (_rx*2)-_rx;
		_ty=random (_ry*2)-_ry;
		_xout=if (_ad!=0) then {_cx+ (_cd*_tx - _sd*_ty)} else {_cx+_tx};
		_yout=if (_ad!=0) then {_cy+ (_sd*_tx + _cd*_ty)} else {_cy+_ty};
		[_xout,_yout]
	};
	// find any building (and its possible building positions) near a position
	KRON_PosInfo = {
		private["_lst","_bld","_bldpos"];
		params["_pos"];
		_lst= nearestObjects [_pos,["House","vbs2_house"],20];
		if (count _lst==0) then {_bld=0;_bldpos=0} else {_bld=_lst select 0; _bldpos=[_bld] call KRON_BldPos}; 
		[_bld,_bldpos]
	};
	/// find the highest building position	
	KRON_BldPos = {
		private ["_bi","_bldpos","_maxZ","_bp","_bz","_higher"];
		params["_bld"];
		_maxZ=0;_bi=0;_bldpos=0;
		while {_bi>=0} do {
			_bp = _bld BuildingPos _bi;
			if ((_bp select 0)==0) then {
				_bi=-99
			} else {
				_bz=_bp select 2;
				_higher = ((_bz>_maxZ) || ((abs(_bz-_maxZ)<.5) && (random 1>.5))); 
				if ((_bz>4) && _higher) then {_maxZ=_bz; _bldpos=_bi}
			};
			_bi=_bi+1
		};
		_bldpos
	};

	KRON_OnRoad = {
		private["_lst"];
		params["_pos","_car","_tries"];
		_lst=_pos nearRoads 4;
		if ((count _lst!=0) && (_car || !(surfaceIsWater _pos))) then {_tries=99}; 
		(_tries+1)
	};
	
	KRON_getDirPos = {
		private["_a","_b","_return"]; 
		params["_from","_to"];
		_return = 0; 
		_a = (_to select 0) - (_from select 0);
		_b = (_to select 1) - (_from select 1);
		if (_a != 0 || _b != 0) then {_return = _a atan2 _b}; 
		if ( _return < 0 ) then { _return = _return + 360 };
		_return
	};
	
	KRON_distancePosSqr = {
		(((_this select 0) select 0)-((_this select 1) select 0))^2 + (((_this select 0) select 1)-((_this select 1) select 1))^2
	};
	
	KRON_relPos = {
		private["_xout","_yout"];
		params["_p","_d","_a"];
		_p params["_xc","_yc"];
		_xout=_xc + sin(_a)*_d;
		_yout=_yc + cos(_a)*_d;
		[_xout,_yout,0]
	};
	
	KRON_rotpoint = {
		private["_cd","_sd","_xout","_yout"];
		params["_cp","_a","_tx","_ty"];
		_cp params["_cx","_cy"];
		_cd=cos(_a*-1);
		_sd=sin(_a*-1);
		_xout={if (_a!=0) then {_cx+ (_cd*_tx - _sd*_ty)} else {_cx+_tx}};
		_yout={if (_a!=0) then {_cy+ (_sd*_tx + _cd*_ty)} else {_cy+_ty}};
		[_xout,_yout,0]
	};
	
	KRON_stayInside = {
		private["_tp","_tx","_ty","_fx","_fy"];
		params["_np","_cp","_rx","_ry","_d"];
		_np params["_nx","_ny"];
		_cp params["_cx","_cy"];
		_tp = [_cp,_d,(_nx-_cx),(_ny-_cy)] call KRON_rotpoint;
		_tx = _tp select 0; _fx=_tx;
		_ty = _tp select 1; _fy=_ty;
		if (_tx<(_cx-_rx)) then {_fx=_cx-_rx};
		if (_tx>(_cx+_rx)) then {_fx=_cx+_rx};
		if (_ty<(_cy-_ry)) then {_fy=_cy-_ry};
		if (_ty>(_cy+_ry)) then {_fy=_cy+_ry};
		if ((_fx!=_tx) || (_fy!=_ty)) then {_np = [_cp,_d*-1,(_fx-_cx),(_fy-_cy)] call KRON_rotpoint};
		_np;
	};
		
	// Misc
	KRON_getArg = {
		private["_a","_v"];
		params["_cmd","_arg","_list"];
		_a=-1; 
		{
			_a=_a+1;
			_v=format["%1",_list select _a];
			if (_v==_cmd) then {_arg=(_list select _a+1)};
		} forEach _list;
		_arg
	};
	KRON_deleteDead = {
		params["_u","_s"];
		_u removeAllEventHandlers "killed";
		sleep _s;
		deleteVehicle _u;
	};
	KRON_KnownEnemy=[objNull,objNull,objNull]; // enemy information is shared between different groups
	
	if (isNil("KRON_UPS_Debug")) then { KRON_UPS_Debug = 0; };
	KRON_UPS_Instances=0;
	KRON_UPS_Total=0;
	KRON_UPS_INIT=1;
};

if ((count _this) < 2) exitWith {
	if (format["%1",_this]!="INIT") then {hint "UPS: Unit and marker name have to be defined!"};
};
_exit = false;
_onroof = false;

// ---------------------------------------------------------------------------------------------------------
waitUntil {KRON_UPS_INIT==1};

// get name of area marker 
_areamarker = _this select 1;
if (isNil ("_areamarker")) exitWith {
	hint "UPS: Area marker not defined.\n(Typo, or name not enclosed in quotation marks?)";
};	

_centerPos = [];
_centerX = [];
_centerY = [];
_rangeX = 0;
_rangeY = 0;
_areaDir = 0;
_areaname = "";
_areatrigger = objNull;
_showmarker = "HIDEMARKER";
_fn_getAreaInfo = {
	if (typeName _areamarker=="String") then {
		// remember center position of area marker
		_centerPos = getMarkerPos _areamarker;
		_centerX = abs(_centerPos select 0);
		_centerY = abs(_centerPos select 1);
	
		// X/Y range of target area
		_areasize = getMarkerSize _areamarker;
		_rangeX = _areasize select 0;
		_rangeY = _areasize select 1;
		// marker orientation (needed as negative value!)
		_areaDir = (markerDir _areamarker) * -1;
	
		_areaname = _areamarker;
		
		// show area marker 
		_showmarker = if ("SHOWMARKER" in _UCthis) then {"SHOWMARKER"} else {"HIDEMARKER"};
		if (_showmarker=="HIDEMARKER") then {
			_areamarker setMarkerAlpha 0;
		};
	} else {
		_centerPos = getPos _areamarker;
		_centerX = abs(_centerPos select 0);
		_centerY = abs(_centerPos select 1);
	
		// X/Y range of target area
		_rangeX = triggerArea _areamarker select 0;
		_rangeY = triggerArea _areamarker select 1;
		// marker orientation (needed as negative value!)
		_areaDir = (getDir _areamarker) * -1;
		
		_areaname = vehicleVarName _areamarker;
	};
	// update trigger position
	if !(isNull _areatrigger) then {
		_areatrigger setPos [_centerX,_centerY];
	};
};

[] call _fn_getAreaInfo;

// wait until mission start to continue
sleep (random 5);

KRON_UPS_Instances = KRON_UPS_Instances + 1;

// unit that's moving
_obj = _this select 0;		

if (isNil "_obj") exitWith {
	diag_log text format["[UPS] ERROR: Invalid UPS Unit %1", _obj];
	hint format["[UPS] ERROR: Invalid UPS Unit %1", _obj];
};

_upsUnit = _obj;
// is anybody alive in the group?
_exit = true;		
if (typeName _obj == "OBJECT") then {
	if (alive _upsUnit) then {_exit = false;}		
} else {
	if (count _obj > 0) then {
		{if (alive _x) then {_upsUnit = _x; _exit = false;}} forEach _obj;
	};
};

// give this group a unique index
_grpidx = format["%1",KRON_UPS_Instances];
_grpName = format["UPS_%1_%2",(side _upsUnit),_grpidx];

// remember the original group members, so we can later find a new leader, in case he dies
_groupMembers = units _upsUnit;
KRON_UPS_Total = KRON_UPS_Total + (count _groupMembers);

// what type of "vehicle" is unit ?
_isMan = _upsUnit isKindOf "Man";
_isCar = _upsUnit isKindOf "Car";
_isBoat = _upsUnit isKindOf "Ship";
_isPlane = _upsUnit isKindOf "Air";

// check to see whether group is neutral (for attack and avoidance manoeuvres)
_isSoldier = false;
{
	if (((side _upsUnit) getFriend _x)<.6) exitWith {
		_isSoldier = true;
	};
} forEach [east,west,independent,civilian];

_friends = [];
_enemies = [];	
_sharedEnemy = [side _upsUnit] call BIS_fnc_sideID;
if _isSoldier then {
	{
		if ([side _x, side _upsUnit] call BIS_fnc_areFriendly) then {
			_friends pushBack _x;
		} else {
			_enemies pushBack _x;
		};
	} forEach allUnits - _groupMembers;
};
sleep .01;
//player sidechat format["%1, friends: %2, enemies: %3 (%4)",_upsUnit,_friends,_enemies,_sharedEnemy];

// global unit variable to externally influence script 
_named = false;
_upsUnitname = format["%1_%2",side _upsUnit, _grpidx];
if ("NAMED" in _UCthis) then {
	_named = true;
	_upsUnitname = format["%1",_upsUnit];
	_grpidx = _upsUnitname;
};
// create global variable for this group
call compile format ["KRON_UPS_%1=1",_upsUnitname];

// store some trig calculations
_cosDir=cos(_areaDir);
_sinDir=sin(_areaDir);

// minimum distance of new target position
if (_rangeX==0) exitWith {
	diag_log text format["ERROR: UPS Cannot patrol Sector: %1 - No Area Marker",_areaname]; 
	hint format["UPS: Cannot patrol Sector: %1\nArea Marker doesn't exist",_areaname]; 
};
_minDist=(_rangeX^2+_rangeY^2)/4;

// remember the original mode & speed
_orgBehaviour = behaviour _upsUnit;
_orgSpeed = speedMode _upsUnit;
_speedMode = _orgSpeed;

// set first target to current position (so we'll generate a new one right away)
_currPos = getPos _upsUnit;
_orgPos = _currPos;
_orgWatch=[_currPos,50,getDir _upsUnit] call KRON_relPos; 
_orgDir = getDir _upsUnit;
_avoidPos = [0,0];
_flankPos = [0,0];
_attackPos = [0,0];

_dist = 0;
_lastDist = 0;
_lastMove1 = 0;
_lastMove2 = 0;
_maxMove=0;
_moved=0;

_damm=0;
_dammChg=0;
_lastDamm = 0;
_timeOnTarget = 0;

_fightMode = "walk";
_fm=0;
_wasHit = false;
_hitPos=[0,0,0];
_react = 99;
_lastDamage = 0;
_lastknown = 0;
_opfknowval = 0;

_sin90=1; _cos90=0;
_sin270=-1; _cos270=0;

// set target tolerance high for choppers & planes
_closeEnough=CLOSEENOUGH*CLOSEENOUGH;
if (_isPlane) then {_closeEnough=5000};

sleep .01;
// ***************************************** optional arguments *****************************************

// wait at patrol end points
_pause = if ("NOWAIT" in _UCthis) then {"NOWAIT"} else {"WAIT"};
// don't move until an enemy is spotted
_nomove  = if ("NOMOVE" in _UCthis || "NOWP" in _UCthis) then {"NOMOVE"} else {"MOVE"};
// don't follow outside of marker area
_nofollow = if ("NOFOLLOW" in _UCthis) then {"NOFOLLOW"} else {"FOLLOW"};
// share enemy info 
_shareinfo = if ("NOSHARE" in _UCthis) then {"NOSHARE"} else {"SHARE"};
// "area cleared" trigger activator
_usetrigger = if ("TRIGGER" in _UCthis) then {"TRIGGER"} else {if ("SILENTTRIGGER" in _UCthis) then {"SILENTTRIGGER"} else {"NOTRIGGER"}};
// suppress fight behaviour
if ("NOAI" in _UCthis) then {_isSoldier=false};
// adjust cycle delay 
_cycle = ["CYCLE:",10,_UCthis] call KRON_getArg;
// drop units at random positions
_initpos = "ORIGINAL";
if ("RANDOM" in _UCthis) then {_initpos = "RANDOM"};
if ("RANDOMUP" in _UCthis) then {_initpos = "RANDOMUP"}; 
if ("RANDOMDN" in _UCthis) then {_initpos = "RANDOMDN"}; 
// don't position groups or vehicles on rooftops
if ((_initpos!="ORIGINAL") && ((!_isMan) || (count _groupMembers)>1)) then {_initpos="RANDOMDN"};
// set behaviour modes (or not)
_noslow = if ("NOSLOW" in _UCthis) then {"NOSLOW"} else {"SLOW"};

if (_noslow != "NOSLOW") then {
	_upsUnit setBehaviour "SAFE"; 
	_upsUnit setSpeedMode "LIMITED";
	_orgBehaviour = "SAFE";
	_orgSpeed = "LIMITED";
	_speedMode = "LIMITED";
}; 

// make start position random 
if (_initpos!="ORIGINAL") then {
	// find a random position (try a max of 20 positions)
	_try=0;
	_bld=0;
	_bldpos=0;
	while {_try<20} do {
		_currPos=[_centerX,_centerY,_rangeX,_rangeY,_cosDir,_sinDir,_areaDir] call KRON_randomPos;
		if ((_initpos=="RANDOMUP") || ((_initpos=="RANDOM") && (random 1>.75))) then {
			_posinfo=[_currPos] call KRON_PosInfo;
			// _posinfo: [0,0]=no house near, [obj,-1]=house near, but no roof positions, [obj,pos]=house near, with roof pos
			_bld=_posinfo select 0;
			_bldpos=_posinfo select 1;
		};
		if (_isPlane || _isBoat || !(surfaceIsWater _currPos)) then {
			if (((_initpos=="RANDOM") || (_initpos=="RANDOMUP")) && (_bldpos>0)) then {_try=99};
			if (((_initpos=="RANDOM") || (_initpos=="RANDOMDN")) && (_bldpos==0)) then {_try=99};
		};
		_try=_try+1;
	};
	if (_bldpos==0) then {
		if (_isMan) then {
			_currPos = [_currPos, 1, 150, 4] call BIS_fnc_findSafePos;
			{_x setPos _currPos} forEach units _upsUnit; 
		} else {
			_tempPos = _currPos findEmptyPosition [0, 150, typeOf _upsUnit];
			if (count _tempPos > 0) then {
				_upsUnit setPos _tempPos; 
			} else {
				_upsUnit setPos _currPos; 
			};
		};
	} else {
		// put the unit on top of a building
		_upsUnit setPos (_bld buildingPos _bldpos); 
		_upsUnit setUnitPos "up";
		_currPos = getPos _upsUnit;
		_onroof = true;
		_exit=true; // don't patrol if on roof
	};
};
sleep .01;

// track unit
_track = 	if (("TRACK" in _UCthis) || (KRON_UPS_Debug > 0)) then {"TRACK"} else {"NOTRACK"};
_trackername = "";
_destName = "";
_markerDot = "";
if (_track=="TRACK") then {
	_track = "TRACK";
	_trackername=format["trk_%1",_grpidx];
	_markerobj = createMarkerLocal [_trackername,[0,0]];
	_markerobj setMarkerShapeLocal "ICON";
	_markerDot = "";
	{
		if (isClass(configFile >> "cfgMarkers" >> _x)) then {_markerDot = _x};
	} forEach ["DOT","WTF_Dot","MIL_DOT"];
	if (_markerDot=="") exitWith {};
	_trackername setMarkerTypeLocal _markerDot;
	_markercolor = switch (side _upsUnit) do {
		case west: {"ColorWest"};
		case east: {"ColorEast"};
		case independent: {"ColorGuer"};
		default {"ColorBlack"};
	};
	_trackername setMarkerColorLocal _markercolor;
	_trackername setMarkerTextLocal format["%1",_grpidx];
	_trackername setMarkerPosLocal (getPos _upsUnit); 
	_trackername setMarkerSizeLocal [.5,.5];
	
	_destName=format["dest_%1",_grpidx];
	_markerobj = createMarkerLocal [_destName,[0,0]];
	_markerobj setMarkerShapeLocal "ICON";
	if (isClass(configFile >> "cfgMarkers" >> "WTF_Flag")) then {"WTF_FLAG"} else {"FLAG"};
	_markertype = "";
	{
		if (isClass(configFile >> "cfgMarkers" >> _x)) then {_markertype = _x};
	} forEach ["FLAG","WTF_Flag","mil_objective"];
	_destName setMarkerTypeLocal _markertype;
	_destName setMarkerColorLocal _markercolor;
	_destName setMarkerTextLocal format["%1",_grpidx];
	_destName setMarkerSizeLocal [.5,.5];
};	
sleep .01;

// delete dead units
_deletedead = ["DELETE:",0,_UCthis] call KRON_getArg;
if (_deletedead>0) then {
	{_x addEventHandler['killed',format["[_this select 0,%1] spawn KRON_deleteDead",_deletedead]]}forEach _groupMembers;
};

// how many group clones?
// TBD: add to global side arrays?
_mincopies = ["MIN:",0,_UCthis] call KRON_getArg;
_maxcopies = ["MAX:",0,_UCthis] call KRON_getArg;
if (_mincopies>_maxcopies) then {_maxcopies=_mincopies};
if (_maxcopies>50) then { _maxcopies = 50; };
if (_maxcopies>0) then {
	if !(_isMan) exitWith {hint "Vehicles cannot be cloned."};
	_copies=_mincopies+round(random (_maxcopies-_mincopies));
	// any init strings?
	_initstr = ["INIT:","",_UCthis] call KRON_getArg;

	// name of clones
	_nameprefix = ["PREFIX:","UPSCLONE",_UCthis] call KRON_getArg;

	// create the clones
	for "_grpcnt" from 1 to _copies do {
		// group leader
		_unittype=typeOf _upsUnit;
		// copy groups
		if (isNil ("KRON_cloneindex")) then {
			KRON_cloneindex = 0;
		}; 
		// make the clones civilians
		// use random Civilian models for single unit groups
		if ((_unittype=="C_man_1") && (count _groupMembers==1)) then {_rnd=1+round(random 6); if (_rnd>1) then {_unittype=format["C_man_polo_%1_F",_rnd]}};
		
		_grp = createGroup [side _upsUnit,true];
		_lead = _grp createUnit [_unittype, getPos _upsUnit, [], 0, "form"];
		KRON_cloneindex = KRON_cloneindex+1;
		_lead setVehicleVarName format["%1%2",_nameprefix,KRON_cloneindex];
		call compile format["%1%2=_lead",_nameprefix,KRON_cloneindex];
		_lead setBehaviour _orgBehaviour;
		_lead setSpeedMode _orgSpeed;
		_lead setSkill skill _upsUnit;
		//_lead setVehicleInit _initstr;
		[_lead] join _grp;
		_grp selectLeader _lead;
		// copy team members (skip the leader)
		_c=0;
		{
			_c=_c+1;
			if (_c>1) then {
				_newunit = _grp createUnit [typeOf _x, getPos _x, [],0,"form"];
				KRON_cloneindex = KRON_cloneindex+1;
				_newunit setVehicleVarName format["%1%2",_nameprefix,KRON_cloneindex];
				call compile format["%1%2=_newunit",_nameprefix,KRON_cloneindex];
				_newunit setBehaviour _orgBehaviour;
				_newunit setSpeedMode _orgSpeed;
				_newunit setSkill skill _x;
				//_newunit setVehicleInit _initstr;
				[_newunit] join _grp;
			};
		} forEach _groupMembers;
		_nul=[_lead,_areamarker,_pause,_noslow,_nomove,_nofollow,_initpos,_track,_showmarker,_shareinfo,"DELETE:",_deletedead] call zmm_fnc_aiUPS;
		sleep .05;
	};	
	//processInitCommands;
};
sleep .01;


// units that can be left for area to be "cleared"
_zoneempty = ["EMPTY:",0,_UCthis] call KRON_getArg;

// create area trigger
if (_usetrigger!="NOTRIGGER") then {
	_trgside = switch (side _upsUnit) do { case west: {"WEST"}; case east: {"EAST"}; case independent: {"GUER"}; default {"CIV"};};
	_trgname="KRON_Trig_"+_trgside+"_"+_areaname;
	call compile format["%1=objNull",_trgname];
	_flgname="KRON_Cleared_"+_areaname;
	// has the trigger been created already?
	KRON_TRGFlag=objNull;
	call compile format["%1=false",_flgname];
	call compile format["KRON_TRGFlag=%1",_trgname];
	if (isNull KRON_TRGFlag) then {
		// trigger doesn't exist yet, so create one (make it a bit bigger than the marker, to catch path finding 'excursions' and flanking moves)
		call compile format["%1=createTrigger['EmptyDetector',[_centerX,_centerY]];",_trgname];
		call compile format["_areatrigger = %1",_trgname];
		call compile format["%1 setTriggerArea[_rangeX*1.5,_rangeY*1.5,markerDir _areaname,true]",_trgname];
		call compile format["%1 setTriggerActivation[_trgside,'PRESENT',true]",_trgname];
		call compile format["%1 setEffectCondition 'true'",_trgname];
		call compile format["%1 setTriggerTimeout [5,7,10,true]",_trgname];
		if (_usetrigger!="SILENTTRIGGER") then {
			_markerhide = 0;
			_markershow = .8;
			if (_showmarker=="HIDEMARKER") then {
				_markershow = 0;
			};
			call compile format["%1 setTriggerStatements['count thisList<=%6', 'titleText [''SECTOR <%2> CLEARED'',''PLAIN''];''%2'' setMarkerAlpha %4;%3=true;', 'titleText [''SECTOR <%2> HAS BEEN RE-OCCUPIED'',''PLAIN''];''%2'' setMarkerAlpha %5;%3=false;']", _trgname,_areaname,_flgname,_markerhide,_markershow,_zoneempty];
		} else {
			call compile format["%1 setTriggerStatements['count thisList<=%3', '%2=true;', '%2=false;']", _trgname,_flgname,_zoneempty];
		};
	};
	sleep .01;
};

// init done
_makeNewTarget=true;
_newPos=false;
_targetPos = _currPos;
_swimming = false;
_waiting = if (_nomove=="NOMOVE") then {9999} else {0};

// exit if something went wrong during initialization (or if unit is on roof)
if _exit exitWith {
	if ((KRON_UPS_DEBUG>0) && !_onroof) then {hint "Initialization aborted"};
};

// ************************************************ MAIN LOOP ************************************************
_loop = true;
_currCycle = _cycle;
while {_loop} do {
	sleep .01;

	// keep track of how long we've been moving towards a destination
	_timeOnTarget = _timeOnTarget + _currCycle;
	_react = _react + _currCycle;
			
	// did anybody in the group got hit?
	_newDamage=0; 
	{
		if (((damage _x)>0.2) || (isNull _x)) then {
			_newDamage=_newDamage+(damage _x); 
			// damage has increased since last round
			if (_newDamage > _lastDamage) then {
				_lastDamage = _newDamage; 
				_wasHit = true;
			};
			_hitPos=getPos _x; 
			if (!alive _x) then {
				_groupMembers = _groupMembers - [_x]; 
				_friends = _friends - [_x];
			};
		};
	} forEach _groupMembers;
	sleep .01;

	// nobody left alive, exit routine
	if (count _groupMembers==0) then {
		_exit = true;
	} else {
		// did the leader die?
		if (!alive _upsUnit) then {
			_upsUnit = _groupMembers select 0; 
			group _upsUnit selectLeader _upsUnit;
			if (isPlayer _upsUnit) then { _exit = true };
		};
	};
	
	// current position
	_currPos = getPos _upsUnit; _currX = _currPos select 0; _currY = _currPos select 1;
	if (_track=="TRACK") then { _trackername setMarkerPos _currPos; };
	
	// if the AI is a civilian we don't have to bother checking for enemy encounters
	if (_isSoldier && count _enemies > 0 && !_exit) then {
		// if the leader comes across another unit that's either injured or dead, go into combat mode as well. 
		// If the other person is still alive, share enemy information.
		if (_shareinfo=="SHARE") then {
			_others=_friends - _groupMembers - [player];
			{
				if (!(isNull _x) && (_upsUnit distance _x < SHAREDIST) && behaviour _x in ["COMBAT"]) exitWith {
					_wasHit = true; 					
					if (_hitPos select 0 == 0) then {_hitPos = getPos _x};
					if (alive _x) then {
						_foundEnemy = _x findNearestEnemy _x;
						// Enemy is alive and not bleeding out.
						if (alive _foundEnemy && lifeState _foundEnemy != "INCAPACITATED") then {
							if (_upsUnit knowsAbout _x > 3) then { _upsUnit reveal _foundEnemy; };
							if (isNull (KRON_KnownEnemy select _sharedEnemy)) then { KRON_KnownEnemy set [_sharedEnemy,_foundEnemy]; };
						};
					};
				};
			} forEach _others;
		};
		sleep .01;

		// did the group spot an enemy?
		_lastknown = _opfknowval;
		_opfknowval = 0; 
		_maxknowledge = 0;
		{
			_knows = _upsUnit knowsAbout _x; 
			if ((alive _x) && (_knows > 0.2) && (_knows > _maxknowledge)) then {
				//diag_log text format["[UPS] Share: %1 Object: %2 - Knows: %3 - Alive: %4",groupId (group _x),_x,(_knows>0.2),(alive _x)];
				KRON_KnownEnemy set [_sharedEnemy,_x]; 
				_opfknowval = _opfknowval + _knows; 
				_maxknowledge = _knows;
			};
			if (!alive _x) then {_enemies=_enemies-[_x]};
			if (_maxknowledge==4) exitWith {};
		} forEach _enemies;
		sleep .01;
		
		_pursue=false;
		_accuracy=100;
		// opfor spotted an enemy or got shot, so start pursuit
		if (_opfknowval > _lastknown || _wasHit) then {
			_pursue = true;
			// make the exactness of the target dependent on the knowledge about the shooter
			_accuracy=21-(_maxknowledge*5);
		};
		
		// remove target if downed or dead.
		if ((lifeState (KRON_KnownEnemy select _sharedEnemy) in ["DEAD","DEAD-RESPAWN","DEAD-SWITCHING","INCAPACITATED"]) && {!isNull (KRON_KnownEnemy select _sharedEnemy)}) then { 
			KRON_KnownEnemy set [_sharedEnemy,objNull]; 
		};
		
		// don't react to new fatalities if less than 120 seconds have passed since the last one or no enemy to chase
		if (_react < 120 && _fightMode != "walk" || isNull (KRON_KnownEnemy select _sharedEnemy)) then { 
			_pursue = false;
		};

		if (_pursue) then {
			// get position of spotted unit in player group, and watch that spot
			_offsx = _accuracy / 2 - random _accuracy;
			_offsY = _accuracy / 2 - random _accuracy;
			
			_targetPos = getPos (KRON_KnownEnemy select _sharedEnemy);
			_targetPos = [(_targetPos select 0) + _offsX, (_targetPos select 1) + _offsY];
			_targetX = _targetPos select 0;
			_targetY = _targetPos select 1;
			{_x doWatch _targetPos} forEach units _upsUnit;
			sleep .01;			

			// also go into "combat mode"
			_upsUnit setSpeedMode "FULL"; 
			_speedMode = "FULL";
			_upsUnit setBehaviour "COMBAT";
			_pause="NOWAIT";
			_waiting=0;
			
			// angle from unit to target
			_dir1 = [_currPos,_targetPos] call KRON_getDirPos;
			// angle from target to unit (reverse direction)
			_dir2 = (_dir1+180) mod 360;
			// angle from fatality to target
			_dir3 = if (_hitPos select 0 != 0) then {[_hitPos,_targetPos] call KRON_getDirPos} else {_dir1};
			_dd=(_dir1-_dir3);
			
			// unit position offset straight towards target
			_relUX = sin(_dir1)*SAFEDIST;
			_relUY = cos(_dir1)*SAFEDIST;
			// target position offset straight towards unit
			_relTX = sin(_dir2)*SAFEDIST;
			_relTY = cos(_dir2)*SAFEDIST;
			
			// go either left or right (depending on location of fatality - or randomly if no fatality)
			_sinU=_sin90; _cosU=_cos90; _sinT=_sin270; _cosT=_cos270;
			if ((_dd<0) || (_dd==0 && (random 1)>.5)) then {_sinU=_sin270; _cosU=_cos270; _sinT=_sin90; _cosT=_cos90};

			// avoidance position (right or left of unit)
			_avoidX = _currX + _cosU*_relUX - _sinU*_relUY;
			_avoidY = _currY + _sinU*_relUX + _cosU*_relUY;
			_avoidPos = [_avoidX,_avoidY];
			// flanking position (right or left of target)
			_flankX = _targetX + _cosT*_relTX - _sinT*_relTY;
			_flankY = _targetY + _sinT*_relTX + _cosT*_relTY;
			_flankPos = [_flankX,_flankY];
			// final target position
			_attackPos = _targetPos;
			// for now we're stepping a bit to the side
			_targetPos = _avoidPos;

			if (_nofollow=="NOFOLLOW") then {
				_avoidPos = [_avoidPos,_centerPos,_rangeX,_rangeY,_areaDir] call KRON_stayInside;
				_flankPos = [_flankPos,_centerPos,_rangeX,_rangeY,_areaDir] call KRON_stayInside;
				_attackPos = [_attackPos,_centerPos,_rangeX,_rangeY,_areaDir] call KRON_stayInside;
				_targetPos = [_targetPos,_centerPos,_rangeX,_rangeY,_areaDir] call KRON_stayInside;
			};
			
			_react = 0;
			_fightMode = "fight";
			_timeOnTarget = 0; 
			_fm = 1;
			if (KRON_UPS_Debug != 0) then {
				{
					_x params ["_type","_pos","_color"];
					if (isNil format ["Marker_%1_%2",_grpName,_type]) then {
						private _tempMarker = createMarkerLocal [format ["Marker_%1_%2",_grpName,_type],_pos];
						_tempMarker setMarkerTypeLocal "mil_objective";
						_tempMarker setMarkerColorLocal _color;
						_tempMarker setMarkerTextLocal format["%1:%2",_type,_grpidx];
						_tempMarker setMarkerSizeLocal [.5,.5];
					};
					format ["Marker_%1_%2",_grpName,_type] setMarkerPosLocal _pos;
					format ["Marker_%1_%2",_grpName,_type] setMarkerAlphaLocal 1;
				} forEach [["Dead",_hitPos,"ColorGrey"],["Avoid",_avoidPos,"ColorRed"],["Flank",_flankPos,"ColorOrange"],["Target",_attackPos,"ColorBlack"]];
			};
			_newPos = true;
			// speed up the cycle duration after an incident
			if (_currCycle >= _cycle) then { _currCycle = 1 };
		};
	}; 
	sleep .01;

	if !_newPos then {
		// calculate new distance
		// if we're waiting at a waypoint, no calculating necessary
		if (_waiting <= 0) then {
			// distance to target
			_dist = [_currPos,_targetPos] call KRON_distancePosSqr;
			if (_lastDist == 0) then { _lastDist = _dist };
			_moved = abs(_dist-_lastDist);
			// adjust the target tolerance for fast moving vehicles
			if (_moved > _maxMove) then { _maxMove = _moved; if (_maxMove / 40 > _closeEnough) then { _closeEnough = _maxMove / 40 }};
			// how much did we move in the last three cycles?
			_ttm = _moved + _lastMove1 + _lastMove2;
			_damm = damage _upsUnit;
			// is our damage changing (increasing)?
			_dammChg = abs(_damm - _lastDamm);
			
			// we're either close enough, seem to be stuck, or are getting damaged, so find a new target 
			if (!_swimming && (_dist <= _closeEnough || _ttm < .2 || _dammChg > 0.01 || _timeOnTarget > ALERTTIME)) then {
				_makeNewTarget = true;
			};

			// in 'attack (approach) mode', so follow the flanking path (don't make it too predictable though)
			if (_fightMode != "walk" && _dist <= _closeEnough) then {
				if ((random 1)<.95) then {
					if (_flankPos select 0!=0) then {
						_targetPos=_flankPos; _flankPos=[0,0]; _makeNewTarget=false; _newPos=true;
						_fm=1;
					} else {
						if (_attackPos select 0!=0) then {
							_targetPos=_attackPos; _attackPos=[0,0]; _makeNewTarget=false; _newPos=true;
							_fm=2;
						};
					};
				};
			};
			sleep .01;

			// make new target
			if _makeNewTarget then {
				if (_nomove == "NOMOVE" && _timeOnTarget > ALERTTIME) then {
					if (([_currPos,_orgPos] call KRON_distancePosSqr) < _closeEnough) then {
						_newPos = false;
					} else {
						_targetPos = _orgPos;
					};
				} else {
					// re-read marker position/size
					[] call _fn_getAreaInfo;
					// find a new target that's not too close to the current position
					_targetPos=_currPos;
					_tries=0;
					while {([_currPos,_targetPos] call KRON_distancePosSqr) < _minDist && _tries < 20} do {
						_tries = _tries + 1;
						// generate new target position (on the road)
						_tries = 0;
						while {_tries < 20} do {
							_targetPos=[_centerX,_centerY,_rangeX,_rangeY,_cosDir,_sinDir,_areaDir] call KRON_randomPos; 
							if _isCar then {
								_roadList = (_targetPos nearRoads 100) select { count (roadsConnectedTo _x) > 0};
								if (count _roadList > 0) then {
									_targetPos = getPos (_roadList select 0);
									_tries=99;
								};
							} else {
								_tries=99;
							};
							sleep .01;			
						};
					};
				};
				_avoidPos = [0,0]; _flankPos = [0,0]; _attackPos = [0,0];
				_wasHit = false;
				_hitPos = [0,0,0];
				_fm = 0;
				_upsUnit setSpeedMode _orgSpeed;
				_upsUnit setBehaviour _orgBehaviour;
				_newPos = true;
				
				if (KRON_UPS_Debug != 0) then {
					{
						format ["Marker_%1_%2",_grpName,_x] setMarkerAlphaLocal 0;
					} forEach ["Dead","Avoid","Flank","Target"];
				};
	
				// if we're waiting at patrol end points then don't create a new target right away. Keep cycling though to check for enemy encounters
				if (_pause != "NOWAIT" && _waiting < 0) then {_waiting = (15 + random 20)};
			};
		};
	};
	sleep .01;

	// if in water, get right back out of it again
	if (surfaceIsWater _currPos) then {
		if (_isMan && !_swimming) then {
			_drydist=999;
			// look around, to find a dry spot
			for [{_a=0}, {_a<=270}, {_a=_a+90}] do {
				_dp=[_currPos,30,_a] call KRON_relPos; 
				if !(surfaceIsWater _dp) then {_targetPos=_dp};
			};
			_newPos = true; 
			_swimming = true;
		};
	} else {
		_swimming = false;
	};
		
	_waiting = _waiting - _currCycle;
	if (_waiting <= 0 && _newPos) then {
		// tell unit about new target position
		if (_fightMode != "walk") then {
			// reset patrol speed after following enemy for a while
			if (_timeOnTarget > ALERTTIME) then {
				_fightMode = "walk";
				_speedMode = _orgSpeed;
				_upsUnit setSpeedMode _speedMode;
				_upsUnit setBehaviour _orgBehaviour;
				_timeOnTarget = 0;
			};
			
			// use individual doMoves if pursuing enemy, as otherwise the group breaks up too much
			{_x doMove _targetPos} forEach _groupMembers;
		} else {
			_upsUnit move _targetPos;
			_upsUnit setSpeedMode _speedMode;
		};
		
		if (_track=="TRACK") then { 
			switch (_fm) do {
				case 1: 
					{_destName setmarkerSize [.4,.4]};
				case 2: 
					{_destName setmarkerSize [.6,.6]};
				default
					{_destName setmarkerSize [.5,.5]};
			};
			_destName setMarkerPos _targetPos;
		};
		_dist = 0; 
		_moved = 0; 
		_lastMove1 = 10; 
		_waiting = -1; 
		_newPos = false;
		_swimming = false;
	};
	
	// move on
	_lastDist = _dist;
	_lastMove2 = _lastMove1;
	_lastMove1 = _moved;
	_lastDamm = _damm;

	// check external loop switch
	_cont = (call compile format ["KRON_UPS_%1",_upsUnitname]);
	if (_cont == 0) then {_exit=true};
	
	_makeNewTarget = false;
	if (_exit || isNil "_upsUnit") then {
		_loop = false;
	} else {
		// slowly increase the cycle duration after an incident
		if (_currCycle < _cycle) then { _currCycle = _currCycle + 0.5};
		sleep _currCycle;
	};
};

if (_track == "TRACK") then {
	_trackername setMarkerType _markerDot;
	_destName setMarkerType "Empty";
};
_friends = nil;
_enemies = nil;