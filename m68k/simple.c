#include <stdio.h>

static short xx;
int main(int argc, char *argv[])
{
    int x[] = { 0x01234567, 0x89abcdef };

    printf("simple test program\r\n");

    for (int i = 0; i < sizeof(x); i++)
    {
        int y[sizeof(x)] = {x[0], x[1]};

        int *unal = (int *) ((char *) &y + i);
        *unal = 0xaffebeef;

        printf("y[] = %08x %08x\r\n", y[0], y[1]);
    }

    puts("");

    for (int i = 0; i < sizeof(x); i++)
    {
        int y[sizeof(x)] = {x[0], x[1]};

        short *unal = (short *) ((char *) &y + i);
        *unal = 0xaffe;

        printf("y[] = %08x %08x\r\n", y[0], y[1]);
    }


    puts("");

    for (int i = 0; i < sizeof(x); i++)
    {
        int y[sizeof(x)] = {x[0], x[1]};

        char *unal = (char *) ((char *) &y + i);
        *unal = 0xaf;

        printf("y[] = %08x %08x\r\n", y[0], y[1]);
    }
    (void) * (volatile char *) 0xffffffff; /* stop program */
    return 0;
}
