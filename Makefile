CC := riscv64-elf-gcc
QEMU := qemu-system-riscv64
GDB := gdb

ARCH_FLAGS := -march=rv64imac_zicsr -mabi=lp64 -mcmodel=medany \
              -msmall-data-limit=0 -mno-relax

CFLAGS := $(ARCH_FLAGS) -std=c11 -ffreestanding \
          -fno-stack-protector -fno-pie \
          -Wall -Wextra -O0 -g

LDFLAGS := $(ARCH_FLAGS) -nostdlib -static \
           -Wl,-T,linker.ld -Wl,--build-id=none \
           -Wl,-Map,build/kernel.map

.PHONY: all qemu gdb clean

all: build/kernel.elf

build:
	mkdir -p build

build/boot.o: boot.S | build
	$(CC) $(ARCH_FLAGS) -g -c $< -o $@

build/trap.o: trap.S | build
	$(CC) $(ARCH_FLAGS) -g -c $< -o $@

build/main.o: main.c | build
	$(CC) $(CFLAGS) -c $< -o $@

build/kernel.elf: build/boot.o build/trap.o build/main.o linker.ld
	$(CC) $(LDFLAGS) build/boot.o build/trap.o build/main.o -o $@

run: build/kernel.elf
	$(QEMU) -machine virt -m 128M -smp 1 \
		-nographic -bios none -kernel $<

gdb: build/kernel.elf
	@$(QEMU) -machine virt -m 128M -smp 1 \
		-display none -monitor none -serial file:build/qemu.log \
		-bios none -kernel $< -S -gdb tcp:127.0.0.1:1234 & \
	qemu_pid=$$!; \
	trap 'kill $$qemu_pid 2>/dev/null; wait $$qemu_pid 2>/dev/null' EXIT; \
	$(GDB) -q $< \
		-ex 'set tcp auto-retry on' \
		-ex 'set tcp connect-timeout 3' \
		-ex 'target remote 127.0.0.1:1234' \
		-ex 'break kernel_main' \
		-ex 'continue'

clean:
	rm -rf build
