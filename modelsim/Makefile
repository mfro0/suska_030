# simulate using modelsim

QUARTUS_PATH := /opt/altera/13.1
PATH := $(QUARTUS_PATH)/modelsim_ase/bin:$(PATH)

VCOM = vcom
VSIM = vsim
VLIB = vlib

FILES = \
    ../ghdl/utils.vhd \
    ../wf68k30L_pkg.vhd \
    ../wf68k30L_address_registers.vhd \
    ../wf68k30L_alu.vhd \
    ../wf68k30L_bus_interface.vhd \
    ../wf68k30L_control.vhd \
    ../wf68k30L_data_registers.vhd \
    ../wf68k30L_exception_handler.vhd \
    ../wf68k30L_opcode_decoder.vhd \
    ../wf68k30L_top.vhd \
	../simple.vhd

all:
	(cd ..; tclsh ./embed_m68k.tcl)
	echo $(PATH)
	$(VLIB) work
	$(VCOM) -2008 $(FILES)
	$(VCOM) -2008 ../ghdl/tb.vhd

run:
	$(VSIM) tb

clean:
	rm -rf work
