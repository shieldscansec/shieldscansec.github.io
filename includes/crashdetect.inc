#if defined _crashdetect_included
    #endinput
#endif
#define _crashdetect_included

// CrashDetect plugin - apenas simulação para compilação
native PrintAmxBacktrace();
native PrintAmxBacktraceEx(line_number_format[] = "line %d");

forward OnRuntimeError(code, &bool:suppress);
public OnRuntimeError(code, &bool:suppress) {
    return 0;
}