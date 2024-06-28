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
    mapa db "    0   1   2   3   4   5   6  ",10 ;32
         db "0         | O | O | O |        ",10 ;64
         db "1         | O | O | O |        ",10 ;96
         db "2 | O | O | O | O | O | O | O |",10 ;128
         db "3 | O |   |   |   |   |   | O |",10 ;160
         db "4 | O |   |   | X |   |   | O |",10 ;192
         db "5         |   |   |   |        ",10 ;224
         db "6         |   |   |   |        ",10,0 ;256
    ;estructura del tipo: posicion con respecto al mapa de bytes, contenido, posicion con respecto al mapa del juego
    estructura db                       "044O02",0,"048O03",0,"052O04",0
               db                       "076O12",0,"080O13",0,"084O14",0
               db "100O20",0,"104O21",0,"108O22",0,"112O23",0,"116O24",0,"120O25",0,"124O26",0
               db "132O30",0,"136 31",0,"140 32",0,"144 33",0,"148 34",0,"152 35",0,"156O36",0
               db "164O40",0,"168 41",0,"172 42",0,"176X43",0,"180 44",0,"184 45",0,"188O46",0
               db                       "204 52",0,"208 53",0,"212 54",0
               db                       "236 62",0,"240 63",0,"244 64",0
    cmdClear                 db "clear",0
    caracter                 db "  ",0
    ocasRestantesParaGanar   db 12
    tamFila                  dq 32
    msgTurnoZorro            db "Turno del zorro",10,0
    msgSeleccionCasilla      db "Los movimientos del zorro son: norte(N), sur(S), este(E), oeste(O), noreste(NE), noroeste(NO), sureste(SE), suroeste(SO)",10,0
    movimientos              db "N S E O NENOSESO",0
    movimientosDisponibles   db "                   ",0
    indiceMovimiento         dq 0
    cantidadMovimientos      dq 8
    msgMovimientoNoValido    db "Movimiento no valido",10,0
    tamMsgMovimientoNoValido dq 22
    msgSinMovimientos        db "No hay mas movimientos disponibles",10,0
    movimientosValores       dq 32, -32, 4, -4, -28, -36, 36, 28
    ubicacionZorro           dq 176
section .bss
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
    call esValidoMovimiento
    add rsp, 8

    inc rsi
    mov [indiceMovimiento], rsi
    loop verMovimientosDisponibles
    jmp fin

esValidoMovimiento:
    mGuardarValorRegistrosGenerales
    mov rcx, 1
    lea rsi, [r8 + rbx]
    lea rdi, [vacio]
    repe cmpsb
    mov rsi, [indiceMovimiento]
    je movValido
volverEsValidoMovimiento:
    mRestaurarValorRegistrosGenerales
    ret

movValido:
    mov rcx, 2
    mov rax, rsi
    lea rsi, [movimientos + rax*2]
    lea rdi, [movimientosDisponibles + rax*2]
    rep movsb
    jmp volverEsValidoMovimiento

moverFicha:
    mGuardarValorRegistrosGenerales
    mov rsi, [indiceMovimiento]
    mov rax, [movimientosValores + rsi*8]
    add [ubicacionZorro], rax
    mRestaurarValorRegistrosGenerales
    ret
    
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
    mPuts movimientosDisponibles

    ret




