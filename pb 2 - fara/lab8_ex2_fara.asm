bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; Sa se citeasca de la tastatura doua numere a si b (in baza 10) si sa se calculeze a/b.
; Catul impartirii se va salva in memorie in variabila "rezultat" (definita in segmentul de date).
; Valorile se considera cu semn.

segment data use32 class=data
    a resd 1
    b resd 1

    rezultat dd 0

    format_mesaj_a db "a = ", 0
    format_mesaj_b db "b = ", 0
    format_citire db "%d", 0
    format_afisare db "a / b = %d", 0
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

        ; pun in EDX:EAX variabila a
        mov eax, [a] 
        cdq

        ; impart EDX:EAX la EBX (a/b) iar EAX <- catul
        mov ebx, [b]
        idiv ebx
        mov [rezultat], eax ; pun catul in rezultat

        ; afisez rezultatul
        push dword [rezultat]
        push dword format_afisare
        call [printf]
        add esp, 2*4

	    push dword 0 
	    call [exit] 