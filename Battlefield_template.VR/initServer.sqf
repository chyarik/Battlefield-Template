fnc_save = {
params
[
    ["_object",player,[objNull]],
    ["_class","REPLACE",[""]],
    ["_displayName","REPLACE",[""]],
    ["_icon","\A3\Ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa",[""]],
    ["_role","Default",[""]],
    ["_conditionShow","true",[""]]
];

private _indent = "    ";
private _class = format ["class %1",_class];
private _displayName = format ["displayName = ""%1"";",_displayName];
private _icon = format ["icon = ""%1"";",_icon];
private _role = format ["role = ""%1"";",_role];
private _conditionShow = format ["show = ""%1"";",_conditionShow];
private _uniformClass = format ["uniformClass = ""%1"";",uniform _object];
private _backpack = format ["backpack = ""%1"";",backpack _object];
private _export = _class + endl + "{" + endl + _indent + _displayName + endl + _indent + _icon + endl + _indent + _role + endl + _indent + _conditionShow + endl + _indent + _uniformClass + endl + _indent + _backpack + endl;
private _weapons = weapons _object;
private _primWeaponItems = primaryWeaponItems _object;
private _secWeaponItems = secondaryWeaponItems _object;
private _assignedItems = assigneditems _object;
// From BIS_fnc_exportLoadout START
private _fnc_addArray =
{
    params ["_name","_array"];
    _export = _export + format [_indent + "%1[] = {",_name];
    {
        if (_foreachindex > 0) then {_export = _export + ",";};
        _export = _export + format ["""%1""",_x];
    } foreach _array;
    _export = _export + "};" + endl;
};

["weapons",_weapons + ["Throw","Put"]] call _fnc_addArray;
["magazines",magazines _object] call _fnc_addArray;
["items",items _object] call _fnc_addArray;
["linkedItems",[vest _object,headgear _object,goggles _object] + _assignedItems - _weapons + _primWeaponItems + _secWeaponItems] call _fnc_addArray;
// From BIS_fnc_exportLoadout END
_export = _export + "};" + endl;

_export;
};

fnc_save1 = {
	//формуємо текст з класами всіх наборів спорядження
_exportText = "";

{

	//параметри які будуть передаватись у функцію для формування набору спорядження
	_unitVariableName = vehicleVarName _x; // blufor_rifleman
	_displayName = ""; // Стрілець
	_equipmentSetupClassname = ""; // OPFOR_Saboteur
	_unitRole = ""; // Assault
	_conditionWithSide = ""; // east or west
	
	switch (_unitVariableName) do
	{
		case "blufor_rifleman": 	{ _displayName = "Rifleman"; 		 _equipmentSetupClassname = "BLUFOR_Rifleman"; 	_unitRole = "Assault";};
		case "blufor_riflemanAT": 	{ _displayName = "Rifleman (AT)";	 _equipmentSetupClassname = "BLUFOR_Rifleman_AT"; _unitRole = "Assault";};
		case "blufor_gl": 		{ _displayName = "GL"; 	 _equipmentSetupClassname = "BLUFOR_GL"; _unitRole = "Assault";};
		case "blufor_at": 		{ _displayName = "AT"; 	 _equipmentSetupClassname = "BLUFOR_AT"; _unitRole = "Assault";};
		case "blufor_aa": 		{ _displayName = "AA"; 	 _equipmentSetupClassname = "BLUFOR_AA"; _unitRole = "Assault";};
		case "blufor_sapper": 		{ _displayName = "Sapper"; 		 _equipmentSetupClassname = "BLUFOR_Sapper"; _unitRole = "Engineer";};
		case "blufor_engineer": 	{ _displayName = "Engineeer"; 		 _equipmentSetupClassname = "BLUFOR_Engineer"; _unitRole = "Engineer";};
		case "blufor_mg1": 		{ _displayName = "MG 1"; 	 _equipmentSetupClassname = "BLUFOR_MG_1"; _unitRole = "Support";};
		case "blufor_mg2": 		{ _displayName = "MG 2"; 	 _equipmentSetupClassname = "BLUFOR_MG_2"; _unitRole = "Support";};
		case "blufor_sniper":		{ _displayName = "Sniper"; 		 _equipmentSetupClassname = "BLUFOR_Sniper"; _unitRole = "Recon";};
		case "blufor_saboteur":		{ _displayName = "Saboteur"; 		 _equipmentSetupClassname = "BLUFOR_Saboteur"; _unitRole = "Recon";};
		
		case "opfor_rifleman": 		{ _displayName = "Rifleman"; 		 _equipmentSetupClassname = "OPFOR_Rifleman"; _unitRole = "Assault";};
		case "opfor_riflemanAT": 	{ _displayName = "Rifleman (AT)"; 	 _equipmentSetupClassname = "OPFOR_Rifleman_AT"; _unitRole = "Assault";};
		case "opfor_gl": 		{ _displayName = "GL"; 	 _equipmentSetupClassname = "OPFOR_GL"; _unitRole = "Assault";};
		case "opfor_at": 		{ _displayName = "AT"; 	 _equipmentSetupClassname = "OPFOR_AT"; _unitRole = "Assault";};
		case "opfor_aa": 		{ _displayName = "AA"; 	 _equipmentSetupClassname = "OPFOR_AA"; _unitRole = "Assault";};
		case "opfor_sapper": 		{ _displayName = "Sapper"; 		 _equipmentSetupClassname = "OPFOR_Sapper"; _unitRole = "Engineer";};
		case "opfor_engineer": 		{ _displayName = "Engineer"; 		 _equipmentSetupClassname = "OPFOR_Engineer"; _unitRole = "Engineer";};
		case "opfor_mg1": 		{ _displayName = "MG 1"; 	 _equipmentSetupClassname = "OPFOR_MG_1"; _unitRole = "Support";};
		case "opfor_mg2": 		{ _displayName = "MG 2"; 	 _equipmentSetupClassname = "OPFOR_MG_2"; _unitRole = "Support";};
		case "opfor_sniper": 		{ _displayName = "Sniper"; 		 _equipmentSetupClassname = "OPFOR_Sniper"; _unitRole = "Recon";};
		case "opfor_saboteur":		{ _displayName = "Saboteur"; 		 _equipmentSetupClassname = "OPFOR_Saboteur"; _unitRole = "Recon";};
		
		default {};
	};
	
	unitHaveProperId = False;
	
	// вирішуємо для якої сторони показуватиме пресет спорядження
	if (["blufor_", _unitVariableName, false] call BIS_fnc_inString) then {
		_conditionWithSide = "side group _this == west";
		unitHaveProperId = True;
	}; 
	
	if (["opfor_", _unitVariableName, false] call BIS_fnc_inString) then {
		_conditionWithSide = "side group _this == east";
		unitHaveProperId = True;
	}; 
	
	if (unitHaveProperId == True) then {
		_exportTextTemp = [_x, _equipmentSetupClassname, _displayName, "\A3\Ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa", _unitRole, _conditionWithSide] call fnc_save; 
		_exportText = _exportText + _exportTextTemp;
	};
	
} forEach allUnits;

if (count (toArray _exportText) > 0) then {
	copyToClipboard _exportText;
};
};

EastSpawn1Array = [];
{
  if (["east_spawn1_", str _x, false] call BIS_fnc_inString) then {
    EastSpawn1Array append [_x];
  }; 
} forEach (8 allObjects 0);
EastSpawn2Array = [];
{
  if (["east_spawn2_", str _x, false] call BIS_fnc_inString) then {
    EastSpawn2Array append [_x];
  }; 
} forEach (8 allObjects 0);
WestSpawn1Array = [];
{
  if (["west_spawn1_", str _x, false] call BIS_fnc_inString) then {
    WestSpawn1Array append [_x];
  }; 
} forEach (8 allObjects 0);
WestSpawn2Array = [];
{
  if (["west_spawn2_", str _x, false] call BIS_fnc_inString) then {
    WestSpawn2Array append [_x];
  }; 
} forEach (8 allObjects 0);
ZoneASpawnArray = [];
{
  if (["zone_a_spawn", str _x, false] call BIS_fnc_inString) then {
    ZoneASpawnArray append [_x];
  }; 
} forEach (8 allObjects 0);
ZoneBEastSpawnArray = [];
{
  if (["zone_b_east_spawn", str _x, false] call BIS_fnc_inString) then {
    ZoneBEastSpawnArray append [_x];
  }; 
} forEach (8 allObjects 0);
ZoneBWestSpawnArray = [];
{
  if (["zone_b_west_spawn", str _x, false] call BIS_fnc_inString) then {
    ZoneBWestSpawnArray append [_x];
  }; 
} forEach (8 allObjects 0);
ZoneCSpawnArray = [];
{
  if (["zone_c_spawn", str _x, false] call BIS_fnc_inString) then {
    ZoneCSpawnArray append [_x];
  }; 
} forEach (8 allObjects 0);

sleep 7;
execVM "turret_reload.sqf";

EastSpawn1 = [east, east_spawn1script, "$STR_Spawn_Base"] call BIS_fnc_addRespawnPosition;
sleep 1;
EastSpawn2 = [east, east_spawn2script, "$STR_Spawn_BaseReserve"] call BIS_fnc_addRespawnPosition;
sleep 1;
WestSpawn1 = [west, west_spawn1script, "$STR_Spawn_Base"] call BIS_fnc_addRespawnPosition;
sleep 1;
WestSpawn2 = [west, west_spawn2script, "$STR_Spawn_BaseReserve"] call BIS_fnc_addRespawnPosition;

[west, ["BLUFOR_Rifleman",3]] call BIS_fnc_addRespawnInventory; 
[west, ["BLUFOR_Rifleman_AT",1]] call BIS_fnc_addRespawnInventory; 
[west, ["BLUFOR_GL",1]] call BIS_fnc_addRespawnInventory; 
[west, ["BLUFOR_AT",1]] call BIS_fnc_addRespawnInventory; 
[west, ["BLUFOR_AA",1]] call BIS_fnc_addRespawnInventory; 
[west, ["BLUFOR_Sapper",2]] call BIS_fnc_addRespawnInventory; 
[west, ["BLUFOR_Engineer",3]] call BIS_fnc_addRespawnInventory; 
[west, ["BLUFOR_MG_1",1]] call BIS_fnc_addRespawnInventory; 
[west, ["BLUFOR_MG_2",1]] call BIS_fnc_addRespawnInventory; 
[west, ["BLUFOR_Sniper",1]] call BIS_fnc_addRespawnInventory; 
[west, ["BLUFOR_Saboteur",1]] call BIS_fnc_addRespawnInventory; 
[east, ["OPFOR_Rifleman",3]] call BIS_fnc_addRespawnInventory; 
[east, ["OPFOR_Rifleman_AT",1]] call BIS_fnc_addRespawnInventory; 
[east, ["OPFOR_GL",1]] call BIS_fnc_addRespawnInventory; 
[east, ["OPFOR_AT",1]] call BIS_fnc_addRespawnInventory; 
[east, ["OPFOR_AA",1]] call BIS_fnc_addRespawnInventory; 
[east, ["OPFOR_Sapper",2]] call BIS_fnc_addRespawnInventory; 
[east, ["OPFOR_Engineer",3]] call BIS_fnc_addRespawnInventory; 
[east, ["OPFOR_MG_1",1]] call BIS_fnc_addRespawnInventory; 
[east, ["OPFOR_MG_2",1]] call BIS_fnc_addRespawnInventory; 
[east, ["OPFOR_Sniper",1]] call BIS_fnc_addRespawnInventory; 
[east, ["OPFOR_Saboteur",1]] call BIS_fnc_addRespawnInventory;

powerW=0; powerE=0; _ticketsW=1800; _ticketsE=1800; VictoryE=false; VictoryW=false;
while {true} do {
	powerW=0; powerE=0;
	{
        if (markerColor _x == "ColorBLUFOR") then {powerW = powerW + 1;};
        if (markerColor _x == "ColorOPFOR") then {powerE = powerE + 1;};
    } forEach ["zone_a","zone_b","zone_c"];

	if(powerW!=powerE)then
	{	if(powerW>powerE)
		then{_ticketsE = _ticketsE - (powerW-powerE);}
		else{_ticketsW = _ticketsW - (powerE-powerW);};
	};
	
	if(_ticketsE == 0)then
	{VictoryW=true};
	if(_ticketsW == 0)then
	{VictoryE=true};

	if ((CBA_missionTime >= 3000) and (_ticketsE>_ticketsW)) then {VictoryE=true};
	if ((CBA_missionTime >= 3000) and (_ticketsW>_ticketsE)) then {VictoryW=true};
	
	ticketsGlobalE = _ticketsE; publicVariable "ticketsGlobalE";
	ticketsGlobalW = _ticketsW; publicVariable "ticketsGlobalW";
		{hintSilent parseText (format [localize "$STR_Other_Tickets", ticketsGlobalW, ticketsGlobalE])} remoteExec ["bis_fnc_call", 0, true];
	sleep 1;
};


