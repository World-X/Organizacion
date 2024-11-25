section .data
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

section .bss
    input resb 1024
    buffer resb 4
    space_count resw 1
    comma_count resw 1
    newline_count resw 1
    word_count resw 1
    char_count resw 1
    ctrl_buffer resb 1

%macro read_string 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

%macro print_string 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .text
    global _start

_start:
    mov word [space_count], 0
    mov word [comma_count], 0
    mov word [newline_count], 0
    mov word [word_count], 0
    mov word [char_count], 0
    read_string input, 1024
    mov esi, input

count_chars:
    mov al, byte [esi]
    cmp al, 0
    je end_of_count
    cmp al, 0x0A
    je inc_newline
    inc word [char_count]
    cmp al, 0x20
    je inc_space
    cmp al, 0x2C
    je inc_comma

move_next_char:
    inc esi
    jmp count_chars

inc_space:
    inc word [space_count]
    inc word [word_count]
    inc esi
    jmp count_chars

inc_comma:
    inc word [comma_count]
    inc esi
    jmp count_chars

inc_newline:
    inc word [newline_count]
    inc word [word_count]
    inc esi
    jmp count_chars

print_number:
    mov ecx, buffer
    mov ebx, 10

print_number_next_digit:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz print_number_next_digit
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

end_of_count:
    inc word [word_count]
    
print_space_count:
    print_string space_msg, 10
    movzx eax, word [space_count]
    mov byte [ctrl_buffer], CTRL_SPACE
    jmp print_number

print_comma_count:
    print_string comma_msg, 7
    movzx eax, word [comma_count]
    mov byte [ctrl_buffer], CTRL_COMMA
    jmp print_number
    
print_newline_count:
    print_string newline_msg, 18
    movzx eax, word [newline_count]
    mov byte [ctrl_buffer], CTRL_NEWLINE
    jmp print_number
    
print_word_count:
    print_string words_msg, 10
    movzx eax, word [word_count]
    mov byte [ctrl_buffer], CTRL_WORD
    jmp print_number

print_char_count:
    print_string chars_msg, 12
    movzx eax, word [char_count]
    mov byte [ctrl_buffer], CTRL_CHAR
    jmp print_number

exit_program:
    mov eax, 1
    mov ebx, 0
    int 0x80