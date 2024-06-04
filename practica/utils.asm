global strLen

section .text
strLen:
    mov rsi,0
nextChar:
    cmp byte[rdi+rsi],0
    je endStrLen
    inc rsi
    jmp nextChar
endStrLen:
    mov rax,rsi
    ret


