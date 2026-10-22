nasm src/main.asm -fbin -o os.bin

qemu-system-x86_64 -display sdl \
	-m 256M \
    -hda os.bin