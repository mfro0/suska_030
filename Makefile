LANG=C
ifeq ($(OS),Windows_NT)
	ALTPATH=c:/opt/intelFPGA_lite/17.0/quartus/bin64
	ALTOPT=
else
	ALTPATH=/opt/altera/13.1/quartus/bin
	ALTOPT=--64bit
endif

PROJ=wf68k30L_top.qsf
BITSTREAM=output_files/$(patsubst %.qpf,%,$(PROJ)).sof

all: synthesis fitter assembler timing_analyzer eda ghdl
#precmd synthesis fitter assembler timing_analyzer eda

precmd:
	$(ALTPATH)/quartus_sh -t precmd.tcl

synthesis:
	$(ALTPATH)/quartus_map --read_settings_files=on --write_settings_files=off $(ALTOPT) $(PROJ) -c $(PROJ)

fitter:
	$(ALTPATH)/quartus_fit --read_settings_files=off --write_settings_files=off $(ALTOPT) $(PROJ) -c $(PROJ)

assembler:
	$(ALTPATH)/quartus_asm --read_settings_files=off --write_settings_files=off $(ALTOPT) $(PROJ) -c $(PROJ)

timing_analyzer:
	$(ALTPATH)/quartus_sta $(ALTOPT) $(PROJ)

eda:
	$(ALTPATH)/quartus_eda --read_settings_files=off --write_settings_files=off --simulation $(ALTOPT) $(PROJ) -c $(PROJ)

# program the beast
p: $(BITSTREAM)
	$(ALTPATH)/quartus_pgm $(ALTOPT) -m JTAG -o P\;$(BITSTREAM)@1

.PHONY: ghdl
ghdl:
	cd ghdl; make

.PHONY: clean
clean:
	rm -rf db incremental_db
