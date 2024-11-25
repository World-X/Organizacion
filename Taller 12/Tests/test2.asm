; Just print number variable

section .data
    number db 8

section .bss
    buffer resb 4

section .text
    global _start

_start:
    movzx eax, byte [number]
    add eax, 48
    mov [buffer], eax

    ; Print the number
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, buffer     ; buffer to print
    mov edx, 1          ; length of buffer
    int 0x80            ; call kernel

    ; Exit the program
    mov eax, 1          ; sys_exit
    mov ebx, 0          ; exit code
    int 0x80            ; call kernel