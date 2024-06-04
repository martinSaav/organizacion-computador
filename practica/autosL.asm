global main

%macro mPuts 1
	mov rdi, %1
	sub rsp, 8
	call puts
	add rsp, 8
%endmacro

%macro mGets 1
	mov rdi, %1
	sub rsp, 8
	call gets
	add rsp, 8
%endmacro
extern puts
extern gets
extern strLen

section .data
	msgInMarca db "Ingrese una marca de auto", 0
	arrMarcas db "Fiat      "
