#include <stdint.h>
#include <stdio.h>

extern "C" {
	#include "../common/irq.h"
}

typedef uint32_t BUS_BRIDGE_TYPE;
static volatile BUS_BRIDGE_TYPE * const INTERNAL_LED = (BUS_BRIDGE_TYPE * const) 0x50000000;
static volatile BUS_BRIDGE_TYPE * const GPIO_BANK_A = (BUS_BRIDGE_TYPE * const) 0x50001000;
static volatile BUS_BRIDGE_TYPE * const GPIO_BANK_B = (BUS_BRIDGE_TYPE * const) 0x50002000;
static const unsigned BUS_BRIDGE_ITR = 2;


struct MRV32_GPIO {
	volatile uint32_t direction;	// direction of pins, 0: input (read pin), 1: output (write pin)
	volatile uint32_t output;		// outgoing pin values
	volatile uint32_t input;		// incoming, read pin values
};


struct MRV32_INTLED {
	volatile uint32_t val;
};

static struct MRV32_INTLED* const INT_LEDs = (struct MRV32_INTLED*) INTERNAL_LED;
static struct MRV32_GPIO*   const SWITCHES = (struct MRV32_GPIO*) GPIO_BANK_A;
static struct MRV32_GPIO*   const EXT_LEDs = (struct MRV32_GPIO*) GPIO_BANK_B;


static void set_next_timer_interrupt() {
	*mtimecmp = *mtime + 1000;  // 1000 timer ticks, corresponds to 1 MS delay with usual CLINT configuration
}

volatile static uint8_t internal_led_state = 0;
void timer_irq_handler() {
	printf("InternalLED update\n");
	INT_LEDs->val = internal_led_state++;
	set_next_timer_interrupt();
}

int main() {

	SWITCHES->direction = 0x00;
	EXT_LEDs->direction = 0xff;

	register_timer_interrupt_handler(timer_irq_handler);
	set_next_timer_interrupt();

	printf("Init done.\n");

	printf("TODO: Interface with DS1302\n");

	return 0;
}
