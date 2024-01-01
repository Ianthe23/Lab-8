bits 32
global start

extern exit, fopen, fclose, fscanf, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import printf msvcrt.dll

; Se da un fisier text. Sa se citeasca continutul fisierului, 
; sa se contorizeze numarul de consoane si sa se afiseze aceasta valoare. 
; Numele fisierului text este definit in segmentul de date.

segment data use32 class=data
    file_name db "ex2.txt", 0
    file_mode db "r", 0

    vocale db "aeiouAEIOU", 0
    l equ $-vocale

    caracter resb 1

    file_descriptor dd -1

    format_citire db "%c", 0
    format_afisare db "Numarul de consoane = %d", 0

    contor_consoane dd 0

segment code use32 class=code
    start:
        ; deschid fisierul
        push dword file_mode
        push dword file_name
        call [fopen]
        add esp, 2*4

        ; verific daca s-a deschis fisierul cum trebuie
        cmp eax, 0
        je final

        mov [file_descriptor], eax

    citire:
        ; citesc caracter cu caracter (despartite prin pauza)
        push dword caracter
        push dword format_citire
        push dword [file_descriptor]
        call [fscanf]
        add esp, 3*4

        ; fie a ajuns la EOF, fie n-a reusit sa citeasca
        cmp eax, 1
        jne iesire

        push ecx

        mov ecx, l ; pun lungimea sirului de vocale in ecx
        sub ecx, 1
        mov esi, 0 ; indexul sirului de vocale

        ; verific daca e pauza sa sar direct peste acel caracter
        mov bl, [caracter]
        cmp bl, 32
        je NuConsoana

        Repeta:
            mov bl, [caracter]
            cmp bl, [vocale + esi] 
            je citire ; verific daca e vocala sa sar direct peste acel caracter

            inc esi ; altfel verific cu celelalte vocale
            dec ecx
            jecxz Continua
            jmp Repeta

        Continua:
            add dword [contor_consoane], 1

        NuConsoana:
            pop ecx
            jmp citire


    iesire:
        ; afisam contorul de consoane
        mov eax, [contor_consoane]
        push eax
        push dword format_afisare
        call [printf]
        add esp, 2*4

        ; inchidem fisierul
        push dword [file_descriptor]
        call [fclose]
        add esp, 1*4

    final:
	    push dword 0 
	    call [exit] 