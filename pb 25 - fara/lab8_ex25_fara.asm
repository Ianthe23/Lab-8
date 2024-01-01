bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; Sa se citeasca de la tastatura doua numere a si b (in baza 10) şi
; să se determine relaţia de ordine dintre ele (a < b, a = b sau a > b). 
; Afisati rezultatul în următorul format: "<a> < <b>, <a> = <b> sau <a> > <b>".

segment data use32 class=data
    a resd 1
    b resd 1

    format_mesaj_a db "a = ", 0
    format_mesaj_b db "b = ", 0
    format_citire db "%d", 0
    format_afisare_1 db "%d < %d", 0
    format_afisare_2 db "%d = %d", 0
    format_afisare_3 db "%d > %d", 0

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

        mov eax, [a]
        mov ebx, [b]

        cmp eax, ebx ; verific daca a < b
        jl MaiMic

        cmp eax, ebx ; verific daca a = b
        je Egale

        cmp eax, ebx ; verific daca a > b
        jg MaiMare

    MaiMic:
        ; afisez "a < b"
        push dword [b]
        push dword [a]
        push dword format_afisare_1
        call [printf]
        add esp, 3*4

        jmp final

    Egale:
        ; afisez "a = b"
        push dword [b]
        push dword [a]
        push dword format_afisare_2
        call [printf]
        add esp, 3*4

        jmp final

    MaiMare:
        ; afisez "a > b"
        push dword [b]
        push dword [a]
        push dword format_afisare_3
        call [printf]
        add esp, 3*4

    final:
	    push dword 0 
	    call [exit] 