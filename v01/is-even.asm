org 100h

; add numbers
mov ax, num1
add ax, num2

; check if lowest bit set
test ax, 1

; if the result is 1, the number is odd
; otherwise it's even
jz even
jnz exit

even:
    mov si, 1

exit:
    jmp exit

ret

num1 dw 32
num2 dw 8
