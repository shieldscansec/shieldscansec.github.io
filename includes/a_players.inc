#if defined _a_players_included
    #endinput
#endif
#define _a_players_included

/* Player functions */
native IsPlayerConnected(playerid);
native IsPlayerInAnyVehicle(playerid);
native IsPlayerInVehicle(playerid, vehicleid);
native IsPlayerInRangeOfPoint(playerid, Float:range, Float:x, Float:y, Float:z);
native GetPlayerDistanceFromPoint(playerid, Float:x, Float:y, Float:z);
native IsPlayerStreamedIn(playerid, forplayerid);
native GetPlayerVehicleID(playerid);
native GetPlayerVehicleSeat(playerid);

/* Player position functions */
native SetPlayerPos(playerid, Float:x, Float:y, Float:z);
native GetPlayerPos(playerid, &Float:x, &Float:y, &Float:z);
native SetPlayerPosFindZ(playerid, Float:x, Float:y, Float:z);
native GetPlayerLastShotVectors(playerid, &Float:fOriginX, &Float:fOriginY, &Float:fOriginZ, &Float:fHitPosX, &Float:fHitPosY, &Float:fHitPosZ);

/* Player rotation functions */
native SetPlayerFacingAngle(playerid, Float:angle);
native GetPlayerFacingAngle(playerid, &Float:angle);

/* Player interior and virtual world */
native SetPlayerInterior(playerid, interiorid);
native GetPlayerInterior(playerid);
native SetPlayerVirtualWorld(playerid, worldid);
native GetPlayerVirtualWorld(playerid);

/* Player health and armor */
native SetPlayerHealth(playerid, Float:health);
native GetPlayerHealth(playerid, &Float:health);
native SetPlayerArmour(playerid, Float:armour);
native GetPlayerArmour(playerid, &Float:armour);

/* Player weapons */
native GivePlayerWeapon(playerid, weaponid, ammo);
native ResetPlayerWeapons(playerid);
native SetPlayerAmmo(playerid, weaponslot, ammo);
native GetPlayerAmmo(playerid);
native GetPlayerWeaponState(playerid);
native GetPlayerTargetPlayer(playerid);
native GetPlayerWeapon(playerid);
native GetPlayerWeaponData(playerid, slot, &weapons, &ammo);

/* Player money */
native GivePlayerMoney(playerid, money);
native ResetPlayerMoney(playerid);
native SetPlayerScore(playerid, score);
native GetPlayerScore(playerid);
native GetPlayerMoney(playerid);

/* Player state */
native GetPlayerState(playerid);
native GetPlayerPing(playerid);
native GetPlayerWeapon(playerid);

/* Player control */
native TogglePlayerControllable(playerid, toggle);
native PlayerPlaySound(playerid, soundid, Float:x, Float:y, Float:z);
native ApplyAnimation(playerid, const animlib[], const animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync);
native ClearAnimations(playerid, forcesync);
native GetPlayerAnimationIndex(playerid);
native GetAnimationName(index, animlib[], len1, animname[], len2);

/* Player special actions */
native SetPlayerSpecialAction(playerid, actionid);
native GetPlayerSpecialAction(playerid);

/* Player drunk level */
native SetPlayerDrunkLevel(playerid, level);
native GetPlayerDrunkLevel(playerid);

/* Player color */
native SetPlayerColor(playerid, color);
native GetPlayerColor(playerid);

/* Player skin */
native SetPlayerSkin(playerid, skinid);
native GetPlayerSkin(playerid);

/* Player team */
native SetPlayerTeam(playerid, teamid);
native GetPlayerTeam(playerid);

/* Player wanted level */
native SetPlayerWantedLevel(playerid, level);
native GetPlayerWantedLevel(playerid);

/* Player fighting style */
native SetPlayerFightingStyle(playerid, style);
native GetPlayerFightingStyle(playerid);

/* Player velocity */
native SetPlayerVelocity(playerid, Float:X, Float:Y, Float:Z);
native GetPlayerVelocity(playerid, &Float:X, &Float:Y, &Float:Z);

/* Player camera */
native PlayCrimeReportForPlayer(playerid, suspectid, crime);
native PlayAudioStreamForPlayer(playerid, const url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0);
native StopAudioStreamForPlayer(playerid);