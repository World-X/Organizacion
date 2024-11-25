section .data ; Variables inicializadas
    newline db 0x0A
    space_msg db "Espacios: ", 0x0
    comma_msg db "Comas: ", 0x0
    newline_msg db "Saltos de línea: ", 0x0
    words_msg db "Palabras: ", 0x0
    chars_msg db "Caracteres: ", 0x0
    CTRL_SPACE equ 0
    CTRL_COMMA equ 1
    CTRL_NEWLINE equ 2
    CTRL_WORD equ 3
    CTRL_CHAR equ 4

section .bss ; Variables no inicializadas
    input resb 1024
    buffer resb 4
    space_count resw 1
    comma_count resw 1
    newline_count resw 1
    word_count resw 1
    char_count resw 1
    ctrl_buffer resb 1

%macro read_string 2 ; Macro para leer una cadena de texto
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

%macro print_string 2 ; Macro para imprimir una cadena de texto
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .text ; Sección de código
    global _start

_start: ; Punto de entrada del programa
    ;=> Inicialización de contadores
    mov word [space_count], 0
    mov word [comma_count], 0
    mov word [newline_count], 0
    mov word [word_count], 0
    mov word [char_count], 0
    ;=> Leer la cadena de texto
    read_string input, 1024
    ;=> Mover el puntero al inicio de la cadena
    mov esi, input

count_chars: ; Contar los caracteres de la cadena
    ;=> Cargar el siguiente caracter
    mov al, byte [esi]
    ;=> Verificar si es el final de la cadena
    cmp al, 0
    je end_of_count
    ;=> Verificar si es un salto de línea
    cmp al, 0x0A
    je inc_newline
    ;=> Incrementar el contador de caracteres
    inc word [char_count]
    ;=> Verificar si es un espacio
    cmp al, 0x20
    je inc_space
    ;=> Verificar si es una coma
    cmp al, 0x2C
    je inc_comma

move_next_char: ; Mover al siguiente caracter
    ;=> Mover al siguiente caracter
    inc esi
    jmp count_chars

inc_space: ; Incrementar el contador de espacios
    ;=> Incrementar el contador de espacios
    inc word [space_count]
    ;=> Incrementar el contador de palabras
    inc word [word_count]
    ;=> Mover al siguiente caracter
    inc esi
    jmp count_chars

inc_comma: ; Incrementar el contador de comas
    ;=> Incrementar el contador de comas
    inc word [comma_count]
    ;=> Mover al siguiente caracter
    inc esi
    jmp count_chars

inc_newline: ; Incrementar el contador de saltos de línea
    ;=> Incrementar el contador de saltos de línea
    inc word [newline_count]
    ;=> Incrementar el contador de palabras
    inc word [word_count]
    ;=> Mover al siguiente caracter
    inc esi
    jmp count_chars

print_number: ; Imprimir un número
    ;=> Mover la dirección del buffer a ecx
    mov ecx, buffer
    ;=> Mover el valor 10 a ebx (base decimal)
    mov ebx, 10

print_number_next_digit: ; Imprimir el siguiente dígito
    ;=> Limpiar edx
    xor edx, edx
    ;=> Dividir eax por 10, el cociente se almacena en eax y el residuo en edx
    div ebx
    ;=> Almacenar el residuo en la pila
    add dl, '0'
    ;=> Decrementar ecx para apuntar a la posición anterior en el buffer
    dec ecx
    ;=> Almacenar el carácter ASCII en el buffer
    mov [ecx], dl
    ;=> Probar si el cociente es 0
    test eax, eax
    ;=> Si no es 0, repetir el proceso
    jnz print_number_next_digit
    ;=> Si es 0, imprimir el número
    print_string ecx, 4
    print_string newline, 1
    cmp byte [ctrl_buffer], CTRL_SPACE
    je print_comma_count
    cmp byte [ctrl_buffer], CTRL_COMMA
    je print_newline_count
    cmp byte [ctrl_buffer], CTRL_NEWLINE
    je print_word_count
    cmp byte [ctrl_buffer], CTRL_WORD
    je print_char_count
    cmp byte [ctrl_buffer], CTRL_CHAR
    je exit_program

end_of_count: ; Fin del conteo
    ;=> Incrementar el contador de palabras
    inc word [word_count]
    
print_space_count: ; Imprimir el contador de espacios
    print_string space_msg, 10
    ;=> Mover el valor de space_count a eax
    movzx eax, word [space_count]
    ;=> Mover el valor de CTRL_SPACE a ctrl_buffer
    mov byte [ctrl_buffer], CTRL_SPACE
    ;=> Llamar a print_number
    jmp print_number

print_comma_count: ; Imprimir el contador de comas
    print_string comma_msg, 7
    ;=> Mover el valor de comma_count a eax
    movzx eax, word [comma_count]
    ;=> Mover el valor de CTRL_COMMA a ctrl_buffer
    mov byte [ctrl_buffer], CTRL_COMMA
    ;=> Llamar a print_number
    jmp print_number
    
print_newline_count: ; Imprimir el contador de saltos de línea
    print_string newline_msg, 18
    ;=> Mover el valor de newline_count a eax
    movzx eax, word [newline_count]
    ;=> Mover el valor de CTRL_NEWLINE a ctrl_buffer
    mov byte [ctrl_buffer], CTRL_NEWLINE
    ;=> Llamar a print_number
    jmp print_number
    
print_word_count: ; Imprimir el contador de palabras
    print_string words_msg, 10
    ;=> Mover el valor de word_count a eax
    movzx eax, word [word_count]
    ;=> Mover el valor de CTRL_WORD a ctrl_buffer
    mov byte [ctrl_buffer], CTRL_WORD
    ;=> Llamar a print_number
    jmp print_number

print_char_count: ; Imprimir el contador de caracteres
    print_string chars_msg, 12
    ;=> Mover el valor de char_count a eax
    movzx eax, word [char_count]
    ;=> Mover el valor de CTRL_CHAR a ctrl_buffer
    mov byte [ctrl_buffer], CTRL_CHAR
    ;=> Llamar a print_number
    jmp print_number

exit_program: ; Salir del programa
    ;=> Mover el valor 1 a eax (sys_exit)
    mov eax, 1
    ;=> Mover el valor 0 a ebx (código de salida)
    mov ebx, 0
    ;=> Llamar al kernel
    int 0x80