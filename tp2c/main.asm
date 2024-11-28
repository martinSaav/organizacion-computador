; -------------------------------------------------------------------------------
; Trabajo Práctico “El Asalto”
; Materia: 95.57 & TB023 - Organización del Computador
; -------------------------------------------------------------------------------
; El Asalto arraigó con fuerza en Europa, sobre todo en Francia, Alemania e Inglaterra,
; durante el siglo XIX. El tablero comprende de una zona que semeja una fortaleza 
; defendida por dos oficiales, que deberán abortar el asalto de un escuadrón de 
; veinticuatro soldados.
;
; MATERIAL
; - Un tablero con treinta y tres hendiduras en forma de cruz, que incluya una zona 
;   delimitada como fortaleza en una de las aspas.
; - Dos canicas como oficiales y otras veinticuatro como soldados, distinguiéndose 
;   claramente el rango expuesto, ya sea mediante el tamaño o el color de las piezas.
;
;        | X | X | X |
;        | X | X | X |
;| X | X | X | X | X | X | X | 
;| X | X | X | X | X | X | X |
;| X | X |   |   |   | X | X |
;        |   |   | O |
;        | O |   |   |
;
; OBJETIVO
; Dos oficiales con libertad de acción deberán defender la fortaleza del asalto 
; de veinticuatro soldados con movimientos restringidos.
;
; DISPOSICIÓN INICIAL
; Las dos canicas que están dentro de la fortaleza (las 9 posiciones en color gris)
; deben defenderla de las veinticuatro del exterior.
;
; DESARROLLO DEL JUEGO
; - Los soldados son los primeros en moverse.
; - Cada oficial puede desplazarse en cualquier dirección, mientras que los soldados 
;   sólo pueden avanzar en dirección a la fortaleza, tanto en línea recta como en 
;   diagonal, nunca hacia los costados o retroceder (excepto en las posiciones 
;   marcadas en rojo, qué solo admiten movimiento hacia los costados).
; - Los oficiales pueden capturar a los soldados saltando por encima de ellos a un 
;   hoyo vacío inmediato. Cuando un soldado es capturado, es retirado del tablero.
; - Los oficiales no pueden desentenderse de su obligación de capturar a sus enemigos. 
;   Por ello, si un oficial omite una captura, también es retirado.
; - Los soldados culminan el asalto cuando han ocupado todos los puntos del interior 
;   de la fortaleza o bien cuando los oficiales se encuentran rodeados, sin posibilidad 
;   de maniobrar.
; - Los oficiales abortarán el asalto cuando hayan diezmado de tal modo al escuadrón 
;   de soldados, que éstos no pueden ocupar ya la totalidad de la fortaleza.
;
; CONSIGNA
; Desarrollar en un grupo de 4 personas un programa en assembler Intel 80x86 que 
; implemente el juego de “El Asalto” cumpliendo los siguientes requisitos:
;
; Requerimiento 1:
; - Implementar una partida del juego para 2 jugadores. (Deberá visualizarse claramente 
;   el estado del tablero actualizado luego de cada movimiento).
; - Permitir interrumpir la partida en cualquier momento del juego. (Salir del juego).
; - Identificar automáticamente cuando el juego llegó a su fin indicando el motivo.
%macro mPuts 1  
    mov     rdi,%1
    sub     rsp,8
    call    puts
    add     rsp,8
%endmacro

%macro mGets 1
    mov     rdi,%1
    sub     rsp,8
    call    gets  
    add     rsp,8
%endmacro

%macro mSscanf 3
    mov     rdi,%1
    mov     rsi,%2
    mov     rdx,%3
    sub     rsp,8
    call    sscanf
    add     rsp,8
%endmacro

%macro mPrintf 2
    mov     rdi,%1
    mov     rsi,%2
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

%macro mClear 0
    mov     rdi,cmdClear
    sub     rsp,8
    call    system
    add     rsp,8
%endmacro

%macro mGuardarValorRegistrosGenerales 0
    sub rsp, 8
    call guardarValorRegistrosGenerales
    add rsp, 8
%endmacro

%macro mRestaurarValorRegistrosGenerales 0
    sub rsp, 8
    call restaurarValorRegistrosGenerales
    add rsp, 8
%endmacro


global main

extern puts
extern gets
extern printf
extern sscanf
extern system

section .data
    oficial                       db "O",0
    soldado                     db "X",0
    vacio                       db " ",0
    mapa                        db "    1   2   3   4   5   6   7  ",10 ;32
                                db "1         | X | X | X |        ",10 ;64
                                db "2         | X | X | X |        ",10 ;96
                                db "3 | X | X | X | X | X | X | X |",10 ;128
                                db "4 | X | X | X | X | X | X | X |",10 ;160
                                db "5 | X | X |   |   |   | X | X |",10 ;192
                                db "6         |   |   | O |        ",10 ;224
                                db "7         | O |   |   |        ",10,0 ;256
    cantidadPosiciones          dq 33

    posicionMapaByteStr         db "   ",0
    posicionTableroStr          db "  ",0

    ;estructura del tipo: posicion con respecto al mapa de bytes, posicion con respecto al tablero
    traduccionPosiciones        db                     "04413",0,"04814",0,"05215",0
                                db                     "07623",0,"08024",0,"08425",0
                                db "10031",0,"10432",0,"10833",0,"11234",0,"11635",0,"12036",0,"12437",0
                                db "13241",0,"13642",0,"14043",0,"14444",0,"14845",0,"15246",0,"15647",0
                                db "16451",0,"16852",0,"17253",0,"17654",0,"18055",0,"18456",0,"18857",0
                                db                     "20463",0,"20864",0,"21265",0
                                db                     "23673",0,"24074",0,"24475",0,0
    cmdClear                     db "clear",0
    soldadosRestantesParaGanar       dq 16


    msgTurnoOficial                 db "Turno de los oficiales",10
                                  db "Los movimientos de los oficiales son: norte(N), sur(S), este(E), oeste(O), noreste(NE), noroeste(NO), sureste(SE), suroeste(SO)",10
                                    db "Seleccione el oficial a mover: ",0
    tamMsgTurnoOficial              dq 182
    movimientosOficial              db "N",0,"S",0,"E",0,"O",0,"NE",0,"NO",0,"SE",0,"SO",0,0
    movimientosOficialDisponibles   db " ",0," ",0," ",0," ",0,"  ",0,"  ",0,"  ",0,"  ",0,0
    tamMovimientosOficial           dq 21
    posMovimientosOficialDisponibles dq 0, 2, 4, 6, 8, 11, 14, 17
    tamMovimientosOficialDisponibles dq 1, 1, 1, 1, 2, 2, 2, 2
    movimientosOficialValores        dq -32, 32, 4, -4, -28, -36, 36, 28
    cantidadMovimientosOficial       dq 8


    msgTurnoSoldados                  db "Turno de los soldados",10
                                  db "Los movimientos de los soldados son: sur(S), sureste(SE), suroeste(SO) y en las posiciones 51, 52, 56, 57 solo admite este(E) y oeste(O)",10
                                  db "Seleccione el soldado a mover: ",0
    tamMsgTurnoSoldados               dq 190

    movimientosSoldados               db "S",0,"SE",0,"SO",0,0
    movimientosSoldadosDisponibles    db " ",0,"  ",0,"  ",0,0
    tamMovimientosSoldados            dq 9
    posMovimientosSoldadosDisponibles dq 0, 2, 5
    tamMovimientosSoldadosDisponibles dq 1, 2, 2
    movimientosSoldadosValores        dq 32, 36, 28
    cantidadMovimientosSoldados       dq 3

    movimientosSoldadosEspeciales     db "E",0,"O",0,0
    movimientosSoldadosEspecialesDisponibles    db " ",0," ",0,0
    tamMovimientosSoldadosEspeciales            dq 5
    posMovimientosSoldadosEspecialesDisponibles dq 0, 2
    tamMovimientosSoldadosEspecialesDisponibles dq 1, 1
    movimientosSoldadosEspecialesValores        dq 4, -4
    cantidadMovimientosSoldadosEspeciales       dq 2

    posicionesEspecialesDisponibles dq 164, 168, 184, 188
    cantidadPosicionesEspeciales dq 4

    msgMovimientosDisponibles     db "Los movimientos disponibles son: "
    movimientosDisponiblesPrint   db "                   ",10
    msgIngresoMovimiento          db "Ingrese el movimiento a realizar: ",0

    indiceMovimiento             dq 0
    msgMovimientoNoValido        db "Movimiento no valido",10,0
    tamMsgMovimientoNoValido     dq 22
    msgSinMovimientos            db "No hay mas movimientos disponibles",10,0
    tamMsgSinMovimientos         dq 36
    msgNoFichaEnPosicion           db "No hay una ficha en la posicion ingresada",10,0

    turnoOficial                   dq 1
    turnoSoldados                    dq 0
    siguienteTurno               dq 0
    numFormato                   db "%lld",0


section .bss
    movimientoIngresado resb 256
    tamMovimientoIngresado resq 1
    msgTurno resb 512
    movimientos resb 256
    movimientosDisponibles resb 256
    posMovimientosDisponibles resq 8
    tamMovimientosDisponibles resq 8
    movimientosValores resq 8
    cantidadMovimientos resq 1
    turnoActual resq 1
    posicionFichaIngresadaStr resq 1
    posicionMapaByte resq 1
    posicionActualMapaByte resq 1
    iterador resq 1
    posicion resq 1
    ubicacionFicha resq 1
    fichaActual resb 1
    direccionFicha resq 1
    movimientoActual resq 1
    fueraDeMapa resq 1
    posiblesFichasACapturar resq 1
    fichasACapturar resq 1
    hayFichaParaCapturar resq 1
    raxAux resq 1
    rbxAux resq 1
    rcxAux resq 1
    rdxAux resq 1
    rsiAux resq 1
    rdiAux resq 1
    r8Aux resq 1
    r9Aux resq 1
    r10Aux resq 1
    r11Aux resq 1
    r12Aux resq 1
    r13Aux resq 1
    r14Aux resq 1
    r15Aux resq 1
section .text
    global main
main:
    xor rax, rax
    lea rdi, [movimientosDisponiblesPrint]
    mov rcx, 19
    mov al, ''  
    rep stosb
    xor rax, rax
    lea rdi, [msgTurno]
    mov rcx, 512
    mov al, ''
    rep stosb   
    mov rax, [turnoOficial]
    cmp rax, [siguienteTurno]
    je esTurnoOficial
    jmp esTurnoSoldados

esTurnoOficial:
    mov rax, [turnoOficial]
    mov [turnoActual], rax

    mov rcx, [tamMsgTurnoOficial]
    lea rsi, [msgTurnoOficial]
    lea rdi, [msgTurno]
    rep movsb

    mov rcx, [tamMovimientosOficial]
    lea rsi, [movimientosOficial]
    lea rdi, [movimientos]
    rep movsb

    mov rcx, [tamMovimientosOficial]
    lea rsi, [movimientosOficialDisponibles]
    lea rdi, [movimientosDisponibles]
    rep movsb

    mov rcx, [cantidadMovimientosOficial]
    lea rsi, [posMovimientosOficialDisponibles]
    lea rdi, [posMovimientosDisponibles]
    rep movsq

    mov rcx, [cantidadMovimientosOficial]
    lea rsi, [tamMovimientosOficialDisponibles]
    lea rdi, [tamMovimientosDisponibles]
    rep movsq

    mov rcx, [cantidadMovimientosOficial]
    lea rsi, [movimientosOficialValores]
    lea rdi, [movimientosValores]
    rep movsq

    mov rax, [cantidadMovimientosOficial]
    mov [cantidadMovimientos], rax

    mov rax, [turnoSoldados]
    mov [siguienteTurno], rax


    xor rax, rax
    mov rax, [oficial]
    mov [fichaActual], rax

    jmp comienzoTurno

esTurnoSoldados:
    mov rax, [turnoSoldados]
    mov [turnoActual], rax

    mov rcx, [tamMsgTurnoSoldados]
    lea rsi, [msgTurnoSoldados]
    lea rdi, [msgTurno]
    rep movsb

    mov rcx, [tamMovimientosSoldados]
    lea rsi, [movimientosSoldados]
    lea rdi, [movimientos]
    rep movsb

    mov rcx, [tamMovimientosSoldados]
    lea rsi, [movimientosSoldadosDisponibles]
    lea rdi, [movimientosDisponibles]
    rep movsb

    mov rcx, [cantidadMovimientosSoldados]
    lea rsi, [posMovimientosSoldadosDisponibles]
    lea rdi, [posMovimientosDisponibles]
    rep movsq

    mov rcx, [cantidadMovimientosSoldados]
    lea rsi, [tamMovimientosSoldadosDisponibles]
    lea rdi, [tamMovimientosDisponibles]
    rep movsq

    mov rcx, [cantidadMovimientosSoldados]
    lea rsi, [movimientosSoldadosValores]
    lea rdi, [movimientosValores]
    rep movsq

    mov rax, [cantidadMovimientosSoldados]
    mov [cantidadMovimientos], rax

    mov rax, [turnoOficial]
    mov [siguienteTurno], rax

    xor rax, rax
    mov rax, [soldado]
    mov [fichaActual], rax

    jmp comienzoTurno

esTurnoSoldadoEspecial:
    mov rcx, [tamMovimientosSoldadosEspeciales]
    lea rsi, [movimientosSoldadosEspeciales]
    lea rdi, [movimientos]
    rep movsb

    mov rcx, [tamMovimientosSoldadosEspeciales]
    lea rsi, [movimientosSoldadosEspecialesDisponibles]
    lea rdi, [movimientosDisponibles]
    rep movsb

    mov rcx, [cantidadMovimientosSoldadosEspeciales]
    lea rsi, [posMovimientosSoldadosEspecialesDisponibles]
    lea rdi, [posMovimientosDisponibles]
    rep movsq

    mov rcx, [cantidadMovimientosSoldadosEspeciales]
    lea rsi, [tamMovimientosSoldadosEspecialesDisponibles]
    lea rdi, [tamMovimientosDisponibles]
    rep movsq

    mov rcx, [cantidadMovimientosSoldadosEspeciales]
    lea rsi, [movimientosSoldadosEspecialesValores]
    lea rdi, [movimientosValores]
    rep movsq

    mov rax, [cantidadMovimientosSoldadosEspeciales]
    mov [cantidadMovimientos], rax

    jmp continuarTurno

seleccionarFicha:
    mov rax, [turnoActual]
    cmp rax, [turnoOficial]

    mGets posicionFichaIngresadaStr
    
continuarSeleccionandoFicha:
    mov r11, [cantidadPosiciones] ; cantidad de posiciones en el tablero
    mov rax, 0
esPosicionValida:
    cmp r11, 0
    je posicionNoValida

    mov rcx, 2
    lea rsi, [traduccionPosiciones]
    add rsi, rax  ; "04413 0 04814"
                  ;   1234 5 6      6 bytes son los que necesito para saltar a la siguiente posicion

    add rsi, 3    ; "04413"
                  ;   123   3 bytes son los que necesito para leer la posicion del tablero con respecto al mapa 
    lea rdi, [posicionTableroStr]
    rep movsb

    mov rcx, 2
    lea rsi, [posicionTableroStr]
    lea rdi, [posicionFichaIngresadaStr]
    rep cmpsb
    
    je hayFichaEnPosicion
    add rax, 6 ; añado 6 para saltar a la siguiente posicion
    dec r11
    jmp esPosicionValida

hayFichaEnPosicion:
    mov rcx, 3
    lea rsi, [traduccionPosiciones] 
    add rsi, rax
    lea rdi, [posicionMapaByteStr]
    rep movsb

    mSscanf posicionMapaByteStr, numFormato, posicionMapaByte

    lea r8, [mapa]
    add r8, [posicionMapaByte]
    xor rax, rax
    mov al, [fichaActual]
    cmp byte[r8], al
    je posicionValida
    jmp posicionNoValida

posicionNoValida:
    mPuts msgNoFichaEnPosicion
    jmp seleccionarFicha

posicionValida:
    mov rax, [posicionMapaByte]
    mov [ubicacionFicha], rax
    mov rax, [turnoActual]
    cmp rax, [turnoOficial]
    je continuarTurno
    mov rcx, [cantidadPosicionesEspeciales]
    mov rsi, 0
esPosicionEspecial:
    mov rax, [ubicacionFicha]
    cmp rax, [posicionesEspecialesDisponibles + rsi*8]
    je esTurnoSoldadoEspecial
    inc rsi
    loop esPosicionEspecial

    jmp continuarTurno

comienzoTurno:
    mClear
    mPuts  mapa
    mPuts  msgTurno

    jmp seleccionarFicha
continuarTurno:
    mov rcx, [cantidadMovimientos]
    mov rax, 0
    mov rsi, 0
    mov [indiceMovimiento], rsi

    lea r8, [mapa]
    add r8, [ubicacionFicha]
    mov [direccionFicha], r8
    ; guardar el valor de r8 en una variable direccionFicha


verMovimientosDisponibles:
    mov r8, [direccionFicha]
    mov rbx, [movimientosValores + rsi*8]
    mov [movimientoActual], rbx

    mov [posicionActualMapaByte], r8
    add [posicionActualMapaByte], rbx
    lea rax, [mapa]
    sub [posicionActualMapaByte], rax
    
    sub rsp, 8
    call esMovimientoDisponible
    add rsp, 8

    inc rsi
    mov [indiceMovimiento], rsi
    loop verMovimientosDisponibles

    jmp copiarMovimientosDisponibles
continuar:
    mPuts msgMovimientosDisponibles
    mGets movimientoIngresado
    jmp verficarEsMovimientoValido

esMovimientoDisponible:
    mGuardarValorRegistrosGenerales

    sub rsp, 8
    call estaEnElMapa 
    add rsp, 8
    mov rax, [fueraDeMapa]
    cmp rax, 1
    je volverEsMovimientoDisponible

    sub rsp, 8
    call verificarSiHayFichaParaCapturar
    add rsp, 8
    mov rax, [hayFichaParaCapturar]
    cmp rax, 1
    je continuarEsMovimientoDisponible

    mov r8, [direccionFicha]
    mov rbx, [movimientoActual]

    mov rcx, 1
    lea rsi, [r8 + rbx] 
    lea rdi, [vacio]
    repe cmpsb

continuarEsMovimientoDisponible:
    mov rsi, [indiceMovimiento]
    je copiarMovimientoDisponible
volverEsMovimientoDisponible:
    mRestaurarValorRegistrosGenerales
    ret

copiarMovimientoDisponible:
    mov rcx, [tamMovimientosDisponibles + rsi*8]
    mov rax, [posMovimientosDisponibles + rsi*8]
    lea rsi, [movimientos + rax]
    lea rdi, [movimientosDisponibles + rax]
    rep movsb
    jmp volverEsMovimientoDisponible

estaEnElMapa:
    mov rax, [cantidadPosiciones] ; cantidad de posiciones en el tablero = 33
    mov [iterador], rax
    mov rax, 0
    mov [posicion], rax
    mov rax, 0
    mov [fueraDeMapa], rax
estaEnElMapaLoop:
    mov rax, [iterador]
    cmp rax, 0
    je noEstaEnElMapaFin

    mov rcx, 3
    lea rsi, [traduccionPosiciones]
    mov rax, [posicion]
    add rsi, rax  ; "04413 0 04814"
                  ;   1234 5 6      6 bytes son los que necesito para saltar a la siguiente posicion
    lea rdi, [posicionMapaByteStr]

    rep movsb
    
    mSscanf posicionMapaByteStr, numFormato, posicionMapaByte

    mov rax, [posicionMapaByte]
    cmp rax, [posicionActualMapaByte]
    je estaEnElMapaFin

    mov rax, [posicion]
    add rax, 6 ; añado 6 para saltar a la siguiente posicion
    mov [posicion], rax

    mov rax, [iterador]
    dec rax
    mov [iterador], rax
    jmp estaEnElMapaLoop

estaEnElMapaFin:
    ret

noEstaEnElMapaFin:
    mov rax, 1
    mov [fueraDeMapa], rax
    ret

verificarSiHayFichaParaCapturar:
    mov rax, 0
    mov [hayFichaParaCapturar], rax
    
    mov rax, [turnoActual]
    cmp rax, [turnoSoldados]
    je finVerificarSiHayFichaParaCapturar

    mov r8, [direccionFicha]
    mov rbx, [movimientoActual]

    mov rcx, 1
    lea rsi, [r8 + rbx] 
    lea rdi, [soldado]
    repe cmpsb
    jne finVerificarSiHayFichaParaCapturar

    mov rbx, [movimientoActual]
    mov rax, [posicionActualMapaByte]
    add rax, rbx
    mov [posicionActualMapaByte], rax

    sub rsp, 8
    call estaEnElMapa
    add rsp, 8

    mov rax, [fueraDeMapa]
    cmp rax, 1
    je finVerificarSiHayFichaParaCapturar

    mov r8, [direccionFicha]
    mov rbx, [movimientoActual]
    imul rbx, rbx, 2

    mov rcx, 1
    lea rsi, [r8 + rbx] 
    lea rdi, [vacio]
    repe cmpsb
    jne finVerificarSiHayFichaParaCapturar

    mov rax, 1
    mov [hayFichaParaCapturar], rax
    ret


finVerificarSiHayFichaParaCapturar:
    ret

copiarMovimientosDisponibles:
    lea rsi, [movimientosDisponibles]  
    lea rdi, [movimientosDisponiblesPrint]      
      
copiar:
    mov al, [rsi]
    cmp al, 0
    je agregarEspacio
    mov [rdi], al                     
    inc rdi
    inc rsi
    jmp copiar

agregarEspacio:
    inc rsi
    cmp byte[rsi], 0       
    je  continuar
    mov byte[rdi], ' '
    inc rdi
    jmp copiar

verficarEsMovimientoValido:
    mov rsi, 0
    jmp tamMovIngresado

verificarTamMovimientoIngresado:
    mov rax, [tamMovimientoIngresado]
    cmp rax, 2
    jg movimientoNoValido
    mov rsi, 0

verificarIncluidoEnMovimientosDisponibles:
    mov r9, rsi
    mov rcx, [tamMovimientoIngresado]
    mov rax, [posMovimientosDisponibles + rsi*8]
    lea rsi, [movimientoIngresado]
    lea rdi, [movimientosDisponibles + rax]
    repe cmpsb
    mov rsi, r9
    je moverFicha
    inc rsi
    cmp rsi, [cantidadMovimientos]
    je movimientoNoValido
    jmp verificarIncluidoEnMovimientosDisponibles 
    
tamMovIngresado:
    cmp byte[movimientoIngresado+rsi],0 
    je finalString
    inc rsi
    jmp tamMovIngresado

finalString:
    mov [tamMovimientoIngresado],rsi
    jmp  verificarTamMovimientoIngresado

movimientoNoValido:
    mPuts msgMovimientoNoValido
    jmp continuar

moverFicha:
    lea r8, [mapa]
    add r8, [ubicacionFicha]
    mov byte[r8], ' '

    mov rax, [turnoActual]
    cmp rax, [turnoSoldados]
    je continuarMoverFicha
    mov rax, [movimientosValores + rsi*8]
    add r8, rax
    xor rax, rax
    mov al, [soldado]
    cmp byte[r8], al
    je capturarFicha
    mov rax, [movimientosValores + rsi*8]
    sub r8, rax 
    jmp continuarMoverFicha
capturarFicha:
    mov byte[r8], ' '
    mov rax, [soldadosRestantesParaGanar]
    dec rax
continuarMoverFicha:
    mov rax, [movimientosValores + rsi*8]
    add r8, rax
    xor rax, rax
    mov al, [fichaActual]
    mov byte[r8], al

    jmp main


; Funciones auxiliares en desuso
    
guardarValorRegistrosGenerales:
    mov [raxAux], rax
    mov [rbxAux], rbx
    mov [rcxAux], rcx
    mov [rdxAux], rdx
    mov [rsiAux], rsi
    mov [rdiAux], rdi
    mov [r8Aux], r8
    mov [r9Aux], r9
    mov [r10Aux], r10
    mov [r11Aux], r11
    mov [r12Aux], r12
    mov [r13Aux], r13
    mov [r14Aux], r14
    mov [r15Aux], r15
    ret

restaurarValorRegistrosGenerales:
    mov rax, [raxAux]
    mov rbx, [rbxAux]
    mov rcx, [rcxAux]
    mov rdx, [rdxAux]
    mov rsi, [rsiAux]
    mov rdi, [rdiAux]
    mov r8, [r8Aux]
    mov r9, [r9Aux]
    mov r10, [r10Aux]
    mov r11, [r11Aux]
    mov r12, [r12Aux]
    mov r13, [r13Aux]
    mov r14, [r14Aux]
    mov r15, [r15Aux]
    ret

fin:


    ret




