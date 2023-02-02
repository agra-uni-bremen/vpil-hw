#include <stdint.h>
#include <iostream>

#include "arduino_gangsta_wrapper.hpp"
#include "DS1302.h"

using namespace std;

int main() {
	pinMode(B7, OUTPUT);
	digitalWrite(B7, HIGH);

	DS1302 ds1302 (B0,B1,B2);

	printf("Init done.\n");


	while(true) {
		auto t = ds1302.time();
		cout << +t.yr << "-" << +t.mon << "-" << +t.date << endl;
		cout << +t.hr << ":" << +t.min << ":" << +t.sec << endl;

		delayMicroseconds(100000);
	}

	digitalWrite(B7, LOW);
	return 0;
}
