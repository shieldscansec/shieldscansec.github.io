#if defined _datagram_included
    #endinput
#endif
#define _datagram_included

/* Datagram/Network functions */
native Socket:socket_create(type);
native socket_close(Socket:socket);
native socket_bind(Socket:socket, const address[], port);
native socket_listen(Socket:socket, backlog);
native Socket:socket_accept(Socket:socket, address[], &port);
native socket_connect(Socket:socket, const address[], port);
native socket_send(Socket:socket, const data[], length);
native socket_recv(Socket:socket, data[], length);
native socket_sendto(Socket:socket, const data[], length, const address[], port);
native socket_recvfrom(Socket:socket, data[], length, address[], &port);
native socket_set_option(Socket:socket, option, value);
native socket_get_option(Socket:socket, option);

/* Socket types */
#define SOCKET_TCP      0
#define SOCKET_UDP      1

/* Socket options */
#define SO_REUSEADDR    1
#define SO_KEEPALIVE    2
#define SO_BROADCAST    3
#define SO_NODELAY      4

/* Network constants */
#define SOCKET_ERROR    -1
#define INVALID_SOCKET  Socket:-1

/* Address families */
#define AF_INET         2
#define AF_INET6        10

/* Protocol families */
#define PF_INET         AF_INET
#define PF_INET6        AF_INET6