#if defined _zcmd_included
    #endinput
#endif
#define _zcmd_included

#define CMD:%1(%2) forward cmd_%1(%2); public cmd_%1(%2)
#define OnPlayerCommandText(%1) CMD_OnPlayerCommandText(%1)

forward CMD_OnPlayerCommandText(playerid, cmdtext[]);
public CMD_OnPlayerCommandText(playerid, cmdtext[]) {
    return 0;
}