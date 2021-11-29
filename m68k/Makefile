
CC=m68k-atari-mint-gcc
OBJCOPY=m68k-atari-mint-objcopy
NOBJCOPY=objcopy
OBJDUMP=m68k-atari-mint-objdump

CSRCS=puzzle.c
ASRCS=

COBJS=$(patsubst %.c,%.o,$(CSRCS))
AOBJS=$(patsubst %.S,%.o,$(ASRCS))
OBJS=$(AOBJS) $(COBJS)

CFLAGS000=-Wall -g -O3 -fomit-frame-pointer -nostdlib -ffreestanding -nostartfiles
CFLAGS030=-Wall -g -O3 -mcpu=68030 -mtune=68030 -fomit-frame-pointer -nostdlib -ffreestanding -nostartfiles
LDFLAGS=-g -Wl,-Map -Wl,mapfile -Wl,--cref -Wl,--oformat -Wl,srec -Wl,-T simple.lk
LDFLAGS000=-g -Wl,-Map -Wl,mapfile -Wl,--cref
LDFLAGS030=-g -Wl,-Map -Wl,mapfile -Wl,--cref


all: $(OBJS)
	$(CC) $(LDFLAGS) $(CFLAGS000) -o tst.srec libcmini/build/crt0.o $^ -Llibcmini/build -lcmini -lgcc
	$(NOBJCOPY) -I srec -O binary tst.srec simple.bin

.PHONY: clean
clean:
	- rm -f $(OBJS) simple.out simple.bin mapfile tst.srec 
    
.PHONY: check
check:
	CFLAGS="$(CFLAGS030)" LDFLAGS="$(LDFLAGS030)" echo \$CFLAGS
	#$(CC) -o puzzle030.prg libcmini/build/crt0.o puzzle.c -Llibcmini/build -lcmini -lgcc
	CFLAGS="$(CFLAGS000)" LDFLAGS="$(LDFLAGS000)" $(CC) -o puzzle000.prg libcmini/build/crt0.o puzzle.c -Llibcmini/build -lcmini -lgcc
	m68k-atari-mint-objdump -S -d puzzle030.prg > puzzle030.dis
	m68k-atari-mint-objdump -S -d puzzle000.prg > puzzle000.dis
	diffuse puzzle030.dis puzzle000.dis
dump:
	$(OBJDUMP) -bbinary --architecture=m68k:68020 -D simple.bin
