#include <stdio.h>

int main(int argc, char *argv[])
{
    int x[] = { 0, 0, 0 };

    printf("simple test\r\n");

    for (int i = 0; i < sizeof(x) - sizeof(long); i++)
    {
        int y[sizeof(x)] = {x[0], x[1], x[2]};

        int *unal = (int *) ((char *) &y + i);
        *unal = 0x12345678;

        printf("y[] = %08x %08x\r\n", y[0], y[1]);
    }

    puts("");

    for (int i = 0; i < sizeof(x) - sizeof(long); i++)
    {
        int y[sizeof(x)] = {x[0], x[1], x[2]};

        short *unal = (short *) ((char *) &y + i);
        *unal = 0x1234;

        printf("y[] = %08x %08x\r\n", y[0], y[1]);
    }


    puts("");

    for (int i = 0; i < sizeof(x) - sizeof(long); i++)
    {
        int y[sizeof(x)] = {x[0], x[1], x[2]};

        char *unal = (char *) ((char *) &y + i);
        *unal = 0x12;

        printf("y[] = %08x %08x\r\n", y[0], y[1]);
    }

    (void) * (volatile char *) 0xffffffff; /* stop program */
    return 0;
}
