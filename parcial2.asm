global main
extern puts


section .data
    tabla db 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    f db '5'
    tex db "AB"
    c db "CD"
    cont db 0
section .bss

section .text
    global main
main:
    mov rax, 0
    mov rcx, 0
    mov cl, [f]
    mov esi, 0

foo:
    add ax, [tabla + esi]
    add si, 40
    loop foo


    mov dl, al
    imul rax,2
    mov dh, al



    ret
