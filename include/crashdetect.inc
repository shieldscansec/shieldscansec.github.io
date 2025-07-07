/*
 * CrashDetect plugin include
 * Runtime error detection and debugging
 */

#if defined _crashdetect_included
    #endinput
#endif
#define _crashdetect_included

// Runtime error codes
#define AMX_ERR_NONE         0
#define AMX_ERR_EXIT         1
#define AMX_ERR_ASSERT       2
#define AMX_ERR_STACKERR     3
#define AMX_ERR_BOUNDS       4
#define AMX_ERR_MEMACCESS    5
#define AMX_ERR_INVINSTR     6
#define AMX_ERR_STACKLOW     7
#define AMX_ERR_HEAPLOW      8
#define AMX_ERR_CALLBACK     9
#define AMX_ERR_NATIVE      10
#define AMX_ERR_DIVIDE      11
#define AMX_ERR_SLEEP       12

// Natives (will be no-ops if plugin is not loaded)
native print_backtrace();
native print_crashdetect_version();

// Compatibility
#if !defined assert
    #define assert(%1) \
        do { \
            if (!(%1)) { \
                printf("Assertion failed: %s", #%1); \
                print_backtrace(); \
            } \
        } while (0)
#endif