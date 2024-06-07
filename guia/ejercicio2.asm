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
    padronInText               db "ingrese su padron: ",0
    fechaNacimientoInText      db "ingrese su fecha de nacimiento con el formato dd/mm/aaaa: ",0 ; si se ingresa mal la fecha de nacimiento, el programa se rompe
    fechaHoy                   db "15",0
section .bss
    nombreApellido            resb 500
    padron                    resb 500
    fechaNacimiento           resb 500
    anios                     resb 1
    mes                       resb 1
    dia                       resb 1
    temp_string               resb 2  ; Temporal para un carácter y el nulo

section .text
    global main
main:
    mPuts nombreApellidoInText
    mGets nombreApellido

    mPuts padronInText
    mGets padron

    mPuts fechaNacimientoInText
    mGets fechaNacimiento



    sub     rsp,8
    ;call    calcularEdad
    add     rsp,8


 ; Iterar sobre fechaHoy y mostrar cada carácter
    mov     rsi, 0

nextCharFindLast:
    mov     al, byte[fechaHoy+rsi]          ; Cargar el carácter actual
    cmp     byte[fechaHoy+rsi], 0              ; Comparar con 0 (fin de cadena)
    je      endString

    mov     [temp_string],al   ; Colocar el carácter en temp_string
    mov     byte [temp_string+1], 0 ; Añadir el carácter nulo
    mPuts   temp_string

    inc     rsi
    jmp     nextCharFindLast

endString:
    ret
    