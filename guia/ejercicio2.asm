%macro mPuts 0
    sub     rsp,8
    call    puts
    add     rsp,8
%endmacro

%macro mGets 0
    sub     rsp,8
    call    gets  
    add     rsp,8
%endmacro

%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

global main

extern puts
extern gets
extern printf

section .data
    infoAlumnoText             db "El alumno %s de Padrón N° %s tiene %li años",0
    nombreApellidoInText       db "ingrese su nombre y apellido: ",0
    fechaNacimientoInText      db "ingrese su fecha de nacimiento: ",0
section .bss
    text            resb 500
section .text
    global main
main:
    mov rdi, nombreApellidoInText
    mPuts
    mov rdi, text
    mGets

    ret