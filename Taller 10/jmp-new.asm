section .data
    num1 db 0
    num2 db 0
    result db 0
    msg db "Resultado: ", 0
    resultStr db "00", 0xA
    zeroMsg db "Esto es un cero", 0xA

section .text
    global _start

_start:
    mov al, [num1]
    add al, [num2]
    mov [result], al
    cmp byte [result], 0
    je print_zero
    
    movzx eax, byte [result]
    add eax, '0'
    mov [resultStr], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, 11
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, resultStr
    mov edx, 3
    int 0x80
    
    jmp exit_program

print_zero:
    mov eax, 4
    mov ebx, 1
    mov ecx, zeroMsg
    mov edx, 16
    int 0x80

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80