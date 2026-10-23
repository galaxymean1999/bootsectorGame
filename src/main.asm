[org 0x7c00]
[bits 16]

; BIOS interrupts
; https://jyywiki.cn/pages/OS/manuals/BIOS-interrupts.pdf

; ASM instructions
; https://github.com/7etsuo/x86

; VGA colour palette
; https://www.fountainware.com/EXPL/vgapalette.png

start:
    ; switch to graphics mode
    xor ah, ah
    mov al, 0x13    ; 320x200 256 colours
    int 0x10

    mov ax, 0xa000
    mov es, ax

    ; clear the screen with green
    mov al, 0x2f
    call clear_screen

    mov ax, 20
    mov bx, 10
    mov cl, 0x28
    call set_pixel

    mov ax, 10
    mov bx, 2
	call calculate_offset
    mov cx, 200
    mov dl, 0x24
    call horizontal_line

	mov ax, 10
	mov bx, 10
	call calculate_offset
	mov cx, 100
	mov bx, 50
	mov dl, 77
	call fill_rect

    jmp $

; ax - memory offset where to start
; cx - width
; bx - height
; dl - colour
fill_rect:
.loop:
	push ax
	push cx
	call horizontal_line
	pop cx
	pop ax
	add ax, 320
	dec bx
	jnz .loop
	ret

; ax - memory offset
; cx - length
; dl - colour
horizontal_line:
.loop:
    mov di, ax
    mov [es:di], dl
    inc ax
    dec cx
    jnz .loop
    ret

; ax - x position (0 - 319)
; bx - y position (0 - 199)
calculate_offset:
    mov si, bx
    shl bx, 8   ; y * 256
    shl si, 6   ; y * 64
    add bx, si
    add ax, bx  ; offset = y * 256 + y * 64 + x
    ret

; ax - x position (0 - 319)
; bx - y position (0 - 199)
; cl - colour
set_pixel:
    call calculate_offset

    mov di, ax

    mov [es:di], cl
    ret

; al - colour to clear the screen with
clear_screen:
    mov cx, 64000
.loop:
    mov di, cx
    dec di
    mov [es:di], al
    dec cx
    jnz .loop
    ret

times 510-($-$$) db 0
dw 0xaa55
