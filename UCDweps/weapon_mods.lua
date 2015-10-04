-------------------------------------------------------------------
--// PROJECT: Project Downtown
--// RESOURCE: weps
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 13.02.2014
--// PURPOSE: Weapon balancing and modification.
--// FILE: \weps\weapon_mods.lua [server]
-------------------------------------------------------------------

-- AK-47
-- Gave it an extra 20 bullets to compensate for the accuracy being larger than the M4, at a pro level
-- Extra 5 damage to balance it with the M4
-- Gave it an extra 10 bullets to compensate for the accuracy being larger than the M4, at a standard level
-- Made it a little more accurate to balance it with the M4
setWeaponProperty( "ak-47", "pro", "maximum_clip_ammo", 50 )
setWeaponProperty( "ak-47", "std", "maximum_clip_ammo", 40 )
setWeaponProperty( "ak-47", "pro", "damage", 35 )
setWeaponProperty( "ak-47", "std", "damage", 35 )
setWeaponProperty( "ak-47", "poor", "damage", 35 )
setWeaponProperty( "ak-47", "pro", "accuracy", 0.7 )
setWeaponProperty( "ak-47", "std", "accuracy", 0.6 )

-- Sawed off
-- Removed dual sawed off, but made pro level sawed off have 1 more round to compensate
setWeaponProperty( "sawed-off", "pro", "flag_type_dual", false )
setWeaponProperty( "sawed-off", "std", "flag_type_dual", false )
setWeaponProperty( "sawed-off", "poor", "flag_type_dual", false )
setWeaponProperty( "sawed-off", "pro", "maximum_clip_ammo", 3 )

-- MP5
-- Accuracy is better at pro level.
setWeaponProperty( "mp5", "pro", "accuracy", 1.6 )
