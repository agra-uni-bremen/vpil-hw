#include <stdint.h>
#include <stdio.h>
#include "../common/irq.h"

typedef uint32_t BUS_BRIDGE_TYPE;
static volatile BUS_BRIDGE_TYPE * const INTERNAL_LED = (BUS_BRIDGE_TYPE * const) 0x50000000;
static volatile BUS_BRIDGE_TYPE * const GPIO_BANK_A = (BUS_BRIDGE_TYPE * const) 0x50001000;
static volatile BUS_BRIDGE_TYPE * const GPIO_BANK_B = (BUS_BRIDGE_TYPE * const) 0x50002000;
static const unsigned BUS_BRIDGE_ITR = 2;


struct MRV32_GPIO {
	volatile uint8_t direction; // direction of pins, 0: input (read pin), 1: output (write pin)
	volatile uint8_t input; // incomming, read pin values
	volatile uint8_t output; // outgoing pin values
};

struct MRV32_INTLED {
	volatile uint8_t val;
};

static struct MRV32_INTLED* const INT_LEDs = (struct MRV32_INTLED*) INTERNAL_LED;
static struct MRV32_GPIO*   const SWITCHES = (struct MRV32_GPIO*) GPIO_BANK_A;
static struct MRV32_GPIO*   const EXT_LEDs = (struct MRV32_GPIO*) GPIO_BANK_B;


static void set_next_timer_interrupt() {
	*mtimecmp = *mtime + 1000;  // 1000 timer ticks, corresponds to 1 MS delay with usual CLINT configuration
}

static uint8_t internal_led_state = 0;
void timer_irq_handler() {
	INT_LEDs->val = internal_led_state++;
	set_next_timer_interrupt();
}


void incrementRegister(unsigned delay) {
	printf("Write LED with delay of %d clock cycles\n", delay);
	for (unsigned i = 0; i < 256; i++) {
		printf("Writing %0X...\n", i);
		EXT_LEDs->output = i;
		uint64_t now = *mtime;
		while(now + delay >= *mtime) {
			asm volatile ("nop");
		}
	}
}
void knightRider(unsigned delay) {
	for (unsigned i = 0; i < 20; i++) {
		printf("Round %d...\n", i);
		for(uint8_t k = 1; k > 0; k <<= 1){
			EXT_LEDs->output  = k;
			uint64_t now = *mtime;
			while(now + delay >= *mtime) {
				asm volatile ("nop");
			}
		}
		for(uint8_t k = 0b10000000; k > 0; k >>= 1){
			EXT_LEDs->output  = k;
			uint64_t now = *mtime;
			while(now + delay >= *mtime) {
				asm volatile ("nop");
			}
		}
	}
}

int main() {

	SWITCHES->direction = 0;
	EXT_LEDs->direction = 1;
	
	register_timer_interrupt_handler(timer_irq_handler);

	printf("Init done.\n");

	while(!(SWITCHES->input & 0b10000000)) {
		printf("Running main loop\n");
		if(SWITCHES->input & 0b00000001) {
			printf("Running knight rider\n");
			knightRider(2000);
		} else {
			printf("Running counter\n");
			incrementRegister(100);
		}
	}

	return 0;
}
