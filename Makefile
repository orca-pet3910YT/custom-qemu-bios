all:
	@echo "Assembling main.asm"
	@nasm -f bin -o bios.bin main.asm

qemu:
	@echo "Running in QEMU"
	@echo "hint: use GDB with:"
	@echo "target remote :1234"
	@echo "where 1234 is your QEMU port (which it is on my machine),"
	@echo "and use si to step instructions manually."
	@echo "QEMU is going to be halted until you manually unpause it and/or attach a debugger (which you should definitely do)"
	@qemu-system-i386 -bios bios.bin -s -S -serial stdio

clean:
	@rm -f bios.bin
	@echo "Cleaned."
