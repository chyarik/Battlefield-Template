if (!isServer) exitWith {};

// Define variables
_unit = _this select 0;
_delay = if (count _this > 1) then {_this select 1} else {30};
_deserted = if (count _this > 2) then {_this select 2} else {120};
_respawns = if (count _this > 3) then {_this select 3} else {0};
_dynamic = if (count _this > 4) then {_this select 4} else {false};
_unitinit = if (count _this > 5) then {_this select 5} else {};
_haveinit = if (count _this > 5) then {true} else {false};

_hasname = false;
_unitname = vehicleVarName _unit;
if (isNil _unitname) then {_hasname = false;} else {_hasname = true;};
_noend = true;
_run = true;
_rounds = 0;

if (_delay < 0) then {_delay = 0};
if (_deserted < 0) then {_deserted = 0};
if (_respawns <= 0) then {_respawns= 0; _noend = true;};
if (_respawns > 0) then {_noend = false};

_dir = getDir _unit;
_position = getPosASL _unit;
_type = typeOf _unit;
_dead = false;
_nodelay = false;


fnc_setVehicleInit = {
       private ["_netID","_unit","_unitinit"];

       _netID = _this select 0;
       _unit = objectFromNetID _netID;
       _unitinit = _this select 1;

       _unit call compile format ["%1",_unitinit];
};


fnc_setVehicleVarName = {
       private ["_netID","_unit","_unitname"];

       _netID = _this select 0;
       _unit = objectFromNetID _netID;
       _unitname = _this select 1;

       _unit setVehicleVarName _unitname;
       _unit call compile format ["%1=_This; PublicVariable ""%1""",_unitname];
};


// Start monitoring the vehicle   
while {_run} do 
{	
sleep (2 + random 10);
	if (((_unit getHitPointDamage "hitengine" > 0.35) or (_unit getHitPointDamage "hitfuel" > 0.35)
	or (_unit getHitPointDamage "hithull" > 0.35) or (_unit getHitPointDamage "hitturret" > 0.35)
	or (_unit getHitPointDamage "hitgun" > 0.35))
 	and ({alive _x} count crew _unit == 0) and (count (_unit nearEntities [["Man"], 30]) <= 0)) then {_dead = true; _nodelay =false};
 
// Check if the vehicle is deserted.
if ((_unit getHitPointDamage "hitengine" < 0.35) and (_unit getHitPointDamage "hitfuel" < 0.35)
and (_unit getHitPointDamage "hithull" < 0.35) and (_unit getHitPointDamage "hitturret" < 0.35)
and (_unit getHitPointDamage "hitgun" < 0.35) and (getPosASL _unit distance _position > 10) and ({alive _x} count crew _unit == 0)) then 
    {
        _timeout = time + _deserted;
        sleep 0.1;
        waitUntil {(count (_unit nearEntities [["Man"], 70]) <= 0) or !alive _unit or {alive _x} count crew _unit > 0}; 
        if ({alive _x} count crew _unit > 0) then {_dead = false}; 
        if (count (_unit nearEntities [["Man"], 70]) <= 0) then {sleep 2; if({alive _x} count crew _unit == 0) then {_dead = true; _nodelay = true} else {};}; 
        if !(alive _unit) then {_dead = true; _nodelay = false;}; 
    };
// Respawn vehicle
     if (_dead) then 
{	
	sleep 0.1;

	deleteVehicle _unit;
	if (_nodelay) then {sleep 0.1; _nodelay = false;} else {sleep _delay;};
	_unit = _type createVehicle _position;
	_unit setPosASL _position;
	_unit setDir _dir;
	clearItemCargoGlobal _unit; //removing all cargo items
		
	if (_haveinit) then {[[netID _unit, _unitinit], "fnc_setVehicleInit", true, true] spawn BIS_fnc_MP;};

	if (_hasname) then {[[netID _unit, _unitname], "fnc_setVehicleVarName", true, true] spawn BIS_fnc_MP;};

	_dead = false;

	// Check respawn amount
	if !(_noend) then {_rounds = _rounds + 1};
	if ((_rounds == _respawns) and !(_noend)) then {_run = false;};
};
};