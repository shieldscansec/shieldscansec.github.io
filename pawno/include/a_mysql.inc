#if defined _mysql_included
    #endinput
#endif
#define _mysql_included

// MySQL constants
#define MYSQL_INVALID_HANDLE        0

// Connection handle type
#define MySQL: _:

// MySQL natives
native MySQL:mysql_connect(const host[], const user[], const password[], const database[], MySQLOpt:option_id = MySQLOpt:0);
native mysql_close(MySQL:handle = MYSQL_INVALID_HANDLE);
native mysql_errno(MySQL:handle = MYSQL_INVALID_HANDLE);
native mysql_error(destination[], max_len = sizeof(destination), MySQL:handle = MYSQL_INVALID_HANDLE);
native mysql_escape_string(const source[], destination[], max_len = sizeof(destination), MySQL:handle = MYSQL_INVALID_HANDLE);
native mysql_format(MySQL:handle, destination[], max_len, const format[], {Float,_}:...);
native mysql_pquery(MySQL:handle, const query[], const callback[] = "", const format[] = "", {Float,_}:...);
native mysql_query(MySQL:handle, const query[], bool:use_cache = true);
native mysql_stat(destination[], max_len = sizeof(destination), MySQL:handle = MYSQL_INVALID_HANDLE);
native mysql_get_charset(destination[], max_len = sizeof(destination), MySQL:handle = MYSQL_INVALID_HANDLE);
native mysql_set_charset(const charset[], MySQL:handle = MYSQL_INVALID_HANDLE);

// Cache natives
native cache_get_row_count();
native cache_get_field_count();
native cache_get_field_name(field_index, destination[], max_len = sizeof(destination));
native cache_get_field_type(field_index);
native cache_get_row(row, destination[], max_len = sizeof(destination), const delimiter[] = "|");
native cache_get_field(row, field_index, destination[], max_len = sizeof(destination));
native cache_get_field_assoc(row, const field_name[], destination[], max_len = sizeof(destination));
native cache_get_value_name(row, const field_name[], destination[], max_len = sizeof(destination));
native cache_get_value_name_int(row, const field_name[]);
native cache_get_value_name_float(row, const field_name[], &Float:destination);
native cache_get_value(row, field_index, destination[], max_len = sizeof(destination));
native cache_get_value_int(row, field_index);
native cache_get_value_float(row, field_index, &Float:destination);
native cache_set_result(Cache:cache_id);
native Cache:cache_save();
native cache_delete(Cache:cache_id);
native cache_affected_rows();
native cache_insert_id();
native cache_warning_count();

// Compatibility aliases
#define cache_num_rows() cache_get_row_count()
#define cache_num_fields() cache_get_field_count()

// MySQL options
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
};

native mysql_option(MySQLOpt:type, value);
native mysql_global_option(MySQLOpt:type, value);