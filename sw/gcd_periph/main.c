#include <stdint.h>
#include <stdio.h>
#include "../common/irq.h"

typedef uint32_t BUS_BRIDGE_TYPE;
static volatile BUS_BRIDGE_TYPE * const INTERNAL_LED = (BUS_BRIDGE_TYPE * const) 0x50000000;
static volatile BUS_BRIDGE_TYPE * const GPIO_BANK_A = (BUS_BRIDGE_TYPE * const) 0x50001000;
static volatile BUS_BRIDGE_TYPE * const GPIO_BANK_B = (BUS_BRIDGE_TYPE * const) 0x50002000;
static volatile BUS_BRIDGE_TYPE * const USER_UART = (BUS_BRIDGE_TYPE * const) 0x50003000;
static volatile BUS_BRIDGE_TYPE * const GCD_HW = (BUS_BRIDGE_TYPE * const) 0x50004000;
static const unsigned BUS_BRIDGE_ITR = 2;


struct MRV32_GPIO {
	volatile uint32_t direction;	// direction of pins, 0: input (read pin), 1: output (write pin)
	volatile uint32_t output;		// outgoing pin values
	volatile uint32_t input;		// incoming, read pin values
};

struct MRV32_INTLED {
	volatile uint32_t val;
};

struct UART_REGS{
    volatile uint32_t txData;
    volatile uint32_t txCtrl;
    volatile uint32_t rxData;
    volatile uint32_t rxOccupation;
    volatile uint32_t rxAlmostEmpty;
    volatile uint32_t rxEmpty;
};

struct GCD_REGS {
  volatile uint32_t a;
  volatile uint32_t b;
  volatile uint32_t res;
  volatile uint32_t ready;
  volatile uint32_t valid;
};

static struct MRV32_INTLED* const INT_LEDs  = (struct MRV32_INTLED*) INTERNAL_LED;
static struct MRV32_GPIO*   const SWITCHES  = (struct MRV32_GPIO*) GPIO_BANK_A;
static struct MRV32_GPIO*   const EXT_LEDs  = (struct MRV32_GPIO*) GPIO_BANK_B;
static struct UART_REGS*    const EXT_UART  = (struct UART_REGS*) USER_UART;
static struct GCD_REGS*     const GCD_ACCEL = (struct GCD_REGS*) GCD_HW;


static void set_next_timer_interrupt() {
	*mtimecmp = *mtime + 1000;  // 1000 timer ticks, corresponds to 1 MS delay with usual CLINT configuration
}

volatile static uint8_t internal_led_state = 0;
void timer_irq_handler() {
	printf("InternalLED update\n");
	INT_LEDs->val = internal_led_state++;
	set_next_timer_interrupt();
}


void incrementRegister(unsigned delay) {
	static uint8_t i = 0;
	printf("Write LED %0X with delay of %d clock cycles\n", i, delay);
	EXT_LEDs->output = i;
	uint64_t now = *mtime;
	while(now + delay >= *mtime) {
		asm volatile ("nop");
	}
	i++;
}
void knightRider(unsigned delay) {
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

int main() {
	SWITCHES->direction = 0x00;
	EXT_LEDs->direction = 0xff;

	static uint32_t const a = 24;
	static uint32_t const b = 777;
	uint32_t result;

	register_timer_interrupt_handler(timer_irq_handler);
	set_next_timer_interrupt();

	printf("Init done.\n");
	GCD_ACCEL->a = a;
	GCD_ACCEL->b = b;
	GCD_ACCEL->valid = 1;
	while(!GCD_ACCEL->ready);
	result = GCD_ACCEL->res;
	printf("Calculation done.\n");
	printf("a: %d, b: %d, gcd(a,b)=%d\n", a, b, result);
	return 0;
}
