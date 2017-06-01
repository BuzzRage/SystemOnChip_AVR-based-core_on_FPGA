//      port.c

#include <avr/io.h>


// unite approximative 2us
void delai(unsigned long int delai) {
	volatile long int i=0;
	for(i=0;i<delai;i+=1);
} 

int main(void) {
	
	unsigned char tmp;
	DDRA = 0xF0;
	DDRB = 0x00;
   	tmp = 0;
	while (1) {
		PORTA = PINA << 4;
	}
	return 0;
}

