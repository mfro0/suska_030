                .text
		.globl	_main
_main:
		clr.l	d0

loop:		movem.l	d0,-(sp)
		lea	-4*4(sp),sp
		clr.l	(sp)
		clr.l	4(sp)
		clr.l	8(sp)
		move.l	d0,12(sp)
		move.w	num,4(sp,d0.l)
		pea	message
                bsr     _printf
                lea	4 * 4(sp),sp

		movem.l	(sp)+,d0

		addq.l	#1,d0
		cmp.l	#8,d0
		beq	finish
                bra.s   loop
finish:		move.l	#0xfffffff8,d0	| crash us
                .data
message:	.asciz	"[%d] = %08x %08x\r\n"
		.byte	0
num:		.long	0x12345678

                .bss
                .even
stack:          .ds.l   49
initialstack:   .ds.l   1

