#pragma once
#include <stdint.h>

extern "C" {
	#include "../common/irq.h"
}

struct MRV32_GPIO {
	volatile uint32_t direction;	// direction of pins, 0: input (read pin), 1: output (write pin)
	volatile uint32_t output;		// outgoing pin values
	volatile uint32_t input;		// incoming, read pin values
};

struct MRV32_INTLED {
	volatile uint32_t val;
};

static struct MRV32_INTLED* const INTERN_LED  = (struct MRV32_INTLED* const) 0x50000000;
static struct MRV32_GPIO*   const GPIO_BANK_A = (struct MRV32_GPIO* const)   0x50001000;
static struct MRV32_GPIO*   const GPIO_BANK_B = (struct MRV32_GPIO* const)   0x50002000;

typedef bool LogicLevel;
static constexpr LogicLevel LOW = false;
static constexpr LogicLevel HIGH = true;

typedef bool PinDirection;
static constexpr PinDirection INPUT = false;
static constexpr PinDirection OUTPUT = true;

typedef uint8_t PinNumber;
typedef uint32_t Duration_us;

enum : PinNumber {
	BANKA = 0,
	A0 = BANKA,
	A1,
	A2,
	A3,
	A4,
	A5,
	A6,
	A7,

	BANKB,
	B0 = BANKB,
	B1,
	B2,
	B3,
	B4,
	B5,
	B6,
	B7,

	INT_LED,
	L0 = INT_LED,
	L1,
	L2,
	L3,
	L4,
	L5,
	L6,
	L7,
};

void digitalWrite(PinNumber pin, LogicLevel level);
LogicLevel digitalRead(PinNumber pin);
void pinMode(PinNumber pin, PinDirection dir);
void delayMicroseconds(Duration_us duration);
