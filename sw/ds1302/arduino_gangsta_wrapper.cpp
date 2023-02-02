#include "arduino_gangsta_wrapper.hpp"

void digitalWrite(PinNumber pin, LogicLevel level) {
	if(pin >= INT_LED) {
		pin -= INT_LED;
		if(level == HIGH) {
			INTERN_LED->val |=  (1 << pin);
		} else {
			INTERN_LED->val &= ~(1 << pin);
		}
		return;
	}
	MRV32_GPIO* target;

	if(pin >= BANKB) {
		target = GPIO_BANK_B;
		pin -= BANKB;
	} else if (pin >= BANKA) {
		target = GPIO_BANK_A;
		pin -= BANKA;
	}

	if(level == HIGH) {
		target->output |=  (1 << pin);
	} else {
		target->output &= ~(1 << pin);
	}
}

LogicLevel digitalRead(PinNumber pin) {
	if(pin >= INT_LED) {
		pin -= INT_LED;
		return INTERN_LED->val &=  (1 << pin);
	}

	MRV32_GPIO* target;
	if(pin >= BANKB) {
		target = GPIO_BANK_B;
		pin -= BANKB;
	} else if (pin >= BANKA) {
		target = GPIO_BANK_A;
		pin -= BANKA;
	}

	return target->input &= (1 << pin);
}

void pinMode(PinNumber pin, PinDirection dir) {
	if(pin >= INT_LED)
		return;	// no direction needed

	MRV32_GPIO* target;
	if(pin >= BANKB) {
		target = GPIO_BANK_B;
		pin -= BANKB;
	} else if (pin >= BANKA) {
		target = GPIO_BANK_A;
		pin -= BANKA;
	}

	if(dir == INPUT) {
		target->direction &= ~(1 << pin);
	} else {
		target->direction |=  (1 << pin);
	}
}

void delayMicroseconds(Duration_us duration) {
	uint64_t now = *mtime;
	while(now + duration >= *mtime) {
		asm volatile ("nop");
	}
}
