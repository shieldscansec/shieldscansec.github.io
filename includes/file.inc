#if defined _file_included
    #endinput
#endif
#define _file_included

/* File I/O functions */
native File:fopen(const name[], filemode:mode = io_readwrite);
native bool:fclose(File:handle);
native fwrite(File:handle, const string[]);
native fread(File:handle, string[], size=sizeof string, bool:pack=false);
native fputchar(File:handle, value, bool:utf8=true);
native fgetchar(File:handle, value, bool:utf8=true);
native fblockwrite(File:handle, const buffer[], size=sizeof buffer);
native fblockread(File:handle, buffer[], size=sizeof buffer);
native ftemp();
native fseek(File:handle, position=0, seek_whence:whence=seek_start);
native flength(File:handle);
native bool:fexist(const name[]);
native bool:frename(const oldname[], const newname[]);
native bool:fcopy(const source[], const target[]);
native bool:fdelete(const name[]);
native bool:fmatch(const name[], const pattern[], index=0, size=sizeof name);

/* File modes */
enum filemode {
    io_read,        /* file must exist */
    io_write,       /* creates a new file */
    io_readwrite,   /* opens an existing file, or creates a new file */
    io_append,      /* appends to file (write-only) */
}

/* File seek whence */
enum seek_whence {
    seek_start,
    seek_current,
    seek_end,
}

/* Directory functions */
native bool:fcreatedir(const name[]);
native bool:fremovedir(const name[]); 

/* File attributes */
native fattrib(const name[]);
native bool:fstat(const name[], &size=0, &timestamp=0, &mode=0, &inode=0);