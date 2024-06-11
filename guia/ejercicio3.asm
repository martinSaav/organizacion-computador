; 3. Realizar un programa que resuelva X Y teniendo en cuenta que tanto X e Y pueden ser positivos o negativos.

global main

extern puts

section .data
    cadena db "Organización del Computador", 0

section .text
    global main
main:
    mov rdi, cadena
    sub rsp, 8
    call puts
    add rsp, 8
    ret