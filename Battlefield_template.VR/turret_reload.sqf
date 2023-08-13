turretsVarNamesShortReload = [];
turretsVarNamesLongReload = [];
{
  if (["trt_short", str _x, false] call BIS_fnc_inString) then {
    turretsVarNamesShortReload append [_x];
  }; 
  if (["trt_long", str _x, false] call BIS_fnc_inString) then {
    turretsVarNamesLongReload append [_x];
  }; 
} foreach vehicles;

while {true} do {
{ _x setVehicleAmmo 1 } forEach turretsVarNamesShortReload; 
sleep 120;
};
while {true} do {
{ _x setVehicleAmmo 1 } forEach turretsVarNamesLongReload; 
sleep 600;
};