#$@  	Le nom de la cible
#$< 	Le nom de la première dépendance
#$^ 	La liste des dépendances
#$? 	La liste des dépendances plus récentes que la cible
#$* 	Le nom du fichier sans suffixe
#.PHONY: clean mrproper


CC=avr-gcc
OBJCOPY=avr-objcopy
OBJDUMP=avr-objdump
#ASFLAGS=-mmcu=attiny261 --gdwarf2
#CCFLAGS=-mmcu=attiny261 -Wall -gdwarf-2 -std=gnu99 -Os -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums -MD -MP -MT
CCFLAGS=-mmcu=attiny861 -Wall -std=gnu99 -Os -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums -MD -MP -MT
LDFLAGS=-mmcu=attiny861
OBJCOPYFLAGS=-O ihex -R .eeprom 
OBJDUMPFLAGS=-h -S


DIRHEXTOVHD=../hex2vhdl
DIRBUILD=../build
SRC=porta.c
OBJ= $(SRC:.c=.o)
ELF=$(DIRBUILD)/$(SRC:.c=.elf)
HEX= $(DIRBUILD)/pm.hex
LSS= $(SRC:.c=.lss)
MAP= $(SRC:.c=.map)
DFILE= $(SRC:.c=.d)
DATAMEM=/opt/Xilinx/14.2/ISE_DS/ISE/bin/lin64/data2mem
BMMFILE=$(DIRBUILD)/attiny861.bmm
DIRBIT=../
BITFILE=$(DIRBIT)/microcontroleur.bit
BITFILENEW=$(DIRBIT)/microcontroleur_new.bit
DIRPM=${DIRBIT}
HEXTOVHDL=${DIRHEXTOVHD}/hex2vhdl
PMVHDBACKFILE=${DIRPM}/pm.vhd.back
PMVHDFILE=${DIRPM}/pm.vhd


all: 
	$(CC) $(CCFLAGS) $(OBJ) -c $(SRC)
	$(CC) $(LDFLAGS) -Wl,-Map=$(MAP) -o $(ELF) $(OBJ)	
	$(OBJCOPY) $(OBJCOPYFLAGS) $(ELF) $(HEX)
	$(OBJDUMP) $(OBJDUMPFLAGS) $(ELF) > $(LSS)
	
newbit:
	$(DATAMEM) -bm $(BMMFILE) -bd $(ELF) -bt $(BITFILE) -ob $(BITFILENEW)
	
newvhd:
	cp ${PMVHDFILE} ${PMVHDBACKFILE}
	${HEXTOVHDL}
	
	
clean:
	rm  $(DFILE) $(OBJ) $(ELF) $(HEX) $(LSS)
