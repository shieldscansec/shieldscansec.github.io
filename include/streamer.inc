/*
 * SA-MP Streamer Plugin
 * Basic definitions for objects, pickups, etc.
 */

#if defined _streamer_included
    #endinput
#endif
#define _streamer_included

// Plugin natives
native CreateDynamicObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_OBJECT_SD, Float:drawdistance = STREAMER_OBJECT_DD, areaid = -1, priority = 0);
native DestroyDynamicObject(objectid);
native IsValidDynamicObject(objectid);
native SetDynamicObjectPos(objectid, Float:x, Float:y, Float:z);
native GetDynamicObjectPos(objectid, &Float:x, &Float:y, &Float:z);
native SetDynamicObjectRot(objectid, Float:rx, Float:ry, Float:rz);
native GetDynamicObjectRot(objectid, &Float:rx, &Float:ry, &Float:rz);

native CreateDynamicPickup(modelid, type, Float:x, Float:y, Float:z, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_PICKUP_SD, areaid = -1, priority = 0);
native DestroyDynamicPickup(pickupid);
native IsValidDynamicPickup(pickupid);

native CreateDynamic3DTextLabel(const text[], color, Float:x, Float:y, Float:z, Float:drawdistance, attachedplayer = INVALID_PLAYER_ID, attachedvehicle = INVALID_VEHICLE_ID, testlos = 0, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_3D_TEXT_LABEL_SD, areaid = -1, priority = 0);
native DestroyDynamic3DTextLabel(Text3D:id);
native IsValidDynamic3DTextLabel(Text3D:id);

// Constants
#if !defined MAX_OBJECTS
    #define MAX_OBJECTS 1000
#endif

#define STREAMER_OBJECT_SD          300.0
#define STREAMER_OBJECT_DD          0.0
#define STREAMER_PICKUP_SD          200.0
#define STREAMER_3D_TEXT_LABEL_SD   200.0

// Callbacks
forward OnPlayerPickUpDynamicPickup(playerid, pickupid);

#endif