#include <stdio.h>
#include <string.h>
#include <dlfcn.h>
#include <stdlib.h>

/* Author: https://github.com/Hackerl/
 * https://github.com/Hackerl/Wine_Appimage/issues/11#issuecomment-447834456
 * sudo apt-get -y install gcc-multilib
 * gcc -shared -fPIC -ldl libhookexecv.c -o libhookexecv.so
 * for i386: gcc -shared -fPIC -m32 -ldl libhookexecv.c -o libhookexecv.so
 * 
 * hook wine execv syscall. use special ld.so
 * */

typedef int(*EXECV)(const char*, char**);

static inline int strendswith( const char* str, const char* end )
{
    size_t len = strlen( str );
    size_t tail = strlen( end );
    return len >= tail && !strcmp( str + len - tail, end );
}

int execv(char *path, char ** argv)
{
    static void *handle = NULL;
    static EXECV old_execv = NULL;
    char **last_arg = argv;

    if( !handle )
    {
        handle = dlopen("libc.so.6", RTLD_LAZY);
        old_execv = (EXECV)dlsym(handle, "execv");
    }

    char * wineloader = getenv("WINELDLIBRARY");

    if (wineloader == NULL)
    {
        return old_execv(path, argv);
    }

    while (*last_arg) last_arg++;

    char ** new_argv = (char **) malloc( (last_arg - argv + 2) * sizeof(*argv) );
    memcpy( new_argv + 1, argv, (last_arg - argv + 1) * sizeof(*argv) );

    char * pathname = NULL;

    char hookpath[256];
    memset(hookpath, 0, 256);

    if (strendswith(path, "wine-preloader"))
    {
        strcat(hookpath, path);
        strcat(hookpath, "_hook");
        
        wineloader = hookpath;
    }

    new_argv[0] = wineloader;
    int res = old_execv(wineloader, new_argv);
    free( new_argv );

    return res;
}
