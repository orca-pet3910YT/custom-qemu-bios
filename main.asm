[bits 16]
org 0x0000

start:
	cli
	cld
	; initialize stack so we can `call` and `ret`
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00
	mov dx, 0x80
	mov al, 0x00 ; POST code 00
	out dx, al
	call init ; 0x0014
	mov bx, msg
	call print
	hlt

; the main init function
init:
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	mov dx, 0x3fb
	mov al, 0x01
	out dx, al
	mov dx, 0x3f8
	mov al, 0x01
	out dx, al
	mov dx, 0x3f9
	mov al, 0x00
	out dx, al
	mov dx, 0x3fb
	mov al, 0x03
	out dx, al
	ret ; 0x0042
	hlt

msg db "Meow", 13, 10, 0

; hey, you! yes, you! dereference ROM data with [cs:location] not [location]
; as that tells the CPU to read from [ds:location], where ds was emptied at machine power-on!

; a small serial print for a smaller BIOS using the memory address supplied on `bx`
print:
	mov al, [cs:bx]
	test al, al
	jz .done
	mov dx, 0x03fd
.wait:
	in al, dx
	test al, 0x20
	jz .wait
	mov dx, 0x03f8
	mov al, [cs:bx]
	out dx, al
	inc bx
	jmp print
.done:
	ret

times 65536 - 14 - ($ - $$) db 0
reset:
	jmp 0xF000:start
	times 9 db 0
