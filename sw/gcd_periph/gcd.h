#include <stdint.h>
#include <stdio.h>
#include "../common/irq.h"

typedef uint32_t BUS_BRIDGE_TYPE;
static volatile BUS_BRIDGE_TYPE * const GCD_HW = (BUS_BRIDGE_TYPE * const) 0x50004000;

struct GCD_REGS {
  volatile uint32_t a;
  volatile uint32_t b;
  volatile uint32_t res;
  volatile uint32_t ready;
  volatile uint32_t valid;
};

static struct GCD_REGS*     const GCD_ACCEL = (struct GCD_REGS*) GCD_HW;

int sw_GCD(uint32_t a, uint32_t b) {
    // thanks to https://www.programiz.com/c-programming/examples/hcf-gcd
    while(a != b) {
        if(a > b)
            a -= b;
        else
            b -= a;
    }
    return a;
}

int hw_GCD(uint32_t a, uint32_t b) {
	GCD_ACCEL->a = a;
	GCD_ACCEL->b = b;
	GCD_ACCEL->valid = 1;
	while(!GCD_ACCEL->ready);
    return GCD_ACCEL->res;
}

static uint32_t const a = 36546;
static uint32_t const b = 1051654;
