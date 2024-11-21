section .data ; Sección de datos
    msg db 'Resultado: ', 0 ; Mensaje a imprimir
    newline db 0xA ; Nueva línea

section .bss ; Sección de datos no inicializados
    res resb 4 ; Espacio para el resultado

section .text ; Sección de código
    global _start ; Punto de entrada del programa

_start: ; Inicio del programa
    ; Instrucciones aritméticas
    mov eax, 10 ; Cargar el valor 10 en EAX
    mov ebx, 5 ; Cargar el valor 5 en EBX
    add eax, ebx ; Sumar EAX y EBX (10 + 5 = 15)

    ; Instrucción lógica (AND)
    ; Ejemplo: si eax = 15 (0b1111), el resultado será 0b1111 & 0b1111 = 0b1111 (15 en decimal), o sea, no cambia
    and eax, 0xF ; Realizar la operación AND con 0xF (para obtener el último dígito en hexadecimal)

    ; Instrucciones de manipulación de bits
    ; Ejemplo: si eax = 15 (0b1111), el resultado será 30 (0b11110)
    shl eax, 1 ; Desplazar el bit a la izquierda

    ; Guardar el resultado en la sección .bss
    ; Se usa [res] en lugar de res para acceder al contenido de la dirección de memoria, en lugar de la dirección en sí
    mov [res], eax ; Almacenar el resultado en 'res'

    ; Llamar a la rutina para imprimir el resultado
    mov eax, 4        ; Syscall para escribir
    mov ebx, 1        ; Usar la salida estándar (pantalla)
    mov ecx, msg      ; Direccion del mensaje a imprimir
    mov edx, 11       ; Longitud del mensaje
    int 0x80          ; Interrupción para imprimir el mensaje

    ; Imprimir el número (resultado almacenado en 'res')
    mov eax, [res]    ; Cargar el resultado en EAX
    ; Ejemplo: si eax = 30, y '0' en ASCII es 48, el resultado será 78 (ASCII de 'N')
    add eax, '0'      ; Convertir el número en carácter (ASCII)
    mov [res], eax    ; Almacenar el carácter convertido
    mov eax, 4        ; Syscall para escribir
    mov ebx, 1        ; Usar la salida estándar
    mov ecx, res      ; Dirección del resultado
    mov edx, 1        ; Longitud de 1 carácter
    int 0x80          ; Interrupción para imprimir el número

    ; Imprimir nueva línea
    mov eax, 4        ; Syscall para escribir
    mov ebx, 1        ; Usar la salida estándar
    mov ecx, newline  ; Dirección de la nueva línea
    mov edx, 1        ; Longitud de 1 carácter
    int 0x80          ; Interrupción para imprimir nueva línea

    ; Terminar el programa
    mov eax, 1        ; Syscall para salir
    xor ebx, ebx      ; Código de salida 0
    int 0x80          ; Interrupción para terminar el programa