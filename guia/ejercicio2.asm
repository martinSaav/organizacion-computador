%macro mPuts 1  
    mov     rdi,%1
    sub     rsp,8
    call    puts
    add     rsp,8
%endmacro
;genera conflicto con el rsi
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
    infoAlumnoText            db "El alumno %s de Padrón N° %s tiene %li años",10,0
    nombreApellidoInText      db "ingrese su nombre y apellido: ",0
    padronInText              db "ingrese su padron: ",0
    fechaNacimientoInText     db "ingrese su fecha de nacimiento con el formato dd/mm/aaaa: ",0 ; si se ingresa mal la fecha de nacimiento, el programa se rompe
    diaHoy                    dq 10
    mesHoy                    dq 6
    anioHoy                   dq 2024
    numFormato                db "%d",0
section .bss
    nombreApellido            resb 500
    padron                    resb 500
    fechaNacimiento           resb 500
    diaNacStr              resb 3   
    mesNacStr              resb 3   
    anioNacStr             resb 5
    diaNac                 resq 1
    mesNac                 resq 1
    anioNac                resq 1
    edad                      resq 1  

section .text
    global main
main:

    mPuts nombreApellidoInText
    mGets nombreApellido

    mPuts padronInText
    mGets padron

    mPuts fechaNacimientoInText
    mGets fechaNacimiento

    mov     ax,word[fechaNacimiento]    
    mov     [diaNacStr],ax   
    mov     byte[diaNacStr+2],0 

    mov     ax,word[fechaNacimiento+3]         
    mov     [mesNacStr],ax 
    mov     byte[mesNacStr+2],0 

    mov     rax,qword[fechaNacimiento+6]
    mov     [anioNacStr],rax
    mov     byte[anioNacStr+4],0  

    mSscanf diaNacStr,numFormato,diaNac

    mSscanf mesNacStr,numFormato,mesNac

    mSscanf anioNacStr,numFormato,anioNac

    ; Calcula la edad
    mov     rax, [anioHoy]
    sub     rax, [anioNac]
    mov     [edad], rax

    ; Compara los meses
    mov     rax, [mesNac]
    mov     rbx, [mesHoy] ; mesSiendo
    cmp     rax, rbx
    jg      decEdad
    jl      fin
    je      mesIgual

decEdad:
    sub     qword [edad], 1
    jmp     fin

mesIgual:
    ; Compara los días si los meses son iguales
    mov     rax, [diaHoy]
    mov     rbx, [diaNac]
    cmp     rax, rbx
    jl      decEdad

fin:
    ; Muestra la información del alumno
    mov    rdi, infoAlumnoText
    mov    rsi, nombreApellido
    mov    rdx, padron
    mov    rcx, [edad]
    sub    rsp, 8
    call   printf
    add    rsp, 8
    ret
    