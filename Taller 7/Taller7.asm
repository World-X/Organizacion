section .data ; Sección de datos
    num1 db 5 ; Definición de una variable de 1 byte
    num2 db 11 ; Definición de una variable de 1 byte
    result db 0 ; Definición de una variable de 1 byte
    msg db 'Resultado: ', 0 ; Definición de una cadena de caracteres

section .bss ; Sección de datos no inicializados
    buffer resb 4 ; Reserva de 4 bytes para el buffer

section .text ; Sección de código
    global _start ; Punto de entrada del programa

_start: ; Inicio del programa
    mov al, [num1] ; Mover el valor de la variable num1 al registro AL
    add al, [num2] ; Sumar el valor de la variable num2 al registro AL
    mov [result], al ; Almacenar el resultado en la variable result
    ; Convertir el resultado a ASCII
    movzx eax, byte [result] ; Cargar el valor de result en el registro EAX
    add eax, 48 ; Convertir el valor numérico en su correspondiente ASCII ('0' = 48)
    mov [buffer], al ; Almacenar el carácter ASCII en el buffer
    mov eax, 4 ; Llamada al sistema para imprimir el mensaje
    mov ebx, 1 ; Descriptor de archivo (stdout)
    mov ecx, msg ; Dirección de memoria de la cadena de caracteres
    mov edx, 11 ; Longitud de la cadena de caracteres
    int 0x80 ; Llamada al sistema

    mov eax, 4 ; Llamada al sistema para imprimir el resultado
    mov ebx, 1 ; Descriptor de archivo (stdout)
    mov ecx, buffer ; Dirección de memoria del buffer
    mov edx, 1 ; Longitud del buffer
    int 0x80 ; Llamada al sistema

    mov eax, 1 ; Llamada al sistema para salir del programa
    xor ebx, ebx ; Código de salida
    int 0x80 ; Llamada al sistema