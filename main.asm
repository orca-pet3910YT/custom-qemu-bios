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
	mov bx, ramtest_err_count
	call print
	call print_count
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
	mov bx, ramtest_notify
	call print
	call ram_test
	times 8 nop
	ret ; 0x0042
	hlt

print_count:
.start:
	xor dx, dx
	cmp cx, 0
	jne .print
	je .ret
.print:
	mov dx, 1
	mov bx, letter_a
	call print
	jmp .start
.ret:
	cmp dx, 1
	jne .noerr
	ret
.noerr:
	mov bx, ramtest_no_err
	call print
	ret

ram_test:
.test_start:
	mov bx, 0x2000
	xor cx, cx
	mov ax, 0xFFFF
.loop:
	mov word [bx], ax
	mov dx, [bx]
	cmp dx, ax
	jne .fail
	mov ax, 0xAAAA
	mov word [bx], ax
	mov dx, [bx]
	cmp dx, ax
	jne .fail
	mov ax, 0x5555
	mov word [bx], ax
	mov dx, [bx]
	cmp dx, ax
	jne .fail
	xor ax, ax
	mov word [bx], ax
	mov dx, [bx]
	cmp dx, ax
	jne .fail
	add bx, 2
	cmp bx, 0x7AFF
	jbe .loop
	cmp bx, 0x7AFE
	jbe .loop
.ret:
	mov bx, ramtest_successmsg
	call print
	ret
.fail:
	inc cx
	cmp cx, 0x0A
	je .halt
	jmp .loop
.halt:
	mov bx, ramtest_failmsg
	call print
	hlt

; string area

letter_a db 'E', 13, 10, 0
ramtest_no_err db "No errors detected", 13, 10, 0
msg db "Meow", 13, 10, 0
ramtest_failmsg db "RAM test did not pass, system halted", 13, 10, 0
ramtest_successmsg db "RAM test passed", 13, 10, 0
ramtest_notify db "Starting RAM test, 65535 iterations of the following patterns", 13, 10, "0xFFFF, 0xAAAA, 0x5555, 0x0000", 13, 10, 0
ramtest_err_count db "The number of following Es will say the amount of errors during the test: ", 0

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
