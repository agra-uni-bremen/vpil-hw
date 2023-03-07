#include "../gcd.h"
int main() {
	printf("GCD SW calculation:\n");
	uint32_t result = hw_GCD(a, b);
	printf("a: %d, b: %d, gcd(a,b)=%d\n", a, b, result);
	return 0;
}
