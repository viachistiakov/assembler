assume cs: code, ds: data

data segment
string1 db 25, ?, 25 dup (0)
string2 db 25, ?, 25 dup (0)
string11 db 25, ?, 25 dup (0) 
string22 db 25, ?, 25 dup (0) 
string3 db 50, 50 dup (0) 
string33 db 50, 50 dup (0)      
string4  db 50, 50 dup (0)  
string44 db 50, 50 dup (0)   
string5  db 50, 50 dup (0)   
string55 db 50, 50 dup (0) 
msg1 db 0ah, 0dh, "Enter first numebr: $"
msg2 db 0ah, 0dh, "Enter second number: $"	
s db 0ah, 0dh, "THE BASIS OF SYSTEM IS 10 $"
sss db 0ah, 0dh, "THE BASIS OF SYSTEM IS 16 $"	
msg3 db 0ah, 0dh, "Result of addition in dec: $"
msg33 db 0ah, 0dh, "Result of addition in hex: $"
msg4 db 0ah, 0dh, "Result of substraction in dec: $"
msg44 db 0ah, 0dh, "Result of substraction in hex: $"
msg5 db 0ah, 0dh, "Result of multiplication in dec: $"
msg55 db 0ah, 0dh, "Result of multiplication in hex: $"
line db 0ah, 0dh, '$'
data ends

sseg segment stack
db 255 dup (?)
sseg ends

code segment

stdn macro m, buf
	mov ax, 0
	mov dx, offset m
	mov ah, 09h
	int 21h		
	
	mov dx, offset buf
	mov ah, 0ah
	int 21h		
endm

fromString proc 
	pop bp
	pop di 
	mov cx, 0
	mov cl, [di]
	add di, 1
	cycle:
		cmp byte ptr [di], 48
		jb exit				
		cmp byte ptr [di], 57
		ja inhex				
		sub byte ptr [di], 30h
		jmp incr
		inhex: 	
			cmp byte ptr [di], 65
			jb exit	
			cmp byte ptr [di], 70			
			ja lower
			sub byte ptr [di], 55
			jmp incr
		lower: 	
			cmp byte ptr [di], 97
			jb exit	
			cmp byte ptr [di], 102
			ja exit	
			sub byte ptr [di], 87	
		incr: 
			inc di			
			dec cx
			or cx, cx
			jne cycle
			jmp next
	exit: 
		mov ah, 4ch
		int 21h
	next: 
	mov byte ptr [di], '$'	
	push bp
	ret	
fromString endp

toString proc
	pop bp
	pop di
	mov cx, 0
	mov cl, [di]
	add di, 1
	mov dx, di
	makeStr:
		cmp byte ptr [di], 9
		ja letter
		add byte ptr [di], 48
		jmp nxt
		letter:
			add byte ptr [di], 55
		nxt:
			inc di				
			dec cx				
			or cx, cx
			jne makeStr
	mov byte ptr [di], '$'			
	mov ah, 09h
	int 21h	
	mov dx, offset line
	int 21h
	push bp
	ret
toString endp

addition proc
	push bp
	mov bp, sp
	
	mov di, [bp+4]
	mov si, [bp+6]
	mov bx, [bp+8]

	mov cx, 0
	mov dx, 0
	mov cl, [di]
	mov dl, [si]
	add di, cx
	add si, dx		
	cmp dx, cx		
	ja larger		
		xchg cx, dx		
		xchg  di, si	
	larger:
		sub dx, cx
	add bx, [bx]
	push dx
	mov dl, [bp + 10]
	xor ax, ax
	sumcycle:
		or cx, cx
		je then
		add al, byte ptr [di]
		add al, byte ptr [si]
		div dl
		mov byte ptr [bx], ah 
		xor ah, ah		
		dec di	
		dec si
		dec cx
		dec bx
		jmp sumcycle
	then: 
		pop cx
	sumlast:
		xor ah, ah
		or cx, cx
		je addexit
		add al, byte ptr [si]
		div dl		
		mov byte ptr [bx], ah
		xor ah, ah		
		dec si
		dec cx
		dec bx
		jmp sumlast
	addexit: 
	mov byte ptr [bx], al
	mov sp, bp 
	pop bp     
	ret 6	   
addition endp

substraction proc
	push bp			
	mov bp, sp		
	
	mov di, [bp+4]		
	mov si, [bp+6]		
	mov bx, [bp+8]

	mov cx, 0
	mov dx, 0
	mov cl, [di]	
	mov dl, [si]	
	add di, cx 		
	add si, dx		
	
	sub cx, dx		 
	add bx, [bx]	 
	
	push cx
	xor ax, ax		
	xor cx, cx		
	subcycle:
		or dx, dx	
		je thensub
		mov al, byte ptr [di]	
		cmp al, cl
		jnb subelse
		add al, [bp+10]
		dec al
		jmp subt
		subelse:
			sub al, cl
			xor cx, cx
		subt:
			cmp al, byte ptr [si]
			jnb ssub
			add al, [bp+10]
			mov cx, 1
		ssub:
			sub al, byte ptr [si]
		mov byte ptr [bx], al 
		dec di	
		dec si
		dec dx
		dec bx
		jmp subcycle
	thensub: 
		pop dx
	sublast:	
		xor ah, ah
		or dx, dx
		je subexit
		mov al, byte ptr [di]
		cmp al, cl
		jnb subb
		add al, [bp+10]
		dec al
		jmp subs
		subb:
			sub al, cl
			xor cx, cx
		subs:	
			mov byte ptr [bx], al
			xor ah, ah		
			dec di
			dec dx
			dec bx
		jmp sublast
	subexit: 
	mov sp, bp 
	pop bp     
	ret 6	   
substraction endp

multiplication proc
	push bp			
	mov bp, sp		

	mov di, [bp+4]		
	mov si, [bp+6]		
	mov bx, [bp+8]		

	mov cx, 0
	mov dx, 0
	mov cl, [di]	
	mov dl, [si]	
	add di, cx 		
	add si, dx		
	cmp cx, dx			
	ja largr		
		xchg cx, dx		
		xchg  di, si	
	largr: 
	add bx, [bx]	
	xor ax, ax		
	
	mulcycle:
		or dx, dx	
		je mulexit

		push bx	
		push di	
		push si			
		push cx			
		push dx			
			
		xor dx, dx 
		xor ax, ax
		mulccl:
			or cx, cx 
			je eout
			mov al, byte ptr [di]	
			mul byte ptr [si]	
			add al, dh		
			div byte ptr [bp+10]	
			mov dh, al				
			mov al, byte ptr [bx]	 
			add al, ah		
			add al, dl		
			xor ah, ah
			div byte ptr [bp+10]	
			mov [bx], ah
			mov dl, al	
			dec di
			dec cx
			dec bx
			jmp mulccl
		eout:
			
			xor ax, ax
			mov al, byte ptr [bx]
			add al, dh		
			add al, dl		
			div byte ptr [bp+10]	
			mov byte ptr [bx], ah
			mov byte ptr [bx-1], al

			pop dx			
			pop cx			
			pop si			
			pop di			
			pop bx	
			
			dec bx			
			dec si			
			dec dx
		jmp mulcycle	
			
	mulexit:
		mov sp, bp 
		pop bp     
		ret 6	   
multiplication endp

start:	
	mov ax, data
	mov ds, ax
	
	lea dx, s	
	mov ah, 09h
	int 21h
	
	stdn msg1, string1
	stdn msg2, string2
	
	mov dx, offset string1 + 1
	push dx		
	call fromString	
	mov dx, offset string2 + 1
	push dx		
	call fromString
	
	push 10
	push offset string3
	push offset string2 + 1
	push offset string1 + 1
	call addition
	
	lea dx, msg3
	mov ah, 09h
	int 21h	
	push offset string3
	call toString
	
	push 10
	push offset string4
	push offset string2 + 1
	push offset string1 + 1
	call substraction
	
	lea dx, msg4
	mov ah, 09h
	int 21h	
	push offset string4
	call toString
	
	push 10
	push offset string5
	push offset string1 + 1
	push offset string2 + 1
	call multiplication
	
	lea dx, msg5
	mov ah, 09h
	int 21h	
	push offset string5
	call toString	
	
	
	lea dx, sss
	mov ah, 09h
	int 21h
	
	stdn msg1, string11
	stdn msg2, string22
	
	mov dx, offset string11 + 1
	push dx		
	call fromString
		
	mov dx, offset string22 + 1
	push dx		
	call fromString
	
	push 16
	push offset string33
	push offset string22 + 1
	push offset string11 + 1
	call addition
	
	lea dx, msg33
	mov ah, 09h
	int 21h	
	push offset string33
	call toString
	
	push 16
	push offset string44
	push offset string22 + 1
	push offset string11 + 1
	call substraction
	
	lea dx, msg44
	mov ah, 09h
	int 21h	
	push offset string44
	call toString
	
	push 16
	push offset string55
	push offset string11 + 1
	push offset string22 + 1
	call multiplication
	
	lea dx, msg55
	mov ah, 09h
	int 21h	
	push offset string55
	call toString
	
	mov ah, 4ch
	int 21h

	code ends
	end start