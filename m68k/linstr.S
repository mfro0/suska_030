                .text
		.globl	_main

		.arch	68030
		.cpu	68030
_main:
loop:
		move.l	#10,d0

		*movel data_start(d0.l),faraway

                pea     hello_world
		move.l	data_start(d0.l),-(sp)
		
                bsr     _printf

                addq.l  #2 * 4,sp
                bra.s   loop

                .data
data_start:	.ds.l	100
hello_world:
                .ascii  "A friendly hello World from the m68k! faraway=%ld"
                .byte   13,10,0

                .bss
                .even
faraway:        .ds.l   1
stack:          .ds.l   8191
initialstack:   .ds.l   1

