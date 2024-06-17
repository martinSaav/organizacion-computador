global main


section .data
    ddd db "&"
    val db 0,0,0,0

section .bss


section .text
    global main
main:

    mov     cl, [ddd]
    lea     rbx, [mat]
    mov     rdx,0
    mov     rsi,0
    mov     rcx,0

ne:
    add     dx, [mat+rsi]
    add     rsi,78
    loop    ne




    ret
