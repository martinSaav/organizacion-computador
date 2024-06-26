nasm ejercicio4.asm -f elf64
gcc ejercicio4.o -o ejercicio4.out -no-pie
nasm -f elf64 -g -F dwarf -l test.lst -o test.o ejercicio4.asm
gcc -no-pie -o test test.o 



fin:
    mov     rsi, 0
    mov     rcx, [tamVector]
    jmp     imprimirVector

imprimirVector:
    cmp     rcx, 0
    je      finPrograma
    mov     rax, [numVector + rsi*8]
    mPrintf numFormato, rax
    inc     rsi
    dec     rcx
    jmp     imprimirVector

finPrograma: