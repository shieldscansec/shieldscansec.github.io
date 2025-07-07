#if defined _samp_included
    #endinput
#endif
#define _samp_included

#pragma rational Float

// Definições básicas
#define MAX_PLAYERS 1000
#define MAX_VEHICLES 2000
#define MAX_PLAYER_NAME 24
#define MAX_PLAYERS_PER_VEHICLE 4

// Cores
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_RED 0xFF0000FF
#define COLOR_GREEN 0x00FF00FF
#define COLOR_BLUE 0x0000FFFF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_ORANGE 0xFF8000FF
#define COLOR_GREY 0x808080FF
#define COLOR_PURPLE 0x800080FF
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_LIGHTGREEN 0x9ACD32AA

// Dialog styles
#define DIALOG_STYLE_MSGBOX 0
#define DIALOG_STYLE_INPUT 1
#define DIALOG_STYLE_LIST 2
#define DIALOG_STYLE_PASSWORD 3

// Textdraw
#define Text: Text:
#define INVALID_TEXT_DRAW Text:0xFFFF
#define INVALID_PLAYER_ID 0xFFFF
#define INVALID_VEHICLE_ID 0xFFFF

// Natives básicas do servidor
native SetGameModeText(const string[]);
native SendRconCommand(const command[]);
native print(const string[]);
native printf(const format[], {Float,_}:...);
native format(output[], len = sizeof output, const format[], {Float,_}:...);

// Player basics
native GetPlayerName(playerid, const name[], len);
native GetPlayerPos(playerid, &Float:x, &Float:y, &Float:z);
native SetPlayerPos(playerid, Float:x, Float:y, Float:z);
native GetPlayerHealth(playerid, &Float:health);
native SetPlayerHealth(playerid, Float:health);
native GetPlayerArmour(playerid, &Float:armour);
native SetPlayerArmour(playerid, Float:armour);
native GetPlayerMoney(playerid);
native GivePlayerMoney(playerid, money);
native ResetPlayerMoney(playerid);
native SetPlayerScore(playerid, score);
native GetPlayerScore(playerid);
native SendClientMessage(playerid, color, const message[]);
native SendClientMessageToAll(color, const message[]);
native IsPlayerConnected(playerid);
native Kick(playerid);
native GetPlayerFacingAngle(playerid, &Float:angle);
native SetPlayerFacingAngle(playerid, Float:angle);
native SetPlayerInterior(playerid, interiorid);
native GetPlayerInterior(playerid);
native SetPlayerVirtualWorld(playerid, worldid);
native GetPlayerVirtualWorld(playerid);
native GetPlayerIp(playerid, name[], len);
native SetPlayerSkin(playerid, skinid);
native GetPlayerSkin(playerid);
native TogglePlayerControllable(playerid, toggle);
native SetCameraBehindPlayer(playerid);
native GetPlayerWeaponData(playerid, slot, &weapon, &ammo);
native ResetPlayerWeapons(playerid);
native GetWeaponName(weaponid, weapon[], len);
native SetPlayerDrunkLevel(playerid, level);
native GameTextForPlayer(playerid, const string[], time, style);
native IsPlayerInAnyVehicle(playerid);
native ShowPlayerDialog(playerid, dialogid, style, const caption[], const info[], const button1[], const button2[]);
native SpawnPlayer(playerid);

// Vehicles
native CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay);
native SetVehicleVirtualWorld(vehicleid, worldid);
native LinkVehicleToInterior(vehicleid, interiorid);

// World
native DisableInteriorEnterExits();
native SetNameTagDrawDistance(Float:distance);
native ShowNameTags(show);
native ShowPlayerMarkers(mode);
native LimitGlobalChatRadius(Float:chat_radius);
native GetDistanceBetweenPoints3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2);

// TextDraw natives
native TextDrawCreate(Float:x, Float:y, text[]);
native TextDrawDestroy(Text:text);
native TextDrawShowForPlayer(playerid, Text:text);
native TextDrawSetString(Text:text, const string[]);
native TextDrawAlignment(Text:text, alignment);
native TextDrawLetterSize(Text:text, Float:x, Float:y);
native TextDrawColor(Text:text, color);
native TextDrawSetOutline(Text:text, size);
native TextDrawFont(Text:text, font);
native TextDrawUseBox(Text:text, use);
native TextDrawBoxColor(Text:text, color);
native TextDrawSetShadow(Text:text, size);
native TextDrawBackgroundColor(Text:text, color);
native TextDrawSetProportional(Text:text, set);
native TextDrawTextSize(Text:text, Float:x, Float:y);

// PVars
native SetPVarInt(playerid, const varname[], int_value);
native GetPVarInt(playerid, const varname[]);
native DeletePVar(playerid, const varname[]);

// Timers
native SetTimer(const funcname[], interval, repeating);
native SetTimerEx(const funcname[], interval, repeating, const format[], {Float,_}:...);
native KillTimer(timerid);
native gettime();
native GetTickCount();

// Callbacks
forward OnGameModeInit();
forward OnGameModeExit();
forward OnPlayerConnect(playerid);
forward OnPlayerDisconnect(playerid, reason);
forward OnPlayerSpawn(playerid);
forward OnPlayerDialogResponse(playerid, dialogid, response, listitem, inputtext[]);

// Float functions
native Float:float(value);
native Float:floatstr(const string[]);
native Float:floatadd(Float:oper1, Float:oper2);
native Float:floatsub(Float:oper1, Float:oper2);
native Float:floatmul(Float:oper1, Float:oper2);
native Float:floatdiv(Float:dividend, Float:divisor);
native floatround(Float:value, method=0);
native floatcmp(Float:oper1, Float:oper2);
native Float:floatsqroot(Float:value);

// String functions
native strlen(const string[]);
native strcmp(const string1[], const string2[], bool:ignorecase=false, length=0x7FFFFFFF);
native strfind(const string[], const sub[], bool:ignorecase=false, pos=0);
native strmid(dest[], const source[], start, end, maxlength=sizeof dest);
native strcat(dest[], const source[], maxlength=sizeof dest);
native strval(const string[]);
native valstr(dest[], value, bool:pack=false);

// Constants
#define true 1
#define false 0
#define EOS '\0'
#define cellmax 0x7FFFFFFF
#define cellmin 0x80000000