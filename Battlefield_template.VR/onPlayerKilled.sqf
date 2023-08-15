_pWeap = primaryWeapon _oldUnit;
_sWeap = secondaryWeapon _oldUnit;
_oldUnit removeWeaponGlobal _pWeap;
_oldUnit removeWeaponGlobal _sWeap;
_oldUnit unlinkItem "ItemRadio";
_oldUnit unlinkItem "TFAR_fadak";
_oldUnit unlinkItem "TFAR_anprc152";