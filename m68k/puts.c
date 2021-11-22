static int putchar(int c)
{
    volatile int *term_ready = (volatile int *) 0xfffffff0;
    volatile int *term_out = (volatile int *) 0xfffffff4;


    while (!*term_ready);
    *term_out = c;

    return 1;
}

int puts(char *str)
{
    int c;

    while ((c = *str++))
        putchar(c);

    return 0;
}
