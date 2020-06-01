CC=i686-elf-gcc
AS=i686-elf-as

boot-iso: build-iso
	qemu-system-i386 -cdrom output/cmduck.iso

boot-kernel: build
	qemu-system-i386 -kernel output/cmduck.bin

build-iso: build
	cp output/cmduck.bin output/isodir/boot/cmduck.bin
	cp src/grub.cfg output/isodir/boot/grub/grub.cfg
	grub-mkrescue -o output/cmduck.iso output/isodir

build: kernel boot
	$(CC) -T src/linker.ld -o output/cmduck.bin -ffreestanding -O2 -nostdlib output/boot.o output/kernel.o -lgcc

boot: src/boot.s
	$(AS) src/boot.s -o output/boot.o

kernel: src/kernel.c
	$(CC) -c src/kernel.c -o output/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
