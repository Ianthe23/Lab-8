bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; Se citesc de la tastatura numere (in baza 10) pana cand se introduce cifra 0. 
; Determinaţi şi afişaţi cel mai mare număr dintre cele citite.

segment data use32 class=data
    numar dd 0
    maxim dd 0

    format_citire db "%d", 0
    format_afisare db "maxim = %d", 0

segment code use32 class=code
    start:
        ; citesc de la tastatura primul numar din sir
        push dword numar
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; verific sa nu fie 0
        mov edx, [numar]
        cmp edx, 0
        je Final

        ; il luam ca maxim pe primul numar citit
        mov [maxim], edx


    Repeta:
        ; citesc numar cu numar de la tastatura din sirul ramas
        push dword numar
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; verific sa nu fie 0
        mov edx, [numar]
        cmp edx, 0
        je Final

        ; compar numarul curent cu maximul
        mov edx, [maxim]
        cmp edx, [numar]

        jge NuMaxim ; daca maxim - numar >= 0, inseamna ca nu am gasit alt maxim

        ; altfel modificam maximul
        mov edx, [numar] 
        mov [maxim], edx

        NuMaxim:
            jmp Repeta
    
    Final:  
        ; afisez maximul pe consola
        push dword [maxim]
        push dword format_afisare
        call [printf]
        add esp, 2*4

	    push dword 0 
	    call [exit] 