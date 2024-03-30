assume CS:code, DS:data

data segment
len DW 6
arr DW 1, 2, 7, -12, -5, 4
res DW ?
data ends

code segment
start:
    mov AX, data
    mov DS, AX
    mov CX, len
    mov DI, 255
    loop1:
        mov AX, arr[SI]
        CMP AX, DI
        jg skip
        mov DI, AX
        skip:
            add SI, 2     
        loop loop1 
    mov AX, 4C00H
    int 21h
    code ends
end start         
