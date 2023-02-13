#include <stdint.h>
#include <stdio.h>
#include "../common/irq.h"

typedef uint32_t BUS_BRIDGE_TYPE;
static volatile BUS_BRIDGE_TYPE * const GCD_HW = (BUS_BRIDGE_TYPE * const) 0x50004000;
static const unsigned BUS_BRIDGE_ITR = 2;

struct GCD_REGS {
  volatile uint32_t a;
  volatile uint32_t b;
  volatile uint32_t res;
  volatile uint32_t ready;
  volatile uint32_t valid;
};

static struct GCD_REGS*     const GCD_ACCEL = (struct GCD_REGS*) GCD_HW;

static void set_next_timer_interrupt() {
	*mtimecmp = *mtime + 1000;  // 1000 timer ticks, corresponds to 1 MS delay with usual CLINT configuration
}

void timer_irq_handler() {
	printf("InternalLED update\n");
	set_next_timer_interrupt();
}

int main() {
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
