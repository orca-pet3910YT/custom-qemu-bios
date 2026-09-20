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
	call init
	mov bx, msg
	call print
	hlt

; the main init function
init:
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	; initialize the VGA
	; prep for init
	mov dx, 0x3C4
	xor ax, ax
	out dx, al
	inc dx
	mov al, 0x01
	out dx, al

	mov dx, 0x3D4
	mov al, 0x11
	out dx, al
	inc dx
	in al, dx
	and al, 0x7F
	out dx, al
	; mode control
	mov dx, 0x3DA
	in ax, dx
	mov dx, 0x3C0
	mov al, 0x10
	out dx, al
	mov al, 0x0C
	out dx, al
	mov dx, 0x3DA
	in ax, dx
	; set up overscan register
	mov dx, 0x3C0
	mov al, 0x11
	out dx, al
	xor ax, ax
	out dx, al
	mov dx, 0x3DA
	in ax, dx
	; color plane enable
	mov dx, 0x3C0
	mov al, 0x12
	out dx, al
	mov al, 0x0F
	out dx, al
	mov dx, 0x3DA
	in ax, dx
	; horizontal panning
	mov dx, 0x3C0
	mov al, 0x13
	out dx, al
	mov al, 0x08
	out dx, al
	mov dx, 0x3DA
	in ax, dx
	; color select
	mov dx, 0x3C0
	mov al, 0x14
	out dx, al
	xor ax, ax
	out dx, al
	mov dx, 0x3DA
	in ax, dx
	; MOR
	mov dx, 0x3C2
	mov al, 0x67
	out dx, al
	; sequencer reset
	mov dx, 0x3C4
	xor al, al
	out dx, al
	inc dx
	mov al, 0x01
	out dx, al
	; clock mode
	mov dx, 0x3C4
	mov al, 0x01
	out dx, al
	inc dx
	xor ax, ax
	out dx, al
	; map mask
	mov dx, 0x3C4
	mov al, 0x02
	out dx, al
	inc dx
	mov al, 0x03
	out dx, al
	; character select
	mov dx, 0x3C4
	mov al, 0x03
	out dx, al
	inc dx
	xor ax, ax
	out dx, al
	; memory mode
	mov dx, 0x3C4
	mov al, 0x04
	out dx, al
	inc dx
	mov al, 0x02
	out dx, al
	; release reset
	mov dx, 0x3C4
	xor al, al
	out dx, al
	inc dx
	mov al, 0x03
	out dx, al
	; mode register
	mov dx, 0x3CE
	mov al, 0x05
	out dx, al
	inc dx
	mov al, 0x10
	out dx, al
	; set/reset
	mov dx, 0x3CE
	xor al, al
	out dx, al
	inc dx
	xor al, al
	out dx, al
	; enable s/r
	mov dx, 0x3CE
	mov al, 0x01
	out dx, al
	inc dx
	xor al, al
	out dx, al
	; color compare
	mov dx, 0x3CE
	mov al, 0x02
	out dx, al
	inc dx
	xor al, al
	out dx, al
	; data rotate
	mov dx, 0x3CE
	mov al, 0x03
	out dx, al
	inc dx
	xor al, al
	out dx, al
	; read map select
	mov dx, 0x3CE
	mov al, 0x04
	out dx, al
	inc dx
	mov al, 0x02
	out dx, al
	; mode
	mov dx, 0x3CE
	mov al, 0x05
	out dx, al
	inc dx
	mov al, 0x10
	out dx, al
	; misc register
	mov dx, 0x3CE
	mov al, 0x06
	out dx, al
	inc dx
	mov al, 0x0E
	out dx, al
	; color don't care
	mov dx, 0x3CE
	mov al, 0x07
	out dx, al
	inc dx
	xor al, al
	out dx, al
	; bit mask
	mov dx, 0x3CE
	mov al, 0x08
	out dx, al
	inc dx
	mov al, 0xFF
	out dx, al
	; horizontal total
	mov dx, 0x3D4
	xor ax, ax
	out dx, al
	inc dx
	mov al, 0x5F
	out dx, al
	; horizontal display enable end
	mov dx, 0x3D4
	mov al, 0x01
	out dx, al
	inc dx
	mov al, 0x4F
	out dx, al
	; horizontal blank start
	mov dx, 0x3D4
	mov al, 0x02
	out dx, al
	inc dx
	mov al, 0x50
	out dx, al
	; horizontal blank end
	mov dx, 0x3D4
	mov al, 0x03
	out dx, al
	inc dx
	mov al, 0x82
	out dx, al
	; horizontal retrace start
	mov dx, 0x3D4
	mov al, 0x04
	out dx, al
	inc dx
	mov al, 0x55
	out dx, al
	; horizontal retrace end
	mov dx, 0x3D4
	mov al, 0x05
	out dx, al
	inc dx
	mov al, 0x81
	out dx, al
	; vertical total
	mov dx, 0x3D4
	mov al, 0x06
	out dx, al
	inc dx
	mov al, 0xBF
	out dx, al
	; overflow
	mov dx, 0x3D4
	mov al, 0x07
	out dx, al
	inc dx
	mov al, 0x1F
	out dx, al
	; preset row scan
	mov dx, 0x3D4
	mov al, 0x08
	out dx, al
	inc dx
	xor ax, ax
	out dx, al
	; maximum scan line
	mov dx, 0x3D4
	mov al, 0x09
	out dx, al
	inc dx
	mov al, 0x0F
	out dx, al
	; cursor start
	mov dx, 0x3D4
	mov al, 0x0A
	out dx, al
	inc dx
	mov al, 0x0E
	out dx, al
	; cursor end
	mov dx, 0x3D4
	mov al, 0x0B
	out dx, al
	inc dx
	mov al, 0x0F
	out dx, al
	; start address high
	mov dx, 0x3D4
	mov al, 0x0C
	out dx, al
	inc dx
	xor al, al
	out dx, al
	; start address low
	mov dx, 0x3D4
	mov al, 0x0D
	out dx, al
	inc dx
	xor al, al
	out dx, al
	; cursor loc high
	mov dx, 0x3D4
	mov al, 0x0E
	out dx, al
	inc dx
	xor al, al
	out dx, al
	; cursor loc low
	mov dx, 0x3D4
	mov al, 0x0F
	out dx, al
	inc dx
	xor al, al
	out dx, al
	; palette setup
	mov dx, 0x3DA
	in al, dx
	mov dx, 0x3C0
	xor al, al
	xor cl, cl
.palette_setup:
	mov dx, 0x3DA
	in al, dx
	mov dx, 0x3C0
	mov al, cl
	out dx, al
	mov al, cl
	out dx, al
	inc cx
	cmp cx, 16
	jne .palette_setup
	; vertical retrace start
	mov dx, 0x3D4
	mov al, 0x10
	out dx, al
	inc dx
	mov al, 0x9C
	out dx, al
	; vertical retrace end
	mov dx, 0x3D4
	mov al, 0x11
	out dx, al
	inc dx
	mov al, 0x0E
	out dx, al
	; vertical display enable end
	mov dx, 0x3D4
	mov al, 0x12
	out dx, al
	inc dx
	mov al, 0x8F
	out dx, al
	; logical width
	mov dx, 0x3D4
	mov al, 0x13
	out dx, al
	inc dx
	mov al, 0x28
	out dx, al
	; underline location
	mov dx, 0x3D4
	mov al, 0x14
	out dx, al
	inc dx
	mov al, 0x1F
	out dx, al
	; vertical blank start
	mov dx, 0x3D4
	mov al, 0x15
	out dx, al
	inc dx
	mov al, 0x96
	out dx, al
	; vertical blank end
	mov dx, 0x3D4
	mov al, 0x16
	out dx, al
	inc dx
	mov al, 0xB9
	out dx, al
	; mode control (again)
	mov dx, 0x3D4
	mov al, 0x17
	out dx, al
	inc dx
	mov al, 0xA3
	out dx, al
	; init is done
	mov dx, 0x3D4
	mov al, 0x11
	out dx, al
	inc dx
	mov al, 0x8E
	out dx, al
	; font setup
	mov dx, 0x3C4
	mov al, 0x02
	out dx, al
	inc dx
	mov al, 0x04
	out dx, al

	dec dx
	mov al, 0x04
	out dx, al
	inc dx
	mov al, 0x07
	out dx, al

	mov dx, 0x3CE
	mov al, 0x04
	out dx, al
	inc dx
	mov al, 0x02
	out dx, al

	dec dx
	mov al, 0x05
	out dx, al
	inc dx
	xor ax, ax
	out dx, al

	dec dx
	mov al, 0x06
	out dx, al
	inc dx
	xor ax, ax
	out dx, al

	mov ax, 0xA000
	mov es, ax
	xor di, di

	mov di, 0x41*32
	mov si, font_data_A
	mov cx, 16
.copy_char:
	mov al, [cs:si]
	mov [es:di], al
	inc si
	inc di
	loop .copy_char

	mov dx, 0x3C4
	mov al, 0x02
	out dx, al
	inc dx
	mov al, 0x03
	out dx, al

	dec dx
	mov al, 0x04
	out dx, al
	inc dx
	mov al, 0x02
	out dx, al

	mov dx, 0x3CE
	mov al, 0x05
	out dx, al
	inc dx
	mov al, 0x10
	out dx, al

	dec dx
	mov al, 0x06
	out dx, al
	inc dx
	mov al, 0x0E
	out dx, al

	; turn on display
	mov dx, 0x3DA
	in al, dx
	mov dx, 0x3C0
	mov al, 0x20
	out dx, al

	; end of VGA init
	mov ax, 0xB800
	mov es, ax
	xor di, di
	cld
	mov ax, 0x1F41
	stosw
	ret
	hlt

; hey, you! yes, you! dereference ROM data with [cs:location] not [location]
; as that tells the CPU to read from [ds:location], where ds was emptied at machine power-on!

; a small serial print for a smaller BIOS using the memory address supplied on `bx`
print:
	push ax
	push dx
.next:
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
	jmp .next
.done:
	pop dx
	pop ax
	ret

font_data_A:
db 00011000b
db 00111100b
db 01100110b
db 01100110b
db 01111110b
db 01100110b
db 01100110b
db 01100110b
db 01100110b
db 0
db 0
db 0
db 0
db 0
db 0
db 0

letter_a db 'E', 13, 10, 0
msg db "Meow", 13, 10, 0

times 65536 - 14 - ($ - $$) db 0
reset:
	jmp 0xF000:start
	times 9 db 0
