bits 32
global start

extern exit, fopen, fclose, fscanf, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import printf msvcrt.dll

; Se da un fisier text. Sa se citeasca continutul fisierului, sa se contorizeze numarul de vocale si sa se afiseze aceasta valoare. 
; Numele fisierului text este definit in segmentul de date.

segment data use32 class=data
    file_name db "ex1.txt", 0
    file_mode db "r", 0

    caracter resd 1
    vocale db "aeiouAEIOU", 0
    nr_vocale dd 0

    format_citire db "%c", 0
    format_afisare db "nr de vocale = %d", 0
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

    Citire:
        push dword caracter
        push dword format_citire
        push dword [file_descriptor]
        call [fscanf]
        add esp, 3*4

        cmp eax, 1
        jne Afisare

        mov al, byte [caracter]
        mov ecx, 10
        mov esi, 0

        Repeta:
            mov bl, byte[vocale + esi]

            cmp al, bl
            jne NuVocala

            add dword [nr_vocale], 1

        NuVocala:
            inc esi
            loop Repeta

        jmp Citire


    Afisare:
        push dword [nr_vocale]
        push dword format_afisare
        call [printf]
        add esp, 2*4

        push dword [file_descriptor]
        call [fclose]
        add esp, 4

    final:
	    push dword 0 
	    call [exit] 