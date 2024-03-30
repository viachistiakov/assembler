assume CS:code,DS:data

data segment
a dw 3
b dw 6
c dw 4
d dw 2
cnt dw 0
data ends

code segment
start:
mov AX, data
mov DS, AX
mov AH,0
mov AX,a
mul b
mov BX, AX
mov AX, c
xor dx, dx
div d
add AX, BX
add AX, 5

mov bx, 10
mov cx, 1
myloop1:
inc cnt
div bx
push dx
xor dx, dx
cmp ax, 0
je continue
jne myelse
myelse:
inc cx
loop myloop1

continue:
mov cx, cnt
myloop2:
pop dx
add dl, '0'
mov ah, 02h
int 21h
loop myloop2

mov ax, 4c00h
int 21h

code ends
end start