#include <stdint.h>
#include <iostream>
#include <iomanip>

#include "arduino_wrapper.hpp"
#include "DS1302.h"

using namespace std;

int main() {
	pinMode(B7, OUTPUT);
	digitalWrite(B7, HIGH);

	DS1302 ds1302 (B0,B1,B2);
	ds1302.halt(false);

	printf("Init done.\n");

	cout << setfill('0');

	while(true) {
		auto t = ds1302.time();
		cout << +t.yr << "-" << setw(2) << +t.mon << "-" << setw(2) << +t.date << " ";
		cout << setw(2) << +t.hr << ":" << setw(2) << +t.min << ":" << setw(2) << +t.sec << endl;

		delayMicroseconds(50000);
	}

	digitalWrite(B7, LOW);
	return 0;
}
