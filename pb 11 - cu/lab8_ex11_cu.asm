bits 32
global start

extern exit, fopen, fclose, fprintf, scanf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll

; Se da un nume de fisier (definit in segmentul de date).
; Sa se creeze un fisier cu numele dat, apoi sa se citeasca de la tastatura cuvinte si sa se scrie in fisier cuvintele citite
; pana cand se citeste de la tastatura caracterul '$'.

segment data use32 class=data
    file_name db "ex11.txt", 0
    file_mode db "w", 0

    cuvant resb 256

    format_citire db "%s", 0
    format_afisare db "%s", 10, 0 ; 10 semnifica caract. new line
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
        ; citesc cuvant cu cuvant
        push dword cuvant
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; verific daca am citit doar '$'
        cmp byte [cuvant], 36
        je final ; daca da, ies din eticheta (ma opresc din citire)

        ; afisez cate un cuvant pe o linie
        push dword cuvant
        push dword format_afisare
        push dword [file_descriptor]
        call [fprintf]
        add esp, 3*4

        jmp Citire

    final:
	    push dword 0 
	    call [exit] 