bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

;Sa se citeasca de la tastatura un numar in baza 10 si sa se afiseze valoarea acelui numar in baza 16
segment data use32 class=data
    n dd 0 ; definim variabila n
    format_citire db "%d", 0 ; definim formatul de citire
    format_afisare db "%x", 0 ; definim formatul de afisare

segment code use32 class=code
    start:
        push dword n ; punem parametrii pe stiva de la dreapta la stanga
        push dword format_citire
        call [scanf] ; apelam functia scanf pentru citire
        add esp, 2*4 ; eliberam parametrii de pe stiva

        mov ebx, 0
        add ebx, [n] ; pun variabila n pe registrul ebx

        push ebx; punem parametrii pe stiva de la dreapta la stanga
        push dword format_afisare 
        call [printf] ; apelam functia printf pentru afisare
        add esp, 2*4 ; eliberam parametrii de pe stiva

	    push dword 0 
	    call [exit] 