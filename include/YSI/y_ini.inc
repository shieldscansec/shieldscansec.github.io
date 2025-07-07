/*
 * YSI - Y INI
 * INI file reading and writing library
 */

#if defined _y_ini_included
    #endinput
#endif
#define _y_ini_included

// INI constants
#define INI_MAX_LINE_LENGTH 256
#define INI_MAX_KEY_LENGTH  64
#define INI_MAX_VALUE_LENGTH 128

// INI parsing states
#define INI_PARSE_CONTINUE  0
#define INI_PARSE_SUCCESS   1
#define INI_PARSE_FAIL      2

// File handle structure
enum INI_File
{
    INI_File_Handle,
    INI_File_Buffer[INI_MAX_LINE_LENGTH],
    INI_File_Pos,
    bool:INI_File_Open
}

// Tags for type safety
#define INI:%1<%2> %1<%2>

// INI reading macros
#define INI_Int(%0,%1) \
    if (!strcmp(key, #%0, true)) { \
        %0 = strval(value); \
        continue; \
    }

#define INI_Float(%0,%1) \
    if (!strcmp(key, #%0, true)) { \
        %0 = floatstr(value); \
        continue; \
    }

#define INI_String(%0,%1,%2) \
    if (!strcmp(key, #%0, true)) { \
        strmid(%0, value, 0, strlen(value), %2); \
        continue; \
    }

#define INI_Bool(%0,%1) \
    if (!strcmp(key, #%0, true)) { \
        %0 = (strval(value) != 0); \
        continue; \
    }

// INI writing macros
#define INI_WriteInt(%0,%1) \
    format(string, sizeof(string), "%s=%d\r\n", #%0, %1); \
    fwrite(file, string);

#define INI_WriteFloat(%0,%1) \
    format(string, sizeof(string), "%s=%.6f\r\n", #%0, %1); \
    fwrite(file, string);

#define INI_WriteString(%0,%1) \
    format(string, sizeof(string), "%s=%s\r\n", #%0, %1); \
    fwrite(file, string);

#define INI_WriteBool(%0,%1) \
    format(string, sizeof(string), "%s=%d\r\n", #%0, (%1) ? 1 : 0); \
    fwrite(file, string);

// Function definitions
stock INI_Open(filename[])
{
    return fopen(filename, io_read);
}

stock INI_Close(File:handle)
{
    return fclose(handle);
}

stock INI_ParseFile(filename[], callback[])
{
    new File:file = fopen(filename, io_read);
    if (!file) return 0;
    
    new line[INI_MAX_LINE_LENGTH];
    new key[INI_MAX_KEY_LENGTH];
    new value[INI_MAX_VALUE_LENGTH];
    new pos;
    
    while (fread(file, line))
    {
        // Skip empty lines and comments
        if (!line[0] || line[0] == ';' || line[0] == '#') continue;
        
        // Find equals sign
        pos = strfind(line, "=");
        if (pos == -1) continue;
        
        // Extract key and value
        strmid(key, line, 0, pos);
        strmid(value, line, pos + 1, strlen(line));
        
        // Trim whitespace
        while (key[strlen(key) - 1] == ' ') key[strlen(key) - 1] = '\0';
        while (value[0] == ' ') strdel(value, 0, 1);
        while (value[strlen(value) - 1] == ' ') value[strlen(value) - 1] = '\0';
        while (value[strlen(value) - 1] == '\r') value[strlen(value) - 1] = '\0';
        while (value[strlen(value) - 1] == '\n') value[strlen(value) - 1] = '\0';
        
        // Call parsing function
        CallLocalFunction(callback, "ss", key, value);
    }
    
    fclose(file);
    return 1;
}

stock INI_WriteFile(filename[], callback[])
{
    new File:file = fopen(filename, io_write);
    if (!file) return 0;
    
    CallLocalFunction(callback, "i", _:file);
    
    fclose(file);
    return 1;
}

// Compatibility
#define INI_Load INI_ParseFile
#define INI_Save INI_WriteFile