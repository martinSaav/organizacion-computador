; Trabajo Práctico “El Zorro y las Ocas”
; Elementos
; El juego se desarrolla en un tablero con treinta y tres hendiduras, dispuestas en forma de
; cruz, tal y como se puede apreciar en la ilustración.
; Diecisiete piezas redondas, semejantes a las canicas, de un mismo color, que
; representarán a las ocas; y otra distinta, que será el zorro.
;        | O | O | O |
;        | O | O | O |
;| O | O | O | O | O | O | O | 
;| O |   |   |   |   |   | O |
;| O |   |   | X |   |   | O |
;        |   |   |   |
;        |   |   |   |
; Objetivo
; El jugador que se halla en posesión del zorro tiene como objetivo capturar un mínimo de
; doce ocas, mediante movimientos sucesivos muy parecidos a los que se realizan en el
; juego de damas. Su oponente deberá evitarlo.
; Uno de los participantes de este juego dispone de una ficha, el zorro, que debe procurar
; capturar las de su contendiente, las ocas.
; Desarrollo del juego
; Las partidas se disputan entre dos jugadores. Uno de ellos dispone de una sola pieza, el
; zorro, que puede moverse libremente por el tablero. El otro cuenta con diecisiete fichas, que
; son las ocas, y se encuentra limitado por unos movimientos muy restringidos.
;- Las ocas y el zorro se colocarán tal como se muestra en la ilustración.
;- El zorro es el que inicia la partida, pudiendo desplazarse en cualquier dirección: hacia
;  adelante, hacia atrás, en diagonal y a los costados (una casilla a la vez salvo que coma a
;  una oca).
;- Para comerse una oca, el zorro deberá saltar por encima de ella a una casilla vacía,
;  aunque no está obligado a hacerlo siempre que pueda. Los saltos múltiples están
;  permitidos.
;- Las ocas pueden moverse hacia adelante y hacia los lados, pero nunca en diagonal o
;  hacia atrás (una casilla a la vez). Como no pueden saltar por encima del zorro, tienen
;  que intentar acorralarle para que no se pueda mover. Toda oca cazada es apartada del
;  tablero.
;- Es un movimiento por turno y solamente puede moverse una pieza por vez.
;- El zorro ganará el juego si consigue cazar un mínimo de doce ocas.
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
    zorro                       db "X",0
    oca                         db "O",0
    vacio                       db " ",0
    mapa                        db "    1   2   3   4   5   6   7  ",10 ;32
                                db "1         | O | O | O |        ",10 ;64
                                db "2         | O | O | O |        ",10 ;96
                                db "3 | O | O | O | O | O | O | O |",10 ;128
                                db "4 | O |   |   |   |   |   | O |",10 ;160
                                db "5 | O |   |   | X |   |   | O |",10 ;192
                                db "6         |   |   |   |        ",10 ;224
                                db "7         |   |   |   |        ",10,0 ;256
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
    ocasRestantesParaGanar       dq 12


    msgTurnoZorro                 db "Turno del zorro",10
                                  db "Los movimientos del zorro son: norte(N), sur(S), este(E), oeste(O), noreste(NE), noroeste(NO), sureste(SE), suroeste(SO)",10,0
    tamMsgTurnoZorro              dq 138
    movimientosZorro              db "N",0,"S",0,"E",0,"O",0,"NE",0,"NO",0,"SE",0,"SO",0,0
    movimientosZorroDisponibles   db " ",0," ",0," ",0," ",0,"  ",0,"  ",0,"  ",0,"  ",0,0
    tamMovimientosZorro           dq 21
    posMovimientosZorroDisponibles dq 0, 2, 4, 6, 8, 11, 14, 17
    tamMovimientosZorroDisponibles dq 1, 1, 1, 1, 2, 2, 2, 2
    movimientosZorroValores        dq -32, 32, 4, -4, -28, -36, 36, 28
    cantidadMovimientosZorro       dq 8


    msgTurnoOcas                  db "Turno de las ocas",10
                                  db "Los movimientos de las ocas son: sur(S), este(E), oeste(O)",10
                                  db "Seleccione la oca a mover: ",0
    tamMsgTurnoOcas               dq 105
    movimientosOcas               db "S",0,"E",0,"O",0,0
    movimientosOcasDisponibles    db " ",0," ",0," ",0,0
    tamMovimientosOcas            dq 7
    posMovimientosOcasDisponibles dq 0, 2, 4
    tamMovimientosOcasDisponibles dq 1, 1, 1
    movimientosOcasValores        dq 32, 4, -4
    cantidadMovimientosOcas       dq 3


    msgMovimientosDisponibles     db "Los movimientos disponibles son: "
    movimientosDisponiblesPrint   db "                   ",10
    msgIngresoMovimiento          db "Ingrese el movimiento a realizar: ",0

    indiceMovimiento             dq 0
    msgMovimientoNoValido        db "Movimiento no valido",10,0
    tamMsgMovimientoNoValido     dq 22
    msgSinMovimientos            db "No hay mas movimientos disponibles",10,0
    tamMsgSinMovimientos         dq 36
    msgNoOcaEnPosicion           db "No hay una oca en la posicion ingresada",10,0

    turnoZorro                   dq 0
    turnoOcas                    dq 1
    siguienteTurno               dq 0
    ubicacionZorro               dq 176
    numFormato                   db "%lld",0


section .bss
    movimientoIngresado resb 256
    tamMovimientoIngresado resq 1
    msgTurno resb 256
    movimientos resb 256
    movimientosDisponibles resb 256
    posMovimientosDisponibles resq 8
    tamMovimientosDisponibles resq 8
    movimientosValores resq 8
    cantidadMovimientos resq 1
    turnoActual resq 1
    posicionOcaStr resq 1
    posicionMapaByte resq 1
    ;posicionTablero resq 1
    ubicacionFicha resq 1
    fichaActual resb 1
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
    mov al, ' '  
    rep stosb   
    mov rax, [turnoZorro]
    cmp rax, [siguienteTurno]
    je esTurnoZorro
    jmp esTurnoOcas

esTurnoZorro:
    mov rax, [turnoZorro]
    mov [turnoActual], rax

    mov rcx, [tamMsgTurnoZorro]
    lea rsi, [msgTurnoZorro]
    lea rdi, [msgTurno]
    rep movsb

    mov rcx, [tamMovimientosZorro]
    lea rsi, [movimientosZorro]
    lea rdi, [movimientos]
    rep movsb

    mov rcx, [tamMovimientosZorro]
    lea rsi, [movimientosZorroDisponibles]
    lea rdi, [movimientosDisponibles]
    rep movsb

    mov rcx, [cantidadMovimientosZorro]
    lea rsi, [posMovimientosZorroDisponibles]
    lea rdi, [posMovimientosDisponibles]
    rep movsq

    mov rcx, [cantidadMovimientosZorro]
    lea rsi, [tamMovimientosZorroDisponibles]
    lea rdi, [tamMovimientosDisponibles]
    rep movsq

    mov rcx, [cantidadMovimientosZorro]
    lea rsi, [movimientosZorroValores]
    lea rdi, [movimientosValores]
    rep movsq

    mov rax, [cantidadMovimientosZorro]
    mov [cantidadMovimientos], rax

    mov rax, [turnoOcas]
    mov [siguienteTurno], rax

    mov rax, [ubicacionZorro]
    mov [ubicacionFicha], rax

    mov rax, [zorro]
    mov [fichaActual], rax

    jmp comienzoTurno

esTurnoOcas:
    mov rax, [turnoOcas]
    mov [turnoActual], rax

    mov rcx, [tamMsgTurnoOcas]
    lea rsi, [msgTurnoOcas]
    lea rdi, [msgTurno]
    rep movsb

    mov rcx, [tamMovimientosOcas]
    lea rsi, [movimientosOcas]
    lea rdi, [movimientos]
    rep movsb

    mov rcx, [tamMovimientosOcas]
    lea rsi, [movimientosOcasDisponibles]
    lea rdi, [movimientosDisponibles]
    rep movsb

    mov rcx, [cantidadMovimientosOcas]
    lea rsi, [posMovimientosOcasDisponibles]
    lea rdi, [posMovimientosDisponibles]
    rep movsq

    mov rcx, [cantidadMovimientosOcas]
    lea rsi, [tamMovimientosOcasDisponibles]
    lea rdi, [tamMovimientosDisponibles]
    rep movsq

    mov rcx, [cantidadMovimientosOcas]
    lea rsi, [movimientosOcasValores]
    lea rdi, [movimientosValores]
    rep movsq

    mov rax, [cantidadMovimientosOcas]
    mov [cantidadMovimientos], rax

    mov rax, [turnoZorro]
    mov [siguienteTurno], rax

    mov rax, [oca]
    mov [fichaActual], rax

    jmp comienzoTurno

seleccionarOca:
    mGets posicionOcaStr

    mov r11, [cantidadPosiciones]
    mov rax, 0
esPosicionValida:
    cmp r11, 0
    je posicionNoValida
    mov rcx, 2
    lea rsi, [traduccionPosiciones]
    add rsi, rax
    add rsi, 3
    lea rdi, [posicionTableroStr]
    rep movsb

    mov rcx, 2
    lea rsi, [posicionTableroStr]
    lea rdi, [posicionOcaStr]
    rep cmpsb
    je hayOcaEnPosicion
    add rax,6
    dec r11
    jmp esPosicionValida

hayOcaEnPosicion:
    mov rcx, 3
    lea rsi, [traduccionPosiciones]
    add rsi, rax
    lea rdi, [posicionMapaByteStr]
    rep movsb

    mSscanf posicionMapaByteStr, numFormato, posicionMapaByte

    lea r8, [mapa]
    add r8, [posicionMapaByte]
    cmp byte[r8], 'O'
    je posicionValida
    jmp posicionNoValida

posicionNoValida:
    mPuts msgNoOcaEnPosicion
    jmp seleccionarOca

posicionValida:
    mov rax, [posicionMapaByte]
    mov [ubicacionFicha], rax
    jmp continuarTurno
    
comienzoTurno:
    mClear
    mPuts  mapa
    mPuts  msgTurno
    mov rax, [turnoActual]
    cmp rax, [turnoOcas]
    je seleccionarOca
continuarTurno:
    mov rcx, [cantidadMovimientos]
    mov rax, 0
    mov rsi, 0
    mov [indiceMovimiento], rsi

    lea r8, [mapa]
    add r8, [ubicacionFicha]
verMovimientosDisponibles:
    mov ax, [movimientos + rsi*2]
    mov rbx, [movimientosValores + rsi*8]

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
    mov rcx, 1
    lea rsi, [r8 + rbx]
    lea rdi, [vacio]
    repe cmpsb
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
    sub r8, [ubicacionFicha]

    mov rax, [movimientosValores + rsi*8]
    add [ubicacionFicha], rax
    add r8, [ubicacionFicha]
    mov rax, [fichaActual]
    mov byte[r8], al

    mov rax, [turnoActual]
    cmp rax, [turnoOcas]
    je main

    mov rax, [ubicacionFicha]
    mov [ubicacionZorro], rax
    jmp main

    
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




