global main
extern puts


section .data
    fff db ")"
    des db 16
    val2 db "Z9"
    val3 db 0
section .bss

section .text
    global main
main:
    mov rax, 0
    mov ax, 41

    mov ah, al
    add ah, 2
    mov [des],ax
    mov rdi, des
    sub rsp,8
    call puts
    add rsp,8



    ret
