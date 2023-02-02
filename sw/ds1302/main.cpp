#include <stdint.h>
#include <iostream>

#include "arduino_gangsta_wrapper.hpp"
#include "DS1302.h"

using namespace std;

static void set_next_timer_interrupt() {
	*mtimecmp = *mtime + 1000;  // 1000 timer ticks, corresponds to 1 MS delay with usual CLINT configuration
}

volatile static uint8_t internal_led_state = 0;
void timer_irq_handler() {
	printf("Internal LED update\n");
	INTERN_LED->val = internal_led_state++;
	set_next_timer_interrupt();
}

int main() {

	register_timer_interrupt_handler(timer_irq_handler);
	set_next_timer_interrupt();

	DS1302 ds1302 (B1,B2,B3);

	printf("Init done.\n");

	while(true) {
		auto t = ds1302.time();
		cout << t.yr << "-" << t.mon << "-" << t.date << endl;
		cout << t.hr << ":" << t.min << ":" << t.sec << endl;

		delayMicroseconds(1000);
	}

	return 0;
}
