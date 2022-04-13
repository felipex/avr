#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#define set_bit(y,bit) (y|=(1<<bit))
#define tst_bit(y,bit) (y&(1<<bit))

char resultado[6];
unsigned uresultado;
unsigned vresultado;

volatile unsigned char converted;
volatile unsigned char newValue;

ISR(ADC_vect) {
  uresultado = ADC; 
  converted = 1;
  newValue = 1; 
}

void setup() {
   ADMUX = 0b01000000;

   // Habilita módulo ADC
   ADCSRA = ( 1 << ADEN );
   //Seleciona o prescaler 1:32 
   ADCSRA |= ( 1 << ADPS2 ) | ( 0 << ADPS1 ) | ( 1 << ADPS0 );
   // Habilita interrupção do ADC após interrupção
   ADCSRA |= (1 << ADIE);
   
   sei();

   converted = 1;
   newValue = 0;
   vresultado = 0;

   DDRB  = 0b00100000;
   PORTB = 0b00000000;
}

void loop() {
  if (newValue) {
    newValue = 0;
    if (uresultado > 500) {
	    PORTB = 0b00100000;
    }else {
	    PORTB = 0b00000000;
    }
    _delay_ms(100);
  }
  if (converted) {
    ADCSRA |= (1<<ADSC) | (1<<ADIE);
    converted = 0;
  }
}

int main() {
	setup();
	while(1) {
		loop();
	}
	return 0;
}
