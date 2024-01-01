bits 32
global start

extern exit, fopen, fclose, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll

; Se dau un nume de fisier si un text (definite in segmentul de date).
; Textul contine litere mici, litere mari, cifre si caractere speciale. 
; Sa se inlocuiasca toate spatiile din textul dat cu caracterul 'S'.
; Sa se creeze un fisier cu numele dat si sa se scrie textul obtinut prin inlocuire in fisier.

segment data use32 class=data
    file_name db "ex25.txt", 0
    file_mode db "w", 0

    text db "Ana, are mere!", 0
    l equ $-text

    file_descriptor dd -1

segment code use32 class=code
    start:

        ; deschidem fisierul
        push dword file_mode
        push dword file_name
        call [fopen]
        add esp, 2*4

        ; verific daca s-a deschis corect fisierul
        cmp eax, 0
        je final

        mov [file_descriptor], eax

        mov ecx, l ; ECX <- lungimea textului
        mov esi, 0 ; index-ul textului
        jecxz final ; verific daca nu-i vid textul

        Repeta:
            ; verific daca, caracterul curent este spatiu sau nu
            mov al, [text + esi]
            cmp al, 32
            jne NuSpatiu

            ; daca e spatiu, il inlocuiesc cu 'S'
            mov ah, 'S'
            mov [text + esi], ah

        NuSpatiu:
            inc esi ; altfel doar cresc index-ul
            loop Repeta

        Sfarsit:
            ; scriem in fisier textul modificat
            push dword text
            push dword [file_descriptor]
            call [fprintf]
            add esp, 2*4

            ; inchidem fisierul
            push dword [file_descriptor]
            call [fclose]
            add esp, 4

    final:
	    push dword 0 
	    call [exit] 