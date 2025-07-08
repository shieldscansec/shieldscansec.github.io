/*
 * MySQL Plugin for SA-MP
 * Basic definitions
 */

#if defined _mysql_included
    #endinput
#endif
#define _mysql_included

// MySQL Handle
#define MySQL: _:

// Constants
#define MYSQL_INVALID_HANDLE    MySQL:0

// Connection functions
native MySQL:mysql_connect(const host[], const user[], const password[], const database[], MySQLOpt:option_id = MySQLOpt:0);
native mysql_close(MySQL:handle = MYSQL_INVALID_HANDLE);
native mysql_reconnect(MySQL:handle = MYSQL_INVALID_HANDLE);

// Query functions
native mysql_query(MySQL:handle, const query[], bool:use_cache = true);
native mysql_tquery(MySQL:handle, const query[], const callback[] = "", const format[] = "", {Float,_}:...);
native mysql_format(MySQL:handle, output[], len, const format[], {Float,_}:...);
native mysql_escape_string(const source[], destination[], max_len = sizeof(destination), MySQL:handle = MYSQL_INVALID_HANDLE);

// Cache functions
native cache_num_rows();
native cache_get_value_int(row, const column_name[]);
native cache_get_value_float(row, const column_name[]);
native cache_get_value_name(row, const column_name[], destination[], max_len = sizeof(destination));

// Options
native mysql_set_charset(const charset[], MySQL:handle = MYSQL_INVALID_HANDLE);

// Enum for options
enum MySQLOpt {
    AUTO_RECONNECT,
    MULTI_STATEMENTS,
    POOL_SIZE,
    SERVER_PORT,
    SSL_ENABLE,
    SSL_KEY_FILE,
    SSL_CERT_FILE,
    SSL_CA_FILE,
    SSL_CA_PATH,
    SSL_CIPHER
}

#endif