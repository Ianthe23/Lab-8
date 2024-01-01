bits 32
global start

extern exit, fopen, fclose, fscanf, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import printf msvcrt.dll

; Se da un fisier text. Sa se citeasca continutul fisierului,
; sa se contorizeze numarul de litere 'y' si 'z' si sa se afiseze aceaste valori.
; Numele fisierului text este definit in segmentul de date.

segment data use32 class=data
    file_name db "ex16.txt", 0
    file_mode db "r", 0

    caracter resd 1
    contor_y dd 0
    contor_z dd 0

    format_citire db "%c", 0
    format_afisare db "contor y = %d, contor z = %d", 0
    file_descriptor dd -1

segment code use32 class=code
    start:

        ; deschid fisierul
        push dword file_mode
        push dword file_name
        call [fopen]
        add esp, 2*4

        ; verific daca s-a deschis corect
        cmp eax, 0
        je final

        mov [file_descriptor], eax

    Citire:
        ; citesc caracter cu caracter
        push dword caracter
        push dword format_citire
        push dword [file_descriptor]
        call [fscanf]
        add esp, 3*4

        ; verific daca am ajuns la EOF sau daca nu se mai poate citi nimic
        cmp eax, 1
        jne Iesire

        ; verific daca acel caracter e 'y'
        mov al, byte [caracter]
        cmp al, 121
        jne VerifZ

        ; cresc contorul daca e 'y'
        add dword [contor_y], 1
        jmp Citire

    VerifZ:
        ; verific daca acel caracter e de fapt 'z'
        cmp al, 122
        jne Jump ; daca nu e doar citesc in continuare 
        add dword [contor_z], 1 ; daca e 'z', cresc contorul

    Jump:
        jmp Citire

    Iesire:
        ; afisez contoarele dupa format
        push dword [contor_z]
        push dword [contor_y]
        push dword format_afisare
        call [printf]
        add esp, 3*4

        ; inchid fisierul
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

    final:
	    push dword 0 
	    call [exit] 