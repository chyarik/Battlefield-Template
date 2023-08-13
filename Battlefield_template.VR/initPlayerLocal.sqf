player enableStamina false;

player addEventHandler ["Respawn",{ 
	params ["_newObject","_oldObject"];
	deleteVehicle _oldObject; 
}];

player addEventHandler ["WeaponAssembled", {
	params ["_unit", "_staticWeapon"];
	uav_deployed = _staticWeapon;
}];

player addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
        uav_deployed setDamage 1;
}];

player addEventHandler ["InventoryOpened",{
        if (_this select 1 isKindOf "Man") then {closeDialog 602; true}
}];

{
	missionNamespace setVariable [_x, true];
} forEach [
	"BIS_respSpecAllow3PPCamera",		// Allow 3rd person camera
	"BIS_respSpecShowFocus",			// Show info about the selected unit (dissapears behind the respawn UI)
	"BIS_respSpecShowHeader",			// Top bar of the spectator UI including mission time
	"BIS_respSpecLists"					// Show list of available units and locations on the left hand side
];
