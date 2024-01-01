bits 32
global start

extern exit, fopen, fclose, fscanf, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import printf msvcrt.dll

; Se da un fisier text. Sa se citeasca continutul fisierului, sa se contorizeze numarul de cifre pare
; si sa se afiseze aceasta valoare. Numele fisierului text este definit in segmentul de date.

segment data use32 class=data
    file_name db "ex3.txt", 0
    file_mode db "r", 0

    caracter dd 0
    contor_pare dd 0

    format_citire db "%c", 0
    format_afisare db "numar cifre pare = %d", 0
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

        mov al, byte [caracter] ; pun in AL caracterul citit
        mov bl, 48

        cmp al, bl  ; compar caracterul cu '0' 
        jb NuCifra  ; daca e mai mic decat '0', inseamna ca nu-i cifra

        mov bl, 57 

        cmp al, bl  ; compar caracterul cu '9'
        ja NuCifra  ; daca e mai mare decat '9', inseamna ca nu-i cifra

        shr al, 1  ; daca e mai mare sau egal decat '0' si mai mic sau egal decat '9', atunci il shiftez cu o pozitie spre dreapta
        ; ca sa aflu daca e cifra para sau nu
        jc NuCifra  ; daca in CF e valoarea 1, inseamna ca-i cifra impara iar daca e valoarea 0, atunci e cifra para

        add dword [contor_pare], 1 ; daca e cifra para, cresc contorul


    NuCifra:
        jmp Citire

    Iesire:
        ; afisam contorul de cifre pare
        push dword [contor_pare]
        push dword format_afisare
        call [printf]
        add esp, 2*4

        ; inchid fisierul
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
    
    final:
	    push dword 0 
	    call [exit] 