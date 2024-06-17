; 3. Realizar un programa que resuelva X Y teniendo en cuenta que tanto X e Y pueden ser positivos o negativos.

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


global main

extern puts
extern gets
extern printf
extern sscanf

section .data
    msgEntradaX db "Ingrese el valor de X: ",0
    msgEntradaY db "Ingrese el valor de Y: ",0
    msgResultadoPositivo db "El resultado de %lld^%lld es: %lld",10,0
    msgResultadoNegativo db "El resultado de %lld^%lld es: 1/%lld",10,0
    numFormato db "%lld",0
    negativo db 0
section .bss
    xStr resb 500
    yStr resb 500
    x resq 1
    y resq 1
    resultado resq 1
    msgResultado resb 500

section .text
    global main
main:

    mPuts msgEntradaX
    mGets xStr

    mPuts msgEntradaY
    mGets yStr

    mSscanf xStr,numFormato,x
    mSscanf yStr,numFormato,y

    mov     rax,[y]
    cmp     rax,0
    jl      exponenteNegativo
    je      cero
    jmp     calculoPotencia
exponenteNegativo:
    neg     rax
    mov     byte[negativo],1
calculoPotencia:
    mov     rcx,rax
    mov     rax,1
    mov     rbx,[x]
calculo:
    imul    rax, rbx
    loop    calculo
    mov     [resultado],rax

    cmp     byte[negativo],1
    je      negativoResultado
    jmp     positvoResultado
negativoResultado:
    ;mov     rax,1
    ;idiv    qword[resultado]
    ;mov     [resultado],rax
    mov     rcx, 38
    lea     rsi, [msgResultadoNegativo]
    lea     rdi, [msgResultado]
    rep     movsb
    jmp     mostarResultado
positvoResultado:
    mov     rcx, 36
    lea     rsi, [msgResultadoPositivo]
    lea     rdi, [msgResultado]
    rep     movsb
    jmp     mostarResultado
cero:
    mov     rax, 1
    mov     [resultado], rax
mostarResultado:
    mov     rdi,msgResultado
    mov     rsi,[x]
    mov     rdx,[y]
    mov     rcx,rax
    sub     rsp,8
    call    printf
    add     rsp,8

    ret
