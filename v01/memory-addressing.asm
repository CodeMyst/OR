data_seg segment

    num1 dw 17
    num2 dw 3
    
    arr db 1, 2, 3, 4, 5, 6, 7, 0
    
data_seg ends

code_seg segment

    assume cs:code_seg, ds:data_seg
    
    start:
        ; set data segment
        mov dx, offset data_seg
        mov ds, dx
        
        ; label access
        mov ax, num1
        add ax, num2
        mov num1, ax
        
        ; relative, writes to num2
        mov bx, 2
        mov num1[bx], 255
        
        mov si, 0 ; array index
        mov ax, 0 ; temporary value
        mov dx, 0 ; result
        
        ; sum all array elements
        loop1:
            ; move next array element to al (just one byte)
            mov al, arr[si]
            
            ; if ax == 0, exit, end of array
            cmp ax, 0
            je exit
            
            ; add ax to dx, increment index, go back to loop
            add dx, ax
            inc si
            jmp loop1
            
        exit:
            jmp exit
            end start
    
code_seg ends
