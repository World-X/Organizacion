section .data ; Sección de datos inicializados
    num1 db 5 ; Definición de un número de 1 byte
    num2 db 11 ; Definición de otro número de 1 byte
    result db 0 ; Definición del resultado de 1 byte
    message db "Resultado: ", 0 ; Definición de una cadena de caracteres

section .bss ; Sección de datos no inicializados
    buffer resb 4 ; Reserva de 4 bytes para el buffer  

section .text ; Sección de código
    global _start ; Punto de entrada del programa

%macro PRINT_STRING 1 ; Macro para imprimir una cadena de caracteres
    mov eax, 4 ; Llamada al sistema para imprimir un mensaje
    mov ebx, 1 ; Descriptor de archivo (stdout)
    mov ecx, %1 ; Dirección de memoria de la cadena de caracteres
    mov edx, 13 ; Longitud de la cadena de caracteres
    int 0x80 ; Llamada al sistema
%endmacro

%macro PRINT_NUMBER 1 ; Macro para imprimir un número
    mov eax, %1 ; Mover el número al registro EAX
    add eax, '0' ; Convertir el número en su correspondiente carácter ASCII
    mov [buffer], eax ; Almacenar el carácter en el buffer
    mov eax, 4 ; Llamada al sistema para imprimir un mensaje
    mov ebx, 1 ; Descriptor de archivo (stdout)
    mov ecx, buffer ; Dirección de memoria del buffer
    mov edx, 1 ; Longitud del buffer
    int 0x80 ; Llamada al sistema
%endmacro

_start: ; Inicio del programa
    mov al, [num1] ; Mover el valor de num1 al registro AL
    add al, [num2] ; Sumar el valor de num2 al registro AL
    mov [result], al ; Almacenar el resultado en la variable result

    PRINT_STRING message ; Imprimir el mensaje "Resultado: "
    PRINT_NUMBER [result] ; Imprimir el resultado

    ; Salir del programa
    mov eax, 1 ; Llamada al sistema para salir
    mov ebx, 0 ; Código de salida
    int 0x80 ; Llamada al sistema