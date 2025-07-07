#if defined _string_included
    #endinput
#endif
#define _string_included

/* String functions */
native strlen(const string[]);
native strpack(dest[], const source[], maxlength=sizeof dest);
native strunpack(dest[], const source[], maxlength=sizeof dest);
native strcat(dest[], const source[], maxlength=sizeof dest);
native strmid(dest[], const source[], start, end, maxlength=sizeof dest);
native bool:strins(string[], const substr[], pos, maxlength=sizeof string);
native bool:strdel(string[], start, end);
native strcmp(const string1[], const string2[], bool:ignorecase=false, length=cellmax);
native strfind(const string[], const sub[], bool:ignorecase=false, pos=0);
native strval(const string[]);
native valstr(dest[], value, bool:pack=false);
native bool:ispacked(const string[]);
native uudecode(dest[], const source[], maxlength=sizeof dest);
native uuencode(dest[], const source[], numbytes, maxlength=sizeof dest);
native memcpy(dest[], const source[], index=0, numbytes, maxlength=sizeof dest);

/* Additional string functions */
native tolower(c);
native toupper(c);
native swapchars(c);

/* String character constants */
#define '\a'        '\x07'      // Bell (alert)
#define '\b'        '\x08'      // Backspace
#define '\e'        '\x1B'      // Escape character
#define '\f'        '\x0C'      // Form feed
#define '\n'        '\x0A'      // Line feed (newline)
#define '\r'        '\x0D'      // Carriage return
#define '\t'        '\x09'      // Horizontal tab
#define '\v'        '\x0B'      // Vertical tab
#define '\\'        '\x5C'      // Backslash
#define '\%'        '\x25'      // Percent
#define '\''        '\x27'      // Single quote
#define '\"'        '\x22'      // Double quote