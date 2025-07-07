/*
 * ZCMD - Z Command Processor
 * Simple and efficient command processing for SA-MP
 */

#if defined _zcmd_included
    #endinput
#endif
#define _zcmd_included

#define MAX_FUNC_NAME (32)

#define COMMAND:%1(%2) \
    forward cmd_%1(%2); \
    public cmd_%1(%2)

#define CMD:%1(%2) \
    COMMAND:%1(%2)

#define command(%1,%2,%3) \
    COMMAND:%1(%2,%3)

#define YCMD:%1(%2) \
    COMMAND:%1(%2)

static
    zcmd_g_sCommands[MAX_PLAYERS][128],
    bool:zcmd_g_bPlayerCmdText[MAX_PLAYERS]
;

#if defined _ALS_OnPlayerCommandText
    #undef OnPlayerCommandText
#else
    #define _ALS_OnPlayerCommandText
#endif
#define OnPlayerCommandText zcmd_OnPlayerCommandText

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect zcmd_OnPlayerDisconnect

forward zcmd_OnPlayerCommandText(playerid, cmdtext[]);
forward zcmd_OnPlayerDisconnect(playerid, reason);

public zcmd_OnPlayerCommandText(playerid, cmdtext[])
{
    if (zcmd_g_bPlayerCmdText[playerid])
    {
        return 1;
    }
    
    static
        pos,
        funcname[MAX_FUNC_NAME];
    
    while (cmdtext[++pos] > ' ') {}
    
    strmid(funcname, cmdtext[1], 0, pos - 1);
    format(funcname, sizeof(funcname), "cmd_%s", funcname);
    
    while (cmdtext[pos] == ' ') pos++;
    
    if (!cmdtext[pos])
    {
        format(zcmd_g_sCommands[playerid], 128, "%s(%d,\"\")", funcname, playerid);
    }
    else
    {
        format(zcmd_g_sCommands[playerid], 128, "%s(%d,\"%s\")", funcname, playerid, cmdtext[pos]);
    }
    
    pos = 0;
    zcmd_g_bPlayerCmdText[playerid] = true;
    
    new result = CallLocalFunction(funcname, "is", playerid, cmdtext[pos] ? cmdtext[pos] : "\1");
    
    zcmd_g_bPlayerCmdText[playerid] = false;
    
    if (result != -1)
    {
        return 1;
    }
    
    #if defined zcmd_OnPlayerCommandText
        return zcmd_OnPlayerCommandText(playerid, cmdtext);
    #else
        return 0;
    #endif
}

public zcmd_OnPlayerDisconnect(playerid, reason)
{
    zcmd_g_sCommands[playerid][0] = '\0';
    zcmd_g_bPlayerCmdText[playerid] = false;
    
    #if defined zcmd_OnPlayerDisconnect
        return zcmd_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerCommandText
    #undef _ALS_OnPlayerCommandText
#endif
#if defined zcmd_OnPlayerCommandText
    forward zcmd_OnPlayerCommandText(playerid, cmdtext[]);
#endif

#if defined _ALS_OnPlayerDisconnect
    #undef _ALS_OnPlayerDisconnect
#endif
#if defined zcmd_OnPlayerDisconnect
    forward zcmd_OnPlayerDisconnect(playerid, reason);
#endif