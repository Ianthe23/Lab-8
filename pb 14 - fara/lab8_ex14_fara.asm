bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; Sa se citeasca de la tastatura doua numere a si b (in baza 16) si sa se calculeze a+b.
; Sa se afiseze rezultatul adunarii in baza 10.

segment data use32 class=data
    a dd 0
    b dd 0
    rezultat dd 0

    format_citire db "%x", 0
    format_afisare db "a + b = %d", 0

segment code use32 class=code
    start:

        ; citim variabila a de la tastatura
        push dword a
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; ; citim variabila b de la tastatura
        push dword b
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; rezultat <- a + b
        mov eax, [a]
        add eax, [b]
        mov [rezultat], eax

        ; afisam rezultatul in consola
        push dword [rezultat]
        push dword format_afisare
        call [printf]
        add esp, 2*4

	    push dword 0 
	    call [exit] 