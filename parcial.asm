global main
extern puts
extern gets


section .data
    tabla        db "FKD","EJG"
    t1           db "HIQ","LMN"
    t2           db "OCR","ABP"
    desplaz      db 0
    val1 times 3 db 0 ; 3 bytes inicializados a 0, va a guardar 2 caracteres y un 0

section .bss


section .text
    global main
main:

    mov     rbx,1 ; i = 1
    mov     rcx,2 ; j = 2

    dec     rbx ; i-1 = 0
    imul    rbx,6 ; (i-1)*longitud de fila = 0 

    sub     rcx,1 ; j-1 = 1
    imul    rcx,2 ; (j-1)*longitud de columna = 2

    add     rbx,rcx ; (i-1)*longitud de fila + (j-1)*longitud de columna = rbx = 2
    lea     rax,[tabla] ; direccion de la tabla en rax
    add     rax,rbx ; direccion de la tabla + desplazamiento

    mov     rcx,rbx ; rcx = 2

    mov     rsi,rax ; rsi = rax = direccion de la tabla + desplazamiento
    mov     rdi,val1 ; rdi = direccion de val1
    rep    movsb ; copia 2(rcx) bytes de rsi a rdi

    mov     rsi,val1 
    sub     rsp,8
    call    puts
    add     rsp,8

    sub     rax,rax
    mov     ax,[tabla+4]



    ret
