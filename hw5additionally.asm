input macro buf, string, symbol
    mov di, offset buf
    mov si, offset string
    inc si
    mov ax, 0
    mov cx, 0
    see:
        mov al, byte ptr [di]
        cmp al, 10
        je ou
        mov byte ptr [si], al
        inc si
        inc di 
        inc cx
        jmp see
    ou:
    inc di
    mov al, byte ptr [di]  
    mov symbol, al   
    mov si, offset string
    mov byte ptr [si], cl
endm

close macro handle
    mov bx, handle
    mov al, 0
    mov ah, 3eh
    int 21h
endm

counting macro stu, symbol
local repet, skip
    mov dx, 0
    mov cx, 0
    mov di, offset stu
    mov cl, byte ptr [di]
    inc di
    mov al, symbol
    repet:
        mov bl, byte ptr [di]
        cmp al, bl
        jne skip
        inc dx
        skip:
        inc di
        loop repet
endm

open macro file, handle
    mov dx, offset file
	mov ax, 0
	mov ah, 3dh
	int 21h
    mov handle, ax
endm

create macro file, handle
    mov cx, 0
    mov al, 1
    mov ah, 3ch
    mov dx, offset file
    int 21h
    mov handle, ax
endm

read macro handle, filesize, buf
    mov ax, 0
    mov ah, 3fh
    mov bx, handle
    mov cx, filesize
    mov dx, offset buf 
    int 21h
endm
 
write macro handle, filesize, databuf
    mov ax, 0
    mov ah,40h
    mov bx, handle
    mov cx, filesize
    mov dx, offset databuf 
    int 21h
endm

print macro resmsg, res
mov di, offset resmsg 
    mov cx, 0 
    mov bx, 10
    mov ax, res
    fillStack: ; to ASCII
        mov dx, 0
        div bx
        add dl, '0' 
        push dx
        inc cx 
        test ax, ax 
        jnz fillstack  
    mov filesize, cx    
    makeAnswer:
        pop dx
        mov byte ptr [di], dl
        inc di
        loop makeanswer
    mov byte ptr [di], 10
    inc di
    mov byte ptr [di], 13
    inc di
    mov byte ptr [di], "$"
endm