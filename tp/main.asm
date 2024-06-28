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
    zorro db "X",0
    oca db "O",0
    vacio db " ",0
    mapa db "                               ",10 ;32
         db "          | O | O | O |        ",10 ;64
         db "          | O | O | O |        ",10 ;96
         db "  | O | O | O | O | O | O | O |",10 ;128
         db "  | O |   |   |   |   |   | O |",10 ;160
         db "  | O |   |   | X |   |   | O |",10 ;192
         db "          |   |   |   |        ",10 ;224
         db "          |   |   |   |        ",10,0 ;256
    ;estructura del tipo: posicion con respecto al mapa de bytes, contenido, posicion con respecto al mapa del juego
    estructura db                   "044O",0,"048O",0,"052O",0
               db                   "076O",0,"080O",0,"084O",0
               db "100O",0,"104O",0,"108O",0,"112O",0,"116O",0,"120O",0,"124O",0
               db "132O",0,"136 ",0,"140 ",0,"144 ",0,"148",0,"152 ",0,"156O",0
               db "164O",0,"168 ",0,"172 ",0,"176X",0,"180 ",0,"184 ",0,"188O",0
               db                   "204 ",0,"208 ",0,"212 ",0
               db                   "236 ",0,"240 ",0,"244 ",0
    cmdClear                 db "clear",0
    ocasRestantesParaGanar   db 12
    tamFila                  dq 32
    msgTurnoZorro            db "Turno del zorro",10,0
    msgSeleccionCasilla      db "Los movimientos del zorro son: norte(N), sur(S), este(E), oeste(O), noreste(NE), noroeste(NO), sureste(SE), suroeste(SO)",10,0
    movimientos              db "N",0,"S",0,"E",0,"O",0,"NE",0,"NO",0,"SE",0,"SO",0
    movimientosDisponibles   db " ",0," ",0," ",0," ",0,"  ",0,"  ",0,"  ",0,"  ",0,0
    posMovimientosDisponibles dq 0, 2, 4, 6, 8, 11, 14, 17
    tamMovimientosDisponibles dq 1, 1, 1, 1, 2, 2, 2, 2
    msgMovimientosDisponibles db "Los movimientos disponibles son: "
    movimientosDisponiblesPrint   db "                   ",10
    msgIngresoMovimiento     db "Ingrese el movimiento a realizar: ",0
    indiceMovimiento         dq 0
    cantidadMovimientos      dq 8
    msgMovimientoNoValido    db "Movimiento no valido",10,0
    tamMsgMovimientoNoValido dq 22
    msgSinMovimientos        db "No hay mas movimientos disponibles",10,0
    movimientosValores       dq -32, 32, 4, -4, -28, -36, 36, 28
    ubicacionZorro           dq 176
section .bss
    movimientoIngresado resb 256
    tamMovimientoIngresado resq 1
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
    mClear
    mPuts  mapa
    mPuts  msgTurnoZorro
    mPuts  msgSeleccionCasilla

    mov rcx, [cantidadMovimientos]
    mov rax, 0
    mov rsi, [indiceMovimiento]
    lea r8, [mapa]
    add r8, [ubicacionZorro]
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
    jmp fin

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
    ; primero verifico el tamaño del movimiento ingresado
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
    ;mov r10, [movimientosValores + rsi*8]
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
    jmp fin

moverFicha:
    lea r8, [mapa]
    add r8, [ubicacionZorro]
    mov byte[r8], ' '
    sub r8, [ubicacionZorro]

    mov rax, [movimientosValores + rsi*8]
    add [ubicacionZorro], rax
    add r8, [ubicacionZorro]
    mov byte[r8], 'X'

    mClear
    mPuts mapa
    jmp fin
    ;jmp main

    
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
    mPuts msgMovimientosDisponibles
    mGets movimientoIngresado
    jmp verficarEsMovimientoValido

    ret




