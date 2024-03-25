assume CS:code,DS:data

data segment
mystr db 100, 99 dup (0)
symbol db ?
ind db ?
notfound db "not found$"
;dummy db 0Ah, '$'
data ends

code segment

strchr proc near
    push bp
    mov bp, sp

    cld
    mov di, [bp+6] ; mystr
    xor cx, cx
    mov cl, byte ptr[di+1] ; cx <- len(mystr)
    add di, 2
    xor ax, ax
    mov bx, [bp+4]
    mov al, byte ptr[bx]
    repne scasb
    jne .end
    .exist:
        dec di
        mov [bp+4], di
    .end:
        pop bp
        ret
strchr endp

start:
	mov AX, data
	mov DS, AX
    MOV  ES,  AX

    mov dx, offset mystr ; считываем mystr
	mov ah, 0Ah
	int 21h

    mov bx, offset mystr ; добавляем в конец mystr $
	xor dx, dx
	mov dl, byte ptr[bx+1]
	add bx, 2
	add bx, dx
	mov byte ptr[bx], '$'

    mov dx, offset mystr
    push dx ; передаем mystr

	mov dl, 0Ah ; /n
	mov ah, 02h
    int 21h

	mov ah, 01h ; считываем symbol
	int 21h
    mov symbol, al

    mov dx, offset symbol
    push dx ; передаем symbol

    mov dl, 0Ah ; /n
	mov ah, 02h
    int 21h

    call strchr

    pop bx
    mov si, offset mystr
    mov dl, byte ptr[si+1]
    inc dx
    cmp dx, bx
    jl .notfound


    mov dx, offset mystr
    add dx, bx ;ответ в bx - указатель в mystr, где входит string
    mov ah, 09h
    int 21h

    jmp .endprog

.notfound:
    mov dx, offset notfound
    mov ah, 09h
    int 21h

.endprog:
	mov AX,4C00h
	int 21h
code ends
end start