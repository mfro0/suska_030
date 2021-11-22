
CC=m68k-atari-mint-gcc
OBJCOPY=m68k-atari-mint-objcopy
NOBJCOPY=objcopy
OBJDUMP=m68k-atari-mint-objdump

SRCS=simple_asm.S \
     puts.c

CFLAGS=-Wall -O2 -fomit-frame-pointer -nostdlib -ffreestanding -nostartfiles
LDFLAGS=-Wl,-Map -Wl,mapfile -Wl,--oformat -Wl,srec -Wl,-T simple.lk

all: simple_asm.o puts.o
	$(CC) $(LDFLAGS) $(CFLAGS) -o simple.srec $^
	$(NOBJCOPY) -I srec -O binary simple.srec simple.bin

.PHONY: clean
clean:
	- rm -f *.o simple.out simple.bin
    
dump:
	$(OBJDUMP) -bbinary --architecture=m68k:68020 -D simple.bin
