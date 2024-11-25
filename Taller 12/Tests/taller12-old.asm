; Contador de palabras en una cadena de caracteres
; Se contarán la cantidad de espacios en blanco, y se sumará 1 al final

section .bss
    cadena resb 100
    contador resb 1

section .text
    global _start

_start:
    ; Leer la cadena de caracteres
    mov eax, 3
    mov ebx, 0
    mov ecx, cadena
    mov edx, 100
    int 0x80

    ; Contar la cantidad de palabras
    mov eax, 0
    mov ebx, cadena
    mov ecx, 0
    mov edx, 0
    .contar:
        mov al, [ebx + ecx]
        cmp al, 0
        je .fin
        cmp al, 32
        jne .siguiente
        inc edx
        .siguiente:
            inc ecx
            jmp .contar
    .fin:
        inc edx

    ; Mostrar la cantidad de palabras
    mov eax, 4
    mov ebx, 1
    mov ecx, contador
    mov edx, 1
    int 0x80

    ; Salir del programa
    mov eax, 1
    mov ebx, 0
    int 0x80

