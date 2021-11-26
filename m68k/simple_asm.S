
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
                lea     3 * 4(sp),sp
*loop:           move.l  #hello_world,-(sp)
loop:           pea     hello_world
                bsr     _puts
                addq.l  #4,sp
                bra.s   loop

                .data
hello_world:
                .ascii  "A friendly hello World from the m68k!"
                .byte   13,10,0

                .bss
                .even
stack:          .ds.l   19
initialstack:   .ds.l   1

