/*
 * ZCMD 0.3.1
 * Zeex's Command Processor
 * -
 * A very fast command processor for PAWN
 * -
 * Modified by Y_Less for better functionality
 */

#if defined _zcmd_included
    #endinput
#endif
#define _zcmd_included

#define MAX_FUNC_NAME (32)

#define COMMAND:%1(%2)          \
            forward cmd_%1(%2); \
            public cmd_%1(%2)

#define CMD:%1(%2) \
            COMMAND:%1(%2)

#define command(%1,%2,%3) \
            COMMAND:%1(%2, %3)

#if !defined isnull
    #define isnull(%1) \
                ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

static
    bool:zcmd_g_HasOPCS = false,
    bool:zcmd_g_DoesPC[MAX_PLAYERS] = { false, ... };

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
    zcmd_g_HasOPCS = funcidx("OnPlayerCommandPerformed") != -1;
    return CallLocalFunction("zcmd_OnFilterScriptInit", "");
}

#if defined _ALS_OnFilterScriptInit
    #undef OnFilterScriptInit
#else
    #define _ALS_OnFilterScriptInit
#endif

#define OnFilterScriptInit zcmd_OnFilterScriptInit

forward zcmd_OnFilterScriptInit();

#else

public OnGameModeInit()
{
    zcmd_g_HasOPCS = funcidx("OnPlayerCommandPerformed") != -1;
    if (funcidx("zcmd_OnGameModeInit") != -1)
    {
        return CallLocalFunction("zcmd_OnGameModeInit", "");
    }
    return 1;
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif

#define OnGameModeInit zcmd_OnGameModeInit

forward zcmd_OnGameModeInit();

#endif

public OnPlayerConnect(playerid)
{
    zcmd_g_DoesPC[playerid] = false;
    if (funcidx("zcmd_OnPlayerConnect") != -1)
    {
        return CallLocalFunction("zcmd_OnPlayerConnect", "i", playerid);
    }
    return 1;
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect zcmd_OnPlayerConnect

forward zcmd_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
    zcmd_g_DoesPC[playerid] = false;
    if (funcidx("zcmd_OnPlayerDisconnect") != -1)
    {
        return CallLocalFunction("zcmd_OnPlayerDisconnect", "ii", playerid, reason);
    }
    return 1;
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect zcmd_OnPlayerDisconnect

forward zcmd_OnPlayerDisconnect(playerid, reason);

public OnPlayerCommandText(playerid, cmdtext[])
{
    if (zcmd_g_DoesPC[playerid])
    {
        return CallLocalFunction("OnPlayerCommandPerformed", "iis", playerid, cmdtext, 1);
    }
    new
        pos,
        funcname[MAX_FUNC_NAME];
    while (cmdtext[++pos] > ' ')
    {
        if (pos >= MAX_FUNC_NAME)
        {
            #if defined OnPlayerCommandPerformed
                return OnPlayerCommandPerformed(playerid, cmdtext, 0);
            #else
                return 0;
            #endif
        }
        funcname[pos - 1] = tolower(cmdtext[pos]);
    }
    format(funcname, sizeof (funcname), "cmd_%s", funcname);
    while (cmdtext[pos] == ' ') pos++;
    if (!cmdtext[pos])
    {
        if (zcmd_g_HasOPCS)
        {
            return CallLocalFunction("OnPlayerCommandPerformed", "iis", playerid, cmdtext, funcidx(funcname) != -1);
        }
        return funcidx(funcname) != -1 && CallLocalFunction(funcname, "is", playerid, cmdtext[pos]);
    }
    if (zcmd_g_HasOPCS)
    {
        return CallLocalFunction("OnPlayerCommandPerformed", "iis", playerid, cmdtext, funcidx(funcname) != -1);
    }
    return funcidx(funcname) != -1 && CallLocalFunction(funcname, "is", playerid, cmdtext[pos]);
}

#if defined _ALS_OnPlayerCommandText
    #undef OnPlayerCommandText
#else
    #define _ALS_OnPlayerCommandText
#endif
#define OnPlayerCommandText zcmd_OnPlayerCommandText

forward zcmd_OnPlayerCommandText(playerid, cmdtext[]);

// Fix for using ZCMD with YSI command system
#if defined OnPlayerCommandReceived
    forward OnPlayerCommandReceived(playerid, cmdtext[]);
#endif
#if defined OnPlayerCommandPerformed
    forward OnPlayerCommandPerformed(playerid, cmdtext[], success);
#endif