
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
<<<<<<< HEAD
                pea.l   faraway
                lea     3 * 4(sp),sp
loop:           move.l  #hello_world,-(sp)
*loop:           pea     hello_world.l
                bsr     _puts
                addq.l  #4,sp
                bra.s   loop
                nop
=======
                lea     3 * 4(sp),sp
*loop:           move.l  #hello_world,-(sp)
loop:           pea     hello_world
                bsr     _puts
                addq.l  #4,sp
                bra.s   loop
>>>>>>> a0e275c8e3d8bf9ecca9e9def86d1ca6c9795cf1

                .data
hello_world:
<<<<<<< HEAD
                .ascii  "Hello World"
=======
                .ascii  "A friendly hello World from the m68k!"
>>>>>>> a0e275c8e3d8bf9ecca9e9def86d1ca6c9795cf1
                .byte   13,10,0

                .bss
                .even
stack:          .ds.l   19
initialstack:   .ds.l   1
                .ds.l   65536
faraway:        .ds.l   1

