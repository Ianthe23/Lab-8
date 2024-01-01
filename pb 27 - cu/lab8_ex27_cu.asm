bits 32
global start

extern exit, fopen, fclose, fprintf, fscanf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import fprintf msvcrt.dll

; Se da un fisier text. Fisierul contine numere (in baza 10) separate prin spatii. 
; Sa se citeasca continutul acestui fisier, 
; sa se determine minimul numerelor citite si sa se scrie rezultatul la sfarsitul fisierului.

segment data use32 class=data
    numar dd 0
    minim dd 0
    
    file_name db "ex27.txt", 0
    file_mode_citire db "r", 0
    file_mode_append db "a", 0
    file_descriptor dd -1

    format_citire db "%d", 0
    format_afisare db " %d", 0
segment code use32 class=code
    start:

        ; deschidem fisierul
        push dword file_mode_citire
        push dword file_name
        call [fopen]
        add esp, 2*4

        ; verificam daca s-a deschis corect
        cmp eax, 0
        je final

        mov [file_descriptor], eax

    citire:
        ; citim primul numar ca sa-l luam ca minim
        push dword numar
        push dword format_citire
        push dword [file_descriptor]
        call [fscanf]
        add esp, 3*4

        ; verific daca s-a ajuns la EOF sau nu se mai poate citi nimic
        cmp eax, 1
        jne iesire

        push eax

        ; luam primul numar ca maxim
        mov eax, [numar]
        mov [minim], eax

        pop eax

        Repeta:
            ; citim numar cu numar din cele ramase
            push dword numar
            push dword format_citire
            push dword [file_descriptor]
            call [fscanf]
            add esp, 3*4

            ; verific daca s-a ajuns la EOF sau nu se mai poate citi nimic
            cmp eax, 1
            jne iesire

            push eax

            ; verificam sa vedem daca am gasit un alt minim
            mov eax, [minim]
            cmp eax, [numar]
            jle NuMinim

            mov eax, [numar]
            mov [minim], eax ; actualizam noul minim daca am gasit altul

            NuMinim:
                pop eax
                jmp Repeta

    iesire:
        ; inchidem fisierul
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

        ; deschidem fisierul
        push dword file_mode_append
        push dword file_name
        call [fopen]
        add esp, 2*4

        cmp eax, 0
        je final

        mov [file_descriptor], eax

        ; dam append la minim in fisier
        push dword [minim]
        push dword format_afisare
        push dword [file_descriptor]
        call [fprintf]
        add esp, 3*4

        ; inchidem fisierul
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

    final:
	    push dword 0 
	    call [exit] 