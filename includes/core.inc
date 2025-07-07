#if defined _core_included
    #endinput
#endif
#define _core_included

#pragma rational Float

/* Prevent name collisions */
#define main        __main__
#define strlen      __strlen__
#define strfind     __strfind__
#define strcmp      __strcmp__
#define strins      __strins__
#define strdel      __strdel__
#define strcat      __strcat__
#define strmid      __strmid__
#define strpack     __strpack__
#define strunpack   __strunpack__
#define ispacked    __ispacked__
#define uudecode    __uudecode__
#define uuencode    __uuencode__
#define memcpy      __memcpy__

/* Constants */
#define debug       0x1
#define true        1
#define false       0
#define EOS         '\0'

/* Global symbol */
#define cellmax     0x7fffffff
#define cellmin     0x80000000