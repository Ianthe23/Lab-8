bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; Sa se citeasca de la tastatura doua numere a si b (in baza 10).
; Sa se calculeze si sa se afiseze media lor aritmetica in baza 16.

segment data use32 class=data
    a dd 0
    b dd 0
    impartit dd 2

    format_citire db "%d", 0
    format_afisare db "%x", 0

segment code use32 class=code
    start:
        ; citim de la tastatura numarul a
        push dword a
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; citim de la tastatura numarul numarul b
        push dword b
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; punem in eax suma celor 2 numere: EAX <- a + b
        mov eax, dword [a]
        add eax, dword [b]
        shr eax, 1 ; mutam bitii cu o pozitie spre dreapta (adica impartim suma la 2)

        ; afisam media aritmetica a celor 2 numere
        push eax
        push dword format_afisare
        call [printf]
        add esp, 2*4

	    push dword 0 
	    call [exit] 