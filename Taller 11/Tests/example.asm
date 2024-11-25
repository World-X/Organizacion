%macro suma 2-3
    %if %0 == 2
        mov eax, %1
        add eax, %2
    %elif %0 == 3
        mov eax, %1
        add eax, %2
        add eax, %3
    %else
        mov eax, 0
    %endif
%endmacro

%macro imprimir 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .bss
    res resb 4

section .text
    global _start

_start:
    suma 5, 4
    add eax, '0'
    mov [res], eax
    imprimir res, 1

    suma 1, 1, 2
    add eax, '0'
    mov [res], eax
    imprimir res, 1

    mov eax, 1
    mov ebx, 0
    int 0x80