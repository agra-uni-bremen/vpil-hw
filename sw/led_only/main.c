#include <stdint.h>
#include <stdio.h>
#include "../common/irq.h"

typedef uint32_t BUS_BRIDGE_TYPE;
static volatile BUS_BRIDGE_TYPE * const BUS_BRIDGE_START = (BUS_BRIDGE_TYPE * const) 0x50000000;
static volatile BUS_BRIDGE_TYPE * const BUS_BRIDGE_END   = (BUS_BRIDGE_TYPE * const) 0x5000000F; // INCLUSIVE
static const unsigned BUS_BRIDGE_ITR = 2;


static const unsigned num_words = (BUS_BRIDGE_END - BUS_BRIDGE_START) + 1;		// INCLUSIVE

void read_stuff() {
	for (int i = 0; i < num_words; i++) {
		const BUS_BRIDGE_TYPE datum = BUS_BRIDGE_START[i];
		for(int c = 0; c < sizeof(BUS_BRIDGE_TYPE); c++) {
			printf("%0X ", ((uint8_t*)&datum)[c]);
		}
		printf("\n");
	}
}



void write_stuff(unsigned delay) {
	printf("Write LED with delay of %d clock cycles\n", delay);
	for (unsigned i = 0; i < 256; i++) {
		printf("Writing %0X...\n", i);
		*BUS_BRIDGE_START = i;
		uint64_t now = *mtime;
		while(now + delay >= *mtime) {
			asm volatile ("nop");
		}
	}
}

int main() {

	write_stuff(100);
	
	write_stuff(0);
	
	write_stuff(10000);

	return 0;
}
