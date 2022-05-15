; rekurzivna procedura koja proverava da li je uneti string palindrom

data_seg segment
    
    msgInput db "Unesi string: $"
    msgPalindrome db "Uneti string je palindrom.$"
    msgNotPalindrome db "Uneti string nije palindrom.$"
    msgEnd db "Pritisni bilo koje dugme da se zavrsi program...$"
    
    inputString db 50 dup(' ')
    inputStringLen dw 0

data_seg ends

stack_seg segment stack
    dw 128 dup(?)
stack_seg ends

; makroi

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

; ucitaj znak bez ispisa
readkey macro
    push ax

    mov ah, 08
    int 21h

    pop ax
endm

; kraj programa
exit macro
    mov ax, 4c02h
    int 21h
endm

code_seg segment

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
    mov b. inputStringLen, cl ; sacuvaj duzinu
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

checkPalindrome proc
    ; if start == end, return true
    cmp bx, si
    je pal_true
    
    ; if input[start] != input[end] return false
    mov cl, inputString[bx] ; sacuvaj vrednosti karaktera input[start] i input[end]
    mov ch, inputString[si]
    cmp cl, ch ; ako nisu isti, return false
    jne pal_false
    
    ; ako postoji jos bar 2 karaktera - if start <= end, checkPalindrome(start + 1, end - 1)
    cmp bx, si
    ja pal_true
    
    inc bx
    dec si
    call checkPalindrome
    
    cmp ax, 1
    je pal_true
    jne pal_false
    
pal_true:
    mov ax, 1
    ret
    
pal_false:
    mov ax, 0
    ret
checkPalindrome endp

start:
    assume cs:code_seg, ss:stack_seg
    mov ax, data_seg
    mov ds, ax
    
    ; ucitaj string
    writestring msgInput
    push 50
    push offset inputString
    call readstring
    call newline
    
    cmp inputStringLen, 0 ; ako je duzina 0, return true
    je true
    
    call newline
    
    mov bx, 0 ; start index
    mov si, inputStringLen ; end index
    dec si ; smanji duzinu za 1 da bi drzalo vrednost zadnjeg indeksa umesto duzine
    call checkPalindrome
    
    cmp ax, 1 ; ako je true
    je true
    jne false
    
true:
    writestring msgPalindrome
    jmp end

false:
    writeString msgNotPalindrome

end:
    ; kraj
    call newline
    call newline
    writestring msgEnd
    readkey
    exit

end start
