#include <avr/io.h>

#define clear_bit(v, bit) v &= ~(1 << bit)
#define set_bit(v, bit)   v |=  (1 << bit)

static inline void setup_io () {
}

int main(void) {
	setup_io();

	for (;;) {
	}
}
