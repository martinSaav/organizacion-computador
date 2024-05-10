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