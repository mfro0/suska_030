
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
loop:           pea     hello_world
                bsr     _puts
                addq.l  #4,sp
                bra.s   loop


                .data
                .even
hello_world:
                .ascii  "Hello World"
                .byte   13,10,0

                .bss
                .even
stack:          .ds.l   0x200
initialstack:

