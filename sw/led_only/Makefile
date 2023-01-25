common=../common
virtual-bus-path=$(common)/virtual-bus
<<<<<<< HEAD
vp_args=--error-on-zero-traphandler=true --intercept-syscalls 
ttyPort=/dev/ttyUSB0
=======
vp_args=--error-on-zero-traphandler=true --intercept-syscalls
tty=/dev/ttyUSB0
>>>>>>> 6b024eef660276457064dc7bdf7310cbdd45c1a9

main : main.c $(common)/irq.c $(common)/irq.h $(common)/bootstrap.S
	riscv32-unknown-elf-gcc main.c $(common)/irq.c $(common)/bootstrap.S -g -o main -march=rv32i -mabi=ilp32 -nostartfiles -Wl,--no-relax

<<<<<<< HEAD
real: all
	hwitl-vp main $(vp_args) --virtual-bus-device $(ttyPort) --virtual-bus-baudrate=115200
=======
$(virtual-bus-path)/responder-cli:
	make -C $(virtual-bus-path) responder-cli
>>>>>>> 6b024eef660276457064dc7bdf7310cbdd45c1a9

real: main
	hwitl-vp main $(vp_args) --virtual-bus-device $(tty) --virtual-bus-baudrate 115200

sim: main $(virtual-bus-path)/responder-cli
	make -C $(virtual-bus-path) pipe_left pipe_right
	$(virtual-bus-path)/responder-cli $(virtual-bus-path)/pipe_right &
	sleep 1
	hwitl-vp main $(vp_args) --virtual-bus-device $(virtual-bus-path)/pipe_left
	killall responder-cli || true
	killall socat || true

clean:
	rm -f main

