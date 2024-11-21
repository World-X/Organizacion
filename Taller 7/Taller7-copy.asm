section .data
    num1 db 5
    num2 db 11
    result db 0
    msg db 'Resultado: ', 0

section .bss
    buffer resb 4

section .text
    global _start

_start:
    lea esi, [num1]
    lea edi, [num2]
    mov al, [esi]
    add al, [edi]
    mov [result], al
    movzx eax, byte [result]
    add eax, 48
    mov [buffer], al
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, 11
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80