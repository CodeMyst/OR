data_seg segment
    msg1 DB "Unesi broj elemenata: $"
    msg2 DB "Broj: $"
    msg3 DB "Obrnuti niz: $"
    msg4 DB "Pritisni bilo koje dugme da se zavrsi program...$"
    arr DW 50 dup(?)
    rev DW 50 dup(?)
    arrLenString DB "        "
    arrLen DW ?
    numString DB "        "
    num DW ?
data_seg ends

stack_seg segment stack
    dw 128 dup(?)
stack_seg ends

; makroi
             
; ispis znaka            
write macro c
    push ax
    push dx
    
    mov ah, 02
    mov dl, c
    int 21h   
    
    pop dx
    pop ax
endm

; ucitaj znak bez ispisa
readkey macro
    push ax      
    
    mov ah, 08
    int 21h  
    
    pop ax
endm
                   
; ispis teksta
writestring macro s
    push ax
    push dx      
    
    mov dx, offset s
    mov ah, 09
    int 21h
    
    pop dx
    pop ax
endm
    
; kraj programa
exit macro
    mov ax, 4c02h
    int 21h
endm

code_seg segment

; procedure    

; pomera cursor u sledecu liniju
newline proc 
    push ax
    push bx
    push cx
    push dx
    
    mov ah, 03
    mov bh, 0
    int 10h 
    inc dh   
    mov dl, 0
    mov ah, 02
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
newline endp

; ucitava string sa tastature
readstring proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov bp, sp
    mov dx, [bp + 12]
    mov bx, dx
    mov ax, [bp + 14]
    mov byte [bx], al
    mov ah, 0ah
    int 21h
    mov si, dx
    mov cl, [si + 1]
    mov ch, 0
copy:
    mov al, [si + 2]
    mov [si], al
    inc si
    loop copy
    mov [si], '$'
       
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret 4
readstring endp

; pretvara string u int
strtoint proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov bp, sp
    mov bx, [bp + 14]
    mov ax, 0
    mov cx, 0
    mov si, 10
loop0:
    mov cl, [bx]
    cmp cl, '$'
    je end0
    mul si
    sub cx, 48
    add ax, cx
    inc bx
    jmp loop0
end0:
    mov bx, [bp + 12]
    mov [bx], ax
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret 4
strtoint endp

; pretvara int u string
inttostr proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov bp, sp
    mov ax, [bp + 14]
    mov dl, '$'
    push dx
    mov si, 10
loop1:
    mov dx, 0
    div si
    add dx, 48
    push dx
    cmp ax, 0
    jne loop1
    mov bx, [bp + 12]
loop2:
    pop dx
    mov [bx], dl
    inc bx
    cmp dl, '$'
    jne loop2
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret 4
inttostr endp
        
 
; ucitaj duzinu niza
load_arr_len proc
    writestring msg1

    push 6
    push offset arrLenString
    call readstring

    push offset arrLenString
    push offset arrLen
    call strtoint

    ret   
load_arr_len endp                                                              


; ucitaj niz
load_arr proc

    push cx
    push si

    mov cx, arrLen ; counter
    xor si, si ; reset

load_loop:
    call newline
    writestring msg2

    push 6
    push offset numString
    call readstring

    push offset numString
    push offset num
    call strtoint

    mov ax, num
    mov arr[si], ax

    add si, 2
    loop load_loop

    pop si
    pop cx
   
    ret
load_arr endp


; obrni niz
reverse proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    xor di, di ; reset

    mov cx, arrlen
    mov si, cx
    mov al, 2
    mul si
    mov si, ax

reverse_loop:
    sub si, 2
    mov ax, arr[si]
    mov rev[di], ax
    add di, 2
    cmp si, 0
    jne reverse_loop

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
reverse endp
                                                                                             

; ispisi obrnuti niz                                                                            
print_reverse proc
    push ax
    push cx
    push si

    call newline
    mov cx, arrLen
    xor si, si ; reset

print_loop:
    mov ax, rev[si]
    push ax
    push offset numString
    call inttostr
    writestring numString
    call newline
    add si, 2
    loop print_loop

    pop si
    pop cx
    pop ax

    ret
print_reverse endp
                                         
                                         
start:
    assume cs:code_seg, ss:stack_seg ; postavljanje segmenata
    mov ax, data_seg
    mov ds, ax

    call load_arr_len ; unos duzine niza

    call load_arr ; unos niza

    call reverse ; obrtanje

    call newline
    call newline
    writestring msg3

    call print_reverse ; ispisi novi niz

    call newline
    writestring msg4
    readkey ; exit

    exit
end start
