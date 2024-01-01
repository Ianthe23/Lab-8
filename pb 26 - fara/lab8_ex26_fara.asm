bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; Se citesc de la tastatura doua numere a si b. 
; Sa se calculeze valoarea expresiei (a-b)*k, k fiind o constanta definita in segmentul de date.
; Afisati valoarea expresiei (in baza 16).

segment data use32 class=data
    a resd 1
    b resd 1

    k equ 9

    format_mesaj_a db "a = ", 0
    format_mesaj_b db "b = ", 0
    format_citire db "%d", 0
    format_afisare db "(a - b) * k = %x", 0

segment code use32 class=code
    start:
        ; afisez "a = "
        push dword format_mesaj_a
        call [printf]
        add esp, 4

        ; citesc variabila a
        push dword a
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; afisez "b = "
        push dword format_mesaj_b
        call [printf]
        add esp, 4

        ; citesc variabila b
        push dword b
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; EAX <- a - b
        mov eax, [a]
        sub eax, [b]

        ; EDX:EAX = (a - b) * k
        mov ebx, k
        imul ebx
        
        ; dar cum e foarte probabil sa n-am niciodata quadworduri, afisez doar ce-i in EAX
        push dword eax
        push dword format_afisare
        call [printf]
        add esp, 2*4

	    push dword 0 
	    call [exit] 