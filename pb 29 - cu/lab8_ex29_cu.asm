bits 32
global start

extern exit, fopen, fclose, fscanf, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import fprintf msvcrt.dll

; Se da un fisier text. Fisierul contine numere (în baza 10) separate prin spatii.
; Sa se citeasca continutul acestui fisier, sa se determine maximul numerelor citite si sa se scrie rezultatul la sfarsitul fisierului.

segment data use32 class=data
    file_name db "ex29.txt", 0
    file_mode_citire db "r", 0
    file_mode_append db "a", 0

    numar resd 1
    maxim dd 0

    format_citire db "%d", 0
    format_afisare db " %d", 0
    file_descriptor dd -1

segment code use32 class=code
    start:
        ; deschid fisierul
        push dword file_mode_citire
        push dword file_name
        call [fopen]
        add esp, 2*4

        ; verific daca s-a deschis corect
        cmp eax, 0
        je final

        mov [file_descriptor], eax

        ; citesc primul numar ca sa-l iau ca maxim
        push dword numar
        push dword format_citire
        push dword [file_descriptor]
        call [fscanf]
        add esp, 3*4

        ; verific daca s-a ajuns la EOF sau daca nu se mai poate citi nimic
        cmp eax, 1
        jne Iesire

        mov eax, [numar]
        mov [maxim], eax ; pun in maxim primul numar citit

    Citire:
        ; citesc numar cu numar din continuarea fisierului
        push dword numar
        push dword format_citire
        push dword [file_descriptor]
        call [fscanf]
        add esp, 3*4

        ; verific daca s-a ajuns la EOF sau daca nu se mai poate citi nimic
        cmp eax, 1
        jne Iesire

        mov eax, [numar]
        cmp eax, [maxim] ; verific daca am gasit un numar mai mare decat maxim
        jle NuMaxim

        mov [maxim], eax

    NuMaxim:
        jmp Citire

    Iesire:
        ; dam append la maxim

        ; mai intai inchidem fisierul deschis cu modul de citire doar
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

        ; deschid fisierul cu modul append
        push dword file_mode_append
        push dword file_name
        call [fopen]
        add esp, 2*4

        ; verific daca s-a deschis corect
        cmp eax, 0
        je final

        mov [file_descriptor], eax

        ; dau append la maxim
        push dword [maxim]
        push dword format_afisare
        push dword [file_descriptor]
        call [fprintf]
        add esp, 2*4

        ; inchid fisierul
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

    final:
	    push dword 0 
	    call [exit] 