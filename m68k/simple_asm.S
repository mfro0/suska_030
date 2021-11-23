
*
* simple m68k startup routine
* 
* code is supposed to start at address 0
*

                .org    0

                .globl  _putchar
                .text
_start:         .long   initialstack
                .long   initialpc

initialpc:
                lea     initialstack,sp
loop:           lea     hello_world,a0
iloop:          move.b  (a0)+,d0
                beq     end_loop
                and.l   #0xff,d0

                | output character
not_ready:      tst.l   0xfffffff0
                beq     not_ready
                move.l  d0,0xfffffff4
                bra.s   iloop
end_loop:       bra.s   loop


                .data
                .even
hello_world:
                .ascii  "Hello World"
                .byte   13,10,0

                .bss
                .even
stack:          .ds.l   0x200
initialstack:

