/*
 * SA-MP Streamer Plugin
 * Basic Include File
 */

#if defined _inc_streamer
    #undef _inc_streamer
#endif

#if defined _streamer_included
    #endinput
#endif
#define _streamer_included

// Object limits
#define MAX_OBJECTS (1000)
#define MAX_PICKUPS (4096)
#define MAX_ACTORS (1000)
#define MAX_VEHICLES (2000)

// Stream distances
#define STREAMER_OBJECT_SD (300.0)
#define STREAMER_PICKUP_SD (200.0)
#define STREAMER_CP_SD (200.0)
#define STREAMER_RACE_CP_SD (200.0)
#define STREAMER_MAP_ICON_SD (200.0)
#define STREAMER_3D_TEXT_LABEL_SD (200.0)
#define STREAMER_ACTOR_SD (200.0)
#define STREAMER_VEHICLE_SD (300.0)

// Basic streaming functions
native CreateDynamicObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_OBJECT_SD);
native DestroyDynamicObject(objectid);
native IsValidDynamicObject(objectid);
native SetDynamicObjectPos(objectid, Float:x, Float:y, Float:z);
native GetDynamicObjectPos(objectid, &Float:x, &Float:y, &Float:z);
native SetDynamicObjectRot(objectid, Float:rx, Float:ry, Float:rz);
native GetDynamicObjectRot(objectid, &Float:rx, &Float:ry, &Float:rz);
native MoveDynamicObject(objectid, Float:x, Float:y, Float:z, Float:speed, Float:rx = -1000.0, Float:ry = -1000.0, Float:rz = -1000.0);
native StopDynamicObject(objectid);
native IsDynamicObjectMoving(objectid);

native CreateDynamicPickup(modelid, type, Float:x, Float:y, Float:z, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_PICKUP_SD);
native DestroyDynamicPickup(pickupid);
native IsValidDynamicPickup(pickupid);

native CreateDynamicCP(Float:x, Float:y, Float:z, Float:size, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_CP_SD);
native DestroyDynamicCP(checkpointid);
native IsValidDynamicCP(checkpointid);
native TogglePlayerDynamicCP(playerid, checkpointid, toggle);
native TogglePlayerAllDynamicCPs(playerid, toggle);
native IsPlayerInDynamicCP(playerid, checkpointid);
native GetPlayerVisibleDynamicCP(playerid);

native CreateDynamicRaceCP(type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_RACE_CP_SD);
native DestroyDynamicRaceCP(checkpointid);
native IsValidDynamicRaceCP(checkpointid);
native TogglePlayerDynamicRaceCP(playerid, checkpointid, toggle);
native TogglePlayerAllDynamicRaceCPs(playerid, toggle);
native IsPlayerInDynamicRaceCP(playerid, checkpointid);
native GetPlayerVisibleDynamicRaceCP(playerid);

native CreateDynamicMapIcon(Float:x, Float:y, Float:z, type, color, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_MAP_ICON_SD, style = MAPICON_LOCAL);
native DestroyDynamicMapIcon(iconid);
native IsValidDynamicMapIcon(iconid);

native CreateDynamic3DTextLabel(const text[], color, Float:x, Float:y, Float:z, Float:drawdistance, attachedplayer = INVALID_PLAYER_ID, attachedvehicle = INVALID_VEHICLE_ID, testLOS = 0, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_3D_TEXT_LABEL_SD);
native DestroyDynamic3DTextLabel(id);
native IsValidDynamic3DTextLabel(id);
native GetDynamic3DTextLabelText(id, text[], maxlength = sizeof(text));
native UpdateDynamic3DTextLabelText(id, color, const text[]);

native CreateDynamicActor(modelid, Float:x, Float:y, Float:z, Float:r, invulnerable = true, Float:health = 100.0, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_ACTOR_SD);
native DestroyDynamicActor(actorid);
native IsValidDynamicActor(actorid);

// Callbacks
forward OnDynamicObjectMoved(objectid);
forward OnPlayerPickUpDynamicPickup(playerid, pickupid);
forward OnPlayerEnterDynamicCP(playerid, checkpointid);
forward OnPlayerLeaveDynamicCP(playerid, checkpointid);
forward OnPlayerEnterDynamicRaceCP(playerid, checkpointid);
forward OnPlayerLeaveDynamicRaceCP(playerid, checkpointid);

// Compatibility
#define CreateObject CreateDynamicObject
#define DestroyObject DestroyDynamicObject