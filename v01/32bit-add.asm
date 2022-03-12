
data_seg segment
    ; empty data segment
data_seg ends

stack_seg segment stack
    ; empty stack segment
stack_seg ends

code_seg segment
    
    assume cs:code_seg, ss:stack_seg, ds:data_seg

    mov ax, 25000
    mov bx, 25000
    
    mov cx, 25000
    mov dx, 25000
    
    xor si, si
    
    add bx, dx
    adc ax, cx
    
    jo overflow
    
    jmp exit
    
    overflow:
        mov si, 1
    
    exit:
        jmp exit

code_seg ends
end
