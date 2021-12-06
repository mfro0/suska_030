                .text
		.globl	_main
_main:
		clr.l	d0

loop:		movem.l	d0,-(sp)
		lea	-2*4(sp),sp
		move.l	d0,(sp)
		lsl.l	#4,d0
		nop
		move.l	(array,d0.l),4(sp)
		pea	message
                bsr     _printf
                lea	3 * 4(sp),sp

		movem.l	(sp)+,d0

		addq.l	#1,d0
		cmp.l	#8,d0
		beq	finish
                bra.s   loop
finish:		move.l	#0xfffffff8,d0	| crash us
                .data
message:	.asciz	"[%d] = %08x\r\n"
array:		.long	0
		.long	1
		.long	2
		.long	3
		.long	4
		.long 	5
		.long	6
		.long	7
		.long	8
		.long	9
		.long	0xa
		.long	0xb
		.long	0xc
		.long	0xd
		.long	0xe
		.long	0xf
		.long	0x10
		.long	0x11
		.long	0x12
		.long	0x13
		.long	0x14
		.long	0x15
		.long	0x16
		.long	0x17
		.long	0x18
		.long	0x19
		.long	0x1a
		.long	0x1b
		.long	0x1c
		.long	0x1d
		.long	0x1e
		.long	0x1f

                .bss
                .even
stack:          .ds.l   49
initialstack:   .ds.l   1

