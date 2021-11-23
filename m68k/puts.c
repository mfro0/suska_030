static int putchar(int c)
{
    volatile long *term_ready = (volatile long *) 0xfffffff0;
    volatile long *term_out = (volatile long *) 0xfffffff4;


    while (! *term_ready);
    *term_out = (long) c;

    return 1;
}

int puts(char *str)
{
    int c;

    while ((c = *str++))
        putchar(c);

    return 0;
}
