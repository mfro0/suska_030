                .text
		.globl	_main
_main:
                lea     initialstack,sp
                move.l  #0xaffeaffe,(sp)
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
                .ds.l   65536
faraway:        .ds.l   1

