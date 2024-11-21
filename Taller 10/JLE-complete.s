%macro print_var 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .data
    sum db 0
    count db 1

section .text
    global _start

_start:
    jmp while_loop

while_loop:
    mov al, [count]
    cmp al, 10
    jle suma
    jmp fin

suma:
    add [sum], al
    inc byte [count]
    jmp while_loop

fin:
    print_var sum, 1 ; Imprime el caracter '7', que tiene un valor de 55 en ASCII
    mov eax, 1
    mov ebx, 0
    int 0x80