bits 32
global start

extern exit, fopen, fclose, scanf, fprintf, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import fprintf msvcrt.dll

; Se da un nume de fisier (definit in segmentul de date). 
; Sa se creeze un fisier cu numele dat, apoi sa se citeasca de la tastatura numere si 
; sa se scrie valorile citite in fisier pana cand se citeste de la tastatura valoarea 0.

segment data use32 class=data
    file_name db "ex12.txt", 0
    file_mode db "w", 0

    numar resd 1

    format_mesaj_citire db "Introduceti numerele: ", 0
    format_mesaj_afisare db "Numerele sunt: ", 0
    format_citire db "%d", 0
    format_afisare db "%d ", 0
    file_descriptor dd -1

segment code use32 class=code
    start:

        push dword file_mode
        push dword file_name
        call [fopen]
        add esp, 2*4

        cmp eax, 0
        je final

        mov [file_descriptor], eax

        push dword format_mesaj_citire
        call [printf]
        add esp, 4

        push dword format_mesaj_afisare
        push dword [file_descriptor]
        call [fprintf]
        add esp, 2*4

    Citire:
        push dword numar
        push dword format_citire
        call [scanf]
        add esp, 2*4

        mov eax, [numar]
        test eax, eax

        je Iesire

        push dword eax
        push dword format_afisare
        push dword [file_descriptor]
        call [fprintf]
        add esp, 3*4

        jmp Citire

    Iesire:
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

    final:
	    push dword 0 
	    call [exit] 