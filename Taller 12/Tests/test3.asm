; Read string from user, count spaces and newlines, and print the count, then print the string

%macro read_string 2
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, %1         ; buffer to store input
    mov edx, %2         ; max number of bytes to read
    int 0x80            ; call kernel
%endmacro

%macro print_string 2
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, %1         ; buffer to print
    mov edx, %2         ; length of buffer
    int 0x80            ; call kernel
%endmacro

%macro print_number 2
    movzx eax, byte [%1]
    add eax, 48
    mov [buffer], eax

    ; Print the number
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, buffer     ; buffer to print
    mov edx, %2         ; length of buffer
    int 0x80            ; call kernel
%endmacro

section .data
    newline db 0x0A
    space_msg db "Espacios: ", 0x0
    newline_msg db "Saltos de línea: ", 0x0
    words_msg db "Palabras: ", 0x0
    chars_msg db "Caracteres: ", 0x0

section .bss
    input resb 100
    buffer resb 4
    space_count resb 4
    newline_count resb 4
    word_count resb 4
    char_count resb 4

section .text
    global _start

_start:
    ; Initialize counters
    mov byte [space_count], 0
    mov byte [newline_count], 0
    mov byte [word_count], 0
    mov byte [char_count], 0

    ; Read input from the user
    read_string input, 100

    ; Count spaces, tabs, and newlines
    mov esi, input      ; pointer to input buffer

count_chars:
    mov al, byte [esi]  ; load next byte

    cmp al, 0           ; end of input?
    je end_of_program   ; if yes, we're done

    cmp al, 0x0A        ; is it a newline?
    je inc_newline      ; if yes, handle newline

    inc byte [char_count] ; increment character count

    cmp al, 0x20        ; is it a space?
    je inc_space        ; if yes, handle space

    inc esi             ; move to next character
    jmp count_chars     ; repeat

inc_space:
    inc byte [space_count] ; increment space count
    inc byte [word_count]  ; increment word count
    inc esi             ; move to next character
    jmp count_chars     ; repeat

inc_newline:
    inc byte [newline_count] ; increment newline count
    inc byte [word_count]    ; increment word count
    inc esi             ; move to next character
    jmp count_chars     ; repeat

end_of_program:
    inc byte [word_count]    ; increment word count
    ; Print input
    print_string input, 100
    print_string newline, 1
    ; Print the space count
    print_string space_msg, 10
    print_number space_count, 1
    print_string newline, 1
    ; Print the newline count
    print_string newline_msg, 18
    print_number newline_count, 1
    print_string newline, 1
    ; Print the total word count
    print_string words_msg, 10
    print_number word_count, 1
    print_string newline, 1
    ; Print the total character count
    print_string chars_msg, 12
    print_number char_count, 1
    print_string newline, 1

    ; Exit the program
    mov eax, 1          ; sys_exit
    mov ebx, 0          ; exit code
    int 0x80            ; call kernel