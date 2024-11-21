MOV AX, [3423h] ; Lo que hace este comando es mover el valor de la dirección de memoria 3423h al registro AX
MOV AX, [BX] ; Mueve el valor de la dirección de memoria que está en BX al registro AX
MOV AX, BX ; Mueve el valor de BX al registro AX
MOV AX, 324 ; Mueve el valor 324 al registro AX
MOV AX, [BX + SI + 21] ; Mueve el valor de la dirección de memoria que está en BX + SI + 21 al registro AX
MOV AX, [BX + 15] ; Mueve el valor de la dirección de memoria que está en BX + 15 al registro AX
MOV AX, [SI - 14] relativo a registro ; Mueve el valor de la dirección de memoria que está en SI - 14 al registro AX
MOV AX, [BX + SI] ; Mueve el valor de la dirección de memoria que está en BX + SI al registro AX
