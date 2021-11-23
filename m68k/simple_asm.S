
*
* simple m68k startup routine
* 
* code is supposed to start at address 0
*

                .org    0

                .text
_start:         .long   initialstack
                .long   initialpc

initialpc:
                lea     initialstack,sp

loop:           lea     hello_world,a0
                jsr     print_string
                jra     loop

*
* print a 0 terminated string
* string address passed in A0
*
print_string:   move.b  (a0)+,d0
                beq     end_loop
                and.l   #0xff,d0

                | output character
not_ready:      tst.l   0xfffffff0          | check uart ready (!= 0)
                beq     not_ready           | not ready
                move.l  d0,0xfffffff4       | output character
                bra.s   print_string        | next character
end_loop:       rts                         | restart (next line)


                .data
                .even
hello_world:
                .ascii  "Hello World"
                .ascii  ", this is a (friendly) message from the 030 CPU!"
                .byte   13,10,0

                .bss
                .even
stack:          .ds.l   9
initialstack:   .ds.l   1

