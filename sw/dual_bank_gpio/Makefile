common=../common
virtual-bus-path=$(common)/virtual-bus
vp_args=--error-on-zero-traphandler=true --intercept-syscalls
tty=/dev/ttyUSB0

main : main.c $(common)/irq.c $(common)/irq.h $(common)/bootstrap.S
	riscv32-unknown-elf-gcc main.c $(common)/irq.c $(common)/bootstrap.S -g -o main -march=rv32i -mabi=ilp32 -nostartfiles -Wl,--no-relax

$(virtual-bus-path)/responder-cli:
	make -C $(virtual-bus-path) responder-cli

real: main
	hwitl-vp main $(vp_args) --virtual-bus-device $(tty) --virtual-bus-baudrate 115200

sim: main $(virtual-bus-path)/responder-cli
	make -C $(virtual-bus-path) responder-cli
	make -C $(virtual-bus-path) pipe_left pipe_right
	sleep 1
	$(virtual-bus-path)/responder-cli $(virtual-bus-path)/pipe_right &
	hwitl-vp main $(vp_args) --virtual-bus-device $(virtual-bus-path)/pipe_left
	killall responder-cli || true
	killall socat || true

clean:
	rm -f main
	killall responder-cli || true
	killall socat || true

