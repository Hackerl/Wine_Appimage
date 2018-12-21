#include <stdlib.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <sys/reg.h>
#include <sys/user.h>
#include <stdio.h>
#include <syscall.h>
#include <fcntl.h>
#include <string.h>

/* 
 * Author: https://github.com/Hackerl
 * https://github.com/Hackerl/Wine_Appimage/issues/11#issuecomment-448081998
 * sudo apt-get -y install gcc-multilib
 * only for i386: gcc -std=c99 -m32 -static preloaderhook.c -o wine-preloader_hook
 * Put the file in the /bin directory, in the same directory as the wine-preloader.
 * hook int 0x80 open syscall. use special ld.so
 * */

#define LONGSIZE sizeof(long)
#define TARGET_PATH "/lib/ld-linux.so.2"
#define HasZeroByte(v) ~((((v & 0x7F7F7F7F) + 0x7F7F7F7F) | v) | 0x7F7F7F7F)
#define HOOK_OPEN_LD_SYSCALL -1

int main(int argc, char ** argv)
{
    if (argc < 2)
        return 0;

    char * wineloader = (char *) getenv("WINELDLIBRARY");

    if (wineloader == NULL)
    {
        return 0;
    }

    int LD_fd = open(wineloader, O_RDONLY);

    if (LD_fd == -1)
    {
        return 0;
    }

    pid_t child = fork();

    if(child == 0)
    {
        ptrace(PTRACE_TRACEME, 0, NULL, NULL);
        execv(*(argv + 1), argv + 1);
    }
    else
    {
        while(1)
        {
            int status = 0;
            wait(&status);

            if(WIFEXITED(status))
                break;

            long orig_eax = ptrace(PTRACE_PEEKUSER, 
                            child, 4 * ORIG_EAX, 
                            NULL);

            static int insyscall = 0;

            if (orig_eax == HOOK_OPEN_LD_SYSCALL)
            {
                ptrace(PTRACE_POKEUSER, child, 4 * EAX, LD_fd);

                //Detch
                ptrace(PTRACE_DETACH, child, NULL, NULL);
                break;
            }

            if (orig_eax == SYS_open)
            {
                if(insyscall == 0)
                {    
                    /* Syscall entry */
                    insyscall = 1;

                    //Get Path Ptr
                    long ebx = ptrace(PTRACE_PEEKUSER, 
                                child, 4 * EBX, NULL);

                    char Path[256];
                    memset(Path, 0, 256);

                    //Read Path String
                    for (int i = 0; i < sizeof(Path)/LONGSIZE; i ++)
                    {
                        union 
                        {
                            long val;
                            char chars[LONGSIZE];
                        } data;

                        data.val = ptrace(PTRACE_PEEKDATA, child, ebx + i * 4, NULL);
                        
                        memcpy(Path + i * 4, data.chars, LONGSIZE);

                        if (HasZeroByte(data.val))
                            break;
                    }
                    
                    if (strcmp(Path, TARGET_PATH) == 0)
                    {
                        //Modify Syscall -1. So Will Not Call Open Syscall.
                        ptrace(PTRACE_POKEUSER, child, 4 * ORIG_EAX, HOOK_OPEN_LD_SYSCALL);
                    }
                }
                else
                { 
                    /* Syscall exit */
                    insyscall = 0;
                }
            }

            ptrace(PTRACE_SYSCALL, child, NULL, NULL);
        }
    }

    close(LD_fd);
    return 0;
}
