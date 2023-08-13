waituntil {!isnil "bis_fnc_init"};
[] execVM "briefing.sqf";

fnc_clienttime = {
disableSerialization;
_missionTime = (51 * 60);
//Create displays in bottom left
("timeRsc" call BIS_fnc_rscLayer) cutRsc ["timeleftStructText", "PLAIN"];
//If displays weren't created then exit the script
if (uiNameSpace getVariable "timeleftStructText" isEqualTo displayNull) exitWith {hint "TIMELEFT display not defined in description.ext"};

fnc_missionTimeUI_PFH =[{
  params ["_missionTime", "_handle"];
  //Update text in the displays to match the points markers
  _display = uiNameSpace getVariable "timeleftStructText";
  _setText = _display displayCtrl 1003;
  _setText ctrlSetStructuredText parseText (format [localize "STR_Other_MissionTime", [_missionTime - CBA_missionTime, "MM:SS"] call BIS_fnc_secondsToString]);
}, 1, _missionTime] call CBA_fnc_addPerFrameHandler;

fnf_mapTimeShown = false;
fnf_mapMissionTime = addMissionEventHandler ["Map", {
	params ["_mapIsOpened", "_mapIsForced"];

  if (_mapIsOpened) then {
    if (missionNamespace getVariable ["fnf_safetyEnabled", true]) then {
      call fnf_fnc_clientSafeStartTime;
    } else {
      call fnf_fnc_clientTime;
    };
    fnf_mapTimeShown = true;
  };
}];
};

call fnc_clienttime;

if (isServer) then {
	_clearBodies = [] spawn {
		while {true} do {

		{
		deleteVehicle _x;
		sleep 0.01;
		} forEach allDeadMen;
	sleep 5;
	};  
};
};

fnc_notify = {
params ["_veh"];
['Veh_Spawn', [_veh]] remoteExec ["BIS_fnc_showNotification", 0, true];
};

fnc_notify_sector1 = {
	params ["_side","_sector"];
['Sector_Captured1', [_side, _sector]] remoteExec ["BIS_fnc_showNotification", 0, true];
};

fnc_notify_sector2 = {
	params ["_side","_sector"];
['Sector_Captured2', [_side, _sector]] remoteExec ["BIS_fnc_showNotification", 0, true];
};
