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


global main

extern puts
extern gets
extern printf
extern sscanf

section .data
    msgEntradaValores db "Ingrese el valor del numero %lld: ",10,0
    numFormato db "%lld",0
section .bss
    numStr resb 500
    num resq 1


section .text
    global main
main:

    mPuts msgEntradaX
    mGets xStr

    mSscanf xStr,numFormato,x



    ret
