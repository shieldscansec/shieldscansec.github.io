#if defined _mysql_included
    #endinput
#endif
#define _mysql_included

#define MySQL: MySQL:

native MySQL:mysql_connect(const host[], const user[], const database[], const password[], MySQL:handle = MySQL:1);
native mysql_close(MySQL:handle = MySQL:1);
native mysql_errno(MySQL:handle = MySQL:1);
native mysql_error(dest[], len = sizeof(dest), MySQL:handle = MySQL:1);
native mysql_tquery(MySQL:handle, const query[], const callback[] = "", const format[] = "", {Float,_}:...);
native cache_num_rows();

forward OnPlayerAccountCheck(playerid);