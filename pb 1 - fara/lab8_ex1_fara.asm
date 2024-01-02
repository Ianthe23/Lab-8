bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; Sa se citeasca de la tastatura doua numere (in baza 10) si sa se calculeze produsul lor.
; Rezultatul inmultirii se va salva in memorie in variabila "rezultat" (definita in segmentul de date).

segment data use32 class=data
    a resd 1
    b resd 1

    rezultat dq 0

    format_mesaj_a db "a = ", 0
    format_mesaj_b db "b = ", 0
    format_citire db "%d", 0
    format_afisare db "a * b = %lld", 0

segment code use32 class=code
    start:
        ; afisam "a = "
        push dword format_mesaj_a
        call [printf]
        add esp, 4

        ; citim variabila a
        push dword a
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; afisam "b = "
        push dword format_mesaj_b
        call [printf]
        add esp, 4

        ; citim variabila b
        push dword b
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; EDX:EAX <- a * b
        mov eax, [a]
        mov edx, 0
        mov ebx, [b]
        imul ebx

        ; pun in memorie rezultatul (little-endian)
        mov [rezultat], eax ; pun dublu-cuvantul inferior
        mov [rezultat + 4], edx ; pun dublu-cuvantul superior

        ; afisez rezultatul
        push dword [rezultat + 4]
        push dword [rezultat]
        push dword format_afisare
        call [printf]
        add esp, 3*4


	    push dword 0 
	    call [exit] 