nasm ejercicio4.asm -f elf64
gcc ejercicio4.o -o ejercicio4.out -no-pie
nasm -f elf64 -g -F dwarf -l test.lst -o test.o ejercicio4.asm
gcc -no-pie -o test test.o 



x/1xb &direccion
x/3gb a
x/1s

   mClear
    mPuts  mapaPrint
    mov    rsi, 0
    mov    rsi, 44
    lea    rax, [mapaPrint]
    mov    dl, [rax + rsi]
    mov    [caracter], dl
    mov    [rsiAux], rsi
    mPuts  caracter

    lea    rax, [mapaPrint]
    mov    rsi, [rsiAux]
    add    rsi, [tamFila]
    mov    dl, [rax + rsi]
    mov    [caracter], dl
    mPuts  caracter

    lea    rax, [mapaPrint]
    mov    rsi, 176
    mov    dl, [rax + rsi]
    mov    [caracter], dl
    mPuts  caracter
