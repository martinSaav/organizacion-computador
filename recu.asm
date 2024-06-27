global main
extern puts


section .data
    ddd db 12
    val db 0,0,0,0
    ;matriz de 38x38
    ;mat db 1,1,1,1

section .bss


section .text
    global main
main:

    ;mov     cl, [ddd]
    ;lea     rbx, [mat]
    ;mov     rdx,0
    ;mov     rsi,0
    ;mov     rcx,0

;ne:
    ;add     dx, [mat+rsi]
    ;add     rsi,78
    ;loop    ne
    mov rdx, 0
    mov rcx, 5

    add dx, 38

    mov dh, dl 
    add dh, 2
    mov [val], dx
    mov rdi, val
    sub rsp, 8
    call puts
    add rsp, 8





    ret
