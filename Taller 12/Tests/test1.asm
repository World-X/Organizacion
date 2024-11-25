; Just read and print it out immediately

section .bss
    buffer resb 100

section .text
    global _start

_start:
    ; Read input from the user
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, buffer     ; buffer to store input
    mov edx, 100        ; max number of bytes to read
    int 0x80            ; call kernel

    ; Print the input
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, buffer     ; buffer to print
    int 0x80            ; call kernel

    ; Exit the program
    mov eax, 1          ; sys_exit
    mov ebx, 0          ; exit code
    int 0x80            ; call kernel