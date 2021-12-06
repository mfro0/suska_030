
CC=m68k-atari-mint-gcc
OBJCOPY=m68k-atari-mint-objcopy
NOBJCOPY=objcopy
OBJDUMP=m68k-atari-mint-objdump

CSRCS=
ASRCS=simple2_asm.S

COBJS=$(patsubst %.c,%.o,$(CSRCS))
AOBJS=$(patsubst %.S,%.o,$(ASRCS))
OBJS=$(AOBJS) $(COBJS)

CFLAGS000=-Wall -g -O3 -fomit-frame-pointer -nostdlib -ffreestanding -nostartfiles
CFLAGS=--std=c99 -Wall -g -O3 -mcpu=68030 -mtune=68030 -fomit-frame-pointer -nostdlib -ffreestanding -nostartfiles
LDFLAGS=-g -mcpu=68030 -mtune=68030 -Wl,-Map -Wl,mapfile -Wl,--cref -Wl,--oformat -Wl,srec -Wl,-T simple.lk
LDFLAGS000=-g -Wl,-Map -Wl,mapfile -Wl,--cref
ASFLAGS=$(CFLAGS)


all: $(OBJS)
	$(CC) $(LDFLAGS) $(CFLAGS) -o puzzle.srec libcmini/build/crt0.o $^ -Llibcmini/build -lcmini -lgcc
	$(NOBJCOPY) -I srec -O binary puzzle.srec simple.bin

.PHONY: clean
clean:
	- rm -f $(OBJS) simple.out simple.bin mapfile tst.srec 
    
dump:
	$(OBJDUMP) -bbinary --architecture=m68k:68030 -D simple.bin
