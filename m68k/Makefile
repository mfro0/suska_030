
CC=m68k-atari-mint-gcc
OBJCOPY=m68k-atari-mint-objcopy
NOBJCOPY=objcopy
OBJDUMP=m68k-atari-mint-objdump

SRCS=puzzle.c

CFLAGS=-Wall -O2 -fomit-frame-pointer -nostdlib -ffreestanding -nostartfiles
LDFLAGS=-Wl,-Map -Wl,mapfile -Wl,--cref -Wl,--oformat -Wl,srec -Wl,-T simple.lk

all: $(SRCS)
	$(CC) $(LDFLAGS) $(CFLAGS) -o puzzle.srec libcmini/build/crt0.o $^ -Llibcmini/build -lcmini -lgcc
	$(NOBJCOPY) -I srec -O binary puzzle.srec simple.bin

.PHONY: clean
clean:
	- rm -f *.o simple.out simple.bin
    
dump:
	$(OBJDUMP) -bbinary --architecture=m68k:68020 -D simple.bin
