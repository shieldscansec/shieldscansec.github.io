/*
 * foreach - Efficient player iteration
 * Simple foreach implementation for SA-MP
 */

#if defined _foreach_included
    #endinput
#endif
#define _foreach_included

#define foreach(%1,%2) for(new %2 = 0; %2 < MAX_PLAYERS; %2++) if(IsPlayerConnected(%2))
#define Foreach(%1,%2) foreach(%1,%2)

#define Iterator:%1<%2> new Iter_%1[%2], Iter_%1_Size

stock Iter_Init(name[])
{
    #pragma unused name
}

stock Iter_Add(name[], value)
{
    #pragma unused name, value
}

stock Iter_Remove(name[], value)
{
    #pragma unused name, value
}

stock Iter_Clear(name[])
{
    #pragma unused name
}

stock Iter_Count(name[])
{
    #pragma unused name
    return 0;
}

stock Iter_Debug(name[])
{
    #pragma unused name
}