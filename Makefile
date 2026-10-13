CC := riscv64-elf-gcc
QEMU := qemu-system-riscv64

ARCH_FLAGS := -march=rv64imac -mabi=lp64 -mcmodel=medany \
              -msmall-data-limit=0 -mno-relax

CFLAGS := $(ARCH_FLAGS) -std=c11 -ffreestanding \
          -fno-stack-protector -fno-pie \
          -Wall -Wextra -O0 -g

LDFLAGS := $(ARCH_FLAGS) -nostdlib -static \
           -Wl,-T,linker.ld -Wl,--build-id=none \
           -Wl,-Map,build/kernel.map

.PHONY: all qemu clean

all: build/kernel.elf

build:
	mkdir -p build

build/boot.o: boot.S | build
	$(CC) $(ARCH_FLAGS) -g -c $< -o $@

build/main.o: main.c | build
	$(CC) $(CFLAGS) -c $< -o $@

build/kernel.elf: build/boot.o build/main.o linker.ld
	$(CC) $(LDFLAGS) build/boot.o build/main.o -o $@

qemu: build/kernel.elf
	$(QEMU) -machine virt -m 128M -smp 1 \
		-nographic -bios none -kernel $<

clean:
	rm -rf build