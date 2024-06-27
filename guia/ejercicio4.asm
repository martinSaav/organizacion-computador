; Escribir un programa que lea 15 números ingresados por teclado. Se pide imprimir dichos números en forma decreciente.


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


global main

extern puts
extern gets
extern printf
extern sscanf

section .data
    msgEntradaValores db "Ingrese el valor del numero %lld: ",10,0
    numFormato db "%lld",0
    indiceNum dq 0
    tamVector dq 3
    tamVectorAux dq 3
    saltoLinea db 10,0
    mensajeOrdenado db "El vector ordenado de forma decreciente es: ",10,0
section .bss
    numStr resb 500
    numVector times 15 resq 1
    num resq 1
    rsiAux resq 1
    rcxAux resq 1
section .text
    global main
main:

ingresarOrdenado:
    mov     rax, [tamVectorAux]
    cmp     rax, 0
    je      fin

    sub     rsp,8
    call    ingresoValores
    add     rsp,8

    sub     rsp,8
    call    algoritmo
    add     rsp,8

    mov     rax, [tamVectorAux]
    dec     rax
    mov     [tamVectorAux], rax
    jmp     ingresarOrdenado

ingresoValores:
    mov     rax, [indiceNum] 
    add     rax, 1
    mPrintf msgEntradaValores, rax
    mGets   numStr
    mSscanf numStr, numFormato, num
    ret

algoritmo:
    mov     rsi, 0
iteracionVector: 
    mov     rcx, [indiceNum]
    cmp     rcx, 0
    je      finAlgoritmo
    mov     rax, [num]
    cmp     rax, [numVector + rsi*8]
    jg      finAlgoritmo
    dec     rcx
    inc     rsi
    jmp     iteracionVector
finAlgoritmo:
    mov    rbx, rsi
    mov    rcx, [indiceNum]
    sub    rcx, rbx
    ;mov    rax, rsi ; guardo el indice en rax
    lea    rsi, [numVector + rbx*8]
    lea    rdi, [numVector + (rbx + 1)*8]
    rep movsq

    ;copio el numero en la posicion correcta
    mov    rax, [num]
    mov    [numVector + rbx*8], rax

   ;aumento el indice
    mov    rax, [indiceNum]
    inc    rax
    mov    [indiceNum], rax
    ret

fin:
    mov     rsi, 0
    mov     rcx, [tamVector]
    mov     [rsiAux], rsi
    mov     [rcxAux], rcx
    ;mPuts   mensajeOrdenado

imprimirVector:
    cmp     rcx, 0
    je      finPrograma
    mov     rax, [numVector + rsi*8]
    mPrintf numFormato, rax
    
    mov     rsi, [rsiAux]
    inc     rsi
    mov     [rsiAux], rsi

    mov     rcx, [rcxAux]
    dec     rcx
    mov     [rcxAux], rcx

    jmp     imprimirVector

finPrograma:
    ;mPuts   saltoLinea


    ret


