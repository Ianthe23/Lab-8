bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; Sa se citeasca de la tastatura doua numere a si b (in baza 10) si sa se calculeze: (a+b) / (a-b).
; Catul impartirii se va salva in memorie in variabila "rezultat" (definita in segmentul de date).
; Valorile se considera cu semn.

segment data use32 class=data
    a resd 1
    b resd 1

    rezultat resd 1

    format_mesaj_a db "a = ", 0
    format_mesaj_b db "b = ", 0
    format_citire db "%d", 0
    format_afisare db "(a + b) / (a - b) = %d", 0

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

        mov eax, [a]
        add eax, [b] ; EAX <- a + b

        mov ebx, [a]
        sub ebx, [b] ; EBX <- a - b

        cdq ; convertesc cu semn de la EAX la EDX:EAX
        idiv ebx ; impart cu semn EDX:EAX la EBX => EAX <- catul

        mov [rezultat], eax ; pun catul in rezultat

        ; afisez catul dupa format
        push dword [rezultat]
        push dword format_afisare
        call [printf]
        add esp, 2*4

	    push dword 0 
	    call [exit] 