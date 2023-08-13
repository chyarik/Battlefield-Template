private _east_spawn1 = selectRandom EastSpawn1Array;
private _east_spawn2 = selectRandom EastSpawn2Array;
private _west_spawn1 = selectRandom WestSpawn1Array;
private _west_spawn2 = selectRandom WestSpawn2Array;
private _zone_a_spawn = selectRandom ZoneASpawnArray;
private _zone_b_east_spawn = selectRandom ZoneBEastSpawnArray;
private _zone_b_west_spawn = selectRandom ZoneBWestSpawnArray;
private _zone_c_spawn = selectRandom ZoneCSpawnArray;

if (player inArea east_spawn1_area) then {player setPosASL getPosASL _east_spawn1}
else {if (player inArea east_spawn2_area) then {player setPosASL getPosASL _east_spawn2} 
else {if (player inArea west_spawn1_area) then {player setPosASL getPosASL _west_spawn1}
else {if (player inArea west_spawn2_area) then {player setPosASL getPosASL _west_spawn2} 
else {if (player inArea zone_a_area) then {player setPosASL getPosASL _zone_a_spawn} 
else {if (player inArea zone_b_east_area) then {player setPosASL getPosASL _zone_b_east_spawn}
else {if (player inArea zone_b_west_area) then {player setPosASL getPosASL _zone_b_west_spawn}
else {if (player inArea zone_c_area) then {player setPosASL getPosASL _zone_c_spawn}
else {};};};};};};};};

openGPS true;
player enableStamina false;
player linkItem "ItemRadio";

_playersWeapons = weapons player;
_playerRole = "Empty";
_playerBackpackItems = backpackItems player;

if ("ToolKit" in _playerBackpackItems) then {_playerRole = "Engineer";};

switch (_playerRole) do {
	case "Empty":
	{player setUnitTrait ["Medic", true];};	
	case "Engineer":
	{
		player setUnitTrait ["Engineer", true];	
		player setUnitTrait ["Medic", true];	
	};
};

[] spawn {
player allowDamage false;
sleep 5; 
player allowDamage true;
};

