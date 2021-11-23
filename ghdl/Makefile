GHDLFLAGS = --std=08 -fsynopsys
GHDL_RUNFLAGS = --ieee-asserts=disable
GHDL = ghdl

VPATH=..

TG68_OBJS = \
	wf68k30L_pkg.o \
	wf68k30L_address_registers.o  \
	wf68k30L_alu.o  \
	wf68k30L_bus_interface.o \
	wf68k30L_control.o \
	wf68k30L_data_registers.o \
	wf68k30L_exception_handler.o \
	wf68k30L_opcode_decoder.o \
	wf68k30L_top.o \
	simple.o \
	utils.o \

.PHONY: all
all: tb

.PHONY: code
code:
	(cd ..; tclsh ./embed_m68k.tcl)

tb.o: simple.o $(TG68_OBJS)

tb: tb.o code

%: %.o
	$(GHDL) -m $(GHDLFLAGS) $@

%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

.PHONY: run
run: tb
	./tb $(GHDL_RUNFLAGS) --wave=tb.ghw
.PHONY: clean
clean:
	rm $(TG68_OBJS) tb
