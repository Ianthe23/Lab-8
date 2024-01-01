bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; Sa se citeasca de la tastatura un numar in baza 10 si un numar in baza 16.
; Sa se afiseze in baza 10 numarul de biti 1 ai sumei celor doua numere citite. 
; Exemplu:
;   a = 32 = 0010 0000b
;   b = 1Ah = 0001 1010b
;   32 + 1Ah = 0011 1010b
; Se va afisa pe ecran valoarea 4.

segment data use32 class=data
    a resd 1
    b resd 1
    contor dd 0

    format_mesaj_a db "a = ", 0
    format_mesaj_b db "b = ", 0
    format_citire_a db "%d", 0
    format_citire_b db "%x", 0
    format_afisare db "numarul de biti 1 : %d", 0


segment code use32 class=code
    start:
        ; afisez "a = "
        push dword format_mesaj_a
        call [printf]
        add esp, 4

        ; citesc variabila a
        push dword a
        push dword format_citire_a
        call [scanf]
        add esp, 2*4

        ; afisez "b = "
        push dword format_mesaj_b
        call [printf]
        add esp, 4

        ; citesc variabila b
        push dword b
        push dword format_citire_b
        call [scanf]
        add esp, 2*4

        ; EAX <- a + b
        mov eax, [a] 
        add eax, [b]

        mov ebx, eax ; EBX = EAX

        ; numar cati biti 1 sunt in suma
        Repeta:
            rol ebx, 1
            jnc NuBit1

            add dword [contor], 1

        NuBit1:
            cmp ebx, eax
            jne Repeta

        ; afisez contorul de biti
        push dword [contor]
        push dword format_afisare
        call [printf]
        add esp, 2*4
            
	    push dword 0 
	    call [exit] 