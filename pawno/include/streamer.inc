#if defined _streamer_included
    #endinput
#endif
#define _streamer_included

// Streamer natives
native CreateDynamicObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_OBJECT_SD, Float:drawdistance = STREAMER_OBJECT_DD, areaid = -1, priority = 0);
native DestroyDynamicObject(objectid);
native IsValidDynamicObject(objectid);
native SetDynamicObjectPos(objectid, Float:x, Float:y, Float:z);
native GetDynamicObjectPos(objectid, &Float:x, &Float:y, &Float:z);
native SetDynamicObjectRot(objectid, Float:rx, Float:ry, Float:rz);
native GetDynamicObjectRot(objectid, &Float:rx, &Float:ry, &Float:rz);
native MoveDynamicObject(objectid, Float:x, Float:y, Float:z, Float:speed, Float:rx = -1000.0, Float:ry = -1000.0, Float:rz = -1000.0);
native StopDynamicObject(objectid);
native IsDynamicObjectMoving(objectid);
native AttachDynamicObjectToObject(objectid, attachtoid, Float:offsetx, Float:offsety, Float:offsetz, Float:rx, Float:ry, Float:rz, syncrotation = 1);
native AttachDynamicObjectToPlayer(objectid, playerid, Float:offsetx, Float:offsety, Float:offsetz, Float:rx, Float:ry, Float:rz);
native AttachDynamicObjectToVehicle(objectid, vehicleid, Float:offsetx, Float:offsety, Float:offsetz, Float:rx, Float:ry, Float:rz);
native EditDynamicObject(playerid, objectid);
native GetDynamicObjectMaterial(objectid, materialindex, &modelid, txdname[], texturename[], &materialcolor, maxtxdname = sizeof(txdname), maxtexturename = sizeof(texturename));
native SetDynamicObjectMaterial(objectid, materialindex, modelid, const txdname[], const texturename[], materialcolor = 0);
native GetDynamicObjectMaterialText(objectid, materialindex, text[], &materialsize, fontface[], &fontsize, &bold, &fontcolor, &backcolor, &textalignment, maxtext = sizeof(text), maxfontface = sizeof(fontface));
native SetDynamicObjectMaterialText(objectid, materialindex, const text[], materialsize = OBJECT_MATERIAL_SIZE_256x128, const fontface[] = "Arial", fontsize = 24, bold = 1, fontcolor = 0xFFFFFFFF, backcolor = 0, textalignment = 0);

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

// Object material sizes
#define OBJECT_MATERIAL_SIZE_32x32      10
#define OBJECT_MATERIAL_SIZE_64x32      20
#define OBJECT_MATERIAL_SIZE_64x64      30
#define OBJECT_MATERIAL_SIZE_128x32     40
#define OBJECT_MATERIAL_SIZE_128x64     50
#define OBJECT_MATERIAL_SIZE_128x128    60
#define OBJECT_MATERIAL_SIZE_256x32     70
#define OBJECT_MATERIAL_SIZE_256x64     80
#define OBJECT_MATERIAL_SIZE_256x128    90
#define OBJECT_MATERIAL_SIZE_256x256    100
#define OBJECT_MATERIAL_SIZE_512x64     110
#define OBJECT_MATERIAL_SIZE_512x128    120
#define OBJECT_MATERIAL_SIZE_512x256    130
#define OBJECT_MATERIAL_SIZE_512x512    140

// Text alignment
#define OBJECT_MATERIAL_TEXT_ALIGN_LEFT     0
#define OBJECT_MATERIAL_TEXT_ALIGN_CENTER   1
#define OBJECT_MATERIAL_TEXT_ALIGN_RIGHT    2

// Streamer callbacks
forward OnDynamicObjectMoved(objectid);
forward OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
forward OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z);
forward OnPlayerPickUpDynamicPickup(playerid, pickupid);