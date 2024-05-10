global main

extern puts

section .data
    cadena db "Hello World!", 0

section .text

main:
    mov rdi, cadena
    sub rsp, 8
    call puts
    add rsp, 8
    ret

