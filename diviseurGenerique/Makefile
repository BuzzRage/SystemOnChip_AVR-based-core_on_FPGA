CC=ghdl
PROG=diviseurGenFreq
SRC=$(PROG).vhdl
VCD=$(PROG).vcd
SRCTB=$(PROG)_tb.vhdl
ENTITE=$(PROG)_tb
OPTIONS= --ieee=synopsys -fexplicit
AOPTIONS= -Wc,-m32 -Wa,--32
EOPTIONS= -Wa,--32 -Wl,-m32
STOPTIME=500ns
	
all:
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(SRC)
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(SRCTB)
	$(CC) -e $(EOPTIONS) $(OPTIONS) $(ENTITE)
	$(CC) -r $(OPTIONS) $(ENTITE) --vcd=$(VCD) --stop-time=$(STOPTIME)
view:
	gtkwave $(VCD)
	
clean:
	$(CC) --clean
	rm  $(VCD) *.cf
