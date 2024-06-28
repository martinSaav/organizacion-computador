nasm main.asm -f elf64
gcc main.o -o main.out -no-pie
./main.out

nasm -f elf64 -g -F dwarf -l test.lst -o test.o main.asm
gcc -no-pie -o test test.o
gdb test


