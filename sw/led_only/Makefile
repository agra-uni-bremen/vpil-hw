common=../common
virtual-bus-path=$(common)/virtual-bus
vp_args=--error-on-zero-traphandler=true --intercept-syscalls 
ttyPort=/dev/ttyUSB0

all : main.c $(common)/irq.c $(common)/irq.h $(common)/bootstrap.S
	riscv32-unknown-elf-gcc main.c $(common)/irq.c $(common)/bootstrap.S -g -o main -march=rv32i -mabi=ilp32 -nostartfiles -Wl,--no-relax

real: all
	hwitl-vp main $(vp_args) --virtual-bus-device $(ttyPort) --virtual-bus-baudrate=115200

sim: all
	make -C $(virtual-bus-path) all
	make -C $(virtual-bus-path) pipe_left pipe_right
	$(virtual-bus-path)/responder-cli $(virtual-bus-path)/pipe_right &
	sleep 1
	hwitl-vp main $(vp_args) --virtual-bus-device $(virtual-bus-path)/pipe_left
	killall responder-cli
	killall socat


clean:
	rm -f main

