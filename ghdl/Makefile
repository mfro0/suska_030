GHDLFLAGS = --std=08 -fsynopsys
GHDL = ghdl

VPATH=..

TG68_OBJS = \
	tb.o \
	wf68k30L_address_registers.o  \
	wf68k30L_alu.o  \
	wf68k30L_bus_interface.o \
	wf68k30L_control.o \
	wf68k30L_data_registers.o \
	wf68k30L_exception_handler.o \
	wf68k30L_opcode_decoder.o \
	wf68k30L_pkg.o \
	wf68k30L_top.o \
	utils.o \

.PHONY: all
all: tb

tb: $(TG68_OBJS)

%: %.o
	$(GHDL) -m $(GHDLFLAGS) $@

%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

.PHONY: clean
clean:
	rm $(TG68_OBJS) tb
