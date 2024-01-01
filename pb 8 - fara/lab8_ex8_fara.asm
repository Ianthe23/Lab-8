bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; Se da un numar natural a (a: dword, definit in segmentul de date).
; Sa se citeasca un numar natural b si sa se calculeze: a + a/b. Sa se afiseze rezultatul operatiei.
; Valorile vor fi afisate in format decimal (baza 10) cu semn.

segment data use32 class=data
    a dd 36
    b dd 0

    rezultat dd 0

    format_citire db "%d", 0
    format_afisare db "a + a/b = %d", 0

segment code use32 class=code
    start:
        ; citesc variabila b
        push dword b
        push format_citire
        call [scanf]
        add esp, 2*4

        ; pun pe EDX:EAX variabila a si o impart la b
        mov eax, [a]
        mov edx, 0
        mov ebx, [b]
        idiv ebx ; => EAX <- catul, EDX <- restul

        mov [rezultat], eax ; pun catul in rezultat = a/b
        mov eax, [a]
        add [rezultat], eax ; adun variabila a in rezultat = a + a/b

        ; afisez rezultatul dupa format
        push dword [rezultat]
        push dword format_afisare
        call [printf]
        add esp, 2*4

	    push dword 0 
	    call [exit] 