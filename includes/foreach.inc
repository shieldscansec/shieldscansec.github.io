#if defined _foreach_included
    #endinput
#endif
#define _foreach_included

#define foreach(%1,%2) for(new %2 = 0; %2 < MAX_PLAYERS; %2++) if(IsPlayerConnected(%2))
#define Iter_Init(%1) for(new %1_Index = 0; %1_Index < MAX_PLAYERS; %1_Index++)
#define Iter_Add(%1,%2) %1_Index++
#define Iter_Remove(%1,%2) %1_Index--