common=../common

all : main.c $(common)/irq.c $(common)/irq.h $(common)/bootstrap.S
	riscv32-unknown-elf-gcc main.c $(common)/irq.c $(common)/bootstrap.S -g -o main -march=rv32i -mabi=ilp32 -nostartfiles -Wl,--no-relax

real: all
	hwitl-vp main --error-on-zero-traphandler=true --intercept-syscalls --virtual-bus-device /dev/ttyUSB0

clean:
	rm -f main

