static inline int putchar(unsigned int c)
{
    volatile unsigned long *term_ready = (volatile unsigned long *) 0xfffffff0;
    volatile unsigned long *term_out = (volatile unsigned long *) 0xfffffff4;


    while (! *term_ready);
    *term_out = (unsigned long) c;

    return 1;
}

int puts(char *str)
{
    unsigned int c;

    while ((c = *str++))
        putchar(c);

    return 0;
}
