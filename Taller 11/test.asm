struc direccion
    calle resb 50
    numero resb 10
    colonia resb 30
endstruc

struct:
    istruc direccion
        at calle, db "Mi Calle", 0
        at numero, db "115", 0
        at colonia, db "Ensenada", 0
    iend

section .data
    direccion1 direccion
    direccion2 direccion

section .bss

section .text
    global _start

_start:
    ; Copy direccion1 to direccion2
    mov esi, direccion1
    mov edi, direccion2
    mov ecx, direccion_size
    rep movsb

    ; Exit program
    mov eax, 60         ; syscall: exit
    xor edi, edi        ; status: 0
    syscall