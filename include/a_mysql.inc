/*
 * SA-MP MySQL Plugin
 * Database connectivity for SA-MP
 */

#if defined _mysql_included
    #endinput
#endif
#define _mysql_included

// MySQL connection handle
#define MySQL: MySQL_Connection:

// MySQL result codes
#define MYSQL_OK                    0
#define MYSQL_ERROR                 1
#define MYSQL_INVALID_CONNECTION    2
#define MYSQL_NO_DATA               3

// Cache handling
#define CACHE_OK                    0
#define CACHE_EMPTY                 1
#define CACHE_INVALID               2

// MySQL logging levels
#define LOG_ERROR                   1
#define LOG_WARNING                 2
#define LOG_DEBUG                   4
#define LOG_INFO                    8
#define LOG_ALL                     15

// Native functions - Connection
native MySQL:mysql_connect(const host[], const user[], const database[], const password[], port = 3306, bool:autoreconnect = true, pool_size = 2);
native mysql_close(MySQL:handle);
native mysql_reconnect(MySQL:handle);
native mysql_errno(MySQL:handle);
native mysql_error(const destination[], max_len = sizeof(destination), MySQL:handle);

// Native functions - Queries
native mysql_query(MySQL:handle, const query[], bool:use_cache = true);
native mysql_tquery(MySQL:handle, const query[], const callback[] = "", const format[] = "", {Float,_}:...);
native mysql_pquery(MySQL:handle, const query[], const callback[] = "", const format[] = "", {Float,_}:...);

// Native functions - Threading
native mysql_stat(const destination[], max_len = sizeof(destination), MySQL:handle);
native mysql_get_charset(const destination[], max_len = sizeof(destination), MySQL:handle);
native mysql_set_charset(const charset[], MySQL:handle);

// Native functions - Escape
native mysql_escape_string(const source[], destination[], max_len = sizeof(destination), MySQL:handle);
native mysql_format(MySQL:handle, output[], len, const format[], {Float,_}:...);

// Native functions - Cache
native cache_get_row_count();
native cache_get_field_count();
native cache_get_field_name(field_index, destination[], max_len = sizeof(destination));
native cache_get_field_type(field_index);

native cache_get_value_index(row_index, field_index, destination[], max_len = sizeof(destination));
native cache_get_value_index_int(row_index, field_index);
native Float:cache_get_value_index_float(row_index, field_index);

native cache_get_value_name(row_index, const field_name[], destination[], max_len = sizeof(destination));
native cache_get_value_name_int(row_index, const field_name[]);
native Float:cache_get_value_name_float(row_index, const field_name[]);

native cache_save();
native cache_delete();
native cache_set_active(Cache:cache_id);
native Cache:cache_get_current();

// Native functions - Options
native mysql_option(MySQL:handle, option, value);
native mysql_global_option(option, value);
native mysql_log(loglevel = LOG_ERROR | LOG_WARNING);

// Backwards compatibility
#define mysql_num_rows cache_get_row_count
#define mysql_num_fields cache_get_field_count
#define mysql_fetch_row_format cache_get_value_index
#define mysql_fetch_field cache_get_value_name
#define mysql_fetch_int cache_get_value_name_int
#define mysql_fetch_float cache_get_value_name_float

// Helper stocks
stock mysql_real_escape_string(const source[], destination[], max_len = sizeof(destination), MySQL:handle)
{
    return mysql_escape_string(source, destination, max_len, handle);
}

stock mysql_ping(MySQL:handle)
{
    new query[32];
    format(query, sizeof(query), "SELECT 1");
    return mysql_query(handle, query, false);
}

stock mysql_insert_id(MySQL:handle)
{
    new query[64];
    format(query, sizeof(query), "SELECT LAST_INSERT_ID()");
    if (mysql_query(handle, query))
    {
        return cache_get_value_index_int(0, 0);
    }
    return 0;
}

stock mysql_affected_rows(MySQL:handle)
{
    new query[64];
    format(query, sizeof(query), "SELECT ROW_COUNT()");
    if (mysql_query(handle, query))
    {
        return cache_get_value_index_int(0, 0);
    }
    return 0;
}

// Callback forwards
forward OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle);
forward OnQueryFinish(const callback[], const query[], MySQL:handle);